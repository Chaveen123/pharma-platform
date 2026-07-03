/*data "aws_iam_policy_document" "eso_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:external-secrets"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [var.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "eso_role" {
  name               = "${var.project}-${var.env}-eso-role"
  assume_role_policy = data.aws_iam_policy_document.eso_assume_role.json

  tags = {
    Name    = "${var.project}-${var.env}-eso-role"
    Env     = var.env
    Project = var.project
  }
}

resource "aws_iam_policy" "eso_secrets_policy" {
  name        = "${var.project}-${var.env}-eso-secrets-policy"
  description = "Allow External Secrets Operator to read pharma secrets from AWS Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = "arn:aws:secretsmanager:*:${var.aws_account_id}:secret:/pharma/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eso_secrets_attachment" {
  role       = aws_iam_role.eso_role.name
  policy_arn = aws_iam_policy.eso_secrets_policy.arn
}

# ArgoCD IRSA Role
data "aws_iam_policy_document" "argocd_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:argocd:argocd-application-controller"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [var.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "argocd_role" {
  name               = "${var.project}-${var.env}-argocd-role"
  assume_role_policy = data.aws_iam_policy_document.argocd_assume_role.json

  tags = {
    Name    = "${var.project}-${var.env}-argocd-role"
    Env     = var.env
    Project = var.project
  }
}

# GitLab Runner IRSA Role
data "aws_iam_policy_document" "gitlab_runner_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:gitlab-runner:gitlab-runner"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [var.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "gitlab_runner_role" {
  name               = "${var.project}-${var.env}-gitlab-runner-role"
  assume_role_policy = data.aws_iam_policy_document.gitlab_runner_assume_role.json

  tags = {
    Name    = "${var.project}-${var.env}-gitlab-runner-role"
    Env     = var.env
    Project = var.project
  }
}

resource "aws_iam_policy" "gitlab_runner_policy" {
  name        = "${var.project}-${var.env}-gitlab-runner-policy"
  description = "Allow GitLab Runner to push to ECR and describe EKS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "gitlab_runner_policy_attachment" {
  role       = aws_iam_role.gitlab_runner_role.name
  policy_arn = aws_iam_policy.gitlab_runner_policy.arn
}*/

# IAM Role for Bastion
resource "aws_iam_role" "bastion_role" {
  name               = "${var.project}-${var.env}-bastion-role"
  assume_role_policy = data.aws_iam_policy_document.bastion_assume_role.json

  tags = {
    Name    = "${var.project}-${var.env}-bastion-role"
    Env     = var.env
    Project = var.project
  }
}

data "aws_iam_policy_document" "bastion_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Bastion Policy (EKS + EC2 describe)
/*resource "aws_iam_policy" "bastion_policy" {
  name        = "${var.project}-${var.env}-bastion-policy"
  description = "Allow bastion host to access EKS and private resources"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:ListNodegroups",
          "eks:DescribeNodegroup"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups"
        ]
        Resource = "*"
      }
    ]
  })
}

# Jenkins/ECR Policy
resource "aws_iam_policy" "jenkins_ecr_policy" {
  name        = "${var.project}-${var.env}-jenkins-ecr-policy"
  description = "Allow Jenkins on bastion to push/pull images to ECR"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach both policies to the bastion role
resource "aws_iam_role_policy_attachment" "bastion_policy_attachment" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = aws_iam_policy.bastion_policy.arn
}

resource "aws_iam_role_policy_attachment" "jenkins_ecr_policy_attachment" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = aws_iam_policy.jenkins_ecr_policy.arn
}*/

resource "aws_iam_role_policy_attachment" "bastion_policy_attachment" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"  # Attach AdministratorAccess policy to the bastion role
}

# Instance Profile
resource "aws_iam_instance_profile" "bastion_instance_profile" {
  name = "${var.project}-${var.env}-bastion-instance-profile"
  role = aws_iam_role.bastion_role.name

  tags = {
    Name    = "${var.project}-${var.env}-bastion-instance-profile"
    Env     = var.env
    Project = var.project
  } 
}