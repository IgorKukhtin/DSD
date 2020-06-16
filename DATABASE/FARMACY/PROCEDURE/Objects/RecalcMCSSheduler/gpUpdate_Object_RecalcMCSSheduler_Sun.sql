-- Function: gpUpdate_Object_RecalcMCSSheduler_Sun()

DROP FUNCTION IF EXISTS gpUpdate_Object_RecalcMCSSheduler_Sun(Integer, 
                                                              Integer, Integer, Integer, Integer, Integer, Integer, Integer, 
                                                              Integer, Integer, Integer, Integer, Integer, Integer, Integer, 
                                                              TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_RecalcMCSSheduler_Sun(
    IN inUnitId                  Integer   ,   	-- ключ объекта <Причина разногласия>
        
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
    IN inSession                 TVarChar       -- Сессия пользователя
) 
RETURNS VOID
AS 
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbName TVarChar;
   DECLARE RetailId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ReasonDifferences());
   vbUserId:= inSession;
   
   IF COALESCE (inUnitId, 0) = 0
   THEN
     RETURN;
   END IF;


   -- сохранили <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_PeriodSun1(), inUnitId, inPeriodSun1);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_PeriodSun2(), inUnitId, inPeriodSun2);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_PeriodSun3(), inUnitId, inPeriodSun3);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_PeriodSun4(), inUnitId, inPeriodSun4);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_PeriodSun5(), inUnitId, inPeriodSun5);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_PeriodSun6(), inUnitId, inPeriodSun6);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_PeriodSun7(), inUnitId, inPeriodSun7);

   -- сохранили <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_DaySun1(), inUnitId, inDaySun1);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_DaySun2(), inUnitId, inDaySun2);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_DaySun3(), inUnitId, inDaySun3);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_DaySun4(), inUnitId, inDaySun4);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_DaySun5(), inUnitId, inDaySun5);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_DaySun6(), inUnitId, inDaySun6);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_DaySun7(), inUnitId, inDaySun7);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_RecalcMCSSheduler_Sun(Integer, 
                                                     Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                     Integer, Integer, Integer, Integer, Integer, Integer, Integer, 
                                                     TVarChar) OWNER TO postgres;


------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 16.06.20                                                       *
*/