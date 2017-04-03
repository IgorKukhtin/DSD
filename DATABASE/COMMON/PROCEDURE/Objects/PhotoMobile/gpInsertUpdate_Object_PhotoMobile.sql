-- Function: gpInsertUpdate_Object_PhotoMobile()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PhotoMobile(Integer, Integer, TVarChar, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PhotoMobile(
 INOUT ioId             Integer   ,     -- ключ объекта <Регионы> 
    IN inCode           Integer   ,     -- MovementItemId
    IN inName           TVarChar  ,     -- Название объекта 
    IN inPhotoData      TBlob     ,
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_PhotoMobile());

   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_PhotoMobile(), inName);


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object_PhotoMobile (ioId	   := ioId
                                            , inCode       := inCode
                                            , inName       := inName
                                            , inPhotoData  := inPhotoData
                                            , inUserId     := vbUserId
                                             );
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.03.17         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_PhotoMobile(ioId:=null, inCode:=null, inName:='Регион 1', inSession:='2')