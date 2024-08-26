version edge
arch x86_64
signingkey /etc/apk/keys/pkg-amd64@originull.org-62bcc3cd.rsa.pub
repository https://depot.originull.org/edge/system
# Default Network Configuration
network false
hostname hollywood-live
nameserver 2620:fe::fe
nameserver 9.9.9.9
nameserver 149.112.112.112

# Base packages
pkginstall hollywood-base hollywood-desktop hollywood-setup livecd-support hollywood-accessories neofetch cmst
kernel stable

# Live User
username hollywood
useralias hollywood Hollywood Live Image User
usergroups hollywood users,audio,video,wheel,netdev,input
#userpw hollywood $6$b3P7y2vLSRl3ujqi$mYk5jlsRta8RQ/Qvunadj5ZO8BYO7cLkJsrMKve/r5Ka/1Gqrh1v93cjEttRR3wdmKwyvZZnkLbaw4T1dIEL40
# "live"
rootpw $6$b3P7y2vLSRl3ujqi$mYk5jlsRta8RQ/Qvunadj5ZO8BYO7cLkJsrMKve/r5Ka/1Gqrh1v93cjEttRR3wdmKwyvZZnkLbaw4T1dIEL40

svcenable syslogd
svcenable cronie
svcenable rtkit-daemon
svcenable connman
svcenable systemd-timesyncd
svcenable wpa_supplicant
svcenable sddm
svcenable sshd
svcenable wireplumber globaluser
svcenable pipewire-pulse globaluser
