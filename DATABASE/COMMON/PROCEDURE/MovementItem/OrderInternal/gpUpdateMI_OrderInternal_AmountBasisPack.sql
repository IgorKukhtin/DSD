-- Function: gpUpdateMI_OrderInternal_AmountBasisPack()

DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_AmountBasisPack (Integer, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderInternal_AmountBasisPack(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inOperDate            TDateTime , -- Дата документа
    IN inFromId              Integer   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate   TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderInternal());

     vbStartDate := inOperDate - INTERVAL '28 day'; 
     vbEndDate := inOperDate - INTERVAL '1 day';

    -- таблица -
   CREATE TEMP TABLE tmpAll (GoodsId Integer, GoodsKindId Integer, Amount TFloat) ON COMMIT DROP;
   --
   INSERT INTO tmpAll (GoodsId, GoodsKindId, Amount)
                                 WITH tmpUnit AS (SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inFromId) AS lfSelect_Object_Unit_byGroup)
                                    , tmpGoods AS (SELECT lfSelect.GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (1917) AS lfSelect)    -- группа СД-СЫРЬЕ (1917)
                                                  
                                 SELECT tmp.GoodsId
                                      , tmp.GoodsKindId
                                      , (tmp.Amount)/28 * 3  AS Amount  -- средняя потребность на 3 дня  (среднее считаем за 4 недели (28 дней)) 
                                 FROM (-- !!!!ПРОИЗВОДСТВО
                                       SELECT MovementItem.ObjectId                         AS GoodsId
                                            , MILinkObject_GoodsKind.ObjectId               AS GoodsKindId
                                            , SUM (COALESCE (MovementItem.Amount, 0))             AS Amount
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
                                      ) AS tmp

                                     ;

         -- сохранили
       PERFORM lpUpdate_MI_OrderInternal_Property (ioId                 := COALESCE (tmp.MovementItemId,0)
                                                 , inMovementId         := inMovementId
                                                 , inGoodsId            := COALESCE (tmpAll.GoodsId, tmp.GoodsId)
                                                 , inGoodsKindId        := COALESCE (tmpAll.GoodsKindId, tmp.GoodsKindId)
                                                 , inAmount_Param       := COALESCE (tmpAll.Amount, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_Param       := zc_MIFloat_AmountPartner()
                                                 , inAmount_ParamOrder  := NULL
                                                 , inDescId_ParamOrder  := NULL
                                                 , inAmount_ParamSecond := NULL
                                                 , inDescId_ParamSecond := NULL
                                                 , inIsPack             := NULL
                                                 , inUserId             := vbUserId
                                                  ) 
       FROM tmpAll
         
         FULL JOIN
                   (SELECT MAX (MovementItem.Id)                         AS MovementItemId 
                         , MovementItem.ObjectId                         AS GoodsId
                         , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                    FROM MovementItem 
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                          ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                    GROUP BY MovementItem.ObjectId
                           , MILinkObject_GoodsKind.ObjectId
                   ) AS tmp ON tmp.GoodsId = tmpAll.GoodsId
                           AND COALESCE (tmp.GoodsKindId,0) = COALESCE (tmpAll.GoodsKindId,0)

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
 25.12.19         *
*/

-- тест
-- SELECT * FROM gpUpdateMI_OrderInternal_AmountBasisPack (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
