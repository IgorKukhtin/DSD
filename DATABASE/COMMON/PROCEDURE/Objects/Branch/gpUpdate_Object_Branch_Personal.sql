-- Function: gpUpdate_Object_Branch_Personal()

DROP FUNCTION IF EXISTS gpUpdate_Object_Branch_Personal (Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_Branch_Personal(
    IN inId                    Integer   ,     -- ключ объекта <> 
    IN inPersonalBookkeeperId  Integer   ,     -- Сотрудник (бухгалтер)
    IN inSession               TVarChar        -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Branch_Personal());


   -- сохранили св-во 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Branch_PersonalBookkeeper(), inId, inPersonalBookkeeperId);

        
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.12.15         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Branch_Personal(inId:=null, inPersonalBookkeeperId:=null, inSession:='2')