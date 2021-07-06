-- Function: gpSelect_Movement_ContractGoods_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_ContractGoods_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ContractGoods_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ContractGoods());
     vbUserId:= lpGetUserBySession (inSession);


     -- параметры из документа
     SELECT Movement.DescId
          , Movement.StatusId
          , Movement.OperDate
            INTO vbDescId, vbStatusId, vbOperDate
     FROM Movement
     WHERE Movement.Id = inMovementId;


     -- очень важная проверка
     IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete() AND vbUserId <> 5 -- !!!кроме Админа!!!
     THEN
         IF vbStatusId = zc_Enum_Status_Erased()
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
         END IF;
         IF vbStatusId = zc_Enum_Status_UnComplete()
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
         END IF;
         -- это уже странная ошибка
         RAISE EXCEPTION 'Ошибка.Документ <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
     END IF;


     --
     OPEN Cursor1 FOR
      SELECT Movement.Id                                AS Id
           , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement.Id) AS IdBarCode
           , Movement.InvNumber                         AS InvNumber
           , Movement.OperDate                          AS OperDate
           , Object_Contract.Id                  AS ContractId
           , Object_Contract.ValueData           AS ContractName
           
           , MovementDate_EndBegin.ValueData     AS EndBeginDate

           , MovementString_Comment.ValueData    AS Comment
       FROM Movement
            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementDate AS MovementDate_EndBegin
                                   ON MovementDate_EndBegin.MovementId = Movement.Id
                                  AND MovementDate_EndBegin.DescId = zc_MovementDate_EndBegin()

       WHERE Movement.Id = inMovementId
         -- AND Movement.StatusId = zc_Enum_Status_Complete()
      ;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
       WITH
       tmpGoodsQuality AS (SELECT ObjectLink_Goods.ChildObjectId AS GoodsId
                                , CAST (CASE WHEN POSITION( 'год' IN ObjectString_Value2.ValueData) > 0 THEN CAST(LEFT (ObjectString_Value2.ValueData,POSITION( 'год' IN ObjectString_Value2.ValueData)-1 ) AS NUMERIC (16,0) ) / 24
                                             WHEN POSITION( 'діб' IN ObjectString_Value2.ValueData) > 0 THEN CAST(LEFT (ObjectString_Value2.ValueData,POSITION( 'діб' IN ObjectString_Value2.ValueData)-1 ) AS NUMERIC (16,0) )
                                             WHEN POSITION( 'доб' IN ObjectString_Value2.ValueData) > 0 THEN CAST(LEFT (ObjectString_Value2.ValueData,POSITION( 'доб' IN ObjectString_Value2.ValueData)-1 ) AS NUMERIC (16,0) )
                                             WHEN POSITION( 'міс' IN ObjectString_Value2.ValueData) > 0 THEN CAST(LEFT (ObjectString_Value2.ValueData,POSITION( 'міс' IN ObjectString_Value2.ValueData)-1 ) AS NUMERIC (16,0) ) * 30
                                             WHEN POSITION( 'рок' IN ObjectString_Value2.ValueData) > 0 THEN CAST(LEFT (ObjectString_Value2.ValueData,POSITION( 'рок' IN ObjectString_Value2.ValueData)-1 ) AS NUMERIC (16,0) ) * 364
                                        ELSE 0
                                        END AS NUMERIC (16,0) ) + 1 AS Value2   -- срок хранения в днях
                           FROM ObjectBoolean AS ObjectBoolean_Klipsa
                                INNER JOIN Object AS Object_GoodsQuality 
                                                  ON Object_GoodsQuality.Id = ObjectBoolean_Klipsa.ObjectId
                                                 AND Object_GoodsQuality.isErased = FALSE
                                LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                     ON ObjectLink_Goods.ObjectId = ObjectBoolean_Klipsa.ObjectId
                                                    AND ObjectLink_Goods.DescId = zc_ObjectLink_GoodsQuality_Goods()

                                LEFT JOIN ObjectString AS ObjectString_Value2
                                                       ON ObjectString_Value2.ObjectId = Object_GoodsQuality.Id 
                                                      AND ObjectString_Value2.DescId = zc_ObjectString_GoodsQuality_Value2()
                           WHERE ObjectBoolean_Klipsa.DescId = zc_ObjectBoolean_GoodsQuality_Klipsa()
                             AND ObjectBoolean_Klipsa.ValueData = TRUE
                           )

       SELECT
             Object_Unit.ObjectCode          AS UnitCode
           , Object_Unit.ValueData           AS UnitName 

           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.ValueData     AS GoodsGroupName 
           , Object_Goods.ObjectCode  	     AS GoodsCode
           , Object_Goods.ValueData          AS GoodsName
           , Object_Measure.ValueData        AS MeasureName
           --, zfFormat_BarCode (zc_BarCodePref_Object(), COALESCE (View_GoodsByGoodsKind.Id, Object_Goods.Id)) AS IdBarCode

           , tmpMI.Amount
           , tmpMI.AmountSecond

           , tmpMI.Price
           , tmpMI.Summa

       FROM (SELECT tmpMI.GoodsId
                  , tmpMI.MeasureId
                  , tmpMI.Amount
                  , tmpMI.AmountSecond
                  , CASE WHEN COALESCE (tmpMI.Amount,0) <> 0 THEN tmpMI.Summa / tmpMI.Amount ELSE 0 END ::TFloat AS Price
                  , COALESCE (tmpMI.Summa,0) ::TFloat AS Summa
             FROM
            (SELECT MovementItem.ObjectId                         AS GoodsId
                  , ObjectLink_Goods_Measure.ChildObjectId        AS MeasureId
                  , SUM (MovementItem.Amount)                     AS Amount
                  , SUM (COALESCE (MIFloat_AmountSecond.ValueData, 0)) AS AmountSecond  --шт
                  , SUM (CASE WHEN  ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                 THEN COALESCE( MIFloat_AmountSecond.ValueData,0) * MIFloat_Price.ValueData
                               ELSE COALESCE (MovementItem.Amount,0) * MIFloat_Price.ValueData
                          END) ::TFloat AS Summa
             FROM MovementItem

                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                              ON MIFloat_Price.MovementItemId = MovementItem.Id
                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
                  LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                              ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                  LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                       ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                      AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId     = zc_MI_Master()
               AND MovementItem.isErased   = FALSE
             GROUP BY MovementItem.ObjectId
                    , ObjectLink_Goods_Measure.ChildObjectId

            ) AS tmpMI
            ) AS tmpMI

            LEFT JOIN ObjectLink AS ObjectLink_OrderType_Goods
                                 ON ObjectLink_OrderType_Goods.ChildObjectId = tmpMI.GoodsId
                                AND ObjectLink_OrderType_Goods.DescId = zc_ObjectLink_OrderType_Goods()
            LEFT JOIN ObjectLink AS ObjectLink_OrderType_Unit
                                 ON ObjectLink_OrderType_Unit.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                AND ObjectLink_OrderType_Unit.DescId = zc_ObjectLink_OrderType_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_OrderType_Unit.ChildObjectId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = tmpMI.MeasureId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

--            LEFT JOIN Object_GoodsByGoodsKind_View AS View_GoodsByGoodsKind ON View_GoodsByGoodsKind.GoodsId = Object_Goods.Id
--                                                                           AND View_GoodsByGoodsKind.GoodsKindId = Object_GoodsKind.Id

            LEFT JOIN tmpGoodsQuality ON tmpGoodsQuality.GoodsId = tmpMI.GoodsId

       WHERE tmpMI.Amount <> 0 OR tmpMI.AmountSecond<> 0
       ;
    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.07.21         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_ContractGoods_Print (inMovementId := 388160, inSession:= zfCalc_UserAdmin())
