-- Function: gpReport_CheckAmount_ReturnInToSale ()

DROP FUNCTION IF EXISTS gpReport_CheckAmount_ReturnInToSale (TDateTime,TDateTime,Boolean, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CheckAmount_ReturnInToSale (
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inShowAll           Boolean ,
    IN inMovementId        Integer   ,
    IN inJuridicalId       Integer   ,
    IN inPartnerId         Integer   , --
    IN inSession           TVarChar    -- ñåññèÿ ïîëüçîâàòåëÿ
)
RETURNS TABLE (Id Integer, StatusCode Integer
             , OperDate TDateTime, InvNumber TVarChar, OperDatePartner TDateTime, InvNumberPartner TVarChar 
             , InvNumber_Master TVarChar, InvNumberPartner_Master TVarChar, OperDate_Master TDateTime, DocumentTaxKindName TVarChar
             
             , PartnerCode Integer, PartnerName TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar
             , GoodsGroupNameFull TVarChar, GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar
             , Price TFloat 

             , AmountSale TFloat, AmountInReturn TFloat, AmountReturn TFloat 
             , isError Boolean
             ) 

AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

    -- Ðåçóëüòàò
    RETURN QUERY
       WITH 
      tmpMovReturn  AS (SELECT Movement.Id
                             , MovementLinkObject_From.ObjectId AS PartnerId
                        FROM Movement 
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                    ON MovementLinkObject_From.MovementId = Movement.Id
                                   AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                   ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                  AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                        WHERE (Movement.id = inMovementId OR inMovementId = 0)
                          AND Movement.DescId = zc_Movement_ReturnIn()
                          AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                          AND (MovementLinkObject_From.ObjectId = inPartnerId OR inPartnerId = 0)
                          AND (ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
                 )

    , tmpMIChildReturn AS (SELECT tmpMovReturn.Id
                             , tmpMovReturn.PartnerId
                             , MI_Child.ParentId                             AS MI_Id
                             , MI_Child.ObjectId                             AS GoodsId
                             , MIFloat_MovementId.ValueData      :: Integer  AS MovementId_sale
                             , MIFloat_MovementItemId.ValueData  :: Integer  AS MovementItemId_sale
                        FROM tmpMovReturn
                         INNER JOIN MovementItem AS MI_Child
                                                ON MI_Child.MovementId = tmpMovReturn.Id
                                               AND MI_Child.DescId     = zc_MI_Child()
                                               AND MI_Child.isErased   = False
                        
                         INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                     ON MIFloat_MovementId.MovementItemId = MI_Child.Id
                                                    AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()                         
                                                    AND COALESCE (MIFloat_MovementId.ValueData,0) <> 0                         
                         INNER JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                     ON MIFloat_MovementItemId.MovementItemId = MI_Child.Id
                                                    AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId() 
                     )

       , tmpData AS ( select tmpMIChildReturn.MovementId_sale
                           , MI_Sale.Id                          AS MISaleId 
                           , MI_Return.ObjectId                  AS GoodsId
                           , MI_Sale.Amount                      AS AmountSale
                           , Sum(MI_Return.Amount)               AS Amount
                           , Sum(CASE WHEN Movement_Return.Operdate BETWEEN inStartDate AND inEndDate THEN MI_Return.Amount ELSE 0 END) AS AmountIn       --inStartDate AND inEndDate
                           , Sum(CASE WHEN Movement_Return.Operdate BETWEEN inStartDate AND inEndDate THEN 0 ELSE MI_Return.Amount END) AS AmountOut 
                      from tmpMIChildReturn
                         INNER JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                     ON MIFloat_MovementItemId.ValueData = tmpMIChildReturn.MovementItemId_sale    --MIFloat_MovementItemId.MovementItemId = MI_Child.Id
                                                    AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId() 
                         INNER JOIN MovementItem AS MI_Sale ON MI_Sale.Id = tmpMIChildReturn.MovementItemId_sale -- MIFloat_MovementId.MovementItemId--
                         
                         INNER JOIN MovementItem AS MI_Return ON MI_Return.Id = MIFloat_MovementItemId.MovementItemId  -- MIFloat_MovementId.MovementItemId--
                         INNER JOIN Movement AS Movement_Return ON Movement_Return.Id = MI_Return.MovementId
                                                               AND Movement_Return.DescId = zc_Movement_ReturnIn()
                         GROUP BY tmpMIChildReturn.MovementId_sale
                                , MI_Sale.Id
                                , MI_Return.ObjectId 
                                , MI_Sale.Amount
                      )   

             SELECT Movement_Sale.Id                AS Id
                  , Object_Status.ObjectCode        AS StatusCode
                  , Movement_Sale.OperDate          AS OperDate
                  , Movement_Sale.InvNumber         AS InvNumber
                  , MD_OperDatePartner.ValueData                AS OperDatePartner
                  , MovementString_InvNumberPartner.ValueData   AS InvNumberPartner

                  , Movement_DocumentMaster.InvNumber        AS InvNumber_Master
                  , MS_InvNumberPartner_Master.ValueData     AS InvNumberPartner_Master
                  , Movement_DocumentMaster.OperDate         AS OperDate_Master
                  , Object_TaxKind_Master.ValueData          AS DocumentTaxKindName
                           
                  , Object_Partner.ObjectCode       AS PartnerCode
                  , Object_Partner.ValueData        AS PartnerName

                  , Object_Juridical.ObjectCode AS JuridicalCode
                  , Object_Juridical.ValueData  AS JuridicalName
                  
                  , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                  , Object_Goods.ObjectCode         AS GoodsCode
                  , Object_Goods.ValueData          AS GoodsName
                  , Object_GoodsKind.ValueData      AS GoodsKindName
                  , COALESCE (MIFloat_Price.ValueData, 0)  :: Tfloat  AS Price

                  , tmpData.AmountSale   :: Tfloat
                  , tmpData.AmountIn     :: Tfloat AS AmountInReturn
                  , tmpData.Amount       :: Tfloat AS AmountReturn
                  , CASE WHEN tmpData.AmountSale < tmpData.Amount THEN TRUE ELSE FALSE END AS isError

             FROM tmpData
                LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = tmpData.MovementId_sale
                LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Sale.StatusId

                LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                         ON MovementString_InvNumberPartner.MovementId = Movement_Sale.Id 
                                        AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
                LEFT JOIN MovementDate AS MD_OperDatePartner
                                       ON MD_OperDatePartner.MovementId = Movement_Sale.Id 
                                      AND MD_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                                  
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
                LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                            ON MIFloat_Price.MovementItemId = tmpData.MISaleId
                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()  

                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                 ON MILinkObject_GoodsKind.MovementItemId = tmpData.MISaleId
                                                AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
                                           
                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement_Sale.Id
                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_To.ObjectId

                LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                     ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                                    AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId
                                                   
                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                               ON MovementLinkMovement_Master.MovementId = Movement_Sale.Id
                                              AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                LEFT JOIN Movement AS Movement_DocumentMaster ON Movement_DocumentMaster.Id = MovementLinkMovement_Master.MovementChildId
                LEFT JOIN MovementString AS MS_InvNumberPartner_Master
                                         ON MS_InvNumberPartner_Master.MovementId = MovementLinkMovement_Master.MovementChildId
                                        AND MS_InvNumberPartner_Master.DescId = zc_MovementString_InvNumberPartner()

                LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind_Master
                                             ON MovementLinkObject_DocumentTaxKind_Master.MovementId = Movement_DocumentMaster.Id 
                                            AND MovementLinkObject_DocumentTaxKind_Master.DescId = zc_MovementLinkObject_DocumentTaxKind()
                LEFT JOIN Object AS Object_TaxKind_Master 
                                 ON Object_TaxKind_Master.Id = MovementLinkObject_DocumentTaxKind_Master.ObjectId
                                AND Movement_DocumentMaster.StatusId = zc_Enum_Status_Complete()
             WHERE (tmpData.AmountSale < tmpData.Amount) OR inShowAll = TRUE
       ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 30.05.15         * 
*/

-- òåñò
--SELECT * FROM gpReport_CheckAmount_ReturnInToSale (inStartDate:= '2016-05-20' ::TDateTime , inEndDate:= '2016-05-20' ::TDateTime, inShowAll:= false, inMovementId:=0, inJuridicalId:= 0, inPartnerId:=97790, inSession:= zfCalc_UserAdmin()) 
--SELECT * FROM gpReport_CheckAmount_ReturnInToSale (inStartDate:= '2016-05-20' ::TDateTime , inEndDate:= '2016-05-20' ::TDateTime, inShowAll:= true, inMovementId:=0, inJuridicalId:= 0, inPartnerId:=97790, inSession:= zfCalc_UserAdmin()) 