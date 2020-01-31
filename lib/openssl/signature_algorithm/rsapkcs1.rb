# frozen_string_literal: true

require "openssl"
require "openssl/signature_algorithm/base"

module OpenSSL
  module SignatureAlgorithm
    class RSAPKCS1 < Base
      class SigningKey < OpenSSL::PKey::RSA
        def verify_key
          VerifyKey.new(public_key.to_pem)
        end
      end

      class VerifyKey < OpenSSL::PKey::RSA
        class << self
          alias_method :deserialize, :new
        end

        def serialize
          to_pem
        end
      end

      DEFAULT_KEY_SIZE = 2048

      def generate_signing_key(size: DEFAULT_KEY_SIZE)
        @signing_key = SigningKey.new(size)
      end
    end
  end
end
