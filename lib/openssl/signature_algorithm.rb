# frozen_string_literal: true

require "openssl/signature_algorithm/ecdsa"
require "openssl/signature_algorithm/rsapss"
require "openssl/signature_algorithm/rsapkcs1"
require "openssl/signature_algorithm/version"

module OpenSSL
  module SignatureAlgorithm
    class Error < StandardError; end
  end
end
