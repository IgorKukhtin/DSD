-- Function: gpInsertUpdate_Object_AccommodationUnit_Unit()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_AccommodationUnit_Unit (Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_AccommodationUnit_Unit(
 INOUT ioId	                 Integer   ,    -- ключ объекта
    IN inUnitId              Integer   ,    -- ключ объекта подразделение
    IN inCode                Integer   ,    -- код объекта
    IN inName                TVarChar  ,    -- Название объекта <
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE ObjectName TVarChar;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Education());
   vbUserId:= lpGetUserBySession (inSession);

   IF COALESCE(ioId, 0 ) <> 0 AND
      (SELECT ObjectLink_Accommodation_Unit.ChildObjectId FROM ObjectLink AS ObjectLink_Accommodation_Unit
       WHERE ObjectLink_Accommodation_Unit.ObjectId = ioId
         AND ObjectLink_Accommodation_Unit.DescId = zc_Object_Accommodation_Unit()) <> inUnitId
   THEN
     RAISE EXCEPTION 'Изменять название привязки можно только по обрабатываемому подразделению <%>.',  (SELECT ValueData FROM Object WHERE Id = inUnitId);   
   END IF;

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Accommodation());

   -- проверка уникальности <Наименование>
   IF EXISTS (SELECT Object.ValueData FROM Object

                 INNER JOIN ObjectLink AS ObjectLink_Accommodation_Unit
                                       ON ObjectLink_Accommodation_Unit.ChildObjectId = inUnitId
                                      AND ObjectLink_Accommodation_Unit.ObjectId = Object.Id
                                      AND ObjectLink_Accommodation_Unit.DescId = zc_Object_Accommodation_Unit()

              WHERE Object.DescId = zc_Object_Accommodation()
                AND Object.ValueData = inName
                AND Object.Id <> COALESCE(ioId, 0 ))
   THEN
      SELECT ItemName INTO ObjectName FROM ObjectDesc WHERE Id = zc_Object_Accommodation();
      RAISE EXCEPTION 'Значение "%" не уникально для справочника "%" по подразделению "%"', inName, ObjectName,
        (SELECT ValueData FROM Object WHERE Id = inUnitId);
   END IF;
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Accommodation(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Accommodation(), vbCode_calc, inName);

   -- сохранили связь с <Подразделением>
   PERFORM lpInsertUpdate_ObjectLink (zc_Object_Accommodation_Unit(), ioId, inUnitId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_AccommodationUnit_Unit(Integer, Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 17.08.18         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_AccommodationUnit_Unit()