-- Function: gpUpdateMI_OrderInternal_AmountForecastBasisPack()

DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_AmountForecastBasisPack (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderInternal_AmountForecastBasisPack(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inFromId              Integer   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsPack  Boolean;
   DECLARE vbIsBasis Boolean;

   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate   TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderInternal());

     SELECT Movement.OperDate - INTERVAL '28 day'
          , Movement.OperDate - INTERVAL '1 day'
    INTO vbStartDate, vbEndDate
     FROM Movement
     WHERE Movement.Id = inMovementId;
     
    -- расчет, временно хардкод
    vbIsPack:= EXISTS (SELECT MovementId FROM MovementLinkObject WHERE DescId = zc_MovementLinkObject_To() AND MovementId = inMovementId AND ObjectId = 8455); -- Склад специй ---
    -- расчет, временно хардкод
    vbIsBasis:= EXISTS (SELECT MovementId FROM MovementLinkObject WHERE DescId = zc_MovementLinkObject_From() AND MovementId = inMovementId AND ObjectId IN (SELECT tmp.UnitId FROM lfSelect_Object_Unit_byGroup (8451) AS tmp)); -- Цех упаковки
 
    -- сохранили свойство <Дата проноз с>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateStart(), inMovementId, vbStartDate);
    -- сохранили свойство <Дата проноз по>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateEnd(), inMovementId, vbEndDate);


     -- таблица -
     CREATE TEMP TABLE tmpAll (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, AmountForecast TFloat) ON COMMIT DROP;
         INSERT INTO tmpAll (MovementItemId, GoodsId, GoodsKindId, AmountForecast)

         WITH tmpUnit AS (SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inFromId) AS lfSelect_Object_Unit_byGroup)
            , tmpGoods AS (SELECT lfSelect.GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (1917) AS lfSelect)    -- группа СД-СЫРЬЕ (1917)
            , tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId 
                             , MovementItem.ObjectId                         AS GoodsId
                             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                             , MovementItem.Amount
                        FROM MovementItem 
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                        WHERE MovementItem.MovementId = inMovementId
                          AND MovementItem.DescId     = zc_MI_Master()
                          AND MovementItem.isErased   = FALSE
                       )
            , tmpProductionUnion AS (-- !!!!ПРОИЗВОДСТВО
                                     SELECT MovementItem.ObjectId                         AS GoodsId
                                          , MILinkObject_GoodsKind.ObjectId               AS GoodsKindId
                                          , SUM (COALESCE (MovementItem.Amount, 0))       AS Amount
                                     FROM Movement
                                          INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                          INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_From.ObjectId

                                          INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                       AND MovementLinkObject_To.ObjectId = MovementLinkObject_From.ObjectId

                                          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                 AND MovementItem.DescId     = zc_MI_Child()
                                                                 AND MovementItem.isErased   = FALSE
                                          INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                                     WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                                       AND Movement.DescId = zc_Movement_ProductionUnion()
                                       AND Movement.StatusId = zc_Enum_Status_Complete()
                                     GROUP BY MovementItem.ObjectId
                                            , MILinkObject_GoodsKind.ObjectId
                                    )
         -- данные из zc_Movement_ProductionUnion за 4 недели
         SELECT COALESCE (tmpMI.MovementItemId, 0)                            AS MovementItemId
              , COALESCE (tmpMI.GoodsId,tmpProductionUnion.GoodsId)          AS GoodsId
              , COALESCE (tmpMI.GoodsKindId, tmpProductionUnion.GoodsKindId) AS GoodsKindId
              , COALESCE (tmpProductionUnion.Amount, 0)                      AS AmountForecast
         FROM tmpProductionUnion
         FULL JOIN tmpMI ON tmpMI.GoodsId = tmpProductionUnion.GoodsId
                        AND COALESCE (tmpMI.GoodsKindId,0) = COALESCE (tmpProductionUnion.GoodsKindId,0)
         ;

       -- сохранили
       PERFORM lpUpdate_MI_OrderInternal_Property (ioId                 := tmpAll.MovementItemId
                                                 , inMovementId         := inMovementId
                                                 , inGoodsId            := tmpAll.GoodsId
                                                 , inGoodsKindId        := tmpAll.GoodsKindId
                                                 , inAmount_Param       := tmpAll.AmountForecast * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_Param       := zc_MIFloat_AmountForecast()
                                                 , inAmount_ParamOrder  := NULL
                                                 , inDescId_ParamOrder  := NULL
                                                 , inAmount_ParamSecond := NULL
                                                 , inDescId_ParamSecond := NULL
                                                 , inIsPack             := NULL
                                                 , inUserId             := vbUserId
                                                  ) 
       FROM tmpAll
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpAll.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpAll.GoodsId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.12.19         *
*/

-- тест
