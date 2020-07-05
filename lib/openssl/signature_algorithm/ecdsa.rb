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
        def self.deserialize(pem_string)
          new(OpenSSL::PKey::EC.new(pem_string).public_key)
        end

        def serialize
          ec_key.to_pem
        end

        def ec_key
          @ec_key ||=
            begin
              ec_key = OpenSSL::PKey::EC.new(group)
              ec_key.public_key = self

              ec_key
            end
        end

        def verify(*args)
          ec_key.verify(*args)
        end
      end

      ACCEPTED_PARAMETERS = [
        { curve: "prime256v1", hash_function: "SHA256" },
        { curve: "secp384r1", hash_function: "SHA384" },
        { curve: "secp521r1", hash_function: "SHA512" },
        { curve: "secp256k1", hash_function: "SHA256" }
      ].freeze

      attr_reader :curve, :hash_function

      def initialize(curve: nil, hash_function: nil)
        @curve, @hash_function = pick_parameters(curve, hash_function)
      end

      def generate_signing_key
        @signing_key = SigningKey.new(curve)
      end

      def compatible_verify_key?(key)
        super && key.respond_to?(:group) && key.group.curve_name == curve
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

      def pick_parameters(curve, hash_function)
        parameters = ACCEPTED_PARAMETERS.detect do |params|
          if curve
            if hash_function
              params[:curve] == curve && params[:hash_function] == hash_function
            else
              params[:curve] == curve
            end
          elsif hash_function
            params[:hash_function] == hash_function
          else
            true
          end
        end

        if parameters
          [parameters[:curve], parameters[:hash_function]]
        else
          raise(OpenSSL::SignatureAlgorithm::UnsupportedParameterError, "Unsupported algorithm parameters")
        end
      end
    end
  end
end
