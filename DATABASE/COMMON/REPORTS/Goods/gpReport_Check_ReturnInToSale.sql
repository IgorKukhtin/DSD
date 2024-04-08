-- Function: gpReport_Check_ReturnInToSale ()

DROP FUNCTION IF EXISTS gpReport_Check_ReturnInToSale (TDateTime,TDateTime,Boolean, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Check_ReturnInToSale (
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inShowAll           Boolean ,
    IN inMovementId        Integer   ,
    IN inJuridicalId       Integer   ,
    IN inPartnerId         Integer   , --
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Movement_ReturnId Integer, MovementDescName TVarChar, StatusCode Integer
             , OperDate TDateTime, InvNumber TVarChar , PaidKindName TVarChar                  --, OperDatePartner TDateTime   ---InvNumberPartner TVarChar, 
             , ContractCode Integer, ContractName TVarChar
             , PartnerCode Integer, PartnerName TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar
             , Amount TFloat, Price TFloat

             , Movement_SaleId Integer, StatusCode_Sale Integer
             , OperDate_Sale TDateTime, InvNumber_Sale TVarChar, PaidKindName_Sale TVarChar
             , ContractCode_Sale Integer, ContractName_Sale TVarChar

             , MovementId_Tax Integer, StatusCode_Tax Integer
             , OperDate_Tax TDateTime, InvNumber_Tax TVarChar, InvNumberPartner_Tax TVarChar, DocumentTaxKindName TVarChar
             , ContractCode_Tax Integer, ContractName_Tax TVarChar

             , PartnerCode_Sale Integer, PartnerName_Sale TVarChar
             , GoodsCode_Sale Integer, GoodsName_Sale TVarChar, GoodsKindName_Sale TVarChar
             , Price_Sale TFloat 
             , isDiff Boolean
             , isDiffGoodsKind Boolean
             , isDiffPartner Boolean
             , isDiffPrice Boolean
             , isDiffStatus Boolean
             , isDiffContract Boolean
             ) 

AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


    IF inJuridicalId = 0 AND inPartnerId = 0
    THEN inShowAll:= TRUE;
    END IF;
    -- !!!захардкодил временно!!!
    IF inMovementId = 0 THEN inShowAll:= TRUE; END IF;


    -- Результат
    RETURN QUERY
      WITH 
         tmpMovReturn_all AS (-- zc_Movement_ReturnIn
                              SELECT Movement.Id
                                   , Movement.DescId                      AS MovementDescId
                                   , COALESCE (MovementLinkObject_From.ObjectId, 0)     AS PartnerId
                                   , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId
                                   , MD_OperDatePartner.ValueData         AS OperDatePartner
                              FROM MovementDate AS MD_OperDatePartner
                                   INNER JOIN Movement ON Movement.Id = MD_OperDatePartner.MovementId
                                                      AND Movement.DescId   = zc_Movement_ReturnIn()
                                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                ON MovementLinkObject_From.MovementId = Movement.Id 
                                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                   LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                        ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                                       AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                               AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                              WHERE inMovementId = 0
                                AND MD_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                                AND MD_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                AND (MovementLinkObject_From.ObjectId = inPartnerId OR inPartnerId = 0)
                                AND (ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)

                             UNION ALL
                              -- zc_Movement_TransferDebtIn
                              SELECT Movement.Id
                                   , Movement.DescId                      AS MovementDescId
                                   , COALESCE (MovementLinkObject_Partner.ObjectId, 0)  AS PartnerId
                                   , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId
                                   , Movement.OperDate                    AS OperDatePartner
                              FROM Movement
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                                ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                               AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_PartnerFrom()
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                ON MovementLinkObject_From.MovementId = Movement.Id
                                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                               AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_ContractFrom()
                              WHERE inMovementId = 0
                                AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                AND Movement.DescId = zc_Movement_TransferDebtIn()
                                AND Movement.StatusId = zc_Enum_Status_Complete()
                                AND (MovementLinkObject_Partner.ObjectId = inPartnerId OR inPartnerId = 0)
                                AND (MovementLinkObject_From.ObjectId = inJuridicalId OR inJuridicalId = 0)

                             UNION ALL
                              -- zc_Movement_PriceCorrective
                              SELECT Movement.Id
                                   , Movement.DescId                      AS MovementDescId
                                   , COALESCE (MovementLinkObject_Partner.ObjectId, 0)  AS PartnerId
                                   , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId
                                   , Movement.OperDate                    AS OperDatePartner
                              FROM Movement
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                                ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                               AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                ON MovementLinkObject_From.MovementId = Movement.Id
                                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                               AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                              WHERE inMovementId = 0
                                AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                AND Movement.DescId = zc_Movement_PriceCorrective()
                                AND Movement.StatusId = zc_Enum_Status_Complete()
                                AND (MovementLinkObject_Partner.ObjectId = inPartnerId OR inPartnerId = 0)
                                AND (MovementLinkObject_From.ObjectId = inJuridicalId OR inJuridicalId = 0)

                             UNION ALL
                              -- current
                              SELECT Movement.Id                          AS Id
                                   , Movement.DescId                      AS MovementDescId
                                   , COALESCE (MovementLinkObject_From.ObjectId, 0)     AS PartnerId
                                   , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId
                                   , CASE WHEN Movement.DescId = zc_Movement_ReturnIn()
                                               THEN MD_OperDatePartner.ValueData
                                          WHEN Movement.DescId = zc_Movement_PriceCorrective()
                                               THEN Movement.OperDate
                                          ELSE Movement.OperDate
                                     END AS OperDatePartner
                              FROM Movement
                                   LEFT JOIN MovementDate AS MD_OperDatePartner
                                                          ON MD_OperDatePartner.MovementId = Movement.Id
                                                         AND MD_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                ON MovementLinkObject_From.MovementId = Movement.Id
                                                               AND MovementLinkObject_From.DescId = CASE WHEN Movement.DescId = zc_Movement_ReturnIn()
                                                                                                              THEN zc_MovementLinkObject_From()
                                                                                                         WHEN Movement.DescId = zc_Movement_PriceCorrective()
                                                                                                              THEN zc_MovementLinkObject_Partner()
                                                                                                         ELSE zc_MovementLinkObject_PartnerFrom()
                                                                                                    END
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                               AND MovementLinkObject_Contract.DescId = CASE WHEN Movement.DescId = zc_Movement_ReturnIn()
                                                                                                                  THEN zc_MovementLinkObject_Contract()
                                                                                                             WHEN Movement.DescId = zc_Movement_PriceCorrective()
                                                                                                                  THEN zc_MovementLinkObject_Contract()
                                                                                                             ELSE zc_MovementLinkObject_ContractFrom()
                                                                                                        END
                              WHERE Movement.Id = inMovementId
                             )
      , tmpMovReturn  AS (SELECT tmpMovReturn_all.Id
                               , tmpMovReturn_all.MovementDescId
                               , tmpMovReturn_all.PartnerId
                               , tmpMovReturn_all.OperDatePartner
                               , tmpMovReturn_all.ContractId
                          FROM tmpMovReturn_all
                         )
     , tmpMIChild_all AS (SELECT MI_Child.*
                          FROM MovementItem AS MI_Child
                          WHERE MI_Child.MovementId IN (SELECT DISTINCT tmpMovReturn.Id FROM tmpMovReturn)
                            AND MI_Child.DescId     = zc_MI_Child()
                            AND MI_Child.isErased   = FALSE
                         )
        , tmpMIReturn AS (SELECT   tmpMovReturn.Id
                                 , tmpMovReturn.MovementDescId
                                 , tmpMovReturn.PartnerId
                                 , tmpMovReturn.ContractId
                                 , MI_Child.ParentId                             AS MI_Id
                                 , MI_Child.ObjectId                             AS GoodsId
                                 , MI_Child.Amount                               AS Amount
                                 , MIFloat_MovementId.ValueData      :: Integer  AS MovementId_sale
                                 , MIFloat_MovementItemId.ValueData  :: Integer  AS MovementItemId_sale
                            FROM tmpMovReturn
                             INNER JOIN tmpMIChild_all AS MI_Child
                                                       ON MI_Child.MovementId = tmpMovReturn.Id
                                                      AND MI_Child.DescId     = zc_MI_Child()
                                                      AND MI_Child.isErased   = FALSE
    
                             INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                         ON MIFloat_MovementId.MovementItemId = MI_Child.Id
                                                        AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()                         
                                                        AND MIFloat_MovementId.ValueData > 0
                             INNER JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                         ON MIFloat_MovementItemId.MovementItemId = MI_Child.Id
                                                        AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId() 
                         )
   , tmpData_MILO_ret AS (SELECT MovementItemLinkObject.*
                          FROM MovementItemLinkObject
                          WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMIReturn.MI_Id FROM tmpMIReturn)
                            AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                         )
    , tmpData_MIF_ret AS (SELECT MovementItemFloat.*
                          FROM MovementItemFloat
                          WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMIReturn.MI_Id FROM tmpMIReturn)
                         )
    , tmpData_MI_sale AS (SELECT MISale.*
                               , Movement_Sale.StatusId AS StatusId
                               , Movement_Sale.DescId   AS MovementDescId
                          FROM tmpMIReturn
                               --SALE 
                               LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = tmpMIReturn.MovementId_sale
                               LEFT JOIN MovementItem AS MISale ON MISale.Id = tmpMIReturn.MovementItemId_sale
                         )
  , tmpData_MILO_sale AS (SELECT MovementItemLinkObject.*
                          FROM MovementItemLinkObject
                          WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpData_MI_sale.Id FROM tmpData_MI_sale)
                            AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                         )
   , tmpData_MIF_sale AS (SELECT MovementItemFloat.*
                          FROM MovementItemFloat
                          WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpData_MI_sale.Id FROM tmpData_MI_sale)
                            AND MovementItemFloat.DescId = zc_MIFloat_Price()  
                         )
  , tmpData AS (SELECT tmpMIReturn.Id
                      , tmpMIReturn.MovementDescId
                      , MISale.MovementId                                  AS Sale_Id
                      , tmpMIReturn.GoodsId
                      , tmpMIReturn.Amount
                      , tmpMIReturn.PartnerId                              AS PartnerId
                      , tmpMIReturn.ContractId
                      , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)      AS GoodsKindId
                      , COALESCE (MIFloat_PriceTax_calc.ValueData, MIFloat_Price.ValueData, 0) AS Price

                      , CASE WHEN MISale.isErased = TRUE OR MISale.StatusId <> zc_Enum_Status_Complete() THEN 0 ELSE MISale.ObjectId END AS GoodsId_Sale
                      , MovementLinkObject_To.ObjectId                     AS PartnerId_Sale
                      , COALESCE (MILinkObject_GoodsKind_Sale.ObjectId, 0) AS GoodsKindId_Sale
                      , COALESCE (MIFloat_Price_Sale.ValueData, 0)         AS Price_Sale
             
                 FROM tmpMIReturn
                   LEFT JOIN tmpData_MILO_ret AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = tmpMIReturn.MI_Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                   LEFT JOIN tmpData_MIF_ret AS MIFloat_Price
                                             ON MIFloat_Price.MovementItemId = tmpMIReturn.MI_Id
                                            AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                   LEFT JOIN tmpData_MIF_ret AS MIFloat_PriceTax_calc
                                             ON MIFloat_PriceTax_calc.MovementItemId = tmpMIReturn.MI_Id
                                            AND MIFloat_PriceTax_calc.DescId         = zc_MIFloat_PriceTax_calc()
                   --SALE 
                   LEFT JOIN tmpData_MI_sale AS MISale ON MISale.Id = tmpMIReturn.MovementItemId_sale
                                                
                   LEFT JOIN tmpData_MILO_sale AS MILinkObject_GoodsKind_Sale
                                                    ON MILinkObject_GoodsKind_Sale.MovementItemId = MISale.Id
                                                   AND MILinkObject_GoodsKind_Sale.DescId = zc_MILinkObject_GoodsKind()
                   LEFT JOIN tmpData_MIF_sale AS MIFloat_Price_Sale
                                              ON MIFloat_Price_Sale.MovementItemId = MISale.Id
                                             AND MIFloat_Price_Sale.DescId = zc_MIFloat_Price()  
                   LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                ON MovementLinkObject_To.MovementId = MISale.Id
                                               AND MovementLinkObject_To.DescId = CASE WHEN MISale.MovementDescId = zc_Movement_Sale() THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_Partner() END
            --   WHERE Movement_Sale.StatusId <> zc_Enum_Status_Complete()
             )
 
   , tmpMLO_PaidKind_return AS (SELECT MovementLinkObject.*
                                FROM MovementLinkObject
                                WHERE MovementLinkObject.DescId = zc_MovementLinkObject_PaidKind()
                                  AND MovementLinkObject.MovementId IN (SELECT DISTINCT tmpData.Id FROM tmpData)
                                )
   , tmpMLO_PaidKind_sale AS (SELECT MovementLinkObject.*
                              FROM MovementLinkObject
                              WHERE MovementLinkObject.DescId = zc_MovementLinkObject_PaidKind()
                                AND MovementLinkObject.MovementId IN (SELECT DISTINCT tmpData.Sale_Id FROM tmpData)
                              )            


             SELECT Movement_Return.Id          AS Movement_ReturnId
                  , MovementDesc.ItemName AS MovementDescName
                  , Object_Status.ObjectCode    AS StatusCode
                  , Movement_Return.OperDate    AS OperDate
                  , Movement_Return.InvNumber   AS InvNumber
                  , Object_PaidKind_return.ValueData           AS PaidKindName
                  , View_Contract_InvNumber.ContractCode       AS ContractCode
                  , View_Contract_InvNumber.InvNumber          AS ContractName
                  , Object_Partner.ObjectCode   AS PartnerCode
                  , Object_Partner.ValueData    AS PartnerName
                  , Object_Goods.ObjectCode     AS GoodsCode
                  , Object_Goods.ValueData      AS GoodsName
                  , Object_GoodsKind.ValueData  AS GoodsKindName
                  , tmpData.Amount :: Tfloat
                  , tmpData.Price  :: Tfloat
                  
                  , Movement_Sale.Id                                AS Movement_SaleId
                  , Object_StatusSale.ObjectCode                    AS StatusCode_Sale
                  , Movement_Sale.OperDate                          AS OperDate_Sale
                  , Movement_Sale.InvNumber                         AS InvNumber_Sale
                  , Object_PaidKind_sale.ValueData                  AS PaidKindName_Sale
                  , View_Contract_InvNumber_Sale.ContractCode       AS ContractCode_Sale
                  , View_Contract_InvNumber_Sale.InvNumber          AS ContractName_Sale

                  , Movement_Tax.Id                                 AS MovementId_Tax
                  , Object_StatusTax.ObjectCode                     AS StatusCode_Tax
                  , Movement_Tax.OperDate                           AS OperDate_Tax
                  , Movement_Tax.InvNumber                          AS InvNumber_Tax
                  , MS_InvNumberPartner_Tax.ValueData               AS InvNumberPartner_Tax
                  , Object_TaxKind.ValueData                        AS DocumentTaxKindName
                  , View_Contract_InvNumber_Tax.ContractCode        AS ContractCode_Tax
                  , View_Contract_InvNumber_Tax.InvNumber           AS ContractName_Tax

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
                           OR (COALESCE (Movement_Tax.StatusId, 0) <> zc_Enum_Status_Complete())-- AND Movement_Tax.Id > 0)
                         THEN TRUE
                         ELSE FALSE
                         END                      AS isDiffStatus
                         
                  , CASE WHEN tmpData.ContractId <> COALESCE (View_Contract_InvNumber_Sale.ContractId, 0)
                           OR (tmpData.ContractId <> COALESCE (View_Contract_InvNumber_Tax.ContractId, 0)) -- AND Movement_Tax.Id > 0)
                         THEN TRUE
                         ELSE FALSE
                         END                      AS isDiffContract
             FROM tmpData
                LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpData.PartnerId
                LEFT JOIN Object AS Object_PartnerSale ON Object_PartnerSale.Id = tmpData.PartnerId_Sale
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
                LEFT JOIN Object AS Object_GoodsSale ON Object_GoodsSale.Id = tmpData.GoodsId_Sale
                LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpData.GoodsKindId
                LEFT JOIN Object AS Object_GoodsKindSale ON Object_GoodsKindSale.Id = tmpData.GoodsKindId_Sale
                LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = tmpData.ContractId
                
                LEFT JOIN Movement AS Movement_Return ON Movement_Return.Id = tmpData.Id
                LEFT JOIN MovementDesc ON MovementDesc.Id = tmpData.MovementDescId
                LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Return.StatusId

                LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = tmpData.Sale_Id
                LEFT JOIN Object AS Object_StatusSale ON Object_StatusSale.Id = Movement_Sale.StatusId
                
                LEFT JOIN MovementLinkObject AS MLO_Contract_Sale
                                             ON MLO_Contract_Sale.MovementId = Movement_Sale.Id
                                            AND MLO_Contract_Sale.DescId = CASE WHEN Movement_Sale.DescId = zc_Movement_Sale() THEN zc_MovementLinkObject_Contract() ELSE zc_MovementLinkObject_ContractTo() END
                LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber_Sale ON View_Contract_InvNumber_Sale.ContractId = MLO_Contract_Sale.ObjectId                             
                
                LEFT JOIN MovementLinkMovement AS MLM_Tax
                                               ON MLM_Tax.MovementId = Movement_Sale.Id
                                              AND MLM_Tax.DescId = zc_MovementLinkMovement_Master()
                LEFT JOIN Movement AS Movement_Tax ON Movement_Tax.Id = MLM_Tax.MovementChildId
                LEFT JOIN Object AS Object_StatusTax ON Object_StatusTax.Id = Movement_Tax.StatusId

                LEFT JOIN MovementLinkObject AS MLO_Contract_Tax
                                             ON MLO_Contract_Tax.MovementId = Movement_Tax.Id
                                            AND MLO_Contract_Tax.DescId = zc_MovementLinkObject_Contract()
                LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber_Tax ON View_Contract_InvNumber_Tax.ContractId = MLO_Contract_Tax.ObjectId

                LEFT JOIN MovementLinkObject AS MLO_DocumentTaxKind
                                             ON MLO_DocumentTaxKind.MovementId = Movement_Tax.Id
                                            AND MLO_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                LEFT JOIN Object AS Object_TaxKind
                                 ON Object_TaxKind.Id = MLO_DocumentTaxKind.ObjectId
                                AND Movement_Tax.StatusId = zc_Enum_Status_Complete()

                LEFT JOIN MovementString AS MS_InvNumberPartner_Tax
                                         ON MS_InvNumberPartner_Tax.MovementId = Movement_Tax.Id
                                        AND MS_InvNumberPartner_Tax.DescId = zc_MovementString_InvNumberPartner()

                LEFT JOIN tmpMLO_PaidKind_return ON tmpMLO_PaidKind_return.MovementId = tmpData.Id
                LEFT JOIN Object AS Object_PaidKind_return ON Object_PaidKind_return.Id = tmpMLO_PaidKind_return.ObjectId
                
                LEFT JOIN tmpMLO_PaidKind_sale ON tmpMLO_PaidKind_sale.MovementId = tmpData.Sale_Id
                LEFT JOIN Object AS Object_PaidKind_sale ON Object_PaidKind_sale.Id = tmpMLO_PaidKind_sale.ObjectId

            WHERE (tmpData.GoodsId <> tmpData.GoodsId_Sale
                OR tmpData.GoodsKindId <> tmpData.GoodsKindId_Sale 
                OR tmpData.PartnerId <> tmpData.PartnerId_Sale 
                OR tmpData.Price <> tmpData.Price_Sale
                OR COALESCE (Movement_Sale.StatusId, 0) <> zc_Enum_Status_Complete()
                OR (COALESCE (Movement_Tax.StatusId, 0) <> zc_Enum_Status_Complete() AND Movement_Tax.Id > 0)
                OR tmpData.ContractId <> COALESCE (View_Contract_InvNumber_Sale.ContractId, 0)
                OR (tmpData.ContractId <> COALESCE (View_Contract_InvNumber_Tax.ContractId, 0) AND Movement_Tax.Id > 0)
                  ) OR inShowAll = FALSE

       ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.04.20         *
 30.05.15         * 
*/

-- тест
-- SELECT * FROM gpReport_Check_ReturnInToSale (inStartDate:= '01.04.2020', inEndDate:= '15.04.2020', inShowAll:= FALSE, inMovementId:= 0, inJuridicalId:= 0, inPartnerId:= 0, inSession:= zfCalc_UserAdmin());
