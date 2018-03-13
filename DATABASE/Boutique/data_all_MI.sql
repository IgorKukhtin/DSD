-- select distinct DatabaseId from _data_all
-- select distinct DatabaseId from _dataRet_all
-- select distinct DatabaseId from _dataPay_all 
-- select distinct DatabaseId from _dataBI_all
-- select DiscountKlientAccountMoney.* from DiscountKlientAccountMoney left outer join _dataPay_all  on _dataPay_all.ReplId = DiscountKlientAccountMoney.ReplId and _dataPay_all.DatabaseId = DiscountKlientAccountMoney.DatabaseId where _dataPay_all.ReplId is null and DiscountKlientAccountMoney.isErased = 1 and DiscountKlientAccountMoney.DatabaseId not in (3,6)
-- select DiscountKlientAccountMoney.* from DiscountKlientAccountMoney join _dataPay_all  on _dataPay_all.ReplId = DiscountKlientAccountMoney.ReplId and _dataPay_all.DatabaseId = DiscountKlientAccountMoney.DatabaseId where _dataPay_all.DiscountMovementItemReturnId > 0 AND DiscountKlientAccountMoney.DiscountMovementItemReturnId is null and DiscountKlientAccountMoney.isErased = 1
-- truncate table _data_all; truncate table _dataRet_all; truncate table _dataPay_all; truncate table _DataBI_all;; truncate table _DataMove_all;
-- select * from _data_all    where BillItemsId > 0 and BillItemsId in (select BillItemsId from _data_all    where BillItemsId > 0 group by BillItemsId having count(*) > 1) order by BillItemsId desc
-- select * from _dataRet_all where BillItemsId > 0 and BillItemsId in (select BillItemsId from _dataRet_all where BillItemsId > 0 group by BillItemsId having count(*) > 1)


-- !!!������� ������!!!
-- delete from _pgSummDiscountManual;
-- insert into _pgSummDiscountManual (DiscountMovementItemId, SummDiscountManual) select  DiscountMovementItemId, SummDiscountManual from _pgSummDiscountManual_view;

--
-- 1. ��������� ��� ���� ��� - ������� + �������� - !!!� ����!!! ����� �����������
--
-- 01
select Id,DiscountMovementId,BillItemsIncomeId,BarCode_byClient,OperCount,OperPrice,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,TotalSummReturnToPay,TotalSummReturnPay,TotalSummReturnPayCurrent,TotalReturnOperCount,SummDiscountManual,replId,DatabaseId,BillItemsId,isReplication,DiscountTax from DBA.DiscountMovementItem_byBarCode order by 1;
output  to 'c:\Profimanager\01mm.dat' FORMAT ASCII;
go
select ID,BillID,OperCount,OperPrice,BillKind,SummIn,SummInTotal,SummOutTotal,GoodsPropertyID,BillItemsIncomeID,ParentBillItemsID,PriceListPrice,SummInBII,SummInTotalBII,ReturnCount,GoodsID,UserID,ProtocolDate,ParentBillDate,replId,DatabaseId from DBA.BillItems order by 1;
output  to 'c:\Profimanager\01mmBI.dat' FORMAT ASCII;
go
select Id,DiscountMovementId,BillItemsIncomeId,OperCount,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,DiscountMovementItemId,replId,DatabaseId,BillItemsId,isReplication from DBA.DiscountMovementItemReturn_byBarCode order by 1;
output  to 'c:\Profimanager\011mm.dat' FORMAT ASCII;
go
select ID,DiscountKlientId,OperDate,Summa,KursClient,NominalKursClient,isKursToValutaClient,DiscountMovementItemId,InsertUserID,InsertDate,KassaId,UpdateUserID,UpdateDate,isCurrent,isErased,CommentInfo,DiscountMovementItemReturnId,SummDiscountManual,replId,DatabaseId,ClientAccountMoneyId from DBA.DiscountKlientAccountMoney order by 1;
output  to 'c:\Profimanager\0111mm.dat' FORMAT ASCII;
go
select ID,OperDate,FromKassaID,ToKassaID,SummaFrom,SummaTo,Kurs,NominalKurs,isKursToValuta,InsertUserID,InsertDate,UpdateUserID,UpdateDate,DiscountMovementId,DiscountKlientAccountMoneyId,isErased,replId,DatabaseId,KassaMoveMoneyId from DBA.DiscountKassaMoveMoney order by 1;
output  to 'c:\Profimanager\01mmMov.dat' FORMAT ASCII;
go

