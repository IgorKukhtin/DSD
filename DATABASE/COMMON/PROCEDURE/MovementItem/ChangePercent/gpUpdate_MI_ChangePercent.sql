-- Function: gpUpdate_MI_ChangePercent()

DROP FUNCTION IF EXISTS gpUpdate_MI_ChangePercent (integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_MI_ChangePercent(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ChangePercent());
     vbUserId:= lpGetUserBySession (inSession);

     -- обновляем строки
     PERFORM lpInsertUpdate_MI_ChangePercent_byTax (inMovementId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.03.23         *
*/

-- тест
--