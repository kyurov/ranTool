#!/usr/bin/env bash

# Download this script from the link:
urlGitHub=https://github.com/kyurov/ranTool.git
currentVersion=3.0
welcomeMessage="#, ,#"
welcomeMessage+="\n#,IT IS ALWAYS RECOMMENDED TO USE THE LATEST VERSION OF THE SCRIPT,#"
welcomeMessage+="\n#, ,#"
welcomeMessage+="\n#,You can download the latest version script from the link: $urlGitHub,#"
welcomeMessage+="\n#, ,#"
welcomeMessage+="\n#,Сurrent version of the script: "$currentVersion",#"
welcomeMessage+="\n#, ,#"
scriptName=$0
scriptAction=$1
collectionName=$3
hostName=$(gawk 'BEGIN {FS="="}/web_host_default=/{print toupper($2)}' /ericsson/tor/data/global.properties | gawk 'BEGIN {FS="."}{print $3,$1}')
host_Name=$(echo $hostName | sed 's/ /-/g')
startTime=$(date +%s)
timeDate=$(date "+%d-%b-%Y_T%H-%M-%S")
yearWeek=$(date "+Y%yW%V")
auditFile=auditENM_${host_Name}_${timeDate}.csv
swUpgradeDirectory=~/swUpgrade_${yearWeek}
enmCliFunctions=("enmCliBsc" "enmCliRnc" "enmCliBts" "enmCliRbs" "enmCliErbs" "enmCliRadioNode")
auditFileBeforeUpgrade=${swUpgradeDirectory}/auditBeforeUpgrade_${collectionName}.csv
auditFileAfterUpgrade=${swUpgradeDirectory}/auditAfterUpgrade_${collectionName}_${timeDate}.csv
pingIpLog=${swUpgradeDirectory}/pingIpLog_${collectionName}_${timeDate}.log
alarmsBeforeUpgrade=${swUpgradeDirectory}/alarmsBeforeUpgrade_${collectionName}.csv
abisTsState=${swUpgradeDirectory}/abisTsState_${collectionName}_${timeDate}.csv
joinAlarmsBeforeUpgrade=joinAlarmsBeforeUpgrade_${collectionName}_${timeDate}.audit
alarmsAfterUpgrade=${swUpgradeDirectory}/alarmsAfterUpgrade_${collectionName}_${timeDate}.csv
joinAlarmsAfterUpgrade=joinAlarmsAfterUpgrade_${collectionName}_${timeDate}.audit
alarmsCompare=${swUpgradeDirectory}/alarmsCompare_${collectionName}_${timeDate}.csv
tempAuditFile=tempAuditFile_${timeDate}.audit

declareVariablesForPython () {
	export radionodeNetworkPrint=radionodeNetwork_${timeDate}.audit
	export radionodeNetworkPrintGawk=gawk_${radionodeNetworkPrint}_${timeDate}.audit
	export radionodeConnectivityPrint=radionodeConnectivity_${timeDate}.audit
	export radionodeConnectivityPrintGawk=gawk_${radionodeConnectivityPrint}_${timeDate}.audit
	export radionodeProductPrint=radionodeProduct_${timeDate}.audit
	export radionodeProductPrintGawk=gawk_${radionodeProductPrint}_${timeDate}.audit
	export radionodeLicensePrint=radionodeLicense_${timeDate}.audit
	export radionodeLicensePrintGawk=gawk_${radionodeLicensePrint}_${timeDate}.audit
	export radionodeJoinConnectivityNetwork=radionodeJoinConnectivityNetwork_${timeDate}.audit
	export radionodeJoinConnectivityNetworkProduct=radionodeJoinConnectivityNetworkProduct_${timeDate}.audit
	export radionodeJoin=radionodeJoin_${timeDate}.audit
	#####################################################################################################
	export rbsNetworkPrint=rbsNetwork_${timeDate}.audit
	export rbsNetworkPrintGawk=gawk_${rbsNetworkPrint}_${timeDate}.audit
	export rbsConnectivityPrint=rbsConnectivity_${timeDate}.audit
	export rbsConnectivityPrintGawk=gawk_${rbsConnectivityPrint}_${timeDate}.audit
	export rbsProductPrint=rbsProduct_${timeDate}.audit
	export rbsProductPrintGawk=gawk_${rbsProductPrint}_${timeDate}.audit
	export rbsLicensePrint=rbsLicense_${timeDate}.audit
	export rbsLicensePrintGawk=gawk_${rbsLicensePrint}_${timeDate}.audit
	export rbsHardwarePrint=rbsHardware_${timeDate}.audit
	export rbsHardwarePrintGawk=gawk_${rbsHardwarePrint}_${timeDate}.audit
	export rbsJoinConnectivityNetwork=rbsJoinConnectivityNetwork_${timeDate}.audit
	export rbsJoinConnectivityNetworkProduct=rbsJoinConnectivityNetworkProduct_${timeDate}.audit
	export rbsJoinConnectivityNetworkProductLicense=rbsJoinConnectivityNetworkProductLicense_${timeDate}.audit
	export rbsJoin=rbsJoin_${timeDate}.audit
	#####################################################################################################
	export erbsNetworkPrint=erbsNetwork_${timeDate}.audit
	export erbsNetworkPrintGawk=gawk_${erbsNetworkPrint}_${timeDate}.audit
	export erbsConnectivityPrint=erbsConnectivity_${timeDate}.audit
	export erbsConnectivityPrintGawk=gawk_${erbsConnectivityPrint}_${timeDate}.audit
	export erbsProductPrint=erbsProduct_${timeDate}.audit
	export erbsProductPrintGawk=gawk_${erbsProductPrint}_${timeDate}.audit
	export erbsLicensePrint=erbsLicense_${timeDate}.audit
	export erbsLicensePrintGawk=gawk_${erbsLicensePrint}_${timeDate}.audit
	export erbsHardwarePrint=erbsHardware_${timeDate}.audit
	export erbsHardwarePrintGawk=gawk_${erbsHardwarePrint}_${timeDate}.audit
	export erbsJoinConnectivityNetwork=erbsJoinConnectivityNetwork_${timeDate}.audit
	export erbsJoinConnectivityNetworkProduct=erbsJoinConnectivityNetworkProduct_${timeDate}.audit
	export erbsJoinConnectivityNetworkProductLicense=erbsJoinConnectivityNetworkProductLicense_${timeDate}.audit
	export erbsJoin=erbsJoin_${timeDate}.audit
	#####################################################################################################
	export rncNetworkPrint=rncNetwork_${timeDate}.audit
	export rncNetworkPrintGawk=gawk_${rncNetworkPrint}_${timeDate}.audit
	export rncConnectivityPrint=rncConnectivity_${timeDate}.audit
	export rncConnectivityPrintGawk=gawk_${rncConnectivityPrint}_${timeDate}.audit
	export rncProductPrint=rncProduct_${timeDate}.audit
	export rncProductPrintGawk=gawk_${rncProductPrint}_${timeDate}.audit
	export rncLicensePrint=rncLicense_${timeDate}.audit
	export rncLicensePrintGawk=gawk_${rncLicensePrint}_${timeDate}.audit
	export rncCellQtyPrint=rncCellQtyPrint_${timeDate}.audit
	export rncCellQtyPrintGawk=gawk_${rncCellQtyPrint}_${timeDate}.audit
	export rncJoinConnectivityNetwork=rncJoinConnectivityNetwork_${timeDate}.audit
	export rncJoinConnectivityNetworkProduct=rncJoinConnectivityNetworkProduct_${timeDate}.audit
	export rncJoinConnectivityNetworkProductLicense=rncJoinConnectivityNetworkProductLicense_${timeDate}.audit
	export rncJoin=rncJoin_${timeDate}.audit
	#####################################################################################################
	export bscNetworkPrint=bscNetwork_${timeDate}.audit
	export bscNetworkPrintGawk=gawk_${bscNetworkPrint}_${timeDate}.audit
	export bscConnectivityPrint=bscConnectivity_${timeDate}.audit
	export bscConnectivityPrintGawk=gawk_${bscConnectivityPrint}_${timeDate}.audit
	export bscProductPrint=bscProduct_${timeDate}.audit
	export bscProductPrintGawk=gawk_${bscProductPrint}_${timeDate}.audit
	export bscLicensePrint=bscLicense_${timeDate}.audit
	export bscLicensePrintGawk=gawk_${bscLicensePrint}_${timeDate}.audit
	export bscCellQtyPrint=bscCellQtyPrint_${timeDate}.audit
	export bscCellQtyPrintGawk=gawk_${bscCellQtyPrint}_${timeDate}.audit
	export bscJoinConnectivityNetwork=bscJoinConnectivityNetwork_${timeDate}.audit
	export bscJoinConnectivityNetworkProduct=bscJoinConnectivityNetworkProduct_${timeDate}.audit
	export bscJoinConnectivityNetworkProductLicense=bscJoinConnectivityNetworkProductLicense_${timeDate}.audit
	export bscJoinConnectivityNetworkProductLicenseCellQty=bscJoinConnectivityNetworkProductLicenseCellQty_${timeDate}.audit
	export bscOtherBladePrint=bscOtherBlade_${timeDate}.audit
	export bscOtherBladePrintGawk=gawk_bscOtherBlade_${timeDate}.audit
	export bscHardwareBladePrint=bscHardwareBlade_${timeDate}.audit
	export bscTrafBoardGawk=gawk_bscTrafBoard_${timeDate}.audit
	export bscApBoardGawk=gawk_bscApBoard_${timeDate}.audit
	export bscJoinSwitchTrafBoard=bscJoinSwitchTrafBoard_${timeDate}.audit
	export bscJoinSwitchTrafBoardGawk=gawk_bscJoinSwitchTrafBoardGawk_${timeDate}.audit
	export bscJoinSwitchTrafApBoard=bscJoinSwitchTrafApBoard_${timeDate}.audit
	export bscJoinSwitchTrafApBoardGawk=gawk_bscJoinSwitchTrafApBoard_${timeDate}.audit
	export bscJoin=bscJoin_${timeDate}.audit
	#####################################################################################################
	export bscG12TgPrint=bscG12Tg_${timeDate}.audit
	export btsJoin=btsJoin_${timeDate}.audit
}

cleanUpFolder () {
	rm *_${timeDate}.audit
}

cleanPrintoutNetwork () {
	#gawk '/SubNetwork/{gsub("OT AV","OT_AV");gsub(", ","_");gsub(",",">");gsub("identity=|NetworkElement=|revision=","");print $0}' $1
	gawk '(NF>4)&&$1!~/odeId/&&$2!~/syncStatus/{gsub("OT AV","OT_AV");gsub(", ","_");gsub(",",">");gsub("identity=|NetworkElement=|revision=","");print $0}' $1
}

cleanAndParsHardwarePrintout () {
	gawk 'BEGIN{OFS=","}/slotNo=1.*productNumber=KDU/{print $1,$0}' $1 |
	gawk 'BEGIN{FS=OFS=","}{print $1,$5,$6}' |
	gawk 'BEGIN{FS=",|}";OFS=","}{if($2~/productName=/)prodName=$2;else prodName=$3;print $1,prodName}' |
	gawk 'BEGIN{FS=",";OFS=" "}{gsub(" productName=","",$2);gsub(" ","",$2);print $1,$2}'
}

