 -- Function: gpReport_Sale_WeighingPartner_Compare()

DROP FUNCTION IF EXISTS gpReport_Sale_WeighingPartner_Compare (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Sale_WeighingPartner_Compare(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inUnitId             Integer   , --
    IN inGoodsId            Integer   , --
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementId Integer
             , InvNumber        TVarChar
             , OperDate         TDateTime
             , MovementDescName TVarChar
             , FromId           Integer
             , FromName         TVarChar
             , ToId             Integer
             , ToName           TVarChar
             , PaidKindName     TVarChar
             , ContractName     TVarChar
             , GoodsId          Integer
             , GoodsCode        Integer
             , GoodsName        TVarChar
             , GoodsKindId      Integer
             , GoodsKindName    TVarChar
             , GoodsGroupName     TVarChar
             , GoodsGroupNameFull TVarChar
             , MeasureName        TVarChar
             , Weight             TFloat
             , Amount           TFloat
             , AmountPartner    TFloat
             -- WeighingPartner
             , OperDate_wp            TVarChar
             , InvNumber_wp           TVarChar
             , InvNumberOrder_wp      TVarChar
             , UserName_wp            TVarChar 
             , FromName_wp            TVarChar 
             , ToName_wp              TVarChar 
             , PaidKindName_wp        TVarChar 
             , ContractName_wp        TVarChar
             , WeighingNumber_wp      TVarChar 
             , StartWeighing_wp       TDateTime 
             , EndWeighing_wp         TDateTime 
             , Amount_wp              TFloat   
             , AmountPartner_wp       TFloat   
             , AmountPartnerSecond_wp TFloat   
             , RealWeight_wp          TFloat   
             , CountTare_wp           TFloat   
             , WeightTare_wp          TFloat 
             , CountPack_wp           TFloat    
             
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
     WITH 
     tmpMovement_Sale AS (SELECT Movement.Id                       AS Id
                               , Movement.InvNumber                AS InvNumber
                               , Movement.OperDate                 AS OperDate
                               , MovementDesc.ItemName             AS MovementDescName 
                               , MovementLinkObject_From.ObjectId  AS FromId
                          FROM Movement
                             INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                         AND (MovementLinkObject_From.ObjectId = inUnitId OR inUnitId = 0)
                             LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
          
                          WHERE Movement.DescId IN (zc_Movement_Sale(), zc_Movement_SendOnPrice())
                            AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                            AND Movement.StatusId = zc_Enum_Status_Complete()
                         )
   , tmpMI_Sale AS (SELECT MovementItem.*
                    FROM MovementItem
                    WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement_Sale.Id FROM tmpMovement_Sale)
                      AND MovementItem.isErased = FALSE
                      AND MovementItem.DescId = zc_MI_Master()
                      AND (MovementItem.ObjectId = inGoodsId OR inGoodsId = 0)
                    )                     

   , tmpMLO_sale AS (SELECT MovementLinkObject.*
                     FROM MovementLinkObject
                     WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement_Sale.Id FROM tmpMovement_Sale)
                       AND MovementLinkObject.DescId IN (zc_MovementLinkObject_From()
                                                       , zc_MovementLinkObject_To()
                                                       , zc_MovementLinkObject_PaidKind()
                                                       , zc_MovementLinkObject_Contract()
                                                       )
                     )   
   , tmpMIFloat_sale AS (SELECT MovementItemFloat.*
                         FROM MovementItemFloat
                         WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Sale.Id FROM tmpMI_Sale)
                         )          
   , tmpMILO_sale AS (SELECT MovementItemLinkObject.*
                      FROM MovementItemLinkObject
                      WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_Sale.Id FROM tmpMI_Sale) 
                        AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                      )

    -- документы Взвешивания
   , tmpMovement_WeighingPartner AS (SELECT Movement.*
                                     FROM Movement
                                     WHERE Movement.ParentId IN (SELECT DISTINCT tmpMI_Sale.MovementId FROM tmpMI_Sale)
                                       AND Movement.DescId   = zc_Movement_WeighingPartner()
                                       AND Movement.StatusId <> zc_Enum_Status_Erased()
                                     )
                                    
   , tmpMI_WeighingPartner AS (SELECT MovementItem.*
                               FROM MovementItem
                               WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement_WeighingPartner.Id FROM tmpMovement_WeighingPartner)
                                 AND MovementItem.isErased = FALSE
                                 AND MovementItem.DescId = zc_MI_Master()
                                 AND (MovementItem.ObjectId = inGoodsId OR inGoodsId = 0)
                               )                                 
   , tmpMovementDate_wp AS (SELECT MovementDate.*
                            FROM MovementDate
                            WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement_WeighingPartner.Id FROM tmpMovement_WeighingPartner)
                              AND MovementDate.DescId IN (zc_MovementDate_StartWeighing()
                                                        , zc_MovementDate_EndWeighing()
                                                        )
                            ) 

   , tmpMovementFloat_wp AS (SELECT MovementFloat.*
                             FROM MovementFloat
                             WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement_WeighingPartner.Id FROM tmpMovement_WeighingPartner)
                               AND MovementFloat.DescId IN (zc_MovementFloat_WeighingNumber()
                                                         )
                             )

   , tmpMovementString_wp AS (SELECT MovementString.*
                             FROM MovementString
                             WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMovement_WeighingPartner.Id FROM tmpMovement_WeighingPartner)
                               AND MovementString.DescId IN (zc_MovementString_InvNumberOrder()
                                                         )
                             )

   , tmpMLO_wp AS (SELECT MovementLinkObject.*
                   FROM MovementLinkObject
                   WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement_WeighingPartner.Id FROM tmpMovement_WeighingPartner)
                     AND MovementLinkObject.DescId IN (zc_MovementLinkObject_From()
                                                     , zc_MovementLinkObject_To()
                                                     , zc_MovementLinkObject_PaidKind()
                                                     , zc_MovementLinkObject_Contract()
                                                     , zc_MovementLinkObject_User()
                                                     )
                   )   

   , tmpMLM_wp AS (SELECT MovementLinkMovement.*
                   FROM MovementLinkMovement
                   WHERE MovementLinkMovement.MovementId IN (SELECT DISTINCT tmpMovement_WeighingPartner.Id FROM tmpMovement_WeighingPartner)
                     AND MovementLinkMovement.DescId IN (zc_MovementLinkMovement_Order()
                                                     )
                   )

   , tmpMovementString_order AS (SELECT MovementString.*
                                 FROM MovementString
                                 WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMLM_wp.MovementChildId FROM tmpMLM_wp)
                                   AND MovementString.DescId IN (zc_MovementString_InvNumberPartner()
                                                             )
                                 )
 
   , tmpMIFloat_wp AS (SELECT MovementItemFloat.*
                       FROM MovementItemFloat
                       WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_WeighingPartner.Id FROM tmpMI_WeighingPartner)
                       )          
   , tmpMILO_wp AS (SELECT MovementItemLinkObject.*
                    FROM MovementItemLinkObject
                    WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_WeighingPartner.Id FROM tmpMI_WeighingPartner) 
                      AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                    ) 
     --
   , tmpData_wp AS (SELECT Movement.ParentId 
                         , STRING_AGG (DISTINCT Movement.InvNumber, ';' ) AS InvNumber 
                         , STRING_AGG (DISTINCT zfConvert_DateShortToString (Movement.OperDate) , ';' )   AS OperDate
                         , STRING_AGG (DISTINCT Object_From.ValueData, ';' )     AS FromName
                         , STRING_AGG (DISTINCT Object_To.ValueData, ';' )       AS ToName
                         , STRING_AGG (DISTINCT Object_PaidKind.ValueData, ';' ) AS PaidKindName
                         , STRING_AGG (DISTINCT Object_Contract.ValueData, ';' ) AS ContractName
                         , STRING_AGG (DISTINCT Object_User.ValueData, ';') AS UserName
                         , STRING_AGG (DISTINCT MovementFloat_WeighingNumber.ValueData ::TVarChar, ';' ) AS WeighingNumber
                         , MIN (MovementDate_StartWeighing.ValueData)            AS StartWeighing
                         , MAX (MovementDate_EndWeighing.ValueData)              AS EndWeighing

                         , STRING_AGG (DISTINCT (CASE WHEN MovementLinkMovement_Order.MovementChildId IS NOT NULL
                                                           THEN CASE WHEN Movement_Order.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                                                                          THEN ''
                                                                     ELSE '???'
                                                                END
                                                             || CASE WHEN TRIM (COALESCE (MovementString_InvNumberPartner_Order.ValueData, '')) <> ''
                                                                          THEN MovementString_InvNumberPartner_Order.ValueData
                                                                     ELSE '***' || Movement_Order.InvNumber
                                                                END
                                                      ELSE MovementString_InvNumberOrder.ValueData
                                                 END)
                                       , ';' ) :: TVarChar AS InvNumberOrder
                         --
                         , MovementItem.ObjectId                                     AS GoodsId
                         , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)             AS GoodsKindId
                         , SUM (COALESCE (MovementItem.Amount, 0))                   AS Amount           --Кол-во (склад)
                         , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0))       AS AmountPartner    --Кол-во со скидкой
                         , SUM (COALESCE (MIFloat_AmountPartnerSecond.ValueData, 0)) AS AmountPartnerSecond   --Кол-во Поставщика
                         , SUM (COALESCE (MIFloat_RealWeight.ValueData, 0))          AS RealWeight
                         , SUM (COALESCE (MIFloat_CountTare.ValueData, 0))           AS CountTare 
                         , SUM (COALESCE (MIFloat_WeightTare.ValueData, 0))          AS WeightTare
                        -- , CASE WHEN inShowAll = TRUE THEN COALESCE (MIFloat_WeightTare.ValueData, 0) ELSE 0 END AS WeightTare  --Вес 1 тары
                         , SUM (CASE WHEN COALESCE (MIFloat_WeightPack.ValueData,0) > 0 THEN 0 ELSE COALESCE (MIFloat_CountPack.ValueData, 0) END) AS CountPack  --Кол. упаковок
                        -- , MIFloat_WeightPack.ValueData  ::TFloat AS WeightPack   --Вес  1-ой уп.    
                        -- , COALESCE (MIFloat_ChangePercentAmount.ValueData, 0) AS ChangePercentAmount   --% скидки вес
                    FROM tmpMovement_WeighingPartner AS Movement
                         LEFT JOIN tmpMLO_wp AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                         LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                         LEFT JOIN tmpMLO_wp AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                         LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
             
                         LEFT JOIN tmpMLO_wp AS MovementLinkObject_PaidKind
                                             ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                            AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                         LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId
             
                         LEFT JOIN tmpMLO_wp AS MovementLinkObject_Contract
                                             ON MovementLinkObject_Contract.MovementId = Movement.Id
                                            AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                         LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

                         LEFT JOIN tmpMLO_wp AS MovementLinkObject_User
                                             ON MovementLinkObject_User.MovementId = Movement.Id
                                            AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
                         LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId

                         LEFT JOIN tmpMovementString_wp AS MovementString_InvNumberOrder
                                                        ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                                       AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
                         LEFT JOIN tmpMLM_wp AS MovementLinkMovement_Order
                                             ON MovementLinkMovement_Order.MovementId = Movement.Id
                                            AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                         LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MovementLinkMovement_Order.MovementChildId

                         LEFT JOIN tmpMovementString_order AS MovementString_InvNumberPartner_Order
                                                  ON MovementString_InvNumberPartner_Order.MovementId = Movement_Order.Id
                                                 AND MovementString_InvNumberPartner_Order.DescId = zc_MovementString_InvNumberPartner()

                         LEFT JOIN tmpMovementDate_wp AS MovementDate_StartWeighing
                                                      ON MovementDate_StartWeighing.MovementId = Movement.Id
                                                     AND MovementDate_StartWeighing.DescId = zc_MovementDate_StartWeighing()
                         LEFT JOIN tmpMovementDate_wp AS MovementDate_EndWeighing
                                                      ON MovementDate_EndWeighing.MovementId = Movement.Id
                                                     AND MovementDate_EndWeighing.DescId = zc_MovementDate_EndWeighing()
                         LEFT JOIN tmpMovementFloat_wp AS MovementFloat_WeighingNumber
                                                       ON MovementFloat_WeighingNumber.MovementId = Movement.Id
                                                      AND MovementFloat_WeighingNumber.DescId = zc_MovementFloat_WeighingNumber()

                         --
                         INNER JOIN tmpMI_WeighingPartner AS MovementItem ON MovementItem.MovementId = Movement.Id
                         
                         LEFT JOIN tmpMILO_wp AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                         LEFT JOIN tmpMIFloat_wp AS MIFloat_AmountPartner
                                                 ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                         LEFT JOIN tmpMIFloat_wp AS MIFloat_AmountPartnerSecond
                                                 ON MIFloat_AmountPartnerSecond.MovementItemId = MovementItem.Id
                                                AND MIFloat_AmountPartnerSecond.DescId = zc_MIFloat_AmountPartnerSecond()
                         LEFT JOIN tmpMIFloat_wp AS MIFloat_RealWeight
                                                 ON MIFloat_RealWeight.MovementItemId = MovementItem.Id
                                                AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight()
                         LEFT JOIN tmpMIFloat_wp AS MIFloat_CountTare
                                                 ON MIFloat_CountTare.MovementItemId = MovementItem.Id
                                                AND MIFloat_CountTare.DescId = zc_MIFloat_CountTare()
                         LEFT JOIN tmpMIFloat_wp AS MIFloat_WeightTare
                                                 ON MIFloat_WeightTare.MovementItemId = MovementItem.Id
                                                AND MIFloat_WeightTare.DescId = zc_MIFloat_WeightTare()
                         LEFT JOIN tmpMIFloat_wp AS MIFloat_CountPack
                                                 ON MIFloat_CountPack.MovementItemId = MovementItem.Id
                                                AND MIFloat_CountPack.DescId = zc_MIFloat_CountPack()
                         LEFT JOIN tmpMIFloat_wp AS MIFloat_WeightPack
                                                 ON MIFloat_WeightPack.MovementItemId = MovementItem.Id
                                                AND MIFloat_WeightPack.DescId = zc_MIFloat_WeightPack() 
                  /*LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentAmount
                                              ON MIFloat_ChangePercentAmount.MovementItemId = MovementItem.Id
                                             AND MIFloat_ChangePercentAmount.DescId = zc_MIFloat_ChangePercentAmount() */

                    GROUP BY Movement.ParentId
                           , MovementItem.ObjectId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                    )

   , tmpData_sale AS (SELECT Movement.Id                       AS MovementId
                           , Movement.InvNumber                AS InvNumber
                           , Movement.OperDate                 AS OperDate
                           , Movement.MovementDescName         AS MovementDescName 
                           , Movement.FromId                   AS FromId 
                           , Object_From.ValueData             AS FromName
                           , Object_To.Id                      AS ToId
                           , Object_To.ValueData               AS ToName
                           , Object_PaidKind.ValueData         AS PaidKindName
                           , Object_Contract.ValueData         AS ContractName
                           --
                           , MovementItem.ObjectId                          AS GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId
                           , Object_GoodsKind.ValueData                     AS GoodsKindName
                           , COALESCE (MovementItem.Amount, 0)              AS Amount
                           , COALESCE (MIFloat_AmountPartner.ValueData, 0)  AS AmountPartner   
                      FROM tmpMovement_Sale AS Movement
                         LEFT JOIN Object AS Object_From ON Object_From.Id = Movement.FromId

                         LEFT JOIN tmpMLO_sale AS MovementLinkObject_To
                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                              AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                         LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
             
                         LEFT JOIN tmpMLO_sale AS MovementLinkObject_PaidKind
                                               ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                              AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                         LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId
             
                         LEFT JOIN tmpMLO_sale AS MovementLinkObject_Contract
                                               ON MovementLinkObject_Contract.MovementId = Movement.Id
                                              AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                         LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId
                         --
                         INNER JOIN tmpMI_Sale AS MovementItem ON MovementItem.MovementId = Movement.Id
                         
                         LEFT JOIN tmpMILO_sale AS MILinkObject_GoodsKind
                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                               AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                         LEFT JOIN tmpMIFloat_sale AS MIFloat_AmountPartner
                                                   ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                  AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()

                         LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                      )

 , tmpGoods_param AS (SELECT Object_GoodsGroup.Id           AS GoodsGroupId
                           , Object_GoodsGroup.ValueData    AS GoodsGroupName
                           , ObjectString_Goods_GroupNameFull.ValueData  AS GoodsGroupNameFull
                           , COALESCE(Object_Goods.Id, 0)   AS GoodsId
                           , Object_Goods.ObjectCode        AS GoodsCode
                           , Object_Goods.ValueData         AS GoodsName
                           , Object_Measure.Id              AS MeasureId
                           , Object_Measure.ValueData       AS MeasureName  
                           , ObjectFloat_Weight.ValueData   AS Weight
                      
                      FROM (SELECT DISTINCT tmpData_sale.GoodsId FROM tmpData_sale) AS tmpGoods
                          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoods.GoodsId

                          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                               ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpGoods.GoodsId
                                              AND ObjectLink_Goods_GoodsGroup.DescId in (zc_ObjectLink_Goods_GoodsGroup(), zc_ObjectLink_Asset_AssetGroup())
                          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure 
                                               ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                                 ON ObjectString_Goods_GroupNameFull.ObjectId = tmpGoods.GoodsId
                                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()
                          LEFT JOIN ObjectFloat AS ObjectFloat_Weight ON ObjectFloat_Weight.ObjectId = tmpGoods.GoodsId
                                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                  )


       ----
       SELECT --SALE
              tmpData_sale.MovementId       ::Integer
            , tmpData_sale.InvNumber        ::TVarChar
            , tmpData_sale.OperDate         ::TDateTime
            , tmpData_sale.MovementDescName ::TVarChar
            , tmpData_sale.FromId           ::Integer
            , tmpData_sale.FromName         ::TVarChar
            , tmpData_sale.ToId             ::Integer
            , tmpData_sale.ToName           ::TVarChar
            , tmpData_sale.PaidKindName     ::TVarChar
            , tmpData_sale.ContractName     ::TVarChar
            --
            , tmpGoods_param.GoodsId        ::Integer
            , tmpGoods_param.GoodsCode      ::Integer
            , tmpGoods_param.GoodsName      ::TVarChar
            , tmpData_sale.GoodsKindId      ::Integer
            , tmpData_sale.GoodsKindName    ::TVarChar

            , tmpGoods_param.GoodsGroupName     ::TVarChar
            , tmpGoods_param.GoodsGroupNameFull ::TVarChar
            , tmpGoods_param.MeasureName        ::TVarChar
            , tmpGoods_param.Weight             ::TFloat

            , tmpData_sale.Amount           ::TFloat
            , tmpData_sale.AmountPartner    ::TFloat

            -- WeighingPartner 
            , tmpData_wp.OperDate           ::TVarChar AS OperDate_wp
            , tmpData_wp.InvNumber          ::TVarChar AS InvNumber_wp
            , tmpData_wp.InvNumberOrder     ::TVarChar AS InvNumberOrder_wp
            , tmpData_wp.UserName           ::TVarChar AS UserName_wp
            , tmpData_wp.FromName           ::TVarChar AS FromName_wp
            , tmpData_wp.ToName             ::TVarChar AS ToName_wp
            , tmpData_wp.PaidKindName       ::TVarChar AS PaidKindName_wp
            , tmpData_wp.ContractName       ::TVarChar AS ContractName_wp
            , tmpData_wp.WeighingNumber     ::TVarChar AS WeighingNumber_wp
            , tmpData_wp.StartWeighing      ::TDateTime AS StartWeighing_wp
            , tmpData_wp.EndWeighing        ::TDateTime AS EndWeighing_wp
            --
            , tmpData_wp.Amount             ::TFloat   AS Amount_wp
            , tmpData_wp.AmountPartner      ::TFloat   AS AmountPartner_wp   
            , tmpData_wp.AmountPartnerSecond::TFloat   AS AmountPartnerSecond_wp
            , tmpData_wp.RealWeight         ::TFloat   AS RealWeight_wp
            , tmpData_wp.CountTare          ::TFloat   AS CountTare_wp 
            , tmpData_wp.WeightTare         ::TFloat   AS WeightTare_wp
            , tmpData_wp.CountPack          ::TFloat   AS CountPack_wp 
       FROM tmpData_sale
            LEFT JOIN tmpData_wp ON tmpData_wp.ParentId = tmpData_sale.MovementId
                                AND tmpData_wp.GoodsId = tmpData_sale.GoodsId
                                AND tmpData_wp.GoodsKindId = tmpData_sale.GoodsKindId

            LEFT JOIN tmpGoods_param ON tmpGoods_param.GoodsId = tmpData_sale.GoodsId

     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.08.26         *
*/

-- тест
--    select * from gpReport_Sale_WeighingPartner_Compare(inStartDate := ('01.07.2026')::TDateTime , inEndDate := ('01.07.2026')::TDateTime , inUnitId := 8411  , inGoodsId:= 867684,   inSession := '5');



--select * from gpSelect_MovementItem_WeighingPartner(inMovementId := 34664657 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '9457');

--select * from Object WHERE ObjectCode = 1210

--select * from gpGet_Movement_WeighingPartner(inMovementId := 34664657 ,  inSession := '9457');


--SELECT zfConvert_DateShortToString (CURRENT_TIMESTAMP)
