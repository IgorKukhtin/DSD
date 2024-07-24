-- Function: gpSelect_Movement_Send_Print()

-- DROP FUNCTION IF EXISTS gpSelect_Movement_Send_Print (Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpSelect_Movement_Send_Print (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Send_Print (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Send_Print(
    IN inMovementId                 Integer  , -- ключ Документа
    IN inMovementId_Weighing        Integer  , -- ключ Документа взвешивания
    IN inisItem                     Boolean  , -- не сворачивать по MovementItem да / нет
    IN inSession                    TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbIsProductionOut Boolean;
    DECLARE vbIsInventory Boolean;
    DECLARE vbIsWeighing Boolean;

    DECLARE vbStoreKeeperName TVarChar;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);


     -- расчет, временно захардкодил - только если Обвалка
     vbIsWeighing:= EXISTS (SELECT 1
                            FROM Movement
                                 INNER JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = inMovementId AND MLO_From.DescId = zc_MovementLinkObject_From()
                                 INNER JOIN lfSelect_Object_Unit_byGroup (8439) AS lfSelectFrom ON lfSelectFrom.UnitId = MLO_From.ObjectId -- Участок мясного сырья
                                 INNER JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = inMovementId AND MLO_To.DescId = zc_MovementLinkObject_To()
                                 INNER JOIN lfSelect_Object_Unit_byGroup (8439) AS lfSelectTo ON lfSelectTo.UnitId = MLO_To.ObjectId -- Участок мясного сырья
                            WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_ProductionUnion()
                           );
     -- расчет, временно захардкодил
     vbIsProductionOut:= (EXISTS (SELECT MovementId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_To() AND ObjectId IN (8447, 8448, 8449)) -- ЦЕХ колбасный + ЦЕХ деликатесов + ЦЕХ с/к
                       OR (EXISTS (SELECT 1 FROM MovementBoolean WHERE MovementId = inMovementId_Weighing AND DescId = zc_MovementBoolean_isIncome() AND ValueData = FALSE)
                           AND vbIsWeighing = TRUE)
                       OR (EXISTS (SELECT 1 FROM MovementLinkObject AS MLO_DocumentKind WHERE MLO_DocumentKind.MovementId = inMovementId AND MLO_DocumentKind.DescId = zc_MovementLinkObject_DocumentKind() AND MLO_DocumentKind.ObjectId = zc_Enum_DocumentKind_PackDiff()))
                         )
                     AND EXISTS (SELECT Id FROM Movement WHERE Id = inMovementId AND DescId = zc_Movement_ProductionUnion());
     -- расчет, временно захардкодил
     vbIsInventory:= EXISTS (SELECT Id FROM Movement WHERE Id = inMovementId AND DescId = zc_Movement_Inventory());


     -- параметры из Взвешивания
     vbStoreKeeperName:= (SELECT Object_User.ValueData
                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                                            ON MovementLinkObject_User.MovementId = Movement.Id
                                                           AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
                               LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId
                          WHERE Movement.ParentId = inMovementId AND Movement.DescId IN (zc_Movement_WeighingPartner(), zc_Movement_WeighingProduction())
                            AND Movement.StatusId = zc_Enum_Status_Complete()
                          LIMIT 1
                         );


    OPEN Cursor1 FOR
       WITH tmpUnit AS (SELECT UnitId FROM lfSelect_Object_Unit_byGroup (8446) AS lfSelect_Object_Unit_byGroup) -- ЦЕХ колбаса+дел-сы
       SELECT
             Movement.Id                                        AS Id
           , (Movement.InvNumber || CASE WHEN vbIsWeighing = TRUE THEN '/' || (MFloat_WeighingNumber.ValueData :: Integer) :: TVarChar ELSE '' END) :: TVarChar AS InvNumber
           , Movement.OperDate                                  AS OperDate
           , Object_Status.ObjectCode                           AS StatusCode
           , Object_Status.ValueData                            AS StatusName
           , MovementFloat_TotalCount.ValueData                 AS TotalCount
           , Object_From.Id                                     AS FromId
           , Object_From.ValueData                              AS FromName
           , Object_To.Id                                       AS ToId
           , Object_To.ValueData                                AS ToName
           , CASE WHEN vbIsInventory = TRUE
                       THEN 'инвентаризации'
                  WHEN vbIsProductionOut = TRUE
                       THEN 'производства (расход)'
                  WHEN Movement.DescId = zc_Movement_ProductionUnion()
                       THEN 'производства (приход)'
                  WHEN Movement.DescId = zc_Movement_Send()
                       THEN 'перемещения'
             END AS Movement_info

           , CASE WHEN Movement.DescId = zc_Movement_Send() AND tmpUnit.UnitId IS NULL
                       THEN vbStoreKeeperName
                  WHEN Movement.DescId = zc_Movement_Send()
                       THEN ''
                  ELSE vbStoreKeeperName
             END :: TVarChar AS StoreKeeperName_from -- кладовщик
           , CASE WHEN Movement.DescId = zc_Movement_Send() AND tmpUnit.UnitId > 0
                       THEN vbStoreKeeperName
                  ELSE ''
             END :: TVarChar AS StoreKeeperName_to -- кладовщик

           , (COALESCE (Object_SubjectDoc.ValueData, '') || CASE WHEN MovementBoolean_isRePack.ValueData = TRUE THEN 'ПЕРЕПАК'  ELSE '' END)  :: TVarChar AS SubjectDocName

           , Object_PersonalGroup.ValueData                     AS PersonalGroupName
           , Object_Unit.ValueData                              AS UnitName_PersonalGroup

           , CASE WHEN TRIM (MovementString_Comment.ValueData) <> '' THEN ' / ' || MovementString_Comment.ValueData ELSE '' END :: TVarChar AS Comment

       FROM Movement
            LEFT JOIN MovementFloat AS MFloat_WeighingNumber
                                    ON MFloat_WeighingNumber.MovementId = inMovementId_Weighing
                                   AND MFloat_WeighingNumber.DescId = zc_MovementFloat_WeighingNumber()
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN tmpUnit ON tmpUnit.UnitId = Object_From.Id

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_SubjectDoc
                                         ON MovementLinkObject_SubjectDoc.MovementId = Movement.Id
                                        AND MovementLinkObject_SubjectDoc.DescId = zc_MovementLinkObject_SubjectDoc()
            LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = MovementLinkObject_SubjectDoc.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalGroup
                                         ON MovementLinkObject_PersonalGroup.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalGroup.DescId = zc_MovementLinkObject_PersonalGroup()
            LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = MovementLinkObject_PersonalGroup.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_PersonalGroup_Unit
                                 ON ObjectLink_PersonalGroup_Unit.ObjectId = Object_PersonalGroup.Id
                                AND ObjectLink_PersonalGroup_Unit.DescId = zc_ObjectLink_PersonalGroup_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_PersonalGroup_Unit.ChildObjectId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId =  Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementBoolean AS MovementBoolean_isRePack
                                      ON MovementBoolean_isRePack.MovementId =  Movement.Id
                                     AND MovementBoolean_isRePack.DescId = zc_MovementBoolean_isRePack()

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId IN (zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_Inventory())
      ;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
    WITH
    tmpMI AS (SELECT MAX (MovementItem.Id)              AS MovementItemId
                   , MovementItem.ObjectId              AS GoodsId
                   , MILinkObject_GoodsKind.ObjectId    AS GoodsKindId
                   , MIDate_PartionGoods.ValueData      AS PartionGoodsDate
                   , MIString_PartionGoods.ValueData    AS PartionGoods
                   , MIString_PartNumber.ValueData      AS PartNumber
                   , MILinkObject_Asset.ObjectId        AS AssetId
                   , MILinkObject_Asset_two.ObjectId    AS AssetId_two
                   , MILinkObject_PartionGoods.ObjectId AS PartionGoodsId
                   , SUM (MovementItem.Amount)          AS Amount
                   , SUM (COALESCE (MIFloat_Count.ValueData, 0))     AS Count
                   , SUM (COALESCE (MIFloat_CountPack.ValueData, 0)) AS CountPack
                   , SUM (COALESCE (MIFloat_HeadCount.ValueData, 0)) AS HeadCount
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

                   LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                              ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                             AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                   LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                               AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                   LEFT JOIN MovementItemString AS MIString_PartNumber
                                                ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                               AND MIString_PartNumber.DescId = zc_MIString_PartNumber()

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                    ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset_two
                                                    ON MILinkObject_Asset_two.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Asset_two.DescId = zc_MILinkObject_Asset_two()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionGoods
                                                    ON MILinkObject_PartionGoods.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_PartionGoods.DescId = zc_MILinkObject_PartionGoods()

              WHERE MovementItem.MovementId = CASE WHEN vbIsWeighing = TRUE THEN inMovementId_Weighing ELSE inMovementId END
                AND MovementItem.DescId     = CASE WHEN vbIsProductionOut = TRUE AND  vbIsWeighing = FALSE THEN zc_MI_Child() ELSE zc_MI_Master() END
                AND MovementItem.isErased   = FALSE
                AND MovementItem.Amount <> 0
                AND inisItem = FALSE
              GROUP BY MovementItem.ObjectId
                     , MILinkObject_GoodsKind.ObjectId
                     , MIDate_PartionGoods.ValueData
                     , MIString_PartionGoods.ValueData
                     , MIString_PartNumber.ValueData
                     , MILinkObject_Asset.ObjectId
                     , MILinkObject_Asset_two.ObjectId
                     , MILinkObject_PartionGoods.ObjectId
             UNION ALL
              SELECT MovementItem.Id                    AS MovementItemId
                   , MovementItem.ObjectId              AS GoodsId
                   , MILinkObject_GoodsKind.ObjectId    AS GoodsKindId
                   , MIDate_PartionGoods.ValueData      AS PartionGoodsDate
                   , MIString_PartionGoods.ValueData    AS PartionGoods
                   , MIString_PartNumber.ValueData      AS PartNumber
                   , MILinkObject_Asset.ObjectId        AS AssetId
                   , MILinkObject_Asset_two.ObjectId    AS AssetId_two
                   , MILinkObject_PartionGoods.ObjectId AS PartionGoodsId
                   , MovementItem.Amount                AS Amount
                   , COALESCE (MIFloat_Count.ValueData, 0)     AS Count
                   , COALESCE (MIFloat_CountPack.ValueData, 0) AS CountPack
                   , COALESCE (MIFloat_HeadCount.ValueData, 0) AS HeadCount
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

                   LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                              ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                             AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                   LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                               AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                   LEFT JOIN MovementItemString AS MIString_PartNumber
                                                ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                               AND MIString_PartNumber.DescId = zc_MIString_PartNumber()

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                    ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset_two
                                                    ON MILinkObject_Asset_two.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Asset_two.DescId = zc_MILinkObject_Asset_two()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionGoods
                                                    ON MILinkObject_PartionGoods.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_PartionGoods.DescId = zc_MILinkObject_PartionGoods()

              WHERE MovementItem.MovementId = CASE WHEN vbIsWeighing = TRUE THEN inMovementId_Weighing ELSE inMovementId END
                AND MovementItem.DescId     = CASE WHEN vbIsProductionOut = TRUE AND vbIsWeighing = FALSE THEN zc_MI_Child() ELSE zc_MI_Master() END
                AND MovementItem.isErased   = FALSE
                AND MovementItem.Amount <> 0
                AND inisItem = TRUE
             )

       --результат
       SELECT
             tmpMI.MovementItemId               AS Id
           , Object_Goods.Id                    AS GoodsId
           , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.ValueData                AS GoodsGroupName
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , Object_Measure.ValueData           AS MeasureName
           , tmpMI.Amount
           , tmpMI.Count
           , tmpMI.CountPack
           , tmpMI.HeadCount
           --, CAST ((tmpMI.Amount * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END )) AS TFloat) AS Amount_Weight
           , CAST ((tmpMI.Amount * (CASE WHEN Object_Measure.Id = zc_Measure_Kg() THEN 1 ELSE COALESCE (ObjectFloat_Weight.ValueData, 0) END )) AS TFloat) AS Amount_Weight
           , CASE WHEN COALESCE (tmpMI.Count, 0) <> 0
                  THEN tmpMI.Amount * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END ) / tmpMI.Count
                  ELSE 0
             END AS WeightOne     -- "вес 1 ед." = вес / кол-во батонов
           , tmpMI.PartionGoodsDate
           , CASE WHEN tmpMI.PartionGoods <> ''
                       THEN tmpMI.PartionGoods
                  ELSE CASE WHEN Object_Asset_two.ValueData <> '' THEN '1)' ELSE '' END || COALESCE (Object_Asset.ValueData, '')
                    || CASE WHEN Object_Asset_two.ValueData <> '' THEN CHR (13) || '2)' ||Object_Asset_two.ValueData ELSE '' END
             END :: TVarChar AS PartionGoods
           , tmpMI.PartNumber :: TVarChar AS PartNumber

           , Object_GoodsKind.Id                AS GoodsKindId
           , Object_GoodsKind.ValueData         AS GoodsKindName
           , Object_Asset.Id                    AS AssetId
           , Object_Asset.ValueData             AS AssetName

           , Object_PartionGoods.Id             AS PartionGoodsId
           , Object_PartionGoods.ValueData      AS PartionGoodsName
           , ObjectDate_Value.ValueData         AS PartionGoodsOperDate
           , ObjectFloat_Price.ValueData        AS Price
           , Object_Storage_Partion.ValueData   AS StorageName_Partion
           , Object_Unit.ValueData              AS UnitName

           , ObjectFloat_WmsCellNum.ValueData   AS WmsCellNum

       FROM tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN Object AS Object_Asset     ON Object_Asset.Id     = tmpMI.AssetId
            LEFT JOIN Object AS Object_Asset_two ON Object_Asset_two.Id = tmpMI.AssetId_two
            
            LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpMI.PartionGoodsId
            LEFT JOIN ObjectFloat AS ObjectFloat_Price ON ObjectFloat_Price.ObjectId = Object_PartionGoods.Id                   -- цена
                                                      AND ObjectFloat_Price.DescId = zc_ObjectFloat_PartionGoods_Price()
            LEFT JOIN ObjectLink AS ObjectLink_Storage ON ObjectLink_Storage.ObjectId = Object_PartionGoods.Id 		        -- склад
                                                      AND ObjectLink_Storage.DescId = zc_ObjectLink_PartionGoods_Storage()
            LEFT JOIN Object AS Object_Storage_Partion ON Object_Storage_Partion.Id = ObjectLink_Storage.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Unit ON ObjectLink_Unit.ObjectId = Object_PartionGoods.Id		        -- подразделение
                                                   AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId

            LEFT JOIN ObjectDate as objectdate_value ON objectdate_value.ObjectId = Object_PartionGoods.Id                    -- дата
                                                    AND objectdate_value.DescId = zc_ObjectDate_PartionGoods_Value()

            LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN Object_GoodsByGoodsKind_View AS View_GoodsByGoodsKind ON View_GoodsByGoodsKind.GoodsId = Object_Goods.Id
                                                                           AND View_GoodsByGoodsKind.GoodsKindId = Object_GoodsKind.Id

            LEFT JOIN ObjectFloat AS ObjectFloat_WmsCellNum
                                  ON ObjectFloat_WmsCellNum.ObjectId = View_GoodsByGoodsKind.Id
                                 AND ObjectFloat_WmsCellNum.DescId = zc_ObjectFloat_GoodsByGoodsKind_WmsCellNum()

       ORDER BY ObjectString_Goods_GroupNameFull.ValueData
              , Object_GoodsGroup.ValueData
              , Object_Goods.ValueData
              , Object_GoodsKind.ValueData
              , tmpMI.PartionGoodsDate
              , tmpMI.PartionGoods
              , tmpMI.PartNumber
        ;


    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.08.19         * WmsCellNum
 12.02.19         * add inisItem
 11.10.17         *
 12.06.15         *
*/

-- SELECT * FROM gpSelect_Movement_Send_Print (inMovementId := 570596, inMovementId_Weighing:= 0 , inisItem:=true, inSession:= '5');