enmCliBsc () {
python -c '
import os
import enmscripting
import sys
reload(sys)
sys.setdefaultencoding("utf8")
session = enmscripting.open()
term = session.terminal()

bscNetwork = "cmedit get * networkelement.(neProductVersion,neType,ossPrefix,release,technologyDomain,timeZone) --netype=BSC -t -s"
fileOut = open(os.environ["bscNetworkPrint"], "w")
fileOut.write(str(term.execute(bscNetwork)))
fileOut.close()

bscConnectivity = "cmedit get * BscConnectivityInformation.ipAddress --netype=BSC -t"
fileOut = open(os.environ["bscConnectivityPrint"], "w")
fileOut.write(str(term.execute(bscConnectivity)))
fileOut.close()

bscProduct = "cmedit get * ManagedElement.managedElementType --netype=BSC -t"
fileOut = open(os.environ["bscProductPrint"], "w")
fileOut.write(str(term.execute(bscProduct)))
fileOut.close()

bscLicense = "cmedit get * LicenseInventory.fingerprint --netype=BSC -t"
fileOut = open(os.environ["bscLicensePrint"], "w")
fileOut.write(str(term.execute(bscLicense)))
fileOut.close()

bscCellQty = "cmedit get * GeranCell.(geranCellId,state) --netype=BSC -t"
fileOut = open(os.environ["bscCellQtyPrint"], "w")
fileOut.write(str(term.execute(bscCellQty)))
fileOut.close()

bscOtherBlade = "cmedit get * OtherBlade.(OtherBladeId==0,bladeProductNumber,functionalBoardName) -t --netype=BSC"
fileOut = open(os.environ["bscOtherBladePrint"], "w")
fileOut.write(str(term.execute(bscOtherBlade)))
fileOut.close()

bscHardwareBlade = "cmedit get * HardwareBlade.(hardwaretype,boardname,unitLocation,administrativeData) -t --netype=BSC"
fileOut = open(os.environ["bscHardwareBladePrint"], "w")
fileOut.write(str(term.execute(bscHardwareBlade)))
fileOut.close()

print("## Getting data BSC.........OK")

enmscripting.close(session)
exit()'

	parsingDataBsc () {
		bscCellQtyCalc () {
			readBsc () {
				gawk '/SubNetwork=/{print $1}' $bscNetworkPrint | sort | uniq
			}
			for nameBsc in $(readBsc)
			do
				bscCellQty=$(gawk '$1~/'$nameBsc'/{cellQty++}END{
				if(cellQty~"^$")cellQty="null";
				else cellQty=cellQty;
				print cellQty}' $bscCellQtyPrint)
				echo $nameBsc $bscCellQty 
			done
		}
		bscCellQtyCalc | sed 's/\r//' > $bscCellQtyPrintGawk
		
		
		#gawk '(NF>7)&&$1!~/odeId/&&$2!~/syncStatus/{for(i=1;i<=NF;++i){if($i~"revision=[^1].[0-9].[0-9]")apgVer=$i;else apgVer="null";print $1,$2,apgVer,$(NF-4),$(NF-3),$(NF-2),$(NF-1),$NF}}' $bscNetworkPrint | not work
		
		#gawk '(NF>7)&&$1!~/odeId/&&$2!~/syncStatus/{if($3~/identity=R[0-9][A-Z]/&&$4~/revision=[0-9].[0-9].[0-9]/)bscString=$1" "$2" "$4" "$(NF-4)" "$(NF-3)" "$(NF-2)" "$(NF-1)" "$NF;else if($5~/identity=R[0-9][A-Z]/&&$6~/revision=[0-9].[0-9].[0-9]/)bscString=$1" "$2" "$6" "$(NF-4)" "$(NF-3)" "$(NF-2)" "$(NF-1)" "$NF;else if($7~/identity=R[0-9][A-Z]/&&$8~/revision=[0-9].[0-9].[0-9]/)bscString=$1" "$2" "$8" "$(NF-4)" "$(NF-3)" "$(NF-2)" "$(NF-1)" "$NF;else if($8~/identity=R[0-9][A-Z]/&&$9~/revision=[0-9].[0-9].[0-9]/)bscString=$1" "$2"_"$3" "$9" "$(NF-4)" "$(NF-3)" "$(NF-2)" "$(NF-1)" "$NF;else if($3~/identity=[0-9].[0-9].[0-9]/&&$4~/revision=R[0-9][A-Z]/)bscString=$1" "$2" "$3" "$(NF-4)" "$(NF-3)" "$(NF-2)" "$(NF-1)" "$NF;else bscString=$1" "$2" null "$(NF-4)" "$(NF-3)" "$(NF-2)" "$(NF-1)" "$NF;gsub("},","",bscString);gsub(", BSC"," BSC",bscString);print bscString}' $bscNetworkPrint | cleanPrintoutNetwork | sed 's/\r//' | sort -s -k 1,1 > $bscNetworkPrintGawk
		gawk '(NF>7)&&$1!~/odeId/&&$2!~/syncStatus/{if($3~/identity=R[0-9][A-Z]/&&$4~/revision=[0-9].[0-9].[0-9]/)apgVer=$4;else if($5~/identity=R[0-9][A-Z]/&&$6~/revision=[0-9].[0-9].[0-9]/)apgVer=$6;else if($7~/identity=R[0-9][A-Z]/&&$8~/revision=[0-9].[0-9].[0-9]/)apgVer=$8;else if($8~/identity=R[0-9][A-Z]/&&$9~/revision=[0-9].[0-9].[0-9]/)apgVer=$9;else if($3~/identity=[0-9].[0-9].[0-9]/&&$4~/revision=R[0-9][A-Z]/)apgVer=$3;else apgVer="null";print $1,$2,apgVer,$(NF-4),$(NF-3),$(NF-2),$(NF-1),$NF}' $bscNetworkPrint | sed 's/}]//g;s/, BSC/ BSC/g;s/\[{//g' | cleanPrintoutNetwork | sed 's/\r//' | sort -s -k 1,1 > $bscNetworkPrintGawk
			
		gawk '$2~/^[0-9]/&&$3~/^[0-9]/{print $1,$3}' $bscConnectivityPrint | sed 's/\r//' | sort -s -k 1,1 > $bscConnectivityPrintGawk
		gawk '$4~/^[SubNetwork]/{print $1,$5}' $bscProductPrint | sed 's/\r//' | sort -s -k 1,1 > $bscProductPrintGawk
		gawk '$2~/^[0-9]/&&$3~/^[0-9]/{print $1,$4}' $bscLicensePrint | sed 's/\r//' | sort -s -k 1,1 > $bscLicensePrintGawk
		join $bscConnectivityPrintGawk $bscNetworkPrintGawk > $bscJoinConnectivityNetwork
		join -a 1 $bscJoinConnectivityNetwork $bscProductPrintGawk | gawk '{if(NF==9)stringBsc=$0" null";else stringBsc=$0;print stringBsc}' > $bscJoinConnectivityNetworkProduct
		join -a 1 $bscJoinConnectivityNetworkProduct $bscLicensePrintGawk | gawk '{if(NF==10)stringBsc=$0" null";else stringBsc=$0;print stringBsc}' > $bscJoinConnectivityNetworkProductLicense
		join $bscJoinConnectivityNetworkProductLicense $bscCellQtyPrintGawk > $bscJoinConnectivityNetworkProductLicenseCellQty
		
		## Switch board
		gawk '$7~/.2.0.4$/&&$8~/^0$/&&$NF~/^0$/{print $1,$10}' $bscOtherBladePrint | sort -s -k 1,1 > $bscOtherBladePrintGawk
		
		## Traffic board
		gawk '{if($8~/EPB/)trafBoard="EPB";else if($9~/EPB/)trafBoard="EPB";else if($8$9~/.*208.*459/)trafBoard="GARP";else trafBoard="";print $1,trafBoard}' $bscHardwareBladePrint | sort | uniq | egrep -i 'epb|garp' | sort -s -k 1,1 > $bscTrafBoardGawk
		
		join -a 1 $bscOtherBladePrintGawk $bscTrafBoardGawk > $bscJoinSwitchTrafBoard
		join -a 2 $bscOtherBladePrintGawk $bscTrafBoardGawk >> $bscJoinSwitchTrafBoard
		
		gawk '{print $1,$2"-"$3}' $bscJoinSwitchTrafBoard | sort -s -k 1,1 | uniq |
		gawk '{if($2~/SCB_RP/)bscType="HD<-<BSC";
			else if($2~/SCXB-GARP/)bscType="EvoC8100";
			else if($2~/SCXB-EPB/)bscType="EvoC8200";
			else if($2~/SMXB-EPB/)bscType="EvoC8230";
			else bscType="null";
			print $1,bscType}' | sort -s -k 1,1 > $bscJoinSwitchTrafBoardGawk 
		
		## APG board
		gawk '$2~/^1$/&&$3~/^1$/&&$(NF-1)~/AP/&&$NF~/12/{gsub("productNumber=","");gsub("\\}","");apProdNum=$7$8$9;if(apProdNum~"ROJ208840/11")apBoard="APUB";else if(apProdNum~"ROJ208841/21")apBoard="APUB2";else if(apProdNum~"ROJ208841/2")apBoard="GEP2";else if(apProdNum~"ROJ208840/5")apBoard="GEP5";else if(apProdNum~"ROJ208842/5")apBoard="GEP5";else if(apProdNum~"ROJ208867/5")apBoard="GEP5";else if(apProdNum~"ROJ208862/7")apBoard="GEP7";else if(apProdNum~"ROJ208864/7")apBoard="GEP7";else apBoard="null";print $1,apBoard}' $bscHardwareBladePrint | sort -s -k 1,1 > $bscApBoardGawk
		
		join -a 1 $bscJoinSwitchTrafBoardGawk $bscApBoardGawk > $bscJoinSwitchTrafApBoard
		join -a 2 $bscJoinSwitchTrafBoardGawk $bscApBoardGawk >> $bscJoinSwitchTrafApBoard
		
		cat $bscJoinSwitchTrafApBoard | sed 's/\r//' | sort -s -k 1,1 | uniq > $bscJoinSwitchTrafApBoardGawk
		
		join $bscJoinConnectivityNetworkProductLicenseCellQty $bscJoinSwitchTrafApBoardGawk	|
		gawk '
			BEGIN {OFS=","}
			{print $1,$2,$3,$4,$5,$7,$8,$9,$10,$11,$12,$13,$14,$6}' | 
		gawk '
			BEGIN {FS=",|>";OFS=","}
			{if($13~/^APUB$/)apgType="APG43/1";
			else if($13~/^APUB2$|^GEP2$/)apgType="APG43/2";
			else if($13~/^GEP5$/)apgType="APG43/3";
			else if($13~/^GEP7$/)apgType="APG43/4";
			else apgType=$13;
			nodeId=$1;
			ipAddress=$2;
			syncStatus=$3;
			controllingRnc="null";
			controllingBsc="null";
			neProductVersion=$6" (CP)<-</<-<"$4" (APG43L)";
			if(neProductVersion~"null.*null")neProductVersion="null";
			else neProductVersion=neProductVersion;
			neType=$5;
			ossPrefix=$(NF-1);
			technologyDomain=$7;
			timeZone=$8;
			bscType=$12"-"apgType;
			if(bscType~/HD<-<BSC-APG43\/1/)productName=$12"<-<R1";
			else if(bscType~/HD<-<BSC-APG43\/2/)productName=$12;
			else if(bscType~/EvoC8100-APG43\/2/)productName=$12;
			else if(bscType~/EvoC8200-APG43\/2/)productName=$12"<-<R1";
			else if(bscType~/EvoC8200-APG43\/3/)productName=$12"<-<R2";
			else if(bscType~/EvoC8230-APG43\/3/)productName=$12"<-<R1";
			else if(bscType~/EvoC8230-APG43\/4/)productName=$12"<-<R2";
			else productName=bscType;
			fingerprint=$10;
			cellQty=$11;
			sigDel="null";
			tMode="null";
			print nodeId,"'"$host_Name"'",syncStatus,ipAddress,neType,productName,neProductVersion,fingerprint,timeZone,ossPrefix,technologyDomain,controllingRnc,controllingBsc,cellQty,sigDel,tMode}'
	}
	parsingDataBsc | sed 's/\r//' > $bscJoin
}

