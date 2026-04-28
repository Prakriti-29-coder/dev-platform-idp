package idp.compliance

default allow := false

############################################
# MAIN RULE
############################################

allow if {
    valid_name
    valid_region
    length_ok
    gdpr_safe
    iso27001_compliant
    nist_secure
}

############################################
# NAME RULES
############################################

valid_name if {
    input.app_name == lower(input.app_name)
    not contains(input.app_name, "admin")
    not contains(input.app_name, "root")
    not contains(input.app_name, "test")
}

length_ok if {
    count(input.app_name) >= 5
    count(input.app_name) <= 30
}

############################################
# REGION RULE
############################################

valid_region if {
    input.region == "southeastasia"
}

############################################
# GDPR SIMULATION
############################################

gdpr_safe if {
    not contains(input.app_name, "user")
    not contains(input.app_name, "email")
    not contains(input.app_name, "password")
    not contains(input.app_name, "customer")
}

############################################
# ISO 27001 SIMULATION
############################################

iso27001_compliant if {
    not startswith(input.app_name, "public-")
}

############################################
# NIST SECURITY RULES
############################################

nist_secure if {
    not contains(input.app_name, "123")
    not contains(input.app_name, "hack")
}
