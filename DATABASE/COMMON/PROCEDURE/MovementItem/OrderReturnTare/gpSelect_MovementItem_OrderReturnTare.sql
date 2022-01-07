-- Function: gpSelect_MovementItem_OrderReturnTare()

 DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderReturnTare (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderReturnTare(
    IN inMovementId  Integer      , -- ключ Документа
    IN inisErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar
             , Amount TFloat
             , PartnerId Integer, PartnerCode Integer, PartnerName  TVarChar           
             , isErased Boolean
             )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbGoodsPropertyId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderReturnTare());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
        SELECT
             MovementItem.Id         :: Integer AS Id
           , Object_Goods.Id          		AS GoodsId
           , Object_Goods.ObjectCode  		AS GoodsCode
           , Object_Goods.ValueData   		AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , MovementItem.Amount     :: TFloat  AS Amount

           , Object_Partner.Id        	        AS PartnerId
           , Object_Partner.ObjectCode          AS PartnerCode
           , Object_Partner.ValueData 	        AS PartnerName

           , MovementItem.isErased              AS isErased

        FROM MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                             ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Partner.DescId = zc_MILinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MILinkObject_Partner.ObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId     = zc_MI_Master()
          AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.10.20         *
*/

-- тест
-- select * from gpSelect_MovementItem_OrderReturnTare(inMovementId := 18298048 , inIsErased := 'False' ,  inSession := '5')
