# frozen_string_literal: true

require "openssl"
require "openssl/signature_algorithm/base"

module OpenSSL
  module SignatureAlgorithm
    class ECDSA < Base
      class SigningKey < OpenSSL::PKey::EC
        def initialize(*args)
          super(*args).generate_key
        end

        def verify_key
          VerifyKey.new(group, public_key.to_bn)
        end
      end

      class VerifyKey < OpenSSL::PKey::EC::Point
        def verify(*args)
          ec_key = OpenSSL::PKey::EC.new(group)
          ec_key.public_key = self

          ec_key.verify(*args)
        end
      end

      CURVE_BY_DIGEST_LENGTH = {
        "256" => "prime256v1",
        "384" => "secp384r1",
        "512" => "secp521r1"
      }.freeze

      def generate_signing_key
        @signing_key = SigningKey.new(curve_name)
      end

      def curve_name
        CURVE_BY_DIGEST_LENGTH[digest_length] ||
          raise(OpenSSL::SignatureAlgorithm::Error, "Unsupported digest length #{digest_length}")
      end
    end
  end
end
