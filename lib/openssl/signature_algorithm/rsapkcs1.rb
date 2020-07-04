# frozen_string_literal: true

require "openssl"
require "openssl/signature_algorithm/rsa"

module OpenSSL
  module SignatureAlgorithm
    class RSAPKCS1 < RSA
    end
  end
end
