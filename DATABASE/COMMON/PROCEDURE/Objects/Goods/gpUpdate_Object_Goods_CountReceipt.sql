-- Function: gpUpdate_Object_Goods_CountReceipt()

DROP FUNCTION IF EXISTS gpUpdate_Object_Goods_CountReceipt (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Goods_CountReceipt(
    IN inId                  Integer   , -- Ключ объекта <товар>
    IN inCountReceipt        TFloat    , -- колво партий 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Goods());

     IF COALESCE (inId,0) = 0
     THEN
         RETURN;
     END IF;

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_CountReceipt(), inId, inCountReceipt);

     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.04.20         *
*/


-- тест
--