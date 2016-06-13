-- Function: gpReport_ReturnInBySale ()

DROP FUNCTION IF EXISTS gpReport_ReturnInBySale (Integer, Integer, Integer, Tfloat, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ReturnInBySale (
    IN inMovementId        Integer   ,
    IN inGoodsId           Integer   ,
    IN inGoodsKindId       Integer   , --
    IN inPrice             Tfloat    , --
    IN inSession           TVarChar    -- ñåññèÿ ïîëüçîâàòåëÿ
)
RETURNS TABLE (Id Integer, MovementDescName TVarChar, StatusCode Integer
             , InvNumber TVarChar, InvNumberPartner TVarChar, OperDate TDateTime, OperDatePartner TDateTime
             , PartnerCode Integer, PartnerName TVarChar
             , BranchName TVarChar, UnitName TVarChar                        
             , PaidKindName TVarChar
             , ContractCode Integer, ContractName TVarChar

             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar, MeasureName TVarChar

             , Amount        TFloat  -- 
             --, AmountPartner TFloat  -- 
             , Price         TFloat  -- 
             ) 

AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

    -- Ðåçóëüòàò
    RETURN QUERY
      WITH 
      tmpMIChildReturn AS (SELECT MI_Child.ParentId
                                , MI_Child.Amount
                           FROM MovementItemFloat AS MIFloat_MovementIdSale
                                 INNER JOIN MovementItem AS MI_Child
                                                         ON MI_Child.Id       = MIFloat_MovementIdSale.MovementItemId 
                                                        AND MI_Child.DescId   = zc_MI_Child()
                                                        AND MI_Child.isErased = FALSE
                           WHERE MIFloat_MovementIdSale.ValueData = inMovementId
                             AND MIFloat_MovementIdSale.DescId    = zc_MIFloat_MovementId()
                             AND (MI_Child.ObjectId = inGoodsId OR inGoodsId = 0)
                           )
    , tmpMIReturn AS (SELECT MI_Master.MovementId
                           --, MI_Master.Amount                              AS Amount
                           , tmpMIChildReturn.Amount                       AS Amount
                           , MI_Master.ObjectId                            AS GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                           --, COALESCE (MIFloat_AmountPartner.ValueData, 0) AS AmountPartner
                           , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
                          
                      FROM tmpMIChildReturn
                         INNER JOIN MovementItem AS MI_Master
                                                 ON MI_Master.Id = tmpMIChildReturn.ParentId 
                                                AND MI_Master.DescId   = zc_MI_Master()
                                                AND MI_Master.isErased = FALSE
                         INNER JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MI_Master.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                          AND (COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = inGoodsKindId OR inGoodsKindId = 0)
                         INNER JOIN MovementItemFloat AS MIFloat_Price
                                                      ON MIFloat_Price.MovementItemId = MI_Master.Id
                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                     AND (COALESCE (MIFloat_Price.ValueData, 0) = inPrice OR inPrice = 0)
                         /*LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                     ON MIFloat_AmountPartner.MovementItemId = MI_Master.Id
                                                    AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()*/
                      )
     , tmpMovReturn AS (SELECT Movement.Id
                             , Movement.DescId                      AS MovementDescId
                             , Object_From.ObjectCode               AS PartnerCode
                             , Object_From.ValueData                AS PartnerName
                             , Object_To.ValueData                  AS UnitName
                             , Object_Branch.ValueData              AS BranchName
                             , Object_PaidKind.ValueData            AS PaidKindName
                             , View_Contract_InvNumber.ContractCode AS ContractCode
                             , View_Contract_InvNumber.InvNumber    AS ContractName
                             , Movement.InvNumber
                             , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
                             , Movement.OperDate
                             , CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN MovementDate_OperDatePartner.ValueData ELSE Movement.OperDate END AS OperDatePartner
                             , Object_Status.ObjectCode                  AS StatusCode
                              
                        FROM (SELECT DISTINCT tmpMIReturn.MovementId AS Id FROM tmpMIReturn
                             ) AS tmpMovement
                            LEFT JOIN Movement ON Movement.id = tmpMovement.id
                            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
              
                            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

                            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                   ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                  AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                  AND MovementLinkObject_From.DescId = CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN zc_MovementLinkObject_From() ELSE zc_MovementLinkObject_PartnerFrom() END
                            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                  AND MovementLinkObject_To.DescId = CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_Partner() END
                            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                   ON ObjectLink_Unit_Branch.ObjectId = Object_To.Id
                                  AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                   ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                  AND MovementLinkObject_PaidKind.DescId = CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN zc_MovementLinkObject_PaidKind() ELSE zc_MovementLinkObject_PaidKindFrom() END
                            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId
                            
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                   ON MovementLinkObject_Contract.MovementId = Movement.Id
                                  AND MovementLinkObject_Contract.DescId = CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN zc_MovementLinkObject_Contract() ELSE zc_MovementLinkObject_ContractFrom() END
                            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
                        )

      SELECT tmpMovReturn.Id
           , MovementDesc.ItemName AS MovementDescName
           , tmpMovReturn.StatusCode
           , tmpMovReturn.InvNumber
           , tmpMovReturn.InvNumberPartner
           , tmpMovReturn.OperDate
           , tmpMovReturn.OperDatePartner
           , tmpMovReturn.PartnerCode
           , tmpMovReturn.PartnerName
           , tmpMovReturn.BranchName
           , tmpMovReturn.UnitName
           , tmpMovReturn.PaidKindName
           , tmpMovReturn.ContractCode
           , tmpMovReturn.ContractName

           , Object_Goods.ObjectCode  		AS GoodsCode
           , Object_Goods.ValueData   		AS GoodsName
           , Object_GoodsKind.ValueData 	AS GoodsKindName
           , Object_Measure.ValueData           AS MeasureName
           , tmpMIReturn.Amount         ::TFloat
           --, tmpMIReturn.AmountPartner  ::TFloat
           , tmpMIReturn.Price          ::TFloat
      FROM tmpMIReturn
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMIReturn.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMIReturn.GoodsKindId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = tmpMIReturn.GoodsId
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN tmpMovReturn ON tmpMovReturn.Id = tmpMIReturn.MovementId
          LEFT JOIN MovementDesc ON MovementDesc.Id = tmpMovReturn.MovementDescId
     ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 16.05.15         * 
*/

-- òåñò
--SELECT * FROM gpReport_ReturnInBySale (inMovementId:= 0, inGoodsId:= 2507, inGoodsKindId:= 0, inPrice:=0, inSession:= zfCalc_UserAdmin()) limit 10 ; -- 
--select * from gpReport_ReturnInBySale(inMovementId := 3555574 , inGoodsId := 2153 , inGoodsKindId := 0 , inPrice := 0 ,  inSession := '5');