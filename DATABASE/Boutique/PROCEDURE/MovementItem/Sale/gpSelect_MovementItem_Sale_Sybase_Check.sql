-- Function: gpSelect_MovementItem_Sale_Sybase_Check()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Sale_Sybase_Check ();

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Sale_Sybase_Check()
RETURNS TABLE (isErased Boolean, MovementItemId Integer, MovementId Integer, InvNumber Integer, OperDate TDateTime, StartDate_sybase TDateTime
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsSizeId Integer, GoodsSizeName TVarChar
             , PartionId Integer, PartionId_MI Integer
             , COUNT_Sale TFloat, COUNT_Ret TFloat, SummDebt_sale TFloat, SummDebt_return TFloat
              )
AS
$BODY$
   DECLARE vbTmp Integer;
BEGIN

     -- !!!
     -- !!!Для ХАРДКОД!!!
     -- !!!

     -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpData (isErased Boolean, MovementItemId Integer, MovementId Integer, InvNumber Integer, OperDate TDateTime, StartDate_sybase TDateTime, FromId Integer, ToId Integer
                               , GoodsId Integer, GoodsSizeId Integer, PartionId Integer, PartionId_MI Integer
                               , COUNT_Sale TFloat, COUNT_Ret TFloat, SummDebt_sale TFloat, SummDebt_return TFloat
                                ) ON COMMIT DROP;


     WITH tmpUnit AS (SELECT * FROM gpSelect_Object_Unit (TRUE, zfCalc_UserAdmin()) AS tmp WHERE tmp.StartDate_sybase IS NOT NULL ORDER BY tmp.Id)
     , tmpData AS (SELECT MovementItem.isErased AS isErased_go, tmpUnit.Name, tmpUnit.StartDate_sybase, Movement.Id AS MovementId_go, Movement.InvNumber AS InvNumber_go, Movement.OperDate AS OperDate_go, MovementItem.Amount AS COUNT_Sale, MIFloat_TotalCountReturn.ValueData AS COUNT_Ret, Object_From.ValueData AS FromName, Object_To.ValueData AS ToName, Object_Goods.ObjectCode AS GoodsCode, Object_Goods.ValueData AS GoodsName, Object_GoodsSize.ValueData AS GoodsSizeName, Object_From.Id AS FromId, Object_To.Id AS ToId, Object_Goods.Id AS GoodsId, Object_GoodsSize.Id AS GoodsSizeId, MovementItem.*

                         -- !!!1.1. самое Важное - Сложный расчет ДОЛГА - БЕЗ ВОЗВРАТА!!!
                       , -- Сумма по Прайсу
                         zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData)

                         -- МИНУС: Итого сумма Скидки (в ГРН) - для ВСЕХ документов - суммируется 1)по %скидки + 2)дополнительная + 3)дополнительная в оплатах
                       - (COALESCE (MIFloat_TotalChangePercent.ValueData, 0) + COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0))

                         -- МИНУС: Итого сумма оплаты (в ГРН) - для ВСЕХ документов - суммируется 1) + 2)
                       - (COALESCE (MIFloat_TotalPay.ValueData, 0) + COALESCE (MIFloat_TotalPayOth.ValueData, 0))

                         AS SummDebt_sale -- 1.1.


                         -- !!!1.2. самое Важное - Сложный расчет ДОЛГА - с учетом ВОЗВРАТА!!!
                       , -- Сумма по Прайсу
                         zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData)

                         -- МИНУС: Итого сумма Скидки (в ГРН) - для ВСЕХ документов - суммируется 1)по %скидки + 2)дополнительная + 3)дополнительная в оплатах
                       - (COALESCE (MIFloat_TotalChangePercent.ValueData, 0) + COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0))

                         -- МИНУС: Итого сумма оплаты (в ГРН) - для ВСЕХ документов - суммируется 1) + 2)
                       - (COALESCE (MIFloat_TotalPay.ValueData, 0) + COALESCE (MIFloat_TotalPayOth.ValueData, 0))

                         -- МИНУС TotalReturn - Итого сумма возврата со скидкой - все док-ты
                       - COALESCE (MIFloat_TotalReturn.ValueData, 0)
                         -- !!!ПЛЮС!!! TotalReturn - Итого возврат оплаты - все док-ты
                       + COALESCE (MIFloat_TotalPayReturn.ValueData, 0)

                         AS SummDebt_return -- 1.2.
                      , Object.Id AS PartionId_MI

              FROM Movement
                   LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                 ON MovementLinkObject_To.MovementId = Movement.Id
                                                AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                   LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                   INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                 ON MovementLinkObject_From.MovementId = Movement.Id
                                                AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                   LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                   INNER JOIN tmpUnit ON tmpUnit.Id = MovementLinkObject_From.ObjectId
                                     AND tmpUnit.StartDate_sybase > Movement.OperDate
                   INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                          AND MovementItem.DescId     = zc_MI_Master()
                   LEFT JOIN MovementItemBoolean ON MovementItemBoolean.MovementItemId = MovementItem.Id
                                                AND MovementItemBoolean.DescId     = zc_MIBoolean_Close()
                                                AND MovementItemBoolean.ValueData  = TRUE

                   LEFT JOIN Object ON Object.ObjectCode = MovementItem.Id
                                   AND Object.DescId     = zc_Object_PartionMI()
                   LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
                   LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = MovementItem.PartionId
                   LEFT JOIN Object AS Object_GoodsSize ON Object_GoodsSize.Id = Object_PartionGoods.GoodsSizeId

                                         LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                                     ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
                                         LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                                     ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
                                         LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay
                                                                     ON MIFloat_TotalChangePercentPay.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()
                                         LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                                     ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                                         LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                                                     ON MIFloat_TotalPayOth.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth()
                                         LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                                     ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                                         LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                                     ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()

                                         LEFT JOIN MovementItemFloat AS MIFloat_TotalCountReturn
                                                                     ON MIFloat_TotalCountReturn.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_TotalCountReturn.DescId         = zc_MIFloat_TotalCountReturn()
                                         LEFT JOIN MovementItemFloat AS MIFloat_TotalReturn
                                                                     ON MIFloat_TotalReturn.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_TotalReturn.DescId         = zc_MIFloat_TotalReturn()
                                         LEFT JOIN MovementItemFloat AS MIFloat_TotalPayReturn
                                                                     ON MIFloat_TotalPayReturn.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_TotalPayReturn.DescId         = zc_MIFloat_TotalPayReturn()

              WHERE Movement.DescId   = zc_Movement_Sale()
                AND Movement.StatusId = zc_Enum_Status_Complete()
                AND MovementItemBoolean.MovementItemId IS NULL
             )

          INSERT INTO _tmpData (isErased, MovementItemId, MovementId, InvNumber, OperDate, StartDate_sybase, FromId, ToId
                              , GoodsId, GoodsSizeId, PartionId, PartionId_MI
                              , COUNT_Sale, COUNT_Ret, SummDebt_sale, SummDebt_return
                               )
             SELECT isErased_go, Id AS MovementItemId, MovementId_go, InvNumber_go :: Integer, OperDate_go, tmpData.StartDate_sybase, tmpData.FromId, tmpData.ToId
                  , tmpData.GoodsId, tmpData.GoodsSizeId, tmpData.PartionId, tmpData.PartionId_MI
                  , tmpData.COUNT_Sale, tmpData.COUNT_Ret, tmpData.SummDebt_sale, tmpData.SummDebt_return
             FROM tmpData;


