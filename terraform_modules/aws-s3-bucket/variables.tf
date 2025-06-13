variable "bucket_name" {
  type        = string
  default     = ""
  description = "The name to be ascribed to the bucket"
}

variable "iam_role_arn" {
  type        = string
  default     = ""
  description = "The IAM Role ARN to be set to allow access via bucket policy."
}

variable "retention_days" {
  type        = number
  default     = 30
  description = "How many days to retain the contents of this bucket."
}

variable "retention_enabled" {
  type        = bool
  default     = true
  description = "Whether retention settings are enabled for this bucket."
}

variable "simple_retention_enabled" {
  type        = bool
  default     = true
  description = "Whether simple retention settings are enabled for this bucket."
}

variable "custom_retention" {
  description = "Whether custom retention settings are enabled for this bucket."
  default     = null
}

variable "noncurrent_version_expiration_days" {
  type        = number
  default     = 30
  description = "Number of days before objects are declared non-current."
}

variable "create_policy" {
  type        = bool
  default     = true
  description = "Whether to create a bucket policy or not."
}

variable "cost_type" {
  type        = string
  default     = "engine_storage"
  description = "cost_type tag value to apply to this resource"
}

variable "cost_category" {
  type        = string
  default     = "product/orgname"
  description = "cost_category tag value to apply to this resource"
}

variable "versioning" {
  type        = bool
  default     = true
  description = "Whether or not to enable versioning on the bucket."
}

variable "incomplete_multipart_days" {
  type        = number
  default     = 7
  description = "Number of days before incompete multi-part files are maintained."
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "Whether to forcibly destroy all contents automaticall when bucket is marked for deletion."
}

variable "override_policy" {
  default     = null
  description = "Not implementing an override policy."
}

variable "additional_principals" {
  type        = list(string)
  default     = []
  description = "Additional Principals to add to the ACL list of this bucket."
}
