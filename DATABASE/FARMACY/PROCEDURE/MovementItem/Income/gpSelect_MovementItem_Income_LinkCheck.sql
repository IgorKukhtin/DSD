DROP FUNCTION IF EXISTS gpSelect_MovementItem_Income_LinkCheck (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Income_LinkCheck(
    IN inMovementId          Integer   , -- 
   OUT outMessageText        Text      ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Text
AS
$BODY$
   DECLARE vbRetailId         Integer;
   DECLARE vbMessageText      TVarChar; 
BEGIN
     
     -- Проверяем все ли товары состыкованы. 
     --IF EXISTS (SELECT * FROM MovementItem WHERE MovementId = inMovementId AND ObjectId IS NULL) THEN
     --   RAISE EXCEPTION 'В документе прихода не все товары состыкованы';
     --END IF;
     
     outMessageText := '';
     
     -- проверка привязки товара
     vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                    FROM MovementLinkObject AS MovementLinkObject_Juridical
                         LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = MovementLinkObject_Juridical.ObjectId
                                             AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
                    WHERE MovementLinkObject_Juridical.MovementId = inMovementId
                      AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                    );
     vbMessageText := (WITH
                        tmpMI AS (SELECT DISTINCT MILinkObject_Goods.ObjectId  AS PartnerGoodsId
                                  FROM MovementItem 
                                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                                        ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                                       AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                  WHERE MovementItem.MovementId = inMovementId
                                    AND MovementItem.isErased   = FALSE
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND COALESCE (MILinkObject_Goods.ObjectId, 0) <> 0
                                  )
     
                      , tmpLink AS (SELECT tmpMI.PartnerGoodsId
                                         , ObjectLink_LinkGoods_Goods_find.ChildObjectId AS GoodsId
                                    FROM tmpMI
                                         LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                                              ON ObjectLink_LinkGoods_Goods.ChildObjectId = tmpMI.PartnerGoodsId
                                                             AND ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                                         LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                                              ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId
                                                             AND ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
     
                                         LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain_find
                                                              ON ObjectLink_LinkGoods_GoodsMain_find.ChildObjectId = ObjectLink_LinkGoods_GoodsMain.ChildObjectId
                                                             AND ObjectLink_LinkGoods_GoodsMain_find.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                                         LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_Goods_find
                                                              ON ObjectLink_LinkGoods_Goods_find.ObjectId = ObjectLink_LinkGoods_GoodsMain_find.ObjectId
                                                             AND ObjectLink_LinkGoods_Goods_find.DescId = zc_ObjectLink_LinkGoods_Goods()
                                         LEFT JOIN ObjectLink AS ObjectLink_Goods_Object
                                                              ON ObjectLink_Goods_Object.ObjectId = ObjectLink_LinkGoods_Goods_find.ChildObjectId
                                                             AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                         INNER JOIN Object AS Object_Retail 
                                                           ON Object_Retail.Id = ObjectLink_Goods_Object.ChildObjectId
                                                          AND Object_Retail.DescId = zc_Object_Retail()
                                    WHERE ObjectLink_Goods_Object.ChildObjectId = vbRetailId
                                    )
     
                        SELECT string_agg (lfGet_Object_ValueData (tmpMI.PartnerGoodsId ), ';')
                        FROM tmpMI
                            LEFT JOIN tmpLink ON tmpLink.PartnerGoodsId = tmpMI.PartnerGoodsId
                        WHERE tmpLink.GoodsId IS NULL
                        );
    
     IF COALESCE (vbMessageText, '') <> ''
     THEN 
         outMessageText := 'Проверьте привязку товаров поставщика '||vbMessageText;
     END IF;    
     
     vbMessageText := '';
                 
     -- информация по товарам Цена которых более 25% отл. отличается от средней 
     vbMessageText := (SELECT STRING_AGG ('(' || tmp.GoodsCode ||') '||tmp.GoodsName, '; ' ORDER BY tmp.GoodsName)
                       FROM gpSelect_MovementItem_Income (inMovementId := inMovementId  , inShowAll := FALSE , inIsErased := FALSE ,  inSession := inSession) as tmp
                       WHERE tmp.AVGIncomePriceWarning = TRUE
                       ) :: Text;

     IF COALESCE (vbMessageText, '') <> ''
     THEN 
         outMessageText :=  outMessageText ||' Товары, цена которых отл. >25%: '||vbMessageText;
     END IF;   
     
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.10.18         *
*/
-- select * from gpSelect_MovementItem_Income_LinkCheck (inMovementId := 11459485  ,  inSession := '3');  
-- vbJuridicalId = 183312