enmCliRnc () {
python -c '
import os
import enmscripting
import sys
reload(sys)
sys.setdefaultencoding("utf8")
session = enmscripting.open()
term = session.terminal()

rncNetwork = "cmedit get * networkelement.(neProductVersion,neType,ossPrefix,technologyDomain,timeZone) --netype=RNC -t -s"
fileOut = open(os.environ["rncNetworkPrint"], "w")
fileOut.write(str(term.execute(rncNetwork)))
fileOut.close()

rncConnectivity = "cmedit get * CppConnectivityInformation.ipAddress --netype=RNC -t"
fileOut = open(os.environ["rncConnectivityPrint"], "w")
fileOut.write(str(term.execute(rncConnectivity)))
fileOut.close()

rncProduct = "cmedit get * ManagedElement.productName --netype=RNC -t"
fileOut = open(os.environ["rncProductPrint"], "w")
fileOut.write(str(term.execute(rncProduct)))
fileOut.close()

rncLicense = "cmedit get * Licensing.fingerprint --netype=RNC -t"
fileOut = open(os.environ["rncLicensePrint"], "w")
fileOut.write(str(term.execute(rncLicense)))
fileOut.close()

rncCellQty = "cmedit get * UtranCell.(UtranCellId,iubLinkRef) --netype=RNC -t"
fileOut = open(os.environ["rncCellQtyPrint"], "w")
fileOut.write(str(term.execute(rncCellQty)))
fileOut.close()

print("## Getting data RNC.........OK")


enmscripting.close(session)
exit()'

	parsingDataRnc () {
		rncCellQtyCalc () {
			for nameRnc in $(gawk '/SubNetwork=/{print $1}' $rncNetworkPrint | sort | uniq)
			do
				rncCellQty=$(gawk '$1~/'$nameRnc'/{cellQty++}END{print cellQty}' $rncCellQtyPrint)
				if [ -n "$rncCellQty" ]
				then
					echo -e "$nameRnc $rncCellQty"
				else 
					echo -e "$nameRnc null"
			
				fi
			done
		}
		rncCellQtyCalc | sed 's/\r//' > $rncCellQtyPrintGawk
		
		cleanPrintoutNetwork $rncNetworkPrint | sed 's/\r//' | sort -s -k 1,1 > $rncNetworkPrintGawk
		gawk '$2~/^[0-9]/&&$3~/^[0-9]/{print $1,$3}' $rncConnectivityPrint | sed 's/\r//' | sort -s -k 1,1 > $rncConnectivityPrintGawk
		gawk '$3~/^[0-9]/{print $1,$4}' $rncProductPrint | sed 's/\r//' | sort -s -k 1,1 > $rncProductPrintGawk
		gawk '$2~/^[0-9]/&&$3~/^[0-9]/{print $1,$4}' $rncLicensePrint | sed 's/\r//' | sort -s -k 1,1 > $rncLicensePrintGawk
		join -a 1 $rncConnectivityPrintGawk $rncNetworkPrintGawk > $rncJoinConnectivityNetwork
		join -a 1 $rncJoinConnectivityNetwork $rncProductPrintGawk > $rncJoinConnectivityNetworkProduct
		join -a 1 $rncJoinConnectivityNetworkProduct $rncLicensePrintGawk > $rncJoinConnectivityNetworkProductLicense
		join -a 1 $rncJoinConnectivityNetworkProductLicense $rncCellQtyPrintGawk |
		gawk '
			BEGIN {OFS=","}
			{print $1,$2,$3,$4,$5,$7,$8,$9,$10,$11,$6}' | 
		gawk '
			BEGIN {FS=",|>";OFS=","}
			{nodeId=$1;
			ipAddress=$2;
			syncStatus=$3;
			controllingRnc="null";
			controllingBsc="null";
			neProductVersion=$4;
			neType=$5;
			ossPrefix=$(NF-1);
			technologyDomain=$6;
			timeZone=$7;
			productName=$8;
			fingerprint=$9;
			cellQty=$10;
			sigDel="null";
			tMode="null";
			print nodeId,"'"$host_Name"'",syncStatus,ipAddress,neType,productName,neProductVersion,fingerprint,timeZone,ossPrefix,technologyDomain,controllingRnc,controllingBsc,cellQty,sigDel,tMode}'
	}
	parsingDataRnc | sed 's/\r//' > $rncJoin
}

