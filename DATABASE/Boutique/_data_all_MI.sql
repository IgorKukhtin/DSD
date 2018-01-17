-- select distinct DatabaseId from _data_all
-- select distinct DatabaseId from _dataRet_all
-- select distinct DatabaseId from _dataPay_all 
-- select DiscountKlientAccountMoney.* from DiscountKlientAccountMoney left outer join _dataPay_all  on _dataPay_all.ReplId = DiscountKlientAccountMoney.ReplId and _dataPay_all.DatabaseId = DiscountKlientAccountMoney.DatabaseId where _dataPay_all.ReplId is null and DiscountKlientAccountMoney.isErased = 1 and DiscountKlientAccountMoney.DatabaseId not in (3,6)
-- select DiscountKlientAccountMoney.* from DiscountKlientAccountMoney join _dataPay_all  on _dataPay_all.ReplId = DiscountKlientAccountMoney.ReplId and _dataPay_all.DatabaseId = DiscountKlientAccountMoney.DatabaseId where _dataPay_all.DiscountMovementItemReturnId > 0 AND DiscountKlientAccountMoney.DiscountMovementItemReturnId is null and DiscountKlientAccountMoney.isErased = 1
-- truncate table _data_all; truncate table _dataRet_all; truncate table _dataPay_all;
-- select * from _data_all    where BillItemsId > 0 and BillItemsId in (select BillItemsId from _data_all    where BillItemsId > 0 group by BillItemsId having count(*) > 1) order by BillItemsId desc
-- select * from _dataRet_all where BillItemsId > 0 and BillItemsId in (select BillItemsId from _dataRet_all where BillItemsId > 0 group by BillItemsId having count(*) > 1)


--
-- 1. Выгрузили сво всех маг - Продажи + Возвраты - !!!в файл!!! потом скопировали
--
-- 01
select Id,DiscountMovementId,BillItemsIncomeId,BarCode_byClient,OperCount,OperPrice,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,TotalSummReturnToPay,TotalSummReturnPay,TotalSummReturnPayCurrent,TotalReturnOperCount,SummDiscountManual,replId,DatabaseId,BillItemsId,isReplication,DiscountTax from DBA.DiscountMovementItem_byBarCode order by 1;
output  to 'c:\Profimanager\01mm.dat' FORMAT ASCII;
go
select Id,DiscountMovementId,BillItemsIncomeId,OperCount,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,DiscountMovementItemId,replId,DatabaseId,BillItemsId,isReplication from DBA.DiscountMovementItemReturn_byBarCode order by 1;
output  to 'c:\Profimanager\011mm.dat' FORMAT ASCII;
go
select ID,DiscountKlientId,OperDate,Summa,KursClient,NominalKursClient,isKursToValutaClient,DiscountMovementItemId,InsertUserID,InsertDate,KassaId,UpdateUserID,UpdateDate,isCurrent,isErased,CommentInfo,DiscountMovementItemReturnId,SummDiscountManual,replId,DatabaseId,ClientAccountMoneyId from DBA.DiscountKlientAccountMoney order by 1;
output  to 'c:\Profimanager\0111mm.dat' FORMAT ASCII;
go

-- 02
select Id,DiscountMovementId,BillItemsIncomeId,BarCode_byClient,OperCount,OperPrice,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,TotalSummReturnToPay,TotalSummReturnPay,TotalSummReturnPayCurrent,TotalReturnOperCount,SummDiscountManual,replId,DatabaseId,BillItemsId,isReplication,DiscountTax from DBA.DiscountMovementItem_byBarCode order by 1;
output  to 'c:\Profimanager\02TL.dat' FORMAT ASCII;
go
select Id,DiscountMovementId,BillItemsIncomeId,OperCount,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,DiscountMovementItemId,replId,DatabaseId,BillItemsId,isReplication from DBA.DiscountMovementItemReturn_byBarCode order by 1;
output  to 'c:\Profimanager\022TL.dat' FORMAT ASCII;
go
select ID,DiscountKlientId,OperDate,Summa,KursClient,NominalKursClient,isKursToValutaClient,DiscountMovementItemId,InsertUserID,InsertDate,KassaId,UpdateUserID,UpdateDate,isCurrent,isErased,CommentInfo,DiscountMovementItemReturnId,SummDiscountManual,replId,DatabaseId,ClientAccountMoneyId from DBA.DiscountKlientAccountMoney order by 1;
output  to 'c:\Profimanager\0222TL.dat' FORMAT ASCII;
go


