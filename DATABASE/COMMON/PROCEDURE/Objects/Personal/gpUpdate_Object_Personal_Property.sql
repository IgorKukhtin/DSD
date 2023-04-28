-- Function: gpUpdate_Object_Personal_Property ()

--DROP FUNCTION IF EXISTS gpUpdate_Object_Personal_Property (Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpUpdate_Object_Personal_Property (Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Personal_Property (Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Personal_Property(
    IN inId                                Integer   , -- ключ объекта <Сотрудники>
    IN inPositionId                        Integer   , -- ссылка на Должность
    IN inUnitId                            Integer   , -- ссылка на Подразделение
    IN inPersonalServiceListOfficialId     Integer   , -- Ведомость начисления(БН)
    IN inPersonalServiceListCardSecondId   Integer   , -- Ведомость начисления(Карта Ф2)  
    IN inPersonalServiceListId_AvanceF2    Integer   , -- Ведомость начисления(аванс Карта Ф2)
    IN inStorageLineId                     Integer   , -- ссылка на линию производства
    IN inCode1C                            TVarChar  , --код 1С
    IN inIsMain                            Boolean   , -- Основное место работы
    IN inSession                           TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbMemberId Integer;
   DECLARE vbCode     Integer;
   DECLARE vbName     TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Personal());


   -- Основное место работы - только одно
   vbMemberId:=  (SELECT View_Personal.MemberId FROM Object_Personal_View AS View_Personal WHERE View_Personal.PersonalId = inId);
   -- Основное место работы - только одно
   IF inIsMain = TRUE
      AND EXISTS (SELECT 1 FROM Object_Personal_View AS View_Personal WHERE View_Personal.MemberId = vbMemberId AND View_Personal.isMain = TRUE AND View_Personal.PersonalId <> COALESCE(inId, 0)) THEN
      RAISE EXCEPTION 'Значение <Основное место работы> = ДА, уже установлено для подразделения: <%> должность: <%> разряд должности: <%>. Этот признак можно установить только 1 раз.'
                    , lfGet_Object_ValueData_sh ((SELECT View_Personal.UnitId          FROM Object_Personal_View AS View_Personal WHERE View_Personal.MemberId = vbMemberId AND View_Personal.isMain = TRUE ORDER BY View_Personal.PersonalId LIMIT 1))
                    , lfGet_Object_ValueData_sh ((SELECT View_Personal.PositionId      FROM Object_Personal_View AS View_Personal WHERE View_Personal.MemberId = vbMemberId AND View_Personal.isMain = TRUE ORDER BY View_Personal.PersonalId LIMIT 1))
                    , lfGet_Object_ValueData_sh ((SELECT View_Personal.PositionLevelId FROM Object_Personal_View AS View_Personal WHERE View_Personal.MemberId = vbMemberId AND View_Personal.isMain = TRUE ORDER BY View_Personal.PersonalId LIMIT 1))
                     ;
   END IF;

   -- сохранили связь с <должностью>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Position(), inId, inPositionId);
   -- сохранили свойство <Основное место работы>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Personal_Main(), inId, inIsMain);
   -- сохранили связь с <подразделением>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Unit(), inId, inUnitId);
   -- сохранили связь с <Ведомость начисления(БН)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_PersonalServiceListOfficial(), inId, inPersonalServiceListOfficialId); 
   -- сохранили связь с <Ведомость начисления(карта ф2)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_PersonalServiceListCardSecond(), inId, inPersonalServiceListCardSecondId);
   -- сохранили связь с <Ведомость начисления(аванс карта ф2)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_PersonalServiceListAvance_F2(), inId, CASE WHEN EXISTS (SELECT 1 FROM Object WHERE Object.Id = inPersonalServiceListId_AvanceF2 AND TRIM (Object.ValueData) = '' ) THEN 0 ELSE inPersonalServiceListId_AvanceF2 END);
   -- сохранили связь с <линия производства>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_StorageLine(), inId, inStorageLineId); 
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Personal_Code1C(), inId, inCode1C);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpUpdate_Object_Personal_Property (Integer, Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;

/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.
 27,04,23         *
 13.04.22         * add inCode1C
 13.07.17         * add inPersonalServiceListCardSecondId
 25.05.17         * add inStorageLineId
 26.08.15         * add inPersonalServiceListOfficialId
 15.09.14                                                       *
 12.09.14                                                       *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Personal_Property (inId:=0, inPositionId:=0, inIsMain:=False, inSession:='2')