enmCliBts () {
python -c '
import os
import enmscripting
import sys
reload(sys)
sys.setdefaultencoding("utf8")
session = enmscripting.open()
term = session.terminal()

bscG12Tg = "cmedit get * G12Tg.(G12TgId,g12TgId,moAdmState,rSite,sigDel,swVer,swVerAct,swVerDld,tMode) --netype=BSC -t -s"
fileOut = open(os.environ["bscG12TgPrint"], "w")
fileOut.write(str(term.execute(bscG12Tg)))
fileOut.close()

print("## Getting data BTS.........OK")


enmscripting.close(session)
exit()'

	parsingDataBts () {
		gawk '
			BEGIN {OFS=","}
			$3~/^[0-9]/&&$4~/^[0-9]/{
			nodeId=$9;
			ipAddress="RXOTG-"$7;
			syncStatus=$8;
			controllingRnc="null";
			controllingBsc=$1;
			swVerAct=$12;
			if(swVerAct=="B0702R025E"){neProductVersion="G10A ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="B0702R025J"){neProductVersion="G10A_1 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="B0703R027F"){neProductVersion="G10B ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="B0704R029E"){neProductVersion="G11A ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="B1305R061E"){neProductVersion="G11B ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B1306R063H"){neProductVersion="G12A ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B0707R035F"){neProductVersion="G12A.1 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="B1307R065H"){neProductVersion="G12A.1 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B1307R066H"){neProductVersion="G12A.2 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B0707R035H"){neProductVersion="G12A.2 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="B1307R067C"){neProductVersion="G12A.3 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B1308R069G"){neProductVersion="G12B ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B0708R039E"){neProductVersion="G12B ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="B1309R071H"){neProductVersion="G13A ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B0709R041F"){neProductVersion="G13A ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="B0709R041G"){neProductVersion="G13A ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="B1309R071K"){neProductVersion="G13A.1 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B0710R043D"){neProductVersion="G13B ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="B1310R073F"){neProductVersion="G13B ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B1410R078G"){neProductVersion="G14A ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B1311R075J"){neProductVersion="G14A ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B0711R045G"){neProductVersion="G14A ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="B1312R077E"){neProductVersion="G14B ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B0712R047D"){neProductVersion="G14B ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="B1312R078F"){neProductVersion="G14B.1 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B0712R048F"){neProductVersion="G14B.1 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="B1312R078G"){neProductVersion="G14B.1.1 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B1314R081D"){neProductVersion="G15B ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B0714R051C"){neProductVersion="G15B ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="B0715R053D"){neProductVersion="G16A ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="B1315R083D"){neProductVersion="G16A ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B1315R083F"){neProductVersion="G16A1.1 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B1315R083H"){neProductVersion="G16A1.4 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B1316R087C"){neProductVersion="G16B ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B0716R057C"){neProductVersion="G16B ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="B1315R083G"){neProductVersion="G16B ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B1316R087F"){neProductVersion="G16B.11 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B1316R087D"){neProductVersion="G16B.5 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B0719R4A00"){neProductVersion="G17.Q2 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="B1319R4A00"){neProductVersion="G17.Q2 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B0719R4B00"){neProductVersion="G17.Q2.1 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="B1319R4B00"){neProductVersion="G17.Q2.1 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B1320R3B00"){neProductVersion="G17.Q3.0-1 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B0720R3A00"){neProductVersion="G17.Q3.1 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="B1320R3C00"){neProductVersion="G17.Q3.1 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B1320R03CA"){neProductVersion="G17.Q3.1-1 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B0721R1B00"){neProductVersion="G17.Q4 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="B1321R1B00"){neProductVersion="G17.Q4 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B0721R1C00"){neProductVersion="G17.Q4.0-1 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="B1321R1C00"){neProductVersion="G17.Q4.0-1 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B1321R1E00"){neProductVersion="G17.Q4.1 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B1321R01EA"){neProductVersion="G17.Q4.1-1 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B1321R1F00"){neProductVersion="G17.Q4.2 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B0721R1E00"){neProductVersion="G17.Q4.4 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="B1321R1G00"){neProductVersion="G17.Q4.4 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B0717R058D"){neProductVersion="G17A ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="B1317R088D"){neProductVersion="G17A ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B0717R058E"){neProductVersion="G17A.3 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="B1317R088E"){neProductVersion="G17A.3 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B0718R061A"){neProductVersion="G17A.7 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="B1318R091A"){neProductVersion="G17A.7 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B1322R1B00"){neProductVersion="G18.Q1 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B0722R1B00"){neProductVersion="G18.Q1 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="B1322R1C00"){neProductVersion="G18.Q1.1 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B0722R1C00"){neProductVersion="G18.Q1.1 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="B1322R1D00"){neProductVersion="G18.Q1.2 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="G18Q2G7R2B"){neProductVersion="G18.Q2 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="G18Q2G5R2B"){neProductVersion="G18.Q2 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="G18Q2G5R2C"){neProductVersion="G18.Q2.1 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="G18Q2G7R2C"){neProductVersion="G18.Q2.1 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B1323R2D00"){neProductVersion="G18.Q2.2 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B0723R2D00"){neProductVersion="G18.Q2.2 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="G18Q2G7R2D"){neProductVersion="G18.Q2.2 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="G18Q2G5R2D"){neProductVersion="G18.Q2.2 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="G18Q3G7R1B"){neProductVersion="G18.Q3 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="G18Q3G5R1B"){neProductVersion="G18.Q3 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="G18Q3G5R1C"){neProductVersion="G18.Q3.1 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="G18Q3G7R1C"){neProductVersion="G18.Q3.1 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="G18Q4G5R2B"){neProductVersion="G18.Q4 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="G18Q4G7R2C"){neProductVersion="G18.Q4.1 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="G18Q4G5R2C"){neProductVersion="G18.Q4.1 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="G19Q1G5R2D"){neProductVersion="G19.Q1.1 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="G19Q1G7R2D"){neProductVersion="G19.Q1.1 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="G19Q2G7R2D"){neProductVersion="G19.Q2.1 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="G19Q2G5R2D"){neProductVersion="G19.Q2.1 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="G19Q3G7R1C"){neProductVersion="G19.Q3 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="G19Q3G5R1C"){neProductVersion="G19.Q3 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="G19Q4G7R1C"){neProductVersion="G19.Q4 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="G19Q4G5R1C"){neProductVersion="G19.Q4 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="GBA03G7R1D"){neProductVersion="G20.Q2 GBTS01.A04 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="GBA03G5R1D"){neProductVersion="G20.Q2 GBTS01.A04 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="GBA05G5R1C"){neProductVersion="G20.Q3 GBTS01.A05 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="GBA05G7R1C"){neProductVersion="G20.Q3 GBTS01.A05 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="B1324R1C00"){neProductVersion="G18.Q3.1 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="GBA06G5R1C"){neProductVersion="G20.Q4 GBTS01.A06 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="GBA06G7R1C"){neProductVersion="G20.Q4 GBTS01.A06 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="GBA09G5R1C"){neProductVersion="G21.Q2 GBTS01.A09 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="GBA09G7R1C"){neProductVersion="G21.Q2 GBTS01.A09 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="GBA11G5R2C"){neProductVersion="G21.Q4 GBTS01.A11 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="GBA11G7R2C"){neProductVersion="G21.Q4 GBTS01.A11 ("swVerAct")";productName="RUS"}
			else if(swVerAct=="GBA14G5R5D"){neProductVersion="G22.Q3 GBTS01.A14 ("swVerAct")";productName="TRU/RUG"}
			else if(swVerAct=="GBA14G7R5D"){neProductVersion="G22.Q3 GBTS01.A14 ("swVerAct")";productName="RUS"}
			else {neProductVersion=swVerAct;productName="null"};
			neType="BTS";
			ossPrefix="null";
			technologyDomain="GSM";
			timeZone="null";
			fingerprint="null";
			cellQty="null";
			sigDel=$10;
			tMode=$14;
			print nodeId,"'"$host_Name"'",syncStatus,ipAddress,neType,productName,neProductVersion,fingerprint,timeZone,ossPrefix,technologyDomain,controllingRnc,controllingBsc,cellQty,sigDel,tMode}' $bscG12TgPrint
	}
	parsingDataBts | sort -s -k 1,1 | sed 's/\r//' > $btsJoin
}

enmCliRbs () {
python -c '
import os
import enmscripting
import sys
reload(sys)
sys.setdefaultencoding("utf8")
session = enmscripting.open()
term = session.terminal()

rbsNetwork = "cmedit get * networkelement.(neProductVersion,neType,ossPrefix,technologyDomain,timeZone,controllingRnc) --netype=RBS -t -s"
fileOut = open(os.environ["rbsNetworkPrint"], "w")
fileOut.write(str(term.execute(rbsNetwork)))
fileOut.close()

rbsConnectivity = "cmedit get * CppConnectivityInformation.ipAddress --netype=RBS -t"
fileOut = open(os.environ["rbsConnectivityPrint"], "w")
fileOut.write(str(term.execute(rbsConnectivity)))
fileOut.close()

rbsProduct = "cmedit get * ManagedElement.productName --netype=RBS -t"
fileOut = open(os.environ["rbsProductPrint"], "w")
fileOut.write(str(term.execute(rbsProduct)))
fileOut.close()

rbsLicense = "cmedit get * Licensing.fingerprint --netype=RBS -t"
fileOut = open(os.environ["rbsLicensePrint"], "w")
fileOut.write(str(term.execute(rbsLicense)))
fileOut.close()

rbsHardware = "cmedit get * Hardware.* --netype=RBS -t"
fileOut = open(os.environ["rbsHardwarePrint"], "w")
fileOut.write(str(term.execute(rbsHardware)))
fileOut.close()

print("## Getting data RBS.........OK")


enmscripting.close(session)
exit()'

	parsingDataRbs () {
		cleanPrintoutNetwork $rbsNetworkPrint | sed 's/\r//' | sort -s -k 1,1 > $rbsNetworkPrintGawk
		gawk '$2~/^[0-9]/&&$3~/^[0-9]/{print $1,$3}' $rbsConnectivityPrint | sed 's/\r//' | sort -s -k 1,1 > $rbsConnectivityPrintGawk
		gawk '$3~/^[0-9]/{print $1,$4}' $rbsProductPrint | sed 's/\r//' | sort -s -k 1,1 > $rbsProductPrintGawk
		gawk '$2~/^[0-9]/&&$3~/^[0-9]/{print $1,$4}' $rbsLicensePrint | sed 's/\r//' | sort -s -k 1,1 > $rbsLicensePrintGawk
		cleanAndParsHardwarePrintout $rbsHardwarePrint | sed 's/\r//' | sort -s -k 1,1 > $rbsHardwarePrintGawk
		join $rbsConnectivityPrintGawk $rbsNetworkPrintGawk > $rbsJoinConnectivityNetwork
		join $rbsJoinConnectivityNetwork $rbsProductPrintGawk > $rbsJoinConnectivityNetworkProduct
		join $rbsJoinConnectivityNetworkProduct $rbsLicensePrintGawk > $rbsJoinConnectivityNetworkProductLicense
		join -a 1 $rbsJoinConnectivityNetworkProductLicense $rbsHardwarePrintGawk |
		gawk '
			BEGIN {OFS=","}
			{print $1,$2,$3,$4,$5,$6,$8,$9,$10,$11,$12,$7}' | 
		gawk '
			BEGIN {FS=",|>";OFS=","}
			{nodeId=$1;
			ipAddress=$2;
			syncStatus=$3;
			controllingRnc=$4;
			controllingBsc="null";
			neProductVersion=$5;
			neType=$6;
			ossPrefix=$(NF-1);
			technologyDomain=$7;
			timeZone=$8;
			productName=$9" "$11;
			fingerprint=$10;
			cellQty="null";
			sigDel="null";
			tMode="null";
			print nodeId,"'"$host_Name"'",syncStatus,ipAddress,neType,productName,neProductVersion,fingerprint,timeZone,ossPrefix,technologyDomain,controllingRnc,controllingBsc,cellQty,sigDel,tMode}'
	}
	parsingDataRbs | sed 's/\r//' > $rbsJoin
}

enmCliErbs () {
python -c '
import os
import enmscripting
import sys
reload(sys)
sys.setdefaultencoding("utf8")
session = enmscripting.open()
term = session.terminal()

erbsNetwork = "cmedit get * networkelement.(neProductVersion,neType,ossPrefix,technologyDomain,timeZone) --netype=ERBS -t -s"
fileOut = open(os.environ["erbsNetworkPrint"], "w")
fileOut.write(str(term.execute(erbsNetwork)))
fileOut.close()

erbsConnectivity = "cmedit get * CppConnectivityInformation.ipAddress --netype=ERBS -t"
fileOut = open(os.environ["erbsConnectivityPrint"], "w")
fileOut.write(str(term.execute(erbsConnectivity)))
fileOut.close()

erbsProduct = "cmedit get * ManagedElement.productName --netype=ERBS -t"
fileOut = open(os.environ["erbsProductPrint"], "w")
fileOut.write(str(term.execute(erbsProduct)))
fileOut.close()

erbsLicense = "cmedit get * Licensing.fingerprint --netype=ERBS -t"
fileOut = open(os.environ["erbsLicensePrint"], "w")
fileOut.write(str(term.execute(erbsLicense)))
fileOut.close()

erbsHardware = "cmedit get * Hardware.* --netype=ERBS -t"
fileOut = open(os.environ["erbsHardwarePrint"], "w")
fileOut.write(str(term.execute(erbsHardware)))
fileOut.close()

print("## Getting data ERBS........OK")


enmscripting.close(session)
exit()'

	parsingDataErbs () {
		cleanPrintoutNetwork $erbsNetworkPrint | sed 's/\r//' | sort -s -k 1,1 > $erbsNetworkPrintGawk
		gawk '$2~/^[0-9]/&&$3~/^[0-9]/{print $1,$3}' $erbsConnectivityPrint | sed 's/\r//' | sort -s -k 1,1 > $erbsConnectivityPrintGawk
		gawk '$3~/^[0-9]/{if($4~/^$/)product="null";else product=$4;print $1,product}' $erbsProductPrint | sed 's/\r//' | sort -s -k 1,1 > $erbsProductPrintGawk
		gawk '$2~/^[0-9]/&&$3~/^[0-9]/{print $1,$4}' $erbsLicensePrint | sed 's/\r//' | sort -s -k 1,1 > $erbsLicensePrintGawk
		cleanAndParsHardwarePrintout $erbsHardwarePrint | sed 's/\r//' | sort -s -k 1,1 > $erbsHardwarePrintGawk
		join $erbsConnectivityPrintGawk $erbsNetworkPrintGawk > $erbsJoinConnectivityNetwork
		join $erbsJoinConnectivityNetwork $erbsProductPrintGawk > $erbsJoinConnectivityNetworkProduct
		join $erbsJoinConnectivityNetworkProduct $erbsLicensePrintGawk > $erbsJoinConnectivityNetworkProductLicense
		join -a 1 $erbsJoinConnectivityNetworkProductLicense $erbsHardwarePrintGawk |
		gawk '
			BEGIN {OFS=","}
			{print $1,$2,$3,$4,$5,$7,$8,$9,$10,$11,$6}' | 
		gawk '
			BEGIN {FS=",|>";OFS=","}
			{nodeId=$1;
			ipAddress=$2;
			syncStatus=$3;
			controllingRnc="null";
			controllingBsc="null";
			neProductVersion=$4;
			neType=$5;
			ossPrefix=$(NF-1);
			technologyDomain=$6;
			timeZone=$7;
			productName=$8" "$10;
			fingerprint=$9;
			cellQty="null";
			sigDel="null";
			tMode="null";
			print nodeId,"'"$host_Name"'",syncStatus,ipAddress,neType,productName,neProductVersion,fingerprint,timeZone,ossPrefix,technologyDomain,controllingRnc,controllingBsc,cellQty,sigDel,tMode}'
	}
	parsingDataErbs | sed 's/\r//' > $erbsJoin
}

enmCliRadioNode () {
python -c '
import os
import enmscripting
import sys
reload(sys)
sys.setdefaultencoding("utf8")
session = enmscripting.open()
term = session.terminal()

radionodeNetwork = "cmedit get * networkelement.(neProductVersion,neType,ossPrefix,technologyDomain,timeZone,controllingBsc,controllingRnc) --netype=RadioNode -t -s"
fileOut = open(os.environ["radionodeNetworkPrint"], "w")
fileOut.write(str(term.execute(radionodeNetwork)))
fileOut.close()

radionodeConnectivity = "cmedit get * ComConnectivityInformation.ipAddress --netype=RadioNode -t"
fileOut = open(os.environ["radionodeConnectivityPrint"], "w")
fileOut.write(str(term.execute(radionodeConnectivity)))
fileOut.close()

radionodeProduct = "cmedit get * HwItem.(hwCapability,hwType==FieldReplaceableUnit) --netype=RadioNode -t"
fileOut = open(os.environ["radionodeProductPrint"], "w")
fileOut.write(str(term.execute(radionodeProduct)))
fileOut.close()

radionodeLicense = "cmedit get * Lm.fingerprint --netype=RadioNode -t"
fileOut = open(os.environ["radionodeLicensePrint"], "w")
fileOut.write(str(term.execute(radionodeLicense)))
fileOut.close()

print("## Getting data RadioNode...OK")

enmscripting.close(session)
exit()'

	parsingDataRadioNode () {
		cleanPrintoutNetwork $radionodeNetworkPrint | sed 's/\r//' | sort -s -k 1,1 > $radionodeNetworkPrintGawk
		gawk '$2~/^[0-9]/&&$3~/^[0-9]/{print $1,$3}' $radionodeConnectivityPrint | sed 's/\r//' | sort -s -k 1,1 > $radionodeConnectivityPrintGawk
		gawk '$NF~/^FieldReplaceableUnit/&&$(NF-1)!~/^R503/{
			if($5~"Baseband")string=$1" "$5"_"$6;
			else if($5$6~"RadioProcessor")string=$1" "$5"_"$6"_"$7;
			print string}' $radionodeProductPrint | sort | uniq | sed 's/\r//' | sort -s -k 1,1 > $radionodeProductPrintGawk
		gawk '$2~/^[0-9]/&&$3~/^[0-9]/{print $1,$4}' $radionodeLicensePrint | sed 's/\r//' | sort -s -k 1,1 > $radionodeLicensePrintGawk
		join $radionodeConnectivityPrintGawk $radionodeNetworkPrintGawk > $radionodeJoinConnectivityNetwork
		join $radionodeJoinConnectivityNetwork $radionodeProductPrintGawk > $radionodeJoinConnectivityNetworkProduct
		join $radionodeJoinConnectivityNetworkProduct $radionodeLicensePrintGawk |
		gawk '
			BEGIN {OFS=","}
			{print $1,$2,$3,$4,$5,$6,$7,$9,$10,$11,$12,$8}' | 
		gawk '
			BEGIN {FS=",|>";OFS=","}
			{nodeId=$1;
			ipAddress=$2;
			syncStatus=$3;
			controllingBsc=$4;
			controllingRnc=$5;
			neProductVersion=$6;
			neType=$7;
			ossPrefix=$(NF-1);
			technologyDomain=$8;
			timeZone=$9;
			productName=$10;
			fingerprint=$11;
			cellQty="null";
			sigDel="null";
			tMode="null";
			print nodeId,"'"$host_Name"'",syncStatus,ipAddress,neType,productName,neProductVersion,fingerprint,timeZone,ossPrefix,technologyDomain,controllingRnc,controllingBsc,cellQty,sigDel,tMode}'
	}
	parsingDataRadioNode | sed 's/\r//' > $radionodeJoin
}

collectingDataFromEnm () {
	for pythonSession in ${enmCliFunctions[*]}
		do
		$pythonSession &
	done
	wait
}

