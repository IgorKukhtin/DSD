-- Function: gpUpdate_Object_Branch_Personal()

--DROP FUNCTION IF EXISTS gpUpdate_Object_Branch_Personal (Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Branch_Personal (Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Branch_Personal(
    IN inId                    Integer   ,     -- ключ объекта <> 
    IN inPersonalId            Integer   ,     -- Сотрудник (бухгалтер) для расх.док.
    IN inPersonalStoreId       Integer   ,     -- Сотрудник (кладовщик)
    IN inPersonalBookkeeperId  Integer   ,     -- Сотрудник (бухгалтер)
    IN inPersonalBookkeeper    TVarChar,      -- Сотрудник (бухгалтер) подписант
    IN inPlaceOf               TVarChar  ,     -- место составления
    IN inPlaceCar               TVarChar,      -- Місце де зберігається автомобіль
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
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Branch_Personal(), inId, inPersonalId);
   -- сохранили св-во 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Branch_PersonalStore(), inId, inPersonalStoreId);
   -- сохранили св-во 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Branch_PersonalBookkeeper(), inId, inPersonalBookkeeperId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Branch_PersonalBookkeeper(), inId, inPersonalBookkeeper);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Branch_PlaceOf(), inId, inPlaceOf);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Branch_PlaceCar(), inId, inPlaceCar);        

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.07.26         *
 12.03.21         * add inPersonalBookkeeper
 20.12.15
 16.12.15         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Branch_Personal(inId:=null, inPersonalBookkeeperId:=null, inSession:='2')