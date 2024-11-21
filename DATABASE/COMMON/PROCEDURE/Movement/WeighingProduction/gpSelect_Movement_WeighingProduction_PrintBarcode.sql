-- Function: gpSelect_Movement_WeighingProduction_PrintBarcode (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Movement_WeighingProduction_PrintBarcode (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_WeighingProduction_PrintBarcode(
    IN inMovementId        Integer   ,   -- ключ Документа
    IN inId                Integer   ,   -- строка
    IN inSession           TVarChar      -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE Cursor1 refcursor;
    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbStoreKeeperName TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_wms_Movement_WeighingProduction());
     vbUserId:= lpGetUserBySession (inSession);

     -- параметры из документа
     SELECT Movement.DescId
          , Movement.StatusId
          , Object_User.ValueData  :: TVarChar AS StoreKeeperName -- кладовщик
            INTO vbDescId, vbStatusId, vbStoreKeeperName
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                       ON MovementLinkObject_User.MovementId = Movement.Id
                                      AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
          LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId
     WHERE Movement.Id = inMovementId;

    -- очень важная проверка
    IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete()
    THEN
        IF vbStatusId = zc_Enum_Status_Erased()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
      --IF vbStatusId = zc_Enum_Status_UnComplete()
      --THEN
      --    RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
      --END IF;
    END IF;

     OPEN Cursor1 FOR

       -- Результат
    WITH
     tmp1 AS (SELECT MIFloat_MovementItemId.ValueData :: Integer AS MovementItemId FROM MovementItemFloat AS MIFloat_MovementItemId WHERE MIFloat_MovementItemId.MovementItemId = inId AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId())
   , tmp2 AS (SELECT * FROM MovementItem WHERE MovementItem.Id IN (SELECT DISTINCT tmp1.MovementItemId FROM tmp1))
   , tmp3 AS (SELECT * FROM Movement WHERE Movement.Id IN (SELECT DISTINCT tmp2.MovementId FROM tmp2)
                                       AND Movement.DescId = zc_Movement_ProductionUnion()
             )


    -- для 1-ой строки
  , tmpMI AS (SELECT MovementItem.Id                           AS MovementItemId
                   , MovementItem.ObjectId                     AS GoodsId
                   , MILinkObject_GoodsKind.ObjectId           AS GoodsKindId
                   , COALESCE (Movement_Partion.OperDate, MIDate_PartionGoods.ValueData) :: TDateTime AS PartionGoodsDate
                   , MIString_PartionGoods.ValueData           AS PartionGoods
                   , MILinkObject_PartionGoods.ObjectId        AS PartionGoodsId
                   , MovementItem.Amount                       AS Amount
                   , COALESCE (MIFloat_Count.ValueData, 0)     AS Count
                   , COALESCE (MIFloat_CountPack.ValueData, 0) AS CountPack
                   , COALESCE (MIFloat_HeadCount.ValueData, 0) AS HeadCount

                   , COALESCE (MIFloat_CountSkewer1.ValueData, 0)+ COALESCE (MIFloat_CountSkewer2.ValueData, 0)   AS CountSkewer

                   , MIFloat_CountSkewer1.ValueData  AS CountSkewer1
                   , MIFloat_WeightSkewer1.ValueData AS WeightSkewer1
                   , MIFloat_CountSkewer2.ValueData  AS CountSkewer2
                   , MIFloat_WeightSkewer2.ValueData AS WeightSkewer2
                   
                   --
                   , MIFloat_WeightTare.ValueData    AS WeightTare
                   , MIString_KVK.ValueData          AS KVK
                   , MILinkObject_PersonalKVK.ObjectId AS PersonalKVKId
                   
                   , MIDate_Insert.ValueData           AS InsertDate

              FROM MovementItem
                   LEFT JOIN MovementItemFloat AS MIFloat_Count
                                               ON MIFloat_Count.MovementItemId = MovementItem.Id
                                              AND MIFloat_Count.DescId = zc_MIFloat_Count()
                   LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                               ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                              AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                   LEFT JOIN MovementItemFloat AS MIFloat_CountPack
                                               ON MIFloat_CountPack.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountPack.DescId = zc_MIFloat_CountPack()

                   LEFT JOIN MovementItemDate AS MIDate_Insert
                                              ON MIDate_Insert.MovementItemId = MovementItem.Id
                                             AND MIDate_Insert.DescId         = zc_MIDate_Insert()

                   LEFT JOIN MovementItemFloat AS MIFloat_WeightTare
                                               ON MIFloat_WeightTare.MovementItemId = MovementItem.Id
                                              AND MIFloat_WeightTare.DescId = zc_MIFloat_WeightTare()

                   LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                              ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                             AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                   LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                               AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

                   LEFT JOIN MovementItemString AS MIString_KVK
                                                ON MIString_KVK.MovementItemId = MovementItem.Id
                                               AND MIString_KVK.DescId = zc_MIString_KVK()

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionGoods
                                                    ON MILinkObject_PartionGoods.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_PartionGoods.DescId = zc_MILinkObject_PartionGoods()

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_PersonalKVK
                                                    ON MILinkObject_PersonalKVK.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_PersonalKVK.DescId = zc_MILinkObject_PersonalKVK()
                   --LEFT JOIN Object AS Object_PersonalKVK ON Object_PersonalKVK.Id = MILinkObject_PersonalKVK.ObjectId

                   LEFT JOIN MovementItemFloat AS MIFloat_CountSkewer1
                                               ON MIFloat_CountSkewer1.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountSkewer1.DescId = zc_MIFloat_CountSkewer1()
                   LEFT JOIN MovementItemFloat AS MIFloat_CountSkewer2
                                               ON MIFloat_CountSkewer2.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountSkewer2.DescId = zc_MIFloat_CountSkewer2()

                   LEFT JOIN MovementItemFloat AS MIFloat_WeightSkewer1
                                               ON MIFloat_WeightSkewer1.MovementItemId = MovementItem.Id
                                              AND MIFloat_WeightSkewer1.DescId = zc_MIFloat_WeightSkewer1()
                   LEFT JOIN MovementItemFloat AS MIFloat_WeightSkewer2
                                               ON MIFloat_WeightSkewer2.MovementItemId = MovementItem.Id
                                              AND MIFloat_WeightSkewer2.DescId = zc_MIFloat_WeightSkewer2()

                   LEFT JOIN tmp3 AS Movement_Partion ON Movement_Partion.DescId = zc_Movement_ProductionUnion()

              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.Id         = inId
             )

       --результат
       SELECT
             Object_Goods.Id                    AS GoodsId
           , zfFormat_BarCode (zc_BarCodePref_Object(), COALESCE (View_GoodsByGoodsKind.Id, Object_Goods.Id)) AS IdBarCode
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , Object_Measure.ValueData           AS MeasureName
           , tmpMI.Amount
           , tmpMI.Count
           , tmpMI.CountPack
           , tmpMI.HeadCount
           , tmpMI.CountSkewer
           , tmpMI.CountSkewer1
           , tmpMI.WeightSkewer1
           , tmpMI.CountSkewer2
           , tmpMI.WeightSkewer2

           , CAST ((tmpMI.Amount * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END )) AS TFloat) AS Amount_Weight
           , CASE WHEN COALESCE (tmpMI.Count, 0) <> 0
                  THEN (tmpMI.Amount * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END ) / tmpMI.Count)
                  ELSE 0
             END AS WeightOne     -- "вес 1 ед." = вес / кол-во батонов
           , tmpMI.WeightTare
            , tmpMI.PartionGoodsDate
           , tmpMI.PartionGoods
           , zfConvert_DateToString (CURRENT_DATE) AS PartionGoodsDate_obv_str
           , zfConvert_DateToString (tmpMI.PartionGoodsDate) AS PartionGoodsDate_str
           , Object_GoodsKind.Id                AS GoodsKindId
           , Object_GoodsKind.ValueData         AS GoodsKindName

           , Object_PartionGoods.Id             AS PartionGoodsId
           , Object_PartionGoods.ValueData      AS PartionGoodsName
           , ObjectDate_Value.ValueData         AS PartionGoodsOperDate

           , vbStoreKeeperName  :: TVarChar     AS StoreKeeperName
           , tmpMI.KVK          :: TVarChar     AS KVK
           , Object_PersonalKVK.ValueData       AS PersonalKVKName
           , tmpMI.InsertDate

       FROM tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_PersonalKVK ON Object_PersonalKVK.Id = tmpMI.PersonalKVKId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpMI.PartionGoodsId

            LEFT JOIN ObjectDate AS ObjectDate_Value
                                 ON ObjectDate_Value.ObjectId = Object_PartionGoods.Id                    -- дата
                                AND ObjectDate_Value.DescId = zc_ObjectDate_PartionGoods_Value()

            LEFT JOIN Object_GoodsByGoodsKind_View AS View_GoodsByGoodsKind ON View_GoodsByGoodsKind.GoodsId = Object_Goods.Id
                                                                           AND View_GoodsByGoodsKind.GoodsKindId = Object_GoodsKind.Id
        ;

    RETURN NEXT Cursor1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
03.02.20          *
*/

-- тест
-- select * from gpSelect_Movement_WeighingProduction_PrintBarCode(inMovementId := 15745229 , inId := 162901040 ,  inSession := '5');
--FETCH ALL "<unnamed portal 12>";
