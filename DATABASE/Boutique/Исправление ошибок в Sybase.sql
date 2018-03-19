  select * from Unit inner join DiscountKlient on DiscountKlient.ClientId = Unit.id where KindUnit = zc_kuClient()  and Id_Postgres is null order by 1
-- Шибко Дмитрий,Юля - 20% - 25%

-- select DiscountKlientAccountMoney.* from  DiscountMovement join "dba".DiscountMovementItem_byBarCode on DiscountMovementId = DiscountMovement.Id join DiscountKlientAccountMoney on DiscountMovementItemId = DiscountMovementItem_byBarCode.Id where DiscountKlientAccountMoney.OperDate between '2012-01-15' and '2012-01-16' and DiscountKlientAccountMoney.isErased = 1 order by DiscountMovement.OperDate desc, DiscountMovementItem_byBarCode.Id  desc;
-- select * from DiscountMovementItem_byBarCode where DiscountMovementId =  111117
-- select * from DiscountMovementItemReturn_byBarCode  where Id_Postgres =  1096328 
 update DiscountMovementItem_byBarCode set SummDiscountManual = -0.08  where replId =  63251 and DataBaseId = 4
 update DiscountMovementItem_byBarCode set SummDiscountManual = -0.16  where Id = 222287;
 update DiscountKlientAccountMoney set isErased = 0  where MovementId_pg = 315704;
 update DiscountKlientAccountMoney set isErased = 0  where ReplId = 17293 and DatabaseId = 5;
 update DiscountKlientAccountMoney set isErased = 0  where ReplId = 35504 and DatabaseId = 4;
 update DiscountKlientAccountMoney set isErased = 0  where ReplId = 36744 and DatabaseId = 4;
 update DiscountKlientAccountMoney set isErased = 0  where ReplId = 37142 and DatabaseId = 5;
 update DiscountKlientAccountMoney set isErased = 0  where ReplId = 94257 and DatabaseId = 4;
 
-- delete from DiscountKlientAccountMoney  where  id = 59840; commit;
-- update DiscountKlientAccountMoney set summa = -3600.16  where ReplId = 84838 and DatabaseId = 4; commit;
-- update DiscountKlientAccountMoney set summa = 4.78 + 1  where ReplId = 87277 and DatabaseId = 4; commit;
-- update DiscountKlientAccountMoney set summa = 4073.22 + 1  where ReplId = 87279 and DatabaseId = 4; commit;
-- update DiscountKlientAccountMoney set summa = 6.52 + 1  where ReplId = 87278 and DatabaseId = 4; commit;
 
select DiscountMovementItem_byBarCode .*, DiscountMovement.*, DiscountKlientAccountMoney.*
from DiscountMovementItem_byBarCode 
   left outer join DiscountMovement on DiscountMovement.Id = DiscountMovementId
   left outer join DiscountKlientAccountMoney on DiscountMovementItemId = DiscountMovementItem_byBarCode.Id
where  TotalSummToPay <> TotalSummReturnToPay and TotalReturnOperCount = OperCount
  and DiscountMovement.isErased = zc_rvNo(*)
  and TotalSummPay = 1
order by InsertDate, DiscountMovement.OperDate

-- select GoodsProperty.CashCode, GoodsSize.GoodsSizeName, BillItemsIncome.*  from "dba".BillItemsIncome join GoodsProperty on GoodsProperty.Id =BillItemsIncome.GoodsPropertyId join GoodsSize on GoodsSize.Id = GoodsProperty.GoodsSizeId  where BillItemsIncome.Id  order by GoodsProperty.CashCode
-- select _zz_zc_StartDate()
  '2006-01-01' -- MaxMara -- OK
  '2007-04-28' -- TerryL  -- 30762 + 32257(M) + 35078(XS) + 41063(36) + 65813(40) + 77309(XS) in (54663,46751,42986,71924,192757,155479)
  '2007-04-01' -- 5 Elem  -- 28025(36) in (36477)
  '2007-12-03' -- Chado   -- 70064 + 39629(I) in (169245,67594) 
  '2008-03-31' -- Savoy   -- OK
  '2008-03-01' -- PZ      -- OK
  '2007-04-28' -- Terry   -- OK -- 30762 + 32257(M) + 35978(XS) + 41063(36) in (54663,46751,42986,71924)
  '2011-03-31' -- Vintag  -- OK
  '2012-04-01' -- Escada  -- OK
  '2008-03-31' -- Savoy-2 -- OK
  '2014-01-13' -- Sopra   -- OK
  '2014-01-13' -- 11      -- OK
