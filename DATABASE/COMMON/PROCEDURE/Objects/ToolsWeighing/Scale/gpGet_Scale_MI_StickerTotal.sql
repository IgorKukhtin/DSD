-- Function: gpGet_Scale_MI_StickerTotal()

DROP FUNCTION IF EXISTS gpGet_Scale_MI_StickerTotal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_MI_StickerTotal(
    IN inMovementItemId  Integer      ,
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS TABLE (AmountTotal        TFloat
             , WeightTare_add     TFloat
              )
AS
$BODY$
   DECLARE vbUserId               Integer;
   DECLARE vbMovementId           Integer;
   DECLARE vbMovementItemId_start Integer;
   DECLARE vbMovementId_Promo     Integer;
   DECLARE vbGoodsId              Integer;
   DECLARE vbGoodsKindId          Integer;
   DECLARE vbWeightTare_add       TFloat;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);
   
   
   --
   IF COALESCE (inMovementItemId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.inMovementItemId = <%>', inMovementItemId;
   END IF;
   

   IF COALESCE (inMovementItemId, 0) <= 0
   THEN
       inMovementItemId:= (SELECT MAX (MovementItem.Id) FROM MovementItem WHERE MovementItem.MovementId = -1 * inMovementItemId AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE);

       -- Проверка
       IF COALESCE (inMovementItemId, 0) = 0
       THEN
           RAISE EXCEPTION 'Ошибка.Итоговое взвешивание не найдено.';
       END IF;

   END IF;

   --
   SELECT MovementItem.MovementId
        , MovementItem.ObjectId
        , MILinkObject_GoodsKind.ObjectId
        , MIFloat_PromoMovement.ValueData :: Integer AS MovementId_Promo
        , COALESCE (MIFloat_WeightTare.ValueData, 0) * COALESCE (MIFloat_CountTare.ValueData, 0)
          INTO vbMovementId
             , vbGoodsId
             , vbGoodsKindId
             , vbMovementId_Promo
             , vbWeightTare_add
   FROM MovementItem
        LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                         ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                        AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
        LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                    ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                   AND MIFloat_PromoMovement.DescId         = zc_MIFloat_PromoMovementId()
        LEFT JOIN MovementItemFloat AS MIFloat_CountTare
                                    ON MIFloat_CountTare.MovementItemId = MovementItem.Id
                                   AND MIFloat_CountTare.DescId         = zc_MIFloat_CountTare()
        LEFT JOIN MovementItemFloat AS MIFloat_WeightTare
                                    ON MIFloat_WeightTare.MovementItemId = MovementItem.Id
                                   AND MIFloat_WeightTare.DescId         = zc_MIFloat_WeightTare()

   WHERE MovementItem.Id = inMovementItemId;

   
   vbMovementItemId_start:= COALESCE ((SELECT MovementItem.Id + 1
                                       FROM MovementItem
                                            -- нашли предыдущий ИТОГОВЫЙ
                                            INNER JOIN MovementItemBoolean AS MIBoolean_BarCode
                                                                           ON MIBoolean_BarCode.MovementItemId =  MovementItem.Id
                                                                          AND MIBoolean_BarCode.DescId         = zc_MIBoolean_BarCode()
                                                                          AND MIBoolean_BarCode.ValueData      = TRUE
                                            INNER JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                             AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                                                             AND MILinkObject_GoodsKind.ObjectId       = vbGoodsKindId
                                            INNER JOIN MovementItemFloat AS MIFloat_PromoMovement
                                                                         ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                                                        AND MIFloat_PromoMovement.DescId         = zc_MIFloat_PromoMovementId()
                                                                        AND MIFloat_PromoMovement.ValueData      = vbMovementId_Promo
                                       WHERE MovementItem.MovementId = vbMovementId
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = FALSE
                                         AND MovementItem.Id         < inMovementItemId
                                         AND MovementItem.ObjectId   = vbGoodsId
                                       ORDER BY MovementItem.Id DESC
                                       LIMIT 1
                                      )
                                    , (SELECT MIN (MovementItem.Id)
                                       FROM MovementItem
                                            INNER JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                             AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                                                             AND MILinkObject_GoodsKind.ObjectId       = vbGoodsKindId
                                            INNER JOIN MovementItemFloat AS MIFloat_PromoMovement
                                                                         ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                                                        AND MIFloat_PromoMovement.DescId         = zc_MIFloat_PromoMovementId()
                                                                        AND MIFloat_PromoMovement.ValueData      = vbMovementId_Promo
                                       WHERE MovementItem.MovementId = vbMovementId
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = FALSE
                                         AND MovementItem.ObjectId   = vbGoodsId
                                      )
                                     );

   -- Результат
   RETURN QUERY
       SELECT (SUM (COALESCE (MIFloat_RealWeight.ValueData, 0)
                  - COALESCE (MIFloat_WeightTare.ValueData, 0) * COALESCE (MIFloat_CountTare.ValueData, 0)
                   )
            + vbWeightTare_add
             ) :: TFloat
            , vbWeightTare_add

       FROM MovementItem
            INNER JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                             AND MILinkObject_GoodsKind.ObjectId       = vbGoodsKindId
            INNER JOIN MovementItemFloat AS MIFloat_PromoMovement
                                         ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                        AND MIFloat_PromoMovement.DescId         = zc_MIFloat_PromoMovementId()
                                        AND MIFloat_PromoMovement.ValueData      = vbMovementId_Promo
            LEFT JOIN MovementItemFloat AS MIFloat_RealWeight
                                        ON MIFloat_RealWeight.MovementItemId = MovementItem.Id
                                       AND MIFloat_RealWeight.DescId         = zc_MIFloat_RealWeight()
            LEFT JOIN MovementItemFloat AS MIFloat_CountTare
                                        ON MIFloat_CountTare.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountTare.DescId         = zc_MIFloat_CountTare()
            LEFT JOIN MovementItemFloat AS MIFloat_WeightTare
                                        ON MIFloat_WeightTare.MovementItemId = MovementItem.Id
                                       AND MIFloat_WeightTare.DescId         = zc_MIFloat_WeightTare()

       WHERE MovementItem.MovementId = vbMovementId
         AND MovementItem.DescId     = zc_MI_Master()
         AND MovementItem.isErased   = FALSE
         AND MovementItem.ObjectId   = vbGoodsId
         AND MovementItem.Id  BETWEEN vbMovementItemId_start AND inMovementItemId
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 20.07.25                                        *
*/

-- тест
-- SELECT *, AmountTotal - WeightTare_add  FROM gpGet_Scale_MI_StickerTotal (331192570, zfCalc_UserAdmin())
