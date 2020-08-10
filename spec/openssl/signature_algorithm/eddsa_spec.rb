# frozen_string_literal: true

require "openssl/signature_algorithm/eddsa"

RSpec.describe "OpenSSL::SignatureAlgorithm::EdDSA" do
  let(:to_be_signed) { "to-be-signed" }
  let(:signature) do
    signing_key
    signer_algorithm.sign(to_be_signed)
  end
  let(:signer_algorithm) { OpenSSL::SignatureAlgorithm::EdDSA.new }
  let(:signing_key) { signer_algorithm.generate_signing_key }
  let(:verifier_algorithm) { OpenSSL::SignatureAlgorithm::EdDSA.new }

  context "when everything is in place" do
    it "works" do
      # Signer sends verify key to Verifier
      verify_key_string = signing_key.verify_key.serialize

      # Verifier
      verifier_algorithm.verify_key = OpenSSL::SignatureAlgorithm::EdDSA::VerifyKey.deserialize(verify_key_string)
      expect(verifier_algorithm.verify(signature, to_be_signed)).to be_truthy
    end
  end

  context "when signature is invalid" do
    let(:signature) do
      signing_key
      signature = signer_algorithm.sign(to_be_signed)
      signature[63] = 'X' # Change the last byte to make it incorrect

      signature
    end

    it "raises an error" do
      # Signer sends verify key to Verifier
      verify_key_string = signing_key.verify_key.serialize

      # Verifier
      verifier_algorithm.verify_key = OpenSSL::SignatureAlgorithm::EdDSA::VerifyKey.deserialize(verify_key_string)
      expect { verifier_algorithm.verify(signature, to_be_signed) }
        .to raise_error(OpenSSL::SignatureAlgorithm::SignatureVerificationError)
    end
  end
end
