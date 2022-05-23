# frozen_string_literal: true

require "delegate"
require "openssl"
require "openssl/signature_algorithm/base"

module OpenSSL
  module SignatureAlgorithm
    class RSA < Base
      class SigningKey < DelegateClass(OpenSSL::PKey::RSA)
        def initialize(*args)
          super(OpenSSL::PKey::RSA.new(*args))
        end

        def verify_key
          VerifyKey.new(public_key.to_pem)
        end
      end

      class VerifyKey < DelegateClass(OpenSSL::PKey::RSA)
        class << self
          alias_method :deserialize, :new
        end

        def initialize(*args)
          super(OpenSSL::PKey::RSA.new(*args))
        end

        def serialize
          to_pem
        end
      end

      ACCEPTED_HASH_FUNCTIONS = ["SHA256", "SHA384", "SHA512"].freeze
      DEFAULT_KEY_SIZE = 2048

      attr_reader :hash_function

      def initialize(hash_function: self.class::ACCEPTED_HASH_FUNCTIONS.first)
        if self.class::ACCEPTED_HASH_FUNCTIONS.include?(hash_function)
          @hash_function = hash_function
        else
          raise(OpenSSL::SignatureAlgorithm::UnsupportedParameterError, "Unsupported hash function '#{hash_function}'")
        end
      end

      def generate_signing_key(size: DEFAULT_KEY_SIZE)
        @signing_key = SigningKey.new(size)
      end
    end
  end
end