--
select DiscountMovement.DataBaseId, Unit.Id AS UnitId, Unit.UnitName, Users.Id as UserId, Users.UsersName, count(*), max (operDate)
from DBA.DiscountMovement
           left outer join DBA.Unit on Unit.Id = DiscountMovement.UnitID
           left outer join DBA.Users on Users.id = DiscountMovement.InsertUserID
where DiscountMovement.descId = 1  and DiscountMovement.OperDate between '2005-01-01' and '2019-01-01'
  and DiscountMovement.isErased = zc_rvNo()
group by DiscountMovement.DataBaseId, Unit.Id , Unit.UnitName, Users.Id, Users.UsersName
order by Users.UsersName
  
-- select * from DiscountMovement inner join DiscountMovementItem_byBarCode on DiscountMovementId = DiscountMovement.Id where DiscountMovement.OperDate < _zz_zc_StartDate() and DiscountMovement.isErased = 1
-- select * from DiscountMovement inner join DiscountMovementItemReturn_byBarCode on DiscountMovementId = DiscountMovement.Id where OperDate < _zz_zc_StartDate() and isErased = 1
-- select * from DiscountKlientAccountMoney where OperDate < _zz_zc_StartDate() and isErased = 1
 
-- update DiscountMovementItem_byBarCode set SummDiscountManual_OLD = SummDiscountManual, SummDiscountManual = case when  replId =  63251 and DataBaseId = 4 then SummDiscountManual else SummDiscountManual - diff end
 from _err_2018_01_05 where _err_2018_01_05.Id = DiscountMovementItem_byBarCode.Id
create view  "DBA"._err_2018_01_05 as 
alter view
  "DBA"._err_2018_01_05
  as select DiscountMovement.OperDate,DiscountMovement.UnitId,TotalSummToPay,isnull(OperCount,0)*isnull(OperPrice,0)-zf_MyTrunc(zf_CalcValueFromTax(isnull(OperCount,0)*isnull(OperPrice,0),DiscountTax)) as calcTotalSummToPay,
    TotalSummToPay-(isnull(OperCount,0)*isnull(OperPrice,0)-zf_MyTrunc(zf_CalcValueFromTax(isnull(OperCount,0)*isnull(OperPrice,0),DiscountTax))) as diff,
    DiscountMovementItem_byBarCode.SummDiscountManual as new_SummDiscountManual,
    DiscountMovementItem_byBarCode.Id
    from "dba".DiscountMovementItem_byBarCode left outer join "dba".DiscountMovement on DiscountMovement.Id=DiscountMovementId where TotalSummToPay<>isnull(OperCount,0)*isnull(OperPrice,0)-zf_MyTrunc(zf_CalcValueFromTax(isnull(OperCount,0)*isnull(OperPrice,0),DiscountTax))
    and DiscountMovement.OperDate between '2005-01-01' and '2015-01-01'
    and not DiscountMovementItem_byBarCode.Id
    =any(select distinct DiscountMovementItem_byBarCode.Id
      from "dba".DiscountMovementItem_byBarCode join "dba".DiscountMovement on DiscountMovement.Id=DiscountMovementId and DiscountMovement.DescId=1 join
      "dba".DiscountKlientAccountMoney on DiscountKlientAccountMoney.Summa<0
      and DiscountKlientAccountMoney.isErased=1
      and DiscountKlientAccountMoney.DiscountMovementItemId=DiscountMovementItem_byBarCode.Id
      and DiscountKlientAccountMoney.DiscountMovementItemReturnId is null
      where TotalSummToPay<>isnull(OperCount,0)*isnull(OperPrice,0)-zf_MyTrunc(zf_CalcValueFromTax(isnull(OperCount,0)*isnull(OperPrice,0),DiscountTax)))
