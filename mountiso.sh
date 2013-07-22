#!/bin/bash 

# recherhes des images 
for file in $( find /srv/tftp/os/ -name "*.iso" )
do
	isopath=$(echo $file| sed -e 's/\/iso\/.*/\/iso-content/')
	if [ ! -d $isopath ];then
		mkdir -p $isopath
	fi
	echo "Montage de $file sur $isopath"
	mount -t iso9660 -o loop $file $isopath
done
