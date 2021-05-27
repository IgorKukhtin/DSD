-- Function: gpUpdate_Movement_Promo_Supplement()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Promo_Supplement (Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Movement_Promo_Supplement(
    IN inMovementId              Integer    , -- Ключ объекта <Документ>
    IN inisSupplement            Boolean    , -- Использовать товар в дополнении СУН
    IN inSession                 TVarChar     -- сессия пользователя
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
    
    -- сохранили <Использовать товар в дополнении СУН>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Supplement(), inMovementId, not inisSupplement);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 26.05.21                                                       *
*/

-- select * from gpUpdate_Movement_Promo_Supplement(inMovementId := 4193036 , inisSupplement := 'False' ,  inSession := '3');