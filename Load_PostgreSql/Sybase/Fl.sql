/*
unload table DBA.Bill to  'D:\\Database\\Alan\\unload\\435.dat';
unload table DBA.BillItems  to  'D:\\Database\\Alan\\unload\\436.dat';
unload table DBA.BillItems_byParent  to  'D:\\Database\\Alan\\unload\\482.dat';
unload table dba.GoodsProperty_Detail_byLoad  to  'D:\\Database\\Alan\\unload\\502.dat';
unload table dba.Unit  to  'D:\\Database\\Alan\\unload\\437.dat';
unload table dba.Unit_byLoad  to  'D:\\Database\\Alan\\unload\\504.dat';
unload table dba.ClientInformation  to  'D:\\Database\\Alan\\unload\\456.dat';
*/

alter table "DBA"."Bill" add BillId_pg integer null;
CREATE INDEX "Bill_BillId_pg_IDX" ON "DBA"."Bill"
(
	"BillId_pg" ASC
)
go

drop TABLE "DBA"."fBill";
drop TABLE "DBA"."fBillItems";
drop TABLE "DBA"."fBillItems_byParent";

drop TABLE "DBA"."fGoodsProperty_Detail_byLoad";
drop TABLE "DBA"."fUnit";
drop TABLE "DBA"."fUnit_byLoad";
drop TABLE "DBA"."fClientInformation";

go

CREATE TABLE "DBA"."fBill"
(
	"ID"    			integer NOT NULL DEFAULT autoincrement ,
	"BillDate"      		date NOT NULL ,
	"BillNumber"    		TVarCharShort NOT NULL ,
	"BillKind"      		smallint NOT NULL ,
	"BillSumm"      		TSumm NOT NULL ,
	"FromID"        		integer NOT NULL ,
	"ToID"  			integer NOT NULL ,
	"IsNds" 			smallint NOT NULL ,
	"Nds"   			TSumm NOT NULL ,
	"BillSummIn"    		TSumm NOT NULL ,
	"IsCalculateProduction" 	smallint NOT NULL ,
	"MoneyKindID"   		integer NOT NULL ,
	"DiscountFromOperCount" 	TSumm NOT NULL ,
	"DiscountTax"   		TSumm NOT NULL ,
	"BillSummOperCount"     	TSumm NOT NULL ,
	"IsChangeDolg"  		smallint NOT NULL ,
	"isByMinusDiscountTax"  	smallint NOT NULL ,
	"isRemains"     		smallint NULL ,
	"BillNumberNalog"       	integer NULL ,
	"BillNumberClient1"     	TVarCharShort NULL ,
	"BillNumberClient2"     	TVarCharShort NULL ,
	"RouteUnitId"   		integer NULL ,
	"KindRoute"     		smallint NULL ,
	"isClose"       		integer NULL ,
	"BillId_byLoad" 		integer NULL ,
	"StatusId"      		integer NULL ,
	"isRegistration"        	smallint NULL ,
	"RegistrationDate"      	date NULL ,
	"ExpUnitId"     		integer NULL ,
	"PartionStr_MB" 		TVarCharMedium NULL ,
	"KindAuto"      		integer NULL ,
	"Id_Postgres"   		integer NULL , 
	 PRIMARY KEY ("ID"),
	
)
go
CREATE TABLE "DBA"."fBillItems"	
(
	"ID"    			integer NOT NULL DEFAULT autoincrement ,
	"BillID"        		integer NOT NULL ,
	"OperCount"     		TSumm NOT NULL ,
	"OperPrice"     		TSumm NOT NULL ,
	"BillKind"      		smallint NOT NULL ,
	"SummIn"        		TSumm NOT NULL ,
	"GoodsPropertyID"       	integer NOT NULL ,
	"IsProduction"  		smallint NOT NULL ,
	"ScaleHistoryId"        	integer NULL ,
	"RemainsOperCount"      	TSumm NULL ,
	"KindPackageId" 		integer NULL ,
	"PriceIn"       		TSumm NULL ,
	"InsertUserId"  		integer NULL ,
	"InsertDate"    		datetime NULL ,
	"UpdateUserId"  		integer NULL ,
	"UpdateDate"    		datetime NULL ,
	"ReceiptId"     		integer NULL ,
	"KuterCount"    		TSumm NULL ,
	"PartionDate"   		date NULL ,
	"OperCount_sh"  		TSumm NULL ,
	"OperCount_Upakovka"    	TSumm NULL ,
	"RemainsOperCount_sh"   	TSumm NULL ,
	"BillItemsId_byLoad"    	integer NULL ,
	"PartionStr_MB" 		TVarCharMedium NULL ,
	"Id_Postgres"   		integer NULL , 
	 PRIMARY KEY ("ID"),
	
)
go
CREATE TABLE "DBA"."fBillItems_byParent"
(
	"Id"    			integer NOT NULL DEFAULT autoincrement ,
	"BillItemsId"   		integer NOT NULL ,
	"ParentBillItemsId"     	integer NOT NULL ,
	"OperCount"     		TSumm NOT NULL ,
	"addBillNumber" 		integer NOT NULL ,
	"BillId"        		integer NOT NULL ,
	"BillDate"      		date NULL , 
	 PRIMARY KEY ("Id"),
	
)
go
CREATE TABLE "DBA"."fGoodsProperty_Detail_byLoad"
(
	"Id"    			integer NOT NULL DEFAULT autoincrement ,
	"GoodsPropertyId"       	integer NOT NULL ,
	"KindPackageId" 		integer NOT NULL ,
	"Id_byLoad"     		integer NULL , 
	 PRIMARY KEY ("GoodsPropertyId", "KindPackageId"),
	
)
go

