-- Function: gpInsertUpdate_Object_Personal()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Personal (Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, Boolean, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Personal(
 INOUT ioId                            Integer   , -- ключ объекта <Сотрудники>
    IN inMemberId                      Integer   , -- ссылка на Физ.лица 
    IN inPositionId                    Integer   , -- ссылка на Должность
    IN inUnitId                        Integer   , -- ссылка на Подразделение
    IN inPersonalGroupId               Integer   , -- Группировки Сотрудников
    IN inDateIn                        TDateTime , -- Дата принятия
    IN inDateOut                       TDateTime , -- Дата увольнения
    IN inIsDateOut                     Boolean   , -- Уволен
    IN inIsMain                        Boolean   , -- Основное место работы
    IN inSession                       TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;   
   DECLARE vbName TVarChar;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Personal());

   -- проверка
   IF COALESCE (inMemberId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка. <ФИО> не выбрано.';
   END IF;
   -- проверка
   IF COALESCE (inUnitId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка. <Подразделение> не выбрано.';
   END IF;
   -- проверка
   IF COALESCE (inPositionId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка. <Должность> не выбрана.';
   END IF;

   -- определяем параметры, т.к. значения должны быть синхронизированы с объектом <Физические лица>
   SELECT ObjectCode, ValueData INTO vbCode, vbName FROM Object WHERE Id = inMemberId;   

   -- проверка  уникальности для свойств: <ФИО> + <Подразделение> + <Должность> 
   IF EXISTS (SELECT PersonalName FROM Object_Personal_View WHERE PersonalName = vbName AND UnitId = inUnitId AND PositionId = COALESCE (inPositionId, 0) AND PersonalId <> COALESCE(ioId, 0)) THEN
      RAISE EXCEPTION 'Значение <%> для подразделения: <%> должность: <%> не уникально в справочнике <%>.'
                    , vbName
                    , lfGet_Object_ValueData (inUnitId)
                    , lfGet_Object_ValueData (inPositionId)
                    , (SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Personal());
   END IF; 


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Personal(), vbCode, vbName);

   -- сохранили связь с <физ.лицом>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Member(), ioId, inMemberId);
   -- сохранили связь с <должностью>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Position(), ioId, inPositionId);

   -- сохранили связь с <подразделением>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Unit(), ioId, inUnitId);
   -- сохранили связь с <Группировки Сотрудников>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_PersonalGroup(), ioId, inPersonalGroupId);
    -- сохранили свойство <Дата принятия>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Personal_In(), ioId, inDateIn);

   -- сохранили свойство <Дата увольнения>
   IF inIsDateOut = TRUE
   THEN
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Personal_Out(), ioId, inDateOut);
   ELSE
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Personal_Out(), ioId, zc_DateEnd());
   END IF;
   -- сохранили свойство <Основное место работы>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Personal_Main(), ioId, inIsMain);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Personal (Integer, Integer, Integer, Integer, Integer,TDateTime, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;

  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.01.16         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Personal (ioId:=0, inCode:=0, inName:='ЧУМАК заготовитель', inMemberId:=26622, inPositionId:=0, inUnitId:=21778, inDateIn:=null, inDateOut:=null, inSession:='2')
