--

DROP FUNCTION IF EXISTS gpUpdate_Object_Composition_NameUKR (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Composition_NameUKR(
    IN inId           Integer,       -- Ключ объекта <Название>    
    IN inName_UKR     TVarChar,      -- Название объекта <Название> укр
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Composition());
   vbUserId:= lpGetUserBySession (inSession);

   -- сохранили свойство
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Composition_UKR(), inId, inName_UKR);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.08.20          *
*/

/*
 SELECT * 
 , lpInsertUpdate_ObjectString (zc_ObjectString_Composition_UKR(), Object.Id, 
--  zfCalc_Text_replace(ObjectString.ValueData, 'хл', 'бав')
--  zfCalc_Text_replace(ObjectString.ValueData, 'кожа', 'шкіра')
--  zfCalc_Text_replace(ObjectString.ValueData, 'Э', 'Е')
''

 )

FROM Object 
     join ObjectString on ObjectString.ObjectId = Object.Id
                      and ObjectString.DescId = zc_ObjectString_Composition_UKR()

where Object.descId = zc_Object_Composition()
-- and ObjectString.ValueData  like '%Э%' 
and ObjectString.ValueData  = Object.ValueData
*/
-- тест
--