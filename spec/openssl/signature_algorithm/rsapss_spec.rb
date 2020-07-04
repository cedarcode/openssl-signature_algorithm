# frozen_string_literal: true

require "openssl/signature_algorithm/rsapss"

RSpec.describe "OpenSSL::SignatureAlgorithm::RSAPSS" do
  let(:to_be_signed) { "to-be-signed" }
  let(:algorithm_parameters) { {} }
  let(:signer_algorithm) { OpenSSL::SignatureAlgorithm::RSAPSS.new(**algorithm_parameters) }
  let(:signing_key) { signer_algorithm.generate_signing_key }
  let(:verifier_algorithm) { OpenSSL::SignatureAlgorithm::RSAPSS.new(**algorithm_parameters) }

  let(:signature) do
    signing_key
    signer_algorithm.sign(to_be_signed)
  end

  before do
    if !OpenSSL::PKey::RSA.instance_methods.include?(:verify_pss)
      skip "openssl gem v#{OpenSSL::VERSION} doesn't support RSA-PSS"
    end
  end

  context "without arguments" do
    it "picks SHA256" do
      expect(signer_algorithm.hash_function).to eq("SHA256")
    end

    it "works" do
      # Signer sends verify key to Verifier
      verify_key_string = signing_key.verify_key.serialize

      # Verifier
      verifier_algorithm.verify_key = OpenSSL::SignatureAlgorithm::RSAPSS::VerifyKey.deserialize(verify_key_string)
      expect(verifier_algorithm.verify(signature, to_be_signed)).to be_truthy
    end
  end

  context "with SHA384" do
    let(:algorithm_parameters) { { hash_function: "SHA384" } }

    it "works" do
      # Signer sends verify key to Verifier
      verify_key_string = signing_key.verify_key.serialize

      # Verifier
      verifier_algorithm.verify_key = OpenSSL::SignatureAlgorithm::RSAPSS::VerifyKey.deserialize(verify_key_string)
      expect(verifier_algorithm.verify(signature, to_be_signed)).to be_truthy
    end
  end

  context "with SHA512" do
    let(:algorithm_parameters) { { hash_function: "SHA512" } }

    it "works" do
      # Signer sends verify key to Verifier
      verify_key_string = signing_key.verify_key.serialize

      # Verifier
      verifier_algorithm.verify_key = OpenSSL::SignatureAlgorithm::RSAPSS::VerifyKey.deserialize(verify_key_string)
      expect(verifier_algorithm.verify(signature, to_be_signed)).to be_truthy
    end
  end

  context "when signer and verifier algorithms are different" do
    let(:signer_algorithm) { OpenSSL::SignatureAlgorithm::RSAPSS.new(hash_function: "SHA256") }
    let(:verifier_algorithm) { OpenSSL::SignatureAlgorithm::RSAPSS.new(hash_function: "SHA384") }

    it "fail when setting the verify key" do
      # Signer sends verify key to Verifier
      verify_key_string = signing_key.verify_key.serialize

      # Verifier
      verifier_algorithm.verify_key = OpenSSL::SignatureAlgorithm::RSAPSS::VerifyKey.deserialize(verify_key_string)
      expect {
        verifier_algorithm.verify(signature, to_be_signed)
      }.to raise_error(OpenSSL::SignatureAlgorithm::SignatureVerificationError, "Signature verification failed")
    end
  end
end
