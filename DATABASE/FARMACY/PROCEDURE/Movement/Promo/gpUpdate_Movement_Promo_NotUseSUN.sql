-- Function: gpUpdate_Movement_Promo_NotUseSUN()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Promo_NotUseSUN (Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Movement_Promo_NotUseSUN(
    IN inMovementId              Integer    , -- Ключ объекта <Документ>
    IN inisNotUseSUN             Boolean    , -- Не использовать товар в СУН
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
    
    -- сохранили <Не использовать товар в СУН>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_NotUseSUN(), inMovementId, not inisNotUseSUN);
                        
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 10.10.22                                                       *
*/

-- select * from gpUpdate_Movement_Promo_NotUseSUN(inMovementId := 4193036 , inisNotUseSUN := 'False' ,  inSession := '3');