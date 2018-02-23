
DROP FUNCTION IF EXISTS gpUpdate_Object_DiscountPeriod (Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_DiscountPeriod(
    IN inId             Integer,       -- Ключ объекта <Названия накопительных скидок>            
    IN inUnitId         Integer,       -- Ключ объекта <>
    IN inPeriodId       Integer,       -- Ключ объекта <>
    IN inStartDate      TDateTime ,
    IN inEndDate        TDateTime ,
    IN inSession        TVarChar       -- сессия пользователя                     
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_DiscountPeriod());
   vbUserId:= lpGetUserBySession (inSession);

   IF COALESCE (inId, 0) = 0 
   THEN
        RAISE EXCEPTION 'Ошибка. Элемент не сохранен.';
   END IF;
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_DiscountPeriod_Unit(), inId, inUnitId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_DiscountPeriod_Period(), inId, inPeriodId);

   -- сохранили <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_DiscountPeriod_StartDate(), inId, inStartDate);
   -- сохранили <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_DiscountPeriod_EndDate(), inId, inEndDate);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
23.02.18          *
*/

-- тест
-- 