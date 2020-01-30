# Changelog

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

[v0.3.0]: https://github.com/cedarcode/openssl-signature_algorithm/compare/v0.2.0...v0.3.0/
[v0.2.0]: https://github.com/cedarcode/openssl-signature_algorithm/compare/v0.1.1...v0.2.0/
[v0.1.1]: https://github.com/cedarcode/openssl-signature_algorithm/compare/v0.1.0...v0.1.1/
[v0.1.0]: https://github.com/cedarcode/openssl-signature_algorithm/compare/41887c277dc7fa0c884ccf8924cf990ff76784d9...v0.1.0/
