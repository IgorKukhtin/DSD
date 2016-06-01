-- Function: gpSelect_MovementItem_SalePartion()

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
             , MovementId_tax Integer, InvNumber_Master TVarChar, InvNumberPartner_Master TVarChar, OperDate_Master TDateTime
             , DocumentTaxKindName TVarChar
             , FromName TVarChar
             , ToCode Integer
             , ToName TVarChar
             , JuridicalName TVarChar
              )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Sale());
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
       WITH tmpMI AS (SELECT MovementItem.Id                              AS MI_Id
                           , MovementItem.ParentId                        AS MI_ParentId
                           , MovementItem.ObjectId                        AS GoodsId
                           , MovementItem.Amount                          AS Amount
                           , MIFloat_MovementId.ValueData      :: Integer AS MovementId_sale
                           , MIFloat_MovementItemId.ValueData  :: Integer AS MovementItemId_sale
                           , MovementItem.isErased                        AS isErased
                      FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                           INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                  AND MovementItem.DescId     = zc_MI_Child()
                                                  AND MovementItem.isErased   = tmpIsErased.isErased
                           LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                       ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                      AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()                         
                           LEFT JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                       ON MIFloat_MovementItemId.MovementItemId = MovementItem.Id
                                                      AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId() 
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

            , MIFloat_AmountPartner.ValueData       ::tfloat AS AmountPartner
            , COALESCE (MIFloat_Price.ValueData, 0) ::tfloat AS Price

            , MISale.Id                                      AS MovementItemId_sale
            , Movement_Sale.Id                               AS MovementId_sale
            , Movement_Sale.InvNumber
            , MovementString_InvNumberPartner.ValueData      AS InvNumberPartner
            , Movement_Sale.OperDate
            , MD_OperDatePartner.ValueData                   AS OperDatePartner

            , Movement_DocumentMaster.Id                     AS MovementId_tax
            , Movement_DocumentMaster.InvNumber              AS InvNumber_Master
            , MS_InvNumberPartner_Master.ValueData           AS InvNumberPartner_Master
            , Movement_DocumentMaster.OperDate               AS OperDate_Master
            , Object_TaxKind_Master.ValueData                AS DocumentTaxKindName
                           
           , Object_From.ValueData                      AS FromName
           , Object_To.ObjectCode                       AS ToCode
           , Object_To.ValueData                        AS ToName
           , Object_Juridical.ValueData                 AS JuridicalName

       FROM tmpMI
          LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = tmpMI.MovementId_sale 
          LEFT JOIN MovementDate AS MD_OperDatePartner ON MD_OperDatePartner.MovementId = Movement_Sale.Id
                                                      AND MD_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId


          LEFT JOIN MovementItem AS MISale ON MISale.Id = tmpMI.MovementItemId_sale
             
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
                                       -- AND MISale.ObjectId = tmpMI.GoodsId

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
          LEFT JOIN Object AS Object_TaxKind_Master ON Object_TaxKind_Master.Id = MovementLinkObject_DocumentTaxKind_Master.ObjectId
                                                   AND Movement_DocumentMaster.StatusId = zc_Enum_Status_Complete() 

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
