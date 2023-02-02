# Changelog

All notable changes to this project will be documented in this file.

## [3.0.0](https://github.com/cloudandthings/terraform-aws-costnotifier/compare/v2.1.1...v3.0.0) (2023-02-02)


### ⚠ BREAKING CHANGES

* Allow IAM role to be passed to the module ([#37](https://github.com/cloudandthings/terraform-aws-costnotifier/issues/37))

### Features

* Allow IAM role to be passed to the module ([#37](https://github.com/cloudandthings/terraform-aws-costnotifier/issues/37)) ([216ec0b](https://github.com/cloudandthings/terraform-aws-costnotifier/commit/216ec0b77515058da2cd228e6d7e0fa1a01d5255))

## [2.1.1](https://github.com/cloudandthings/terraform-aws-costnotifier/compare/v2.1.0...v2.1.1) (2023-01-18)


### Bug Fixes

* **security:** Mark webhooks variable as sensitive ([#35](https://github.com/cloudandthings/terraform-aws-costnotifier/issues/35)) ([6e3cbe9](https://github.com/cloudandthings/terraform-aws-costnotifier/commit/6e3cbe92151d5b22970fbb6b3d5124f748bcd7b6))

## [2.1.0](https://github.com/cloudandthings/terraform-aws-costnotifier/compare/v2.0.0...v2.1.0) (2022-12-14)


### Features

* Disable remote building ([#33](https://github.com/cloudandthings/terraform-aws-costnotifier/issues/33)) ([d98bf60](https://github.com/cloudandthings/terraform-aws-costnotifier/commit/d98bf60b36e3ae15b51f45d8cce23c6592c74c13))

## [2.0.0](https://github.com/cloudandthings/terraform-aws-costnotifier/compare/v1.2.0...v2.0.0) (2022-12-14)


### ⚠ BREAKING CHANGES

* **security:** Rename sns_topic_kms_key_arn variable to kms_key_id and use for all resources

### Features

* Add tags to all resources ([d86018e](https://github.com/cloudandthings/terraform-aws-costnotifier/commit/d86018ee08326c7dd4476a7e34ebbce962c3e8ae))
* **iam:** Add permissions_boundary variable ([dc0bf06](https://github.com/cloudandthings/terraform-aws-costnotifier/commit/dc0bf0649fb10e38bdde7c6b64dba51e6cf0ed5d))
* **lambda:** Add lambda_description variable ([b040993](https://github.com/cloudandthings/terraform-aws-costnotifier/commit/b04099344223c33b47eda93ad8a97d3090be1a33))
* **notifications:** Add var.webhook_type and improved teams notification ([0ef757b](https://github.com/cloudandthings/terraform-aws-costnotifier/commit/0ef757b177af520adcf6e9260dee9b17e48d84cb))
* **security:** Rename sns_topic_kms_key_arn variable to kms_key_id and use for all resources ([996b40f](https://github.com/cloudandthings/terraform-aws-costnotifier/commit/996b40f191fc24caeec6e184d82fe41d0a83fc82))


### Bug Fixes

* **lambda:** Change timeout to 300sec ([25c45ec](https://github.com/cloudandthings/terraform-aws-costnotifier/commit/25c45ecec91b420bb0a99b6f5865080e516b49ed))

## [1.2.0](https://github.com/cloudandthings/terraform-aws-costnotifier/compare/v1.1.0...v1.2.0) (2022-12-12)


### Features

* **security:** Add sns_topic_kms_key_arn variable ([ca29133](https://github.com/cloudandthings/terraform-aws-costnotifier/commit/ca2913384d968ad0002804c5fb3d90b51f31ac14))


### Bug Fixes

* **iam:** Policy syntax bugfix ([c724935](https://github.com/cloudandthings/terraform-aws-costnotifier/commit/c724935de51d832ba705a8a6d4286f56f269c130))

## [1.1.0](https://github.com/cloudandthings/terraform-aws-costnotifier/compare/v1.0.0...v1.1.0) (2022-12-09)


### Features

* Module tests and standardisation ([ff762ef](https://github.com/cloudandthings/terraform-aws-costnotifier/commit/ff762efb47c1873b88ee6862f93766e562a04c83))
* **security:** Improve support for VPC and private functions ([77a8666](https://github.com/cloudandthings/terraform-aws-costnotifier/commit/77a866665bd587811d753ff57b8810d9a874ca9e))


### Bug Fixes

* **ci:** Enable validateSingleCommit for pr-title ([f8e7d57](https://github.com/cloudandthings/terraform-aws-costnotifier/commit/f8e7d570835ed2143f65e0357df8bab60ac6cd75))
