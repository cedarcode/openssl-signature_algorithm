# frozen_string_literal: true

require "openssl/signature_algorithm/ecdsa"

RSpec.describe "OpenSSL::SignatureAlgorithm::ECDSA" do
  let(:to_be_signed) { "to-be-signed" }
  let(:signature) do
    signing_key
    signer_algorithm.sign(to_be_signed)
  end
  let(:algorithm_parameters) { {} }
  let(:signer_algorithm) { OpenSSL::SignatureAlgorithm::ECDSA.new(**algorithm_parameters) }
  let(:signing_key) { signer_algorithm.generate_signing_key }
  let(:verifier_algorithm) { OpenSSL::SignatureAlgorithm::ECDSA.new(**algorithm_parameters) }

  context "default curve" do
    context "default hash_function" do
      it "picks P-256 and SHA256" do
        expect(signer_algorithm.curve).to eq("prime256v1")
        expect(signer_algorithm.hash_function).to eq("SHA256")
      end

      it "works" do
        # Signer sends verify key to Verifier
        verify_key_string = signing_key.verify_key.serialize

        # Verifier
        verifier_algorithm.verify_key = OpenSSL::SignatureAlgorithm::ECDSA::VerifyKey.deserialize(verify_key_string)
        expect(verifier_algorithm.verify(signature, to_be_signed)).to be_truthy
      end
    end

    context "SHA-256" do
      let(:algorithm_parameters) { { hash_function: "SHA256" } }

      it "picks P-256 curve" do
        expect(signer_algorithm.curve).to eq("prime256v1")
      end

      it "works" do
        # Signer sends verify key to Verifier
        verify_key_string = signing_key.verify_key.serialize

        # Verifier
        verifier_algorithm.verify_key = OpenSSL::SignatureAlgorithm::ECDSA::VerifyKey.deserialize(verify_key_string)
        expect(verifier_algorithm.verify(signature, to_be_signed)).to be_truthy
      end
    end

    context "SHA-384" do
      let(:algorithm_parameters) { { hash_function: "SHA384" } }

      it "picks P-384 curve" do
        expect(signer_algorithm.curve).to eq("secp384r1")
      end

      it "works" do
        # Signer sends verify key to Verifier
        verify_key_string = signing_key.verify_key.serialize

        # Verifier
        verifier_algorithm.verify_key = OpenSSL::SignatureAlgorithm::ECDSA::VerifyKey.deserialize(verify_key_string)
        expect(verifier_algorithm.verify(signature, to_be_signed)).to be_truthy
      end
    end

    context "SHA-512" do
      let(:algorithm_parameters) { { hash_function: "SHA512" } }

      it "picks P-521 curve" do
        expect(signer_algorithm.curve).to eq("secp521r1")
      end

      it "works" do
        # Signer sends verify key to Verifier
        verify_key_string = signing_key.verify_key.serialize

        # Verifier
        verifier_algorithm.verify_key = OpenSSL::SignatureAlgorithm::ECDSA::VerifyKey.deserialize(verify_key_string)
        expect(verifier_algorithm.verify(signature, to_be_signed)).to be_truthy
      end
    end
  end

  context "P-256 curve" do
    let(:algorithm_parameters) { { curve: "prime256v1" } }

    it "picks SHA256" do
      expect(signer_algorithm.hash_function).to eq("SHA256")
    end

    it "works" do
      # Signer sends verify key to Verifier
      verify_key_string = signing_key.verify_key.serialize

      # Verifier
      verifier_algorithm.verify_key = OpenSSL::SignatureAlgorithm::ECDSA::VerifyKey.deserialize(verify_key_string)
      expect(verifier_algorithm.verify(signature, to_be_signed)).to be_truthy
    end
  end

  context "P-384 curve" do
    let(:algorithm_parameters) { { curve: "secp384r1" } }

    it "picks SHA384" do
      expect(signer_algorithm.hash_function).to eq("SHA384")
    end

    it "works" do
      # Signer sends verify key to Verifier
      verify_key_string = signing_key.verify_key.serialize

      # Verifier
      verifier_algorithm.verify_key = OpenSSL::SignatureAlgorithm::ECDSA::VerifyKey.deserialize(verify_key_string)
      expect(verifier_algorithm.verify(signature, to_be_signed)).to be_truthy
    end
  end

  context "P-521 curve" do
    let(:algorithm_parameters) { { curve: "secp521r1" } }

    it "picks SHA512" do
      expect(signer_algorithm.hash_function).to eq("SHA512")
    end

    it "works" do
      # Signer sends verify key to Verifier
      verify_key_string = signing_key.verify_key.serialize

      # Verifier
      verifier_algorithm.verify_key = OpenSSL::SignatureAlgorithm::ECDSA::VerifyKey.deserialize(verify_key_string)
      expect(verifier_algorithm.verify(signature, to_be_signed)).to be_truthy
    end
  end

  context "secp256k1 curve" do
    let(:algorithm_parameters) { { curve: "secp256k1" } }

    it "picks SHA256" do
      expect(signer_algorithm.hash_function).to eq("SHA256")
    end

    it "works" do
      # Signer sends verify key to Verifier
      verify_key_string = signing_key.verify_key.serialize

      # Verifier
      verifier_algorithm.verify_key = OpenSSL::SignatureAlgorithm::ECDSA::VerifyKey.deserialize(verify_key_string)
      expect(verifier_algorithm.verify(signature, to_be_signed)).to be_truthy
    end
  end

  context "when signer and verifier algorithms are different" do
    let(:signer_algorithm) { OpenSSL::SignatureAlgorithm::ECDSA.new(curve: "secp384r1") }
    let(:verifier_algorithm) { OpenSSL::SignatureAlgorithm::ECDSA.new(curve: "secp521r1") }

    it "fail when setting the verify key" do
      # Signer sends verify key to Verifier
      verify_key_string = signing_key.verify_key.serialize

      expect {
        # Verifier
        verifier_algorithm.verify_key = OpenSSL::SignatureAlgorithm::ECDSA::VerifyKey.deserialize(verify_key_string)
      }.to raise_error(OpenSSL::SignatureAlgorithm::VerifyKeyError, "Incompatible verify key for algorithm")
    end
  end

  it "works for raw (non DER) signature" do
    # Signer
    raw_signature = OpenSSL::ASN1.decode(signature).value.map { |v| v.value.to_s(2) }.join

    # Signer sends verify key to Verifier
    verify_key_string = signing_key.verify_key.serialize

    # Verifier
    verifier_algorithm.verify_key = OpenSSL::SignatureAlgorithm::ECDSA::VerifyKey.deserialize(verify_key_string)
    expect(verifier_algorithm.verify(raw_signature, to_be_signed)).to be_truthy
  end
end
