-- Function: gpUpdate_Object_Goods_IsUpload()

DROP FUNCTION IF EXISTS gpUpdate_Unit_MCS(Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_MCS(
    IN inId               Integer   ,    -- ключ объекта <Подразделение>
    IN inPeriod           TFloat    ,    --
    IN inPeriod1          TFloat    ,    --
    IN inPeriod2          TFloat    ,    --
    IN inPeriod3          TFloat    ,    --
    IN inPeriod4          TFloat    ,    --
    IN inPeriod5          TFloat    ,    --
    IN inPeriod6          TFloat    ,    --
    IN inPeriod7          TFloat    ,    --
    IN inDay              TFloat    ,    --
    IN inDay1             TFloat    ,    --
    IN inDay2             TFloat    ,    --
    IN inDay3             TFloat    ,    --
    IN inDay4             TFloat    ,    --
    IN inDay5             TFloat    ,    --
    IN inDay6             TFloat    ,    --
    IN inDay7             TFloat    ,    --
    IN inIsHoliday        Boolean   ,    -- ссылка на подразделение 
    IN inSession          TVarChar       -- текущий пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;
   
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Object_Unit_Params());
   vbUserId := lpGetUserBySession (inSession);

   -- сохранили <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_Holiday(), inId, inIsHoliday);
   
   -- сохранили <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Period(), inId, inPeriod);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Period1(), inId, inPeriod1);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Period2(), inId, inPeriod2);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Period3(), inId, inPeriod3);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Period4(), inId, inPeriod4);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Period5(), inId, inPeriod5);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Period6(), inId, inPeriod6);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Period7(), inId, inPeriod7);
   -- сохранили <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Day(), inId, inDay);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Day1(), inId, inDay1);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Day2(), inId, inDay2);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Day3(), inId, inDay3);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Day4(), inId, inDay4);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Day5(), inId, inDay5);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Day6(), inId, inDay6);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Day7(), inId, inDay7);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.12.18         *
*/