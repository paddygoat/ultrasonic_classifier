#!/bin/bash
# cd /home/tegwyn/Desktop/ && chmod +x jn_sd_resize.sh
# sudo ./jn_sd_resize.sh

# Copyright (c) 2019, Lufus
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#  * Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#  * Lufus name may not be used to endorse or promote products derived
#    from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ``AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
# OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# This is a script to relocate partitions 2..14 to the end of mmcblk0 device
# and expands root partition and file system to maximum size of SD card without reboot

# Script can be executed right on jetson nano or any other linux machine. 
# Just make sure that you SD card is /dev/mmcblk0 device

# Instructions:
# 1. open terminal
# 2. open a new file for edit  `nano jn_sd_resize.sh`
# 3. paste the code, save and exit nano
# 4. call `chmod +x jn_sd_resize.sh`
# 5.  run script with sudo `sudo ./jn_sd_resize.sh`
 

set -e

end_sector="$(sfdisk -d /dev/mmcblk0 | grep "last-lba:" | cut -d' ' -f2)"
echo "$end_sector"
echo "/dev/mmcblck0 device has $(($end_sector*512/1000/1000/1000))G size card"
echo "This script will move partitions p2..p14 to the end of /dev/mmcblk0 device"
size="$(cat /sys/block/mmcblk0/mmcblk0p1/size)"
echo "Current size of root file system is $(($size*512/1000/1000/1000))G"

# Move backup GPT header to end of disk
sgdisk --move-second-header /dev/mmcblk0

# Backup original partition table
# It can be used with command 'sudo sgdisk --load-backup=mmc_orig.ptt /dev/mmcblk0'
# to restore original partition in case of fail
sgdisk --backup=mmc_orig.ptt /dev/mmcblk0

# Read partition information into array
for p in {1..14}
do
    p_n[p]="$(sgdisk -i $p /dev/mmcblk0 | grep "Partition name" | cut -d\' -f2)"
    sleep 0.01
    p_t[p]="$(sgdisk -i $p /dev/mmcblk0 | grep "Partition GUID code:" | cut -d' ' -f4)"
    sleep 0.01
    p_u[p]="$(sgdisk -i $p /dev/mmcblk0 | grep "Partition unique GUID:" | cut -d' ' -f4)"
    sleep 0.01
    p_s[p]="$(cat /sys/block/mmcblk0/mmcblk0p$p/size)"
    sleep 0.01
done

# Calculate new locations for partitions
for p in {14..2}
do
    p_ed[p]=$end_sector
    p_st[p]=$(($end_sector-${p_s[p]}))
    end_sector=${p_st[p]}
done

# Save start sector for root partition
p_st[1]="$(cat /sys/block/mmcblk0/mmcblk0p1/start)"

echo "Partitions [1..14] read done"
echo "Saving data from parttions [2..14]..."
for p in {2..14}
do
    dd if=/dev/mmcblk0p"$p" of=~/.jnp-"$p".img
    echo "Backup partition $p: ${p_n[p]} ${p_t[p]} ${p_u[p]} ${p_s[p]} new start ${p_st[p]} end ${p_ed[p]}"
done
echo "Done"

for p in {14..2}
do
    # Relocate partition
    echo "Relocating ${p_n[p]} partition"
    sgdisk  -d $p -n $p:"${p_st[p]}":0 -c $p:"${p_n[p]}" -t $p:"${p_t[p]}" -u $p:"${p_u[p]}" /dev/mmcblk0
    sleep 0.5
done

partprobe /dev/mmcblk0

echo "Restore data to parttions [2..14]..."
for p in {2..14}
do
    dd of=/dev/mmcblk0p"$p" if=~/.jnp-"$p".img
    echo "Partition $p data restored"
    rm -f ~/.jnp-"$p".img
done

echo "Resizing root file system..."

# Extending root (APP) partition
sgdisk -d 1 -n 1:"${p_st[1]}":0 -c 1:"${p_n[1]}" -t $p:"${p_t[1]}" -u $p:"${p_u[1]}" /dev/mmcblk0

partprobe /dev/mmcblk0

# Resizing file system
resize2fs /dev/mmcblk0p1

sleep 0.5

size="$(cat /sys/block/mmcblk0/mmcblk0p1/size)"
echo "New size of root file system is $(($size*512/1000/1000/1000))G"
# Removing partition table backup
rm -f mmc_orig.ptt
