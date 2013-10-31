-- Function: gpInsertUpdate_Object_StaffList(Integer, Integer, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_StaffList(Integer,  Integer, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_StaffList(
 INOUT ioId                  Integer   , -- ключ объекта <Штатное расписание>
    IN inCode                Integer   , -- свойство <Код>
    IN inHoursPlan           TFloat    , -- План часов
    IN inPersonalCount       TFloat    , -- кол. человек
    IN inComment             TVarChar  , -- комментарий
    IN inUnitId              Integer   , -- Подразделение
    IN inPositionId          Integer   , -- Должность
    IN inPositionLevelId     Integer   , -- Разряд должности
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer; 
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_StaffList()());
   vbUserId := inSession;
   
      -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_StaffList());

   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_StaffList(), vbCode_calc);
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_StaffList(), vbCode_calc, '');
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StaffList_HoursPlan(), ioId, inHoursPlan);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StaffList_PersonalCount(), ioId, inPersonalCount);
  
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
ALTER FUNCTION gpInsertUpdate_Object_StaffList (Integer, Integer, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.10.13         * add Code 
 18.10.13         * add FundPayMonth, FundPayTurn, Comment  
 17.10.13         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_StaffList (0,  198, 2, 1000, 1, 5, 6, '2')
    