
#Op de headnode
if [[ $HOSTNAME =~ "vm1" ]]; then
#update yum
yum update -y

#epel repository:
yum install epel-release -y

#install ansible
yum install ansible -y

#install mariadb
yum install mariadb mariadb-server -y

#install munge
yum install munge munge-libs munge-devel -y

#munge ozpetten:
export MUNGEUSER=1001
groupadd -g $MUNGEUSER munge
useradd  -m -c "MUNGE Uid 'N' Gid Emporium" -d /var/lib/munge -u $MUNGEUSER -g munge  -s /sbin/nologin munge
export SlurmUSER=1002
groupadd -g $SlurmUSER slurm
useradd  -m -c "Slurm workload manager" -d /var/lib/slurm -u $SlurmUSER -g slurm  -s /bin/bash slurm
dd if=/dev/urandom bs=1 count=1024 > /etc/munge/munge.key
chown munge: /etc/munge/munge.key
chmod 400 /etc/munge/munge.key

fi

if  [ $HOSTNAME != *"vm1"* ] && [ $HOSTNAME =~ "vm" ]; then
#dit moet gedaan worden op een andere node dit kan natuurlijk pas zodra alle nodes uitgeroled zijn:
#Munge key kopieeëren naar de verschillende nodes:
scp -p /etc/munge/munge.key $HOSTNAME:/etc/munge/munge.key   #<-- vannuit de headnode
#services starten
systemctl enable munge
systemctl start  munge
#op de nodes:
#update yum
yum update -y
#epel repository:
yum install epel-release -y
#install munge
yum install munge munge-libs munge-devel -y
#Munge opzetten
export MUNGEUSER=1001
groupadd -g $MUNGEUSER munge
useradd  -m -c "MUNGE Uid 'N' Gid Emporium" -d /var/lib/munge -u $MUNGEUSER -g munge  -s /sbin/nologin munge
export SlurmUSER=1002
groupadd -g $SlurmUSER slurm
useradd  -m -c "Slurm workload manager" -d /var/lib/slurm -u $SlurmUSER -g slurm  -s /bin/bash slurm
#zodra de munge key overgekopieerd is:
chown -R munge: /etc/munge/ /var/log/munge/
chmod 0700 /etc/munge/ /var/log/munge/
#services starten
systemctl enable munge
systemctl start  munge
fi