require "openssl"
require "fileutils"
require "csr/version"

class CSR
  attr_reader :bits, :country, :state, :city, :department, :organization,
              :common_name, :email, :passphrase, :cipher, :digest

  def self.verify?(request_key, private_key, passphrase = nil)
    private_key = OpenSSL::PKey::RSA.new(private_key, passphrase)
    csr = OpenSSL::X509::Request.new(request_key)
    csr.public_key = private_key.public_key
    csr.verify(csr.public_key)
  end

  def initialize(country:, state:, city:, department:, organization:,
                  common_name:, email:, bits: 4096, private_key: nil,
                  passphrase: nil, cipher: nil, digest: nil)

    cipher        ||= OpenSSL::Cipher.new("des-ede3-cbc")
    digest        ||= OpenSSL::Digest::SHA256.new
    @country      = country
    @state        = state
    @city         = city
    @department   = department
    @organization = organization
    @common_name  = common_name
    @email        = email
    @bits         = bits
    @passphrase   = passphrase
    @private_key  = OpenSSL::PKey::RSA.new(private_key) if private_key
    @cipher       = cipher
    @digest       = digest
  end

  def private_key
    @private_key ||= OpenSSL::PKey::RSA.new(bits)
  end

  def request
    @request ||= OpenSSL::X509::Request.new.tap do |request|
      request.version = 0
      request.subject = OpenSSL::X509::Name.new([
        ["C",             country,      OpenSSL::ASN1::PRINTABLESTRING],
        ["ST",            state,        OpenSSL::ASN1::PRINTABLESTRING],
        ["L",             city,         OpenSSL::ASN1::PRINTABLESTRING],
        ["O",             organization, OpenSSL::ASN1::UTF8STRING],
        ["OU",            department,   OpenSSL::ASN1::UTF8STRING],
        ["CN",            common_name,  OpenSSL::ASN1::UTF8STRING],
        ["emailAddress",  email,        OpenSSL::ASN1::UTF8STRING]
      ])

      request.public_key = private_key.public_key
      request.sign(private_key, digest)
    end
  end

  def save_to(directory, name)
    FileUtils.mkdir_p(directory)
    base_path = File.join(directory, name)
    save_private_key_to("#{base_path}.key")
    save_csr_to("#{base_path}.csr")
    true
  end

  def private_key_pem
    args = []

    if passphrase
      args << cipher
      args << passphrase
    end

    private_key.to_pem(*args)
  end

  def pem
    request.to_pem
  end

  private

  def save_private_key_to(path)
    File.open(path, "w") do |file|
      file << private_key_pem
    end
  end

  def save_csr_to(path)
    File.open(path, "w") do |file|
      file << pem
    end
  end
end
