# frozen_string_literal: true

require "openssl/signature_algorithm/rsapss"

RSpec.describe "OpenSSL::SignatureAlgorithm::RSAPSS" do
  before do
    if !OpenSSL::PKey::RSA.instance_methods.include?(:verify_pss)
      skip "openssl gem v#{OpenSSL::VERSION} doesn't support RSA-PSS"
    end
  end

  it "works for 256" do
    to_be_signed = "to-be-signed"

    # Signer
    algorithm = OpenSSL::SignatureAlgorithm::RSAPSS.new("256")
    signing_key = algorithm.generate_signing_key
    signature = algorithm.sign(to_be_signed)

    # Signer sends verify key to Verifier
    verify_key_string = signing_key.verify_key.serialize

    # Verifier
    verify_key = OpenSSL::SignatureAlgorithm::RSAPSS::VerifyKey.deserialize(verify_key_string)
    algorithm = OpenSSL::SignatureAlgorithm::RSAPSS.new("256")
    algorithm.verify_key = verify_key
    expect(algorithm.verify(signature, to_be_signed)).to be_truthy
  end

  it "works for 384" do
    to_be_signed = "to-be-signed"

    # Signer
    algorithm = OpenSSL::SignatureAlgorithm::RSAPSS.new("384")
    signing_key = algorithm.generate_signing_key
    signature = algorithm.sign(to_be_signed)

    # Signer sends verify key to Verifier
    verify_key_string = signing_key.verify_key.serialize

    # Verifier
    verify_key = OpenSSL::SignatureAlgorithm::RSAPSS::VerifyKey.deserialize(verify_key_string)
    algorithm = OpenSSL::SignatureAlgorithm::RSAPSS.new("384")
    algorithm.verify_key = verify_key
    expect(algorithm.verify(signature, to_be_signed)).to be_truthy
  end

  it "works for 512" do
    to_be_signed = "to-be-signed"

    # Signer
    algorithm = OpenSSL::SignatureAlgorithm::RSAPSS.new("512")
    signing_key = algorithm.generate_signing_key
    signature = algorithm.sign(to_be_signed)

    # Signer sends verify key to Verifier
    verify_key_string = signing_key.verify_key.serialize

    # Verifier
    verify_key = OpenSSL::SignatureAlgorithm::RSAPSS::VerifyKey.deserialize(verify_key_string)
    algorithm = OpenSSL::SignatureAlgorithm::RSAPSS.new("512")
    algorithm.verify_key = verify_key
    expect(algorithm.verify(signature, to_be_signed)).to be_truthy
  end
end
