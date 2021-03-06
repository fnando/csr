# frozen_string_literal: true

require "test_helper"

class CSRTest < Minitest::Test
  setup do
    FileUtils.rm_rf("tmp")
    FileUtils.mkdir_p("tmp")
  end

  test "generates CSR with default params" do
    csr = create_csr

    assert_equal "sha256WithRSAEncryption", csr.request.signature_algorithm
    assert_equal 4096, csr.bits
  end

  test "uses custom digest" do
    csr = create_csr(digest: OpenSSL::Digest.new("SHA1"))

    assert_equal "sha1WithRSAEncryption", csr.request.signature_algorithm
  end

  test "generates CSR with custom params" do
    csr = create_csr(bits: 2048)
    assert_equal 2048, csr.bits
  end

  test "sets country" do
    csr = create_csr(country: "BR")
    assert_equal "BR", csr.country
  end

  test "sets state" do
    csr = create_csr(state: "SP")
    assert_equal "SP", csr.state
  end

  test "sets city" do
    csr = create_csr(city: "São Paulo")
    assert_equal "São Paulo", csr.city
  end

  test "sets department" do
    csr = create_csr(department: "Tech")
    assert_equal "Tech", csr.department
  end

  test "sets organization" do
    csr = create_csr(organization: "ACME Inc.")
    assert_equal "ACME Inc.", csr.organization
  end

  test "sets FQDN" do
    csr = create_csr(common_name: "*.example.com")
    assert_equal "*.example.com", csr.common_name
  end

  test "sets email" do
    csr = create_csr(email: "admin@example.com")
    assert_equal "admin@example.com", csr.email
  end

  test "saves private key" do
    csr = create_csr
    csr.save_to("./tmp", "server")

    assert File.file?("./tmp/server.key")
  end

  test "saves csr" do
    csr = create_csr
    csr.save_to("./tmp", "server")

    assert File.file?("./tmp/server.csr")
  end

  test "verifies CSR" do
    csr = create_csr
    csr.save_to("./tmp", "server")
    csr_content = File.read("./tmp/server.csr")
    private_key_content = File.read("./tmp/server.key")

    assert CSR.verify?(csr_content, private_key_content)
  end

  test "verifies CSR with passphrase" do
    passphrase = SecureRandom.hex(5)
    csr = create_csr(passphrase: passphrase)
    csr.save_to("./tmp", "server")
    csr_content = File.read("./tmp/server.csr")
    private_key_content = File.read("./tmp/server.key")

    assert CSR.verify?(csr_content, private_key_content, passphrase)
  end

  test "verifies CSR with passphrase (generated by CLI)" do
    csr_content = File.read("./test/fixtures/server.csr")
    private_key_content = File.read("./test/fixtures/server.key.orig")

    assert CSR.verify?(csr_content, private_key_content, "test")
  end

  test "verifies CSR without passphrase (generated by CLI)" do
    csr_content = File.read("./test/fixtures/server.csr")
    private_key_content = File.read("./test/fixtures/server.key")

    assert CSR.verify?(csr_content, private_key_content)
  end

  test "loads CSR" do
    csr = create_csr
    csr.save_to("./tmp", "server")

    parsed_csr = CSR.load(
      File.read("./tmp/server.csr"),
      private_key: File.read("./tmp/server.key"),
      bits: 2048,
      passphrase: "secret",
      cipher: OpenSSL::Cipher.new("des-ede3-cbc")
    )

    assert_equal "US", parsed_csr.country
    assert_equal "CA", parsed_csr.state
    assert_equal "San Francisco", parsed_csr.city
    assert_equal "Web", parsed_csr.department
    assert_equal "Example Inc.", parsed_csr.organization
    assert_equal "example.com", parsed_csr.common_name
    assert_equal "john@example.com", parsed_csr.email
    assert_equal "secret", parsed_csr.passphrase
    assert_equal 2048, parsed_csr.bits
  end

  def create_csr(**kwargs)
    kwargs = {
      country: "US",
      state: "CA",
      city: "San Francisco",
      department: "Web",
      organization: "Example Inc.",
      common_name: "example.com",
      email: "john@example.com"
    }.merge(kwargs)

    CSR.new(**kwargs)
  end
end