/*and DiscountMovementItem_byBarCode.Id
    =any(select distinct DiscountMovementItem_byBarCode.Id
      from "dba".DiscountMovementItem_byBarCode join "dba".DiscountMovement on DiscountMovement.Id=DiscountMovementId and DiscountMovement.DescId=1 join
      "dba".DiscountKlientAccountMoney on DiscountKlientAccountMoney.Summa<0
      and DiscountKlientAccountMoney.isErased=0
      and DiscountKlientAccountMoney.DiscountMovementItemId=DiscountMovementItem_byBarCode.Id
      and DiscountKlientAccountMoney.DiscountMovementItemReturnId is null
      where TotalSummToPay<>isnull(OperCount,0)*isnull(OperPrice,0)-zf_MyTrunc(zf_CalcValueFromTax(isnull(OperCount,0)*isnull(OperPrice,0),DiscountTax)))
and DiscountMovementItem_byBarCode.Id
=any(select distinct DiscountMovementItem_byBarCode.Id
from "dba".DiscountMovementItem_byBarCode join "dba".DiscountMovement on DiscountMovement.Id=DiscountMovementId and DiscountMovement.DescId=1 join
"dba".DiscountKlientAccountMoney on DiscountKlientAccountMoney.Summa<0 and DiscountKlientAccountMoney.DiscountMovementItemId=DiscountMovementItem_byBarCode.Id
and DiscountKlientAccountMoney.DiscountMovementItemReturnId>0
where TotalSummToPay<>isnull(OperCount,0)*isnull(OperPrice,0)-zf_MyTrunc(zf_CalcValueFromTax(isnull(OperCount,0)*isnull(OperPrice,0),DiscountTax)))
*/
-- select * from _err_2018_01_05 order by OperDate

-- select * from _err_2018_01_05 where id in(222287, 222288)
-- select * from _err_2018_01_05 order by OperDate
-- select * from DiscountMovementItem_byBarCode , _err_2018_01_05 where _err_2018_01_05.Id = DiscountMovementItem_byBarCode.Id
--      and DiscountMovementItem_byBarCode.TotalSummPay > DiscountMovementItem_byBarCode.TotalSummToPay - DiscountMovementItem_byBarCode.SummDiscountManual + diff
-- select * from DiscountKlientAccountMoney where DiscountMovementItemId = 27862



-----------------------------------
-- !!!DiscountKlientAccountMoney!!!
-----------------------------------
select DiscountKlientAccountMoney.* 
from DiscountKlientAccountMoney 
     join _dataPay_all  on _dataPay_all.ReplId = DiscountKlientAccountMoney.ReplId and _dataPay_all.DatabaseId = DiscountKlientAccountMoney.DatabaseId 
     left outer join _dataRet_all on _dataRet_all.Id = _dataPay_all.DiscountMovementItemReturnId and _dataRet_all.DatabaseId = _dataPay_all.DatabaseId
     left outer join DiscountMovementItemReturn_byBarCode on DiscountMovementItemReturn_byBarCode.ReplId = _dataRet_all.ReplId and DiscountMovementItemReturn_byBarCode.DatabaseId = _dataRet_all.DatabaseId
     
-- where isnull (DiscountMovementItemReturn_byBarCode.Id, 0) <> isnull (DiscountKlientAccountMoney.DiscountMovementItemReturnId, 0)
 where _dataPay_all.DiscountMovementItemReturnId > 0 AND DiscountKlientAccountMoney.DiscountMovementItemReturnId is null 
  and DiscountKlientAccountMoney.isErased = 1
  and DiscountMovementItemReturn_byBarCode.Id is not null


update DiscountKlientAccountMoney  set DiscountKlientAccountMoney.DiscountMovementItemReturnId = DiscountMovementItemReturn_byBarCode.Id
from _dataPay_all  
     left outer join _dataRet_all on _dataRet_all.Id = _dataPay_all.DiscountMovementItemReturnId and _dataRet_all.DatabaseId = _dataPay_all.DatabaseId
     left outer join DiscountMovementItemReturn_byBarCode on DiscountMovementItemReturn_byBarCode.ReplId = _dataRet_all.ReplId and DiscountMovementItemReturn_byBarCode.DatabaseId = _dataRet_all.DatabaseId
     
where _dataPay_all.DiscountMovementItemReturnId > 0 AND DiscountKlientAccountMoney.DiscountMovementItemReturnId is null 
  and DiscountMovementItemReturn_byBarCode.Id is not null
  and _dataPay_all.ReplId = DiscountKlientAccountMoney.ReplId and _dataPay_all.DatabaseId = DiscountKlientAccountMoney.DatabaseId 
  
  
  
 select DiscountKlientAccountMoney.* 
