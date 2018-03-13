-- Function: gpInsertUpdate_Object_Personal (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Personal (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Personal(
 INOUT ioId                       Integer   ,    -- Ключ объекта <Сотрудники> 
 INOUT ioCode                     Integer   ,    -- Код объекта <Сотрудники>     
    IN inName                     TVarChar  ,    -- Название объекта <Сотрудники>
    IN inMemberId                 Integer   ,    -- ключ объекта <Физические лица> 
    IN inPositionId               Integer   ,    -- ключ объекта <Должности> 
    IN inUnitId                   Integer   ,    -- ключ объекта <Подразделения> 
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Personal());
   vbUserId:= lpGetUserBySession (inSession);

   -- Нужен ВСЕГДА- ДЛЯ НОВОЙ СХЕМЫ С ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) <> 0 THEN ioCode := NEXTVAL ('Object_Personal_seq'); 
   END IF; 

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) = 0  THEN ioCode := NEXTVAL ('Object_Personal_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := COALESCE ((SELECT ObjectCode FROM Object WHERE Id = ioId), 0);
   END IF; 

   -- проверка
   IF ioId > 0 AND vbUserId = zc_User_Sybase()
   THEN
       -- <Подразделения>
       IF inPositionId = 0 THEN inPositionId:= (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Personal_Position() AND ObjectId = ioId); END IF;
       -- <Подразделения>
       IF inUnitId = 0 THEN inUnitId:= (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Personal_Unit() AND ObjectId = ioId); END IF;
   END IF;


   -- проверка
   IF COALESCE (inMemberId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка. <ФИО> не выбрано.';
   END IF;
   -- проверка
   IF COALESCE (inUnitId, 0) = 0 AND vbUserId <> zc_User_Sybase()
   THEN
       RAISE EXCEPTION 'Ошибка. <Подразделение> не выбрано.';
   END IF;
   -- проверка
   IF COALESCE (inPositionId, 0) = 0 AND vbUserId <> zc_User_Sybase()
   THEN
       RAISE EXCEPTION 'Ошибка. <Должность> не выбрана.';
   END IF;


   -- проверка прав уникальности для свойства <Название>
   -- PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Personal(), (SELECT Object.ValueData FROM Object WHERE Object.Id = inMemberId));
                                          
   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Personal(), ioCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Personal(), ioCode, (SELECT Object.ValueData FROM Object WHERE Object.Id = inMemberId));
   
   -- сохранили связь с <Физические лица>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Member(), ioId, inMemberId);
   -- сохранили связь с <Должности>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Position(), ioId, inPositionId);
   -- сохранили связь с <Подразделения>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Unit(), ioId, inUnitId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятикин А.А.
13.05.17                                                           *
08.05.17                                                           *
28.03.17                                                           *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Personal()
