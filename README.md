# Description
 
This script is used in ENM systems. The main purpose of this tool is to export data of RAN equipment. It can also be used as an assistant when working on RAN equipment. To view the full list of features, use the command:
 
	./ranTool.sh --help
or
	
	bash ranTool.sh --help
 
To run the script, you need to upload the `ranTool.sh` file to the ENM scripting machine (connecting via port 5023 or to a direct IP address, you can find out with the command: `egrep scripting_service_IPs /ericsson/tor/data/global.properties`) and expand its rights with the command: `chmod 700 ranTool.sh`
 
 
 
- 30-Jun-2020: Script was created;
- 15-Jul-2020: Added productName field;
- 05-Aug-2020: Added audit BSC;
- 10-Aug-2020: Added audit BTS GRAN;
- 19-Aug-2020: Added "topolologyParentId" field;
- 25-Aug-2020: BSC type is detected automatically;
- 25-Aug-2020: APG board is detected automatically;
- 18-Sep-2020: Added new SW revisions;
- 25-Sep-2020: APG type is detected automatically;
- 05-Oct-2020: Added new SW revisions;
- 05-Oct-2020: Default encoding is set: UTF-8;
- 03-Nov-2020: Added new SW revisions;
- 06-Nov-2020: Added "uniqueKey" field for DB;
- 30-Nov-2020: Added new SW revisions;
- 04-Dec-2020: Fixed issue EvoC8230 with ENM where getting data with mistakes
- 27-Jan-2021: Added new SW revisions;
- 28-Jan-2021: Fixed problem with getting data on APG SW Version
- 05-Feb-2021: Added new SW revisions;
- 20-Feb-2021: Fixed problem with getting data on BSC with sync status "NOT AVAILABLE";
- 21-Feb-2021: Added new SW revisions;
- 03-Mar-2021: Added new SW revisions;
- 28-Apr-2021: Automatic hostname detection added;
- 15-Jun-2021: Added new SW revisions;
- 25-Jun-2021: NEW RELEASE 2.0.
	> The data collection process is now performed in parallel for each type, which has significantly accelerated the script's execution and data collection. The script now runs 2.3 times faster!
	> Added new functional: Collecting audit before and after for collection in ENM, ping IP addresses for collection in ENM.
	
- 01-Jul-2021: Added check whether such collection exists.
- 05-Jul-2021: Additional reports added; Added new SW revisions;
- 14-Jul-2021: Added alarms comparison before and after SW upgrade for collection in ENM
- 12-Jan-2022: Radio Processor type added.
- 24-Nov-2022: Abis TS Status
- 11-Dec-2022: New Release 3.0. Moving to github.
 
 
## ToDo
- [ ] RNC HW revision
- [ ] Audit Pico
- [ ] Audit STN:
	> `cmedit get * Equipment.* --netype=TCU02 -t -s`
	> `cmedit get * networkelement.(neType,platformType==STN) -t -s`
 
 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