/*
     -- !!! 1. эти были закрыты ДО StartDate_sybase!!! - УДАЛЯЕМ
     vbTmp:= (WITH tmpRet AS (SELECT Movement.OperDate, tmpData.*
                              FROM _tmpData AS tmpData
                                   INNER JOIN MovementItemLinkObject AS MIL_PartionMI
                                                           ON MIL_PartionMI.ObjectId = tmpData.PartionId_MI
                                                          AND MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI()
                                   INNER JOIN MovementItem ON MovementItem.Id       = MIL_PartionMI.MovementItemId
                                                          AND MovementItem.DescId   = zc_MI_Master()
                                                          AND MovementItem.isErased = FALSE
                                   INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                      AND Movement.DescId   = zc_Movement_ReturnIn()
                                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                                                      AND Movement.OperDate >= tmpData.StartDate_sybase
                              -- WHERE SummDebt_sale <> 0 AND SummDebt_return = 0
                             )

                 , tmpAcc AS (SELECT Movement.OperDate, MIFloat_TotalPay.ValueData AS TotalPay, MIFloat_SummChangePercent.ValueData  AS SummChangePercent, tmpData.*
                              FROM _tmpData AS tmpData
                                   INNER JOIN MovementItemLinkObject AS MIL_PartionMI
                                                           ON MIL_PartionMI.ObjectId = tmpData.PartionId_MI
                                                          AND MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI()
                                   INNER JOIN MovementItem ON MovementItem.Id       = MIL_PartionMI.MovementItemId
                                                          AND MovementItem.DescId   = zc_MI_Master()
                                                          AND MovementItem.isErased = FALSE
                                   INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                      AND Movement.DescId   = zc_Movement_GoodsAccount()
                                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                                                      AND Movement.OperDate >= tmpData.StartDate_sybase
                                                                                     LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                                                                                 ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                                                                                AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                                                                                     LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                                                                                 ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                                                                                                AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()
                              -- WHERE SummDebt_sale = 0 and MIFloat_TotalPay.ValueData <> 0 and goodsCode <> 1 -- AND SummDebt_return = 0
                             )
              -- !!! 1. эти были закрыты ДО StartDate_sybase!!! - УДАЛЯЕМ
              SELECT MAX (tmp.MovementItemId)
              FROM (SELECT *
                           -- !!!ПРОВЕЛИ - вернули обратно!!!
                         , CASE WHEN tmp.MovementDescId = zc_Movement_Sale()
                                     THEN gpComplete_Movement_Sale (tmp.MovementId_go, zfCalc_UserAdmin())

                                WHEN tmp.MovementDescId = zc_Movement_GoodsAccount()
                                     THEN gpComplete_Movement_GoodsAccount (tmp.MovementId_go, zfCalc_UserAdmin())

                                WHEN tmp.MovementDescId = zc_Movement_ReturnIn()
                                     THEN gpComplete_Movement_ReturnIn (tmp.MovementId_go, zfCalc_UserAdmin())
                           END AS x3
                    FROM
                   (SELECT *
                           -- !!!удалили!!!
                         , CASE WHEN tmp.MovementDescId = zc_Movement_Sale()
                                     THEN gpMovementItem_Sale_SetErased (tmp.MovementItemId_go, zfCalc_UserAdmin())

                                WHEN tmp.MovementDescId = zc_Movement_GoodsAccount()
                                     THEN gpMovementItem_GoodsAccount_SetErased (tmp.MovementItemId_go, zfCalc_UserAdmin())

                                WHEN tmp.MovementDescId = zc_Movement_ReturnIn()
                                     THEN gpMovementItem_ReturnIn_SetErased (tmp.MovementItemId_go, zfCalc_UserAdmin())
                           END AS x2
                    FROM
                   (SELECT *
                           -- !!!РАСПРОВЕЛИ!!!
                         , CASE WHEN tmp.MovementDescId = zc_Movement_Sale()
                                     THEN gpUnComplete_Movement_Sale (tmp.MovementId_go, zfCalc_UserAdmin())

                                WHEN tmp.MovementDescId = zc_Movement_GoodsAccount()
                                     THEN gpUnComplete_Movement_GoodsAccount (tmp.MovementId_go, zfCalc_UserAdmin())

                                WHEN tmp.MovementDescId = zc_Movement_ReturnIn()
                                     THEN gpUnComplete_Movement_ReturnIn (tmp.MovementId_go, zfCalc_UserAdmin())
                           END AS x1
                    FROM
                    
                   (-- ПАРТИИ - ПРОДАЖИ
                    SELECT 3 AS Ord, _tmpData.*, _tmpData.MovementId AS MovementId_go, _tmpData.MovementItemId AS MovementItemId_go
                         , zc_Movement_Sale() AS MovementDescId
                    FROM _tmpData
                    WHERE _tmpData.SummDebt_return = 0
                      AND _tmpData.MovementItemId NOT IN (SELECT tmpRet.MovementItemId from tmpRet)
                      AND _tmpData.MovementItemId NOT IN (SELECT tmpAcc.MovementItemId from tmpAcc)
                   UNION ALL
                    -- ДОБАВИЛИ - ВОЗВРАТЫ - для партий
                    SELECT 2 AS Ord, _tmpData.*, Movement.Id AS MovementId_go, MovementItem.Id AS MovementItemId_go
                         , Movement.DescId AS MovementDescId
                    FROM _tmpData
                                   INNER JOIN MovementItemLinkObject AS MIL_PartionMI
                                                           ON MIL_PartionMI.ObjectId = _tmpData.PartionId_MI
                                                          AND MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI()
                                   INNER JOIN MovementItem ON MovementItem.Id       = MIL_PartionMI.MovementItemId
                                                          AND MovementItem.DescId   = zc_MI_Master()
                                                          AND MovementItem.isErased = FALSE
                                   INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                      AND Movement.DescId   = zc_Movement_ReturnIn()
                                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                                                      -- !!!все что ДО!!!
                                                      AND Movement.OperDate < _tmpData.StartDate_sybase
                    WHERE _tmpData.SummDebt_return = 0
                      AND _tmpData.MovementItemId NOT IN (SELECT tmpRet.MovementItemId from tmpRet)
                      AND _tmpData.MovementItemId NOT IN (SELECT tmpAcc.MovementItemId from tmpAcc)
                   UNION ALL
                    -- ДОБАВИЛИ - ОПЛАТЫ - для партий
                    SELECT 1 AS Ord, _tmpData.*, Movement.Id AS MovementId_go, MovementItem.Id AS MovementItemId_go
                         , Movement.DescId AS MovementDescId
                    FROM _tmpData
                                   INNER JOIN MovementItemLinkObject AS MIL_PartionMI
                                                           ON MIL_PartionMI.ObjectId = _tmpData.PartionId_MI
                                                          AND MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI()
                                   INNER JOIN MovementItem ON MovementItem.Id       = MIL_PartionMI.MovementItemId
                                                          AND MovementItem.DescId   = zc_MI_Master()
                                                          AND MovementItem.isErased = FALSE
                                   INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                      AND Movement.DescId   = zc_Movement_GoodsAccount()
                                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                                                      -- !!!все что ДО!!!
                                                      AND Movement.OperDate < _tmpData.StartDate_sybase
                    WHERE _tmpData.SummDebt_return = 0
                      AND _tmpData.MovementItemId NOT IN (SELECT tmpRet.MovementItemId from tmpRet)
                      AND _tmpData.MovementItemId NOT IN (SELECT tmpAcc.MovementItemId from tmpAcc)
                    ORDER BY 1
                   ) AS tmp
                   ) AS tmp
                   ) AS tmp
                   ) AS tmp
             );
     -- !!! END !!! 1. эти были закрыты ДО StartDate_sybase!!! - УДАЛЯЕМ
     */



     -- Результат - !!! 2. эти были закрыты ПОСЛЕ StartDate_sybase!!! но списаны в кол-ве на ПОК - значит проводки делаем только по сумме
     RETURN QUERY
        WITH tmpAcc_PREV AS (SELECT Movement.OperDate, MIFloat_TotalPay.ValueData AS TotalPay, MIFloat_SummChangePercent.ValueData  AS SummChangePercent, tmpData.*
                             FROM _tmpData AS tmpData
                                  INNER JOIN MovementItemLinkObject AS MIL_PartionMI
                                                          ON MIL_PartionMI.ObjectId = tmpData.PartionId_MI
                                                         AND MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI()
                                  INNER JOIN MovementItem ON MovementItem.Id       = MIL_PartionMI.MovementItemId
                                                         AND MovementItem.DescId   = zc_MI_Master()
                                                         AND MovementItem.isErased = FALSE
                                  INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                     AND Movement.DescId   = zc_Movement_GoodsAccount()
                                                     AND Movement.StatusId = zc_Enum_Status_Complete()
                                                     AND Movement.OperDate < tmpData.StartDate_sybase
                                                                                    LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                                                                                ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                                                                               AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                                                                                    LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                                                                                ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                                                                                               AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()
                             -- WHERE SummDebt_sale = 0 and MIFloat_TotalPay.ValueData <> 0 and goodsCode <> 1 -- AND SummDebt_return = 0
                            )
       -- Результат
       SELECT _tmpData.isErased, _tmpData.MovementItemId, _tmpData.MovementId, _tmpData.InvNumber, _tmpData.OperDate, _tmpData.StartDate_sybase
            , _tmpData.FromId, Object_From.ValueData AS FromName
            , _tmpData.ToId, Object_To.ValueData AS ToName
            , _tmpData.GoodsId, Object_Goods.ObjectCode AS GoodsCode, Object_Goods.ValueData AS GoodsName
            , _tmpData.GoodsSizeId, Object_GoodsSize.ValueData AS GoodsSizeName
            , _tmpData.PartionId, _tmpData.PartionId_MI
            , _tmpData.COUNT_Sale, _tmpData.COUNT_Ret, _tmpData.SummDebt_sale, _tmpData.SummDebt_return
       FROM _tmpData
            LEFT JOIN Object AS Object_From      ON Object_From.Id                     = _tmpData.FromId
            LEFT JOIN Object AS Object_To        ON Object_To.Id                       = _tmpData.ToId
            LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id                    = _tmpData.GoodsId
            LEFT JOIN Object AS Object_GoodsSize ON Object_GoodsSize.Id                = _tmpData.GoodsSizeId
            LEFT JOIN Object_PartionGoods        ON Object_PartionGoods.MovementItemId = _tmpData.PartionId
       WHERE _tmpData.MovementItemId IN (SELECT tmpAcc_PREV.MovementItemId from tmpAcc_PREV)
       -- WHERE _tmpData.isErased = TRUE
      ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 26.01.18                                        *
*/

-- !!! товар - ДОЛГ!!! - значит проводки делаем только по сумме
-- SELECT * FROM gpSelect_MovementItem_Sale_Sybase_Check() WHERE GoodsCode = 1

-- SELECT * FROM tmpData WHERE SummDebt_sale <> 0 AND SummDebt_return = 0
-- SELECT * FROM tmpRet where COUNT_Sale <>  COUNT_Ret
-- SELECT * FROM tmpData WHERE SummDebt_return = 0 AND Id in (SELECT Id from tmpAcc_PREV)
-- SELECT * FROM tmpAcc

-- тест
-- SELECT * FROM gpSelect_MovementItem_Sale_Sybase_Check();
