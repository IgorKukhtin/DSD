-- Function: gpInsertUpdate_Object_RecalcMCSSheduler()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_RecalcMCSSheduler(Integer, Integer, Integer, Boolean, TVarChar,
                                                                Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                                Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                                Integer, Integer, Integer, Integer, Integer, Integer, Integer, 
                                                                Integer, Integer, Integer, Integer, Integer, Integer, Integer, 
                                                                Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_RecalcMCSSheduler(
 INOUT ioId                      Integer   ,   	-- ключ объекта <Причина разногласия>
 INOUT ioCode                    Integer   ,    -- Код объекта <Причина разногласия>
 INOUT ioUnitId                  Integer,

    IN inPharmacyItem            Boolean,
    IN inComment                 TVarChar,

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
    
    IN inPeriodSun1              Integer,
    IN inPeriodSun2              Integer,
    IN inPeriodSun3              Integer,
    IN inPeriodSun4              Integer,
    IN inPeriodSun5              Integer,
    IN inPeriodSun6              Integer,
    IN inPeriodSun7              Integer,
    IN inDaySun1                 Integer,
    IN inDaySun2                 Integer,
    IN inDaySun3                 Integer,
    IN inDaySun4                 Integer,
    IN inDaySun5                 Integer,
    IN inDaySun6                 Integer,
    IN inDaySun7                 Integer,

    IN inUserId                  Integer,
    IN inAllRetail               Boolean,
    IN inIsClose                 Boolean,
    IN inSession                 TVarChar       -- Сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbName TVarChar;
   DECLARE RetailId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ReasonDifferences());
   vbUserId:= inSession;
   
   SELECT ObjectLink_Juridical_Retail.ChildObjectId
   INTO RetailId
   FROM  ObjectLink AS ObjectLink_Unit_Juridical

         LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                          
    WHERE ObjectLink_Unit_Juridical.ObjectId = ioUnitId
      AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical();
   
   IF inIsClose = False AND inAllRetail = True AND 
     EXISTS(SELECT 1
            FROM Object AS Object_RecalcMCSSheduler

                 LEFT JOIN ObjectLink AS ObjectLink_Unit
                                      ON ObjectLink_Unit.ObjectId = Object_RecalcMCSSheduler.Id
                                     AND ObjectLink_Unit.DescId = zc_ObjectLink_RecalcMCSSheduler_Unit()

                 LEFT JOIN ObjectBoolean AS ObjectBoolean_AllRetail
                                         ON ObjectBoolean_AllRetail.ObjectId = Object_RecalcMCSSheduler.Id
                                        AND ObjectBoolean_AllRetail.DescId = zc_ObjectBoolean_RecalcMCSSheduler_AllRetail()

                 LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                      ON ObjectLink_Unit_Juridical.ObjectId = ObjectLink_Unit.ChildObjectId
                                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

                 LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                      ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                     AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                          
            WHERE Object_RecalcMCSSheduler.DescId = zc_Object_RecalcMCSSheduler()
              AND Object_RecalcMCSSheduler.isErased = False
              AND COALESCE (ObjectBoolean_AllRetail.ValueData, FALSE) = True
              AND Object_RecalcMCSSheduler.Id <> COALESCE (ioId, 0)
              AND ObjectLink_Juridical_Retail.ChildObjectId = RetailId)
   THEN
        RAISE EXCEPTION 'Ошибка.Признак <Для всей сети> может быть только у одного подразделения сети.';   
   END IF;

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
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_RecalcMCSSheduler_AllRetail(), ioId, inAllRetail);

   -- сохранили <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_RecalcMCSSheduler_Comment(), ioId, inComment);

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

   -- сохранили <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_PeriodSun1(), ioUnitId, inPeriodSun1);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_PeriodSun2(), ioUnitId, inPeriodSun2);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_PeriodSun3(), ioUnitId, inPeriodSun3);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_PeriodSun4(), ioUnitId, inPeriodSun4);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_PeriodSun5(), ioUnitId, inPeriodSun5);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_PeriodSun6(), ioUnitId, inPeriodSun6);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_PeriodSun7(), ioUnitId, inPeriodSun7);

   -- сохранили <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_DaySun1(), ioUnitId, inDaySun1);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_DaySun2(), ioUnitId, inDaySun2);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_DaySun3(), ioUnitId, inDaySun3);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_DaySun4(), ioUnitId, inDaySun4);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_DaySun5(), ioUnitId, inDaySun5);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_DaySun6(), ioUnitId, inDaySun6);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_DaySun7(), ioUnitId, inDaySun7);

   -- сохранили связь с <Сотрудником>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RecalcMCSSheduler_User(), ioId, inUserId);

   -- изменили
   UPDATE Object SET isErased = inIsClose WHERE Id = ioId;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_RecalcMCSSheduler(Integer, Integer, Integer, Boolean, TVarChar,
                                                       Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                       Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                       Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                       Integer, Integer, Integer, Integer, Integer, Integer, Integer, 
                                                       Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 10.12.19                                                       *
 09.02.19                                                       *
 21.12.18                                                       *

*/