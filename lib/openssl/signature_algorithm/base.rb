# frozen_string_literal: true

require "openssl"
require "openssl/signature_algorithm/error"

module OpenSSL
  module SignatureAlgorithm
    class SignatureVerificationError < Error; end
    class UnsupportedParameterError < Error; end
    class VerifyKeyError < Error; end

    class Base
      attr_reader :signing_key, :verify_key

      def verify_key=(key)
        if compatible_verify_key?(key)
          @verify_key = key
        else
          raise(OpenSSL::SignatureAlgorithm::VerifyKeyError, "Incompatible verify key for algorithm")
        end
      end

      def compatible_verify_key?(verify_key)
        verify_key.respond_to?(:verify)
      end

      def sign(data)
        signing_key.sign(hash_function, data)
      end

      def verify(signature, verification_data)
        formatted_signature =
          if respond_to?(:formatted_signature, true)
            formatted_signature(signature)
          else
            signature
          end

        verify_key.verify(hash_function, formatted_signature, verification_data) ||
          raise(OpenSSL::SignatureAlgorithm::SignatureVerificationError, "Signature verification failed")
      end
    end
  end
end
