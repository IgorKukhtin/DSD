-- Function: gpUpdate_Movement_Promo_Checked()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Promo_Checked (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Promo_Checked(
    IN inId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId          Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
    
      
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.06.20         
*/