-- 03
select Id,DiscountMovementId,BillItemsIncomeId,BarCode_byClient,OperCount,OperPrice,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,TotalSummReturnToPay,TotalSummReturnPay,TotalSummReturnPayCurrent,TotalReturnOperCount,SummDiscountManual,replId,DatabaseId,BillItemsId,isReplication,DiscountTax from DBA.DiscountMovementItem_byBarCode order by 1;
output  to 'c:\Profimanager\03elem.dat' FORMAT ASCII;
go
select Id,DiscountMovementId,BillItemsIncomeId,OperCount,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,DiscountMovementItemId,replId,DatabaseId,BillItemsId,isReplication from DBA.DiscountMovementItemReturn_byBarCode order by 1;
output  to 'c:\Profimanager\033elem.dat' FORMAT ASCII;
go
select ID,DiscountKlientId,OperDate,Summa,KursClient,NominalKursClient,isKursToValutaClient,DiscountMovementItemId,InsertUserID,InsertDate,KassaId,UpdateUserID,UpdateDate,isCurrent,isErased,CommentInfo,DiscountMovementItemReturnId,SummDiscountManual,replId,DatabaseId,ClientAccountMoneyId from DBA.DiscountKlientAccountMoney order by 1;
output  to 'c:\Profimanager\0333elem.dat' FORMAT ASCII;
go

-- 04
select Id,DiscountMovementId,BillItemsIncomeId,BarCode_byClient,OperCount,OperPrice,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,TotalSummReturnToPay,TotalSummReturnPay,TotalSummReturnPayCurrent,TotalReturnOperCount,SummDiscountManual,replId,DatabaseId,BillItemsId,isReplication,DiscountTax from DBA.DiscountMovementItem_byBarCode order by 1;
output  to 'c:\Profimanager\04chado.dat' FORMAT ASCII;
go
select Id,DiscountMovementId,BillItemsIncomeId,OperCount,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,DiscountMovementItemId,replId,DatabaseId,BillItemsId,isReplication from DBA.DiscountMovementItemReturn_byBarCode order by 1;
output  to 'c:\Profimanager\044chado.dat' FORMAT ASCII;
go
select ID,DiscountKlientId,OperDate,Summa,KursClient,NominalKursClient,isKursToValutaClient,DiscountMovementItemId,InsertUserID,InsertDate,KassaId,UpdateUserID,UpdateDate,isCurrent,isErased,CommentInfo,DiscountMovementItemReturnId,SummDiscountManual,replId,DatabaseId,ClientAccountMoneyId from DBA.DiscountKlientAccountMoney order by 1;
output  to 'c:\Profimanager\0444chado.dat' FORMAT ASCII;
go


-- 05-1
select Id,DiscountMovementId,BillItemsIncomeId,BarCode_byClient,OperCount,OperPrice,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,TotalSummReturnToPay,TotalSummReturnPay,TotalSummReturnPayCurrent,TotalReturnOperCount,SummDiscountManual,replId,DatabaseId,BillItemsId,isReplication,DiscountTax from DBA.DiscountMovementItem_byBarCode order by 1;
output  to 'c:\Profimanager\05sav.dat' FORMAT ASCII;
go
select Id,DiscountMovementId,BillItemsIncomeId,OperCount,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,DiscountMovementItemId,replId,DatabaseId,BillItemsId,isReplication from DBA.DiscountMovementItemReturn_byBarCode order by 1;
output  to 'c:\Profimanager\055sav.dat' FORMAT ASCII;
go
select ID,DiscountKlientId,OperDate,Summa,KursClient,NominalKursClient,isKursToValutaClient,DiscountMovementItemId,InsertUserID,InsertDate,KassaId,UpdateUserID,UpdateDate,isCurrent,isErased,CommentInfo,DiscountMovementItemReturnId,SummDiscountManual,replId,DatabaseId,ClientAccountMoneyId from DBA.DiscountKlientAccountMoney order by 1;
output  to 'c:\Profimanager\0555sav.dat' FORMAT ASCII;
go


