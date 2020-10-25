-- Function: gpInsertUpdate_Object_Personal()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Personal (Integer, Integer, Integer, Integer,  TDateTime, TDateTime, Boolean, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Personal(
 INOUT ioId             Integer   , -- ключ объекта <Сотрудники>
    IN inMemberId       Integer   , -- ссылка на Физ.лица
    IN inPositionId     Integer   , -- ссылка на Должность
    IN inUnitId         Integer   , -- ссылка на Подразделение
    IN inDateIn         TDateTime , -- Дата принятия
    IN inDateOut        TDateTime , -- Дата увольнения
    IN inIsDateOut      Boolean   , -- Уволен
    IN inIsMain         Boolean   , -- Основное место работы
    IN inComment        TVarChar  ,
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;
   DECLARE vbName TVarChar;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Personal());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

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

   -- проверка  уникальности для свойств: <ФИО> + <Подразделение> + <Должность> + <Разряд должности>
   IF EXISTS (SELECT 1 
              FROM Object_Personal_View 
              WHERE PersonalName = vbName
                AND UnitId = inUnitId
                AND PositionId = COALESCE (inPositionId, 0)
              --AND PositionLevelId = COALESCE (inPositionLevelId, 0)
                AND PersonalId <> COALESCE(ioId, 0)) 
   THEN
      RAISE EXCEPTION 'Значение <%> для подразделения: <%> должность: <%> не уникально в справочнике <%>.'   ---разряд должности: <%>
                    , vbName
                    , lfGet_Object_ValueData_sh (inUnitId)
                    , lfGet_Object_ValueData_sh (inPositionId)
                    --, COALESCE (lfGet_Object_ValueData_sh (inPositionLevelId), '')
                    , (SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Personal());
   END IF;
   -- Основное место работы - только одно
   IF inIsMain = TRUE
      AND EXISTS (SELECT 1 FROM Object_Personal_View AS View_Personal WHERE View_Personal.MemberId = inMemberId AND View_Personal.isMain = TRUE AND View_Personal.PersonalId <> COALESCE(ioId, 0)) THEN
      RAISE EXCEPTION 'Значение <Основное место работы> = ДА, уже установлено для подразделения: <%> должность: <%>. Этот признак можно установить только 1 раз.'
                    , lfGet_Object_ValueData_sh ((SELECT View_Personal.UnitId          FROM Object_Personal_View AS View_Personal WHERE View_Personal.MemberId = inMemberId AND View_Personal.isMain = TRUE ORDER BY View_Personal.PersonalId LIMIT 1))
                    , lfGet_Object_ValueData_sh ((SELECT View_Personal.PositionId      FROM Object_Personal_View AS View_Personal WHERE View_Personal.MemberId = inMemberId AND View_Personal.isMain = TRUE ORDER BY View_Personal.PersonalId LIMIT 1))
                    --, lfGet_Object_ValueData_sh ((SELECT View_Personal.PositionLevelId FROM Object_Personal_View AS View_Personal WHERE View_Personal.MemberId = inMemberId AND View_Personal.isMain = TRUE ORDER BY View_Personal.PersonalId LIMIT 1))
                     ;
   END IF;
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Personal(), vbCode, vbName);

   -- сохранили связь с <физ.лицом>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Member(), ioId, inMemberId);
   -- сохранили связь с <должностью>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Position(), ioId, inPositionId);
   -- сохранили связь с <Разряд должности>
   --PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_PositionLevel(), ioId, inPositionLevelId);
   -- сохранили связь с <подразделением>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Unit(), ioId, inUnitId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Personal_Comment(), ioId, inComment);

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

   IF vbIsInsert = TRUE THEN
      -- сохранили свойство <Дата создания>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (создание)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.10.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Personal (ioId:=0, inCode:=0, inName:='ЧУМАК заготовитель', inMemberId:=26622, inPositionId:=0, inUnitId:=21778, inJuridicalId:=23966, inBusinessId:=0, inDateIn:=null, inDateOut:=null, inSession:='2')