CREATE TABLE "DBA"."fUnit"
(
	"ID"    			integer NOT NULL DEFAULT autoincrement ,
	"UnitName"      		TVarCharMedium NOT NULL ,
	"ParentID"      		integer NOT NULL ,
	"HasChildren"   		smallint NOT NULL ,
	"Erased"        		smallint NOT NULL ,
	"findGoodsCard" 		smallint NOT NULL ,
	"InformationFromUnitID" 	integer NOT NULL DEFAULT 0 ,
	"UnitCode"      		integer NULL ,
	"UnitId_byLoad" 		integer NULL ,
	"DolgByUnitID"  		integer NULL ,
	"RouteUnitId"   		integer NULL ,
	"KindRoute"     		smallint NULL ,
	"RouteGroupId"  		integer NULL ,
	"isTotalBillNalog"      	smallint NULL ,
	"isTotalBillNalog_byUnit"       smallint NULL ,
	"isFindBill"    		integer NULL ,
	"ExpUnitID"     		integer NULL ,
	"Id1_Postgres"  		integer NULL ,
	"Id2_Postgres"  		integer NULL ,
	"Id3_Postgres"  		integer NULL ,
	"PersonalId_Postgres"   	integer NULL ,
	"Id_Postgres_Business"  	integer NULL ,
	"pgUnitId"      		integer NULL ,
	"isBlockSale"   		smallint NULL ,
	"Id_Postgres_RouteSorting"      integer NULL , 
	 PRIMARY KEY ("ID"),
	
)
go

CREATE TABLE "DBA"."fUnit_byLoad"
(
	"Id"    			integer NOT NULL DEFAULT autoincrement ,
	"UnitId"        		integer NOT NULL ,
	"Id_byLoad"     		integer NULL ,
	"isLoad_toServer"       	smallint NULL ,
	"isLoad_fromServer"     	smallint NULL ,
	"isGroupBill"   		smallint NULL , 
	 PRIMARY KEY ("Id"),
	
)
go

CREATE TABLE "DBA"."fClientInformation"
(
	"ClientID"      		integer NOT NULL ,
	"FirmName"      		TVarCharLong NOT NULL ,
	"KodNalog"      		TVarCharShort NOT NULL ,
	"AddressFirm"   		TVarCharLong NOT NULL ,
	"Telefon"       		TVarCharShort NOT NULL ,
	"KodSvid"       		TVarCharShort NOT NULL ,
	"isNDS" 			smallint NOT NULL ,
	"PriceListId"   		integer NULL ,
	"OKPO"  			TVarCharShort NOT NULL ,
	"PriceListAkcID"        	integer NULL ,
	"StartDateAkc"  		date NULL ,
	"EndDateAkc"    		date NULL ,
	"PriceListOldID"        	integer NULL ,
	"FioBuh"        		TVarCharMedium NULL ,
	"GLN"   			TVarCharMedium NULL ,
	"GLNMain"       		TVarCharMedium NULL , 
	 PRIMARY KEY ("ClientID"),
	
)
go

