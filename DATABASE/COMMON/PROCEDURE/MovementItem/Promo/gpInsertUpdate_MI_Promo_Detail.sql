-- Function: gpInsertUpdate_MI_Promo_Detail()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Promo_Detail (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Promo_Detail(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Promo_Data());


     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmpReport')
     THEN
         DELETE FROM _tmpReport;
     ELSE
         -- данные по документам Данные Sale / Order / ReturnIn где установлен признак "акция"
         CREATE TEMP TABLE _tmpReport (GoodsId Integer, GoodsKindId Integer, OperDate TDateTime, Amount TFloat, AmountIn TFloat, AmountReal TFloat, AmountRetIn TFloat) ON COMMIT DROP;
     END IF;

    --удалить уже сохраненные строки, (  на случай неправильного расчета ) 
    PERFORM lpSetErased_MovementItem (inMovementItemId:= tmp.Id, inUserId:= vbUserId)
    FROM (SELECT MovementItem.Id, MIDate_OperDate.ValueData AS OperDate
               , ROW_NUMBER () OVER (PARTITION BY MovementItem.ParentId, MIDate_OperDate.ValueData ORDER by MovementItem.Id) AS ord
          FROM MovementItem
            LEFT JOIN MovementItemDate AS MIDate_OperDate
                                       ON MIDate_OperDate.MovementItemId = MovementItem.Id
                                      AND MIDate_OperDate.DescId = zc_MIDate_OperDate()
          WHERE MovementItem.MovementId = inMovementId
            AND MovementItem.DescId = zc_MI_Detail()
            AND MovementItem.isErased = FALSE
           ) AS tmp
    WHERE tmp.Ord > 1 OR tmp.OperDate IS NULL;
    --удалить уже сохраненные строки ecли лишний период - непровильный был расчет
    PERFORM lpSetErased_MovementItem (inMovementItemId:= tmp.Id, inUserId:= vbUserId)
    FROM (SELECT MovementItem.Id, MIDate_OperDate.ValueData AS OperDate
               , ROW_NUMBER () OVER (PARTITION BY MovementItem.ParentId, MIDate_OperDate.ValueData ORDER by MovementItem.Id) AS ord
          FROM MovementItem
            LEFT JOIN MovementItemDate AS MIDate_OperDate
                                       ON MIDate_OperDate.MovementItemId = MovementItem.Id
                                      AND MIDate_OperDate.DescId = zc_MIDate_OperDate()
            LEFT JOIN (SELECT DISTINCT _tmpReport.OperDate FROM _tmpReport) AS tmp ON tmp.OperDate = MIDate_OperDate.ValueData
          WHERE MovementItem.MovementId = inMovementId
            AND MovementItem.DescId = zc_MI_Detail()
            AND MovementItem.isErased = FALSE
            AND tmp.OperDate IS NULL
           ) AS tmp
    ;


     -- Данные Sale / ReturnIn
     INSERT INTO _tmpReport (GoodsId, GoodsKindId, OperDate, Amount, AmountIn, AmountReal, AmountRetIn)
        SELECT spReport.GoodsId
             , CASE WHEN spReport.GoodsKindId > 0 THEN spReport.GoodsKindId ELSE spReport.GoodsKindCompleteId END AS GoodsKindId
             , spReport.Month_Partner    AS OperDate
             , spReport.AmountOut        AS Amount
             , spReport.AmountIn         AS AmountIn
             , spReport.AmountReal_calc  AS AmountReal
             , spReport.AmountRetIn_calc AS AmountRetIn
        FROM gpSelect_Report_Promo_Result_Month (inStartDate   := CURRENT_DATE ::TDateTime
                                               , inEndDate     := CURRENT_DATE ::TDateTime
                                               , inIsPromo     := False
                                               , inIsTender    := False
                                               , inisGoodsKind := False
                                               , inisReal      := True
                                               , inUnitId      := 0
                                               , inRetailId    := 0
                                               , inMovementId  := inMovementId
                                               , inJuridicalId := 0
                                               , inSession     := inSession) AS spReport
        ;

     -- Результат -
     PERFORM lpInsertUpdate_MI_PromoGoods_Detail (ioId          := COALESCE (tmp.Id,0)          ::Integer
                                                , inParentId    := COALESCE (tmp.ParentId,0)    ::Integer
                                                , inMovementId  := inMovementId                 ::Integer
                                                , inGoodsId     := tmp.GoodsId                  ::Integer
                                                , inAmount      := COALESCE (tmp.Amount,0)      ::TFloat
                                                , inAmountIn    := COALESCE (tmp.AmountIn,0)    ::TFloat
                                                , inAmountReal  := COALESCE (tmp.AmountReal,0)  ::TFloat
                                                , inAmountRetIn := COALESCE (tmp.AmountRetIn,0) ::TFloat
                                                , inOperDate    := tmp.OperDate                 ::TDateTime
                                                , inUserId      := vbUserId                     ::Integer
                                                 )
     FROM (WITH tmpMI_Master AS (SELECT MovementItem.*
                                      , CASE WHEN COALESCE (MILinkObject_GoodsKind.ObjectId,0) > 0 
                                             THEN COALESCE (MILinkObject_GoodsKind.ObjectId,0)
                                             ELSE COALESCE (MILinkObject_GoodsKindComplete.ObjectId,0)
                                        END   AS GoodsKindId
                                 FROM MovementItem
                                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                      --LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

                                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                                       ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                                      AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                                      --LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = MILinkObject_GoodsKindComplete.ObjectId
                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId = zc_MI_Master()
                                   AND MovementItem.isErased = FALSE
                                 )
              , tmpMI_Detail AS (SELECT MovementItem.*
                                      , MIDate_OperDate.ValueData    ::TDateTime  AS OperDate
                                 FROM MovementItem
                                   LEFT JOIN MovementItemDate AS MIDate_OperDate
                                                              ON MIDate_OperDate.MovementItemId = MovementItem.Id
                                                             AND MIDate_OperDate.DescId = zc_MIDate_OperDate()
                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId = zc_MI_Detail()
                                   AND MovementItem.isErased = FALSE
                                 )

           -- Результат
           SELECT COALESCE (tmpMI_Detail.Id,0)         AS Id
                , tmpMI_Master.Id                      AS ParentId
                , tmpMI_Master.ObjectId                AS GoodsId
                , COALESCE (_tmpReport.Amount,0)               AS Amount
                , COALESCE (_tmpReport.AmountIn, 0)          AS AmountIn
                , COALESCE (_tmpReport.AmountReal, 0)      AS AmountReal
                , COALESCE (_tmpReport.AmountRetIn, 0)    AS AmountRetIn
                , (_tmpReport.OperDate) ::TDateTime AS OperDate
           FROM tmpMI_Master
                --привязка по виду товара
                LEFT JOIN _tmpReport ON _tmpReport.GoodsId = tmpMI_Master.ObjectId
                                    AND COALESCE (_tmpReport.GoodsKindId,0) = COALESCE (tmpMI_Master.GoodsKindId,0)
                                    --AND _tmpReport.GoodsKindId = tmpMI_Master.GoodsKindId
                                    --AND tmpMI_Master.GoodsKindId <> 0
                /*LEFT JOIN (SELECT _tmpReport.GoodsId
                                , _tmpReport.OperDate
                                , SUM (COALESCE (Amount,0))      AS Amount
                                , SUM (COALESCE (AmountIn,0))    AS AmountIn
                                , SUM (COALESCE (AmountReal,0))  AS AmountReal
                                , SUM (COALESCE (AmountRetIn,0)) AS AmountRetIn  
                           FROM  _tmpReport
                           
                           GROUP BY _tmpReport.GoodsId
                                  , _tmpReport.OperDate 
                          ) AS _tmpReport_2
                            ON _tmpReport_2.GoodsId = tmpMI_Master.ObjectId
                           AND COALESCE (tmpMI_Master.GoodsKindId,0) = 0  */
                 
                LEFT JOIN tmpMI_Detail ON tmpMI_Detail.ParentId = tmpMI_Master.Id
                                      AND tmpMI_Detail.OperDate =  _tmpReport.OperDate

          ) AS tmp
     WHERE COALESCE (tmp.Amount,0) <> 0
        OR COALESCE (tmp.AmountIn,0) <> 0
        OR COALESCE (tmp.AmountReal,0) <> 0
        OR COALESCE (tmp.AmountRetIn,0) <> 0
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.12.24         *
*/

-- тест
-- 26423 от 01,10,2024