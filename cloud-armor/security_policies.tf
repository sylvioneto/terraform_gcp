resource "google_compute_security_policy" "policy" {
  name = "${local.application_name}-sec-policy"

  # WAF preconfigured rules
  rule {
    action   = "deny(403)"
    priority = "1000"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('sqli-stable')"
      }
    }
    description = "Deny SQL injection"
  }

  rule {
    action   = "deny(403)"
    priority = "1010"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('xss-stable')"
      }
    }
    description = "Deny Cross-site scripting"
  }

  rule {
    action   = "deny(403)"
    priority = "1020"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('lfi-stable')"
      }
    }
    description = "Deny Local file inclusion"
  }

  rule {
    action   = "deny(403)"
    priority = "1030"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('rfi-stable')"
      }
    }
    description = "Deny Remote file inclusion"
  }

  rule {
    action   = "deny(403)"
    priority = "1040"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('rce-stable')"
      }
    }
    description = "Deny Remote code execution"
  }

  rule {
    action   = "deny(403)"
    priority = "1050"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('methodenforcement-stable')"
      }
    }
    description = "Deny Method enforcement (public preview)"
  }

  rule {
    action   = "deny(403)"
    priority = "1060"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('scannerdetection-stable')"
      }
    }
    description = "Deny Scanner detection"
  }

  rule {
    action   = "deny(403)"
    priority = "1070"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('protocolattack-stable')"
      }
    }
    description = "Deny Protocol attack	"
  }

  rule {
    action   = "deny(403)"
    priority = "1080"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('php-stable')"
      }
    }
    description = "Deny PHP injection attack"
  }

  rule {
    action   = "deny(403)"
    priority = "1090"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('sessionfixation-stable')"
      }
    }
    description = "Deny Session fixation attack"
  }

  rule {
    action   = "deny(403)"
    priority = "1100"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('cve-canary')"
      }
    }
    description = "Deny 	Newly discovered vulnerabilities"
  }

  # allow
  rule {
    action   = "allow"
    priority = "2147483647"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "default rule"
  }
}
