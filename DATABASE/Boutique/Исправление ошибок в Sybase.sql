  delete from _pgSummDiscountManual;
  insert into _pgSummDiscountManual (DiscountMovementItemId, SummDiscountManual) select  DiscountMovementItemId, SummDiscountManual from _pgSummDiscountManual_view;

  select * from Unit inner join DiscountKlient on DiscountKlient.ClientId = Unit.id where KindUnit = zc_kuClient()  and Id_Postgres is null order by 1


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
 

select DiscountMovementItem_byBarCode .*, DiscountMovement.*, DiscountKlientAccountMoney.*
from DiscountMovementItem_byBarCode 
   left outer join DiscountMovement on DiscountMovement.Id = DiscountMovementId
   left outer join DiscountKlientAccountMoney on DiscountMovementItemId = DiscountMovementItem_byBarCode.Id
where  TotalSummToPay <> TotalSummReturnToPay and TotalReturnOperCount = OperCount
  and DiscountMovement.isErased = zc_rvNo(*)
  and TotalSummPay = 1
order by InsertDate, DiscountMovement.OperDate

 
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







SELECT MIBoolean_Close.ValueData 
,  zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData)
                                                         -- МИНУС сколько скидки !!!только из Продажи, т.к. для Sybase скидки по Оплатам=0!!!
                                                       , COALESCE (MIFloat_TotalChangePercent.ValueData, 0)
                                                         -- МИНУС Итого сумма оплаты !!!только из Продажи!!!
                                                       , COALESCE (MIFloat_TotalPay.ValueData, 0)
                                                         -- МИНУС сумма оплаты !!!Расчеты - ВСЕ Статусы!!!
                                                       , COALESCE ((SELECT SUM (COALESCE (MIFloat_TotalPay.ValueData, 0))
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

                                                                    WHERE MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI ()
                                                                      AND MIL_PartionMI.ObjectId = lpInsertFind_Object_PartionMI (685112 ) -- vbPartionMI_Id

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
                                                                                            AND MIL_PartionMI.ObjectId = lpInsertFind_Object_PartionMI (685112 ) -- vbPartionMI_Id
                      
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
                                                                      AND MIL_PartionMI.ObjectId = lpInsertFind_Object_PartionMI (685112 ) -- vbPartionMI_Id

                                                                   ), 0) as end_my


, CASE -- если вернули все - тогда вся скидка из продажи
                                          
                                          -- !!!Сложный расчет - для Sybase - что б после возврата оплаты ДОЛГ был = 0 - только для №п/п=1!!!
                                          WHEN zc_User_Sybase()= zc_User_Sybase()
                                           AND MIBoolean_Close.ValueData = TRUE
                                               -- №п/п=1
                                           AND COALESCE (1038560 , 0) = COALESCE ((SELECT tmp.Id
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
                                                                                       AND MIL_PartionMI.ObjectId = lpInsertFind_Object_PartionMI (685112 ) -- vbPartionMI_Id
      
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
                                                       - COALESCE ((SELECT SUM (COALESCE (MIFloat_TotalPay.ValueData, 0))
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

                                                                    WHERE MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI ()
                                                                      AND MIL_PartionMI.ObjectId = lpInsertFind_Object_PartionMI (685112 ) -- vbPartionMI_Id

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
                                                                                            AND MIL_PartionMI.ObjectId = lpInsertFind_Object_PartionMI (685112 ) -- vbPartionMI_Id
                      
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
                                                                      AND MIL_PartionMI.ObjectId = lpInsertFind_Object_PartionMI (685112 ) -- vbPartionMI_Id

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

                             WHERE MovementItem.Id         = 685112 
                               -- AND MovementItem.MovementId = inMovementId
                               AND MovementItem.DescId     = zc_MI_Master()
                               AND MovementItem.isErased   = FALSE

/*
SELECT Movement.*, MovementItem.*, MIFloat_TotalPay.*
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

                                                                    WHERE MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI ()
                                                                      AND MIL_PartionMI.ObjectId = lpInsertFind_Object_PartionMI (685112 ) -- vbPartionMI_Id
*/



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
