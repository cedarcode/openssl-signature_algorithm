RSpec.describe OpenSSL::SignatureAlgorithm do
  it "has a version number" do
    expect(OpenSSL::SignatureAlgorithm::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