CREATE INDEX "fBill_BillDate_BillKind_IDX" ON "DBA"."fBill"
(
	"BillDate" ASC,
	"BillKind" ASC
)
go
CREATE INDEX "fBill_BillId_byLoad_IDX" ON "DBA"."fBill"
(
	"BillId_byLoad" ASC
)
go
CREATE INDEX "fBillItems_BillItemsId_byLoad_IDX" ON "DBA"."fBillItems"
(
	"BillItemsId_byLoad" ASC
)
go
CREATE INDEX "fUnit_byLoad_UnitId_Id_byLoad_IDX" ON "DBA"."fUnit_byLoad"
(
	"UnitId" ASC,
	"Id_byLoad" ASC
)
go
CREATE INDEX "fUnit_byLoad_Id_byLoad_UnitId_IDX" ON "DBA"."fUnit_byLoad"
(
	"Id_byLoad" ASC,
	"UnitId" ASC
)
go



LOAD TABLE "DBA"."fBill" ("ID", "BillDate", "BillNumber", "BillKind", "BillSumm", "FromID", "ToID", "IsNds", "Nds", "BillSummIn", "IsCalculateProduction", "MoneyKindID", "DiscountFromOperCount", "DiscountTax", "BillSummOperCount", "IsChangeDolg", "isByMinusDiscountTax", "isRemains", "BillNumberNalog", "BillNumberClient1", "BillNumberClient2", "RouteUnitId", "KindRoute", "isClose", "BillId_byLoad", "StatusId", "isRegistration", "RegistrationDate", "ExpUnitId", "PartionStr_MB", "KindAuto", "Id_Postgres" )
	FROM 'D:\\Database\\Alan\\unload\\435.dat'
	FORMAT 'ASCII' QUOTES ON
	ORDER OFF ESCAPES ON
	CHECK CONSTRAINTS OFF COMPUTES OFF                             
	STRIP OFF DELIMITED BY ','
go

LOAD TABLE "DBA"."fBillItems" ("ID", "BillID", "OperCount", "OperPrice", "BillKind", "SummIn", "GoodsPropertyID", "IsProduction", "ScaleHistoryId", "RemainsOperCount", "KindPackageId", "PriceIn", "InsertUserId", "InsertDate", "UpdateUserId", "UpdateDate", "ReceiptId", "KuterCount", "PartionDate", "OperCount_sh", "OperCount_Upakovka", "RemainsOperCount_sh", "BillItemsId_byLoad", "PartionStr_MB", "Id_Postgres" )
	FROM 'D:\\Database\\Alan\\unload\\436.dat'
	FORMAT 'ASCII' QUOTES ON
	ORDER OFF ESCAPES ON
	CHECK CONSTRAINTS OFF COMPUTES OFF
	STRIP OFF DELIMITED BY ','
go

LOAD TABLE "DBA"."fBillItems_byParent" ("Id", "BillItemsId", "ParentBillItemsId", "OperCount", "addBillNumber", "BillId", "BillDate" )
	FROM 'D:\\Database\\Alan\\unload\\482.dat'
	FORMAT 'ASCII' QUOTES ON
	ORDER OFF ESCAPES ON
	CHECK CONSTRAINTS OFF COMPUTES OFF
	STRIP OFF DELIMITED BY ','
go
                  
LOAD TABLE "DBA"."fGoodsProperty_Detail_byLoad" ("Id", "GoodsPropertyId", "KindPackageId", "Id_byLoad" )
	FROM 'D:\\Database\\Alan\\unload\\502.dat'
	FORMAT 'ASCII' QUOTES ON
	ORDER OFF ESCAPES ON
	CHECK CONSTRAINTS OFF COMPUTES OFF
	STRIP OFF DELIMITED BY ','