joinAllTable () {
cat $radionodeJoin $rbsJoin $erbsJoin $rncJoin $bscJoin $btsJoin | sed 's/[{}]//g;s/[][]//g' |
gawk '
	BEGIN{FS=OFS=",";
	print "nodeId,hostName,syncStatus,ipAddress,neType,productName,neProductVersion,fingerprint,timeZone,topologyParentId,technologyDomain,controllingRnc,controllingBsc,cellQty,sigDel,tMode,uniqueKey"}
	{nodeId=$1;
	syncStatus=$3;
	ipAddress=$4;
	neType=$5;
	productName=$6;sub("_"," ",productName);
	neProductVersion=$7;
	if(neProductVersion~"firstStep")neProductVersion="goodPosition";
	else if(neProductVersion~"CXP102051/16_R30BB")neProductVersion="L12B.1.9.0-1 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/19_R27AN")neProductVersion="L13B.0.1.0 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/19_R29BM")neProductVersion="L13B.0.3 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/19_R31AX")neProductVersion="L13B.0.5.0 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/19_R37AL")neProductVersion="L13B.1.10.0 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/19_R41CC")neProductVersion="L13B.3.12.0 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/19_R42CZ")neProductVersion="L13B.4.12.0 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/21_R36CD")neProductVersion="L14A.2.10.0 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/22_R38BC")neProductVersion="L14B.0.2.0 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/22_R45CV")neProductVersion="L14B.0.4.0 ("neProductVersion")";
	else if(neProductVersion~"M/CXP102051/23_R19DA")neProductVersion="L15B ("neProductVersion")";
	else if(neProductVersion~"LTE_Basic_Package_Reduced_DUL20_R19BU")neProductVersion="L15B.0.2.0 ("neProductVersion")";
	else if(neProductVersion~"LTE_Basic_Package_Reduced_DUS41_DUS31_ODS_R19BU")neProductVersion="L15B.0.2.0 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/23_R23CT")neProductVersion="L15B.1.5.0 ("neProductVersion")";
	else if(neProductVersion~"LTE_Upgrade_Package_R23CT")neProductVersion="L15B.1.5.0 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/23_R26DV")neProductVersion="L15B.1.8.0 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/23_R29ED")neProductVersion="L15B.2.10.0 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/23_R32ES")neProductVersion="L15B.3.12.0 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/23_R33FU")neProductVersion="L15B.4.12.0 ("neProductVersion")";
	else if(neProductVersion~"M/CXP102051/24_R19AFB")neProductVersion="L16A ("neProductVersion")";
	else if(neProductVersion~"CXP102051/25_R27DS")neProductVersion="L16B ("neProductVersion")";
	else if(neProductVersion~"M/CXP102051/25_R17FH")neProductVersion="L16B.1 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/25_R23CX")neProductVersion="L16B.10-2 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/25_R24FG")neProductVersion="L16B.12 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/25_R26DU")neProductVersion="L16B.18 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/25 R27CH")neProductVersion="L16B.24 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/25_R27BL")neProductVersion="L16B.24 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/25_R27CB")neProductVersion="L16B.24-2 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R27CT")neProductVersion="L17.A ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R5B18")neProductVersion="L17.Q1.0 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R5C22")neProductVersion="L17.Q1.1 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R5C54")neProductVersion="L17.Q1.1-4 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R5D17")neProductVersion="L17.Q1.2 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R5E41")neProductVersion="L17.Q1.3 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R5F21")neProductVersion="L17.Q1.4 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R5G18")neProductVersion="L17.Q1.5 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R5H28")neProductVersion="L17.Q1.6 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R5H70")neProductVersion="L17.Q1.6-3 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R5H83")neProductVersion="L17.Q1.6-4 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R12B30")neProductVersion="L17.Q2.0 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R12C31")neProductVersion="L17.Q2.1 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R12D21")neProductVersion="L17.Q2.2 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R12E12")neProductVersion="L17.Q2.3 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R12F10")neProductVersion="L17.Q2.4 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R12G13")neProductVersion="L17.Q2.5 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R12G29")neProductVersion="L17.Q2.5-2 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R21C19")neProductVersion="L17.Q3 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R21C36")neProductVersion="L17.Q3.0 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R21C50")neProductVersion="L17.Q3.0-2 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R21D52")neProductVersion="L17.Q3.1 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R21E18")neProductVersion="L17.Q3.2 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R21F23")neProductVersion="L17.Q3.3 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R21J17")neProductVersion="L17.Q3.C1 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R21K14")neProductVersion="L17.Q3.C2 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R21L42")neProductVersion="L17.Q3.C3 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R21S40")neProductVersion="L17.Q3.C6 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/26_R24FM")neProductVersion="L17B ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R42G19")neProductVersion="L18.Q2.4 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R42M24")neProductVersion="L18.Q2.C4 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R55D22")neProductVersion="L18.Q4.1 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R55F15")neProductVersion="L18.Q4.3 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R55G22")neProductVersion="L18.Q4.4 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R55K20")neProductVersion="L18.Q4.C3 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R55M54")neProductVersion="L18.Q4.C5 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R60U19")neProductVersion="L19.Q1.C8 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R73H14")neProductVersion="L19.Q3.5 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R73N36")neProductVersion="L19.Q3.C5 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R80H24")neProductVersion="L19.Q4.5 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R80M25")neProductVersion="L19.Q4.C4 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R85H85")neProductVersion="L20.Q1 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R85G27")neProductVersion="L20.Q1.4-2 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R85J73")neProductVersion="L20.Q4 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R85L40")neProductVersion="L21.Q2 DUS Maint-5-1 ("neProductVersion")";
	else if(neProductVersion~"CXP102022_2/R2E01")neProductVersion="07B R2E ("neProductVersion")";
	else if(neProductVersion~"CXP102022_2/R3D01")neProductVersion="07B_1 R3D ("neProductVersion")";
	else if(neProductVersion~"CXP102022_3/R2F01")neProductVersion="08A R2F ("neProductVersion")";
	else if(neProductVersion~"CXP102022_3/R2L01")neProductVersion="08A_1 R2L ("neProductVersion")";
	else if(neProductVersion~"CXP102022_3/R3V01")neProductVersion="09A R3V ("neProductVersion")";
	else if(neProductVersion~"CXP102022_3/R4X01")neProductVersion="09A_1 R4X ("neProductVersion")";
	else if(neProductVersion~"CXP9028777/1_R1AH01")neProductVersion="17.Q2 ("neProductVersion")";
	else if(neProductVersion~"CXP9026658/1_R2AT01")neProductVersion="L15B ("neProductVersion")";
	else if(neProductVersion~"CXP9026658/1_R2AV08")neProductVersion="L15B.2.11.0 ("neProductVersion")";
	else if(neProductVersion~"CXP9026658/1_R2CT06")neProductVersion="L15B.4.12.0 ("neProductVersion")";
	else if(neProductVersion~"CXP102124/R1U05")neProductVersion="P11A Maint1 R1U ("neProductVersion")";
	else if(neProductVersion~"CXP102124/R2A01")neProductVersion="P11A Maint2 R2A ("neProductVersion")";
	else if(neProductVersion~"CXP102124/R1S01")neProductVersion="P11A R1S ("neProductVersion")";
	else if(neProductVersion~"CXP102022_4/R1K01")neProductVersion="T10A ("neProductVersion")";
	else if(neProductVersion~"CXP102022_41/R1F01")neProductVersion="T10A Maint1 ("neProductVersion")";
	else if(neProductVersion~"CXP102022_41/R1G02")neProductVersion="T10A Maint2 ("neProductVersion")";
	else if(neProductVersion~"CXP9023306/2_R2AC28")neProductVersion="W15 ("neProductVersion")";
	else if(neProductVersion~"CXP9023306/2_R2AD15")neProductVersion="W15 ("neProductVersion")";
	else if(neProductVersion~"CXP9023306/2_R2AA11")neProductVersion="W15.0.1.2 ("neProductVersion")";
	else if(neProductVersion~"CXP9023306/2_R2AG02")neProductVersion="W15.0.2.12 ("neProductVersion")";
	else if(neProductVersion~"CXP9027025/1_R1BL04")neProductVersion="W16A.0 ("neProductVersion")";
	else if(neProductVersion~"CXP9027025/1_R2AE01")neProductVersion="W16A.10 ("neProductVersion")";
	else if(neProductVersion~"CXP9027025/1_R2AV05")neProductVersion="W16A.23 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/2_R19GG")neProductVersion="16A.8 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/4_R9HD")neProductVersion="16B ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/4_R17JC")neProductVersion="16B.12 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/4_R19GN")neProductVersion="16B.18 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R5B17")neProductVersion="17.Q1 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R5B18")neProductVersion="17.Q1.0 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R5B21")neProductVersion="17.Q1.00 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R5C46")neProductVersion="17.Q1.1 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R5D47")neProductVersion="17.Q1.2 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R5E74")neProductVersion="17.Q1.3 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R5F40")neProductVersion="17.Q1.4 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R5G42")neProductVersion="17.Q1.5 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R5H54")neProductVersion="17.Q1.6 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R12B64")neProductVersion="17.Q2.0 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R12B90")neProductVersion="17.Q2.0 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R12C69")neProductVersion="17.Q2.1 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R12D58")neProductVersion="17.Q2.2 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R12E43")neProductVersion="17.Q2.3 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R21C139")neProductVersion="17.Q3 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R21C170")neProductVersion="17.Q3.0 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R21C157")neProductVersion="17.Q3.0.1 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R21D105")neProductVersion="17.Q3.1 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R21E40")neProductVersion="17.Q3.2 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R21F44")neProductVersion="17.Q3.3 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R21H43")neProductVersion="17.Q3.5 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R21H67")neProductVersion="17.Q3.5-4 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R21J23")neProductVersion="17.Q3.C1 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R21K18")neProductVersion="17.Q3.C2 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R21K22")neProductVersion="17.Q3.C2-AD1 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R21K42")neProductVersion="17.Q3.C2-AD9 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R21L79")neProductVersion="17.Q3.C3-3 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R21M37")neProductVersion="17.Q3.C4 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R21N35")neProductVersion="17.Q3.C5-1 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R21S53")neProductVersion="17.Q3.C6 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R21T27")neProductVersion="17.Q3.C7 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R28L55")neProductVersion="17.Q4 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R28K28")neProductVersion="17.Q4.C3-2 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R28N28")neProductVersion="17.Q4.C6-1 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R28N30")neProductVersion="17.Q4.C6-2 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R28S35")neProductVersion="17.Q4.C7 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R28T50")neProductVersion="17.Q4.C8 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R28T54")neProductVersion="17.Q4.C8-1 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/5_R15GK")neProductVersion="17A ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/5_R19AV")neProductVersion="17A.4 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/12_R18C24")neProductVersion="18 MTR 5G MMIMO ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R41B31")neProductVersion="18.17 MTR Elastic RAN UL ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R42C28")neProductVersion="18.19-2 MTR ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/12_R20B27")neProductVersion="18.27 MTR MMIMO ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/12_R21B39")neProductVersion="18.29 MTR MMIMO ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R57B28")neProductVersion="18.49 MTR EC7 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/12_R12B29")neProductVersion="18.Q1 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/12_R18B30")neProductVersion="18.Q1 MTR18.23 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/12_R12D09")neProductVersion="18.Q1.1 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/12_R15B35")neProductVersion="18.Q1.3 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/12_R16B58")neProductVersion="18.Q1.4 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R34G49")neProductVersion="18.Q1.4 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/12_R16B64")neProductVersion="18.Q1.4-AD2 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R42G26")neProductVersion="18.Q2.4 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R42J29")neProductVersion="18.Q2.C1 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R42L27")neProductVersion="18.Q2.C3 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R42M64")neProductVersion="18.Q2.C4 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/12_R22C27")neProductVersion="18.Q3.0 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/12_R22E20")neProductVersion="18.Q3.2 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/12_R22F28")neProductVersion="18.Q3.3 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/12_R22H14")neProductVersion="18.Q3.5 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R48F24")neProductVersion="18.Q3.IP3 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R55E43")neProductVersion="18.Q4.2 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/12_R28E44")neProductVersion="18.Q4.2.0 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R55F24")neProductVersion="18.Q4.3 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R55G22")neProductVersion="18.Q4.4 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R55M41")neProductVersion="18.Q4.8 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R55K32")neProductVersion="18.Q4.C3 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R55L49")neProductVersion="18.Q4.C4 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R55L64")neProductVersion="18.Q4.C4-x ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R55N28")neProductVersion="18.Q4.C6 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R55S36")neProductVersion="18.Q4.C7 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R55T61")neProductVersion="18.Q4.C8 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/12_R39C35")neProductVersion="19.19 MTR EC3 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R60C49")neProductVersion="19.Q1.0 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R60H20")neProductVersion="19.Q1.5 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/12_R45G21")neProductVersion="19.Q3.4 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R73G25")neProductVersion="19.Q3.4 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R73H32")neProductVersion="19.Q3.5 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R73M27")neProductVersion="19.Q3.C4 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R73N41")neProductVersion="19.Q3.C5 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R80C90")neProductVersion="19.Q4.0 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R80D36")neProductVersion="19.Q4.1 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R80F30")neProductVersion="19.Q4.3 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R80G27")neProductVersion="19.Q4.4 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/12_R52F28")neProductVersion="19.Q4.5 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R80H23")neProductVersion="19.Q4.5 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R80K40")neProductVersion="19.Q4.C2 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R80N38")neProductVersion="19.Q4.C5 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R80T25")neProductVersion="19.Q4.C7 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/15_R7E39")neProductVersion="20.Q2.2 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/15_R7G28")neProductVersion="20.Q2.4 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/12_R64G26")neProductVersion="20.Q2.4 eCPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/15_R7H21")neProductVersion="20.Q2.5 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/15_R7J16")neProductVersion="20.Q2.6 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/15_R7S40")neProductVersion="20.Q2.C5-3 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/15_R13D51")neProductVersion="20.Q3.1 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/15_R13F43")neProductVersion="20.Q3.3 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/15_R13J29")neProductVersion="20.Q3.C1 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/12_R70J15")neProductVersion="20.Q3.C1 eCPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/15_R13K41")neProductVersion="20.Q3.C2 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/15_R20E32")neProductVersion="20.Q4.2 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/15_R20G41")neProductVersion="20.Q4.4 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/12_R77G32")neProductVersion="20.Q4.4 eCPRI ("neProductVersion")";
	else if(neProductVersion~"CXP2010171/1_R16G29")neProductVersion="20.Q4.4 G3 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/15_R20J21")neProductVersion="20.Q4.C1 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/15_R30C92")neProductVersion="21.Q2.0 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/12_R87C63")neProductVersion="21.Q2.0 eCPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/15_R30D42")neProductVersion="21.Q2.1 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/12_R87D35")neProductVersion="21.Q2.1 eCPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/15_R30E26")neProductVersion="21.Q2.2 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/12_R87E22")neProductVersion="21.Q2.2 eCPRI ("neProductVersion")";
	else if(neProductVersion~"CXP2010174/1_R27E24")neProductVersion="21.Q2.2 G3 CPRI/eCPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9016865/1_R2Z01")neProductVersion="W11.0.3 ("neProductVersion")";
	else if(neProductVersion~"CXP9016865/1_R2V02")neProductVersion="W11.0.3.11 ("neProductVersion")";
	else if(neProductVersion~"CXP9017021/1_R9N02")neProductVersion="W11.1.2.12 ("neProductVersion")";
	else if(neProductVersion~"CXP9018735/2_R9G01")neProductVersion="W12 ("neProductVersion")";
	else if(neProductVersion~"CXP9018733/1_R9AG08")neProductVersion="W12.1.0.0 ("neProductVersion")";
	else if(neProductVersion~"CXP9021719_R2N01")neProductVersion="W13.1 ("neProductVersion")";
	else if(neProductVersion~"CXP9023078_R3E06")neProductVersion="W13.1 ("neProductVersion")";
	else if(neProductVersion~"CXP9021719_R2U01")neProductVersion="W13.1.0 ("neProductVersion")";
	else if(neProductVersion~"CXP9021719_R6N07")neProductVersion="W13.1.1.12 ("neProductVersion")";
	else if(neProductVersion~"CXP9021719_R5B17")neProductVersion="W13.1.1.2 ("neProductVersion")";
	else if(neProductVersion~"CXP9021719_R5D08")neProductVersion="W13.1.1.4 ("neProductVersion")";
	else if(neProductVersion~"CXP9023078_R3C04")neProductVersion="W13.1.1.4 ("neProductVersion")";
	else if(neProductVersion~"CXP9023078_R4B_1")neProductVersion="W13.1.2 ("neProductVersion")";
	else if(neProductVersion~"CXP9021719_R6A22")neProductVersion="W13.1.2.0 ("neProductVersion")";
	else if(neProductVersion~"CXP9023078_R5B05")neProductVersion="W13.1.2.10 ("neProductVersion")";
	else if(neProductVersion~"CXP9021719_R6U09")neProductVersion="W13.1.2.15 ("neProductVersion")";
	else if(neProductVersion~"CXP9021719_R6D12")neProductVersion="W13.1.2.3 ("neProductVersion")";
	else if(neProductVersion~"CXP9021719_R6F14")neProductVersion="W13.1.2.5 ("neProductVersion")";
	else if(neProductVersion~"CXP9021719_R6Y/1")neProductVersion="W13.1-AD94 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/2_R4VA07")neProductVersion="W14 ("neProductVersion")";
	else if(neProductVersion~"CXP9023078_R4D02")neProductVersion="W14.0.1.4 ("neProductVersion")";
	else if(neProductVersion~"CXP9023078_R5B/1")neProductVersion="W14.0.1.4 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/2_R2AA08")neProductVersion="W14.1.0.1 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/2_R3FA15")neProductVersion="W14.1.1.5 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/2_R4AA13")neProductVersion="W14.1.2.0 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/2_R4BA15")neProductVersion="W14.1.2.1 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/2_R4LA09")neProductVersion="W14.1.2.10 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/2_R4MA20")neProductVersion="W14.1.2.11 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/2_R4NA17")neProductVersion="W14.1.2.12 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/2_R4XA12")neProductVersion="W14.1.2.17 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/2_	R4XA")neProductVersion="W14.1.2.17-1 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/2_R4XA/6")neProductVersion="W14.1.2.17-1 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/2_R4DA01")neProductVersion="W14.1.2.3 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/3_R4TA")neProductVersion="W15.0.2.14 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/4_R1AE03")neProductVersion="W15.1.0.0 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/4_R3AA22")neProductVersion="W15.1.1.0 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/4_R3EA14")neProductVersion="W15.1.1.4 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/4_R4BA22")neProductVersion="W15.1.2.1 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/4_R4LA17")neProductVersion="W15.1.2.10 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/4_R4UA08")neProductVersion="W15.1.2.15 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/4_R4XA06")neProductVersion="W15.1.2.17 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/4_R4VA04")neProductVersion="W15B.1.2.16 ("neProductVersion")";
	else if(neProductVersion~"CXP9023290/6_R2AA")neProductVersion="W16B.1 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/6_R2AA01")neProductVersion="W16B.1 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/6_R2KA19")neProductVersion="W16B.10 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/6_R2MA01")neProductVersion="W16B.12 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/6_R3BA23")neProductVersion="W16B.14 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/6_R3CA14")neProductVersion="W16B.15 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/6_R3GA12")neProductVersion="W16B.20 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/6_R3HA16")neProductVersion="W16B.22 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/6_R3JA45")neProductVersion="W16B.24 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/6_R4BA12")neProductVersion="W16B.30 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/6_R4DA06")neProductVersion="W16B.36 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/6_R2FA12")neProductVersion="W16B.6 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/8_R3HA12")neProductVersion="W17.Q2.13 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/9_R1BC03")neProductVersion="W17.Q3.0-1 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/9_R3EA15")neProductVersion="W17.Q3.10 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/9_R3EC02")neProductVersion="W17.Q3.10-3 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/9_R3ED03")neProductVersion="W17.Q3.10-7 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/9_R2BA31")neProductVersion="W17.Q3.3 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/10_R1BA06")neProductVersion="W17.Q4.0 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/10_R3BB02")neProductVersion="W17.Q4.7-2 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291_R13AC52")neProductVersion="W18.23 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291_R13BD51")neProductVersion="W18.27 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/13_R1AB01")neProductVersion="W18.31-1 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/11_R1BA04")neProductVersion="W18.Q1.0 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/11_R2CB01")neProductVersion="W18.Q1.5-1 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/11_R2CE01")neProductVersion="W18.Q1.6-1 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/12_R1BA06")neProductVersion="W18.Q2.0 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/12_R2LA03")neProductVersion="W18.Q2.15 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/12_R2MA03")neProductVersion="W18.Q2.17 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/12_R2BA22")neProductVersion="W18.Q2.3 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/13_R2CB06")neProductVersion="W18.Q3.5-1 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/14_R2CA10")neProductVersion="W18.Q4.3 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/14_R2EB01")neProductVersion="W18.Q4.5-1 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/14_R2HA06")neProductVersion="W18.Q4.8 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/14_R2JA03")neProductVersion="W18.Q4.9 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291_R18AE25")neProductVersion="W19.37 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291_R19AD19")neProductVersion="W19.49 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/15_R2DA13")neProductVersion="W19.Q1.5 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/16_R2LA03")neProductVersion="W19.Q2.11 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/16_R2EA11")neProductVersion="W19.Q2.5 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/16_R2JA03")neProductVersion="W19.Q2.9 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/17_R1BA03")neProductVersion="W19.Q3.0 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/17_R2BA04")neProductVersion="W19.Q3.1 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/17_R2EA14")neProductVersion="W19.Q3.5 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/18_R1BA04")neProductVersion="W19.Q4.0 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/18_R2CA32")neProductVersion="W19.Q4.3 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/18_R2EA06")neProductVersion="W19.Q4.5 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291_R20AE09")neProductVersion="W20.11 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291_R20BD08")neProductVersion="W20.15 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/19_R1BA03")neProductVersion="W20.Q1.0 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/19_R2AA08")neProductVersion="W20.Q1.1 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/19_R2CA12")neProductVersion="W20.Q1.3 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/20_R1DA01")neProductVersion="W20.Q2.0 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291_R22AB09")neProductVersion="W20.Q3.0 WRBS01.A04 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/6_R4BA09")neProductVersion="W13.1.1.2 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/2_R4AA11")neProductVersion="W14.1.2.0 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/2_R4BA06")neProductVersion="W14.1.2.1 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/2_R4XB")neProductVersion="W14.1.2.17-2 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/3_R4TA")neProductVersion="W15.0.2.14 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/4_R4MA10")neProductVersion="W15.1.2.10 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/6_R2LB01")neProductVersion="W16B.12 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/6_R2MA07")neProductVersion="W16B.14 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/6_R2SA06")neProductVersion="W16B.15 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/6_R2TA09")neProductVersion="W16B.20 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/6_R3AA12")neProductVersion="W16B.24 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/6_R3CC02")neProductVersion="W16B.30 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/6_R4DB03")neProductVersion="W16B.36-1 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/6_R4DC03")neProductVersion="W16B.36-2 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/6_R2FA05")neProductVersion="W16B.6 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/12_R1AC03")neProductVersion="W18.Q2.0 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/12_R4HA12")neProductVersion="W18.Q2.17 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/12_R2BA12")neProductVersion="W18.Q2.3 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/13_R2AB03")neProductVersion="W18.Q3 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/13_R2CA14")neProductVersion="W18.Q3.5 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/13_R2CB03")neProductVersion="W18.Q3.5-1 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/14_R2BB02")neProductVersion="W18.Q4.3 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/14_R1AB10")neProductVersion="W18.Q4.47 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/14_R2GA14")neProductVersion="W18.Q4.8 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/14_R2HA12")neProductVersion="W18.Q4.9 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/14_R2LA09")neProductVersion="W18.Q4.9-2 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/15_R4AA13")neProductVersion="W19.Q1.5 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/16_R2GB03")neProductVersion="W19.Q2.9 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/17_R2BA16")neProductVersion="W19.Q3.3 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/17_R2CA27")neProductVersion="W19.Q3.5 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/18_R2BB02")neProductVersion="W19.Q4.5 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/18_R2CB03")neProductVersion="W19.Q4.5-1 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/18_R2CD03")neProductVersion="W19.Q4.5-4 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/19_R1AA03")neProductVersion="W20.Q1.0 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/20_R2AA07")neProductVersion="W20.Q2.1 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/20_R2EB04")neProductVersion="W20.Q2.10-2 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/20_R2DB04")neProductVersion="W20.Q2.8-1 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/21_R2AA05")neProductVersion="W20.Q3.1 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/21_R2BB05")neProductVersion="W20.Q3.3 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/21_R2CA18")neProductVersion="W20.Q3.5 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/21_R2CC02")neProductVersion="W20.Q3.5-2 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/22_R2CA13")neProductVersion="W20.Q4.5 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/22_R2CB05")neProductVersion="W20.Q4.5-1 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/22_R2CC05")neProductVersion="W20.Q4.5-2 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/24_R2AA10")neProductVersion="W21.Q2.2 RNC01.A02 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/15_R30F18")neProductVersion="21.Q2.3 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/12_R87F17")neProductVersion="21.Q2.3 eCPRI ("neProductVersion")";
	else if(neProductVersion~"CXP2010174/1_R27F19")neProductVersion="21.Q2.3 G3 CPRI/eCPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/22_R2CE06")neProductVersion="W20.Q4.5-4 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291_R23BA02")neProductVersion="W20.Q4.0 WRBS01.A08 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291_R25EA49")neProductVersion="W21.Q2.4 WRBS01.A17 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/15_R30H16")neProductVersion="21.Q2.5 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/12_R87H14")neProductVersion="21.Q2.5 eCPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/15_R30​G18")neProductVersion="21.Q2.4 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/12_R87G16")neProductVersion="21.Q2.4 eCPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/15_R20K67")neProductVersion="20.Q4.C2 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/15_R24C66")neProductVersion="21.Q1 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/24_R2BA06")neProductVersion="W21.Q2.4 RNC01.A03 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/15_R30J13")neProductVersion="21.Q2.C1 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/12_R77J18")neProductVersion="20.Q4.C1 EC3 eCPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/15_R20N16")neProductVersion="20.Q4.C5 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/15_R20M18")neProductVersion="20.Q4.C4 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/15_R30K12")neProductVersion="21.Q2.C2 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/2_R4LA16")neProductVersion="W14.1.2.10 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/12_R2GA07")neProductVersion="W18.Q2.11 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/15_R30F25")neProductVersion="21.Q2.3-1 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/24_R2EA10")neProductVersion="W21.Q2.4-3 RNC01.A03-3 ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/25_R2AA08")neProductVersion="W21.Q4.1 RNC01.A05 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291_R27BA03")neProductVersion="W21.Q4 WRBS01.A23 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/15_R43D28")neProductVersion="21.Q4.1 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/22_R11D30")neProductVersion="21.Q4.1 eCPRI ("neProductVersion")";
	else if(neProductVersion~"CXP2010174/1_R40D30")neProductVersion="21.Q4.1 G3 CPRI/eCPRI ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R85N40")neProductVersion="L21.Q4 DUS Maint-7 ("neProductVersion")";
	else if(neProductVersion~"CXP2010171/1_R16S06")neProductVersion="20.Q4.C6 G3 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/15_R20S07")neProductVersion="20.Q4.C6 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/22_R5J09")neProductVersion="21.Q3.6 eCPRI ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R85G43")neProductVersion="L20.Q2 DUS Maint-1-1 ("neProductVersion")";
	else if(neProductVersion~"M/CXP102051/27_R85G43")neProductVersion="L20.Q2 DUS Maint-1-1 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R85C103")neProductVersion="20.Q1 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/15_R43E31")neProductVersion="21.Q4.2 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/22_R11E34")neProductVersion="21.Q4.2 eCPRI ("neProductVersion")";
	else if(neProductVersion~"CXP2010174/1_R40E35")neProductVersion="21.Q4.2 G3 CPRI/eCPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/15_R30L14")neProductVersion="21.Q2.C3 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9021776/25_R2BA07")neProductVersion="W21.Q4.3 RNC01.A06 ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R55T30")neProductVersion="L18.Q4.C8 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/6_R28S45")neProductVersion="17.Q4.C7-x ("neProductVersion")";
	else if(neProductVersion~"CXP9021776_R27AK10")neProductVersion="W22.Q2.1 RNC01.A09 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/15_R59E13")neProductVersion="22.Q3.2 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP9023291/10_R3BD04")neProductVersion="W17.Q4.7-5 ("neProductVersion")";
	else if(neProductVersion~"CXP9024418/15_R30S17")neProductVersion="21.Q2.C6 CPRI ("neProductVersion")";
	else if(neProductVersion~"CXP102051/27_R85T72")neProductVersion="L22.Q2 DUS Maint-9 ("neProductVersion")";
	else if(neProductVersion~"CXP9023291_R28CA09")neProductVersion="W22.Q2.1 (WRBS01.A27) ("neProductVersion")";
	else neProductVersion=neProductVersion;
	fingerprint=$8
	timeZone=$9;
	ossPrefix=$10;gsub(">"," ",ossPrefix);
	technologyDomain=$11;gsub("_"," ",technologyDomain);
	controllingRnc=$12;
	controllingBsc=$13;
	cellQty=$14;
	sigDel=$15;
	tMode=$16;
	if(neType=="BTS")uniqueKey="'"$host_Name"'-"controllingBsc"-"ipAddress;
	else uniqueKey="'"$host_Name"'-"ipAddress;
	print nodeId,"'"$host_Name"'",syncStatus,ipAddress,neType,productName,neProductVersion,fingerprint,timeZone,ossPrefix,technologyDomain,controllingRnc,controllingBsc,cellQty,sigDel,tMode,uniqueKey}' |
