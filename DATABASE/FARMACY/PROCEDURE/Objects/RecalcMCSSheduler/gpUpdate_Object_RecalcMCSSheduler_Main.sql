-- Function: gpUpdate_Object_RecalcMCSSheduler_()

DROP FUNCTION IF EXISTS gpUpdate_Object_RecalcMCSSheduler_Main(Integer, 
                                                               Integer, Integer, Integer, Integer, Integer, Integer, Integer, 
                                                               Integer, Integer, Integer, Integer, Integer, Integer, Integer, 
                                                               TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_RecalcMCSSheduler_Main(
    IN inUnitId               Integer   ,   	-- ключ объекта <Причина разногласия>
        
    IN inPeriod1              Integer,
    IN inPeriod2              Integer,
    IN inPeriod3              Integer,
    IN inPeriod4              Integer,
    IN inPeriod5              Integer,
    IN inPeriod6              Integer,
    IN inPeriod7              Integer,
    IN inDay1                 Integer,
    IN inDay2                 Integer,
    IN inDay3                 Integer,
    IN inDay4                 Integer,
    IN inDay5                 Integer,
    IN inDay6                 Integer,
    IN inDay7                 Integer,
    IN inSession              TVarChar       -- Сессия пользователя
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
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Period1(), inUnitId, inPeriod1);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Period2(), inUnitId, inPeriod2);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Period3(), inUnitId, inPeriod3);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Period4(), inUnitId, inPeriod4);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Period5(), inUnitId, inPeriod5);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Period6(), inUnitId, inPeriod6);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Period7(), inUnitId, inPeriod7);

   -- сохранили <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Day1(), inUnitId, inDay1);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Day2(), inUnitId, inDay2);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Day3(), inUnitId, inDay3);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Day4(), inUnitId, inDay4);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Day5(), inUnitId, inDay5);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Day6(), inUnitId, inDay6);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Day7(), inUnitId, inDay7);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_RecalcMCSSheduler_Main(Integer, 
                                                      Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                      Integer, Integer, Integer, Integer, Integer, Integer, Integer, 
                                                      TVarChar) OWNER TO postgres;


------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 16.06.20                                                       *
*/