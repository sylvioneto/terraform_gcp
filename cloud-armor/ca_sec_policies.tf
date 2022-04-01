resource "google_compute_security_policy" "policy" {
  provider = google-beta
  name     = "${local.application_name}-sec-policy"

  # Geo location
  rule {
    action      = "deny(403)"
    priority    = "250"
    description = "Deny requests out of geo coverage"
    match {
      expr {
        expression = "origin.region_code != 'BR' && origin.region_code != 'US'"
      }
    }
  }

  # WAF preconfigured rules
  rule {
    action      = "deny(403)"
    priority    = "1000"
    description = "Deny SQL injection"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('sqli-stable')"
      }
    }
  }

  rule {
    action      = "deny(403)"
    priority    = "1010"
    description = "Deny Cross-site scripting"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('xss-stable')"
      }
    }
  }

  rule {
    action      = "deny(403)"
    priority    = "1020"
    description = "Deny Local file inclusion"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('lfi-stable')"
      }
    }
  }

  rule {
    action      = "deny(403)"
    priority    = "1030"
    description = "Deny Remote file inclusion"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('rfi-stable')"
      }
    }
  }

  rule {
    action      = "deny(403)"
    priority    = "1040"
    description = "Deny Remote code execution"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('rce-stable')"
      }
    }
  }

  rule {
    action      = "deny(403)"
    priority    = "1050"
    description = "Deny Method enforcement (public preview)"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('methodenforcement-stable')"
      }
    }
  }

  rule {
    action      = "deny(403)"
    priority    = "1060"
    description = "Deny Scanner detection"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('scannerdetection-stable')"
      }
    }
  }

  rule {
    action      = "deny(403)"
    priority    = "1070"
    description = "Deny Protocol attack"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('protocolattack-stable')"
      }
    }
  }

  rule {
    action      = "deny(403)"
    priority    = "1080"
    description = "Deny PHP injection attack"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('php-stable')"
      }
    }
  }

  rule {
    action      = "deny(403)"
    priority    = "1090"
    description = "Deny Session fixation attack"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('sessionfixation-stable')"
      }
    }
  }

  rule {
    action      = "deny(403)"
    priority    = "1100"
    description = "Deny Newly discovered vulnerabilities"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('cve-canary')"
      }
    }
  }

  # Rate based ban
  rule {
    action      = "rate_based_ban"
    priority    = "1110"
    description = "Rate based ban - 300req in 60s"

    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }

    rate_limit_options {
      rate_limit_threshold {
        count        = 300
        interval_sec = 60
      }
      ban_duration_sec = 600
      conform_action   = "allow"
      exceed_action    = "deny(429)"
      enforce_on_key   = "XFF-IP"
    }
  }

  # Wordpress
  rule {
    action      = "deny(403)"
    priority    = "1120"
    description = "Block access to Wordpress admin"
    match {
      expr {
        expression = "request.path.matches('/wp-admin/')"
      }
    }
  }

  # default rule
  rule {
    action      = "allow"
    priority    = "2147483647"
    description = "default rule"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
  }
}