sed 's/<-</ /g'	| sed 's/\r//'
}

printCountOfChars () {
	printf "%${countOfChars}s\n" | sed "s/ /$chars/g"
	#echo
}

mainReport () {
	reportPars () {
		gawk '
			$2~/^SYNCHRONIZED/{synch++};
			/instance/{inst=$1;instStr=$2};
			END{
			percentOfSynch=synch/inst*100;
			print inst,instStr", synchronized: "synch", ";printf("percentage synchronized: %.2f%",percentOfSynch)}' $1
	}
	
	
	getReportAuditData () {
		echo -e "BSC: "$(reportPars $bscNetworkPrint)
		echo -e "RNC: "$(reportPars $rncNetworkPrint)
		echo -e "BTS: "$(gawk '/instance/{inst=$1;instStr=$2;print inst,instStr}' $bscG12TgPrint)"instance(s), synchronized: notApplicable percentage synchronized: notApplicable"
		echo -e "RBS: "$(reportPars $rbsNetworkPrint)
		echo -e "ERBS: "$(reportPars $erbsNetworkPrint)
		echo -e "RadioNode: "$(reportPars $radionodeNetworkPrint)
	}
	
	
	
	reportAuditData=$(getReportAuditData | sed 's/,//g;s/://g' | gawk 'BEGIN{OFS=",";print "|,nodeType,|,countOf,|,synched,|,% synched,|"}{print "|",$1,"|",$2,"|",$5,"|",$8,"|"}' | column -t -s ",")	
	countOfChars=$((`wc -L <<< "$reportAuditData"`))
	chars="#"
	echo
	echo -e "#####################################################################################################################\n# REPORT FOR $host_Name"
	chars="-"
	printCountOfChars
	gawk '(NR==1){print $0}' <<< "$reportAuditData"
	printCountOfChars
	gawk '(NR>1){print $0}' <<< "$reportAuditData"
	printCountOfChars
	echo -e "Total count of nodes: "$(gawk '/'"$host_Name"'/{a++}END{print a}' $auditFile)"\n"
	

	# Pivot table neType - SW
	listOfNeType=$(gawk 'BEGIN{FS=","}$5!~/^neType/{print $5}' $auditFile | sort | uniq)
	getOutputPivotOfNeType () {
		echo "|,neType,|,swVersion,|,qty,|,totalQty,|,percentageOfTotalQty,|"
		for neType in $listOfNeType
		do 
			gawk 'BEGIN{FS=OFS=",";OFMT="%.2f%"}$5~/^'$neType'$/{totalCountOfNe++;freq[$7]++}END{for (i in freq) print "|,'$neType',|",i,"|",freq[i],"|",totalCountOfNe,"|",freq[i]/totalCountOfNe*100+0.00000000000001,"|"}' $auditFile | sort -t, -nk6
		done
	}
	outputNeType=$(getOutputPivotOfNeType | column -t -s ",")
	countOfChars=$((`wc -L <<< "$outputNeType"`))
	echo -e "#####################################################################################################################\n# Summary table of the number of network elements on the software levels"
	chars="-"
	printCountOfChars
	gawk '(NR==1){print $0}' <<< "$outputNeType"
	printCountOfChars

	for neType in $listOfNeType
	do 
		gawk '$2~/^'$neType'$/{print}' <<< "$outputNeType"
		printCountOfChars
	done
	unset listOfNeType
	unset outputNeType
	
	echo
	
	# Pivot table technologyDomain - SW
	listOfTechnology=$(for i in $(gawk 'BEGIN{FS=","}$11!~/technologyDomain/&&$11!~/null/{print $11}' $auditFile); do echo $i; done | sort | uniq)
	#swReleases=$(gawk 'BEGIN{FS=","}$7!~/^n[e|u][P|l][r|l]/{sw=$7;if(sw~"^[A-Z][0-9][0-9].[A-Z]")sw=substr(sw,2,5);else if(sw~"^[0-9][0-9].[A-Z]")sw=substr(sw,1,5);else if(sw~"^[A-Z][0-9][0-9][A-Z]")sw=substr(sw,2,3);else if(sw~"^[A-Z][0-9][0-9].[0-9]")sw=substr(sw,2,4);else sw=sw;print sw}' $auditFile | sed 's/\//-/g' | sort | uniq)
	getOutputPivotOfTechnologyDomain () {
		echo "|,technologyDomain,|,swVersion,|,qty,|,totalQty,|,percentageOfTotalQty,|"
		for technologyDomain in $listOfTechnology
		do
			gawk 'BEGIN{FS=OFS=",";OFMT="%.2f%"}$7!~/^n[e|u][P|l][r|l]/&&$11~/'$technologyDomain'/{sw=$7;if(sw~"^[A-Z][0-9][0-9].[A-Z]")sw=substr(sw,2,5);else if(sw~"^[0-9][0-9].[A-Z]")sw=substr(sw,1,5);else if(sw~"^[A-Z][0-9][0-9][A-Z]")sw=substr(sw,2,3);else if(sw~"^[A-Z][0-9][0-9].[0-9]")sw=substr(sw,2,4);else sw=sw;totalCountOfSw++;freq[sw]++}END{for (i in freq) print "|,'$technologyDomain',|",i,"|",freq[i],"|",totalCountOfSw,"|",freq[i]/totalCountOfSw*100+0.00000000000001,"|"}' $auditFile | sort -t, -nk6
		done
	}

	outputTechnology=$(getOutputPivotOfTechnologyDomain | column -t -s ",")
	countOfChars=$((`wc -L <<< "$outputTechnology"`))
	echo -e "#####################################################################################################################\n# Summary table of the number of technology domain on the software levels"
	chars="-"
	printCountOfChars
	gawk '(NR==1){print $0}' <<< "$outputTechnology"
	printCountOfChars

	for technologyDomain in $listOfTechnology
	do 
		gawk '$2~/^'$technologyDomain'$/{print}' <<< "$outputTechnology"
		printCountOfChars
	done
	unset listOfTechnology
	unset outputTechnology

	echo -e "#####################################################################################################################\n\nPath to audit: $PWD/$auditFile\n"
}