-- 05-2
select Id,DiscountMovementId,BillItemsIncomeId,BarCode_byClient,OperCount,OperPrice,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,TotalSummReturnToPay,TotalSummReturnPay,TotalSummReturnPayCurrent,TotalReturnOperCount,SummDiscountManual,replId,DatabaseId,BillItemsId,isReplication,DiscountTax from DBA.DiscountMovementItem_byBarCode order by 1;
output  to 'c:\Profimanager\05pz.dat' FORMAT ASCII;
go
select Id,DiscountMovementId,BillItemsIncomeId,OperCount,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,DiscountMovementItemId,replId,DatabaseId,BillItemsId,isReplication from DBA.DiscountMovementItemReturn_byBarCode order by 1;
output  to 'c:\Profimanager\055pz.dat' FORMAT ASCII;
go
select ID,DiscountKlientId,OperDate,Summa,KursClient,NominalKursClient,isKursToValutaClient,DiscountMovementItemId,InsertUserID,InsertDate,KassaId,UpdateUserID,UpdateDate,isCurrent,isErased,CommentInfo,DiscountMovementItemReturnId,SummDiscountManual,replId,DatabaseId,ClientAccountMoneyId from DBA.DiscountKlientAccountMoney order by 1;
output  to 'c:\Profimanager\0555pz.dat' FORMAT ASCII;
go

-- 06
select Id,DiscountMovementId,BillItemsIncomeId,BarCode_byClient,OperCount,OperPrice,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,TotalSummReturnToPay,TotalSummReturnPay,TotalSummReturnPayCurrent,TotalReturnOperCount,SummDiscountManual,replId,DatabaseId,BillItemsId,isReplication,DiscountTax from DBA.DiscountMovementItem_byBarCode order by 1;
output  to 'c:\Profimanager\06ter_Vin.dat' FORMAT ASCII;
go
select Id,DiscountMovementId,BillItemsIncomeId,OperCount,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,DiscountMovementItemId,replId,DatabaseId,BillItemsId,isReplication from DBA.DiscountMovementItemReturn_byBarCode order by 1;
output  to 'c:\Profimanager\066ter_Vin.dat' FORMAT ASCII;
go
select ID,DiscountKlientId,OperDate,Summa,KursClient,NominalKursClient,isKursToValutaClient,DiscountMovementItemId,InsertUserID,InsertDate,KassaId,UpdateUserID,UpdateDate,isCurrent,isErased,CommentInfo,DiscountMovementItemReturnId,SummDiscountManual,replId,DatabaseId,ClientAccountMoneyId from DBA.DiscountKlientAccountMoney order by 1;
output  to 'c:\Profimanager\0666ter_Vin.dat' FORMAT ASCII;
go


-- 07
select Id,DiscountMovementId,BillItemsIncomeId,BarCode_byClient,OperCount,OperPrice,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,TotalSummReturnToPay,TotalSummReturnPay,TotalSummReturnPayCurrent,TotalReturnOperCount,SummDiscountManual,replId,DatabaseId,BillItemsId,isReplication,DiscountTax from DBA.DiscountMovementItem_byBarCode order by 1;
output  to 'c:\Profimanager\07Vintag.dat' FORMAT ASCII;
go
select Id,DiscountMovementId,BillItemsIncomeId,OperCount,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,DiscountMovementItemId,replId,DatabaseId,BillItemsId,isReplication from DBA.DiscountMovementItemReturn_byBarCode order by 1;
output  to 'c:\Profimanager\077Vintag.dat' FORMAT ASCII;
go
select ID,DiscountKlientId,OperDate,Summa,KursClient,NominalKursClient,isKursToValutaClient,DiscountMovementItemId,InsertUserID,InsertDate,KassaId,UpdateUserID,UpdateDate,isCurrent,isErased,CommentInfo,DiscountMovementItemReturnId,SummDiscountManual,replId,DatabaseId,ClientAccountMoneyId from DBA.DiscountKlientAccountMoney order by 1;
output  to 'c:\Profimanager\0777Vintag.dat' FORMAT ASCII;
go


