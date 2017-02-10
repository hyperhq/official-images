#! /bin/bash

id=1000
ganesha_config="/ganesha.conf"
mountpoints=$(df |grep '/dev/sd'|awk '{print $6}')

function setup_local_export_dir() {
  mkdir -p $1
  mount /vol $1
}

function make_export() {
  exportid=$1
  path=$2
  pseudo=$3

cat >> ${ganesha_config} << EOL
EXPORT
{
        # Export Id (mandatory, each EXPORT must have a unique Export_Id)
        Export_Id = ${exportid};

        # Exported path (mandatory)
        Path = ${path};

        # Pseudo Path (required for NFS v4)
        Pseudo = ${pseudo};

	# The Protocols allowed
	Protocols = NFS4;

        # Required for access (default is None)
        # Could use CLIENT blocks instead
        Access_Type = RW;
        Squash = No_root_squash; # To enable/disable root squashing
        SecType = "sys";  # Security flavors supported
	Transports = TCP;
        # Exporting FSAL
        FSAL {
                Name = VFS;
        }
}
EOL
}

rm -f ${ganesha_config}

cat >> ${ganesha_config} << EOL
NFSV4
{
	# Graceless/Grace_Period (NFS v4 Grace Period Control)
	Graceless = true;
}
EOL

setup_local_export_dir /export
make_export ${id} /export /export

# run rpcbind as ganesha.nfsd requires it
rpcbind

/usr/bin/ganesha.nfsd -F -L /var/log/ganesha.log -f ${ganesha_config}
