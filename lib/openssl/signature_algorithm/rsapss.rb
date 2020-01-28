# frozen_string_literal: true

require "openssl"

module OpenSSL
  module SignatureAlgorithm
    class RSAPSS
      class SigningKey < OpenSSL::PKey::RSA
        def verify_key
          public_key
        end
      end

      DEFAULT_KEY_SIZE = 2048

      attr_reader :digest_length, :signing_key
      attr_accessor :verify_key

      def initialize(digest_length)
        @digest_length = digest_length
      end

      def generate_signing_key(size: DEFAULT_KEY_SIZE)
        @signing_key = SigningKey.new(size)
      end

      def sign(data)
        signing_key.sign_pss(hash_function, data, salt_length: salt_length, mgf1_hash: mgf1_hash_function)
      end

      def hash_function
        OpenSSL::Digest.new("sha#{digest_length}")
      end

      def verify(signature, verification_data)
        verify_key.verify_pss(
          hash_function,
          signature,
          verification_data,
          salt_length: salt_length,
          mgf1_hash: mgf1_hash_function
        ) || raise("Signature verification failed")
      end

      def salt_length
        :digest
      end

      def mgf1_hash_function
        hash_function
      end
    end
  end
end
