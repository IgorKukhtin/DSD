-- Function: gpUpdateObject_Partner_EdiOrdspr 


DROP FUNCTION IF EXISTS gpUpdateObject_Partner_Edi (Integer, Boolean, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdateObject_Partner_Edi (
    IN inId                  Integer   , -- Ключ объекта <Документ>
 INOUT ioValue               Boolean   , -- Проверен
    IN inDescCode            TVarChar  , -- 
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
     ioValue:= NOT ioValue;
     
     -- сохранили свойство
     PERFORM lpInsertUpdate_ObjectBoolean (tmpDesc.Id, inId, ioValue)
           FROM ObjectBooleanDesc AS tmpDesc
           WHERE Code = inDescCode;
   
  -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);
  
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
