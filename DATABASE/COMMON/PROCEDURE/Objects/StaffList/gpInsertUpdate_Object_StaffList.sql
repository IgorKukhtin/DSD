-- Function: gpInsertUpdate_Object_StaffList(Integer, Integer, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_StaffList (Integer, Integer, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_StaffList (Integer, Integer, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_StaffList (Integer, Integer, TFloat, TFloat, TFloat, Boolean, TVarChar, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_StaffList(
 INOUT ioId                  Integer   , -- ключ объекта <Штатное расписание>
    IN inCode                Integer   , -- свойство <Код>
    IN inHoursPlan           TFloat    , -- Общий план часов за месяц на человека
    IN inHoursDay            TFloat    , -- Дневной план часов на человека
    IN inPersonalCount       TFloat    , -- кол. человек
    IN inisPositionLevel     Boolean   , -- Все "Разряды должности"
    IN inComment             TVarChar  , -- комментарий
    IN inUnitId              Integer   , -- Подразделение
    IN inPositionId          Integer   , -- Должность
    IN inPositionLevelId     Integer   , -- Разряд должности
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer; 
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_StaffList());
   vbUserId:= lpGetUserBySession (inSession);

   -- проверка прав
   IF vbUserId <> 5 AND NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_Update_Object_StaffList())
   THEN
        RAISE EXCEPTION 'Ошибка.%Нет прав корректировать = <%>.'
                      , CHR (13)
                      , (SELECT ObjectDesc.ItemName FROM ObjectDesc WHERE ObjectDesc.Id = zc_Object_StaffList())
                       ;
   END IF;


   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode:= lfGet_ObjectCode (inCode, zc_Object_StaffList());

   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_StaffList(), vbCode);
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_StaffList(), vbCode, '');
   
   -- сохранили свойство <Общий план часов за месяц на человека>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StaffList_HoursPlan(), ioId, inHoursPlan);
   -- сохранили свойство <Дневной план часов на человека>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StaffList_HoursDay(), ioId, inHoursDay);
   -- сохранили свойство <кол. человек>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StaffList_PersonalCount(), ioId, inPersonalCount);
  
   -- сохранили свойство <>   
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_StaffList_PositionLevel(), ioId, inisPositionLevel);

   -- сохранили свойство <>   
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_StaffList_Comment(), ioId, inComment);
   
   -- сохранили связь с <Подразделением>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StaffList_Unit(), ioId, inUnitId);   
   -- сохранили связь с <Должностью>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StaffList_Position(), ioId, inPositionId);
   -- сохранили связь с <Разрядом должности)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StaffList_PositionLevel(), ioId, inPositionLevelId);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_StaffList (Integer, Integer, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.03.16         * 
 30.11.13                                        * add zc_ObjectFloat_StaffList_HoursDay
 31.10.13         * add Code 
 18.10.13         * add FundPayMonth, FundPayTurn, Comment  
 17.10.13         * 
*/

/*
insert into ObjectFloat (ObjectId, DescId, ValueData)
select ObjectLink_StaffListSumm_StaffList.ChildObjectId, zc_ObjectFloat_StaffList_HoursDay(), ObjectFloat_Value.ValueData
from ObjectLink 
JOIN ObjectFloat AS ObjectFloat_Value 
                 ON ObjectFloat_Value.ObjectId = ObjectLink .ObjectId 
                AND ObjectFloat_Value.DescId = zc_ObjectFloat_StaffListSumm_Value()
LEFT JOIN ObjectLink AS ObjectLink_StaffListSumm_StaffList
                     ON ObjectLink_StaffListSumm_StaffList.ObjectId = ObjectLink .ObjectId 
                    AND ObjectLink_StaffListSumm_StaffList.DescId = zc_ObjectLink_StaffListSumm_StaffList()

where ObjectLink.ChildObjectId = zc_Enum_StaffListSummKind_WorkHours() AND ObjectLink.DescId = zc_ObjectLink_StaffListSumm_StaffListSummKind()

delete from ObjectFloat where ObjectId in (select ObjectLink .ObjectId from ObjectLink where ChildObjectId = zc_Enum_StaffListSummKind_WorkHours() AND DescId = zc_ObjectLink_StaffListSumm_StaffListSummKind());
delete from ObjectString where ObjectId in (select ObjectLink .ObjectId from ObjectLink where ChildObjectId = zc_Enum_StaffListSummKind_WorkHours() AND DescId = zc_ObjectLink_StaffListSumm_StaffListSummKind());
delete from ObjectLink where ObjectId in (select ObjectLink .ObjectId from ObjectLink where ChildObjectId = zc_Enum_StaffListSummKind_WorkHours() AND DescId = zc_ObjectLink_StaffListSumm_StaffListSummKind());
delete from ObjectProtocol where ObjectId in (select Object.Id from Object left join ObjectLink on ObjectId= Object.Id AND ObjectLink.DescId = zc_ObjectLink_StaffListSumm_StaffListSummKind() where Object.DescId =  zc_Object_StaffListSumm() and ObjectId is null);
delete from Object where Id in (select Object.Id from Object left join ObjectLink on ObjectId= Object.Id AND ObjectLink.DescId = zc_ObjectLink_StaffListSumm_StaffListSummKind() where Object.DescId =  zc_Object_StaffListSumm() and ObjectId is null);
delete from ObjectString where ObjectId in (select zc_Enum_StaffListSummKind_WorkHours() union select zc_Enum_StaffListSummKind_HoursDayConst());
delete from Object where Id in (12316, 12334 );

DROP FUNCTION IF EXISTS zc_Enum_StaffListSummKind_WorkHours(); 
DROP FUNCTION IF EXISTS zc_Enum_StaffListSummKind_HoursDayConst()
*/
-- тест
-- SELECT * FROM gpInsertUpdate_Object_StaffList (0,  198, 2, 1000, 1, 5, 6, '2')
