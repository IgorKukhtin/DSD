-- select DiscountKlientAccountMoney.* from  DiscountMovement join "dba".DiscountMovementItem_byBarCode on DiscountMovementId = DiscountMovement.Id join DiscountKlientAccountMoney on DiscountMovementItemId = DiscountMovementItem_byBarCode.Id where DiscountKlientAccountMoney.OperDate between '2012-01-15' and '2012-01-16' and DiscountKlientAccountMoney.isErased = 1 order by DiscountMovement.OperDate desc, DiscountMovementItem_byBarCode.Id  desc;
-- select * from DiscountMovementItem_byBarCode where DiscountMovementId =  111117
 update DiscountMovementItem_byBarCode set SummDiscountManual = -0.08  where replId =  63251 and DataBaseId = 4
 update DiscountMovementItem_byBarCode set SummDiscountManual = -0.16  where Id = 222287;
 


-- update DiscountMovementItem_byBarCode set SummDiscountManual_OLD = SummDiscountManual, SummDiscountManual = case when  replId =  63251 and DataBaseId = 4 then SummDiscountManual else SummDiscountManual - diff end
 from _err_2018_01_05 where _err_2018_01_05.Id = DiscountMovementItem_byBarCode.Id
create view  "DBA"._err_2018_01_05 as 
 select DiscountMovement.OperDate, DiscountMovement.UnitId, TotalSummToPay ,  isnull(OperCount,0)*isnull(OperPrice,0)-zf_MyTrunc(zf_CalcValueFromTax(isnull(OperCount,0)*isnull(OperPrice,0),DiscountTax)) as calcTotalSummToPay
     , TotalSummToPay -  (isnull(OperCount,0)*isnull(OperPrice,0)-zf_MyTrunc(zf_CalcValueFromTax(isnull(OperCount,0)*isnull(OperPrice,0),DiscountTax))) as diff
     , DiscountMovementItem_byBarCode.SummDiscountManual AS new_SummDiscountManual
     , DiscountMovementItem_byBarCode.Id
from DiscountMovementItem_byBarCode left outer join DiscountMovement on DiscountMovement.Id = DiscountMovementId where TotalSummToPay <> isnull(OperCount,0)*isnull(OperPrice,0)-zf_MyTrunc(zf_CalcValueFromTax(isnull(OperCount,0)*isnull(OperPrice,0),DiscountTax)) 
 and DiscountMovement.OperDate between '2005-01-01' and '2015-01-01'
 and DiscountMovementItem_byBarCode.Id not in
      (select distinct DiscountMovementItem_byBarCode.Id
      from DiscountMovementItem_byBarCode join DiscountMovement on DiscountMovement.Id = DiscountMovementId and DiscountMovement.DescId = 1
           join DiscountKlientAccountMoney on DiscountKlientAccountMoney.Summa < 0 and DiscountKlientAccountMoney.DiscountMovementItemId = DiscountMovementItem_byBarCode.Id
                                          and DiscountKlientAccountMoney.DiscountMovementItemReturnId is null
      where TotalSummToPay <> isnull(OperCount,0)*isnull(OperPrice,0)-zf_MyTrunc(zf_CalcValueFromTax(isnull(OperCount,0)*isnull(OperPrice,0),DiscountTax)) 
      )
-- select * from _err_2018_01_05 where id in(222287, 222288)
-- select * from _err_2018_01_05 order by OperDate
-- select * from DiscountMovementItem_byBarCode , _err_2018_01_05 where _err_2018_01_05.Id = DiscountMovementItem_byBarCode.Id
--      and DiscountMovementItem_byBarCode.TotalSummPay > DiscountMovementItem_byBarCode.TotalSummToPay - DiscountMovementItem_byBarCode.SummDiscountManual + diff
-- select * from DiscountKlientAccountMoney where DiscountMovementItemId = 27862