-- 02
select Id,DiscountMovementId,BillItemsIncomeId,BarCode_byClient,OperCount,OperPrice,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,TotalSummReturnToPay,TotalSummReturnPay,TotalSummReturnPayCurrent,TotalReturnOperCount,SummDiscountManual,replId,DatabaseId,BillItemsId,isReplication,DiscountTax from DBA.DiscountMovementItem_byBarCode order by 1;
output  to 'c:\Profimanager\02tl.dat' FORMAT ASCII;
go
select ID,BillID,OperCount,OperPrice,BillKind,SummIn,SummInTotal,SummOutTotal,GoodsPropertyID,BillItemsIncomeID,ParentBillItemsID,PriceListPrice,SummInBII,SummInTotalBII,ReturnCount,GoodsID,UserID,ProtocolDate,ParentBillDate,replId,DatabaseId from DBA.BillItems order by 1;
output  to 'c:\Profimanager\02tlBI.dat' FORMAT ASCII;
go
select Id,DiscountMovementId,BillItemsIncomeId,OperCount,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,DiscountMovementItemId,replId,DatabaseId,BillItemsId,isReplication from DBA.DiscountMovementItemReturn_byBarCode order by 1;
output  to 'c:\Profimanager\022tl.dat' FORMAT ASCII;
go
select ID,DiscountKlientId,OperDate,Summa,KursClient,NominalKursClient,isKursToValutaClient,DiscountMovementItemId,InsertUserID,InsertDate,KassaId,UpdateUserID,UpdateDate,isCurrent,isErased,CommentInfo,DiscountMovementItemReturnId,SummDiscountManual,replId,DatabaseId,ClientAccountMoneyId from DBA.DiscountKlientAccountMoney order by 1;
output  to 'c:\Profimanager\0222tl.dat' FORMAT ASCII;
go
select ID,OperDate,FromKassaID,ToKassaID,SummaFrom,SummaTo,Kurs,NominalKurs,isKursToValuta,InsertUserID,InsertDate,UpdateUserID,UpdateDate,DiscountMovementId,DiscountKlientAccountMoneyId,isErased,replId,DatabaseId,KassaMoveMoneyId from DBA.DiscountKassaMoveMoney order by 1;
output  to 'c:\Profimanager\02tlMov.dat' FORMAT ASCII;
go


-- 03
select Id,DiscountMovementId,BillItemsIncomeId,BarCode_byClient,OperCount,OperPrice,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,TotalSummReturnToPay,TotalSummReturnPay,TotalSummReturnPayCurrent,TotalReturnOperCount,SummDiscountManual,replId,DatabaseId,BillItemsId,isReplication,DiscountTax from DBA.DiscountMovementItem_byBarCode order by 1;
output  to 'c:\Profimanager\03elem.dat' FORMAT ASCII;
go
select ID,BillID,OperCount,OperPrice,BillKind,SummIn,SummInTotal,SummOutTotal,GoodsPropertyID,BillItemsIncomeID,ParentBillItemsID,PriceListPrice,SummInBII,SummInTotalBII,ReturnCount,GoodsID,UserID,ProtocolDate,ParentBillDate,replId,DatabaseId from DBA.BillItems order by 1;
output  to 'c:\Profimanager\03elemBI.dat' FORMAT ASCII;
go
select Id,DiscountMovementId,BillItemsIncomeId,OperCount,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,DiscountMovementItemId,replId,DatabaseId,BillItemsId,isReplication from DBA.DiscountMovementItemReturn_byBarCode order by 1;
output  to 'c:\Profimanager\033elem.dat' FORMAT ASCII;
go
select ID,DiscountKlientId,OperDate,Summa,KursClient,NominalKursClient,isKursToValutaClient,DiscountMovementItemId,InsertUserID,InsertDate,KassaId,UpdateUserID,UpdateDate,isCurrent,isErased,CommentInfo,DiscountMovementItemReturnId,SummDiscountManual,replId,DatabaseId,ClientAccountMoneyId from DBA.DiscountKlientAccountMoney order by 1;
output  to 'c:\Profimanager\0333elem.dat' FORMAT ASCII;
go
select ID,OperDate,FromKassaID,ToKassaID,SummaFrom,SummaTo,Kurs,NominalKurs,isKursToValuta,InsertUserID,InsertDate,UpdateUserID,UpdateDate,DiscountMovementId,DiscountKlientAccountMoneyId,isErased,replId,DatabaseId,KassaMoveMoneyId from DBA.DiscountKassaMoveMoney order by 1;
output  to 'c:\Profimanager\03elemMov.dat' FORMAT ASCII;
go

