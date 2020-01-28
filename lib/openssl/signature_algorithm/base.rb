# frozen_string_literal: true

require "openssl"

module OpenSSL
  module SignatureAlgorithm
    class Base
      attr_reader :digest_length, :signing_key
      attr_accessor :verify_key

      def initialize(digest_length)
        @digest_length = digest_length
      end

      def sign(data)
        signing_key.sign(hash_function, data)
      end

      def hash_function
        OpenSSL::Digest.new("sha#{digest_length}")
      end

      def verify(signature, verification_data)
        verify_key.verify(hash_function, signature, verification_data) ||
          raise(OpenSSL::SignatureAlgorithm::Error, "Signature verification failed")
      end
    end
  end
end