checkIfDirectoryIsExist () {
	# Creating directory
	if [ -d "$swUpgradeDirectory" ]
	then 
		echo -e "Directory is exists: $swUpgradeDirectory\n"

	else
		echo -e "Directory is not exists, creating directory...\n"
		mkdir $swUpgradeDirectory
		if [ -d "$swUpgradeDirectory" ]
		then 
			echo -e "Directory is successfully created: $swUpgradeDirectory\n"
			
		else 
			echo -e "ERROR: Failed to create directory\n"
		fi
	fi
}

createAuditFileForCollectionBeforeUpgrade () {
	checkIfDirectoryIsExist
	# Check the file in the directory
	if [ -f "$auditFileBeforeUpgrade" ]
	then
		echo -e "INFORMATION: audit file before upgrade is exists: $auditFileBeforeUpgrade\nThere is no need to re-create the file.\n"
		
	else
		echo -e "Getting data from ENM for collection: $collectionName, please wait...\n"
		collectingDataFromEnm &>/dev/null
		joinAllTable > $tempAuditFile
		echo -e "nodeId,hostName,syncStatus,ipAddress,neType,productName,swBeforeUpgrade,swAfterUpgrade,fingerprint,timeZone,topologyParentId,technologyDomain,controllingRnc,controllingBsc" > $auditFileBeforeUpgrade
		for nodeIdName in $listOfNodesInCollection
		do
			gawk 'BEGIN{FS=OFS=","}$1~/^'$nodeIdName'$/{print $1,$2,$3,$4,$5,$6,$7",,"$8,$9,$10,$11,$12,$13}' $tempAuditFile >> $auditFileBeforeUpgrade
		done
		echo -e "Done for collection: $collectionName. File path: "$auditFileBeforeUpgrade"\n"
	fi
}

getAlarmsFromNodes () {
#	alarmsFromNodes=$(python -c "import enmscripting;session = enmscripting.open();terminal = session.terminal();command = 'alarm get $collectionName';output = terminal.execute(command);getOutput = output.get_output();print(getOutput);enmscripting.close(session);exit()")
	python -c "import enmscripting;session = enmscripting.open();terminal = session.terminal();command = 'alarm get $collectionName';output = terminal.execute(command);getOutput = output.get_output();print(getOutput);enmscripting.close(session);exit()" | 
#	echo "$alarmsFromNodes" | 
	sed "s/', u'/\n/g;s/\[u'//g" | 
	sed 's/\\t/;/g;s/\\r/ /g;s/\\n/ /g;s/\*\*\*//g' | 
	gawk 'BEGIN{FS=OFS=";"}$1!~/^$/&&$1!~/^Total/&&$1!~/^CLEARED/&&$1!~/^presentSeverity/{
		presentSeverity=$1;if(presentSeverity~"^$"||presentSeverity==0)presentSeverity="null";else presentSeverity=presentSeverity;
		nodeName=$2;
		specificProblem=$3;if(specificProblem~"^$"||specificProblem==0)specificProblem="null";else specificProblem=specificProblem;
		eventTime=$4;
		objectOfReference=$5;
		problemText=$6;if(problemText~"^$"||problemText==0)problemText="null";else problemText=problemText;
		alarmState=$7;if(alarmState~"^$"||alarmState==0)alarmState="null";else alarmState=alarmState;
		alarmId=$8;if(alarmId~"^$"||alarmId==0)alarmId="null";else alarmId=alarmId;
		probableCause=$9;if(probableCause~"^$"||probableCause==0)probableCause="null";else probableCause=probableCause;
		eventType=$10;if(eventType~"^$"||eventType==0)eventType="null";else eventType=eventType;
		recordType=$11;if(recordType~"^$"||recordType==0)recordType="null";else recordType=recordType;
		gsub(",",">",objectOfReference);print nodeName,objectOfReference,specificProblem,probableCause,eventType,problemText,eventTime,alarmState,presentSeverity}' | 
	sed 's/,/ /g' | 
	sed 's/;/,/g' | 
	sort | 
	uniq | 
	gawk 'BEGIN{print "nodeName,objectOfReference,specificProblem,probableCause,eventType,problemText,eventTime,alarmState,presentSeverity"}{print $0}'
}


