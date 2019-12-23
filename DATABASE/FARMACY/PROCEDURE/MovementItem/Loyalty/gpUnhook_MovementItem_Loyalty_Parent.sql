-- Function: gpUnhook_MovementItem_Loyalty_Parent()

DROP FUNCTION IF EXISTS gpUnhook_MovementItem_Loyalty_Parent (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnhook_MovementItem_Loyalty_Parent(
    IN inId                  Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
    
    
    -- сохранили
   update  MovementItem set parentID = Null where ID = inId;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.12.19                                                       *
*/