-- 04
select Id,DiscountMovementId,BillItemsIncomeId,BarCode_byClient,OperCount,OperPrice,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,TotalSummReturnToPay,TotalSummReturnPay,TotalSummReturnPayCurrent,TotalReturnOperCount,SummDiscountManual,replId,DatabaseId,BillItemsId,isReplication,DiscountTax from DBA.DiscountMovementItem_byBarCode order by 1;
output  to 'c:\Profimanager\04chado.dat' FORMAT ASCII;
go
select ID,BillID,OperCount,OperPrice,BillKind,SummIn,SummInTotal,SummOutTotal,GoodsPropertyID,BillItemsIncomeID,ParentBillItemsID,PriceListPrice,SummInBII,SummInTotalBII,ReturnCount,GoodsID,UserID,ProtocolDate,ParentBillDate,replId,DatabaseId from DBA.BillItems order by 1;
output  to 'c:\Profimanager\04chadoBI.dat' FORMAT ASCII;
go
select Id,DiscountMovementId,BillItemsIncomeId,OperCount,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,DiscountMovementItemId,replId,DatabaseId,BillItemsId,isReplication from DBA.DiscountMovementItemReturn_byBarCode order by 1;
output  to 'c:\Profimanager\044chado.dat' FORMAT ASCII;
go
select ID,DiscountKlientId,OperDate,Summa,KursClient,NominalKursClient,isKursToValutaClient,DiscountMovementItemId,InsertUserID,InsertDate,KassaId,UpdateUserID,UpdateDate,isCurrent,isErased,CommentInfo,DiscountMovementItemReturnId,SummDiscountManual,replId,DatabaseId,ClientAccountMoneyId from DBA.DiscountKlientAccountMoney order by 1;
output  to 'c:\Profimanager\0444chado.dat' FORMAT ASCII;
go
select ID,OperDate,FromKassaID,ToKassaID,SummaFrom,SummaTo,Kurs,NominalKurs,isKursToValuta,InsertUserID,InsertDate,UpdateUserID,UpdateDate,DiscountMovementId,DiscountKlientAccountMoneyId,isErased,replId,DatabaseId,KassaMoveMoneyId from DBA.DiscountKassaMoveMoney order by 1;
output  to 'c:\Profimanager\04chadoMov.dat' FORMAT ASCII;
go


