-- Function: gpInsert_MI_PromoBonus_byPromo()

DROP FUNCTION IF EXISTS gpInsert_MI_PromoBonus_byPromo (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_PromoBonus_byPromo(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS void AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;

    CREATE TEMP TABLE tmpMI ON COMMIT DROP AS
     (WITH
          -- Маркетинговый контракт
            tmpMovement AS (SELECT Movement.Id                                         AS MovementId
                                 , Movement.InvNumber                                  AS InvNumber
                                 , MovementLinkObject_Maker.ObjectId                   AS MakerID
                                 , COALESCE (MovementFloat_ChangePercent.ValueData, 0) AS ChangePercent
                                 , MovementDate_EndPromo.ValueData                     AS EndPromo
                                 , MovementLinkMovement_RelatedProduct.MovementChildId AS RelatedProductId
                            FROM Movement
                                 INNER JOIN MovementDate AS MovementDate_StartPromo
                                                         ON MovementDate_StartPromo.MovementId = Movement.Id
                                                        AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
                                                        AND MovementDate_StartPromo.ValueData <= CURRENT_DATE
                                 INNER JOIN MovementDate AS MovementDate_EndPromo
                                                         ON MovementDate_EndPromo.MovementId = Movement.Id
                                                        AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()
                                                        AND MovementDate_EndPromo.ValueData >= CURRENT_DATE
                                 LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                                         ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                                        AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Maker
                                                              ON MovementLinkObject_Maker.MovementId = Movement.Id
                                                             AND MovementLinkObject_Maker.DescId = zc_MovementLinkObject_Maker()
                                 LEFT JOIN MovementLinkMovement AS MovementLinkMovement_RelatedProduct
                                                                ON MovementLinkMovement_RelatedProduct.MovementId = Movement.Id
                                                               AND MovementLinkMovement_RelatedProduct.DescId = zc_MovementLinkMovement_RelatedProduct()


                            WHERE Movement.StatusId = zc_Enum_Status_Complete()
                              AND Movement.DescId = zc_Movement_Promo()),
            tmpMI AS (SELECT MI_Goods.Id                       AS MovementItemId
                          -- , MI_Juridical.ObjectId             AS JuridicalId
                           , MI_Goods.ObjectId                 AS GoodsId
                           , Movement.MakerID                  AS MakerID
                           , ROW_NUMBER() OVER (PARTITION BY /*MI_Juridical.ObjectId, */ MI_Goods.ObjectId ORDER BY /*MI_Juridical.ObjectId, */ MI_Goods.ObjectId, Movement.EndPromo DESC, Movement.MovementId DESC) AS Ord
                      FROM tmpMovement AS Movement

                           INNER JOIN MovementItem AS MI_Goods ON MI_Goods.MovementId = Movement.MovementId
                                                              AND MI_Goods.DescId = zc_MI_Master()
                                                              AND MI_Goods.isErased = FALSE

                        /*   LEFT JOIN MovementItem AS MI_Juridical ON MI_Juridical.MovementId = Movement.MovementId
                                                                 AND MI_Juridical.DescId = zc_MI_Child()
                                                                 AND MI_Juridical.isErased = FALSE*/
                     ),
            tmpGoodsPromo AS (SELECT tmp.MovementItemId
                                  -- , tmp.JuridicalId
                                   , tmp.GoodsId                               AS GoodsPromoId
                                   , tmp.MakerID
                              FROM tmpMI AS tmp
                              WHERE tmp.Ord = 1),
            tmpMI_Master AS (SELECT MovementItem.Id                            AS Id
                                  , MovementItem.ObjectId                      AS GoodsId
                                  , MovementItem.Amount                        AS Amount
                                  , MIFloat_MovementItemId.ValueData::Integer  AS MIPromoId
                                  , MovementItem.isErased                      AS isErased
                             FROM MovementItem

                                 LEFT JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                             ON MIFloat_MovementItemId.MovementItemId = MovementItem.Id
                                                            AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId()

                             WHERE MovementItem.MovementId = inMovementId
                               AND MovementItem.DescId = zc_MI_Master()
                             )


      SELECT tmpGoodsPromo.MovementItemId
           , tmpGoodsPromo.GoodsPromoId
           , tmpMI_Master.Id
           , tmpMI_Master.MIPromoId
           , tmpMI_Master.GoodsId
           , tmpMI_Master.Amount
           , tmpMI_Master.isErased
      FROM tmpGoodsPromo

           FULL JOIN tmpMI_Master ON tmpMI_Master.MIPromoId = tmpGoodsPromo.MovementItemId);

     -- Отменяем удаленные если вернулся контракт
     UPDATE MovementItem SET isErased = False
     WHERE MovementItem.ID IN (SELECT tmpMI.ID FROM tmpMI 
                               WHERE COALESCE (tmpMI.ID, 0) <> 0
                                 AND tmpMI.isErased = TRUE AND COALESCE (tmpMI.MovementItemId, 0) <> 0);

/*     raise notice 'Value: %', (SELECT COUNT(*) FROM tmpMI WHERE COALESCE (tmpMI.ID, 0) <> 0
       AND COALESCE (tmpMI.MovementItemId, 0) = 0);*/
       
     -- Удаляем если ушло контракт
     UPDATE MovementItem SET isErased = True
     WHERE MovementItem.ID IN (SELECT tmpMI.ID FROM tmpMI 
                               WHERE COALESCE (tmpMI.ID, 0) <> 0
                                 AND COALESCE (tmpMI.MovementItemId, 0) = 0);

     -- Добавляем новые
     PERFORM lpInsertUpdate_MI_PromoBonus (ioId             := COALESCE(tmpMI.Id, 0)
                                         , inMovementId     := inMovementId
                                         , inGoodsId        := COALESCE (tmpMI.GoodsPromoId, tmpMI.GoodsId)
                                         , inMIPromoId      := COALESCE (tmpMI.MovementItemId, tmpMI.GoodsId)
                                         , inAmount         := COALESCE (tmpMI.Amount, 0)
                                         , inBonusInetOrder := COALESCE (MIFloat_BonusInetOrder.ValueData, 0)
                                         , inUserId         := vbUserId)
     FROM tmpMI
          LEFT JOIN MovementItemFloat AS MIFloat_BonusInetOrder
                                      ON MIFloat_BonusInetOrder.MovementItemId = COALESCE(tmpMI.Id, 0)
                                     AND MIFloat_BonusInetOrder.DescId = zc_MIFloat_BonusInetOrder()
     WHERE COALESCE (tmpMI.MovementItemId, 0) <> 0
       AND COALESCE (tmpMI.GoodsPromoId, 0) <> COALESCE (tmpMI.GoodsId, 0);

    -- !!!ВРЕМЕННО для ТЕСТА!!!
    /*IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION 'Тест прошел успешно для <%>', inSession;
    END IF;*/

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_MI_PromoBonus (Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 17.02.21                                                                      *
*/

-- тест
-- select * from gpInsert_MI_PromoBonus_byPromo(inMovementId := 22181875  ,  inSession := '3');