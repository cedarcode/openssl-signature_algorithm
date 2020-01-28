# frozen_string_literal: true

require "openssl"
require "openssl/signature_algorithm/base"

module OpenSSL
  module SignatureAlgorithm
    class RSAPKCS1 < Base
      class SigningKey < OpenSSL::PKey::RSA
        def verify_key
          public_key
        end
      end

      DEFAULT_KEY_SIZE = 2048

      def generate_signing_key(size: DEFAULT_KEY_SIZE)
        @signing_key = SigningKey.new(size)
      end
    end
  end
end
