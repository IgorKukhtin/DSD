 -- Function: gpSelect_MovementItem_WeighingPartner()

DROP FUNCTION IF EXISTS gpReport_WeighingPartner (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_WeighingPartner (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_WeighingPartner(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inMovementDescId     Integer   , --
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (InvNumber_parent TVarChar, OperDate_parent TDateTime, MovementDescName TVarChar, FromName TVarChar, ToName TVarChar
             , GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar
             , Amount TFloat, Amount_sh TFloat, Amount_Weight TFloat, Amount_mi TFloat, Amount_mi_sh TFloat, Amount_mi_Weight TFloat
             , AmountDiff_sh TFloat, AmountDiff_Weight TFloat
             , AmountPartner TFloat, AmountPartner_mi TFloat
             , RealWeight TFloat
             , ChangePercentAmount TFloat, AmountChangePercent TFloat
             , Price TFloat, CountForPrice TFloat
             , GoodsKindName TVarChar, MeasureName TVarChar
             
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_WeighingPartner());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- inShowAll:= TRUE;
     RETURN QUERY 
     WITH tmpMovement AS ( SELECT Movement.Id as MovementId
                                , Movement.InvNumber  AS InvNumber
                                , Movement.OperDate
                                , Movement_Parent.Id                AS MovementId_parent
                                , Movement_Parent.OperDate          AS OperDate_parent
                                , Movement_Parent.DescId            AS DescId_parent
                                , MovementDesc.ItemName             AS MovementDescName 
                                , CASE WHEN Movement_Parent.StatusId = zc_Enum_Status_Complete()
                                            THEN Movement_Parent.InvNumber
                                       WHEN Movement_Parent.StatusId = zc_Enum_Status_UnComplete()
                                            THEN '***' || Movement_Parent.InvNumber
                                       WHEN Movement_Parent.StatusId = zc_Enum_Status_Erased()
                                            THEN '*' || Movement_Parent.InvNumber
                                       ELSE ''
                                 END :: TVarChar AS InvNumber_parent
                                 , MovementLinkObject_From.ObjectId  AS FromId
                                 , MovementLinkObject_To.ObjectId    AS ToId
                                 
                           FROM Movement
                               LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement.ParentId
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                          
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                               LEFT JOIN MovementDesc ON MovementDesc.Id = Movement_Parent.DescId
            
                           WHERE Movement.DescId IN (zc_Movement_WeighingPartner(),zc_Movement_WeighingProduction())
                             AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                             AND (Movement_Parent.DescId = inMovementDescId OR COALESCE(inMovementDescId,0)=0)
                           --  AND Movement.parentid = 2054974
                         )
                         

       SELECT
             tmpMI.InvNumber_parent :: TVarChar
           , tmpMI.OperDate_parent  
           , tmpMI.MovementDescName
           , Object_From.ValueData            AS FromName
           , Object_To.ValueData              AS ToName
           , Object_Goods.ObjectCode          AS GoodsCode
           , Object_Goods.ValueData           AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , tmpMI.Amount :: TFloat           AS Amount
           , CAST ((tmpMI.Amount * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN 1 ELSE 0 END )) AS TFloat)    AS Amount_sh
           , CAST ((tmpMI.Amount * (CASE WHEN Object_Measure.Id = zc_Measure_kg() THEN 1 ELSE 0 END )) AS TFloat)    AS Amount_Weight

           , tmpMI.Amount_mi :: TFloat        AS Amount_mi
           , CAST ((tmpMI.Amount_mi * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN 1 ELSE 0 END )) AS TFloat)    AS Amount_mi_sh 
           , CAST ((tmpMI.Amount_mi * (CASE WHEN Object_Measure.Id = zc_Measure_kg() THEN 1 ELSE 0 END )) AS TFloat)    AS Amount_mi_Weight
                      
           , CAST (((tmpMI.Amount-tmpMI.Amount_mi) * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN 1 ELSE 0 END ))  AS TFloat)   ::TFloat     AS AmountDiff_sh
             
           , CAST (((tmpMI.Amount-tmpMI.Amount_mi ) * (CASE WHEN Object_Measure.Id = zc_Measure_Kg() THEN 1 ELSE 0 END )) AS TFloat)   :: TFloat     AS AmountDiff_Weight


           , CASE WHEN tmpMI.AmountPartner = 0 THEN NULL ELSE tmpMI.AmountPartner END :: TFloat       AS AmountPartner
           , CASE WHEN tmpMI.AmountPartner_mi = 0 THEN NULL ELSE tmpMI.AmountPartner_mi END :: TFloat AS AmountPartner_mi

           , tmpMI.RealWeight  :: TFloat      AS RealWeight

           , CASE WHEN tmpMI.ChangePercentAmount = 0 THEN NULL ELSE tmpMI.ChangePercentAmount END :: TFloat AS ChangePercentAmount
           , CASE WHEN tmpMI.AmountChangePercent = 0 THEN NULL ELSE tmpMI.AmountChangePercent END :: TFloat AS AmountChangePercent

           , CASE WHEN tmpMI.Price = 0 THEN NULL ELSE tmpMI.Price END :: TFloat                 AS Price
           , CASE WHEN tmpMI.CountForPrice = 0 THEN NULL ELSE tmpMI.CountForPrice END :: TFloat AS CountForPrice
           
           , Object_GoodsKind.ValueData      AS GoodsKindName
           , Object_Measure.ValueData        AS MeasureName

           
       FROM (SELECT 
                    tmpMI.InvNumber_parent 
                  , tmpMI.OperDate_parent
                  , tmpMI.MovementDescName
                  , tmpMI.FromId
                  , tmpMI.ToId
                  , tmpMI.GoodsId
                  , SUM (tmpMI.Amount)           AS Amount
                  , SUM (tmpMI.Amount_mi)        AS Amount_mi

                  , SUM (tmpMI.AmountPartner)    AS AmountPartner
                  , SUM (tmpMI.AmountPartner_mi) AS AmountPartner_mi

                  , SUM (tmpMI.RealWeight)       AS RealWeight

                  , tmpMI.ChangePercentAmount
                  , SUM (tmpMI.AmountChangePercent) AS AmountChangePercent
                  , tmpMI.Price
                  , tmpMI.CountForPrice
    
                  , tmpMI.GoodsKindId

             FROM
            (SELECT MovementItem.ObjectId AS GoodsId
                  , MovementItem.Amount
                  , 0 AS Amount_mi

                  , COALESCE (MIFloat_AmountPartner.ValueData, 0) AS AmountPartner
                  , 0                                             AS AmountPartner_mi

                  , COALESCE (MIFloat_RealWeight.ValueData, 0)          AS RealWeight

                  , COALESCE (MIFloat_ChangePercentAmount.ValueData, 0) AS ChangePercentAmount
                  , 0 AmountChangePercent

                  , COALESCE (MIFloat_Price.ValueData, 0) 		  AS Price
                  , COALESCE (MIFloat_CountForPrice.ValueData, 0) 	  AS CountForPrice
           
                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId
                                             
                  , tmpMovement.InvNumber_parent
                  , tmpMovement.OperDate_parent
                  , tmpMovement.MovementDescName
                  , tmpMovement.FromId
                  , tmpMovement.ToId
                  
             FROM tmpMovement
                  INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = FAlse

                  LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentAmount
                                              ON MIFloat_ChangePercentAmount.MovementItemId = MovementItem.Id
                                             AND MIFloat_ChangePercentAmount.DescId = zc_MIFloat_ChangePercentAmount()

                  LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                              ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                  LEFT JOIN MovementItemFloat AS MIFloat_RealWeight
                                              ON MIFloat_RealWeight.MovementItemId = MovementItem.Id
                                             AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight()

                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                              ON MIFloat_Price.MovementItemId = MovementItem.Id
                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                             AND tmpMovement.DescId_parent <> zc_Movement_Inventory()
                  LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                              ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                                             AND MIFloat_Price.ValueData <> 0 -- !!!временно!!!
                                             AND tmpMovement.DescId_parent <> zc_Movement_Inventory()

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

            UNION ALL
             SELECT  MovementItem.ObjectId AS GoodsId
                  , 0 AS Amount
                  , MovementItem.Amount AS Amount_mi

                  , 0                                             AS AmountPartner
                  , COALESCE (MIFloat_AmountPartner.ValueData, 0) AS AmountPartner_mi

                  , 0 AS RealWeight
                
                  , COALESCE (MIFloat_ChangePercentAmount.ValueData, 0) AS ChangePercentAmount
                  , COALESCE (MIFloat_AmountChangePercent.ValueData, 0) AS AmountChangePercent

                  , COALESCE (MIFloat_Price.ValueData, 0) 		  AS Price
                  , COALESCE (MIFloat_CountForPrice.ValueData, 0) 	  AS CountForPrice
           
                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                 
                  , tmpMovement.InvNumber_parent 
                  , tmpMovement.OperDate_parent
                  , tmpMovement.MovementDescName
                  , tmpMovement.FromId
                  , tmpMovement.ToId            

             FROM (SELECT tmpMovement.MovementId_parent
                        , tmpMovement.InvNumber_parent
                        , tmpMovement.OperDate_parent
                        , tmpMovement.MovementDescName
                        , tmpMovement.FromId
                        , tmpMovement.ToId  
                   FROM tmpMovement 
                   GROUP BY tmpMovement.MovementId_parent
                          , tmpMovement.InvNumber_parent
                          , tmpMovement.OperDate_parent
                          , tmpMovement.MovementDescName
                          , tmpMovement.FromId
                          , tmpMovement.ToId 
                 ) AS tmpMovement
                  INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId_parent
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = False

                  LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                              ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                  LEFT JOIN MovementItemFloat AS MIFloat_AmountChangePercent
                                              ON MIFloat_AmountChangePercent.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountChangePercent.DescId = zc_MIFloat_AmountChangePercent()
                  LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentAmount
                                              ON MIFloat_ChangePercentAmount.MovementItemId = MovementItem.Id
                                             AND MIFloat_ChangePercentAmount.DescId = zc_MIFloat_ChangePercentAmount()

                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                              ON MIFloat_Price.MovementItemId = MovementItem.Id
                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
                  LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                              ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                                             AND MIFloat_Price.ValueData <> 0 -- !!!временно!!!

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
           ) AS tmpMI
            GROUP BY tmpMI.GoodsId
                   , tmpMI.ChangePercentAmount
                   , tmpMI.Price
                   , tmpMI.CountForPrice
                   , tmpMI.GoodsKindId
                   , tmpMI.InvNumber_parent
                   , tmpMI.MovementDescName
                   , tmpMI.OperDate_parent
                   , tmpMI.FromId
                   , tmpMI.ToId
                   
            ) AS tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpMI.GoodsId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                                 
            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN Object AS Object_From ON Object_From.Id = tmpMI.FromId
            LEFT JOIN Object AS Object_To ON Object_To.Id = tmpMI.ToId
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 14.11.14         *
*/

-- тест
--SELECT * FROM gpReport_WeighingPartner (inStartDate:= '01.08.2015', inEndDate:= '01.08.2015', inSession:= zfCalc_UserAdmin())
--select * from gpReport_WeighingPartner(inStartDate := ('01.08.2015')::TDateTime , inEndDate := ('01.08.2015')::TDateTime , inMovementDescId := 8 ,  inSession := '5');