-- 05-1
select Id,DiscountMovementId,BillItemsIncomeId,BarCode_byClient,OperCount,OperPrice,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,TotalSummReturnToPay,TotalSummReturnPay,TotalSummReturnPayCurrent,TotalReturnOperCount,SummDiscountManual,replId,DatabaseId,BillItemsId,isReplication,DiscountTax from DBA.DiscountMovementItem_byBarCode order by 1;
output  to 'c:\Profimanager\05sav.dat' FORMAT ASCII;
go
select ID,BillID,OperCount,OperPrice,BillKind,SummIn,SummInTotal,SummOutTotal,GoodsPropertyID,BillItemsIncomeID,ParentBillItemsID,PriceListPrice,SummInBII,SummInTotalBII,ReturnCount,GoodsID,UserID,ProtocolDate,ParentBillDate,replId,DatabaseId from DBA.BillItems order by 1;
output  to 'c:\Profimanager\05savBI.dat' FORMAT ASCII;
go
select Id,DiscountMovementId,BillItemsIncomeId,OperCount,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,DiscountMovementItemId,replId,DatabaseId,BillItemsId,isReplication from DBA.DiscountMovementItemReturn_byBarCode order by 1;
output  to 'c:\Profimanager\055sav.dat' FORMAT ASCII;
go
select ID,DiscountKlientId,OperDate,Summa,KursClient,NominalKursClient,isKursToValutaClient,DiscountMovementItemId,InsertUserID,InsertDate,KassaId,UpdateUserID,UpdateDate,isCurrent,isErased,CommentInfo,DiscountMovementItemReturnId,SummDiscountManual,replId,DatabaseId,ClientAccountMoneyId from DBA.DiscountKlientAccountMoney order by 1;
output  to 'c:\Profimanager\0555sav.dat' FORMAT ASCII;
go
select ID,OperDate,FromKassaID,ToKassaID,SummaFrom,SummaTo,Kurs,NominalKurs,isKursToValuta,InsertUserID,InsertDate,UpdateUserID,UpdateDate,DiscountMovementId,DiscountKlientAccountMoneyId,isErased,replId,DatabaseId,KassaMoveMoneyId from DBA.DiscountKassaMoveMoney order by 1;
output  to 'c:\Profimanager\05savMov.dat' FORMAT ASCII;
go


-- 05-2
select Id,DiscountMovementId,BillItemsIncomeId,BarCode_byClient,OperCount,OperPrice,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,TotalSummReturnToPay,TotalSummReturnPay,TotalSummReturnPayCurrent,TotalReturnOperCount,SummDiscountManual,replId,DatabaseId,BillItemsId,isReplication,DiscountTax from DBA.DiscountMovementItem_byBarCode order by 1;
output  to 'c:\Profimanager\05pz.dat' FORMAT ASCII;
go
select ID,BillID,OperCount,OperPrice,BillKind,SummIn,SummInTotal,SummOutTotal,GoodsPropertyID,BillItemsIncomeID,ParentBillItemsID,PriceListPrice,SummInBII,SummInTotalBII,ReturnCount,GoodsID,UserID,ProtocolDate,ParentBillDate,replId,DatabaseId from DBA.BillItems order by 1;
output  to 'c:\Profimanager\05pzBI.dat' FORMAT ASCII;
go
select Id,DiscountMovementId,BillItemsIncomeId,OperCount,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,DiscountMovementItemId,replId,DatabaseId,BillItemsId,isReplication from DBA.DiscountMovementItemReturn_byBarCode order by 1;
output  to 'c:\Profimanager\055pz.dat' FORMAT ASCII;
go
select ID,DiscountKlientId,OperDate,Summa,KursClient,NominalKursClient,isKursToValutaClient,DiscountMovementItemId,InsertUserID,InsertDate,KassaId,UpdateUserID,UpdateDate,isCurrent,isErased,CommentInfo,DiscountMovementItemReturnId,SummDiscountManual,replId,DatabaseId,ClientAccountMoneyId from DBA.DiscountKlientAccountMoney order by 1;
output  to 'c:\Profimanager\0555pz.dat' FORMAT ASCII;
go
select ID,OperDate,FromKassaID,ToKassaID,SummaFrom,SummaTo,Kurs,NominalKurs,isKursToValuta,InsertUserID,InsertDate,UpdateUserID,UpdateDate,DiscountMovementId,DiscountKlientAccountMoneyId,isErased,replId,DatabaseId,KassaMoveMoneyId from DBA.DiscountKassaMoveMoney order by 1;
output  to 'c:\Profimanager\05pzMov.dat' FORMAT ASCII;
go

