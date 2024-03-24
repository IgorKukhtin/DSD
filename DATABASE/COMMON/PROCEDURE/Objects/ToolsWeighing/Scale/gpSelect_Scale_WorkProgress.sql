-- Function: gpSelect_Scale_WorkProgress()

DROP FUNCTION IF EXISTS gpSelect_Scale_WorkProgress (TDateTime, Integer, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpSelect_Scale_WorkProgress (TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Scale_WorkProgress (TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Scale_WorkProgress(
    IN inOperDate              TDateTime,
    IN inMovementItemId        Integer,
    IN inGoodsCode             Integer,
    IN inUnitId                Integer,
    IN inDocumentKindId        Integer,
    IN inSession               TVarChar      -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, MovementItemId Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , ReceiptId Integer, ReceiptCode TVarChar, ReceiptName TVarChar
             , GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar
             , GoodsKindId_Complete Integer, GoodsKindCode_Complete Integer, GoodsKindName_Complete TVarChar
             , MeasureId Integer, MeasureCode Integer, MeasureName TVarChar
               -- Кол-во факт
             , Amount TFloat
               -- Куттеров факт
             , CuterCount TFloat

               -- вес сырой - Закрыт
             , RealWeight TFloat
               -- вес куттер - Закрыт
             , CuterWeight TFloat
               -- вес сырой - Не закрыт
             , RealWeight_current TFloat
               -- вес куттер - Не закрыт
             , CuterWeight_current TFloat
               -- вес сырой - Итого
             , RealWeight_total TFloat
               -- вес куттер - Итого
             , CuterWeight_total TFloat
               -- вес сырой - разница
             , Real_diff TFloat
               -- вес куттер - разница
             , Cuter_diff TFloat

             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , MovementInfo TVarChar
             , DocumentKindId Integer, DocumentKindName TVarChar
             , isErased Boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbGoodsId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);


   -- !!!временно будет по ВСЕМ товарам
   inGoodsCode:= 0;

   -- Определяется Товар
   IF COALESCE (inMovementItemId, 0) = 0 AND inGoodsCode <> 0
   THEN
        vbGoodsId:= COALESCE ((SELECT Object.Id FROM Object WHERE inGoodsCode > 0 AND Object.ObjectCode = inGoodsCode AND Object.DescId = zc_Object_Goods() AND Object.isErased = FALSE), 0);
   ELSE vbGoodsId:= 0;
   END IF;

   -- Результат
   RETURN QUERY
             WITH tmpMI AS (SELECT Movement.Id AS MovementId
                                 , Movement.StatusId
                                 , Movement.OperDate
                                 , Movement.InvNumber
                                 , MILinkObject_Receipt.ObjectId    AS ReceiptId
                                 , MILinkObject_GoodsKind.ObjectId  AS GoodsKindId
                                 , MILO_GoodsKindComplete.ObjectId  AS GoodsKindId_Complete
                                 , MovementItem.Id                  AS MovementItemId
                                 , MovementItem.ObjectId            AS GoodsId
                                 , MovementItem.Amount
                                 , MIFloat_CuterCount.ValueData     AS CuterCount
                                 , COALESCE (MIFloat_RealWeight.ValueData, 0)    AS RealWeight
                                 , COALESCE (MIFloat_CuterWeight.ValueData, 0)   AS CuterWeight
                                 , COALESCE (MIFloat_RealWeightShp.ValueData, 0) AS RealDelicShp
                                 , COALESCE (MIFloat_RealWeightMsg.ValueData, 0) AS RealDelicMsg
                                 , Object_DocumentKind.Id           AS DocumentKindId
                                 , Object_DocumentKind.ValueData    AS DocumentKindName
                            FROM Movement
                                 INNER JOIN MovementLinkObject AS MLO_From
                                                               ON MLO_From.MovementId = Movement.Id
                                                              AND MLO_From.DescId     = zc_MovementLinkObject_From()
                                                              AND MLO_From.ObjectId   = inUnitId
                                 INNER JOIN MovementLinkObject AS MLO_To
                                                               ON MLO_To.MovementId = Movement.Id
                                                              AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                                              AND MLO_To.ObjectId   = inUnitId
                                 LEFT JOIN MovementLinkObject AS MLO_DocumentKind
                                                              ON MLO_DocumentKind.MovementId = Movement.Id
                                                             AND MLO_DocumentKind.DescId     = zc_MovementLinkObject_DocumentKind()
                                 LEFT JOIN Object AS Object_DocumentKind ON Object_DocumentKind.Id = MLO_DocumentKind.ObjectId

                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                                        AND MovementItem.isErased   = FALSE
                                                        AND (MovementItem.ObjectId  = vbGoodsId OR vbGoodsId = 0 OR inMovementItemId <> 0)
                                                        AND (MovementItem.Id        = inMovementItemId OR inMovementItemId = 0)
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Receipt
                                                                  ON MILinkObject_Receipt.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_Receipt.DescId = zc_MILinkObject_Receipt()
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                  ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                                                 AND MILinkObject_GoodsKind.ObjectId       = zc_GoodsKind_WorkProgress()
                                 LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                                                  ON MILO_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                                 AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                                 LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                                             ON MIFloat_CuterCount.MovementItemId = MovementItem.Id
                                                            AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()
                                 LEFT JOIN MovementItemFloat AS MIFloat_RealWeight
                                                             ON MIFloat_RealWeight.MovementItemId = MovementItem.Id
                                                            AND MIFloat_RealWeight.DescId         = zc_MIFloat_RealWeight()
                                 LEFT JOIN MovementItemFloat AS MIFloat_CuterWeight
                                                             ON MIFloat_CuterWeight.MovementItemId = MovementItem.Id
                                                            AND MIFloat_CuterWeight.DescId         = zc_MIFloat_CuterWeight()
                                 LEFT JOIN MovementItemFloat AS MIFloat_RealWeightShp
                                                             ON MIFloat_RealWeightShp.MovementItemId = MovementItem.Id
                                                            AND MIFloat_RealWeightShp.DescId         = zc_MIFloat_RealWeightShp()
                                 LEFT JOIN MovementItemFloat AS MIFloat_RealWeightMsg
                                                             ON MIFloat_RealWeightMsg.MovementItemId = MovementItem.Id
                                                            AND MIFloat_RealWeightMsg.DescId         = zc_MIFloat_RealWeightMsg()

                            -- ЦЕХ деликатесов
                            WHERE Movement.OperDate BETWEEN inOperDate - CASE WHEN inDocumentKindId IN (zc_Enum_DocumentKind_LakTo(), zc_Enum_DocumentKind_LakFrom())
                                                                                   THEN INTERVAL '100 DAY' 
                                                                              WHEN inUnitId = 8448
                                                                                   THEN INTERVAL '50 DAY'
                                                                              ELSE INTERVAL '10 DAY'
                                                                         END :: INTERVAL AND inOperDate
                              AND Movement.DescId   = zc_Movement_ProductionUnion()
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                           )
         -- Не закрыт
       , tmpMI_Weighing AS (SELECT tmpMI.MovementItemId
                                 , SUM (CASE WHEN MLO_DocumentKind.ObjectId = zc_Enum_DocumentKind_CuterWeight()
                                                  THEN MovementItem.Amount
                                             ELSE 0
                                        END) :: TFloat AS CuterWeight
                                 , SUM (CASE WHEN MLO_DocumentKind.ObjectId = zc_Enum_DocumentKind_RealWeight()
                                                  THEN MovementItem.Amount
                                             ELSE 0
                                        END) :: TFloat AS RealWeight
                                 , SUM (CASE WHEN MLO_DocumentKind.ObjectId = zc_Enum_DocumentKind_RealDelicShp()
                                                  THEN MovementItem.Amount
                                             ELSE 0
                                        END) :: TFloat AS RealDelicShp
                                 , SUM (CASE WHEN MLO_DocumentKind.ObjectId = zc_Enum_DocumentKind_RealDelicMsg()
                                                  THEN MovementItem.Amount
                                             ELSE 0
                                        END) :: TFloat AS RealDelicMsg
                            FROM tmpMI
                                 INNER JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                              ON MIFloat_MovementItemId.ValueData = tmpMI.MovementItemId
                                                             AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId()
                                 INNER JOIN MovementItem ON MovementItem.Id         = MIFloat_MovementItemId.MovementItemId
                                                        AND MovementItem.isErased   = FALSE
                                 INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                    AND Movement.DescId   = zc_Movement_WeighingProduction()
                                                    AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                 LEFT JOIN MovementLinkObject AS MLO_DocumentKind
                                                              ON MLO_DocumentKind.MovementId = Movement.Id
                                                             AND MLO_DocumentKind.DescId     = zc_MovementLinkObject_DocumentKind()
                            GROUP BY tmpMI.MovementItemId
                           )
       -- Результат
       SELECT tmpMI.MovementId
            , tmpMI.MovementItemId
            , tmpMI.InvNumber
            , tmpMI.OperDate
            , Object_Status.ObjectCode            AS StatusCode
            , Object_Status.ValueData             AS StatusName
            , Object_Receipt.Id                   AS ReceiptId
            , ObjectString_Receipt_Code.ValueData AS ReceiptCode
            , Object_Receipt.ValueData            AS ReceiptName
            , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , Object_Goods.Id             AS GoodsId
            , Object_Goods.ObjectCode     AS GoodsCode
            , Object_Goods.ValueData      AS GoodsName
            , Object_GoodsKind.Id         AS GoodsKindId
            , Object_GoodsKind.ObjectCode AS GoodsKindCode
            , Object_GoodsKind.ValueData  AS GoodsKindName
            , Object_GoodsKindComplete.Id         AS GoodsKindId_Complete
            , Object_GoodsKindComplete.ObjectCode AS GoodsKindCode_Complete
            , Object_GoodsKindComplete.ValueData  AS GoodsKindName_Complete
            , Object_Measure.Id           AS MeasureId
            , Object_Measure.ObjectCode   AS MeasureCode
            , Object_Measure.ValueData    AS MeasureName
              -- Кол-во факт
            , tmpMI.Amount
              -- Куттеров факт
            , tmpMI.CuterCount
              -- вес сырой - Закрыт
            , tmpMI.RealWeight  :: TFloat AS RealWeight
              -- вес куттер - Закрыт
            , tmpMI.CuterWeight :: TFloat AS CuterWeight
              -- вес сырой - Не закрыт
            , tmpMI_Weighing.RealWeight   AS RealWeight_current
              -- вес куттер - Не закрыт
            , tmpMI_Weighing.CuterWeight  AS CuterWeight_current
              -- вес сырой - Итого
            , (tmpMI.RealWeight  + COALESCE (tmpMI_Weighing.RealWeight, 0))                 :: TFloat AS CuterWeight_total
              -- вес куттер - Итого
            , (tmpMI.CuterWeight + COALESCE (tmpMI_Weighing.CuterWeight, 0))                :: TFloat AS CuterWeight_total
              -- вес сырой - разница
            , (-1 * tmpMI.Amount + tmpMI.RealWeight  + COALESCE (tmpMI_Weighing.RealWeight, 0))  :: TFloat AS Real_diff
              -- вес куттер - разница
            , (-1 * tmpMI.Amount + tmpMI.CuterWeight + COALESCE (tmpMI_Weighing.CuterWeight, 0)) :: TFloat AS Amount_diff

            , Object_Insert.ValueData             AS InsertName
            , Object_Update.ValueData             AS UpdateName
            , MIDate_Insert.ValueData             AS InsertDate
            , MIDate_Update.ValueData             AS UpdateDate

            , ('№ <' || tmpMI.InvNumber || '>'
               -- || ' от <' || DATE (tmpMI.OperDate) || '>'
            || ' партия=<' || DATE (tmpMI.OperDate) || '>'
            || ' вид=<' || COALESCE (Object_GoodsKindComplete.ValueData, '') || '>'
            || ' кут.=<' || zfConvert_FloatToString (tmpMI.CuterCount) || '>'
            || ' кол.=<' || zfConvert_FloatToString (tmpMI.Amount) || '>'
            || CASE WHEN inDocumentKindId IN (zc_Enum_DocumentKind_LakTo(), zc_Enum_DocumentKind_LakFrom())
                    THEN ''
                    ELSE
               ' итого взвеш.=<' || CASE -- вес куттер - Итого
                                         WHEN inDocumentKindId = zc_Enum_DocumentKind_CuterWeight()
                                              THEN zfConvert_FloatToString (tmpMI.CuterWeight + COALESCE (tmpMI_Weighing.CuterWeight, 0)) || '>'
                                         -- вес сырой - Итого
                                         WHEN inDocumentKindId = zc_Enum_DocumentKind_RealWeight()
                                              THEN zfConvert_FloatToString (tmpMI.RealWeight + COALESCE (tmpMI_Weighing.RealWeight, 0)) || '>'
                                         -- вес п/ф факт после шприцевания - Итого
                                         WHEN inDocumentKindId = zc_Enum_DocumentKind_RealDelicShp()
                                              THEN zfConvert_FloatToString (tmpMI.RealDelicShp + COALESCE (tmpMI_Weighing.RealDelicShp, 0)) || '>'
                                         -- вес п/ф факт после массажера - Итого
                                         WHEN inDocumentKindId = zc_Enum_DocumentKind_RealDelicMsg()
                                              THEN zfConvert_FloatToString (tmpMI.RealDelicMsg + COALESCE (tmpMI_Weighing.RealDelicMsg, 0)) || '>'
                                         ELSE '?'
                                    END
            || ' разница=<' || CASE -- вес куттер - разница
                                    WHEN inDocumentKindId = zc_Enum_DocumentKind_CuterWeight()
                                         THEN zfConvert_FloatToString (-1 * tmpMI.Amount + tmpMI.CuterWeight + COALESCE (tmpMI_Weighing.CuterWeight, 0)) || '>'
                                    -- вес сырой - разница
                                    WHEN inDocumentKindId = zc_Enum_DocumentKind_RealWeight()
                                         THEN zfConvert_FloatToString (-1 * tmpMI.Amount + tmpMI.RealWeight  + COALESCE (tmpMI_Weighing.RealWeight, 0)) || '>'
                                    -- вес п/ф факт после шприцевания - разница
                                    WHEN inDocumentKindId = zc_Enum_DocumentKind_RealDelicShp()
                                         THEN zfConvert_FloatToString (-1 * tmpMI.Amount + tmpMI.RealDelicShp  + COALESCE (tmpMI_Weighing.RealDelicShp, 0)) || '>'
                                    -- вес п/ф факт после массажера - разница
                                    WHEN inDocumentKindId = zc_Enum_DocumentKind_RealDelicMsg()
                                         THEN zfConvert_FloatToString (-1 * tmpMI.Amount + tmpMI.RealDelicMsg  + COALESCE (tmpMI_Weighing.RealDelicMsg, 0)) || '>'
                                    ELSE '?'
                               END
               END
              ) :: TVarChar AS MovementInfo

            , tmpMI.DocumentKindId
            , tmpMI.DocumentKindName

            , FALSE AS isErased

       FROM tmpMI
            LEFT JOIN tmpMI_Weighing ON tmpMI_Weighing.MovementItemId = tmpMI.MovementItemId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpMI.StatusId
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId
            LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = tmpMI.GoodsKindId_Complete
            LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = tmpMI.ReceiptId
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                   ON ObjectString_Receipt_Code.ObjectId = Object_Receipt.Id
                                  AND ObjectString_Receipt_Code.DescId   = zc_ObjectString_Receipt_Code()

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpMI.GoodsId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

             LEFT JOIN MovementItemDate AS MIDate_Insert
                                        ON MIDate_Insert.MovementItemId = tmpMI.MovementItemId
                                       AND MIDate_Insert.DescId = zc_MIDate_Insert()
             LEFT JOIN MovementItemDate AS MIDate_Update
                                        ON MIDate_Update.MovementItemId = tmpMI.MovementItemId
                                       AND MIDate_Update.DescId = zc_MIDate_Update()

             LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                              ON MILO_Insert.MovementItemId = tmpMI.MovementItemId
                                             AND MILO_Insert.DescId = zc_MILinkObject_Insert()
             LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId
             LEFT JOIN MovementItemLinkObject AS MILO_Update
                                              ON MILO_Update.MovementItemId = tmpMI.MovementItemId
                                             AND MILO_Update.DescId = zc_MILinkObject_Update()
             LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILO_Update.ObjectId

       WHERE tmpMI.GoodsKindId_Complete IN (zc_GoodsKind_Basis(), 559324) -- штучний
          OR inDocumentKindId NOT IN (zc_Enum_DocumentKind_LakTo(), zc_Enum_DocumentKind_LakFrom())
       ORDER BY Object_Goods.ValueData

              , Object_GoodsKindComplete.ValueData
              , tmpMI.OperDate DESC
              , tmpMI.InvNumber DESC
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 15.11.15                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Scale_WorkProgress (inOperDate:= CURRENT_DATE, inMovementItemId:= 0, inGoodsCode:= 0, inUnitId:= 8447, inDocumentKindId:= 0, inSession:=zfCalc_UserAdmin())