from DiscountKlientAccountMoney 
     join _dataPay_all  on _dataPay_all.ReplId = DiscountKlientAccountMoney.ReplId and _dataPay_all.DatabaseId = DiscountKlientAccountMoney.DatabaseId 
     left outer join _data_all on _data_all.Id = _dataPay_all.DiscountMovementItemId and _data_all.DatabaseId = _dataPay_all.DatabaseId
     left outer join DiscountMovementItem_byBarCode on DiscountMovementItem_byBarCode.ReplId = _dataPay_all.ReplId and DiscountMovementItemReturn_byBarCode.DatabaseId = _dataPay_all.DatabaseId
     
where isnull (DiscountMovementItem_byBarCode.Id, 0) <> isnull (DiscountKlientAccountMoney.DiscountMovementItemId, 0)
-- where _dataPay_all.DiscountMovementItemId > 0 AND DiscountKlientAccountMoney.DiscountMovementItemId is null 
  and DiscountKlientAccountMoney.isErased = 1
  and DiscountMovementItemReturn_byBarCode.Id is not null

-- 1  
select Bill.BillDate , BillItems.* 
from BillItems
     left outer join _dataBI_all  on _dataBI_all.ReplId = BillItems.ReplId and _dataBI_all.DatabaseId = BillItems.DatabaseId 
     left outer join Bill  on Bill.Id = BillItems.BillId 
where BillItems.DatabaseId  > 0
  and _dataBI_all.ReplId is null
order by 1
-- 2
select DiscountMovement.OperDate , _dataBI_all.* 
from _dataBI_all
     left outer join BillItems  on BillItems.ReplId = _dataBI_all.ReplId and BillItems.DatabaseId = _dataBI_all.DatabaseId 
     left outer join _data_all on _data_all.BillItemsId  = _dataBI_all.Id and _data_all.DatabaseId = _dataBI_all.DatabaseId 
     left outer join DiscountMovementItem_byBarCode on DiscountMovementItem_byBarCode.ReplId =_data_all.ReplId and DiscountMovementItem_byBarCode.DatabaseId = _data_all.DatabaseId
     left outer join DiscountMovement on DiscountMovement.Id = DiscountMovementItem_byBarCode.DiscountMovementId 
where BillItems.ReplId is null
order by 1


-- Проверка / Расчет  для Sybase - что б после возврата оплаты ДОЛГ был = 0
SELECT MIBoolean_Close.ValueData 
,  zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData)
                                                         -- МИНУС сколько скидки !!!только из Продажи, т.к. для Sybase скидки по Оплатам=0!!!
                                                       , COALESCE (MIFloat_TotalChangePercent.ValueData, 0)
                                                         -- МИНУС Итого сумма оплаты !!!только из Продажи!!!
                                                       , COALESCE (MIFloat_TotalPay.ValueData, 0)
                                                         -- МИНУС сумма оплаты !!!Расчеты - ВСЕ Статусы!!!
                                                       , COALESCE ((SELECT SUM (COALESCE (MIFloat_TotalPay.ValueData, 0) + COALESCE (MIFloat_SummChangePercent.ValueData, 0))
                                                                    FROM MovementItemLinkObject AS MIL_PartionMI
                                                                         INNER JOIN MovementItem ON MovementItem.Id       = MIL_PartionMI.MovementItemId
                                                                                                AND MovementItem.DescId   = zc_MI_Master()
                                                                                                AND MovementItem.isErased = FALSE
                                                                         INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                                            AND Movement.DescId   = zc_Movement_GoodsAccount()
                                                                                            AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                                                         LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                                                                     ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                                                                    AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                                                                         LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                                                                     ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                                                                                    AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()

                                                                    WHERE MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI ()
                                                                      AND MIL_PartionMI.ObjectId = lpInsertFind_Object_PartionMI (784237 ) -- vbPartionMI_Id

                                                                   ), 0)
                                                         -- МИНУС Сумма ВОЗВРАТ по Прайсу
                                                       , zfCalc_SummPriceList (COALESCE ((SELECT SUM (MovementItem.Amount)
                                                                                          FROM MovementItemLinkObject AS MIL_PartionMI
                                                                                               INNER JOIN MovementItem ON MovementItem.Id       = MIL_PartionMI.MovementItemId
                                                                                                                      AND MovementItem.DescId   = zc_MI_Master()
                                                                                                                      AND MovementItem.isErased = FALSE
                                                                                               INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                                                                  AND Movement.DescId   = zc_Movement_ReturnIn()
                                                                                                                  AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                                                                          WHERE MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI ()
                                                                                            AND MIL_PartionMI.ObjectId = lpInsertFind_Object_PartionMI (784237 ) -- vbPartionMI_Id
                      
                                                                                         ), 0)
                                                                             , MIFloat_OperPriceList.ValueData)
                                                       , COALESCE ((SELECT SUM (COALESCE (MIFloat_TotalPay.ValueData, 0))
                                                                    FROM MovementItemLinkObject AS MIL_PartionMI
                                                                         INNER JOIN MovementItem ON MovementItem.Id       = MIL_PartionMI.MovementItemId
                                                                                                AND MovementItem.DescId   = zc_MI_Master()
                                                                                                AND MovementItem.isErased = FALSE
                                                                         INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                                            AND Movement.DescId   = zc_Movement_ReturnIn()
                                                                                            AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                                                         LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                                                                     ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                                                                    AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()

                                                                    WHERE MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI ()
                                                                      AND MIL_PartionMI.ObjectId = lpInsertFind_Object_PartionMI (784237 ) -- vbPartionMI_Id

                                                                   ), 0) as end_my


