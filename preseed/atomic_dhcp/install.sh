#!/bin/sh
IP="192.168.121.102"
NETMASK="255.255.255.0"
GATE="192.168.121.1"
DNS="192.168.121.1"
HOSTNAME="rmp-dpu-osa"
ROBOT_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCbvwatz8IR73pbp28zZlx465frnAHXBNgnOLvwBy8J8cjzXNeth3sgR5rO3QZw2DANQ51qFUOPqr71aS3pWlMF3H0X1f2ON9RPz90hGsGtiRDypiZNUnKqAIMfncQTy6m4UIycWcznvCtuBgcZWA/4Jfku/lV1yigMm0aNW8qsDs9f6pomdG8VDMRiGlXamJFH38vZwlnC4AbBXcWmX3Zkxxd5ZJqmcXodQureF9NrAtFcgMw+RzsMw2N8mIxP7YoC9kHPpT2jQIbCNfrICzDu59hZzGoaSHmlZLSnjOdNkv0oHLlgCYHDLplYors6QHtsh2YicdB8/GopP1Zj/OjRrDUASrt/gkOwndhdPnHMfcCu/RNcoP+RiVplwmgBSQ4ej135qbSFspcoT4nzbVHk/ffcQRYDVEMXnza1xLT0HAD9cccBjxRRaUpnnNkcMNQRQENEqHP6GcBu816dkDWKlAv2m94LAIuBDeDF2AC1ulvXC3r+jp9SWNSq8GP8OorhoguqvRsCR7M8VYlbmgh5ZMK+1bLNatsXZagOwVTTshjRaXrhEMHHFRUxbgj1N+P2Y3KHll8P7Ofpfa7Q9ro2DCACFsJeuHcq/BvLnQyMIf/xPkZ9XOdzuL3tcSbLRGXMqzoUmRCSzbclaY+/dDFi6FLqG/yFPn32Go8McZp5Yw== anav_key"
#
cat > /etc/network/interfaces.d/eth0.cfg <<-EOF
auto eth0
iface eth0 inet dhcp
EOF
cat > /etc/systemd/system/postinstall.service <<-EOF
	[Unit]
	Description=Base system configuration
	After=multi-user.target
	[Service]
	StandardOutput=tty
	Type=oneshot
	ExecStart=/usr/local/bin/postinst.sh
	[Install]
	WantedBy=multi-user.target
EOF
cat > /usr/local/bin/postinst.sh <<-EOF
	#!/bin/sh
	mkdir /home/robot/.ssh
	echo $ROBOT_KEY > /home/robot/.ssh/authorized_keys
	chown -R robot:robot /home/robot/.ssh
	chmod 0600 /home/robot/.ssh/authorized_keys
	rm -f  /etc/systemd/system/multi-user.target.wants/postinstall.service
	systemctl daemon-reload
EOF
#
chmod +x  /usr/local/bin/postinst.sh
systemctl enable postinstall
systemctl mask NetworkManager
systemctl mask connman
echo "$HOSTNAME" >  /etc/hostname
echo "$IP $HOSTNAME" >> /etc/hosts
#sed -i '/GRUB_CMDLINE_LINUX_DEFAULT=/s/ifnames=0/ifnames=1/' /etc/default/grub
#update-grub
