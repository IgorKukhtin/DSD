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
             , AmountBeforeReturn TFloat, AmountAfterReturn TFloat 
             , isError Boolean
             ) 

AS
$BODY$
 DECLARE vbUserId Integer;
 DECLARE vbTaxKind_null  Boolean;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

     vbTaxKind_null:= inShowAll;

    IF inJuridicalId = 0 AND inPartnerId = 0
    THEN inShowAll:= TRUE;
    END IF;
    inShowAll:= TRUE;

    -- Ðåçóëüòàò
    RETURN QUERY
       WITH 
      tmpMovReturn  AS (SELECT tmp.Id
                             , tmp.PartnerId
                             , tmp.OperDatePartner
                        FROM (SELECT Movement.Id
                                   , MovementLinkObject_From.ObjectId AS PartnerId
                                   , NULL                             AS OperDatePartner
                              FROM MovementDate AS MD_OperDatePartner
                                   INNER JOIN Movement ON Movement.Id = MD_OperDatePartner.MovementId
                                                      AND Movement.DescId   = zc_Movement_ReturnIn()
                                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                ON MovementLinkObject_From.MovementId = MD_OperDatePartner.MovementId
                                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                   LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                        ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                                       AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                                                ON MovementLinkObject_DocumentTaxKind.MovementId = MD_OperDatePartner.MovementId
                                                               AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()

                              WHERE inMovementId = 0
                                AND MD_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                                AND MD_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                AND (MovementLinkObject_From.ObjectId = inPartnerId OR inPartnerId = 0)
                                AND (ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
                                AND (COALESCE (MovementLinkObject_DocumentTaxKind.ObjectId, 0) IN (0, zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS(), zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())
                                  OR vbTaxKind_null = FALSE)
                             UNION ALL
                              SELECT MD_OperDatePartner.MovementId    AS Id
                                   , MovementLinkObject_From.ObjectId AS PartnerId
                                   , MD_OperDatePartner.ValueData     AS OperDatePartner
                              FROM MovementDate AS MD_OperDatePartner
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                ON MovementLinkObject_From.MovementId = MD_OperDatePartner.MovementId
                                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                                                ON MovementLinkObject_DocumentTaxKind.MovementId = MD_OperDatePartner.MovementId
                                                               AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                              WHERE MD_OperDatePartner.MovementId = inMovementId
                                AND MD_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                AND (COALESCE (MovementLinkObject_DocumentTaxKind.ObjectId, 0) IN (0, zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS(), zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())
                                  OR vbTaxKind_null = FALSE)
                             ) AS tmp
                       )

    , tmpMIChildReturn AS (SELECT DISTINCT
                                  tmpMovReturn.OperDatePartner
                                , MIFloat_MovementId.ValueData      :: Integer AS MovementId_sale
                                , MIFloat_MovementItemId.ValueData  :: Integer AS MovementItemId_sale
                           FROM tmpMovReturn
                                INNER JOIN MovementItem AS MI_Child
                                                        ON MI_Child.MovementId = tmpMovReturn.Id
                                                       AND MI_Child.DescId     = zc_MI_Child()
                                                       AND MI_Child.isErased   = FALSE
                                INNER JOIN MovementItem AS MI_Master
                                                        ON MI_Master.Id = MI_Child.ParentId
                                                       AND MI_Master.isErased   = FALSE

                                INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                             ON MIFloat_MovementId.MovementItemId = MI_Child.Id
                                                            AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()                         
                                                            AND MIFloat_MovementId.ValueData > 0
                                INNER JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                             ON MIFloat_MovementItemId.MovementItemId = MI_Child.Id
                                                            AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId() 
                     )

        , tmpData AS (SELECT tmpMIChildReturn.MovementId_sale
                           , tmpMIChildReturn.MovementItemId_sale
                           , MI_Sale.ObjectId                                            AS GoodsId
                           , MIFloat_AmountPartner_Sale.ValueData                        AS AmountSale
                           , SUM (COALESCE (MIFloat_AmountPartner_Return.ValueData, 0))  AS Amount

                           , Sum(CASE WHEN inMovementId = 0 THEN
                                           CASE WHEN MD_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate THEN COALESCE (MIFloat_AmountPartner_Return.ValueData, 0) ELSE 0 END
                                           ELSE 
                                           CASE WHEN (Movement_Return.Id = inMovementId) THEN COALESCE (MIFloat_AmountPartner_Return.ValueData, 0) ELSE 0 END
                                 END ) AS AmountIn  
                           , Sum(CASE WHEN inMovementId = 0 THEN
                                           CASE WHEN MD_OperDatePartner.ValueData < inStartDate THEN COALESCE (MIFloat_AmountPartner_Return.ValueData, 0) ELSE 0 END
                                           ELSE 
                                           CASE WHEN MD_OperDatePartner.ValueData < tmpMIChildReturn.OperDatePartner THEN COALESCE (MIFloat_AmountPartner_Return.ValueData, 0) ELSE 0 END
                                 END ) AS AmountOutBefore  
                           , Sum(CASE WHEN inMovementId = 0 THEN
                                           CASE WHEN MD_OperDatePartner.ValueData > inEndDate THEN COALESCE (MIFloat_AmountPartner_Return.ValueData, 0) ELSE 0 END
                                           ELSE 
                                           CASE WHEN (MD_OperDatePartner.ValueData >= tmpMIChildReturn.OperDatePartner AND Movement_Return.Id <> inMovementId) THEN COALESCE (MIFloat_AmountPartner_Return.ValueData, 0) ELSE 0 END
                                 END ) AS AmountOutAfter                             

                      FROM tmpMIChildReturn
                           INNER JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                        ON MIFloat_MovementItemId.ValueData = tmpMIChildReturn.MovementItemId_sale
                                                       AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId() 
                           INNER JOIN MovementItem AS MI_Sale ON MI_Sale.Id = tmpMIChildReturn.MovementItemId_sale
                         
                           INNER JOIN MovementItem AS MI_Return ON MI_Return.Id       = MIFloat_MovementItemId.MovementItemId
                                                               AND MI_Return.isErased = FALSE
                           INNER JOIN MovementItem AS MI_Master
                                                   ON MI_Master.Id         = MI_Return.ParentId
                                                  AND MI_Master.isErased   = FALSE
                           INNER JOIN Movement AS Movement_Return ON Movement_Return.Id       = MI_Return.MovementId
                                                                 AND Movement_Return.DescId   = zc_Movement_ReturnIn()
                                                                 AND Movement_Return.StatusId = zc_Enum_Status_Complete()
                           LEFT JOIN MovementDate AS MD_OperDatePartner
                                                  ON MD_OperDatePartner.MovementId = Movement_Return.Id
                                                 AND MD_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner_Sale
                                                       ON MIFloat_AmountPartner_Sale.MovementItemId = MI_Sale.Id
                                                      AND MIFloat_AmountPartner_Sale.DescId = zc_MIFloat_AmountPartner()
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner_Return
                                                       ON MIFloat_AmountPartner_Return.MovementItemId = MI_Return.ParentId
                                                      AND MIFloat_AmountPartner_Return.DescId = zc_MIFloat_AmountPartner()

                         GROUP BY tmpMIChildReturn.MovementId_sale
                                , tmpMIChildReturn.MovementItemId_sale
                                , MI_Sale.ObjectId
                                , MIFloat_AmountPartner_Sale.ValueData
                         HAVING MIFloat_AmountPartner_Sale.ValueData < SUM (COALESCE (MIFloat_AmountPartner_Return.ValueData, 0))
                             OR inShowAll = FALSE
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
                  , tmpData.AmountOutBefore      :: Tfloat AS AmountBeforeReturn
                  , tmpData.AmountOutAfter       :: Tfloat AS AmountAfterReturn
                  
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
                                            ON MIFloat_Price.MovementItemId = tmpData.MovementItemId_sale
                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()  

                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                 ON MILinkObject_GoodsKind.MovementItemId = tmpData.MovementItemId_sale
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
             WHERE (tmpData.AmountSale < tmpData.Amount) OR inShowAll = FALSE
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
-- SELECT * FROM gpReport_CheckAmount_ReturnInToSale (inStartDate:= '2016-05-20' ::TDateTime , inEndDate:= '2016-05-20' ::TDateTime, inShowAll:= false, inMovementId:= 0, inJuridicalId:= 0, inPartnerId:=97790, inSession:= zfCalc_UserAdmin()) 
-- SELECT * FROM gpReport_CheckAmount_ReturnInToSale (inStartDate:= '2016-05-20' ::TDateTime , inEndDate:= '2016-05-20' ::TDateTime, inShowAll:= false, inMovementId:= 3650319  , inJuridicalId:= 0, inPartnerId:=97790, inSession:= zfCalc_UserAdmin()) 
