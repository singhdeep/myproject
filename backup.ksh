#!/bin/ksh
#set -x
##------------------------------------------------------------------------------
## Created by DS37260
## UserId: Date: Description:
## ------- ---------- ------------
## DS37260 2019/01/14 G4 feeds Backup script


COB_DT=`date -d yesterday +%Y%m%d`
DATE=`date +%Y%m%d`
SENDER_DL=deepak
TECH_DL=DS37260@imcap.ap.ssmb.com
##----DEV--------
#SRC=home/sb44170/deepak/
#dir=home/sb44170/deepak/$DATE
##---UAT G3------------
SRC=aaa/ff/f/ffff/ccc/bbb/aaa/G4
dir=aaa/ff/f/ffff/ccc/bbb/aaa/G4/$DATE

#this all_files.text file contain list of files for header trailer validations 
cd /$dir/

 

for file in `ls -lrt $(cat /$SRC/all_files.txt) 2>/dev/null |awk '{print $9}'`;do ls -lrt ${file}|awk '{print $9}';done >> /$dir/File_for_backup.log

for email_file in `cat /$dir/File_for_backup.log`;do ls -ltr ${email_file} ;done >> /$dir/email_files.log



BODY=`cat /$dir/email_files.log`


#important files for header trailer validation
for validate_imp in `cat /$SRC/imp_files.txt`;do ls ${validate_imp};zcat -f ${validate_imp} | head -1;zcat -f ${validate_imp} |tail -1; done >> /$dir/validate_$COB_DT.csv

chmod 777 validate_$COB_DT.csv

#create backup directories for all G4 countries.

mkdir ${COB_DT}_AU ${COB_DT}_MY ${COB_DT}_NZ ${COB_DT}_BD ${COB_DT}_ID ${COB_DT}_LK
chmod -R 777 ${COB_DT}_AU ${COB_DT}_MY ${COB_DT}_NZ ${COB_DT}_BD ${COB_DT}_ID ${COB_DT}_LK

#below are destination locations

mv {*AU*,OE102*} /$dir/${COB_DT}_AU
mv {*MY*,OE152*} /$dir/${COB_DT}_MY
mv {*NZ*,OE202*} /$dir/${COB_DT}_NZ
mv {*LK*,OE837*} /$dir/${COB_DT}_LK
mv {*ID*,OE001*} /$dir/${COB_DT}_ID
mv {*BD*,OE919*} /$dir/${COB_DT}_BD



#for sending Mail to ffs Team.
/$dir/validate_$COB_DT.csv

echo "Hi Deepak BACKUP DONE | sending mail ...."

FILE1=/$dir/validate_$COB_DT.csv
echo -e "Hi FFS Team,\n\n $BODY \n\n\n Backup Placed Here:$dir  \n\n\n\n THANKS & REGARDS\n Deepak Singh" | mailx -s "G4 Backup done for COB: $COB_DT" -a $FILE1 -r $SENDER_DL $TECH_DL test@gmail.com

/bin/rm /$dir/File_for_backup.log
/bin/rm /$dir/email_files.log
#/bin/rm /$dir/validate_$COB_DT.csv