-- 08
select Id,DiscountMovementId,BillItemsIncomeId,BarCode_byClient,OperCount,OperPrice,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,TotalSummReturnToPay,TotalSummReturnPay,TotalSummReturnPayCurrent,TotalReturnOperCount,SummDiscountManual,replId,DatabaseId,BillItemsId,isReplication,DiscountTax from DBA.DiscountMovementItem_byBarCode order by 1;
output  to 'c:\Profimanager\08escada.dat' FORMAT ASCII;
go
select Id,DiscountMovementId,BillItemsIncomeId,OperCount,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,DiscountMovementItemId,replId,DatabaseId,BillItemsId,isReplication from DBA.DiscountMovementItemReturn_byBarCode order by 1;
output  to 'c:\Profimanager\088escada.dat' FORMAT ASCII;
go
select ID,DiscountKlientId,OperDate,Summa,KursClient,NominalKursClient,isKursToValutaClient,DiscountMovementItemId,InsertUserID,InsertDate,KassaId,UpdateUserID,UpdateDate,isCurrent,isErased,CommentInfo,DiscountMovementItemReturnId,SummDiscountManual,replId,DatabaseId,ClientAccountMoneyId from DBA.DiscountKlientAccountMoney order by 1;
output  to 'c:\Profimanager\0888escada.dat' FORMAT ASCII;
go


-- 09
select Id,DiscountMovementId,BillItemsIncomeId,BarCode_byClient,OperCount,OperPrice,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,TotalSummReturnToPay,TotalSummReturnPay,TotalSummReturnPayCurrent,TotalReturnOperCount,SummDiscountManual,replId,DatabaseId,BillItemsId,isReplication,DiscountTax from DBA.DiscountMovementItem_byBarCode order by 1;
output  to 'c:\Profimanager\09sv_vintag.dat' FORMAT ASCII;
go
select Id,DiscountMovementId,BillItemsIncomeId,OperCount,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,DiscountMovementItemId,replId,DatabaseId,BillItemsId,isReplication from DBA.DiscountMovementItemReturn_byBarCode order by 1;
output  to 'c:\Profimanager\099sv_vintag.dat' FORMAT ASCII;
go
select ID,DiscountKlientId,OperDate,Summa,KursClient,NominalKursClient,isKursToValutaClient,DiscountMovementItemId,InsertUserID,InsertDate,KassaId,UpdateUserID,UpdateDate,isCurrent,isErased,CommentInfo,DiscountMovementItemReturnId,SummDiscountManual,replId,DatabaseId,ClientAccountMoneyId from DBA.DiscountKlientAccountMoney order by 1;
output  to 'c:\Profimanager\0999sv_vintag.dat' FORMAT ASCII;
go

-- 10
select Id,DiscountMovementId,BillItemsIncomeId,BarCode_byClient,OperCount,OperPrice,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,TotalSummReturnToPay,TotalSummReturnPay,TotalSummReturnPayCurrent,TotalReturnOperCount,SummDiscountManual,replId,DatabaseId,BillItemsId,isReplication,DiscountTax from DBA.DiscountMovementItem_byBarCode order by 1;
output  to 'c:\Profimanager\10sopra.dat' FORMAT ASCII;
go
select Id,DiscountMovementId,BillItemsIncomeId,OperCount,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,DiscountMovementItemId,replId,DatabaseId,BillItemsId,isReplication from DBA.DiscountMovementItemReturn_byBarCode order by 1;
output  to 'c:\Profimanager\1010sopra.dat' FORMAT ASCII;
go
select ID,DiscountKlientId,OperDate,Summa,KursClient,NominalKursClient,isKursToValutaClient,DiscountMovementItemId,InsertUserID,InsertDate,KassaId,UpdateUserID,UpdateDate,isCurrent,isErased,CommentInfo,DiscountMovementItemReturnId,SummDiscountManual,replId,DatabaseId,ClientAccountMoneyId from DBA.DiscountKlientAccountMoney order by 1;
output  to 'c:\Profimanager\101010sopra.dat' FORMAT ASCII;
go


