-- Function: gpUpdateObject_Partner_EdiOrdspr 


DROP FUNCTION IF EXISTS gpUpdateObject_Partner_Edi (Integer, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObject_Partner_Edi (
    IN ioId                  Integer   , -- Ключ объекта <Документ>
 INOUT inValue               Boolean   , -- Проверен
    IN inDesc                TVarChar  , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Boolean 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Partner());

     -- определили признак
     inValue:= NOT inValue;
     
     -- сохранили свойство
     PERFORM lpInsertUpdate_ObjectBoolean (tmpDesc.Id, ioId, inValue)
           FROM ObjectBooleanDesc AS tmpDesc
           WHERE ItemName = inDesc;
   
  -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (ioId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 06.02.15         * 
*/


-- тест
-- SELECT * FROM gpUpdateObject_Partner_Edi (ioId:=  83674 , inValue:= false , inDesc := 'Счет', inSession:= '5')