-- 06
select Id,DiscountMovementId,BillItemsIncomeId,BarCode_byClient,OperCount,OperPrice,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,TotalSummReturnToPay,TotalSummReturnPay,TotalSummReturnPayCurrent,TotalReturnOperCount,SummDiscountManual,replId,DatabaseId,BillItemsId,isReplication,DiscountTax from DBA.DiscountMovementItem_byBarCode order by 1;
output  to 'c:\Profimanager\06ter_Vin.dat' FORMAT ASCII;
go
select ID,BillID,OperCount,OperPrice,BillKind,SummIn,SummInTotal,SummOutTotal,GoodsPropertyID,BillItemsIncomeID,ParentBillItemsID,PriceListPrice,SummInBII,SummInTotalBII,ReturnCount,GoodsID,UserID,ProtocolDate,ParentBillDate,replId,DatabaseId from DBA.BillItems order by 1;
output  to 'c:\Profimanager\06ter_VinBI.dat' FORMAT ASCII;
go
select Id,DiscountMovementId,BillItemsIncomeId,OperCount,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,DiscountMovementItemId,replId,DatabaseId,BillItemsId,isReplication from DBA.DiscountMovementItemReturn_byBarCode order by 1;
output  to 'c:\Profimanager\066ter_Vin.dat' FORMAT ASCII;
go
select ID,DiscountKlientId,OperDate,Summa,KursClient,NominalKursClient,isKursToValutaClient,DiscountMovementItemId,InsertUserID,InsertDate,KassaId,UpdateUserID,UpdateDate,isCurrent,isErased,CommentInfo,DiscountMovementItemReturnId,SummDiscountManual,replId,DatabaseId,ClientAccountMoneyId from DBA.DiscountKlientAccountMoney order by 1;
output  to 'c:\Profimanager\0666ter_Vin.dat' FORMAT ASCII;
go
select ID,OperDate,FromKassaID,ToKassaID,SummaFrom,SummaTo,Kurs,NominalKurs,isKursToValuta,InsertUserID,InsertDate,UpdateUserID,UpdateDate,DiscountMovementId,DiscountKlientAccountMoneyId,isErased,replId,DatabaseId,KassaMoveMoneyId from DBA.DiscountKassaMoveMoney order by 1;
output  to 'c:\Profimanager\06ter_VinMov.dat' FORMAT ASCII;
go


-- 07
select Id,DiscountMovementId,BillItemsIncomeId,BarCode_byClient,OperCount,OperPrice,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,TotalSummReturnToPay,TotalSummReturnPay,TotalSummReturnPayCurrent,TotalReturnOperCount,SummDiscountManual,replId,DatabaseId,BillItemsId,isReplication,DiscountTax from DBA.DiscountMovementItem_byBarCode order by 1;
output  to 'c:\Profimanager\07Vintag.dat' FORMAT ASCII;
go
select ID,BillID,OperCount,OperPrice,BillKind,SummIn,SummInTotal,SummOutTotal,GoodsPropertyID,BillItemsIncomeID,ParentBillItemsID,PriceListPrice,SummInBII,SummInTotalBII,ReturnCount,GoodsID,UserID,ProtocolDate,ParentBillDate,replId,DatabaseId from DBA.BillItems order by 1;
output  to 'c:\Profimanager\07VintagBI.dat' FORMAT ASCII;
go
select Id,DiscountMovementId,BillItemsIncomeId,OperCount,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,DiscountMovementItemId,replId,DatabaseId,BillItemsId,isReplication from DBA.DiscountMovementItemReturn_byBarCode order by 1;
output  to 'c:\Profimanager\077Vintag.dat' FORMAT ASCII;
go
select ID,DiscountKlientId,OperDate,Summa,KursClient,NominalKursClient,isKursToValutaClient,DiscountMovementItemId,InsertUserID,InsertDate,KassaId,UpdateUserID,UpdateDate,isCurrent,isErased,CommentInfo,DiscountMovementItemReturnId,SummDiscountManual,replId,DatabaseId,ClientAccountMoneyId from DBA.DiscountKlientAccountMoney order by 1;
output  to 'c:\Profimanager\0777Vintag.dat' FORMAT ASCII;
go
select ID,OperDate,FromKassaID,ToKassaID,SummaFrom,SummaTo,Kurs,NominalKurs,isKursToValuta,InsertUserID,InsertDate,UpdateUserID,UpdateDate,DiscountMovementId,DiscountKlientAccountMoneyId,isErased,replId,DatabaseId,KassaMoveMoneyId from DBA.DiscountKassaMoveMoney order by 1;
output  to 'c:\Profimanager\07VintagMov.dat' FORMAT ASCII;
go