, CASE -- если вернули все - тогда вся скидка из продажи
                                          
                                          -- !!!Сложный расчет - для Sybase - что б после возврата оплаты ДОЛГ был = 0 - только для №п/п=1!!!
                                          WHEN zc_User_Sybase()= zc_User_Sybase()
                                           AND MIBoolean_Close.ValueData = TRUE
                                               -- №п/п=1
                                           AND COALESCE (1066683 , 0) = COALESCE ((SELECT tmp.Id
                                                                               FROM (SELECT MovementItem.Id
                                                                                          , ROW_NUMBER() OVER (PARTITION BY MIL_PartionMI.ObjectId ORDER BY Movement.OperDate ASC, MovementItem.Id ASC) AS Ord
                                                                                     FROM MovementItemLinkObject AS MIL_PartionMI
                                                                                          INNER JOIN MovementItem ON MovementItem.Id       = MIL_PartionMI.MovementItemId
                                                                                                                 AND MovementItem.DescId   = zc_MI_Master()
                                                                                                                 AND MovementItem.isErased = FALSE
                                                                                          INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                                                             AND Movement.DescId   = zc_Movement_ReturnIn()
                                                                                                             AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                                                                          LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                                                                                      ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                                                                                     AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
      
                                                                                     WHERE MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI ()
                                                                                       AND MIL_PartionMI.ObjectId = lpInsertFind_Object_PartionMI (784237 ) -- vbPartionMI_Id
      
                                                                                    ) AS tmp
                                                                               WHERE tmp.Ord = 1
                                                                              ), 0)

                                               THEN 0 - (-- Сумма по Прайсу
                                                         zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData)
                                                         -- МИНУС сколько скидки !!!только из Продажи, т.к. для Sybase скидки по Оплатам=0!!!
                                                       - COALESCE (MIFloat_TotalChangePercent.ValueData, 0)
                                                         -- МИНУС Итого сумма оплаты !!!только из Продажи!!!
                                                       - COALESCE (MIFloat_TotalPay.ValueData, 0)
                                                         -- МИНУС сумма оплаты !!!Расчеты - ВСЕ Статусы!!!
                                                       - COALESCE ((SELECT SUM (COALESCE (MIFloat_TotalPay.ValueData, 0) + COALESCE (MIFloat_SummChangePercent.ValueData, 0))
                                                                    FROM MovementItemLinkObject AS MIL_PartionMI
                                                                         INNER JOIN MovementItem ON MovementItem.Id       = MIL_PartionMI.MovementItemId
                                                                                                AND MovementItem.DescId   = zc_MI_Master()
                                                                                                AND MovementItem.isErased = FALSE
                                                                         INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                                            AND Movement.DescId   = zc_Movement_GoodsAccount()
                                                                                            AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                                                         LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                                                                     ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                                                                    AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                                                                         LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                                                                     ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                                                                                    AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()

                                                                    WHERE MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI ()
                                                                      AND MIL_PartionMI.ObjectId = lpInsertFind_Object_PartionMI (784237 ) -- vbPartionMI_Id

                                                                   ), 0)
                                                         -- МИНУС Сумма ВОЗВРАТ по Прайсу
                                                       - zfCalc_SummPriceList (COALESCE ((SELECT SUM (MovementItem.Amount)
                                                                                          FROM MovementItemLinkObject AS MIL_PartionMI
                                                                                               INNER JOIN MovementItem ON MovementItem.Id       = MIL_PartionMI.MovementItemId
                                                                                                                      AND MovementItem.DescId   = zc_MI_Master()
                                                                                                                      AND MovementItem.isErased = FALSE
                                                                                               INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                                                                  AND Movement.DescId   = zc_Movement_ReturnIn()
                                                                                                                  AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                                                                          WHERE MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI ()
                                                                                            AND MIL_PartionMI.ObjectId = lpInsertFind_Object_PartionMI (784237 ) -- vbPartionMI_Id
                      
                                                                                         ), 0)
                                                                             , MIFloat_OperPriceList.ValueData)
                                                       + COALESCE ((SELECT SUM (COALESCE (MIFloat_TotalPay.ValueData, 0))
                                                                    FROM MovementItemLinkObject AS MIL_PartionMI
                                                                         INNER JOIN MovementItem ON MovementItem.Id       = MIL_PartionMI.MovementItemId
                                                                                                AND MovementItem.DescId   = zc_MI_Master()
                                                                                                AND MovementItem.isErased = FALSE
                                                                         INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                                            AND Movement.DescId   = zc_Movement_ReturnIn()
                                                                                            AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                                                         LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                                                                     ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                                                                    AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()

                                                                    WHERE MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI ()
                                                                      AND MIL_PartionMI.ObjectId = lpInsertFind_Object_PartionMI (784237 ) -- vbPartionMI_Id

                                                                   ), 0)
                                                        )

                                         

                                     END
