-- Function: gpSelect_MovementItem_IncomeAsset()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_IncomeAsset (Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_IncomeAsset(
    IN inMovementId       Integer      , -- ключ Документа
    IN inInvoiceId        Integer      ,
    IN inShowAll          Boolean      , -- 
    IN inIsErased         Boolean      , -- 
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, InvNumber_Asset TVarChar, InvNumber_Asset_save TVarChar
             , AssetId Integer, AssetCode Integer, AssetName TVarChar, InvNumber_AssetTo TVarChar
             , UnitId Integer, UnitName TVarChar
             , Amount TFloat, Price TFloat
             , Amount_parent TFloat, Price_parent TFloat
             , CountForPrice TFloat
             , AmountSumm TFloat
             , isErased Boolean
             , MIId_Invoice Integer, InvNumber_Invoice TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_IncomeAsset());
     vbUserId:= lpGetUserBySession (inSession);


     -- В этом случае не надо пол
     IF inShowAll = FALSE THEN inInvoiceId:= NULL; END IF;

     -- Результат
     RETURN QUERY 
       WITH tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId                           AS GoodsId
                           , MILinkObject_Asset.ObjectId                     AS AssetId
                           , MILinkObject_Unit.ObjectId                      AS UnitId
                           , MovementItem.Amount                             AS Amount
                           , COALESCE (MIFloat_Price.ValueData, 0)           AS Price
                           , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice
                           , MIFloat_Invoice.ValueData :: Integer            AS MIId_Invoice
                           , MovementItem.isErased                           AS isErased
                          
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()    
                            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                             ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                            LEFT JOIN MovementItemFloat AS MIFloat_Invoice
                                                        ON MIFloat_Invoice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Invoice.DescId = zc_MIFloat_MovementItemId()
                      )
   , tmpMI_parent AS (SELECT MovementItem.Id                                 AS MovementItemId
                           , MILinkObject_Goods.ObjectId                     AS GoodsId
                           , MILinkObject_Asset.ObjectId                     AS AssetId
                           , MILinkObject_Unit.ObjectId                      AS UnitId
                           , COALESCE (MIFloat_Price.ValueData, 0)           AS Price
                           , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice
                      FROM MovementItem
                            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()    
                            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                             ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                             ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()                                                                  
                      WHERE MovementItem.MovementId = inInvoiceId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                     )
   , tmpResult AS (SELECT tmpMI.Id                                                         AS Id
                        , COALESCE (tmpMI.GoodsId, tmpMI_parent.GoodsId)                   AS GoodsId
                        , COALESCE (tmpMI.AssetId, tmpMI_parent.AssetId)                   AS AssetId
                        , COALESCE (tmpMI.UnitId, tmpMI_parent.UnitId)                     AS UnitId
                        , tmpMI.Amount                                                     AS Amount
                        , COALESCE (tmpMI.Price, tmpMI_parent.Price)                       AS Price
                        , COALESCE (tmpMI.CountForPrice, tmpMI_parent.CountForPrice)       AS CountForPrice
                        , COALESCE (tmpMI.MIId_Invoice, tmpMI_parent.MovementItemId) :: Integer AS MIId_Invoice
                        , COALESCE (tmpMI.isErased, FALSE)                           :: Boolean AS isErased
                   FROM tmpMI
                        FULL JOIN tmpMI_parent ON tmpMI_parent.MovementItemId = tmpMI.MIId_Invoice
                                             -- AND tmpMI_parent.GoodsId        = tmpMI.GoodsId
                  )
         -- Результат
         SELECT
             tmpMI.Id

           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , Object_Goods.ValueData              AS GoodsName
           , ObjectString_InvNumber.ValueData    AS InvNumber_Asset
           , ObjectString_InvNumber.ValueData    AS InvNumber_Asset_save

           , Object_Asset.Id                     AS AssetId
           , Object_Asset.ObjectCode             AS AssetCode
           , Object_Asset.ValueData              AS AssetName
           , ObjectString_InvNumber_to.ValueData AS InvNumber_AssetTo

           , Object_Unit.Id             AS UnitId
           , Object_Unit.ValueData      AS UnitName


           , tmpMI.Amount
           , tmpMI.Price           :: TFloat AS Price
           , MI_Invoice.Amount               AS Amount_parent
           , MIFloat_Price_Invoice.ValueData AS Price_parent
           , tmpMI.CountForPrice   :: TFloat AS CountForPrice

           , CASE WHEN tmpMI.CountForPrice > 0
                       THEN CAST ( COALESCE (tmpMI.Amount, 0) * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                  ELSE CAST ( COALESCE (tmpMI.Amount, 0) * tmpMI.Price AS NUMERIC (16, 2))
             END :: TFloat AS AmountSumm
           , tmpMI.isErased
     
           , MI_Invoice.Id AS MIId_Invoice
           , (CASE WHEN MI_Invoice.isErased = TRUE OR Movement_Invoice.StatusId <> zc_Enum_Status_Complete() THEN 'Ошибка *** ' ELSE '' END
           || zfCalc_PartionMovementName (Movement_Invoice.DescId, MovementDesc_Invoice.ItemName, COALESCE (MovementString_InvNumberPartner_Invoice.ValueData, '') || '/' || Movement_Invoice.InvNumber, Movement_Invoice.OperDate)
             ) :: TVarChar AS InvNumber_Invoice

       FROM tmpResult AS tmpMI

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN ObjectString AS ObjectString_InvNumber
                                   ON ObjectString_InvNumber.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_InvNumber.DescId = zc_ObjectString_Asset_InvNumber()

            -- это док. "Счет"
            LEFT JOIN MovementItem AS MI_Invoice ON MI_Invoice.Id       = tmpMI.MIId_Invoice
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Invoice_Goods
                                             ON MILinkObject_Invoice_Goods.MovementItemId = tmpMI.MIId_Invoice
                                            AND MILinkObject_Invoice_Goods.DescId = zc_MILinkObject_Goods()                                                                  
            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id                 = MI_Invoice.MovementId
                                               -- AND MILinkObject_Invoice_Goods.ObjectId = tmpMI.GoodsId

            LEFT JOIN MovementItemFloat AS MIFloat_Price_Invoice
                                        ON MIFloat_Price_Invoice.MovementItemId = tmpMI.MIId_Invoice
                                       AND MIFloat_Price_Invoice.DescId = zc_MIFloat_Price()    
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit_Invoice
                                             ON MILinkObject_Unit_Invoice.MovementItemId = tmpMI.MIId_Invoice
                                            AND MILinkObject_Unit_Invoice.DescId = zc_MILinkObject_Unit()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset_Invoice
                                             ON MILinkObject_Asset_Invoice.MovementItemId = tmpMI.MIId_Invoice
                                            AND MILinkObject_Asset_Invoice.DescId = zc_MILinkObject_Asset()                                                                  

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = COALESCE (tmpMI.UnitId , MILinkObject_Unit_Invoice.ObjectId)
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = COALESCE (tmpMI.AssetId , MILinkObject_Asset_Invoice.ObjectId)
            LEFT JOIN ObjectString AS ObjectString_InvNumber_to
                                   ON ObjectString_InvNumber_to.ObjectId = Object_Asset.Id
                                  AND ObjectString_InvNumber_to.DescId = zc_ObjectString_Asset_InvNumber()

            LEFT JOIN MovementDesc AS MovementDesc_Invoice ON MovementDesc_Invoice.Id = Movement_Invoice.DescId
            LEFT JOIN MovementString AS MovementString_InvNumberPartner_Invoice
                                     ON MovementString_InvNumberPartner_Invoice.MovementId =  Movement_Invoice.Id
                                    AND MovementString_InvNumberPartner_Invoice.DescId = zc_MovementString_InvNumberPartner()
       ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 27.08.16         *
 29.07.16         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_IncomeAsset (inMovementId:= 25173, inInvoiceId:=0, inShowAll:= TRUE,  inIsErased:= TRUE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItem_IncomeAsset (inMovementId:= 25173, inInvoiceId:=0, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
