resource "google_project_organization_policy" "require_os_login" {
  project    = var.project_id
  constraint = "compute.requireOsLogin"

  boolean_policy {
    enforced = false
  }
}

resource "google_project_organization_policy" "disable_serial_port" {
  project    = var.project_id
  constraint = "compute.disableSerialPortLogging"

  boolean_policy {
    enforced = false
  }
}

resource "google_project_organization_policy" "require_shielded_vm" {
  project    = var.project_id
  constraint = "compute.requireShieldedVm"

  boolean_policy {
    enforced = false
  }
}

resource "google_project_organization_policy" "vm_Can_Ip_Forward" {
  project    = var.project_id
  constraint = "compute.vmCanIpForward"

  boolean_policy {
    allow_all = true
  }
}

resource "google_project_organization_policy" "external_ip" {
  project    = var.project_id
  constraint = "compute.vmExternalIpAccess"

  boolean_policy {
    allow_all = true
  }
}

resource "google_project_organization_policy" "vpc_peering" {
  project    = var.project_id
  constraint = "compute.restrictVpcPeering"

  boolean_policy {
    allow_all = true
  }
}