, MIFloat_TotalChangePercent.ValueData
                             FROM MovementItem
                                LEFT JOIN MovementItemBoolean AS MIBoolean_Close
                                                              ON MIBoolean_Close.MovementItemId = MovementItem.Id
                                                             AND MIBoolean_Close.DescId         = zc_MIBoolean_Close()
                                LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                            ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                           AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                                LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                            ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                           AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
                                LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                            ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                                           AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
                                LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay
                                                            ON MIFloat_TotalChangePercentPay.MovementItemId = MovementItem.Id
                                                           AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()
                                LEFT JOIN MovementItemFloat AS MIFloat_TotalCountReturn
                                                            ON MIFloat_TotalCountReturn.MovementItemId = MovementItem.Id
                                                           AND MIFloat_TotalCountReturn.DescId         = zc_MIFloat_TotalCountReturn()

                             WHERE MovementItem.Id         = 784237 
                               -- AND MovementItem.MovementId = inMovementId
                               AND MovementItem.DescId     = zc_MI_Master()
                               AND MovementItem.isErased   = FALSE


-- поиск Движения ПАРТИИ - zc_Enum_Status_UnComplete
SELECT MovementDesc.ItemName, Movement.*, MovementItem.*, MIFloat_TotalPay.*
                                                                    FROM MovementItemLinkObject AS MIL_PartionMI
                                                                         INNER JOIN MovementItem ON MovementItem.Id       = MIL_PartionMI.MovementItemId
                                                                                                AND MovementItem.DescId   = zc_MI_Master()
                                                                                                AND MovementItem.isErased = FALSE
                                                                         INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                                            -- AND Movement.DescId   = zc_Movement_GoodsAccount()
                                                                                            AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                                                         INNER JOIN MovementDesc ON MovementDesc.Id = Movement.DescId       
                                                                         LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                                                                     ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                                                                    AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()

                                                                    WHERE MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI ()
                                                                      AND MIL_PartionMI.ObjectId = 379409 -- select lpInsertFind_Object_PartionMI (680181 ) -- vbPartionMI_Id
