-- Function: gpInsert_MI_OrderInternalPromo_byPromo()

DROP FUNCTION IF EXISTS gpInsert_MI_OrderInternalPromo_byPromo (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_OrderInternalPromo_byPromo(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inMovementId_promo    Integer   , -- Ключ объекта <Документ маркет контракт>
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
    

    
    -- проверка, что данные уже заполнены
    /*IF EXISTS (SELECT 1
               FROM MovementItem
               WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId = zc_MI_Master()
                  AND MovementItem.isErased = FALSE)
    THEN
         RAISE EXCEPTION 'Ошибка.Документ уже заполнен.';
    END IF;
    */
     
    -- сохраняем товары
    PERFORM lpInsertUpdate_MI_OrderInternalPromo_calc (ioId                 := 0
                                                     , inMovementId         := inMovementId
                                                     , inGoodsId            := tmpAll.GoodsId_retail
                                                     , inJuridicalId        := 0
                                                     , inContractId         := 0
                                                     , inAmount             := 0                       :: TFloat
                                                     , inPromoMovementId    := tmpAll.MovementId_Promo :: TFloat
                                                     , inPrice              := 0                       :: TFloat
                                                     , inUserId             := vbUserId
                                                     )
    FROM (WITH 
             -- товары входящего PromoMovement
             tmpMIPromo AS (SELECT MI_Promo.MovementId                  AS MovementId_Promo
                                 , MI_Promo.ObjectId                    AS GoodsId
                            FROM MovementItem AS MI_Promo
                            WHERE MI_Promo.MovementId = inMovementId_promo
                              AND MI_Promo.DescId = zc_MI_Master()
                              AND MI_Promo.isErased = FALSE
                            )
          
          SELECT tmpMIPromo.MovementId_Promo
               , ObjectLink_Child_retail.ChildObjectId AS GoodsId_retail
          FROM tmpMIPromo
          -- находим товар сети
               INNER JOIN ObjectLink AS ObjectLink_Child
                                     ON ObjectLink_Child.ChildObjectId = tmpMIPromo.GoodsId
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
          ) AS tmpAll;    
          
    -- пересчитали Итоговые суммы по накладной
    PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

          
    -- !!!ВРЕМЕННО для ТЕСТА!!!
    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION 'Тест прошел успешно для <%> <%> <%>', inSession, inMovementId, 
                           (SELECT COUNT(*)
                            FROM MovementItem AS MI_Promo
                            WHERE MI_Promo.MovementId = inMovementId
                              AND MI_Promo.DescId = zc_MI_Master()
                              AND MI_Promo.isErased = FALSE
                            );
    END IF;
             
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.09.19         *
*/

select * from gpInsert_MI_OrderInternalPromo_byPromo(inMovementId := 27522956 , inMovementId_promo := 2115795 ,  inSession := '3');