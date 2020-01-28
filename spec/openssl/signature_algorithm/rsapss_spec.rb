# frozen_string_literal: true

require "openssl/signature_algorithm/rsapss"

RSpec.describe "OpenSSL::SignatureAlgorithm::RSAPSS" do
  it "works for 256" do
    to_be_signed = "to-be-signed"

    # Signer
    algorithm = OpenSSL::SignatureAlgorithm::RSAPSS.new("256")
    signing_key = algorithm.generate_signing_key
    signature = algorithm.sign(to_be_signed)

    # Signer sends verify key to Verifier
    verify_key = signing_key.verify_key

    # Verifier
    algorithm = OpenSSL::SignatureAlgorithm::RSAPSS.new("256")
    algorithm.verify_key = verify_key
    algorithm.verify(signature, to_be_signed)
  end

  it "works for 384" do
    to_be_signed = "to-be-signed"

    # Signer
    algorithm = OpenSSL::SignatureAlgorithm::RSAPSS.new("384")
    signing_key = algorithm.generate_signing_key
    signature = algorithm.sign(to_be_signed)

    # Signer sends verify key to Verifier
    verify_key = signing_key.verify_key

    # Verifier
    algorithm = OpenSSL::SignatureAlgorithm::RSAPSS.new("384")
    algorithm.verify_key = verify_key
    algorithm.verify(signature, to_be_signed)
  end

  it "works for 512" do
    to_be_signed = "to-be-signed"

    # Signer
    algorithm = OpenSSL::SignatureAlgorithm::RSAPSS.new("512")
    signing_key = algorithm.generate_signing_key
    signature = algorithm.sign(to_be_signed)

    # Signer sends verify key to Verifier
    verify_key = signing_key.verify_key

    # Verifier
    algorithm = OpenSSL::SignatureAlgorithm::RSAPSS.new("512")
    algorithm.verify_key = verify_key
    algorithm.verify(signature, to_be_signed)
  end
end
