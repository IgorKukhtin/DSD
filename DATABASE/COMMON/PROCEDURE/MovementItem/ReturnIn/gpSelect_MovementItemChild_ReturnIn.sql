-- Function: gpSelect_MovementItem_SalePartion()

DROP FUNCTION IF EXISTS gpSelect_MovementItemChild_TransferDebtIn (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItemChild_ReturnIn (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItemChild_ReturnIn(
    IN inMovementId  Integer      , -- ключ Документа
    IN inisErased    Boolean      , -- Показать все
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer, Amount TFloat
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , AmountPartner TFloat, Price TFloat
             , MovementItemId_sale Integer, MovementId_sale Integer, InvNumber TVarChar, InvNumberPartner TVarChar, OperDate TDateTime, OperDatePartner TDateTime
             , ContractCode_Sale Integer, ContractName_Sale TVarChar
             , MovementId_tax Integer, InvNumber_Master TVarChar, InvNumberPartner_Master TVarChar, OperDate_Master TDateTime
             , DocumentTaxKindName TVarChar
             , ContractCode_Tax Integer, ContractName_Tax TVarChar
             , FromName TVarChar
             , ToCode Integer
             , ToName TVarChar
             , JuridicalName TVarChar
             , DescName_Sale TVarChar
             , ChangePercent_Sale TFloat, MovementPromo_Sale TVarChar
             , isError  Boolean
             , isErased Boolean
              )
AS
$BODY$
    DECLARE vbUserId     Integer;
    DECLARE vbPartnerId  Integer;
    DECLARE vbContractId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Sale());
    vbUserId:= lpGetUserBySession (inSession);


    -- Контрагент
    vbPartnerId:= (SELECT CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN MLO.ObjectId ELSE MLO_Partner.ObjectId END FROM Movement LEFT JOIN MovementLinkObject AS MLO ON MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From() LEFT JOIN MovementLinkObject AS MLO_Partner ON MLO_Partner.MovementId = inMovementId AND MLO_Partner.DescId = zc_MovementLinkObject_PartnerFrom() WHERE Movement.Id = inMovementId);
    -- Договор
    vbContractId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractFrom()));



    -- РЕЗУЛЬТАТ
    RETURN QUERY
   WITH tmpMI_all AS (SELECT MovementItem.Id                               AS MI_Id
                           , MovementItem.ParentId                         AS MI_ParentId
                           , MovementItem.ObjectId                         AS GoodsId

                           , MovementItem.Amount                          AS Amount
                           , MIFloat_MovementId.ValueData      :: Integer AS MovementId_sale
                           , MIFloat_MovementItemId.ValueData  :: Integer AS MovementItemId_sale
                           , CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) = 0 THEN TRUE ELSE MovementItem.isErased END :: Boolean AS isErased
                      FROM MovementItem  
                           LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                       ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                      AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()                         
                           LEFT JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                       ON MIFloat_MovementItemId.MovementItemId = MovementItem.Id
                                                      AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId() 
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Child()
                      )
  , tmpMIParent_MILO AS (SELECT MILO.*
                         FROM MovementItemLinkObject AS MILO
                         WHERE MILO.MovementItemId IN (SELECT DISTINCT tmpMI_all.MI_ParentId FROM tmpMI_all)
                           AND MILO.DescId         = zc_MILinkObject_GoodsKind()
                        )
   , tmpMIParent_MIF AS (SELECT MIF.*
                         FROM MovementItemFloat AS MIF
                         WHERE MIF.MovementItemId IN (SELECT DISTINCT tmpMI_all.MI_ParentId FROM tmpMI_all)
                           AND MIF.DescId         = zc_MIFloat_Price()
                        )
          , tmpMI AS (SELECT tmpMI_all.*
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                           , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
                      FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                           LEFT JOIN tmpMI_all ON tmpMI_all.isErased = tmpIsErased.isErased
                           LEFT JOIN tmpMIParent_MIF AS MIFloat_Price
                                                     ON MIFloat_Price.MovementItemId = tmpMI_all.MI_ParentId
                                                    AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                           LEFT JOIN tmpMIParent_MILO AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = tmpMI_all.MI_ParentId
                                                     AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                      )
       -- результат
       SELECT tmpMI.MI_Id                                    AS Id
            , tmpMI.MI_ParentId                              AS ParentId
            , tmpMI.Amount                                   AS Amount
            , MISale.ObjectId                                AS GoodsId
            , Object_Goods.ObjectCode                        AS GoodsCode
            , Object_Goods.ValueData                         AS GoodsName
            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId
            , Object_GoodsKind.ValueData                     AS GoodsKindName

            , MIFloat_AmountPartner.ValueData       ::TFloat AS AmountPartner
            , COALESCE (MIFloat_Price.ValueData, 0) ::TFloat AS Price

            , MISale.Id                                      AS MovementItemId_sale
            , Movement_Sale.Id                               AS MovementId_sale
            , Movement_Sale.InvNumber
            , MovementString_InvNumberPartner.ValueData      AS InvNumberPartner
            , Movement_Sale.OperDate
            , CASE WHEN Movement_Sale.DescId = zc_Movement_Sale() THEN MD_OperDatePartner.ValueData ELSE Movement_Sale.OperDate END :: TDateTime AS OperDatePartner
            , View_Contract_InvNumber_Sale.ContractCode      AS ContractCode_Sale
            , View_Contract_InvNumber_Sale.InvNumber         AS ContractName_Sale

            , Movement_Tax.Id                                AS MovementId_tax
            , Movement_Tax.InvNumber                         AS InvNumber_Master
            , MS_InvNumberPartner_Tax.ValueData              AS InvNumberPartner_Master
            , Movement_Tax.OperDate                          AS OperDate_Master
            , Object_TaxKind.ValueData                       AS DocumentTaxKindName
            , View_Contract_InvNumber_Tax.ContractCode       AS ContractCode_Tax
            , View_Contract_InvNumber_Tax.InvNumber          AS ContractName_Tax
                           
            , Object_From.ValueData                          AS FromName
            , Object_To.ObjectCode                           AS ToCode
            , Object_To.ValueData                            AS ToName
            , Object_Juridical.ValueData                     AS JuridicalName

            , MovementDesc_Sale.ItemName                     AS DescName_Sale
            , MIFloat_ChangePercent.ValueData                AS ChangePercent_Sale
            , zfCalc_PromoMovementName (NULL, Movement_Promo_View.InvNumber :: TVarChar, Movement_Promo_View.OperDate, Movement_Promo_View.StartSale, Movement_Promo_View.EndSale) AS MovementPromo_Sale

            , CASE WHEN MISale.Id > 0
                   AND (MISale.isErased = TRUE
                     OR tmpMI.Amount                                  > COALESCE (MIFloat_AmountPartner.ValueData, 0)
                     OR MISale.ObjectId                               <> tmpMI.GoodsId
                     OR (COALESCE (MILinkObject_GoodsKind.ObjectId, 0) <> tmpMI.GoodsKindId AND tmpMI.GoodsKindId <> zc_GoodsKind_Basis() AND MILinkObject_GoodsKind.ObjectId <> 0)
                     OR COALESCE (MIFloat_Price.ValueData, 0)         <> tmpMI.Price
                     OR COALESCE (vbPartnerId, 0)                     <> COALESCE (Object_To.Id, 0)
                     OR COALESCE (vbContractId, 0)                    <> COALESCE (MLO_Contract_Sale.ObjectId, 0)
                     OR (COALESCE (vbContractId, 0)                   <> COALESCE (MLO_Contract_Tax.ObjectId, 0) AND Movement_Tax.Id > 0)
                     OR Movement_Sale.StatusId                        <> zc_Enum_Status_Complete()
                     OR (Movement_Tax.StatusId                        <> zc_Enum_Status_Complete() AND Movement_Tax.Id > 0)
                       )
                        THEN TRUE
                   ELSE FALSE
              END :: Boolean AS isError
            , CASE WHEN MISale.isErased = TRUE
                     OR MISale.ObjectId <> tmpMI.GoodsId
                     OR (COALESCE (MILinkObject_GoodsKind.ObjectId, 0) <> tmpMI.GoodsKindId AND tmpMI.GoodsKindId <> zc_GoodsKind_Basis() AND MILinkObject_GoodsKind.ObjectId <> 0)
                     OR COALESCE (MIFloat_Price.ValueData, 0)         <> tmpMI.Price
                     OR COALESCE (vbPartnerId, 0)                     <> COALESCE (Object_To.Id, 0)
                     OR COALESCE (vbContractId, 0)                    <> COALESCE (MLO_Contract_Sale.ObjectId, 0)
                     OR (COALESCE (vbContractId, 0)                   <> COALESCE (MLO_Contract_Tax.ObjectId, 0) AND Movement_Tax.Id > 0)
                     OR Movement_Sale.StatusId                        <> zc_Enum_Status_Complete()
                     OR (Movement_Tax.StatusId                        <> zc_Enum_Status_Complete() AND Movement_Tax.Id > 0)
                        THEN TRUE
                   ELSE tmpMI.isErased
              END :: Boolean AS isErased

       FROM tmpMI
            LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = tmpMI.MovementId_sale 
            LEFT JOIN MovementDesc AS MovementDesc_Sale ON MovementDesc_Sale.Id = Movement_Sale.DescId

            LEFT JOIN MovementDate AS MD_OperDatePartner
                                   ON MD_OperDatePartner.MovementId = Movement_Sale.Id
                                  AND MD_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = CASE WHEN Movement_Sale.DescId = zc_Movement_Sale() THEN MovementLinkObject_To.ObjectId ELSE MovementLinkObject_Partner.ObjectId END

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = CASE WHEN Movement_Sale.DescId = zc_Movement_Sale() THEN ObjectLink_Partner_Juridical.ChildObjectId ELSE MovementLinkObject_To.ObjectId END

          LEFT JOIN MovementItem AS MISale ON MISale.Id = tmpMI.MovementItemId_sale
             
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE (MISale.ObjectId, tmpMI.GoodsId)

          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                           ON MILinkObject_GoodsKind.MovementItemId = MISale.Id
                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

          LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                      ON MIFloat_AmountPartner.MovementItemId = MISale.Id
                                     AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                      ON MIFloat_Price.MovementItemId = MISale.Id
                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()

          LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                   ON MovementString_InvNumberPartner.MovementId = Movement_Sale.Id 
                                  AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Tax
                                         ON MovementLinkMovement_Tax.MovementId = Movement_Sale.Id
                                        AND MovementLinkMovement_Tax.DescId = zc_MovementLinkMovement_Master()
          LEFT JOIN Movement AS Movement_Tax ON Movement_Tax.Id = MovementLinkMovement_Tax.MovementChildId
          LEFT JOIN MovementString AS MS_InvNumberPartner_Tax
                                   ON MS_InvNumberPartner_Tax.MovementId = MovementLinkMovement_Tax.MovementChildId
                                  AND MS_InvNumberPartner_Tax.DescId = zc_MovementString_InvNumberPartner()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind_Master
                                       ON MovementLinkObject_DocumentTaxKind_Master.MovementId = Movement_Tax.Id 
                                      AND MovementLinkObject_DocumentTaxKind_Master.DescId = zc_MovementLinkObject_DocumentTaxKind()
          LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = MovementLinkObject_DocumentTaxKind_Master.ObjectId
                                                   AND Movement_Tax.StatusId = zc_Enum_Status_Complete() 

          LEFT JOIN MovementLinkObject AS MLO_Contract_Sale
                                       ON MLO_Contract_Sale.MovementId = Movement_Sale.Id
                                      AND MLO_Contract_Sale.DescId = CASE WHEN Movement_Sale.DescId = zc_Movement_Sale() THEN zc_MovementLinkObject_Contract() ELSE zc_MovementLinkObject_ContractTo() END
          LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber_Sale ON View_Contract_InvNumber_Sale.ContractId = MLO_Contract_Sale.ObjectId

          LEFT JOIN MovementLinkObject AS MLO_Contract_Tax
                                       ON MLO_Contract_Tax.MovementId = Movement_Tax.Id 
                                      AND MLO_Contract_Tax.DescId = zc_MovementLinkObject_Contract()
          LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber_Tax ON View_Contract_InvNumber_Tax.ContractId = MLO_Contract_Tax.ObjectId

          LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                      ON MIFloat_ChangePercent.MovementItemId = MISale.Id
                                     AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
          LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                      ON MIFloat_PromoMovement.MovementItemId = MISale.Id
                                     AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
          LEFT JOIN Movement_Promo_View ON Movement_Promo_View.Id = MIFloat_PromoMovement.ValueData :: Integer
        ;
                     
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItemChild_ReturnIn (Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 15.05.16                                        *
*/

-- SELECT * FROM gpSelect_MovementItemChild_ReturnIn (inMovementId:= 3662505 ::Integer , inisErased := 'False'::Boolean , inSession := '5'::TVarChar);
