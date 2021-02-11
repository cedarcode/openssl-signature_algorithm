# frozen_string_literal: true

begin
  gem "ed25519", ">= 1.0.0"
  require "ed25519"
rescue LoadError
  warn "OpenSSL::SignatureAlgorithm::EdDSA requires the ed25519 gem, version 1.0 or higher. "\
        "Please add it to your Gemfile: `gem \"ed25519\", \"~> 1.0\"`"
  raise
end

require "openssl/signature_algorithm/base"

module OpenSSL
  module SignatureAlgorithm
    class EdDSA < Base
      class SigningKey < ::Ed25519::SigningKey
        def verify_key
          VerifyKey.new(keypair[32, 32])
        end
      end

      class VerifyKey < ::Ed25519::VerifyKey
        def self.deserialize(key_bytes)
          new(key_bytes)
        end

        def serialize
          to_bytes
        end
      end

      def generate_signing_key
        @signing_key = SigningKey.generate
      end

      def sign(data)
        signing_key.sign(data)
      end

      def verify(signature, verification_data)
        verify_key.verify(signature, verification_data)
      rescue ::Ed25519::VerifyError
        raise(OpenSSL::SignatureAlgorithm::SignatureVerificationError, "Signature verification failed")
      end
    end
  end
end
