 -- Function: gpReport_Losses_KVK

-- потери КВК
DROP FUNCTION IF EXISTS gpReport_Losses_KVK (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Losses_KVK (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Losses_KVK(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inUnitId             Integer   ,
    IN inUserId             Integer   ,
    IN inPersonalKVKId      Integer   ,
    IN inKVK                TVarChar  ,
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (/*MovementId Integer, InvNumber TVarChar, OperDate TDateTime, MovementDescName TVarChar
             , FromName TVarChar, ToName TVarChar, UserName TVarChar
             , */
               MovementDescName TVarChar
             , InvNumber_pu TVarChar, OperDate_pu TDateTime, MovementDescName_pu TVarChar
             , GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar, GoodsKindName TVarChar
             , PartionDate TDateTime            
             , PartionGoods TVarChar
             , PersonalKVKId Integer, PersonalKVKName TVarChar
             , PositionCode_KVK Integer, PositionName_KVK TVarChar
             , UnitCode_KVK Integer, UnitName_KVK TVarChar
             , KVK TVarChar
             , Amount TFloat
             , Amount_pu TFloat
             , Amount_diff TFloat
              )
AS
$BODY$
BEGIN

     RETURN QUERY 
     WITH 
     tmpMovementAll AS (SELECT Movement.Id as MovementId
                             , Movement.InvNumber  AS InvNumber
                             , Movement.OperDate
                             , MovementDesc.ItemName AS MovementDescName
                        FROM Movement
                             INNER JOIN MovementLinkObject AS MLO_DocumentKind
                                                           ON MLO_DocumentKind.MovementId = Movement.Id
                                                          AND MLO_DocumentKind.DescId     = zc_MovementLinkObject_DocumentKind()
                                                          AND MLO_DocumentKind.ObjectId = zc_Enum_DocumentKind_RealWeight()
                             LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                        WHERE Movement.DescId IN (zc_Movement_WeighingProduction())
                          AND Movement.OperDate BETWEEN inStartDate AND inEndDate      -->'01.09.2021'--
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                        )

   , tmpMLO AS (SELECT *
                FROM MovementLinkObject
                WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovementAll.MovementId FROM tmpMovementAll)
                  AND MovementLinkObject.DescId IN (zc_MovementLinkObject_User()
                                                  , zc_MovementLinkObject_From()
                                                  , zc_MovementLinkObject_To()
                                                   )
               )

   , tmpMovement AS (SELECT tmpMovementAll.*
                     FROM tmpMovementAll
                          LEFT JOIN tmpMLO AS MovementLinkObject_User
                                           ON MovementLinkObject_User.MovementId = tmpMovementAll.MovementId
                                          AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
                          LEFT JOIN tmpMLO AS MovementLinkObject_From
                                           ON MovementLinkObject_From.MovementId = tmpMovementAll.MovementId
                                          AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                     WHERE (MovementLinkObject_User.ObjectId = inUserId OR inUserId = 0)
                       AND (MovementLinkObject_From.ObjectId = inUnitId OR inUnitId = 0)
                     )


   , tmpMI AS (SELECT tmpMovement.*
                    , MovementItem.Id AS MI_Id
                    , MovementItem.ObjectId AS GoodsId
                    , MovementItem.Amount
               FROM tmpMovement
                 INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
                                        AND MovementItem.DescId     = zc_MI_Master()
                                        AND MovementItem.isErased   = FALSE
               )

   , tmpMovementItemString AS (SELECT *
                               FROM MovementItemString
                               WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.MI_Id FROM tmpMI)
                                 AND MovementItemString.DescId IN (zc_MIString_PartionGoods()
                                                                 , zc_MIString_KVK()
                                                                  )
                              )

   , tmpMovementItemFloat AS (SELECT *
                              FROM MovementItemFloat
                              WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.MI_Id FROM tmpMI)
                                AND MovementItemFloat.DescId IN (zc_MIFloat_WeightTare()
                                                               , zc_MIFloat_Count()
                                                               , zc_MIFloat_MovementItemId()
                                                                )
                             )

   , tmpMILO AS (SELECT *
                 FROM MovementItemLinkObject
                 WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.MI_Id FROM tmpMI)
                   AND MovementItemLinkObject.DescId IN (zc_MILinkObject_PersonalKVK()
                                                       , zc_MILinkObject_GoodsKind())
                )

   , tmpWeighingProduction AS (SELECT /*tmpMI.MovementId
                                    , tmpMI.InvNumber
                                    , tmpMI.OperDate
                                    , tmpMI.MovementDescName
                                    --, tmpMI.MI_Id
                                    ,*/ tmpMI.MovementDescName
                                    , tmpMI.GoodsId
                                    , MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                                    , SUM (tmpMI.Amount) AS Amount
                                    , MIString_KVK.ValueData            AS KVK
                                    , MILinkObject_PersonalKVK.ObjectId AS PersonalId_KVK
                                    , DATE (COALESCE (Movement_Partion.OperDate, zc_DateEnd())) AS PartionDate    --дата партии
                                    , Movement_Partion.Id               AS MovementId_Partion
                                    , CASE WHEN MIString_PartionGoods.ValueData <> ''
                                                THEN MIString_PartionGoods.ValueData
                                           WHEN MI_Partion.Id > 0
                                                THEN 
                                              ('кол.=<' || zfConvert_FloatToString (COALESCE (MI_Partion.Amount, 0)) || '>'
                                            || ' кут.=<' || zfConvert_FloatToString (COALESCE (MIFloat_CuterCount.ValueData, 0)) || '>'
                                            || ' вид=<' || COALESCE (Object_GoodsKindComplete.ValueData, '') || '>'
                                            || ' партия=<' || DATE (COALESCE (Movement_Partion.OperDate, zc_DateEnd())) || '>'
                                            || ' № <' || COALESCE (Movement_Partion.InvNumber, '') || '>'
                                              )
                                           ELSE MIFloat_MovementItemId.ValueData :: TVarChar
                                      END :: TVarChar AS PartionGoods

                               FROM tmpMI
                                    LEFT JOIN tmpMILO AS MILinkObject_PersonalKVK
                                                      ON MILinkObject_PersonalKVK.MovementItemId = tmpMI.MI_Id
                                                     AND MILinkObject_PersonalKVK.DescId = zc_MILinkObject_PersonalKVK()
                                    LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = tmpMI.MI_Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                                    LEFT JOIN tmpMovementItemString AS MIString_KVK
                                                                    ON MIString_KVK.MovementItemId = tmpMI.MI_Id
                                                                   AND MIString_KVK.DescId = zc_MIString_KVK()

                                    LEFT JOIN tmpMovementItemString AS MIString_PartionGoods
                                                                    ON MIString_PartionGoods.MovementItemId = tmpMI.MI_Id
                                                                   AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

                                    LEFT JOIN tmpMovementItemFloat AS MIFloat_MovementItemId
                                                                   ON MIFloat_MovementItemId.MovementItemId = tmpMI.MI_Id
                                                                  AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId()
                                    LEFT JOIN MovementItem AS MI_Partion ON MI_Partion.Id = CASE WHEN MIFloat_MovementItemId.ValueData > 0 THEN MIFloat_MovementItemId.ValueData ELSE NULL END :: Integer
                                    LEFT JOIN Movement AS Movement_Partion ON Movement_Partion.Id       = MI_Partion.MovementId
                                                                          AND Movement_Partion.DescId   = zc_Movement_ProductionUnion()

                                    LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                                                     ON MILO_GoodsKindComplete.MovementItemId = MI_Partion.Id
                                                                    AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                                    LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = MILO_GoodsKindComplete.ObjectId
                                    LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                                                ON MIFloat_CuterCount.MovementItemId = MI_Partion.Id
                                                               AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()

                               WHERE (COALESCE (MILinkObject_PersonalKVK.ObjectId,0) <> 0 OR COALESCE (MIString_KVK.ValueData,'') <> '')
                                 AND (COALESCE (MILinkObject_PersonalKVK.ObjectId,0) = inPersonalKVKId OR inPersonalKVKId = 0)
                                 AND (COALESCE (MIString_KVK.ValueData,'') = inKVK OR COALESCE (inKVK,'') = '')
                               GROUP BY /*tmpMI.MovementId
                                    , tmpMI.InvNumber
                                    , tmpMI.OperDate
                                    , tmpMI.MovementDescName
                                    , */tmpMI.GoodsId
                                    , tmpMI.MovementDescName
                                    , MILinkObject_GoodsKind.ObjectId
                                    , MIString_KVK.ValueData 
                                    , MILinkObject_PersonalKVK.ObjectId
                                    , DATE (COALESCE (Movement_Partion.OperDate, zc_DateEnd()))
                                    , Movement_Partion.Id
                                    , CASE WHEN MIString_PartionGoods.ValueData <> ''
                                                THEN MIString_PartionGoods.ValueData
                                           WHEN MI_Partion.Id > 0
                                                THEN 
                                              ('кол.=<' || zfConvert_FloatToString (COALESCE (MI_Partion.Amount, 0)) || '>'
                                            || ' кут.=<' || zfConvert_FloatToString (COALESCE (MIFloat_CuterCount.ValueData, 0)) || '>'
                                            || ' вид=<' || COALESCE (Object_GoodsKindComplete.ValueData, '') || '>'
                                            || ' партия=<' || DATE (COALESCE (Movement_Partion.OperDate, zc_DateEnd())) || '>'
                                            || ' № <' || COALESCE (Movement_Partion.InvNumber, '') || '>'
                                              )
                                           ELSE MIFloat_MovementItemId.ValueData :: TVarChar
                                      END
                               )

   -- 2) другое кол-во находим для ContainerId из п1. везде где они есть в zc_Movement_ProductionUnion.zc_MI_Child 
   --    потом через ParentId получаем его zc_Movement_ProductionUnion.zc_MI_Master.Amount + здесь должен быть такой же zc_MIString_KVK + zc_MILinkObject_PersonalKVK в мастере
   
   , tmpMIContainer AS (SELECT *
                        FROM MovementItemContainer AS MIContainer
                        WHERE MIContainer.MovementId IN (SELECT DISTINCT tmpWeighingProduction.MovementId_Partion FROM tmpWeighingProduction)
                        )

   , tmpMIChild_PU AS (SELECT *
                       FROM MovementItem 
                       WHERE MovementItem.Id IN (SELECT DISTINCT tmpMIContainer.MovementItemId FROM tmpMIContainer)
                         AND MovementItem.DescId = zc_MI_Child()
                         AND  MovementItem.isErased = FALSE
                       )

   , tmpMI_String_KVK AS (SELECT *
                          FROM MovementItemString
                          WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMIChild_PU.ParentId FROM tmpMIChild_PU)
                            AND MovementItemString.DescId IN (zc_MIString_PartionGoods()
                                                            , zc_MIString_KVK()
                                                              )
                          )
   , tmpMILO_PersonalKVK AS (SELECT *
                             FROM MovementItemLinkObject
                             WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMIChild_PU.ParentId FROM tmpMIChild_PU)
                               AND MovementItemLinkObject.DescId IN (zc_MILinkObject_PersonalKVK())
                            )

   , tmpMI_Master_PU AS (SELECT MovementItem.*
                              , MIString_KVK.ValueData            AS KVK
                              , MILinkObject_PersonalKVK.ObjectId AS PersonalId_KVK
                         FROM MovementItem 
                            LEFT JOIN tmpMI_String_KVK AS MIString_KVK
                                                       ON MIString_KVK.MovementItemId = MovementItem.Id
                                                      AND MIString_KVK.DescId = zc_MIString_KVK()
                            LEFT JOIN tmpMILO_PersonalKVK AS MILinkObject_PersonalKVK
                                                          ON MILinkObject_PersonalKVK.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_PersonalKVK.DescId = zc_MILinkObject_PersonalKVK()
                         WHERE MovementItem.Id IN (SELECT DISTINCT tmpMIChild_PU.ParentId FROM tmpMIChild_PU)
                           AND MovementItem.DescId = zc_MI_Master()
                           AND MovementItem.isErased = FALSE
                         --  AND COALESCE (MILinkObject_PersonalKVK.ObjectId,0) <> 0 OR COALESCE (MIString_KVK.ValueData,'') <> ''
                       )

   , tmpProductionUnion AS (SELECT Movement.*
                                 , MovementDesc.ItemName AS MovementDescName
                            FROM Movement
                                 LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                            WHERE Movement.Id IN (SELECT tmpMI_Master_PU.MovementId FROM tmpMI_Master_PU)
                           )

     --РЕЗУЛЬТАТ
     SELECT /*tmpWeighingProduction.MovementId
          , tmpWeighingProduction.InvNumber
          , tmpWeighingProduction.OperDate
          , tmpWeighingProduction.MovementDescName
          , Object_From.ValueData               AS FromName
          , Object_To.ValueData                 AS ToName
          , Object_User.ValueData               AS UserName

          , */
          tmpWeighingProduction.MovementDescName
          , tmpProductionUnion.InvNumber      AS InvNumber_pu
          , tmpProductionUnion.OperDate         AS OperDate_pu
          , tmpProductionUnion.MovementDescName AS MovementDescName_pu

          , Object_Goods.ObjectCode           ::Integer AS GoodsCode
          , Object_Goods.ValueData                      AS GoodsName
          , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
          , Object_Measure.ValueData                    AS MeasureName
          , Object_GoodsKind.ValueData                  AS GoodsKindName
          , tmpWeighingProduction.PartionDate ::TDateTime
          , tmpWeighingProduction.PartionGoods

          , Object_PersonalKVK.Id          AS PersonalKVKId
          , Object_PersonalKVK.ValueData   AS PersonalKVKName
          , Object_PositionKVK.ObjectCode  AS PositionCode_KVK
          , Object_PositionKVK.ValueData   AS PositionName_KVK
          , Object_UnitKVK.ObjectCode      AS UnitCode_KVK
          , Object_UnitKVK.ValueData       AS UnitName_KVK
          , tmpWeighingProduction.KVK

          , tmpWeighingProduction.Amount ::TFloat AS Amount
          , tmpMI_Master_PU.Amount       ::TFloat AS Amount_pu          
          , (COALESCE (tmpMI_Master_PU.Amount,0) - COALESCE (tmpWeighingProduction.Amount,0)) ::TFloat AS Amount_diff

     FROM tmpWeighingProduction
          LEFT JOIN tmpMI_Master_PU ON tmpMI_Master_PU.ObjectId = tmpWeighingProduction.GoodsId
                                   AND tmpMI_Master_PU.MovementId = tmpWeighingProduction.MovementId_Partion
                                   AND COALESCE (tmpMI_Master_PU.PersonalId_KVK,0) = COALESCE (tmpWeighingProduction.PersonalId_KVK,0)
                                   AND COALESCE (tmpMI_Master_PU.KVK,'') = COALESCE (tmpWeighingProduction.KVK,'')
          LEFT JOIN tmpProductionUnion ON tmpProductionUnion.Id = tmpMI_Master_PU.MovementId
          
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpWeighingProduction.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpWeighingProduction.GoodsKindId

          LEFT JOIN Object AS Object_PersonalKVK ON Object_PersonalKVK.Id = tmpWeighingProduction.PersonalId_KVK

          LEFT JOIN ObjectLink AS ObjectLink_Personal_PositionKVK
                               ON ObjectLink_Personal_PositionKVK.ObjectId = Object_PersonalKVK.Id
                              AND ObjectLink_Personal_PositionKVK.DescId = zc_ObjectLink_Personal_Position()
          LEFT JOIN Object AS Object_PositionKVK ON Object_PositionKVK.Id = ObjectLink_Personal_PositionKVK.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Personal_UnitKVK
                               ON ObjectLink_Personal_UnitKVK.ObjectId = Object_PersonalKVK.Id
                              AND ObjectLink_Personal_UnitKVK.DescId = zc_ObjectLink_Personal_Unit()
          LEFT JOIN Object AS Object_UnitKVK ON Object_UnitKVK.Id = ObjectLink_Personal_UnitKVK.ChildObjectId

          /*LEFT JOIN tmpMLO AS MovementLinkObject_User
                           ON MovementLinkObject_User.MovementId = tmpWeighingProduction.MovementId
                          AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
          LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId

          LEFT JOIN tmpMLO AS MovementLinkObject_From
                           ON MovementLinkObject_From.MovementId = tmpWeighingProduction.MovementId
                          AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

          LEFT JOIN tmpMLO AS MovementLinkObject_To
                           ON MovementLinkObject_To.MovementId = tmpWeighingProduction.MovementId
                          AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
          */
          LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                 ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
          ;

END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.07.21         *
*/

-- тест
-- SELECT * FROM gpReport_Losses_KVK (inStartDate := ('01.09.2021')::TDateTime , inEndDate := ('01.10.2021')::TDateTime , inUnitId:=0, inUserId:=0, inPersonalKVKId:=14667, inKVK:='', inSession := '5');