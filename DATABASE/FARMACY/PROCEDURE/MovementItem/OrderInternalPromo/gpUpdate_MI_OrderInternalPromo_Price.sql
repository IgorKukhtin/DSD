-- Function: gpUpdate_MI_OrderInternalPromo_Price()

DROP FUNCTION IF EXISTS gpUpdate_MI_OrderInternalPromo_Price (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_OrderInternalPromo_Price(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS 
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbRetailId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
    
    -- данные из шапки документа
    SELECT MovementLinkObject_Retail.ObjectId AS RetailId
   INTO vbRetailId 
    FROM Movement 
         LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                      ON MovementLinkObject_Retail.MovementId = Movement.Id
                                     AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
    WHERE Movement.Id = inMovementId;
    
    --обновляем данные в мастере


    PERFORM lpInsertUpdate_MovementItemFloat      (zc_MIFloat_Price(),          tmpAll.MI_Id, tmpAll.Price ::TFloat)
          , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Juridical(), tmpAll.MI_Id, tmpAll.JuridicalId)
          , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(),  tmpAll.MI_Id, tmpAll.ContractId)
    FROM (WITH
          tmpMI AS (SELECT MovementItem.Id          AS MI_Id
                         , ObjectLink_Main.ChildObjectId AS GoodsMainId
                         , MovementItem.ObjectId         AS GoodsId_retail
                                           FROM MovementItem
                          INNER JOIN ObjectLink AS ObjectLink_Child
                                               ON ObjectLink_Child.ChildObjectId = MovementItem.ObjectId
                                              AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                         INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                  AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                         INNER JOIN ObjectLink AS ObjectLink_Main_retail ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                        AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                         INNER JOIN ObjectLink AS ObjectLink_Child_retail ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                                         AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                         INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                               ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                              AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                              AND ObjectLink_Goods_Object.ChildObjectId = vbRetailId
          
                    WHERE MovementItem.MovementId = inMovementId 
                      AND MovementItem.DescId = zc_MI_Master()
                      AND MovementItem.isErased = FALSE
                    )

        , tmpMinPrice AS (SELECT tt.*
                          FROM (SELECT LoadPriceListItem.GoodsId           AS GoodsId
                                     , LoadPriceListItem.Price             AS Price
                                     , LoadPriceList.JuridicalId
                                     , LoadPriceList.ContractId
                                     , ROW_NUMBER() OVER (PARTITION BY LoadPriceListItem.GoodsId ORDER BY LoadPriceListItem.Price) AS ord  
                                     FROM LoadPriceListItem 
                              
                                          INNER JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId
                                          LEFT JOIN (SELECT DISTINCT JuridicalId, ContractId, isPriceClose
                                                     FROM lpSelect_Object_JuridicalSettingsRetail (vbRetailId)
                                                    ) AS JuridicalSettings
                                                  ON JuridicalSettings.JuridicalId = LoadPriceList.JuridicalId 
                                                 AND JuridicalSettings.ContractId = LoadPriceList.ContractId 
                                                                   
                                         LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = LoadPriceList.JuridicalId
                                         LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = LoadPriceList.ContractId
                                    WHERE COALESCE(JuridicalSettings.isPriceClose, FALSE) <> TRUE
                              ) AS tt
                              WHERE tt.ord = 1
                              )

        SELECT tmpMI.MI_Id
             , tmpMinPrice.Price
             , tmpMinPrice.JuridicalId
             , tmpMinPrice.ContractId
        FROM tmpMinPrice
             JOIN tmpMI ON tmpMI.GoodsMainId = tmpMinPrice.GoodsId
        WHERE COALESCE (tmpMinPrice.Price,0) > 0
        ) AS tmpAll;
     


/*    PERFORM lpInsertUpdate_MovementItemFloat      (zc_MIFloat_Price(),          tmpAll.MI_Id, tmpAll.Price ::TFloat)
          , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Juridical(), tmpAll.MI_Id, tmpAll.JuridicalId)
          , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(),  tmpAll.MI_Id, tmpAll.ContractId)

    FROM (WITH 
             -- данные по ценам товаров
               SelectMinPrice_AllGoods AS (SELECT * FROM lpSelect_GoodsMinPrice_onDate (inOperdate := CURRENT_DATE, inUnitId := 0, inObjectId := vbRetailId, inUserId := vbUserId) AS SelectMinPrice_AllGoods)
            
             -- Строки документа
             , tmpGoodsPromo AS (SELECT MovementItem.Id        AS MI_Id
                                      , MovementItem.ObjectId  AS GoodsId_retail
                                 FROM MovementItem
                                 WHERE MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId = zc_MI_Master()
                                    AND MovementItem.isErased = FALSE
                                 )

         SELECT tmp.MI_Id
              , SelectMinPrice_AllGoods.Price
              , SelectMinPrice_AllGoods.JuridicalId
              , SelectMinPrice_AllGoods.ContractId
         FROM tmpGoodsPromo AS tmp
              INNER JOIN SelectMinPrice_AllGoods ON SelectMinPrice_AllGoods.GoodsId = tmp.GoodsId_retail
         WHERE COALESCE (SelectMinPrice_AllGoods.Price,0) > 0
         ) AS tmpAll;

*/
    -- по мастеру заполняем zc_Movement_OrderInternalPromoPartner 
    PERFORM lpInsertUpdate_Movement_OrderInternalPromoPartner (ioId         := 0
                                                             , inParentId   := inMovementId
                                                             , inJuridicalId:= tmp.JuridicalId
                                                             , inUserId     := vbUserId)
    FROM (WITH
          -- выбираем уже сохраненные юр.лица
          tmpMIPartner AS (SELECT MovementLinkObject_Juridical.ObjectId AS JuridicalId
                           FROM Movement 
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                           ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                                          AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                           WHERE Movement.DescId = zc_Movement_OrderInternalPromoPartner()
                             AND Movement.ParentId = inMovementId
                           )

          SELECT DISTINCT MILinkObject_Juridical.ObjectId AS JuridicalId
          FROM MovementItem
               INNER JOIN MovementItemLinkObject AS MILinkObject_Juridical
                                                 ON MILinkObject_Juridical.MovementItemId = MovementItem.Id
                                                AND MILinkObject_Juridical.DescId = zc_MILinkObject_Juridical()
               LEFT JOIN tmpMIPartner ON tmpMIPartner.JuridicalId = MILinkObject_Juridical.ObjectId
          WHERE MovementItem.MovementId = inMovementId
             AND MovementItem.DescId = zc_MI_Master()
             AND MovementItem.isErased = FALSE
             AND tmpMIPartner.JuridicalId IS NULL
          ) AS tmp;

        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.10.19         *
*/