getAbisTsState () {
	abisTs=$(python -c "import enmscripting;session = enmscripting.open();terminal = session.terminal();command = 'cmedit get --collection $collectionName trx.(abisTsState,maxTxPowerCapability,operationalState) -t -s';output = terminal.execute(command);getOutput = output.get_output();print(getOutput);enmscripting.close(session);exit()" | sed "s/', u'/\n/g;s/\[u'//g" | sed 's/\\t/;/g;s/\\r/ /g;s/\\n/ /g;s/\*\*\*//g;s/,//g')
	echo "$abisTs" | sed 's/\[//g;s/\]//g' | gawk 'BEGIN {FS=";";OFS=","}NF==8{print $1,$2,$4,$5,$8,$7,$6}' > $abisTsState
	echo "$abisTs" | sed 's/\[ENABLED ENABLED ENABLED ENABLED ENABLED ENABLED ENABLED ENABLED\]/ENABLED/;s/\[//g;s/\]//g' | gawk 'BEGIN {FS=OFS=";"}NF==8&&($2!~/^SYNCHRONIZED/||$6!~/^ENABLED$/){print $1,$2,$4,$5,$8,$7,$6}' | column -t -s";"
	echo
}


################################################################################################################################################################################################
# PROCEDURE ####################################################################################################################################################################################
################################################################################################################################################################################################
echo "$welcomeMessage" | column -t -s","

declareVariablesForPython

# If the script is not given any arguments, it will perform a simple audit
if [ -z "$scriptAction" ] 
	then
	echo -e "\n## "$(date)"\n## Host name: "$hostName
	sleep 1
	echo -e "\n## Getting data from ENM, please wait..."
	collectingDataFromEnm
	joinAllTable > $auditFile
	mainReport

elif [ -n "$scriptAction" -a -n "$collectionName" -a "$2" = "--collection" ]
	then

	# Checking if a collection exists on ENM
	listOfNodesInCollection=$(python -c "import enmscripting;session = enmscripting.open();terminal = session.terminal();command = 'cmedit get --collection $collectionName -t';print(command);result= terminal.execute(command);print(result);command = 'cmedit get $collectionName -t';print(command);result= terminal.execute(command);print(result);enmscripting.close(session)" | gawk 'NF==3&&$1!~/NodeId/{print $1}' | sort | uniq)
	if [ -z "$listOfNodesInCollection" ]
		then
		echo -e "ERROR: Collection $collectionName contains no nodes or there is no collection with this name on ENM. Check this collection in app \"Collection Management in ENM\"\n\n"
		exit 0
	fi
	
	###############################################################################################################################################################
	
	if [ "$scriptAction" = "--auditBeforeUpgrade" ]
		then createAuditFileForCollectionBeforeUpgrade
	
	###############################################################################################################################################################
		
	elif [ "$scriptAction" = "--auditAfterUpgrade" ]
		then 
		# Check the file in the directory
		if [ -f "$auditFileBeforeUpgrade" ]
		then
			echo -e "INFORMATION: Getting data from ENM for collection: $collectionName, please wait...\n"
			collectingDataFromEnm &>/dev/null
			joinAllTable > $tempAuditFile
			echo -e "nodeId,hostName,syncStatus,ipAddress,neType,productName,swBeforeUpgrade,swAfterUpgrade,fingerprint,timeZone,topologyParentId,technologyDomain,controllingRnc,controllingBsc" > $auditFileAfterUpgrade
			for nodeIdName in $listOfNodesInCollection
			do
				swBeforeUpgrade=$(gawk 'BEGIN{FS=","}$1~/^'$nodeIdName'$/{print $7}' $auditFileBeforeUpgrade)
				gawk 'BEGIN{FS=OFS=","}$1~/^'$nodeIdName'$/{print $1,$2,$3,$4,$5,$6,"'"$swBeforeUpgrade"'",$7,$8,$9,$10,$11,$12,$13}' $tempAuditFile >> $auditFileAfterUpgrade
			done
			echo -e "Done for collection: $collectionName. File path: "$auditFileAfterUpgrade"\n"
			reportAfterUpgrade=$(gawk 'BEGIN{FS=OFS=",";print "|,qty,|,sw,|"}(NR>1){freq[$8]++} END{for (i in freq) print "|",freq[i],"|",i,"|"}' $auditFileAfterUpgrade | column -t -s ",")
			
			countOfChars=$((`wc -L <<< "$reportAfterUpgrade"`))
			chars="-"
			printCountOfChars
			gawk '(NR==1){print $0}' <<< "$reportAfterUpgrade"
			printCountOfChars
			gawk '(NR>1){print $0}' <<< "$reportAfterUpgrade"
			printCountOfChars
			echo -e "\n"
		
		else
			echo -e "ERROR: audit file before upgrade isn't exists\n"
	
		fi

	###############################################################################################################################################################
		
	elif [ "$scriptAction" = "--alarmsBeforeUpgrade" ]
		then 
		checkIfDirectoryIsExist
		# Check the file in the directory
		if [ -f "$alarmsBeforeUpgrade" ]
		then
			echo -e "INFORMATION: file with alarms before upgrade is exists: $alarmsBeforeUpgrade\nThere is no need to re-create the file.\n"
			
		else
			echo -e "INFORMATION: Getting alarms from ENM for collection: $collectionName, please wait...\n"
			getAlarmsFromNodes > $alarmsBeforeUpgrade
			echo -e "DONE: Collecting alarms before SW upgrade is done for collection: $collectionName. File path: "$alarmsBeforeUpgrade"\nIMPORTANT: Do not remove this file from the folder until the software upgrade is done\n"
		fi

	###############################################################################################################################################################
		
	elif [ "$scriptAction" = "--alarmsAfterUpgrade" ]
		then 
		checkIfDirectoryIsExist
		echo -e "INFORMATION: Getting alarms from ENM for collection: $collectionName, please wait...\n"
		getAlarmsFromNodes > $alarmsAfterUpgrade
		echo -e "DONE: Collecting alarms after SW upgrade is done for collection: $collectionName. File path: "$alarmsAfterUpgrade"\n"
		
		prepareFileForJoinCompare () {
			gawk '{print}' $1 | sed 's/ /_/g' | gawk 'BEGIN{FS=OFS=","}$1!~/^nodeName/{print $1,$2,$3,$4,$5,$6"<=>"$7,$8,$9}' | sed 's/<=>/ /g' | sort | uniq
		}
		
		if [ -f "$alarmsBeforeUpgrade" ]
		then
			prepareFileForJoinCompare $alarmsBeforeUpgrade | gawk '{print $0",before"}' | sed 's/\r//' > $joinAlarmsBeforeUpgrade
			prepareFileForJoinCompare $alarmsAfterUpgrade  | gawk '{print $0",after"}' | sed 's/\r//' > $joinAlarmsAfterUpgrade
			join -a1 -a2 $joinAlarmsBeforeUpgrade $joinAlarmsAfterUpgrade | 
				sed 's/\r//' | 
				gawk '{if($2~"before$"&&(NF==2))str=$1","$2",,,,,";else if($2~"after$"&&(NF==2))str=$1",,,,,"$2;else str=$1","$2","$3;print str}' |
				gawk 'BEGIN{FS=OFS=",";print "nodeName,objectOfReference,specificProblem,probableCause,eventType,problemText,presentSeverity,eventTimeOld,eventTimeNew,alarmStatus"}
					{if($10~"^before$"&&$14~"^$"){alarmStatus="Alarm Cleared";presentSeverity=$9}
					else if($10~"^$"&&$14~"^after$"){alarmStatus="New Alarm";presentSeverity=$13}
					else {alarmStatus="Old Alarm";presentSeverity=$13}
					print $1,$2,$3,$4,$5,$6,presentSeverity,$7,$11,alarmStatus}' > $alarmsCompare
			echo -e "DONE: Alarms compared. "$(gawk '/New Alarm/{newAlarmCount++}END{print newAlarmCount}' $alarmsCompare)" new alarms found. File path: "$alarmsCompare"\n"
		else
			echo -e "ERROR: Alarms not compared. File alarmsBeforeUpgrade_<collectionName>.csv not found. To compare alarm messages before and after the file is needed.\n"
		fi
		#echo -e "Alarms have been compared: $collectionName. File path: "$alarmsAfterUpgrade"\n"

	###############################################################################################################################################################
	
	elif [ "$scriptAction" = "--pingIp" ]
		then
		createAuditFileForCollectionBeforeUpgrade

		# User process ID in UNIX system
		userPid=$$
		
		# Declare variables maximum parrallel children processes
		maxChildrenProcesses=15
		for nodeIdName in $listOfNodesInCollection
		do
			jobCounter=$((`ps ax -Ao ppid | egrep $userPid | wc -l`))
			while [ $jobCounter -ge $maxChildrenProcesses ]
			do
				jobCounter=$((`ps ax -Ao ppid | egrep $userPid | wc -l`))
				sleep 1
			done
			nodeIpAddress=$(gawk 'BEGIN{FS=","}$1~/^'$nodeIdName'$/{print $4}' $auditFileBeforeUpgrade)
			nodeType=$(gawk 'BEGIN{FS=","}$1~/^'$nodeIdName'$/{print $5}' $auditFileBeforeUpgrade)
			
			if [ -z $nodeIpAddress ]
				then echo -e "NOT OK,$nodeIdName,this node exist in the ENM topology, but no data are found for it" | tee -a $pingIpLog | sed 's/,/ /g'
			else 
				ping $nodeIpAddress -c 1 | gawk 'BEGIN{OFS=","}/^[0-9].*packets.*received.*loss/{if($6~"100%")pingResult="NOT OK";else pingResult="OK";print pingResult,"'$nodeIpAddress'","'$nodeIdName'","'$nodeType'"}' | tee -a $pingIpLog | sed 's/,/ /g' &
			fi
		done
	
		# Waiting for child processes to complete
		while [ $jobCounter -gt 1 ]
		do
			jobCounter=$((`ps ax -Ao ppid | egrep $userPid | wc -l`))
			sleep 1
		done
	
		logReport () {
			reportUnsuccessfullPingIp=$(gawk 'BEGIN{FS=OFS=",";print "|,pingStatus,|,nodeIp,|,nodeName,|,nodeType,|"}$1~/^NOT OK/{print "|",$1,"|",$2,"|",$3,"|",$4,"|"}' $pingIpLog | column -t -s ",")
			counOfStringPingIpLog=$((`wc -l $pingIpLog | gawk '{print $1}'`))
			countOfChars=$((`wc -L <<< "$reportUnsuccessfullPingIp"`))
			countOfStringInReport=$((`wc -l <<< "$reportUnsuccessfullPingIp"`))
			echo | tee -a $pingIpLog
			chars="#"
			printCountOfChars
			echo -e "## Total nodes in collection - $counOfStringPingIpLog"
			printCountOfChars
			if [ $countOfStringInReport -le 1 ]
				then
				echo -e "## Ping on all nodes is OK"
				printCountOfChars
			
			else
				echo -e "## Unavailable nodes - $(($countOfStringInReport - 1))"
				chars="-"
				printCountOfChars
				gawk '(NR==1){print $0}' <<< "$reportUnsuccessfullPingIp"
				printCountOfChars
				gawk '(NR>1){print $0}' <<< "$reportUnsuccessfullPingIp"
				printCountOfChars
			fi
		}
		logReport | tee -a $pingIpLog
	###############################################################################################################################################################	
		
	elif [ "$scriptAction" = "--abisTsState" ]
		then
		checkIfDirectoryIsExist
		getAbisTsState
	###############################################################################################################################################################
			
	fi

else 
	echo -e "\nWRONG OPTION
	SYNOPSIS
		$scriptName [OPTIONS] --collection [COLLECTION NAME]
	
	DESCRIPTION
	
	OPTIONS
		--help Print a usage message briefly summarizing these command-line options and the bug-reporting address, then exit.
		
		--auditBeforeUpgrade
		
		--auditAfterUpgrade
		
		--pingIp
		
		--alarmsBeforeUpgrade
		
		--alarmsAfterUpgrade
		
		--abisTsState
		
	"
	exit 0
fi


cleanUpFolder 2> /dev/null
echo -e "#####################################################################################################################\n"
endTime=$(date +%s)
min=$(echo $(($endTime-$startTime)) | gawk '{min=$1/60;printf("%d\n",min)}')
sec=$(echo $(($endTime-$startTime)) | gawk '{sec=$1-'$min'*60;printf("%d\n",sec)}')
echo -e "\nTotal duration: "$min" min. "$sec" sec.\n\n"
exit 0


