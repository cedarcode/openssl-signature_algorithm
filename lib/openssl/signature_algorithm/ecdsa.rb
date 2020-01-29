# frozen_string_literal: true

require "openssl"
require "openssl/signature_algorithm/base"

module OpenSSL
  module SignatureAlgorithm
    class ECDSA < Base
      BYTE_LENGTH = 8

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

      private

      # Borrowed from jwt rubygem.
      # https://github.com/jwt/ruby-jwt/blob/7a6a3f1dbaff806993156d1dff9c217bb2523ff8/lib/jwt/security_utils.rb#L34-L39
      #
      # Hopefully this will be provided by openssl rubygem in the future.
      def formatted_signature(signature)
        n = (verify_key_length.to_f / BYTE_LENGTH).ceil

        if signature.size == n * 2
          r = signature[0..(n - 1)]
          s = signature[n..-1]

          OpenSSL::ASN1::Sequence.new([r, s].map { |int| OpenSSL::ASN1::Integer.new(OpenSSL::BN.new(int, 2)) }).to_der
        else
          signature
        end
      end

      def verify_key_length
        verify_key.group.degree
      end
    end
  end
end
