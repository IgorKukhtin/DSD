-- Function: gpSelect_Movement_WeighingProduction_PrintBrutto()

DROP FUNCTION IF EXISTS gpSelect_Movement_WeighingProduction_PrintBrutto (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_WeighingProduction_PrintBrutto(
    IN inMovementId                 Integer  , -- ключ Документа
    IN inSession                    TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbIsWeighing Boolean;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_WeighingProduction_Print());

    
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
           , Object_User.ValueData                  :: TVarChar AS StoreKeeperName_from -- кладовщик

       FROM Movement
            LEFT JOIN MovementFloat AS MFloat_WeighingNumber
                                    ON MFloat_WeighingNumber.MovementId = Movement.Id
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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                         ON MovementLinkObject_User.MovementId = Movement.Id
                                        AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
            LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId

       WHERE Movement.Id = inMovementId
      --   AND Movement.DescId = zc_Movement_WeighingProduction()
      ;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
    WITH 
    tmpMovementItem AS (SELECT MovementItem.*
                        FROM MovementItem
                        WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId     = zc_MI_Master()
                         AND MovementItem.isErased   = FALSE
                         AND MovementItem.Amount <> 0
                       )
  , tmpMIFloat AS (SELECT *
                   FROM MovementItemFloat
                   WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMovementItem.Id FROM tmpMovementItem)
                     AND MovementItemFloat.DescId IN (zc_MIFloat_CountTare1()
                                                    , zc_MIFloat_CountTare2()
                                                    , zc_MIFloat_CountTare3()
                                                    , zc_MIFloat_CountTare4()
                                                    , zc_MIFloat_CountTare5()
                                                    , zc_MIFloat_WeightTare1()
                                                    , zc_MIFloat_WeightTare2()
                                                    , zc_MIFloat_WeightTare3()
                                                    , zc_MIFloat_WeightTare4()
                                                    , zc_MIFloat_WeightTare5()
                                                    , zc_MIFloat_RealWeight()
                                                    , zc_MIFloat_WeightTare()
                                                    , zc_MIFloat_CountPack()
                                                    , zc_MIFloat_WeightPack()
                                                     )
                 )

  , tmpMILO AS (SELECT *
                FROM MovementItemLinkObject
                WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMovementItem.Id FROM tmpMovementItem)
                  AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKind()
                                                      , zc_MILinkObject_PartionGoods()
                                                       )
              )

  , tmpMIDate AS (SELECT *
                  FROM MovementItemDate
                  WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMovementItem.Id FROM tmpMovementItem)
                    AND MovementItemDate.DescId IN (zc_MIDate_PartionGoods()
                                                    )
                  )

  , tmpMIString AS (SELECT *
                    FROM MovementItemString
                    WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMovementItem.Id FROM tmpMovementItem)
                      AND MovementItemString.DescId IN (zc_MIString_PartionGoods()
                                                       )
                  )


  , tmpMI AS (SELECT MovementItem.Id                           AS MovementItemId
                   , MovementItem.ObjectId                     AS GoodsId
                   , MILinkObject_GoodsKind.ObjectId           AS GoodsKindId
                   , MovementItem.Amount                       AS Amount           --Количество
                   , COALESCE (MIFloat_RealWeight.ValueData,0) AS RealWeight       --Реальный вес
                   , (COALESCE (MIFloat_WeightTare.ValueData,0)
                     -- + Упаковка
                      + COALESCE (MIFloat_CountPack.ValueData, 0) * COALESCE (MIFloat_WeightPack.ValueData, 0)
                       ) AS WeightTare_1       --вес тары Документ <Взвешивание (производство)>
                    
                   , ( COALESCE (MIFloat_CountTare1.ValueData,0) * COALESCE (MIFloat_WeightTare1.ValueData,0)
                     + COALESCE (MIFloat_CountTare2.ValueData,0) * COALESCE (MIFloat_WeightTare2.ValueData,0)
                     + COALESCE (MIFloat_CountTare3.ValueData,0) * COALESCE (MIFloat_WeightTare3.ValueData,0)
                     + COALESCE (MIFloat_CountTare4.ValueData,0) * COALESCE (MIFloat_WeightTare4.ValueData,0)
                     + COALESCE (MIFloat_CountTare5.ValueData,0) * COALESCE (MIFloat_WeightTare5.ValueData,0)
                     -- + Упаковка
                     + COALESCE (MIFloat_CountPack.ValueData, 0) * COALESCE (MIFloat_WeightPack.ValueData, 0)
                      ) ::TFloat AS WeightTare_2                                              --вес тары Документ <Взвешивание (контрагент)>

                   , MIDate_PartionGoods.ValueData             AS PartionGoodsDate
                   , MIString_PartionGoods.ValueData           AS PartionGoods
                   , MILinkObject_PartionGoods.ObjectId        AS PartionGoodsId
                                    
              FROM tmpMovementItem AS MovementItem
 
                   LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                                     ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                   LEFT JOIN tmpMIFloat AS MIFloat_WeightTare
                                        ON MIFloat_WeightTare.MovementItemId = MovementItem.Id
                                       AND MIFloat_WeightTare.DescId = zc_MIFloat_WeightTare()

                   LEFT JOIN tmpMIFloat AS MIFloat_RealWeight
                                        ON MIFloat_RealWeight.MovementItemId = MovementItem.Id
                                       AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight() 

                   -- упаковка
                   LEFT JOIN tmpMIFloat AS MIFloat_CountPack
                                        ON MIFloat_CountPack.MovementItemId =  MovementItem.Id
                                       AND MIFloat_CountPack.DescId         = zc_MIFloat_CountPack()
                   LEFT JOIN tmpMIFloat AS MIFloat_WeightPack
                                        ON MIFloat_WeightPack.MovementItemId =  MovementItem.Id
                                       AND MIFloat_WeightPack.DescId         = zc_MIFloat_WeightPack()

                   LEFT JOIN tmpMIFloat AS MIFloat_CountTare1
                                        ON MIFloat_CountTare1.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountTare1.DescId = zc_MIFloat_CountTare1()
                   LEFT JOIN tmpMIFloat AS MIFloat_CountTare2
                                        ON MIFloat_CountTare2.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountTare2.DescId = zc_MIFloat_CountTare2()
                   LEFT JOIN tmpMIFloat AS MIFloat_CountTare3
                                        ON MIFloat_CountTare3.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountTare3.DescId = zc_MIFloat_CountTare3()
                   LEFT JOIN tmpMIFloat AS MIFloat_CountTare4
                                        ON MIFloat_CountTare4.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountTare4.DescId = zc_MIFloat_CountTare4()
                   LEFT JOIN tmpMIFloat AS MIFloat_CountTare5
                                        ON MIFloat_CountTare5.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountTare5.DescId = zc_MIFloat_CountTare5()

                   LEFT JOIN tmpMIFloat AS MIFloat_WeightTare1
                                        ON MIFloat_WeightTare1.MovementItemId = MovementItem.Id
                                       AND MIFloat_WeightTare1.DescId = zc_MIFloat_WeightTare1()
                   LEFT JOIN tmpMIFloat AS MIFloat_WeightTare2
                                        ON MIFloat_WeightTare2.MovementItemId = MovementItem.Id
                                       AND MIFloat_WeightTare2.DescId = zc_MIFloat_WeightTare2()
                   LEFT JOIN tmpMIFloat AS MIFloat_WeightTare3
                                        ON MIFloat_WeightTare3.MovementItemId = MovementItem.Id
                                       AND MIFloat_WeightTare3.DescId = zc_MIFloat_WeightTare3()
                   LEFT JOIN tmpMIFloat AS MIFloat_WeightTare4
                                        ON MIFloat_WeightTare4.MovementItemId = MovementItem.Id
                                       AND MIFloat_WeightTare4.DescId = zc_MIFloat_WeightTare4()
                   LEFT JOIN tmpMIFloat AS MIFloat_WeightTare5
                                        ON MIFloat_WeightTare5.MovementItemId = MovementItem.Id
                                       AND MIFloat_WeightTare5.DescId = zc_MIFloat_WeightTare5()

                   LEFT JOIN tmpMIDate AS MIDate_PartionGoods
                                       ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                   LEFT JOIN tmpMIString AS MIString_PartionGoods
                                         ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                   LEFT JOIN tmpMILO AS MILinkObject_PartionGoods
                                     ON MILinkObject_PartionGoods.MovementItemId = MovementItem.Id
                                    AND MILinkObject_PartionGoods.DescId = zc_MILinkObject_PartionGoods()
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
           , Object_GoodsKind.Id                AS GoodsKindId
           , Object_GoodsKind.ValueData         AS GoodsKindName

           , tmpMI.Amount
           , CAST ((tmpMI.Amount * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END )) AS TFloat) AS Amount_Weight
           , (COALESCE (tmpMI.WeightTare_1,0) + COALESCE (tmpMI.WeightTare_2,0))    ::TFloat     AS WeightTare
           --, tmpMI.WeightTare_1    ::TFloat
           --, tmpMI.WeightTare_2    ::TFloat
           , tmpMI.RealWeight ::TFloat

           , Object_PartionGoods.Id             AS PartionGoodsId
           , Object_PartionGoods.ValueData      AS PartionGoodsName
           , ObjectDate_Value.ValueData         AS PartionGoodsOperDate
           , tmpMI.PartionGoodsDate
           , tmpMI.PartionGoods
       FROM tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpMI.PartionGoodsId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                                 
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                   ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectDate AS ObjectDate_Value
                                 ON ObjectDate_Value.ObjectId = Object_PartionGoods.Id                    -- дата
                                AND ObjectDate_Value.DescId = zc_ObjectDate_PartionGoods_Value()
       ORDER BY ObjectString_Goods_GroupNameFull.ValueData
              , Object_GoodsGroup.ValueData
              , Object_Goods.ValueData
              , Object_GoodsKind.ValueData
        ;


    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.07.25         *
*/

--SELECT * FROM gpSelect_Movement_WeighingProduction_PrintBrutto (inMovementId := 570596, inSession:= '5');
