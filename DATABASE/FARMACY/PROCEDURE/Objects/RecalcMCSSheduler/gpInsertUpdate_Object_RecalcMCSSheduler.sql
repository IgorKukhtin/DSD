-- Function: gpInsertUpdate_Object_RecalcMCSSheduler()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_RecalcMCSSheduler(Integer, Integer, Integer, Boolean,
                                                                Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                                Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                                Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_RecalcMCSSheduler(
 INOUT ioId                      Integer   ,   	-- ключ объекта <Причина разногласия>
 INOUT ioCode                    Integer   ,    -- Код объекта <Причина разногласия>
 INOUT ioUnitId                  Integer,

    IN inPharmacyItem            Boolean,

    IN inPeriod                  Integer,
    IN inPeriod1                 Integer,
    IN inPeriod2                 Integer,
    IN inPeriod3                 Integer,
    IN inPeriod4                 Integer,
    IN inPeriod5                 Integer,
    IN inPeriod6                 Integer,
    IN inPeriod7                 Integer,
    IN inDay                     Integer,
    IN inDay1                    Integer,
    IN inDay2                    Integer,
    IN inDay3                    Integer,
    IN inDay4                    Integer,
    IN inDay5                    Integer,
    IN inDay6                    Integer,
    IN inDay7                    Integer,

    IN inUserId                  Integer,
    IN inIsClose                 Boolean,
    IN inSession                 TVarChar       -- Сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbName TVarChar;

BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ReasonDifferences());
   vbUserId:= inSession;

   IF COALESCE (ioId, 0) = 0
   THEN
     IF EXISTS (SELECT 1 FROM ObjectLink WHERE DescId = zc_ObjectLink_RecalcMCSSheduler_Unit()
                                           AND ChildObjectId = ioUnitId)
     THEN
       SELECT ObjectId
       INTO ioId
       FROM ObjectLink
       WHERE DescId = zc_ObjectLink_RecalcMCSSheduler_Unit()
         AND ChildObjectId = ioUnitId;
     END IF;
   END IF;

   IF EXISTS (SELECT 1 FROM ObjectLink WHERE DescId = zc_ObjectLink_RecalcMCSSheduler_Unit()
                                         AND ChildObjectId = ioUnitId
                                         AND ObjectId <> ioId)
   THEN
     RAISE EXCEPTION 'Ошибка. Связи поланировщика и подразделения..';
   END IF;

   IF COALESCE(inPeriod, 0) <= 0 OR COALESCE(inPeriod1, 0) <= 0 OR COALESCE(inPeriod2, 0) <= 0 OR COALESCE(inPeriod3, 0) <= 0 OR
      COALESCE(inPeriod4, 0) <= 0 OR COALESCE(inPeriod5, 0) <= 0 OR COALESCE(inPeriod6, 0) <= 0 OR COALESCE(inPeriod7, 0) <= 0 OR
      COALESCE(inDay, 0) <= 0 OR COALESCE(inDay1, 0) <= 0 OR COALESCE(inDay2, 0) <= 0 OR COALESCE(inDay3, 0) <= 0 OR
      COALESCE(inDay4, 0) <= 0 OR COALESCE(inDay5, 0) <= 0 OR COALESCE(inDay6, 0) <= 0 OR COALESCE(inDay7, 0) <= 0
   THEN
     RAISE EXCEPTION 'Ошибка. Не заполнены все параметры..';
   END IF;

   -- Если код не установлен, определяем его как последний+1 (!!! ПОТОМ НАДО БУДЕТ ЭТО ВКЛЮЧИТЬ !!!)
   ioCode:= lfGet_ObjectCode (ioCode, zc_Object_RecalcMCSSheduler());
   vbName := 'Планировщик перещета НТЗ '||ioCode::TVarChar;

   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_RecalcMCSSheduler(), vbName);
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_RecalcMCSSheduler(), ioCode);

   -- сохранили объект
   ioId := lpInsertUpdate_Object (ioId, zc_Object_RecalcMCSSheduler(), ioCode, vbName, NULL);

   -- сохранили связь с <Наше юр. лицо>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RecalcMCSSheduler_Unit(), ioId, ioUnitId);

   --сохранили
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Unit_PharmacyItem(), ioUnitId, inPharmacyItem);

   -- сохранили <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Period(), ioUnitId, inPeriod);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Period1(), ioUnitId, inPeriod1);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Period2(), ioUnitId, inPeriod2);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Period3(), ioUnitId, inPeriod3);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Period4(), ioUnitId, inPeriod4);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Period5(), ioUnitId, inPeriod5);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Period6(), ioUnitId, inPeriod6);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Period7(), ioUnitId, inPeriod7);

   -- сохранили <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Day(), ioUnitId, inDay);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Day1(), ioUnitId, inDay1);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Day2(), ioUnitId, inDay2);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Day3(), ioUnitId, inDay3);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Day4(), ioUnitId, inDay4);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Day5(), ioUnitId, inDay5);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Day6(), ioUnitId, inDay6);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Day7(), ioUnitId, inDay7);


   -- сохранили связь с <Сотрудником>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RecalcMCSSheduler_User(), ioId, inUserId);

   -- изменили
   UPDATE Object SET isErased = inIsClose WHERE Id = ioId;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_RecalcMCSSheduler(Integer, Integer, Integer, Boolean,
                                                       Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                       Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                       Integer, Boolean, TVarChar) OWNER TO postgres;


------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.12.18                                                       *

*/