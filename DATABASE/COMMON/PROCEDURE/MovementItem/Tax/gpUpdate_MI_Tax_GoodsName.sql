-- Function: gpUpdate_MI_Tax_GoodsName()

DROP FUNCTION IF EXISTS gpUpdate_MI_Tax_GoodsName (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Tax_GoodsName(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inGoodsName           TVarChar  , -- другое название
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Tax());


     -- сохранили свойство <другое название>  --редактирование в гриде
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GoodsName(), inId, inGoodsName);


     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.06.24         *
*/

-- тест
--