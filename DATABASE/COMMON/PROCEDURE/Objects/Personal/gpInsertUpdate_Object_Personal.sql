-- Function: gpInsertUpdate_Object_Personal()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Personal (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, Boolean, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Personal (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, Boolean, Boolean, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Personal (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TDateTime, Boolean, Boolean, Boolean, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Personal (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TDateTime, Boolean, Boolean, Boolean, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Personal(
 INOUT ioId                                Integer   , -- ключ объекта <Сотрудники>
    IN inMemberId                          Integer   , -- ссылка на Физ.лица
    IN inPositionId                        Integer   , -- ссылка на Должность
    IN inPositionLevelId                   Integer   , -- ссылка на Разряд должности
    IN inUnitId                            Integer   , -- ссылка на Подразделение
    IN inPersonalGroupId                   Integer   , -- Группировки Сотрудников
    IN inPersonalServiceListId             Integer   , -- Ведомость начисления(главная)
    IN inPersonalServiceListOfficialId     Integer   , -- Ведомость начисления(БН)
    IN inPersonalServiceListCardSecondId   Integer   , -- Ведомость начисления(Карта Ф2) 
    IN inPersonalServiceListId_AvanceF2    Integer   , --  Ведомость начисления(аванс Карта Ф2)
    IN inSheetWorkTimeId                   Integer   , -- Режим работы (Шаблон табеля р.вр.)
    IN inStorageLineId                     Integer   , -- ссылка на линию производства
    
    IN inMember_ReferId                    Integer   , -- сФамилия рекомендателя
    IN inMember_MentorId                   Integer   , -- Фамилия наставника 	
    IN inReasonOutId                       Integer   , -- Причина увольнения 	
    
    IN inDateIn                            TDateTime , -- Дата принятия
    IN inDateOut                           TDateTime , -- Дата увольнения 
    IN inDateSEnd                          TDateTime , -- Дата перевода
    IN inIsDateOut                         Boolean   , -- Уволен
    IN inIsDateSend                        Boolean   , -- переведен
    IN inIsMain                            Boolean   , -- Основное место работы
    IN inComment                           TVarChar  ,
    IN inSession                           TVarChar    -- сессия пользователя
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

   -- !!! это временно !!!
   -- IF COALESCE(ioId, 0) = 0
   -- THEN ioId := (SELECT PersonalId FROM Object_Personal_View WHERE PersonalName = vbName AND UnitId = inUnitId AND PositionId = COALESCE (inPositionId, 0) AND PositionLevelId = COALESCE (inPositionLevelId, 0));
   -- END IF;

   -- проверка  уникальности для свойств: <ФИО> + <Подразделение> + <Должность> + <Разряд должности>
   IF EXISTS (SELECT 1 FROM Object_Personal_View WHERE PersonalName = vbName AND UnitId = inUnitId AND PositionId = COALESCE (inPositionId, 0) AND PositionLevelId = COALESCE (inPositionLevelId, 0) AND StorageLineId = COALESCE (inStorageLineId, 0) AND PersonalId <> COALESCE(ioId, 0)) THEN
      RAISE EXCEPTION 'Значение <%>%для подразделения: <%>%должность: <%>% % %не уникально в справочнике <%>.'
                    , vbName
                    , CHR (13)
                    , lfGet_Object_ValueData_sh (inUnitId)
                    , CHR (13)
                    , lfGet_Object_ValueData_sh (inPositionId)

                    , CASE WHEN inPositionLevelId > 0 THEN CHR (13) || 'разряд должности: ' || '<' || lfGet_Object_ValueData_sh (inPositionLevelId) || '>' ELSE '' END
                    , CASE WHEN inStorageLineId > 0 THEN CHR (13) || 'линия производства: ' || '<' || lfGet_Object_ValueData_sh (inStorageLineId) || '>' ELSE '' END

                    , CHR (13)
                    , (SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Personal())
                     ;
   END IF;
   -- Основное место работы - только одно
   IF inIsMain = TRUE
      AND EXISTS (SELECT 1 FROM Object_Personal_View AS View_Personal WHERE View_Personal.MemberId = inMemberId AND View_Personal.isMain = TRUE AND View_Personal.PersonalId <> COALESCE(ioId, 0)) THEN
      RAISE EXCEPTION 'Значение <Основное место работы> = ДА, уже установлено для подразделения: <%> должность: <%> разряд должности: <%>. Этот признак можно установить только 1 раз.'
                    , lfGet_Object_ValueData_sh ((SELECT View_Personal.UnitId          FROM Object_Personal_View AS View_Personal WHERE View_Personal.MemberId = inMemberId AND View_Personal.isMain = TRUE ORDER BY View_Personal.PersonalId LIMIT 1))
                    , lfGet_Object_ValueData_sh ((SELECT View_Personal.PositionId      FROM Object_Personal_View AS View_Personal WHERE View_Personal.MemberId = inMemberId AND View_Personal.isMain = TRUE ORDER BY View_Personal.PersonalId LIMIT 1))
                    , lfGet_Object_ValueData_sh ((SELECT View_Personal.PositionLevelId FROM Object_Personal_View AS View_Personal WHERE View_Personal.MemberId = inMemberId AND View_Personal.isMain = TRUE ORDER BY View_Personal.PersonalId LIMIT 1))
                     ;
   END IF;
   


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Personal(), vbCode, vbName
                                , inAccessKeyId:= COALESCE ((SELECT Object_Branch.AccessKeyId FROM ObjectLink LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink.ChildObjectId WHERE ObjectLink.ObjectId = inUnitId AND ObjectLink.DescId = zc_ObjectLink_Unit_Branch())
                                                            -- если это "транспортное" подразделение
                                                          , (SELECT zc_Enum_Process_AccessKey_TrasportDnepr() WHERE EXISTS (SELECT 1 FROM ObjectLink WHERE DescId = zc_ObjectLink_Car_Unit() AND ChildObjectId = inUnitId))
                                                           )
                                 );
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
   -- сохранили связь с <Ведомость начисления()>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_PersonalServiceList(), ioId, inPersonalServiceListId);
   -- сохранили связь с <Ведомость начисления(БН)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_PersonalServiceListOfficial(), ioId, inPersonalServiceListOfficialId);
   -- сохранили связь с <Ведомость начисления(карта ф2)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_PersonalServiceListCardSecond(), ioId, inPersonalServiceListCardSecondId);
   -- сохранили связь с <Ведомость начисления(аванс Карта Ф2)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_PersonalServiceListAvance_F2(), ioId, inPersonalServiceListId_AvanceF2);
   -- сохранили связь с <Режим работы (Шаблон табеля р.вр.)>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Personal_SheetWorkTime(), ioId, inSheetWorkTimeId);
   -- сохранили связь с <линия производства>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_StorageLine(), ioId, inStorageLineId);
   -- сохранили свойство <Дата принятия>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Personal_In(), ioId, inDateIn);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Member_Refer(), ioId, inMember_ReferId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Member_Mentor(), ioId, inMember_MentorId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_ReasonOut(), ioId, inReasonOutId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Personal_Comment(), ioId, inComment);


   -- сохранили свойство <Дата увольнения>
   IF inIsDateOut = TRUE
   THEN
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Personal_Out(), ioId, inDateOut);
   ELSE
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Personal_Out(), ioId, zc_DateEnd());
   END IF;  
   
   IF inIsDateSend = TRUE
   THEN
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Personal_Send(), ioId, inDateSEnd);
   ELSE
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Personal_Send(), ioId, Null);
   END IF;


   -- сохранили свойство <Основное место работы>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Personal_Main(), ioId, inIsMain);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

   -- для Админа
   IF vbUserId IN (5, 9457)
   THEN
       RAISE EXCEPTION 'Ошибка.test=ok';
   END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.04.23         *
 19.04.23         *
 06.08.21         *
 13.07.17         * add PersonalServiceListCardSecond
 25.05.16         * add StorageLine
 16.11.16         * add inSheetWorkTimeId
 26.08.15         * add PersonalServiceListOfficial
 07.05.15         * add PersonalServiceList
 12.09.14                                        * add inIsDateOut and inIsOfficial
 21.05.14                        * add inOfficial
 14.12.13                                        * add inAccessKeyId берем по другому
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
