# frozen_string_literal: true

require "openssl"
require "openssl/signature_algorithm/rsa"

module OpenSSL
  module SignatureAlgorithm
    class RSAPSS < RSA
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
        ) || raise(OpenSSL::SignatureAlgorithm::SignatureVerificationError, "Signature verification failed")
      end

      def mgf1_hash_function
        hash_function
      end
    end
  end
end
