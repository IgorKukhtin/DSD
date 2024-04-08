 -- Function: gpReport_WeighingProduction_KVK

DROP FUNCTION IF EXISTS gpReport_WeighingProduction_KVK (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_WeighingProduction_KVK (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_WeighingProduction_KVK(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inisDetail           Boolean, 
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, InvNumber TVarChar, OperDate TDateTime, MovementDescName TVarChar
             , StartWeighing TDateTime, EndWeighing TDateTime
             , InsertDate TDateTime
             , FromName TVarChar, ToName TVarChar
             , GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar, GoodsKindName TVarChar
             , GoodsKindName_Complete TVarChar, GoodsKindName_Partion TVarChar
             , KVK TVarChar
             , PartionGoods TVarChar
             , PartionDate TDateTime
             , Amount TFloat
             , Amount_Partion TFloat
             , CuterCount TFloat
             , WeightTare TFloat
             , Count TFloat
             , PersonalKVKId Integer, PersonalKVKName TVarChar
             , UserId Integer, UserName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_WeighingPartner());

     -- inShowAll:= TRUE;
     RETURN QUERY 
     WITH 
     tmpMovement AS ( SELECT Movement.Id           AS MovementId
                           , Movement.InvNumber    AS InvNumber
                           , Movement.OperDate     AS OperDate
                           , MovementDesc.ItemName AS MovementDescName
                           , MovementDate_StartWeighing.ValueData  AS StartWeighing  
                           , MovementDate_EndWeighing.ValueData    AS EndWeighing
                       FROM Movement
                            INNER JOIN MovementLinkObject AS MLO_DocumentKind
                                                          ON MLO_DocumentKind.MovementId = Movement.Id
                                                         AND MLO_DocumentKind.DescId     = zc_MovementLinkObject_DocumentKind()
                                                         AND MLO_DocumentKind.ObjectId   IN (zc_Enum_DocumentKind_RealWeight(), zc_Enum_DocumentKind_RealDelicMsg())
                            LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

                            LEFT JOIN MovementDate AS MovementDate_StartWeighing
                                                   ON MovementDate_StartWeighing.MovementId = Movement.Id
                                                  AND MovementDate_StartWeighing.DescId = zc_MovementDate_StartWeighing()
                            LEFT JOIN MovementDate AS MovementDate_EndWeighing
                                                   ON MovementDate_EndWeighing.MovementId = Movement.Id
                                                  AND MovementDate_EndWeighing.DescId = zc_MovementDate_EndWeighing()
                       WHERE Movement.DescId IN (zc_Movement_WeighingProduction())
                         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                         AND Movement.StatusId = zc_Enum_Status_Complete()
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

   , tmpMovementItemFloat AS (SELECT *
                              FROM MovementItemFloat
                              WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.MI_Id FROM tmpMI)
                                AND MovementItemFloat.DescId IN (zc_MIFloat_WeightTare()
                                                               , zc_MIFloat_Count()
                                                               , zc_MIFloat_MovementItemId()
                                                                )
                             )
   , tmpMovementItemString AS (SELECT *
                               FROM MovementItemString
                               WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.MI_Id FROM tmpMI)
                                 AND MovementItemString.DescId IN (zc_MIString_PartionGoods()
                                                                 , zc_MIString_KVK()
                                                                  )
                             )
   , tmpMovementItemDate AS (SELECT *
                             FROM MovementItemDate
                             WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI.MI_Id FROM tmpMI)
                               AND MovementItemDate.DescId = zc_MIDate_Insert()
                             )

   , tmpMILO AS (SELECT *
                 FROM MovementItemLinkObject
                 WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.MI_Id FROM tmpMI)
                   AND MovementItemLinkObject.DescId IN (zc_MILinkObject_PersonalKVK()
                                                       , zc_MILinkObject_GoodsKind())
                )

   , tmpMLO AS (SELECT *
                FROM MovementLinkObject
                WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMI.MovementId FROM tmpMI)
                  AND MovementLinkObject.DescId IN (zc_MovementLinkObject_User()
                                                  , zc_MovementLinkObject_From()
                                                  , zc_MovementLinkObject_To()
                                                   )
               )

   , tmpData AS (SELECT tmp.MovementId
                      , tmp.InvNumber
                      , tmp.OperDate
                      , tmp.MovementDescName
                      , tmp.StartWeighing  
                      , tmp.EndWeighing
                      , tmp.InsertDate
                      , CASE WHEN inisDetail = TRUE THEN tmp.MI_Id ELSE 0 END AS MI_Id
                      , tmp.GoodsId
                      , tmp.GoodsKindId
                      , tmp.GoodsKindName_Complete
                      , tmp.GoodsKindName_Partion
                      , tmp.KVK
                      , tmp.PersonalKVKId
                      , tmp.UserId
                      , tmp.FromId
                      , tmp.ToId
                      , tmp.PartionGoods
                      , tmp.PartionDate    --дата партии

                      , SUM (tmp.Amount) AS Amount
                      , tmp.Amount_Partion -- вес
                      , tmp.CuterCount     -- колво кутеров
                      , SUM (tmp.WeightTare) AS WeightTare     -- тара
                      , SUM (tmp.Count) AS Count          -- батоны

                 FROM (
                       SELECT tmpMI.MovementId
                            , tmpMI.InvNumber
                            , tmpMI.OperDate
                            , tmpMI.MovementDescName
                            , tmpMI.StartWeighing  
                            , tmpMI.EndWeighing
                            , MIDate_Insert.ValueData AS InsertDate
                            , tmpMI.MI_Id
                            , tmpMI.GoodsId
                            , tmpMI.Amount
      
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
      
                            , DATE (COALESCE (Movement_Partion.OperDate, zc_DateEnd())) AS PartionDate    --дата партии
                            , COALESCE (MI_Partion.Amount, 0)                           AS Amount_Partion -- вес
                            , COALESCE (MIFloat_CuterCount.ValueData, 0)                AS CuterCount     -- колво кутеров
                            , MIFloat_WeightTare.ValueData                              AS WeightTare     -- тара
                            , MIFloat_Count.ValueData                                   AS Count          -- батоны
                            , MIString_KVK.ValueData                                    AS KVK
                            , MILinkObject_PersonalKVK.ObjectId                         AS PersonalKVKId
                            , MILinkObject_GoodsKind.ObjectId                           AS GoodsKindId
                            , Object_GoodsKindComplete.ValueData                        AS GoodsKindName_Complete
                            , Object_GoodsKindPartion.ValueData                         AS GoodsKindName_Partion
                            , MovementLinkObject_User.ObjectId                          AS UserId
                            , MovementLinkObject_From.ObjectId                          AS FromId
                            , MovementLinkObject_To.ObjectId                            AS ToId
                       FROM tmpMI
                           LEFT JOIN tmpMLO AS MovementLinkObject_User
                                            ON MovementLinkObject_User.MovementId = tmpMI.MovementId
                                           AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
      
                           LEFT JOIN tmpMLO AS MovementLinkObject_From
                                            ON MovementLinkObject_From.MovementId = tmpMI.MovementId
                                           AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                
                           LEFT JOIN tmpMLO AS MovementLinkObject_To
                                            ON MovementLinkObject_To.MovementId = tmpMI.MovementId
                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
      
                           LEFT JOIN tmpMILO AS MILinkObject_PersonalKVK
                                             ON MILinkObject_PersonalKVK.MovementItemId = tmpMI.MI_Id
                                            AND MILinkObject_PersonalKVK.DescId = zc_MILinkObject_PersonalKVK()
      
                           LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = tmpMI.MI_Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
      
      
                           LEFT JOIN tmpMovementItemString AS MIString_PartionGoods
                                                           ON MIString_PartionGoods.MovementItemId = tmpMI.MI_Id
                                                          AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                           LEFT JOIN tmpMovementItemString AS MIString_KVK
                                                           ON MIString_KVK.MovementItemId = tmpMI.MI_Id
                                                          AND MIString_KVK.DescId = zc_MIString_KVK()
      
                           LEFT JOIN tmpMovementItemDate AS MIDate_Insert
                                                         ON MIDate_Insert.MovementItemId = tmpMI.MI_Id
                                                        AND MIDate_Insert.DescId = zc_MIDate_Insert()

                           LEFT JOIN tmpMovementItemFloat AS MIFloat_WeightTare
                                                          ON MIFloat_WeightTare.MovementItemId = tmpMI.MI_Id
                                                         AND MIFloat_WeightTare.DescId = zc_MIFloat_WeightTare()
      
                           LEFT JOIN tmpMovementItemFloat AS MIFloat_Count
                                                          ON MIFloat_Count.MovementItemId = tmpMI.MI_Id
                                                         AND MIFloat_Count.DescId = zc_MIFloat_Count()
      
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

                           LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindPartion
                                                            ON MILO_GoodsKindPartion.MovementItemId = MI_Partion.Id
                                                           AND MILO_GoodsKindPartion.DescId = zc_MILinkObject_GoodsKind()
                           LEFT JOIN Object AS Object_GoodsKindPartion ON Object_GoodsKindPartion.Id = MILO_GoodsKindPartion.ObjectId
                           
                           LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                                       ON MIFloat_CuterCount.MovementItemId = MI_Partion.Id
                                                      AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()
                       ) AS tmp
                 GROUP BY tmp.MovementId
                      , tmp.InvNumber
                      , tmp.OperDate
                      , tmp.MovementDescName
                      , CASE WHEN inisDetail = TRUE THEN tmp.MI_Id ELSE 0 END
                      , tmp.GoodsId
                      , tmp.GoodsKindId
                      , tmp.GoodsKindName_Complete
                      , tmp.GoodsKindName_Partion
                      , tmp.KVK
                      , tmp.PersonalKVKId
                      , tmp.UserId
                      , tmp.FromId
                      , tmp.ToId
                      , tmp.PartionGoods
                      , tmp.PartionDate    --дата партии
                      , tmp.Amount_Partion
                      , tmp.CuterCount
                      , tmp.StartWeighing  
                      , tmp.EndWeighing
                      , tmp.InsertDate
                 )

          --РЕЗУЛЬТАТ
          SELECT tmpData.MovementId
               , tmpData.InvNumber
               , tmpData.OperDate
               , tmpData.MovementDescName
               , tmpData.StartWeighing  ::TDateTime
               , tmpData.EndWeighing    ::TDateTime
               , tmpData.InsertDate     ::TDateTime
               , Object_From.ValueData    AS FromName
               , Object_To.ValueData      AS ToName
               , Object_Goods.ObjectCode ::Integer AS GoodsCode
               , Object_Goods.ValueData   AS GoodsName
               , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
               , Object_Measure.ValueData                    AS MeasureName
               , Object_GoodsKind.ValueData                  AS GoodsKindName
               , tmpData.GoodsKindName_Complete ::TVarChar
               , tmpData.GoodsKindName_Partion  ::TVarChar

               , tmpData.KVK            :: TVarChar               
               , tmpData.PartionGoods   :: TVarChar
               , tmpData.PartionDate    :: TDateTime
               , tmpData.Amount         :: TFloat  -- колво взвеш.(производство)
               , tmpData.Amount_Partion :: TFloat -- вес
               , tmpData.CuterCount     :: TFloat-- колво кутеров
               , tmpData.WeightTare     :: TFloat-- тара
               , tmpData.Count          :: TFloat-- батоны

               , Object_PersonalKVK.Id          AS PersonalKVKId
               , Object_PersonalKVK.ValueData   AS PersonalKVKName
               , tmpData.UserId                 AS UserId
               , Object_Member.ValueData        AS UserName
          FROM tmpData
               LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
               LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpData.GoodsKindId
               --LEFT JOIN Object AS Object_User ON Object_User.Id = tmpData.UserId
               LEFT JOIN Object AS Object_PersonalKVK ON Object_PersonalKVK.Id = tmpData.PersonalKVKId
               LEFT JOIN Object AS Object_From ON Object_From.Id = tmpData.FromId
               LEFT JOIN Object AS Object_To ON Object_To.Id = tmpData.ToId

               LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                      ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                     AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

               LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                    ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                                   AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
               LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

               LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                    ON ObjectLink_User_Member.ObjectId = tmpData.UserId
                                   AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
               LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.07.21         *
*/

-- тест
-- SELECT * FROM gpReport_WeighingProduction_KVK (inStartDate := ('01.07.2021')::TDateTime , inEndDate := ('01.07.2021')::TDateTime , inisDetail:= TRUE, inSession := '5');