-- 08
select Id,DiscountMovementId,BillItemsIncomeId,BarCode_byClient,OperCount,OperPrice,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,TotalSummReturnToPay,TotalSummReturnPay,TotalSummReturnPayCurrent,TotalReturnOperCount,SummDiscountManual,replId,DatabaseId,BillItemsId,isReplication,DiscountTax from DBA.DiscountMovementItem_byBarCode order by 1;
output  to 'c:\Profimanager\08escada.dat' FORMAT ASCII;
go
select ID,BillID,OperCount,OperPrice,BillKind,SummIn,SummInTotal,SummOutTotal,GoodsPropertyID,BillItemsIncomeID,ParentBillItemsID,PriceListPrice,SummInBII,SummInTotalBII,ReturnCount,GoodsID,UserID,ProtocolDate,ParentBillDate,replId,DatabaseId from DBA.BillItems order by 1;
output  to 'c:\Profimanager\08escadaBI.dat' FORMAT ASCII;
go
select Id,DiscountMovementId,BillItemsIncomeId,OperCount,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,DiscountMovementItemId,replId,DatabaseId,BillItemsId,isReplication from DBA.DiscountMovementItemReturn_byBarCode order by 1;
output  to 'c:\Profimanager\088escada.dat' FORMAT ASCII;
go
select ID,DiscountKlientId,OperDate,Summa,KursClient,NominalKursClient,isKursToValutaClient,DiscountMovementItemId,InsertUserID,InsertDate,KassaId,UpdateUserID,UpdateDate,isCurrent,isErased,CommentInfo,DiscountMovementItemReturnId,SummDiscountManual,replId,DatabaseId,ClientAccountMoneyId from DBA.DiscountKlientAccountMoney order by 1;
output  to 'c:\Profimanager\0888escada.dat' FORMAT ASCII;
go
select ID,OperDate,FromKassaID,ToKassaID,SummaFrom,SummaTo,Kurs,NominalKurs,isKursToValuta,InsertUserID,InsertDate,UpdateUserID,UpdateDate,DiscountMovementId,DiscountKlientAccountMoneyId,isErased,replId,DatabaseId,KassaMoveMoneyId from DBA.DiscountKassaMoveMoney order by 1;
output  to 'c:\Profimanager\08escadaMov.dat' FORMAT ASCII;
go


-- 09
select Id,DiscountMovementId,BillItemsIncomeId,BarCode_byClient,OperCount,OperPrice,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,TotalSummReturnToPay,TotalSummReturnPay,TotalSummReturnPayCurrent,TotalReturnOperCount,SummDiscountManual,replId,DatabaseId,BillItemsId,isReplication,DiscountTax from DBA.DiscountMovementItem_byBarCode order by 1;
output  to 'c:\Profimanager\09sv_vintag.dat' FORMAT ASCII;
go
select ID,BillID,OperCount,OperPrice,BillKind,SummIn,SummInTotal,SummOutTotal,GoodsPropertyID,BillItemsIncomeID,ParentBillItemsID,PriceListPrice,SummInBII,SummInTotalBII,ReturnCount,GoodsID,UserID,ProtocolDate,ParentBillDate,replId,DatabaseId from DBA.BillItems order by 1;
output  to 'c:\Profimanager\09sv_vintagBI.dat' FORMAT ASCII;
go
select Id,DiscountMovementId,BillItemsIncomeId,OperCount,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,DiscountMovementItemId,replId,DatabaseId,BillItemsId,isReplication from DBA.DiscountMovementItemReturn_byBarCode order by 1;
output  to 'c:\Profimanager\099sv_vintag.dat' FORMAT ASCII;
go
select ID,DiscountKlientId,OperDate,Summa,KursClient,NominalKursClient,isKursToValutaClient,DiscountMovementItemId,InsertUserID,InsertDate,KassaId,UpdateUserID,UpdateDate,isCurrent,isErased,CommentInfo,DiscountMovementItemReturnId,SummDiscountManual,replId,DatabaseId,ClientAccountMoneyId from DBA.DiscountKlientAccountMoney order by 1;
output  to 'c:\Profimanager\0999sv_vintag.dat' FORMAT ASCII;
go
select ID,OperDate,FromKassaID,ToKassaID,SummaFrom,SummaTo,Kurs,NominalKurs,isKursToValuta,InsertUserID,InsertDate,UpdateUserID,UpdateDate,DiscountMovementId,DiscountKlientAccountMoneyId,isErased,replId,DatabaseId,KassaMoveMoneyId from DBA.DiscountKassaMoveMoney order by 1;
output  to 'c:\Profimanager\09sv_vintagMov.dat' FORMAT ASCII;
go

