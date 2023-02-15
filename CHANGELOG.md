# Changelog

## [v1.3.0] - 2023-02-15

- Loose OpenSSL dependency to support 3.1 users. Thanks @bdewater <3

## [v1.2.1] - 2022-06-05

- Support OpenSSL ~>3.0.0. Credits to @ClearlyClaire <3

## [v1.1.1] - 2021-02-11

### Fixed

- Fix error asking for ed25519 gem when actually not using EdDSA

## [v1.1.0] - 2021-02-11

### Added

- EdDSA support added (requires adding the `ed25519` gem to your `Gemfile`) ([@santiagorodriguez96])

## [v1.0.0] - 2020-07-08

### Added

- ECDSA with **secp256k1** curve support added:
  ```rb
  OpenSSL::SignatureAlgorithm::ECDSA.new(curve: "secp256k1")
  ```
- Algorithm **arguments** are now **optional**. The following works:

  ```rb
  OpenSSL::SignatureAlgorithm::ECDSA.new
  # defaults to ECDSA with SHA-256 and NIST P256 curve
  # Same as OpenSSL::SignatureAlgorithm::ECDSA.new(hash_function: "SHA256", curve: "prime256v1")

  OpenSSL::SignatureAlgorithm::RSAPSS.new
  # defaults to SHA-256
  # Same as OpenSSL::SignatureAlgorithm::RSAPSS.new(hash_function: "SHA256")

  OpenSSL::SignatureAlgorithm::RSAPKCS1.new
  # defaults to SHA-256
  # Same as OpenSSL::SignatureAlgorithm::RSAPSS.new(hash_function: "SHA256")
  ```

### Changed

- Algorithm **instantiation** changed. The positional argument `digest_length` is replaced with keyword arguments, `hash_function:` for RSA algorithms and `hash_function:` and `curve:` for ECDSA. None are required arguments, you get sane defaults if you don't provide any arguments. Code migration examples:
  ```rb
  # Change this
  # OpenSSL::SignatureAlgorithm::ECDSA.new("256")
  # to
  OpenSSL::SignatureAlgorithm::ECDSA.new(hash_function: "SHA256")
  ```
  ```rb
  # Change this
  # OpenSSL::SignatureAlgorithm::RSAPSS.new("384")
  # to
  OpenSSL::SignatureAlgorithm::RSAPSS.new(hash_function: "SHA384")
  ```

## [v0.4.0] - 2020-01-31

### Added

- `VerifyKey` serialization and deserialization for easy transmission over the network

## [v0.3.0] - 2020-01-30

### Added

- Support ruby v2.4 (without RSA-PSS)

## [v0.2.0] - 2020-01-29

### Added

- `OpenSSL::SignatureAlgorithm::ECDSA#verify` now supports raw (non DER) signatures

## [v0.1.1] - 2020-01-29

### Fixed

- Fixed error in `OpenSSL::SignatureAlgorithm::RSAPSS#sign`

## [v0.1.0] - 2020-01-29

### Added

- `OpenSSL::SignatureAlgorithm::ECDSA`
- `OpenSSL::SignatureAlgorithm::RSAPSS`
- `OpenSSL::SignatureAlgorithm::RSAPKCS1`

[v1.3.0]: https://github.com/cedarcode/openssl-signature_algorithm/compare/v1.2.1...v1.3.0/
[v1.2.1]: https://github.com/cedarcode/openssl-signature_algorithm/compare/v1.1.1...v1.2.1/
[v1.1.1]: https://github.com/cedarcode/openssl-signature_algorithm/compare/v1.1.0...v1.1.1/
[v1.1.0]: https://github.com/cedarcode/openssl-signature_algorithm/compare/v1.0.0...v1.1.0/
[v1.0.0]: https://github.com/cedarcode/openssl-signature_algorithm/compare/v0.4.0...v1.0.0/
[v0.4.0]: https://github.com/cedarcode/openssl-signature_algorithm/compare/v0.3.0...v0.4.0/
[v0.3.0]: https://github.com/cedarcode/openssl-signature_algorithm/compare/v0.2.0...v0.3.0/
[v0.2.0]: https://github.com/cedarcode/openssl-signature_algorithm/compare/v0.1.1...v0.2.0/
[v0.1.1]: https://github.com/cedarcode/openssl-signature_algorithm/compare/v0.1.0...v0.1.1/
[v0.1.0]: https://github.com/cedarcode/openssl-signature_algorithm/compare/41887c277dc7fa0c884ccf8924cf990ff76784d9...v0.1.0/

[@santiagorodriguez96]: https://github.com/santiagorodriguez96
[@ClearlyClaire]: https://github.com/clearlyclaire
[@bdewater]: https://github.com/bdewater
