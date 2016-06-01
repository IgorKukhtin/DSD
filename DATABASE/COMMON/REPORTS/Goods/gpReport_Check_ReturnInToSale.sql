-- Function: gpReport_Check_ReturnInToSale ()

DROP FUNCTION IF EXISTS gpReport_Check_ReturnInToSale (TDateTime,TDateTime,Boolean, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Check_ReturnInToSale (
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inShowAll           Boolean ,
    IN inMovementId        Integer   ,
    IN inJuridicalId       Integer   ,
    IN inPartnerId         Integer   , --
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS TABLE (Movement_ReturnId Integer, StatusCode Integer
             , OperDate TDateTime, InvNumber TVarChar                   --, OperDatePartner TDateTime   ---InvNumberPartner TVarChar, 
             , PartnerCode Integer, PartnerName TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar
             , Price TFloat 

             , Movement_SaleId Integer, StatusCode_Sale Integer
             , OperDate_Sale TDateTime, InvNumber_Sale TVarChar
             , PartnerCode_Sale Integer, PartnerName_Sale TVarChar
             , GoodsCode_Sale Integer, GoodsName_Sale TVarChar, GoodsKindName_Sale TVarChar
             , Price_Sale TFloat 
             , isDiff Boolean
             , isDiffGoodsKind Boolean
             , isDiffPartner Boolean
             , isDiffPrice Boolean
             , isDiffStatus Boolean
             ) 

AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

    IF inJuridicalId = 0 AND inPartnerId = 0
    THEN inShowAll:= TRUE;
    END IF;

    -- ���������
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
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                          AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                          AND (MovementLinkObject_From.ObjectId = inPartnerId OR inPartnerId = 0)
                          AND (ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
                 )

    , tmpMIReturn AS (SELECT tmpMovReturn.Id
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
                                                    AND MIFloat_MovementId.ValueData <> 0                         
                         INNER JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                     ON MIFloat_MovementItemId.MovementItemId = MI_Child.Id
                                                    AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId() 
                     )

   , tmpData AS (SELECT tmpMIReturn.Id
                      , Movement_Sale.Id                                   AS Sale_Id
                      , tmpMIReturn.GoodsId
                      , tmpMIReturn.PartnerId                              AS PartnerId
                      , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)      AS GoodsKindId
                      , COALESCE (MIFloat_Price.ValueData, 0)              AS Price

                      , MISale.ObjectId                                    AS GoodsId_Sale
                      , MovementLinkObject_To.ObjectId                     AS PartnerId_Sale
                      , COALESCE (MILinkObject_GoodsKind_Sale.ObjectId, 0) AS GoodsKindId_Sale
                      , COALESCE (MIFloat_Price_Sale.ValueData, 0)         AS Price_Sale
             
                 FROM tmpMIReturn
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = tmpMIReturn.MI_Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                   LEFT JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = tmpMIReturn.MI_Id
                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
                   --SALE 
                   LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = tmpMIReturn.MovementId_sale
                   LEFT JOIN MovementItem AS MISale ON MISale.Id = tmpMIReturn.MovementItemId_sale
                                                
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind_Sale
                                                    ON MILinkObject_GoodsKind_Sale.MovementItemId = MISale.Id
                                                   AND MILinkObject_GoodsKind_Sale.DescId = zc_MILinkObject_GoodsKind()
                   LEFT JOIN MovementItemFloat AS MIFloat_Price_Sale
                                               ON MIFloat_Price_Sale.MovementItemId = MISale.Id
                                              AND MIFloat_Price_Sale.DescId = zc_MIFloat_Price()  
                   LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                ON MovementLinkObject_To.MovementId = Movement_Sale.Id
                                               AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            --   WHERE Movement_Sale.StatusId <> zc_Enum_Status_Complete()
             )

             SELECT Movement_Return.Id          AS Movement_ReturnId
                  , Object_Status.ObjectCode    AS StatusCode
                  , Movement_Return.OperDate    AS OperDate
                  , Movement_Return.InvNumber   AS InvNumber
                  , Object_Partner.ObjectCode   AS PartnerCode
                  , Object_Partner.ValueData    AS PartnerName
                  , Object_Goods.ObjectCode     AS GoodsCode
                  , Object_Goods.ValueData      AS GoodsName
                  , Object_GoodsKind.ValueData  AS GoodsKindName
                  , tmpData.Price :: Tfloat
                  
                  , Movement_Sale.Id                AS Movement_SaleId
                  , Object_StatusSale.ObjectCode    AS StatusCode_Sale
                  , Movement_Sale.OperDate          AS OperDate_Sale
                  , Movement_Sale.InvNumber         AS InvNumber_Sale
                  , Object_PartnerSale.ObjectCode   AS PartnerCode_Sale
                  , Object_PartnerSale.ValueData    AS PartnerName_Sale
                  , Object_GoodsSale.ObjectCode     AS GoodsCode_Sale
                  , Object_GoodsSale.ValueData      AS GoodsName_Sale
                  , Object_GoodsKindSale.ValueData  AS GoodsKindName_Sale
                  , tmpData.Price_Sale :: Tfloat

                  , CASE WHEN tmpData.GoodsId <> tmpData.GoodsId_Sale 
                         THEN TRUE
                         ELSE FALSE
                         END                      AS isDiff
                  , CASE WHEN tmpData.GoodsKindId <> tmpData.GoodsKindId_Sale
                         THEN TRUE
                         ELSE FALSE
                         END                      AS isDiffGoodsKind
                  , CASE WHEN tmpData.PartnerId <> tmpData.PartnerId_Sale
                         THEN TRUE
                         ELSE FALSE
                         END                      AS isDiffPartner
                  , CASE WHEN tmpData.Price <> tmpData.Price_Sale
                         THEN TRUE
                         ELSE FALSE
                         END                      AS isDiffPrice
                  , CASE WHEN COALESCE (Movement_Sale.StatusId, 0) <> zc_Enum_Status_Complete()
                         THEN TRUE
                         ELSE FALSE
                         END                      AS isDiffStatus
             FROM tmpData
                LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpData.PartnerId
                LEFT JOIN Object AS Object_PartnerSale ON Object_PartnerSale.Id = tmpData.PartnerId_Sale
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
                LEFT JOIN Object AS Object_GoodsSale ON Object_GoodsSale.Id = tmpData.GoodsId_Sale
                LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpData.GoodsKindId
                LEFT JOIN Object AS Object_GoodsKindSale ON Object_GoodsKindSale.Id = tmpData.GoodsKindId_Sale

                LEFT JOIN Movement AS Movement_Return ON Movement_Return.Id = tmpData.Id
                LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Return.StatusId

                LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = tmpData.Sale_Id
                LEFT JOIN Object AS Object_StatusSale ON Object_StatusSale.Id = Movement_Sale.StatusId
            WHERE (tmpData.GoodsId <> tmpData.GoodsId_Sale 
                OR tmpData.GoodsKindId <> tmpData.GoodsKindId_Sale 
                OR tmpData.PartnerId <> tmpData.PartnerId_Sale 
                OR tmpData.Price <> tmpData.Price_Sale
                OR Movement_Sale.StatusId <> zc_Enum_Status_Complete()
                  ) OR inShowAll = FALSE

       ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.05.15         * 
*/

-- ����
-- SELECT * FROM gpReport_Check_ReturnInToSale (inStartDate:= '2016-05-24' ::TDateTime , inEndDate:= '2016-05-24' ::TDateTime, inShowAll:= True, inMovementId:=0, inJuridicalId:= 0, inPartnerId:=0, inSession:= zfCalc_UserAdmin()) 
