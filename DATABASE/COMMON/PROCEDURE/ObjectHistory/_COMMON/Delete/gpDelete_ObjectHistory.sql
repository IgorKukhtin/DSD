-- Function: gpDelete_ObjectHistory()

DROP FUNCTION IF EXISTS gpDelete_ObjectHistory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_ObjectHistory(
    IN inId                  Integer   ,  -- ключ объекта 
    IN inSession             TVarChar     -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem());

    
   PERFORM lpDelete_ObjectHistory (inId	       := inId
                                 , inSession   := inSession
                                   );

   -- сохранили протокол
  -- PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.08.15         *
*/

