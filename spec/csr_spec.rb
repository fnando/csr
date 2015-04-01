require 'minitest_helper'

describe CSR do
  before do
    FileUtils.rm_rf('tmp')
    FileUtils.mkdir_p('tmp')
  end

  it 'generates CSR with default params' do
    csr = create_csr

    csr.request.signature_algorithm.must_equal('sha256WithRSAEncryption')
    csr.bits.must_equal(4096)
  end

  it 'uses custom digest' do
    csr = create_csr(digest: OpenSSL::Digest::SHA1.new)

    csr.request.signature_algorithm.must_equal('sha1WithRSAEncryption')
  end

  it 'generates CSR with custom params' do
    csr = create_csr(bits: 2048)
    csr.bits.must_equal(2048)
  end

  it 'sets country' do
    csr = create_csr(country: 'BR')
    csr.country.must_equal('BR')
  end

  it 'sets state' do
    csr = create_csr(state: 'SP')
    csr.state.must_equal('SP')
  end

  it 'sets city' do
    csr = create_csr(city: 'São Paulo')
    csr.city.must_equal('São Paulo')
  end

  it 'sets department' do
    csr = create_csr(department: 'Tech')
    csr.department.must_equal('Tech')
  end

  it 'sets organization' do
    csr = create_csr(organization: 'ACME Inc.')
    csr.organization.must_equal('ACME Inc.')
  end

  it 'sets FQDN' do
    csr = create_csr(common_name: '*.example.com')
    csr.common_name.must_equal('*.example.com')
  end

  it 'sets email' do
    csr = create_csr(email: 'admin@example.com')
    csr.email.must_equal('admin@example.com')
  end

  it 'saves private key' do
    csr = create_csr
    csr.save_to('./tmp', 'server')

    assert File.file?('./tmp/server.key')
  end

  it 'saves csr' do
    csr = create_csr
    csr.save_to('./tmp', 'server')

    assert File.file?('./tmp/server.csr')
  end

  it 'verifies CSR' do
    csr = create_csr
    csr.save_to('./tmp', 'server')
    csr_content = File.read('./tmp/server.csr')
    private_key_content = File.read('./tmp/server.key')

    assert CSR.verify?(csr_content, private_key_content)
  end

  it 'verifies CSR with passphrase' do
    passphrase = SecureRandom.hex(5)
    csr = create_csr(passphrase: passphrase)
    csr.save_to('./tmp', 'server')
    csr_content = File.read('./tmp/server.csr')
    private_key_content = File.read('./tmp/server.key')

    assert CSR.verify?(csr_content, private_key_content, passphrase)
  end

  it 'verifies CSR with passphrase (generated by CLI)' do
    csr_content = File.read('./spec/fixtures/server.csr')
    private_key_content = File.read('./spec/fixtures/server.key.orig')

    assert CSR.verify?(csr_content, private_key_content, 'test')
  end

  it 'verifies CSR without passphrase (generated by CLI)' do
    csr_content = File.read('./spec/fixtures/server.csr')
    private_key_content = File.read('./spec/fixtures/server.key')

    assert CSR.verify?(csr_content, private_key_content)
  end

  def create_csr(**kwargs)
    kwargs = {
      country: 'US',
      state: 'CA',
      city: 'San Francisco',
      department: 'Web',
      organization: 'Example Inc.',
      common_name: 'example.com',
      email: 'john@example.com'
    }.merge(kwargs)

    CSR.new(**kwargs)
  end
end
