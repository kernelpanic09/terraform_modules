🚀 AWS S3 Bucket Terraform Module

This Terraform module provisions a secure, tagged, and optionally versioned Amazon S3 bucket, complete with:

    Server-side encryption

    Ownership controls

    IAM-based access policies

    Optional lifecycle rules for retention

    Optional bucket versioning

✅ Features

    S3 Bucket creation with custom name

    Server-side encryption (AES-256)

    Bucket Ownership Control (enforces bucket owner ownership)

    IAM-based bucket policy supporting multiple principals

    Private ACL

    Versioning (optional)

    Lifecycle policies (optional simple + advanced rules)

    Force destroy (optional)

    Tagging for cost allocation and visibility

📦 Module Usage

module "secure_s3_bucket" {
  source = "./modules/s3" # Replace with actual source path

  bucket_name                     = "my-secure-bucket"
  force_destroy                   = true
  iam_role_arn                    = "arn:aws:iam::123456789012:role/my-app-role"
  additional_principals           = ["arn:aws:iam::123456789012:user/my-user"]

  cost_type                       = "storage"
  cost_category                   = "project-x"

  versioning                     = true
  retention_enabled              = true
  simple_retention_enabled       = true
  retention_days                 = 90
  incomplete_multipart_days      = 7
  noncurrent_version_expiration_days = 30

  custom_retention = [
    {
      id     = "custom-rule-1"
      status = "Enabled"
      filter = [
        {
          tag = [
            { key = "env", value = "prod" }
          ]
        }
      ]
      expiration = [
        { days = 180 }
      ]
    }
  ]
}

📘 Inputs
Name	Description	Type	Default	Required
bucket_name	Name of the S3 bucket	string	n/a	✅
force_destroy	Delete bucket even if it contains objects	bool	false	❌
iam_role_arn	IAM role to grant access to the bucket	string	n/a	✅
additional_principals	List of additional IAM ARNs allowed to access the bucket	list(string)	[]	❌
cost_type	Tag to define cost type	string	""	❌
cost_category	Tag to define cost category	string	""	❌
versioning	Enable versioning on the bucket	bool	false	❌
retention_enabled	Enable lifecycle rules	bool	false	❌
simple_retention_enabled	Enable simple expiration rule	bool	false	❌
retention_days	Number of days before objects expire	number	0	❌
incomplete_multipart_days	Abort incomplete uploads after N days	number	7	❌
noncurrent_version_expiration_days	Days before noncurrent object versions expire	number	30	❌
custom_retention	List of advanced lifecycle rules	list(map(any))	[]	❌
📤 Outputs

(Optional — add if you expose any outputs, such as the bucket name, ARN, or policy JSON)
🔐 Security

    Enforces secure transport (aws:SecureTransport)

    All access is restricted to defined IAM principals

    Ownership is strictly enforced with BucketOwnerEnforced