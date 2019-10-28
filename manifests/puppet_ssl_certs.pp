# resource that will copy the puppet certificates to a specific directory so that only specific owner can write/read it
# Parameters
#  Owner (required)
#  Group: (optional )if empty (default value), group name will equal owner
#  TargetBasePath: (optional) folder in which the certificates should be stored, we require the
#                             this directory to already exist
#  SourceBasePath: (optional) folder from which certificates are copied (by default puppet directory)
# The certificate location are the following:

# ca certificate: ${targetbasepath}/${name}/certs/ca.pem (e.g. /etc/dap-certs/consul/certs/ca.pem)
# certificate: ${targetbasepath}/${name}/certs/${trusted['certname']}.pem
#               (e.g. /etc/dap-certs/consul/certs/dapbasesdb01.dap.pem)
# private key: ${targetbasepath}/${name}/private_keys/${trusted['certname']}.pem
#               (e.g. /etc/dap-certs/consul/certs/dapbasesdb01.dap.pem)
# the puppet_ssl_certs defined resource can only run after the install has created the correct owner,
# NOTE: therefore the service will not be restarted if certificates are updated!!

define proftpd::puppet_ssl_certs(
  String $owner,
  Stdlib::Absolutepath $targetbasepath = '/etc/dap-certs',
  String $group = $owner,
  Stdlib::Absolutepath $sourcebasepath='/etc/puppetlabs/puppet/ssl',
){

  # ensure base target path is present with right settings
  file { "${targetbasepath}/${name}":
    ensure => directory,
    owner  => $owner,
    group  => $group,
    mode   => '0755',
  }

  file { "${targetbasepath}/${name}/private_keys":
    ensure => directory,
    owner  => $owner,
    group  => $group,
    mode   => '0700',
  }

  file { "${targetbasepath}/${name}/certs":
    ensure => directory,
    owner  => $owner,
    group  => $group,
    mode   => '0755',
  }

  # Copy certificates
  file { "${targetbasepath}/${name}/certs/ca.pem":
    ensure    => file,
    owner     => $owner,
    group     => $group,
    source    => "file://${sourcebasepath}/certs/ca.pem",
    mode      => '0644',
    show_diff => false,
  }
  file { "${targetbasepath}/${name}/crl.pem":
    ensure    => file,
    owner     => $owner,
    group     => $group,
    source    => "file://${sourcebasepath}/crl.pem",
    mode      => '0644',
    show_diff => false,
  }
  file { "${targetbasepath}/${name}/certs/${trusted['certname']}.pem":
    ensure    => file,
    owner     => $owner,
    group     => $group,
    source    => "file://${sourcebasepath}/certs/${trusted['certname']}.pem",
    mode      => '0644',
    show_diff => false,
  }
  file { "${targetbasepath}/${name}/private_keys/${trusted['certname']}.pem":
    ensure    => file,
    owner     => $owner,
    group     => $group,
    source    => "file://${sourcebasepath}/private_keys/${trusted['certname']}.pem",
    mode      => '0600',
    show_diff => false,
  }
}
