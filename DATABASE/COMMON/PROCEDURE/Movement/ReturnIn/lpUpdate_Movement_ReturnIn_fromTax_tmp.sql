-- Function: lpUpdate_Movement_ReturnIn_fromTax_tmp() - !!!ВРЕМЕННО!!!

DROP FUNCTION IF EXISTS lpUpdate_Movement_ReturnIn_fromTax_tmp (Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Movement_ReturnIn_fromTax_tmp(
    IN inMovementId          Integer   , -- ключ Документа - zc_Movement_ReturnIn
--   OUT outMessageText        Text      ,
    IN inUserId              Integer     -- Пользователь
)
-- RETURNS Text
RETURNS TABLE (LineNum         Integer
             , LineNum3        Integer
             , LineNum1        Integer
             , LineNum2        Integer

             , ParentId            Integer
             , MovementId_sale     Integer
             , MovementItemId_sale Integer

             , MovementId1 Integer
             , MovementId2 Integer
             , MovementId3 Integer
             , MovementId4 Integer
             , MovementItemId1 Integer
             , MovementItemId2 Integer
             , MovementItemId3 Integer
             , MovementItemId4 Integer

             , MovementId_corr Integer
             , MovementId_tax  Integer

             , GoodsId         Integer
             , GoodsKindId     Integer
             , GoodsKindId_tax Integer
             , Amount          TFloat
             , Price_original  TFloat
              )
AS
$BODY$
BEGIN

     -- таблица - возвратов
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, OperCount TFloat, OperCount_Partner TFloat, Price_original TFloat)  ON COMMIT DROP;
     -- таблица - корректировки
     CREATE TEMP TABLE _tmpMI_corr (LineNum Integer, LineNum3 Integer, LineNum1 Integer, LineNum2 Integer, MovementId_corr Integer, MovementId_tax Integer, GoodsId Integer, GoodsKindId Integer, GoodsKindId_tax Integer, Amount TFloat, Price_original TFloat) ON COMMIT DROP;
     -- таблица - продаж
     CREATE TEMP TABLE _tmpMI_sale (MovementId_tax Integer, MovementId Integer, MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, Amount TFloat, Price_original TFloat) ON COMMIT DROP;


     -- таблица - возвратов
     INSERT INTO _tmpItem (MovementItemId, GoodsId, GoodsKindId, OperCount, OperCount_Partner, Price_original)
        SELECT (MovementItem.Id)
             , MovementItem.ObjectId AS GoodsId
             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
             , CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN MIFloat_AmountPartner.ValueData ELSE MovementItem.Amount END AS OperCount
             , CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN MIFloat_AmountPartner.ValueData ELSE MovementItem.Amount END AS OperCount_Partner
             , COALESCE (MIFloat_Price.ValueData, 0) AS Price_original
        FROM MovementItem
             LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                         ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
        WHERE MovementItem.MovementId  = inMovementId
          AND MovementItem.isErased = FALSE
          AND MovementItem.DescId   = zc_MI_Master()
          AND CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN MIFloat_AmountPartner.ValueData ELSE MovementItem.Amount END <> 0
       ;


     -- таблица - корректировки
     INSERT INTO _tmpMI_corr (LineNum, LineNum3, LineNum1, LineNum2, MovementId_corr, MovementId_tax, GoodsId, GoodsKindId, GoodsKindId_tax, Amount, Price_original)
     WITH -- все корр + налог., для 1-ого док. Возврат
          tmpMovementCorr AS (SELECT MovementLinkMovement_Master.MovementId     AS MovementId_corr
                                   , MovementLinkMovement_Child.MovementChildId AS MovementId_tax
                              FROM MovementLinkMovement AS MovementLinkMovement_Master
                                   -- только проведенные корр.
                                   INNER JOIN Movement ON Movement.Id       = MovementLinkMovement_Master.MovementId
                                                      AND Movement.DescId   = zc_Movement_TaxCorrective()
                                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                                   -- а налог. проверять не будем
                                   INNER JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                                                   ON MovementLinkMovement_Child.MovementId = MovementLinkMovement_Master.MovementId
                                                                  AND MovementLinkMovement_Child.DescId      = zc_MovementLinkMovement_Child()
                              WHERE MovementLinkMovement_Master.MovementChildId = inMovementId
                                AND MovementLinkMovement_Master.DescId          = zc_MovementLinkMovement_Master()
                             )
                -- строчная часть всех налоговых
              , tmpMI_Tax AS (SELECT DISTINCT lpSelect.*
                              FROM (SELECT DISTINCT tmpMovementCorr.MovementId_tax FROM tmpMovementCorr) AS tmp
                                   INNER JOIN lpSelect_TaxFromTaxCorrective (inMovementId:= tmp.MovementId_tax
                                                                            ) AS lpSelect ON lpSelect.MovementId = tmp.MovementId_tax
                             )
        -- результат - корректировки + налог + № п/п
        SELECT COALESCE (ABS (tmpMITax3.LineNum), COALESCE (ABS (tmpMITax1.LineNum), ABS (tmpMITax2.LineNum))) AS LineNum
             , (tmpMITax3.LineNum) AS LineNum3
             , (tmpMITax1.LineNum) AS LineNum1
             , (tmpMITax2.LineNum) AS LineNum2
             , tmpMovementCorr.MovementId_corr
             , tmpMovementCorr.MovementId_tax
             , MovementItem.ObjectId
             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
             , COALESCE (tmpMITax3.GoodsKindId_exists, COALESCE (tmpMITax1.GoodsKindId_exists, COALESCE (tmpMITax2.GoodsKindId_exists, 0))) AS GoodsKindId_tax
             , MovementItem.Amount
             , COALESCE (MIFloat_Price.ValueData, 0)
        FROM tmpMovementCorr
             INNER JOIN MovementItem ON MovementItem.MovementId  = tmpMovementCorr.MovementId_corr
                                    AND MovementItem.isErased = FALSE
                                    AND MovementItem.DescId   = zc_MI_Master()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()

             LEFT JOIN MovementItemFloat AS MIFloat_NPP
                                         ON MIFloat_NPP.MovementItemId = MovementItem.Id
                                        AND MIFloat_NPP.DescId = zc_MIFloat_NPP()
             LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                           ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                          AND MIBoolean_isAuto.DescId = zc_MIBoolean_isAuto()

           LEFT JOIN tmpMI_Tax AS tmpMITax3 ON tmpMITax3.MovementId       = tmpMovementCorr.MovementId_tax
                                           AND ABS (tmpMITax3.LineNum)    = MIFloat_NPP.ValueData :: Integer
                                           AND tmpMITax3.Kind             = 1
                                           AND MIBoolean_isAuto.ValueData = FALSE
           LEFT JOIN tmpMI_Tax AS tmpMITax1 ON tmpMITax1.MovementId  = tmpMovementCorr.MovementId_tax
                                           AND tmpMITax1.Kind        = 1
                                           AND tmpMITax1.GoodsId     = MovementItem.ObjectId
                                           AND tmpMITax1.GoodsKindId = MILinkObject_GoodsKind.ObjectId
                                           AND tmpMITax1.Price       = MIFloat_Price.ValueData
                                           AND tmpMITax3.LineNum     IS NULL
           LEFT JOIN tmpMI_Tax AS tmpMITax2 ON tmpMITax2.MovementId  = tmpMovementCorr.MovementId_tax
                                           AND tmpMITax2.Kind        = 2
                                           AND tmpMITax2.GoodsId     = MovementItem.ObjectId
                                           AND tmpMITax2.Price       = MIFloat_Price.ValueData
                                           AND tmpMITax1.GoodsId     IS NULL
                                           AND tmpMITax3.LineNum     IS NULL

       ;

     -- таблица - продаж
     INSERT INTO _tmpMI_sale (MovementId_tax, MovementId, MovementItemId, GoodsId, GoodsKindId, Amount, Price_original)
     WITH -- один документ продажи - для 1-ой из налоговой
          tmpMovement AS (SELECT _tmpMI_corr.MovementId_tax, MAX (MovementLinkMovement_Master.MovementId) AS MovementId_sale
                          FROM _tmpMI_corr
                               INNER JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                                               ON MovementLinkMovement_Master.MovementChildId = _tmpMI_corr.MovementId_tax
                                                              AND MovementLinkMovement_Master.DescId          = zc_MovementLinkMovement_Master()
                               INNER JOIN Movement ON Movement.Id       = MovementLinkMovement_Master.MovementId
                                                  AND Movement.DescId   IN (zc_Movement_Sale(), zc_Movement_TransferDebtOut())
                                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                          GROUP BY _tmpMI_corr.MovementId_tax
                          )
        -- !!!Оптимизация - так быстрее!!!
        , tmp1 AS (SELECT tmpMovement.MovementId_tax
                        , tmpMovement.MovementId_sale
                        , (MovementItem.Id)                     AS MovementItemId
                        , MovementItem.ObjectId                 AS GoodsId
                        , (MovementItem.Amount)                 AS Amount
                        , COALESCE (MIFloat_Price.ValueData, 0) AS Price
                   FROM tmpMovement
                        INNER JOIN MovementItem ON MovementItem.MovementId  = tmpMovement.MovementId_sale
                                               AND MovementItem.isErased = FALSE
                                               AND MovementItem.DescId   = zc_MI_Master()
                        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()
                   )
        , tmp2 AS (SELECT tmp.MovementId_tax
                        , tmp.MovementId_sale
                        , tmp.MovementItemId
                        , tmp.GoodsId
                        , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                        , tmp.Amount
                        , tmp.Price
                   FROM tmp1 AS tmp
                        LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                         ON MILinkObject_GoodsKind.MovementItemId = tmp.MovementItemId
                                                        AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                  )
        -- результат - продажи
        SELECT tmp.MovementId_tax
             , tmp.MovementId_sale
             , MIN (tmp.MovementItemId) AS MovementItemId
             , tmp.GoodsId
             , tmp.GoodsKindId
             , SUM (tmp.Amount) AS Amount
             , tmp.Price
        FROM tmp2 AS tmp
        GROUP BY tmp.MovementId_tax
               , tmp.MovementId_sale
               , tmp.GoodsId
               , tmp.GoodsKindId
               , tmp.Price
       ;


     -- таблица - результат
     CREATE TEMP TABLE _tmpResult ON COMMIT DROP AS
        WITH tmpReturn AS (SELECT MIN (_tmpItem.MovementItemId) AS MovementItemId
                                , _tmpItem.GoodsId
                                , _tmpItem.GoodsKindId
                                , SUM (_tmpItem.OperCount_Partner) AS Amount
                                , _tmpItem.Price_original
                           FROM _tmpItem
                           GROUP BY _tmpItem.GoodsId
                                  , _tmpItem.GoodsKindId
                                  , _tmpItem.Price_original
                          )
             -- корректировка - по товар + вид
          , _tmpMI_corr2 AS (SELECT _tmpMI_corr.*
                                  , ROW_NUMBER() OVER (PARTITION BY _tmpMI_corr.MovementId_tax, _tmpMI_corr.GoodsId, _tmpMI_corr.GoodsKindId ORDER BY _tmpMI_corr.LineNum ASC) AS Ord
                             FROM _tmpMI_corr
                            )
             -- продажа - по товар + цена
          , _tmpMI_sale2 AS (SELECT _tmpMI_sale.*
                                  , ROW_NUMBER() OVER (PARTITION BY _tmpMI_sale.MovementId_tax, _tmpMI_sale.GoodsId, _tmpMI_sale.Price_original ORDER BY _tmpMI_sale.Amount DESC, _tmpMI_sale.MovementItemId ASC) AS Ord
                             FROM _tmpMI_sale
                            )
             -- продажа - по товар + вид
          , _tmpMI_sale3 AS (SELECT _tmpMI_sale.*
                                  , ROW_NUMBER() OVER (PARTITION BY _tmpMI_sale.MovementId_tax, _tmpMI_sale.GoodsId, _tmpMI_sale.GoodsKindId ORDER BY _tmpMI_sale.Amount DESC, _tmpMI_sale.MovementItemId ASC) AS Ord
                             FROM _tmpMI_sale
                            )
             -- продажа - по товар
          , _tmpMI_sale4 AS (SELECT _tmpMI_sale.*
                                  , ROW_NUMBER() OVER (PARTITION BY _tmpMI_sale.MovementId_tax, _tmpMI_sale.GoodsId ORDER BY _tmpMI_sale.Amount DESC, _tmpMI_sale.MovementItemId ASC) AS Ord
                             FROM _tmpMI_sale
                            )
        -- результат
        SELECT COALESCE (_tmpMI_corr1.LineNum, -1 * _tmpMI_corr2.LineNum) :: Integer AS LineNum
             , COALESCE (_tmpMI_corr1.LineNum3, _tmpMI_corr2.LineNum3)    :: Integer AS LineNum3
             , COALESCE (_tmpMI_corr1.LineNum1, _tmpMI_corr2.LineNum1)    :: Integer AS LineNum1
             , COALESCE (_tmpMI_corr1.LineNum2, _tmpMI_corr2.LineNum2)    :: Integer AS LineNum2

             , tmpReturn.MovementItemId AS ParentId
             , COALESCE (_tmpMI_sale1.MovementId, COALESCE (_tmpMI_sale2.MovementId, COALESCE (_tmpMI_sale3.MovementId, COALESCE (_tmpMI_sale4.MovementId, 0)))) :: Integer AS MovementId_sale
             , COALESCE (_tmpMI_sale1.MovementItemId, COALESCE (_tmpMI_sale2.MovementItemId, COALESCE (_tmpMI_sale3.MovementItemId, COALESCE (_tmpMI_sale4.MovementItemId, 0)))) :: Integer AS MovementItemId_sale

             , _tmpMI_sale1.MovementId AS MovementId1
             , _tmpMI_sale2.MovementId AS MovementId2
             , _tmpMI_sale3.MovementId AS MovementId3
             , _tmpMI_sale4.MovementId AS MovementId4
             , _tmpMI_sale1.MovementItemId AS MovementItemId1
             , _tmpMI_sale2.MovementItemId AS MovementItemId2
             , _tmpMI_sale3.MovementItemId AS MovementItemId3
             , _tmpMI_sale4.MovementItemId AS MovementItemId4

             , COALESCE (_tmpMI_corr1.MovementId_corr, _tmpMI_corr2.MovementId_corr) AS MovementId_corr
             , COALESCE (_tmpMI_corr1.MovementId_tax, _tmpMI_corr2.MovementId_tax)   AS MovementId_tax

             , tmpReturn.GoodsId
             , tmpReturn.GoodsKindId
             , COALESCE (_tmpMI_corr1.GoodsKindId_tax, _tmpMI_corr2.GoodsKindId_tax) AS GoodsKindId_tax
             , COALESCE (_tmpMI_corr1.Amount, _tmpMI_corr2.Amount)                   AS Amount
             , tmpReturn.Price_original
        FROM tmpReturn
             -- корректировка - по всем параметрам 
             LEFT JOIN _tmpMI_corr AS _tmpMI_corr1 ON _tmpMI_corr1.GoodsId        = tmpReturn.GoodsId
                                                  AND _tmpMI_corr1.GoodsKindId    = tmpReturn.GoodsKindId
                                                  AND _tmpMI_corr1.Price_original = tmpReturn.Price_original
             -- корректировка - по товар + вид
             LEFT JOIN _tmpMI_corr2 ON _tmpMI_corr2.GoodsId        = tmpReturn.GoodsId
                                   AND _tmpMI_corr2.GoodsKindId    = tmpReturn.GoodsKindId
                                   AND _tmpMI_corr2.Ord            = 1
                                   AND _tmpMI_corr1.GoodsId        IS NULL
             -- продажа - по всем параметрам 
             LEFT JOIN _tmpMI_sale AS _tmpMI_sale1 ON _tmpMI_sale1.MovementId_tax = COALESCE (_tmpMI_corr1.MovementId_tax, _tmpMI_corr2.MovementId_tax)
                                                  AND _tmpMI_sale1.GoodsId        = tmpReturn.GoodsId
                                                  AND _tmpMI_sale1.GoodsKindId    = COALESCE (_tmpMI_corr1.GoodsKindId_tax, _tmpMI_corr2.GoodsKindId_tax)
                                                  AND _tmpMI_sale1.Price_original = tmpReturn.Price_original
             -- продажа - по товар + цена
             LEFT JOIN _tmpMI_sale2 ON _tmpMI_sale2.MovementId_tax = COALESCE (_tmpMI_corr1.MovementId_tax, _tmpMI_corr2.MovementId_tax)
                                   AND _tmpMI_sale2.GoodsId        = tmpReturn.GoodsId
                                   AND _tmpMI_sale2.Price_original = tmpReturn.Price_original
                                   AND _tmpMI_sale2.Ord            = 1
                                   AND _tmpMI_sale1.GoodsId        IS NULL
             -- продажа - по товар + вид
             LEFT JOIN _tmpMI_sale3 ON _tmpMI_sale3.MovementId_tax = COALESCE (_tmpMI_corr1.MovementId_tax, _tmpMI_corr2.MovementId_tax)
                                   AND _tmpMI_sale3.GoodsId        = tmpReturn.GoodsId
                                   AND _tmpMI_sale3.GoodsKindId    = COALESCE (_tmpMI_corr1.GoodsKindId_tax, _tmpMI_corr2.GoodsKindId_tax)
                                   AND _tmpMI_sale3.Ord            = 1
                                   AND _tmpMI_sale1.GoodsId        IS NULL
                                   AND _tmpMI_sale2.GoodsId        IS NULL
             -- продажа - по товар
             LEFT JOIN _tmpMI_sale4 ON _tmpMI_sale4.MovementId_tax = COALESCE (_tmpMI_corr1.MovementId_tax, _tmpMI_corr2.MovementId_tax)
                                   AND _tmpMI_sale4.GoodsId        = tmpReturn.GoodsId
                                   AND _tmpMI_sale4.Ord            = 1
                                   AND _tmpMI_sale1.GoodsId        IS NULL
                                   AND _tmpMI_sale2.GoodsId        IS NULL
                                   AND _tmpMI_sale3.GoodsId        IS NULL
       ;

     -- !!!сохранили!!!
     PERFORM lpInsertUpdate_MovementItem_ReturnIn_Child (ioId                  := tmp.MovementItemId
                                                       , inMovementId          := inMovementId
                                                       , inParentId            := tmp.ParentId
                                                       , inGoodsId             := tmp.GoodsId
                                                       , inAmount              := CASE WHEN tmp.MovementId_sale > 0 AND tmp.MovementItemId_sale > 0 THEN COALESCE (tmp.Amount, 0) ELSE 0 END
                                                       , inMovementId_sale     := COALESCE (tmp.MovementId_sale, 0)
                                                       , inMovementItemId_sale := COALESCE (tmp.MovementItemId_sale, 0)
                                                       , inUserId              := inUserId
                                                       , inIsRightsAll         := TRUE
                                                        )
     FROM (WITH MI_Master AS (SELECT _tmpItem.MovementItemId AS Id, _tmpItem.GoodsId
                              FROM _tmpItem
                             )
               , MI_Child AS (SELECT MovementItem.Id, MovementItem.ParentId, COALESCE (MIFloat_MovementItemId.ValueData, 0) :: Integer AS MovementItemId_sale
                              FROM MovementItem
                                   LEFT JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                               ON MIFloat_MovementItemId.MovementItemId = MovementItem.Id
                                                              AND MIFloat_MovementItemId.DescId         = zc_MIFloat_MovementItemId()
                              WHERE MovementItem.MovementId = inMovementId
                                AND MovementItem.DescId     = zc_MI_Child()
                             )
                 , MI_All AS (SELECT MI_Child.Id AS MovementItemId
                                   , COALESCE (_tmpResult_ReturnIn_Auto.ParentId, COALESCE (MI_Child.ParentId, 0)) AS ParentId
                                   , _tmpResult_ReturnIn_Auto.MovementId_sale
                                   , _tmpResult_ReturnIn_Auto.MovementItemId_sale
                                   , _tmpResult_ReturnIn_Auto.Amount
                              FROM _tmpResult AS _tmpResult_ReturnIn_Auto
                                   FULL JOIN MI_Child ON MI_Child.ParentId            = _tmpResult_ReturnIn_Auto.ParentId
                                                     AND MI_Child.MovementItemId_sale = _tmpResult_ReturnIn_Auto.MovementItemId_sale
                             )
           -- результат
           SELECT MI_Master.Id AS ParentId
                , MI_Master.GoodsId
                , MI_All.MovementItemId
                , MI_All.MovementId_sale
                , MI_All.MovementItemId_sale
                , MI_All.Amount
           FROM MI_Master
                LEFT JOIN MI_All ON MI_All.ParentId = MI_Master.Id
          ) AS tmp;

     -- результат
     RETURN QUERY
     SELECT * FROM _tmpResult;

     -- результат
     /*outMessageText:= lpCheck_Movement_ReturnIn_Auto (inMovementId    := inMovementId
                                                    , inUserId        := inUserId
                                                     );*/


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 16.05.16                                        *
*/

-- тест
-- SELECT * FROM MovementItem WHERE MovementId = 3662505 AND DescId = zc_MI_Child() -- SELECT * FROM MovementItemFloat WHERE MovementItemId IN (SELECT Id FROM MovementItem WHERE MovementId = 3662505 AND DescId = zc_MI_Child())
-- SELECT * FROM lpUpdate_Movement_ReturnIn_fromTax_tmp (inMovementId:= 3662505 , inUserId:= zfCalc_UserAdmin() :: Integer) ORDER BY 1
-- SELECT * FROM lpUpdate_Movement_ReturnIn_fromTax_tmp (inMovementId:= 2242573 , inUserId:= zfCalc_UserAdmin() :: Integer) ORDER BY 1