-- 11
select Id,DiscountMovementId,BillItemsIncomeId,BarCode_byClient,OperCount,OperPrice,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,TotalSummReturnToPay,TotalSummReturnPay,TotalSummReturnPayCurrent,TotalReturnOperCount,SummDiscountManual,replId,DatabaseId,BillItemsId,isReplication,DiscountTax from DBA.DiscountMovementItem_byBarCode order by 1;
output  to 'c:\Profimanager\11ChadoOut.dat' FORMAT ASCII;
go
select Id,DiscountMovementId,BillItemsIncomeId,OperCount,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,DiscountMovementItemId,replId,DatabaseId,BillItemsId,isReplication from DBA.DiscountMovementItemReturn_byBarCode order by 1;
output  to 'c:\Profimanager\1111ChadoOut.dat' FORMAT ASCII;
go
select ID,DiscountKlientId,OperDate,Summa,KursClient,NominalKursClient,isKursToValutaClient,DiscountMovementItemId,InsertUserID,InsertDate,KassaId,UpdateUserID,UpdateDate,isCurrent,isErased,CommentInfo,DiscountMovementItemReturnId,SummDiscountManual,replId,DatabaseId,ClientAccountMoneyId from DBA.DiscountKlientAccountMoney order by 1;
output  to 'c:\Profimanager\111111ChadoOut.dat' FORMAT ASCII;
go


--
-- 2. Загрузили в 1 Таблицу все Продажи
--
LOAD TABLE DBA._data_all
	FROM 'C:\\PROFIMANAGER\\01mm.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._data_all
	FROM 'C:\\PROFIMANAGER\\02TL.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._data_all
	FROM 'C:\\PROFIMANAGER\\03elem.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._data_all
	FROM 'C:\\PROFIMANAGER\\04chado.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._data_all
	FROM 'C:\\PROFIMANAGER\\05sav.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._data_all
	FROM 'C:\\PROFIMANAGER\\05pz.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._data_all
	FROM 'C:\\PROFIMANAGER\\06ter_Vin.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._data_all
	FROM 'C:\\PROFIMANAGER\\07Vintag.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._data_all
	FROM 'C:\\PROFIMANAGER\\08escada.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._data_all
	FROM 'C:\\PROFIMANAGER\\09sv_vintag.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._data_all
	FROM 'C:\\PROFIMANAGER\\10sopra.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._data_all
	FROM 'C:\\PROFIMANAGER\\11ChadoOut.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go

--
-- RETURN
--

--
-- 3. Загрузили в 1 Таблицу все Возвраты 
--

LOAD TABLE DBA._dataRet_all
	FROM 'C:\\PROFIMANAGER\\011mm.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._dataRet_all
	FROM 'C:\\PROFIMANAGER\\022TL.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._dataRet_all
	FROM 'C:\\PROFIMANAGER\\033elem.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._dataRet_all
	FROM 'C:\\PROFIMANAGER\\044chado.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._dataRet_all
	FROM 'C:\\PROFIMANAGER\\055sav.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._dataRet_all
	FROM 'C:\\PROFIMANAGER\\055pz.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._dataRet_all
	FROM 'C:\\PROFIMANAGER\\066ter_Vin.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._dataRet_all
	FROM 'C:\\PROFIMANAGER\\077Vintag.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._dataRet_all
	FROM 'C:\\PROFIMANAGER\\088escada.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._dataRet_all
	FROM 'C:\\PROFIMANAGER\\099sv_vintag.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._dataRet_all
	FROM 'C:\\PROFIMANAGER\\1010sopra.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._dataRet_all
	FROM 'C:\\PROFIMANAGER\\1111ChadoOut.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go



--
-- 4. Загрузили в 1 Таблицу все Оплаты
--

LOAD TABLE DBA._dataPay_all
	FROM 'C:\\PROFIMANAGER\\0111mm.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._dataPay_all
	FROM 'C:\\PROFIMANAGER\\0222TL.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._dataPay_all
	FROM 'C:\\PROFIMANAGER\\0333elem.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._dataPay_all
	FROM 'C:\\PROFIMANAGER\\0444chado.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._dataPay_all
	FROM 'C:\\PROFIMANAGER\\0555sav.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._dataPay_all
	FROM 'C:\\PROFIMANAGER\\0555pz.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._dataPay_all
	FROM 'C:\\PROFIMANAGER\\0666ter_Vin.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._dataPay_all
	FROM 'C:\\PROFIMANAGER\\0777Vintag.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._dataPay_all
	FROM 'C:\\PROFIMANAGER\\0888escada.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._dataPay_all
	FROM 'C:\\PROFIMANAGER\\0999sv_vintag.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._dataPay_all
	FROM 'C:\\PROFIMANAGER\\101010sopra.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._dataPay_all
	FROM 'C:\\PROFIMANAGER\\111111ChadoOut.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go