go
LOAD TABLE "DBA"."fUnit" ("ID", "UnitName", "ParentID", "HasChildren", "Erased", "findGoodsCard", "InformationFromUnitID", "UnitCode", "UnitId_byLoad", "DolgByUnitID", "RouteUnitId", "KindRoute", "RouteGroupId", "isTotalBillNalog", "isTotalBillNalog_byUnit", "isFindBill", "ExpUnitID", "Id1_Postgres", "Id2_Postgres", "Id3_Postgres", "PersonalId_Postgres", "Id_Postgres_Business", "pgUnitId", "isBlockSale", "Id_Postgres_RouteSorting" )
	FROM 'D:\\Database\\Alan\\unload\\437.dat'
	FORMAT 'ASCII' QUOTES ON
	ORDER OFF ESCAPES ON
	CHECK CONSTRAINTS OFF COMPUTES OFF
	STRIP OFF DELIMITED BY ','
go

LOAD TABLE "DBA"."fUnit_byLoad" ("Id", "UnitId", "Id_byLoad", "isLoad_toServer", "isLoad_fromServer", "isGroupBill" )
	FROM 'D:\\Database\\Alan\\unload\\504.dat'
	FORMAT 'ASCII' QUOTES ON
	ORDER OFF ESCAPES ON
	CHECK CONSTRAINTS OFF COMPUTES OFF
	STRIP OFF DELIMITED BY ','
go
LOAD TABLE "DBA"."fClientInformation" ("ClientID", "FirmName", "KodNalog", "AddressFirm", "Telefon", "KodSvid", "isNDS", "PriceListId", "OKPO", "PriceListAkcID", "StartDateAkc", "EndDateAkc", "PriceListOldID", "FioBuh", "GLN", "GLNMain" )
	FROM 'D:\\Database\\Alan\\unload\\456.dat'
	FORMAT 'ASCII' QUOTES ON
	ORDER OFF ESCAPES ON
	CHECK CONSTRAINTS OFF COMPUTES OFF
	STRIP OFF DELIMITED BY ','
go

-- create VIEW DBA._fUnit_byLoadView as select max(Id_byLoad) as Id_byLoad, UnitId from dba.fUnit_byLoad where fUnit_byLoad.Id_byLoad<>0 group by UnitId
-- select * from dba._fUnit_byLoadView
go
CREATE TABLE "DBA"."_fUnit_byLoadView"
(
	"UnitId"        		integer NOT NULL ,
	"Id_byLoad"     		integer NULL ,
	 PRIMARY KEY ("UnitId"),
	
)
go
CREATE INDEX "_fUnit_byLoadView_Id_byLoad_IDX" ON "DBA"."_fUnit_byLoadView"
(
	"Id_byLoad" ASC
)
go

insert into DBA._fUnit_byLoadView (Id_byLoad, UnitId) select max(Id_byLoad) as Id_byLoad, UnitId from dba.fUnit_byLoad where fUnit_byLoad.Id_byLoad<>0 group by UnitId
go

update DBA.fGoodsProperty_Detail_byLoad set Id_byLoad= 2666 where GoodsPropertyId = 802  and KindPackageId = 13;
update DBA.fGoodsProperty_Detail_byLoad set Id_byLoad= 1616 where GoodsPropertyId = 1592  and KindPackageId = 4;
update DBA.fGoodsProperty_Detail_byLoad set Id_byLoad= 1617 where GoodsPropertyId = 1592  and KindPackageId = 5;
update DBA.fGoodsProperty_Detail_byLoad set Id_byLoad= 2058 where GoodsPropertyId = 1131  and KindPackageId = 29;

-- delete from MovementItemFloat where MovementItemId in (SELECT Id FROM MovementItem where ObjectId is null  and MovementId in (select Id from Movement where OperDate between '02.01.2013' and '28.02.2014' ));
-- delete from movementitemlinkobject where MovementItemId in (SELECT Id FROM MovementItem where ObjectId is null  and MovementId in (select Id from Movement where OperDate between '02.01.2013' and '28.02.2014' ));
-- delete from movementitemString where MovementItemId in (SELECT Id FROM MovementItem where ObjectId is null  and MovementId in (select Id from Movement where OperDate between '02.01.2013' and '28.02.2014' ));
-- delete from MovementItem where ObjectId is null  and MovementId in (select Id from Movement where OperDate between '02.01.2013' and '28.02.2014' );

go	

