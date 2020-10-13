-- Function: gpUpdate_Movement_Promo_RelatedProduct()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Promo_RelatedProduct (Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Movement_Promo_RelatedProduct(
    IN inMovementId                    Integer    , -- Ключ объекта <Документ>
    IN inRelatedProductId              Integer    , -- главый документ Сопутствующие товары
    IN inSession                       TVarChar     -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId    Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
           
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
    END IF;
    
    -- сохранили <Сопутствующие товары>
    PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_RelatedProduct(), inMovementId, inRelatedProductId);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 13.10.20                                                       *
*/