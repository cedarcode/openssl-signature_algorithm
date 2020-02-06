# frozen_string_literal: true

require "openssl/signature_algorithm/ecdsa"

RSpec.describe "OpenSSL::SignatureAlgorithm::ECDSA" do
  before do
    if !OpenSSL::PKey::EC.instance_methods.include?(:private?)
      skip "openssl gem v#{OpenSSL::VERSION} doesn't support ECDSA"
    end
  end

  it "works for 256" do
    to_be_signed = "to-be-signed"

    # Signer
    algorithm = OpenSSL::SignatureAlgorithm::ECDSA.new("256")
    signing_key = algorithm.generate_signing_key
    signature = algorithm.sign(to_be_signed)

    # Signer sends verify key to Verifier
    verify_key_string = signing_key.verify_key.serialize

    # Verifier
    verify_key = OpenSSL::SignatureAlgorithm::ECDSA::VerifyKey.deserialize(verify_key_string)
    algorithm = OpenSSL::SignatureAlgorithm::ECDSA.new("256")
    algorithm.verify_key = verify_key
    expect(algorithm.verify(signature, to_be_signed)).to be_truthy
  end

  it "works for 384" do
    to_be_signed = "to-be-signed"

    # Signer
    algorithm = OpenSSL::SignatureAlgorithm::ECDSA.new("384")
    signing_key = algorithm.generate_signing_key
    signature = algorithm.sign(to_be_signed)

    # Signer sends verify key to Verifier
    verify_key_string = signing_key.verify_key.serialize

    # Verifier
    verify_key = OpenSSL::SignatureAlgorithm::ECDSA::VerifyKey.deserialize(verify_key_string)
    algorithm = OpenSSL::SignatureAlgorithm::ECDSA.new("384")
    algorithm.verify_key = verify_key
    expect(algorithm.verify(signature, to_be_signed)).to be_truthy
  end

  it "works for 512" do
    to_be_signed = "to-be-signed"

    # Signer
    algorithm = OpenSSL::SignatureAlgorithm::ECDSA.new("512")
    signing_key = algorithm.generate_signing_key
    signature = algorithm.sign(to_be_signed)

    # Signer sends verify key to Verifier
    verify_key_string = signing_key.verify_key.serialize

    # Verifier
    verify_key = OpenSSL::SignatureAlgorithm::ECDSA::VerifyKey.deserialize(verify_key_string)
    algorithm = OpenSSL::SignatureAlgorithm::ECDSA.new("512")
    algorithm.verify_key = verify_key
    expect(algorithm.verify(signature, to_be_signed)).to be_truthy
  end

  it "works for raw (non DER) signature" do
    to_be_signed = "to-be-signed"

    # Signer
    algorithm = OpenSSL::SignatureAlgorithm::ECDSA.new("256")
    signing_key = algorithm.generate_signing_key
    signature = algorithm.sign(to_be_signed)

    raw_signature = OpenSSL::ASN1.decode(signature).value.map { |v| v.value.to_s(2) }.join

    # Signer sends verify key to Verifier
    verify_key = signing_key.verify_key

    # Verifier
    algorithm = OpenSSL::SignatureAlgorithm::ECDSA.new("256")
    algorithm.verify_key = verify_key
    expect(algorithm.verify(raw_signature, to_be_signed)).to be_truthy
  end
end
