-- Function: gpUpdate_Movement_OrderInternalPromo()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderInternalPromoPartner (Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderInternalPromoPartner (Integer, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderInternalPromoPartner(
    IN inId                    Integer    , -- Ключ объекта <Документ>
    IN inComment               TVarChar   , -- Примечание
    IN inCorrPrice             TFloat     , -- Корректировка цены
    IN inIsErased              Boolean    , -- Удаленный ли элемент
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId    Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
    
    -- сохранили <Примечание>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), inId, inComment);
    
    -- сохранили <Корректировка цены>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CorrOther(), inId, inCorrPrice);

    --переопределяем. 
    inIsErased := NOT inIsErased;
    
    IF inIsErased = TRUE
    THEN
        -- Удаляем Документ
        PERFORM lpSetErased_Movement (inMovementId := inId
                                    , inUserId     := vbUserId);
    ELSE
        PERFORM lpUnComplete_Movement (inMovementId := inId
                                     , inUserId     := vbUserId);
    END IF;
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 10.02.21                                                       *
 21.04.19         *
*/