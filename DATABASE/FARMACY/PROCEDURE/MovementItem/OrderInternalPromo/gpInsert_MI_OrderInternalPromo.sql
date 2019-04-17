-- Function: gpInsert_MI_OrderInternalPromo()

DROP FUNCTION IF EXISTS gpInsert_MI_OrderInternalPromo (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_OrderInternalPromo(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS 
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbRetailId Integer;
   DECLARE vbInvnumber TVarChar;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
    
    -- данные из шапки документа
    SELECT Movement.OperDate 
         , Movement.Invnumber
         , MovementLinkObject_Retail.ObjectId AS RetailId
   INTO vbOperDate, vbInvnumber, vbRetailId 
    FROM Movement 
         LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                      ON MovementLinkObject_Retail.MovementId = Movement.Id
                                     AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
    WHERE Movement.Id = inMovementId;
    

    
    -- проверка, что данные уже заполнены
    IF EXISTS (SELECT 1
               FROM MovementItem
               WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId = zc_MI_Master()
                  AND MovementItem.isErased = FALSE)
    THEN
         RAISE EXCEPTION 'Ошибка.Документ уже заполнен.';
    END IF;
    
    PERFORM lpInsertUpdate_MI_OrderInternalPromo (ioId                 := 0
                                                , inMovementId         := inMovementId
                                                , inGoodsId            := tmpAll.GoodsId
                                                , inJuridicalId        := tmpAll.JuridicalId
                                                , inContractId         := tmpAll.ContractId
                                                , inAmount             := 0                      :: TFloat
                                                , inPromoMovementId    := tmpAll.PromoMovementId :: TFloat
                                                , inPrice              := tmpAll.Price           :: TFloat
                                                , inUserId             := vbUserId
                                                )
    FROM (WITH SelectMinPrice_AllGoods AS (SELECT * FROM lpSelect_GoodsMinPrice_onDate (inOperdate := vbOperDate, inUnitId := 0, inObjectId := vbRetailId, inUserId := vbUserId) AS SelectMinPrice_AllGoods)
             , tmpGoodsPromo AS (SELECT DISTINCT tmp.MovementId, tmp.GoodsId, tmp.JuridicalId FROM lpSelect_MovementItem_Promo_onDate(inOperDate:= vbOperDate) AS tmp)
         SELECT tmp.MovementId AS PromoMovementId, tmp.GoodsId, SelectMinPrice_AllGoods.Price, SelectMinPrice_AllGoods.JuridicalId, SelectMinPrice_AllGoods.ContractId
         FROM tmpGoodsPromo AS tmp
              INNER JOIN SelectMinPrice_AllGoods ON SelectMinPrice_AllGoods.GoodsId = tmp.GoodsId
                                                AND SelectMinPrice_AllGoods.JuridicalId = tmp.JuridicalId
         WHERE COALESCE (SelectMinPrice_AllGoods.Price,0) > 0
         ) AS tmpAll;
         
    -- по мастеру заполняем     zc_Movement_OrderInternalPromoPartner 
    PERFORM gpInsertUpdate_Movement_OrderInternalPromoPartner (ioId         := 0
                                                             , inParentId   := inMovementId
                                                             , inJuridicalId:= tmp.JuridicalId
                                                             , inComment    := ''  ::TVarChar
                                                             , inSession    := inSession) 
    FROM (SELECT DISTINCT MILinkObject_Juridical.ObjectId AS JuridicalId
          FROM MovementItem
               INNER JOIN MovementItemLinkObject AS MILinkObject_Juridical
                                                 ON MILinkObject_Juridical.MovementItemId = MovementItem.Id
                                                AND MILinkObject_Juridical.DescId = zc_MILinkObject_Juridical()
          WHERE MovementItem.MovementId = inMovementId
             AND MovementItem.DescId = zc_MI_Master()
             AND MovementItem.isErased = FALSE
          ) AS tmp;
        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.04.19         *
*/