# frozen_string_literal: true

require "openssl/signature_algorithm/rsapkcs1"

RSpec.describe "OpenSSL::SignatureAlgorithm::RSAPKCS1" do
  let(:to_be_signed) { "to-be-signed" }
  let(:algorithm_parameters) { {} }
  let(:signer_algorithm) { OpenSSL::SignatureAlgorithm::RSAPKCS1.new(**algorithm_parameters) }
  let(:signing_key) { signer_algorithm.generate_signing_key }
  let(:verifier_algorithm) { OpenSSL::SignatureAlgorithm::RSAPKCS1.new(**algorithm_parameters) }

  let(:signature) do
    signing_key
    signer_algorithm.sign(to_be_signed)
  end

  context "without arguments" do
    it "picks SHA256" do
      expect(signer_algorithm.hash_function).to eq("SHA256")
    end

    it "works" do
      # Signer sends verify key to Verifier
      verify_key_string = signing_key.verify_key.serialize

      # Verifier
      verifier_algorithm.verify_key = OpenSSL::SignatureAlgorithm::RSAPKCS1::VerifyKey.deserialize(verify_key_string)
      expect(verifier_algorithm.verify(signature, to_be_signed)).to be_truthy
    end
  end

  context "with SHA384" do
    let(:algorithm_parameters) { { hash_function: "SHA384" } }

    it "works" do
      # Signer sends verify key to Verifier
      verify_key_string = signing_key.verify_key.serialize

      # Verifier
      verifier_algorithm.verify_key = OpenSSL::SignatureAlgorithm::RSAPKCS1::VerifyKey.deserialize(verify_key_string)
      expect(verifier_algorithm.verify(signature, to_be_signed)).to be_truthy
    end
  end

  context "with SHA512" do
    let(:algorithm_parameters) { { hash_function: "SHA512" } }

    it "works" do
      # Signer sends verify key to Verifier
      verify_key_string = signing_key.verify_key.serialize

      # Verifier
      verifier_algorithm.verify_key = OpenSSL::SignatureAlgorithm::RSAPKCS1::VerifyKey.deserialize(verify_key_string)
      expect(verifier_algorithm.verify(signature, to_be_signed)).to be_truthy
    end
  end

  context "when signer and verifier algorithms are different" do
    let(:signer_algorithm) { OpenSSL::SignatureAlgorithm::RSAPKCS1.new(hash_function: "SHA256") }
    let(:verifier_algorithm) { OpenSSL::SignatureAlgorithm::RSAPKCS1.new(hash_function: "SHA384") }

    it "fail when setting the verify key" do
      # Signer sends verify key to Verifier
      verify_key_string = signing_key.verify_key.serialize

      # Verifier
      verifier_algorithm.verify_key = OpenSSL::SignatureAlgorithm::RSAPKCS1::VerifyKey.deserialize(verify_key_string)
      expect {
        verifier_algorithm.verify(signature, to_be_signed)
      }.to raise_error(OpenSSL::SignatureAlgorithm::SignatureVerificationError, "Signature verification failed")
    end
  end
end
