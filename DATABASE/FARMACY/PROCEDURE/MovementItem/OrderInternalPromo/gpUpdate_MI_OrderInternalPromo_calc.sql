-- Function: gpUpdate_MI_OrderInternalPromo_calc()

DROP FUNCTION IF EXISTS gpUpdate_MI_OrderInternalPromo_calc (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_OrderInternalPromo_calc(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS 
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbRetailId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
    
    -- данные из шапки документа
    SELECT Movement.OperDate 
         , MovementLinkObject_Retail.ObjectId AS RetailId
   INTO vbOperDate, vbRetailId 
    FROM Movement 
         LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                      ON MovementLinkObject_Retail.MovementId = Movement.Id
                                     AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
    WHERE Movement.Id = inMovementId;
    
    --сохраняем данные в мастере
    PERFORM lpInsertUpdate_MI_OrderInternalPromo_calc
                                                 (ioId                 := tmpAll.MI_Id
                                                , inMovementId         := inMovementId
                                                , inGoodsId            := tmpAll.GoodsId_retail
                                                , inJuridicalId        := tmpAll.JuridicalId
                                                , inContractId         := tmpAll.ContractId
                                                , inAmount             := 0                      :: TFloat
                                                , inPromoMovementId    := tmpAll.PromoMovementId :: TFloat
                                                , inPrice              := tmpAll.Price           :: TFloat
                                                , inUserId             := vbUserId
                                                )
    FROM (WITH 
             -- данные по ценам товаров
               SelectMinPrice_AllGoods AS (SELECT * FROM lpSelect_GoodsMinPrice_onDate_byPromo (inOperdate := vbOperDate, inUnitId := 0, inObjectId := vbRetailId, inMovementId := inMovementId, inUserId := vbUserId) AS SelectMinPrice_AllGoods)
             -- товары сети для PromoMovement
             --, tmpGoodsPromoMain AS (SELECT DISTINCT tmp.MovementId, tmp.GoodsId, tmp.JuridicalId FROM lpSelect_MovementItem_Promo_onDate(inOperDate:= vbOperDate) AS tmp)
            
             -- Строки документа, сначала ручками добавляют товары, маркет или не маркет, а потом для этих товаров выполняется расчет (ранее выбирались все товары промо в мастер)
             , tmpGoodsPromo AS (SELECT MovementItem.Id                              AS MI_Id
                                      , MovementItem.ObjectId                        AS GoodsId_retail
                                      , MIFloat_PromoMovementId.ValueData :: Integer AS PromoMovementId
                                 FROM MovementItem
                                      LEFT JOIN MovementItemFloat AS MIFloat_PromoMovementId
                                                                  ON MIFloat_PromoMovementId.MovementItemId = MovementItem.Id
                                                                 AND MIFloat_PromoMovementId.DescId = zc_MIFloat_PromoMovementId()
                                 WHERE MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId = zc_MI_Master()
                                    AND MovementItem.isErased = FALSE
                                 )

         SELECT tmp.MI_Id
              , COALESCE (tmp.PromoMovementId,0) AS PromoMovementId
              , tmp.GoodsId_retail
              , SelectMinPrice_AllGoods.Price
              , SelectMinPrice_AllGoods.JuridicalId
              , SelectMinPrice_AllGoods.ContractId
         FROM tmpGoodsPromo AS tmp
              INNER JOIN SelectMinPrice_AllGoods ON SelectMinPrice_AllGoods.GoodsId = tmp.GoodsId_retail
         WHERE COALESCE (SelectMinPrice_AllGoods.Price,0) > 0
         ) AS tmpAll;

    -- пересчитали Итоговые суммы по накладной
    PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

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
 19.05.19         *
*/