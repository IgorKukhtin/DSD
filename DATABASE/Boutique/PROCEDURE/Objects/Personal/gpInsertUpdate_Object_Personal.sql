-- Function: gpInsertUpdate_Object_Personal (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Personal (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Personal(
 INOUT ioId                       Integer   ,    -- Ключ объекта <Сотрудники> 
    IN inCode                     Integer   ,    -- Код объекта <Сотрудники>     
    IN inName                     TVarChar  ,    -- Название объекта <Сотрудники>
    IN inMemberId                 Integer   ,    -- ключ объекта <Физические лица> 
    IN inPositionId               Integer   ,    -- ключ объекта <Должности> 
    IN inUnitId                   Integer   ,    -- ключ объекта <Подразделения> 
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Personal());
   vbUserId:= lpGetUserBySession (inSession);

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF inCode = 0 THEN  inCode := NEXTVAL ('Object_Personal_seq'); END IF; 

   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Personal(), inName);

   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Personal(), inCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Personal(), inCode, inName);
   
   -- сохранили связь с <Физические лица>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Personal_Member(), ioId, inMemberId);
   -- сохранили связь с <Должности>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Personal_Position(), ioId, inPositionId);
   -- сохранили связь с <Подразделения>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Personal_Unit(), ioId, inUnitId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятикин А.А.
28.03.17                                                           *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Personal()
