# --- T2-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
# 
# T2 SDE: package/.../openssh/stone_mod_sshd.sh
# Copyright (C) 2004 - 2006 The T2 SDE Project
# Copyright (C) 1998 - 2003 ROCK Linux Project
# 
# More information can be found in the files COPYING and README.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License. A copy of the
# GNU General Public License can be found in the file COPYING.
# --- T2-COPYRIGHT-NOTE-END ---
#
# [MAIN] 50 sshd SSH Daemon configuration

ssh_create_hostpair(){
	gui_cmd "Creating ssh host keypair" \
                "/usr/bin/ssh-keygen -t rsa1 -f /etc/ssh/ssh_host_key -N '' ; \
		 /usr/bin/ssh-keygen -t dsa  -f /etc/ssh/ssh_host_dsa_key -N '' ; \
		 /usr/bin/ssh-keygen -t rsa  -f /etc/ssh/ssh_host_rsa_key -N '' "
}

main() {
    while
	gui_menu alsa 'SSH Daemon Configuration.' \
		'Create a ssh host keypair' \
			'ssh_create_hostpair' \
		'Configure runlevels for sshd service' \
                        '$STONE runlevel edit_srv sshd' \
                '(Re-)Start sshd init script' \
			'$STONE runlevel restart sshd'
    do : ; done
}

