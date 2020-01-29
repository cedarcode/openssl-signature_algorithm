# frozen_string_literal: true

require "openssl"
require "openssl/signature_algorithm/base"

module OpenSSL
  module SignatureAlgorithm
    class RSAPSS < Base
      class SigningKey < OpenSSL::PKey::RSA
        def verify_key
          public_key
        end
      end

      DEFAULT_KEY_SIZE = 2048

      def generate_signing_key(size: DEFAULT_KEY_SIZE)
        @signing_key = SigningKey.new(size)
      end

      def sign(data)
        signing_key.sign_pss(hash_function, data, salt_length: :max, mgf1_hash: mgf1_hash_function)
      end

      def verify(signature, verification_data)
        verify_key.verify_pss(
          hash_function,
          signature,
          verification_data,
          salt_length: :auto,
          mgf1_hash: mgf1_hash_function
        ) || raise(OpenSSL::SignatureAlgorithm::Error, "Signature verification failed")
      end

      def mgf1_hash_function
        hash_function
      end
    end
  end
end
