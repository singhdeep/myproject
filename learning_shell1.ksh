#!/bin/ksh
#set -x
##------------------------------------------------------------------------------
## Created by DS37260
## UserId: Date: Description:
## ------- ---------- ------------
## DS37260 2019/01/14 prod files and timestamp

#variables used in script 
COB_DT=`date -d yesterday +%Y%m%d`
DATE=`date +%Y%m%d`
DEEP_STAT=`date +%Y%m%d%HH%mm%ss`
SENDER_DL=FFSTechTeam
#SUPPORT_DL=
TECH_DL=
TEMP_FILE=tmp
#DUMP=var/app/fbbprd/cda/inbound/overrides/


#Arguments passed to run script in two modes (for Daily Dump and for whole Dump only once)

#Script RUNNING Mode's for APAC and PROD_G2_JP
#./ffs_source_feed_arival_status.ksh daily or once 
running_mode=$1
running_env=$2

if [ $# -lt 1 -o $# -gt 2 ]; then
        echo "ERROR : INVALID ARGUMENTS PASSED PLEASE PASS BELOW ARGUMENTS"
        echo "USAGE : <script> <running_mode : (daily or once) For APAC | (daily or once and jp) for Prod G2_JP  >"
        :exit 1
fi

#to check server on which script running in
if [ "`hostname`" = "" -o "`hostname`" = "" ]; then
                SUBJECT="UAT G1"
                

elif [ "`hostname`" = "" ]; then
                SUBJECT="UAT G2"
                

elif [ "`hostname`" = "" -o "`hostname`" = "" ]; then
                SUBJECT="UAT G3"
               

elif [ "`hostname`" = "" -o "`hostname`" = "" ];then
                SUBJECT="Prod China "
                dir=

elif [ "`hostname`" = "" -o "`hostname`" = "" ]; then
                SUBJECT="Prod G1"
                        dir=
               

                                                             

elif [ "`hostname`" = "" -o "`hostname`" = "" ]; then
             if [ $running_env == "jp" ]; then
                                 SUBJECT="Prod G2_JP"
                                                                #dir=
                                                                
                           else 
                                 SUBJECT="PROD G2"
                                                                  #dir=
                                                                  
                                                                                                                                    
             fi 

elif [ "`hostname`" = "" -o "`hostname`" = "" ]; then
           SUBJECT="Prod G3"
                  dir=

elif [ "`hostname`" = "fbblnxmwai1d" ]; then
        SUBJECT="Dev"
        TEMP_FILE=
       dir=
        



else
  echo "This script only support "
  exit 1
fi



> /$TEMP_FILE/tmp_file1.txt
> /$TEMP_FILE/tmp_ffs_feed_arival_status_`hostname`_${running_mode}.txt
#> /$TEMP_FILE/tmp_file2.txt

 
#cd $dir




  if [ $running_mode == 'once' ];then
echo " once runing"


for file in `ls -ltr {*JRNL*,*MERGED*,*BASIS*,*FCDABAL*}| egrep -v 'JDL|.disp|MO|MY' |awk '{print $9}'`;
do ls -lrt ${file}|awk '{print ""$9"|"$6"/"$7"|"$8"|"$6"/"$7""" """$8"|"$9"|"$5"|"d}' d="$(date '+%Y/%m/%d %H:%M:%S')";done > /$TEMP_FILE/tmp_ffs_feed_arival_status_`hostname`_${running_mode}.txt



     cat /$TEMP_FILE/tmp_ffs_feed_arival_status_`hostname`_${running_mode}.txt | awk -F"|" BEGIN'{OFS="|"}{print $1,$2,$3,$4,$5,$6,$7}'|sed 's/_/|/1' |awk -F"|" -v OFS="|" '{if($1=="FMS") {a=$1"_"$2;b==" "; print b,a,$5,$3,$4,$7,$6,$8;} else if($1!="FMS") print $1,$2,$5,$3,$4,$7,$6,$8;}' |awk -F'|' -v OFS='|' '{gsub(/[0-9]/,"",$2)}8'| sed 's/_T_/./g'|sed 's/__T././g' |awk -F"|" BEGIN'{OFS="|"}{print $2,$3,$4,$5,$1,$6,$7,$8}'|awk -F'[_.]' -v OFS="|" '{z=$3; print $0,z}'|cut -d"|" -f1-9 | awk -F "|" -v OFS="|" '{if($9=="DLY") {y=substr($1,5,2); print $1,$2,$3,$4,$5,$6,$7,$8,y;} else if($9!="DLY") print $0;}'|cut -d"|" -f1-9 | awk -F "|" -v OFS="|" '{if($9=="CP") {c=substr($1,8,2); print $1,$2,$3,$4,$5,$6,$7,$8,c;} else if($9!="CP") print $0;}' | cut -d"|" -f1-9 |awk -F "|" -v OFS="|" '{if($9=="JRNL") {i=substr($1,1,2);print $1,$2,$3,$4,$5,$6,$7,$8,i;} else if($9!="JRNL") print $0;}'|awk -F'[_.]' -v OFS="|" '{s=$1; print $0,s}' |cut -d"|" -f1-9 |awk -F "|" -v OFS="|" '{if($9=="journal") {j=substr($1,19,2);print $1,$2,$3,$4,$5,$6,$7,$8,j;} else if($9!="journal") print $0;}'|cut -d"|" -f1-9 |awk -F "|" -v OFS="|" '{if($9=="ICG") {g=substr($1,1,2);print $1,$2,$3,$4,$5,$6,$7,$8,g;} else if($9!="ICG") print $0;}' | awk -F'[_.]' -v OFS="|" '{s=$1; print $0,s}' |
  cut -d"|" -f1-10 | awk -F "|" -v OFS="|" '{
 if($10=="Fgl" || $10=="Ficc") {n="Flex";print $1,$2,$3,$4,$5,$6,$7,$8,$9,n;} 
  else { 
   if($1=="FMS_CPBHK_DLY_JRNL_DETAIL.dat.gz" || $1=="FMS_CPBSG_DLY_JRNL_DETAIL.dat.gz") {n="CPB";print $1,$2,$3,$4,$5,$6,$7,$8,$9,n;} 
  else print $0;}}' | cut -d"|" -f1-10 | awk -F "|" -v OFS="|" '{  
 if($10=="IN" || $10=="MY" || $10=="BD" || $10=="AU" || $10=="NZ" || $10=="ID" || $10=="LK" || $10=="PH" || $10=="TH" || $10=="VN" || $10=="TW") {b=substr($1,4,6); print $1,$2,$3,$4,$5,$6,$7,$8,$9,b;} else print $0;}'| awk -F "|" -v OFS="|" '{print $9,$10,$1,$2,$3,$4,$5,$6,$7}'| sed 's/dat_/dat/g'|awk -F"|" -v OFS="|" '{z=$2; print $0,z}' | awk -F "|" -v OFS="|" '{
 if($3=="FMS_TW_DLY_JRNL_DETAIL.dat.gz" || $3=="FMS_CPBHK_DLY_JRNL_DETAIL.dat.gz" || $3=="FMS_CPBSG_DLY_JRNL_DETAIL.dat.gz") {n="FMS (Non-Rainbow)";print $1,$2,$3,$4,$5,$6,$7,$8,$9,n;} 
 else {
 if($3=="FMS_CN_DLY_JRNL_DETAIL_FIXEDLEN_FMS.dat" || $3=="FMS_CN_DLY_JRNL_DETAIL_FIXEDLEN_PPGL.dat" || $3=="FMS_CN_DLY_JRNL_DETAIL_FMS.dat" || $3=="FMS_CN_DLY_JRNL_DETAIL_PPGL.dat" || $3=="FMS_PH_DLY_JRNL_DETAIL_FMS.dat" || $3=="FMS_PH_DLY_JRNL_DETAIL_PPGL.dat" || $3=="FMS_SG_DLY_JRNL_DETAIL_FMS.dat" || $3=="FMS_TH_DLY_JRNL_DETAIL_FMS.dat" || $3=="FMS_TH_DLY_JRNL_DETAIL_PPGL.dat" || $3=="FMS_SG_DLY_JRNL_DETAIL_PPGL.dat" || $3=="FMS_VN_DLY_JRNL_DETAIL_FMS.dat" || $3=="FMS_VN_DLY_JRNL_DETAIL_PPGL.dat") {n="FMS (Rainbow)";print $1,$2,$3,$4,$5,$6,$7,$8,$9,n;} 
 
 else {
 if($3=="Ficc_accent_CN.dat" || $3=="Ficc_accent_SG.dat" || $3=="Ficc_accent_IN.dat" || $3=="Ficc_accent_TW.dat") {n="Flex PP";print $1,$2,$3,$4,$5,$6,$7,$8,$9,n;}
 
 else {
 if($10=="Flex") {n="Flexcube";print $1,$2,$3,$4,$5,$6,$7,$8,$9,n;}
 else print $0;}}}}' | awk -F "|" -v OFS="|" '{
if($1=="PH" && $10=="FMS (Rainbow)") {n="161604";print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,n;} 
else {
 if($1=="TH" && $10=="FMS (Rainbow)") {n="166207";print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,n;} 

else {
 if($1=="CN" && $10=="FMS (Rainbow)") {n="164737";print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,n;} 

else {
  if($1=="SG" && $10=="FMS (Rainbow)") {n="166174";print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,n;} 
 
else {
  if($1=="VN" && $10=="FMS (Rainbow)") {n="166219";print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,n;} 
  
else {
  if(($1=="CN" || $1=="IN" || $1=="SG" || $1=="TW") && $10=="Flex PP")
          {n="163468";print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,n;}
          
else {
 if(($1=="CN" || $1=="IN" || $1=="SG" || $1=="TW" || $1=="TH" || $1=="VN" || $1=="PH") && $10=="Flexcube")
          {n="34930";print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,n;}

 else {
        if($1=="SG" && $10=="FMS (Non-Rainbow)" ) {n="152959";print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,n;}
else {
        if($1=="HK" && $10=="FMS (Non-Rainbow)" ) {n="152958";print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,n;}
else {
        if($1=="TW" && $10=="FMS (Non-Rainbow)" ) {n="151950";print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,n;}

  else print $0;}}}}}}}}}}'| awk -F"|" 'BEGIN{OFS="|"}{print "Asia",$1,$2,$10,$11,$3,"",$4,$5,"",$6,"","",$7,$8,$9}' | awk -F "|" -v OFS="|" '{
if($2=="VN" && $3=="Flex" && $4=="Flexcube" && $5=="34930") {s="3:00";print $1,$2,$3,$4,$5,$6,s,$8,$9,$10,$11,$12,$13,$14,$15,$16;} 

#SLA Time defined here

else
{
if(($2=="VN" || $2=="PH" || $2=="SG" || $2=="TH") && ($3=="FMS" || $3=="Flex") && ($4=="FMS (Rainbow)" || $4=="Flexcube" || $4=="Flex PP") && ($5=="166219" || $5=="161604" || $5=="34930" || $5=="163468" || $5=="166174" || $5=="166207") && ($6=="FMS_VN_DLY_JRNL_DETAIL_PPGL.dat" || $6=="FMS_PH_DLY_JRNL_DETAIL_PPGL.dat"  || $6=="FMS_TH_DLY_JRNL_DETAIL_PPGL.dat" || $6=="FMS_SG_DLY_JRNL_DETAIL_PPGL.dat" || $6=="Flex_custacc_SG.dat" || $6=="Flex_accent_SG.dat" || $6=="Fgl_accent_SG.dat" || $6=="Ficc_accent_SG.dat")) {s="4:00";print $1,$2,$3,$4,$5,$6,s,$8,$9,$10,$11,$12,$13,$14,$15,$16;}

else
{ 
if($2=="CN" && ($3=="Flex" || $3=="FMS") && ($4=="FMS (Rainbow)" || $4=="Flex PP" || $4=="Flexcube") && ($5=="34930" || $5=="163468" || $5=="164737")) {s="4:00";print $1,$2,$3,$4,$5,$6,s,$8,$9,$10,$11,$12,$13,$14,$15,$16;}
else
{
 if($2=="PH" && $3=="Flex" && $4=="Flexcube" && $5=="34930") {s="4:30";print $1,$2,$3,$4,$5,$6,s,$8,$9,$10,$11,$12,$13,$14,$15,$16;} 
else
{
if($2=="TW" && $3=="Flex" && ($4=="Flexcube" || $4=="Flex PP") && ($5=="34930" || $5=="163468")) {s="5:00";print $1,$2,$3,$4,$5,$6,s,$8,$9,$10,$11,$12,$13,$14,$15,$16;}
else
{
 if($2=="TH" && $3=="Flex" && $4=="Flexcube" && $5=="34930") {s="5:30";print $1,$2,$3,$4,$5,$6,s,$8,$9,$10,$11,$12,$13,$14,$15,$16;} 
else
{
 if(($2=="SG" || $2=="HK") && $3=="CPB" && $4=="FMS (Non-Rainbow)" && ($5=="152959" || $5=="152958") && ($6=="FMS_CPBSG_DLY_JRNL_DETAIL.dat.gz" || $6=="FMS_CPBHK_DLY_JRNL_DETAIL.dat.gz")) {s="5:45";print $1,$2,$3,$4,$5,$6,s,$8,$9,$10,$11,$12,$13,$14,$15,$16;}
else
{
if(($2=="PH" || $2=="SG" || $2=="TH" || $2=="TW" || $2=="VN") && $3=="FMS" && ($4=="FMS (Rainbow)" || $4=="FMS (Non-Rainbow)") && ($5=="161604" || $5=="166174" || $5=="166207" || $5=="151950" || $5=="166219") && ($6=="FMS_PH_DLY_JRNL_DETAIL_FMS.dat" || $6=="FMS_SG_DLY_JRNL_DETAIL_FMS.dat" || $6=="FMS_TH_DLY_JRNL_DETAIL_FMS.dat" || $6=="FMS_TW_DLY_JRNL_DETAIL.dat.gz" || $6=="FMS_VN_DLY_JRNL_DETAIL_FMS.dat")) {s="6:00";print $1,$2,$3,$4,$5,$6,s,$8,$9,$10,$11,$12,$13,$14,$15,$16;}
else
{
if($2=="IN" && $3=="Flex" && ($4=="Flex PP" || $4=="Flexcube") && ($5=="34930" || $5=="163468")) {s="7:30";print $1,$2,$3,$4,$5,$6,s,$8,$9,$10,$11,$12,$13,$14,$15,$16;}

else {
if($4=="FCCACMIS" || $4=="OLV" || $4=="OEITR" || $4=="FCDABAL" || $4=="JP" || $4=="SHIWAK") {n="50327";print $1,"JP","FLEX",$4,n,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16;}


#SLA time define here ended
else print $0;}}}}}}}}}}'  >> /$TEMP_FILE/ffs_source_feed_arival_status_`hostname`_${DEEP_STAT}.csv



 if [ "`hostname`" = "" -o "`hostname`" = "" ];then 
 cd /path
 ls -ltr *CN_DLY_JRNL_DETAIL* |awk -F" " 'BEGIN{OFS="|"}{print "Asia","CN","FMS","FMS (Rainbow)","164737",$9,"4:00",$6"/"$7" "$8,$6"/"$7,"",$8,"","","",$5,$9}'| awk -F'|' -v OFS='|' '{ gsub(/[0-9]/,"",$6);print}'| sed 's/dat_/dat/1' >> /$TEMP_FILE/ffs_source_feed_arival_status_`hostname`_${DEEP_STAT}.csv

 fi
fi



#for sending Mail to ffs Team.
FILE1=/${TEMP_FILE}/ffs_source_feed_arival_status_`hostname`_${DEEP_STAT}.csv
FILE2=/${TEMP_FILE}/tmp_ffs_feed_arival_status_`hostname`_${running_mode}.txt
echo "Dump Updated script ran Successfully | sending mail ...."
echo -e "Hi FFS Team, \n\n\n Updated DUMP Placed Here: $TEMP_FILE \n\n\n\n THANKS & REGARDS\n FFS Tech Team" | mailx -s "Updated Dump Ran Successfully in $SUBJECT For COB:$DATE" -a $FILE1 -a $FILE2 -r $SENDER_DL $TECH_DL test@gmail.com

#/bin/rm /$TEMP_FILE/ffs_source_feed_arival_status_`hostname`_${DEEP_STAT}.csv
/bin/rm /$TEMP_FILE/tmp_file1.txt
#/bin/rm /$TEMP_FILE/tmp_file2.txt
/bin/rm /$TEMP_FILE/tmp_ffs_feed_arival_status_`hostname`_${running_mode}.txt