UNION ALL
SELECT MovementDesc.ItemName, Movement.*, MovementItem.*, MIFloat_TotalPay.*
                                                                    FROM Object
                                                                         INNER JOIN MovementItem ON MovementItem.Id       = Object.ObjectCode
                                                                                                AND MovementItem.DescId   = zc_MI_Master()
                                                                                                AND MovementItem.isErased = FALSE
                                                                         INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                                            -- AND Movement.DescId   = zc_Movement_GoodsAccount()
                                                                                            AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                                                         INNER JOIN MovementDesc ON MovementDesc.Id = Movement.DescId       
                                                                         LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                                                                     ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                                                                    AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
e                                                                    WHERE Object.Id  = 379409 -- select lpInsertFind_Object_PartionMI (680181 ) -- vbPartionMI_Id
                             

   
-- !!!!
-- !!!! Исправляем  zc_MovementLinkObject_To by zc_MovementLinkObject_From!!!!
-- !!!!
-- select gpReComplete_Movement_Sale (MovementId, zfCalc_UserAdmin()), * from
-- (select lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), MovementId, newClientId), * from(
-- select gpReComplete_Movement_GoodsAccount (MovementId_to, zfCalc_UserAdmin()), * from
-- (select lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), MovementId_to, newClientId_sale), * from(
select distinct Object_To.ValueData, Object_From.ValueData, Movement.Id as MovementId, Object_From.Id as newClientId
              , Object_To.Id as newClientId_sale -- !!!!!!!!
              , Mov.Id as MovementId_to          -- !!!!!!!!
           FROM Movement
                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                            AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

inner join MovementItem ON MovementItem.MovementId = Movement.Id
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE
inner join Object on Object.ObjectCode = MovementItem.Id
                    and Object.DescId = zc_Object_PartionMI()
INNER JOIN MovementItemLinkObject AS MIL_PartionMI
                   ON MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI()
                  AND MIL_PartionMI.ObjectId = Object.Id

INNER JOIN MovementItem as MI ON MI.Id       = MIL_PartionMI.MovementItemId
                        AND MI.DescId   = zc_MI_Master()
                        AND MI.isErased = FALSE
inner join Movement as Mov ON Mov.Id = MI.MovementId
                          -- AND Mov.DescId   = zc_Movement_ReturnIn()
                           AND Mov.DescId   = zc_Movement_GoodsAccount()
                          AND Mov.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                inner JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Mov.Id
                                            AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                            AND MovementLinkObject_From.ObjectId   <> MovementLinkObject_To.ObjectId     
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

           WHERE Movement.DescId   = zc_Movement_Sale()
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
-- ) as tmp) as tmp






-- !!!!
-- !!!! Исправляем  BillItemsIncomeID
-- !!!!
select  DiscountMovement.*, DiscountMovementItem_byBarCode.*
from DiscountMovementItem_byBarCode
     join DiscountMovement on DiscountMovement.Id = DiscountMovementId
where BillItemsIncomeID_OLD > 0

select  _data_all.BillItemsIncomeID as id_Shop , DiscountMovementItem_byBarCode.BillItemsIncomeID, BillItems.BillItemsIncomeID as currId, _dataBI_all.BillItemsIncomeID as currId_shop, *
from DiscountMovementItem_byBarCode
     join _data_all   on _data_all.ReplId = DiscountMovementItem_byBarCode.ReplId and _data_all.DatabaseId = DiscountMovementItem_byBarCode.DatabaseId 
     left outer join _dataBI_all on _dataBI_all.Id = _data_all.BillItemsId and _dataBI_all.DatabaseId = _data_all.DatabaseId 
     left outer join BillItems on BillItems.ReplId = _dataBI_all.ReplId and BillItems.DatabaseId = _dataBI_all.DatabaseId 
     left outer join BillItemsIncome on BillItemsIncome.Id = _data_all.BillItemsIncomeID
where _data_all.BillItemsIncomeID  <> DiscountMovementItem_byBarCode.BillItemsIncomeID 
-- where BillItems.BillItemsIncomeID  <> DiscountMovementItem_byBarCode.BillItemsIncomeID 
--  and _data_all.BillItemsId > 0
--  and _data_all.BillItemsIncomeID = 220466
  and BillItemsIncome.Id is null
     
