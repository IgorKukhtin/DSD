-- Function: gpInsertUpdate_Object_Personal()

-- DROP FUNCTION gpInsertUpdate_Object_Personal (Integer, Integer, Integer, Integer,Integer,Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Personal(
 INOUT ioId                  Integer   , -- ключ объекта <Сотрудники>
    IN inMemberId            Integer   , -- ссылка на Физ.лица 
    IN inPositionId          Integer   , -- ссылка на Должность
    IN inPositionLevelId     Integer   , -- ссылка на Разряд должности
    IN inUnitId              Integer   , -- ссылка на Подразделение
    IN inPersonalGroupId     Integer   , -- Группировки Сотрудников
    IN inDateIn              TDateTime , -- Дата принятия
    IN inDateOut             TDateTime , -- Дата увольнения
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;   
   DECLARE vbName TVarChar;   
   DECLARE vbAccessKeyId_calc Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Personal());
   vbUserId := inSession;
   

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
   SELECT ObjectCode, ValueData, AccessKeyId INTO vbCode, vbName, vbAccessKeyId_calc FROM Object WHERE Id = inMemberId;   

   -- !!! это временно !!!
   -- IF COALESCE(ioId, 0) = 0
   -- THEN ioId := (SELECT PersonalId FROM Object_Personal_View WHERE PersonalName = vbName AND UnitId = inUnitId AND PositionId = COALESCE (inPositionId, 0) AND PositionLevelId = COALESCE (inPositionLevelId, 0));
   -- END IF;

   -- проверка  уникальности для свойств: <ФИО> + <Подразделение> + <Должность> + <Разряд должности>
   IF EXISTS (SELECT PersonalName FROM Object_Personal_View WHERE PersonalName = vbName AND UnitId = inUnitId AND PositionId = COALESCE (inPositionId, 0) AND PositionLevelId = COALESCE (inPositionLevelId, 0) AND PersonalId <> COALESCE(ioId, 0)) THEN
      RAISE EXCEPTION 'Значение <%> для подразделения: <%> должность: <%> разряд должности: <%> не уникально в справочнике <%>.'
                    , vbName
                    , lfGet_Object_ValueData (inUnitId)
                    , lfGet_Object_ValueData (inPositionId)
                    , COALESCE (lfGet_Object_ValueData (inPositionLevelId), '')
                    , (SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Personal());
   END IF; 


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Personal(), vbCode, vbName, inAccessKeyId:= vbAccessKeyId_calc);
   -- сохранили связь с <физ.лицом>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Member(), ioId, inMemberId);
   -- сохранили связь с <должностью>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Position(), ioId, inPositionId);
   -- сохранили связь с <Разряд должности>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_PositionLevel(), ioId, inPositionLevelId);
   -- сохранили связь с <подразделением>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Unit(), ioId, inUnitId);
      -- сохранили связь с <Группировки Сотрудников>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_PersonalGroup(), ioId, inPersonalGroupId);
   -- сохранили свойство <Дата принятия>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Personal_In(), ioId, inDateIn);
   -- сохранили свойство <Дата увольнения>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Personal_Out(), ioId, inDateOut);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Personal (Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar) OWNER TO postgres;

  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.12.13                                        * add inAccessKeyId берем у <Физические лица>
 21.11.13                                        * add проверка уникальности для свойств
 21.11.13                                        * add inPositionLevelId
 09.11.13                                        * синхронизируем с объектом <Физические лица>
 28.10.13                                        * add RAISE...
 30.09.13                                        * del vbCode
 25.09.13         * add _PersonalGroup; remove _Juridical, _Business              
 06.09.13                         * inName - УБРАЛ. Не нашел для него применения
 24.07.13                                        * inName - БЫТЬ !!! или хотя бы vbMemberName
 01.07.13          * 
 19.07.13                         * 
 19.07.13         *    rename zc_ObjectDate...
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Personal (ioId:=0, inCode:=0, inName:='ЧУМАК заготовитель', inMemberId:=26622, inPositionId:=0, inUnitId:=21778, inJuridicalId:=23966, inBusinessId:=0, inDateIn:=null, inDateOut:=null, inSession:='2')
