-- Function: gpSelect_Movement_OrderInternal_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderInternal_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderInternal_Print(
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
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
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
           , MovementDate_OperDatePartner.ValueData     AS OperDatePartner
           , Object_From.ValueData                      AS FromName
           , Object_To.ValueData               		AS ToName
       FROM Movement
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
       WHERE Movement.Id =  inMovementId
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
             (vbOperDate :: Date + tmpMI.StartProductionInDays :: Integer) :: TDateTime AS StartDate
           , (vbOperDate :: Date + (tmpMI.StartProductionInDays + tmpMI.TermProduction) :: Integer) :: TDateTime AS EndDate

           , Object_Unit.ObjectCode          AS UnitCode
           , Object_Unit.ValueData           AS UnitName 

           , ObjectString_Receipt_Code_basis.ValueData AS ReceiptCode_basis
           , Object_Receipt_basis.ValueData            AS ReceiptName_basis

           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.ValueData     AS GoodsGroupName 
           , Object_Goods.ObjectCode  	     AS GoodsCode
           , Object_Goods.ValueData          AS GoodsName
           , Object_GoodsKind.ValueData      AS GoodsKindName
           , Object_Measure.ValueData        AS MeasureName
           , zfFormat_BarCode (zc_BarCodePref_Object(), COALESCE (View_GoodsByGoodsKind.Id, Object_Goods.Id)) AS IdBarCode

           , tmpMI.Amount
           , tmpMI.AmountSecond
           , tmpMI.CuterCount
           , tmpMI.CuterCountSecond
           , tmpMI.TermProduction
             -- 312 ОЛІВ`Є вар., Нашi Ковбаси + М/Б
           , CASE WHEN tmpMI.GoodsId = 7035 AND tmpMI.GoodsKindId <> 8331 THEN NULL
                  WHEN tmpGoodsQuality.GoodsId IS NULL THEN NULL 
                  ELSE (vbOperDate :: Date + (tmpMI.StartProductionInDays + tmpMI.TermProduction + tmpGoodsQuality.Value2) :: Integer) END :: TDateTime AS KlipsaDate

       FROM (SELECT tmpMI.ReceiptId_basis
                  , tmpMI.GoodsId
                  , tmpMI.GoodsKindId
                  , tmpMI.Amount
                  , tmpMI.AmountSecond
                  , tmpMI.CuterCount
                  , tmpMI.CuterCountSecond
                  , tmpMI.StartProductionInDays
                  , tmpMI.TermProduction
             FROM
            (SELECT COALESCE (MILinkObject_ReceiptBasis.ObjectId, 0)       AS ReceiptId_basis
                  , COALESCE (MILinkObject_Goods.ObjectId, 0)              AS GoodsId
                  , COALESCE (MILinkObject_GoodsKindComplete.ObjectId, 0)  AS GoodsKindId
                  , SUM (MovementItem.Amount)                              AS Amount
                  , SUM (COALESCE (MIFloat_AmountSecond.ValueData, 0))     AS AmountSecond
                  , SUM (COALESCE (MIFloat_CuterCount.ValueData, 0))       AS CuterCount
                  , SUM (COALESCE (MIFloat_CuterCountSecond.ValueData, 0)) AS CuterCountSecond
                  , COALESCE (MIFloat_StartProductionInDays.ValueData, 0)  AS StartProductionInDays
                  , COALESCE (MIFloat_TermProduction.ValueData, 0)         AS TermProduction
             FROM MovementItem
                  LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                              ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                  LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                              ON MIFloat_CuterCount.MovementItemId = MovementItem.Id 
                                             AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()
                  LEFT JOIN MovementItemFloat AS MIFloat_CuterCountSecond
                                              ON MIFloat_CuterCountSecond.MovementItemId = MovementItem.Id 
                                             AND MIFloat_CuterCountSecond.DescId = zc_MIFloat_CuterCountSecond()
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                   ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                   ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_ReceiptBasis
                                                   ON MILinkObject_ReceiptBasis.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_ReceiptBasis.DescId = zc_MILinkObject_ReceiptBasis()
                  LEFT JOIN MovementItemFloat AS MIFloat_TermProduction
                                              ON MIFloat_TermProduction.MovementItemId = MovementItem.Id 
                                             AND MIFloat_TermProduction.DescId = zc_MIFloat_TermProduction()
                  LEFT JOIN MovementItemFloat AS MIFloat_StartProductionInDays
                                              ON MIFloat_StartProductionInDays.MovementItemId = MovementItem.Id 
                                             AND MIFloat_StartProductionInDays.DescId = zc_MIFloat_StartProductionInDays()
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId     = zc_MI_Master()
               AND MovementItem.isErased   = FALSE
             GROUP BY MILinkObject_ReceiptBasis.ObjectId
                    , MILinkObject_Goods.ObjectId
                    , MILinkObject_GoodsKindComplete.ObjectId
                    , MIFloat_StartProductionInDays.ValueData
                    , MIFloat_TermProduction.ValueData
            ) AS tmpMI
            ) AS tmpMI

            LEFT JOIN ObjectLink AS ObjectLink_OrderType_Goods
                                 ON ObjectLink_OrderType_Goods.ChildObjectId = tmpMI.GoodsId
                                AND ObjectLink_OrderType_Goods.DescId = zc_ObjectLink_OrderType_Goods()
            LEFT JOIN ObjectLink AS ObjectLink_OrderType_Unit
                                 ON ObjectLink_OrderType_Unit.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                AND ObjectLink_OrderType_Unit.DescId = zc_ObjectLink_OrderType_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_OrderType_Unit.ChildObjectId

            LEFT JOIN Object AS Object_Receipt_basis ON Object_Receipt_basis.Id = tmpMI.ReceiptId_basis
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code_basis
                                   ON ObjectString_Receipt_Code_basis.ObjectId = Object_Receipt_basis.Id
                                  AND ObjectString_Receipt_Code_basis.DescId = zc_ObjectString_Receipt_Code()

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN Object_GoodsByGoodsKind_View AS View_GoodsByGoodsKind ON View_GoodsByGoodsKind.GoodsId = Object_Goods.Id
                                                                           AND View_GoodsByGoodsKind.GoodsKindId = Object_GoodsKind.Id

            LEFT JOIN tmpGoodsQuality ON tmpGoodsQuality.GoodsId = tmpMI.GoodsId

       WHERE tmpMI.Amount <> 0 OR tmpMI.AmountSecond <> 0
       ;
    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_OrderInternal_Print (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.06.15                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderInternal_Print (inMovementId := 388160, inSession:= zfCalc_UserAdmin())