--update  DiscountMovementItem_byBarCode set DiscountMovementItem_byBarCode.BillItemsIncomeID = _data_all.BillItemsIncomeID
--                                         , DiscountMovementItem_byBarCode.BillItemsIncomeID_OLD = DiscountMovementItem_byBarCode.BillItemsIncomeID
update  DiscountMovementItem_byBarCode set DiscountMovementItem_byBarCode.BillItemsIncomeID = BillItems.BillItemsIncomeID
                                         , DiscountMovementItem_byBarCode.BillItemsIncomeID_OLD = DiscountMovementItem_byBarCode.BillItemsIncomeID
from  _data_all
     left outer join _dataBI_all on _dataBI_all.Id = _data_all.BillItemsId and _dataBI_all.DatabaseId = _data_all.DatabaseId 
     left outer join BillItems on BillItems.ReplId = _dataBI_all.ReplId and BillItems.DatabaseId = _dataBI_all.DatabaseId 
where BillItems.BillItemsIncomeID  <> DiscountMovementItem_byBarCode.BillItemsIncomeID 
where _data_all.BillItemsIncomeID  <> DiscountMovementItem_byBarCode.BillItemsIncomeID 
  and _data_all.ReplId = DiscountMovementItem_byBarCode.ReplId and _data_all.DatabaseId = DiscountMovementItem_byBarCode.DatabaseId 
  and _data_all.BillItemsId > 0
-- and _data_all.BillItemsIncomeID = 220466




with _tmpData  as
(SELECT * FROM Object WHERE Object.Id IN (SELECT -12345 AS PartionId_MI
                   UNION SELECT 483329 -- select ObP.*, MovementItem.* , Movement.* from MovementItem join Object as ObP on ObP.ObjectCode = MovementItem.Id and ObP.DescId = zc_Object_PartionMI() join Movement on Movement.Id = MovementId and Movement.DescId = zc_Movement_Sale() and Movement.Operdate = '14.05.2012' where PartionId = (SELECT MovementItemId FROM Object_PartionGoods join Object on Object.Id = GoodsId and Object.ObjectCode = 69023 join Object as o2 on o2.Id = GoodsSizeId and o2.ValueData = '40')
                   UNION SELECT 498838
                   UNION SELECT 581629
                   UNION SELECT 581618
                   UNION SELECT 761634
                   UNION SELECT 483304
                   UNION SELECT 484088
                   UNION SELECT 498134
                   UNION SELECT 581631
                   UNION SELECT 581633
                   UNION SELECT 581620
                   UNION SELECT 581624
                   UNION SELECT 761635
                   UNION SELECT 764551
                   UNION SELECT 483331
                   UNION SELECT 483333
                   UNION SELECT 483076
                   UNION SELECT 497389
                   UNION SELECT 761636
                   UNION SELECT 483048
                   UNION SELECT 483114
                   UNION SELECT 483312
                   UNION SELECT 581622
                   UNION SELECT 581627
                   UNION SELECT 761637
                   UNION SELECT 765099
                         -- FROM gpSelect_MovementItem_Sale_Sybase_Check()
                        )
)

        , tmpAcc_PREV AS (SELECT distinct Movement.*
                             FROM _tmpData AS tmpData
                                  INNER JOIN MovementItemLinkObject AS MIL_PartionMI
                                                          ON MIL_PartionMI.ObjectId = tmpData.Id
                                                         AND MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI()
                                  INNER JOIN MovementItem ON MovementItem.Id       = MIL_PartionMI.MovementItemId
                                                         AND MovementItem.DescId   = zc_MI_Master()
                                                         AND MovementItem.isErased = FALSE
                                  INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                     AND Movement.DescId   = zc_Movement_GoodsAccount()
                                                     AND Movement.StatusId = zc_Enum_Status_Complete()
                            /*UNION ALL
                             SELECT distinct Movement.*
                             FROM _tmpData AS tmpData
                                  INNER JOIN MovementItem ON MovementItem.Id       = tmpData.ObjectCode
                                                         AND MovementItem.DescId   = zc_MI_Master()
                                                         AND MovementItem.isErased = FALSE
                                  INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                     AND Movement.DescId   = zc_Movement_Sale()
                                                     AND Movement.StatusId = zc_Enum_Status_Complete()*/
                            )

select * 
-- , gpReComplete_Movement_Sale (Id, zc_User_Sybase() :: TVarChar)
, gpReComplete_Movement_GoodsAccount (Id, zc_User_Sybase() :: TVarChar)
from tmpAcc_PREV 