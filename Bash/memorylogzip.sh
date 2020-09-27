#!/bin/bash
read -p "Please enter the S3 bucket path (e.g. mybucket/myfolder/ ) : " bucket
read -p "Please enter the Day: " day
inst=`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id`
file="$inst-$day"day"-`date +%Y-%m-%d_%H:%M`"
filename="memoryutilization_202*"
if [[ $(find $filename -mtime +$day -print) ]]; then
mkdir zippedfiles
echo "Print files exists and is older than $day days"
find  $filename -mtime +$day -print
echo "Zipping files older than $day days"
find  ./zippedfiles/$file -exec gzip {} \;
find $filename -mtime +$day  -exec mv {} ./zippedfiles/$file \;
echo "Uploading the files to S3://$bucket "
aws s3 cp zippedfiles/$file.gz s3://$bucket
else
        echo "No file present older than $day days"
fi