-- 10
select Id,DiscountMovementId,BillItemsIncomeId,BarCode_byClient,OperCount,OperPrice,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,TotalSummReturnToPay,TotalSummReturnPay,TotalSummReturnPayCurrent,TotalReturnOperCount,SummDiscountManual,replId,DatabaseId,BillItemsId,isReplication,DiscountTax from DBA.DiscountMovementItem_byBarCode order by 1;
output  to 'c:\Profimanager\10sopra.dat' FORMAT ASCII;
go
select ID,BillID,OperCount,OperPrice,BillKind,SummIn,SummInTotal,SummOutTotal,GoodsPropertyID,BillItemsIncomeID,ParentBillItemsID,PriceListPrice,SummInBII,SummInTotalBII,ReturnCount,GoodsID,UserID,ProtocolDate,ParentBillDate,replId,DatabaseId from DBA.BillItems order by 1;
output  to 'c:\Profimanager\10sopraBI.dat' FORMAT ASCII;
go
select Id,DiscountMovementId,BillItemsIncomeId,OperCount,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,DiscountMovementItemId,replId,DatabaseId,BillItemsId,isReplication from DBA.DiscountMovementItemReturn_byBarCode order by 1;
output  to 'c:\Profimanager\1010sopra.dat' FORMAT ASCII;
go
select ID,DiscountKlientId,OperDate,Summa,KursClient,NominalKursClient,isKursToValutaClient,DiscountMovementItemId,InsertUserID,InsertDate,KassaId,UpdateUserID,UpdateDate,isCurrent,isErased,CommentInfo,DiscountMovementItemReturnId,SummDiscountManual,replId,DatabaseId,ClientAccountMoneyId from DBA.DiscountKlientAccountMoney order by 1;
output  to 'c:\Profimanager\101010sopra.dat' FORMAT ASCII;
go
select ID,OperDate,FromKassaID,ToKassaID,SummaFrom,SummaTo,Kurs,NominalKurs,isKursToValuta,InsertUserID,InsertDate,UpdateUserID,UpdateDate,DiscountMovementId,DiscountKlientAccountMoneyId,isErased,replId,DatabaseId,KassaMoveMoneyId from DBA.DiscountKassaMoveMoney order by 1;
output  to 'c:\Profimanager\10sopraMov.dat' FORMAT ASCII;
go


-- 11
select Id,DiscountMovementId,BillItemsIncomeId,BarCode_byClient,OperCount,OperPrice,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,TotalSummReturnToPay,TotalSummReturnPay,TotalSummReturnPayCurrent,TotalReturnOperCount,SummDiscountManual,replId,DatabaseId,BillItemsId,isReplication,DiscountTax from DBA.DiscountMovementItem_byBarCode order by 1;
output  to 'c:\Profimanager\11ChadoOut.dat' FORMAT ASCII;
go
select ID,BillID,OperCount,OperPrice,BillKind,SummIn,SummInTotal,SummOutTotal,GoodsPropertyID,BillItemsIncomeID,ParentBillItemsID,PriceListPrice,SummInBII,SummInTotalBII,ReturnCount,GoodsID,UserID,ProtocolDate,ParentBillDate,replId,DatabaseId from DBA.BillItems order by 1;
output  to 'c:\Profimanager\11ChadoOutBI.dat' FORMAT ASCII;
go
select Id,DiscountMovementId,BillItemsIncomeId,OperCount,CommentInfo,TotalSummToPay,TotalSummPay,TotalSummPayCurrent,DiscountMovementItemId,replId,DatabaseId,BillItemsId,isReplication from DBA.DiscountMovementItemReturn_byBarCode order by 1;
output  to 'c:\Profimanager\1111ChadoOut.dat' FORMAT ASCII;
go
select ID,DiscountKlientId,OperDate,Summa,KursClient,NominalKursClient,isKursToValutaClient,DiscountMovementItemId,InsertUserID,InsertDate,KassaId,UpdateUserID,UpdateDate,isCurrent,isErased,CommentInfo,DiscountMovementItemReturnId,SummDiscountManual,replId,DatabaseId,ClientAccountMoneyId from DBA.DiscountKlientAccountMoney order by 1;
output  to 'c:\Profimanager\111111ChadoOut.dat' FORMAT ASCII;
go
select ID,OperDate,FromKassaID,ToKassaID,SummaFrom,SummaTo,Kurs,NominalKurs,isKursToValuta,InsertUserID,InsertDate,UpdateUserID,UpdateDate,DiscountMovementId,DiscountKlientAccountMoneyId,isErased,replId,DatabaseId,KassaMoveMoneyId from DBA.DiscountKassaMoveMoney order by 1;
output  to 'c:\Profimanager\11ChadoOutMov.dat' FORMAT ASCII;
go


