-- Function: gpUpdate_MI_PersonalService_isMain()

DROP FUNCTION IF EXISTS gpUpdate_MI_PersonalService_isMain (Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PersonalService_isMain(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
 INOUT ioIsMain              Boolean   , -- Основное место работы
    IN inSession             TVarChar    -- пользователь
)
RETURNS Boolean AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbUserId Integer;
BEGIN
     
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService());


     -- определили признак
     ioIsMain:= NOT ioIsMain; 
    
      -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Main(), inId, ioIsMain);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 03.10.14         *
*/

-- тест
-- SELECT * FROM gpUpdate_MI_PersonalService_isMain (inId:= 0, inisMain:= true, inSession:= '2')

--select * from gpUpdate_MI_PersonalService_isMain(inId := 4771714 , ioIsMain := 'false' ,  inSession := '5');