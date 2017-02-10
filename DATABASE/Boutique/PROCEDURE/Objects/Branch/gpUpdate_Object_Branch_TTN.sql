-- Function: gpUpdate_Object_Branch_TTN()

DROP FUNCTION IF EXISTS gpUpdate_Object_Branch_TTN (Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Branch_TTN(
    IN inId                    Integer   ,     -- ключ объекта <> 
    IN inPersonalDriverId      Integer   ,     -- Водитель
    IN inMember1Id             Integer   ,     -- Водитель / экспедитор
    IN inMember2Id             Integer   ,     -- Бухгалтер
    IN inMember3Id             Integer   ,     -- Ответственное лицо(відпуск дозволив)
    IN inMember4Id             Integer   ,     -- Ответственное лицо(здав)
    IN inCarId                 Integer   ,     -- Автомобиль 
    IN inSession               TVarChar        -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Branch_TTN());

   -- сохранили св-во 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Branch_PersonalDriver(), inId, inPersonalDriverId);
   -- сохранили св-во 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Branch_Member1(), inId, inMember1Id);
   -- сохранили св-во 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Branch_Member2(), inId, inMember2Id);
   -- сохранили св-во 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Branch_Member3(), inId, inMember3Id);
   -- сохранили св-во 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Branch_Member4(), inId, inMember4Id);
   -- сохранили св-во 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Branch_Car(), inId, inCarId);
        
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.01.16         *
*/

-- тест
-- 