--
-- 2. ��������� � 1 ������� ��� �������
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
-- 3. ��������� � 2 ������� ��� �������� 
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
-- 4. ��������� � 3 ������� ��� ������
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



--
-- 2. ��������� � 4 ������� ��� BI - �������
--
LOAD TABLE DBA._DataBI_all
	FROM 'C:\\PROFIMANAGER\\01mmBI.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._DataBI_all
	FROM 'C:\\PROFIMANAGER\\02tlBI.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._DataBI_all
	FROM 'C:\\PROFIMANAGER\\03elemBI.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._DataBI_all
	FROM 'C:\\PROFIMANAGER\\04chadoBI.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._DataBI_all
	FROM 'C:\\PROFIMANAGER\\05savBI.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._DataBI_all
	FROM 'C:\\PROFIMANAGER\\05pzBI.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._DataBI_all
	FROM 'C:\\PROFIMANAGER\\06ter_VinBI.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._DataBI_all
	FROM 'C:\\PROFIMANAGER\\07VintagBI.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._DataBI_all
	FROM 'C:\\PROFIMANAGER\\08escadaBI.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._DataBI_all
	FROM 'C:\\PROFIMANAGER\\09sv_vintagBI.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._DataBI_all
	FROM 'C:\\PROFIMANAGER\\10sopraBI.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._DataBI_all
	FROM 'C:\\PROFIMANAGER\\11ChadoOutBI.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go



--
-- 3. ��������� � 5 ������� ��� Mov - ������
--
LOAD TABLE DBA._DataMove_all
	FROM 'C:\\PROFIMANAGER\\01mmMov.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._DataMove_all
	FROM 'C:\\PROFIMANAGER\\02tlMov.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
--LOAD TABLE DBA._DataMove_all
--	FROM 'C:\\PROFIMANAGER\\03elemMov.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
LOAD TABLE DBA._DataMove_all
	FROM 'C:\\PROFIMANAGER\\04chadoMov.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._DataMove_all
	FROM 'C:\\PROFIMANAGER\\05savMov.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._DataMove_all
	FROM 'C:\\PROFIMANAGER\\05pzMov.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._DataMove_all
	FROM 'C:\\PROFIMANAGER\\06ter_VinMov.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._DataMove_all
	FROM 'C:\\PROFIMANAGER\\07VintagMov.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._DataMove_all
	FROM 'C:\\PROFIMANAGER\\08escadaMov.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
LOAD TABLE DBA._DataMove_all
	FROM 'C:\\PROFIMANAGER\\09sv_vintagMov.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go
--LOAD TABLE DBA._DataMove_all
--	FROM 'C:\\PROFIMANAGER\\10sopraMov.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
LOAD TABLE DBA._DataMove_all
	FROM 'C:\\PROFIMANAGER\\11ChadoOutMov.dat'
	FORMAT 'ASCII'
	QUOTES ON ESCAPES ON STRIP OFF
	DELIMITED BY ','
go

