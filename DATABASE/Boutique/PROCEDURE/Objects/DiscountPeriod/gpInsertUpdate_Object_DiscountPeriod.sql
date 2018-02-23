-- Названия накопительных скидок

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiscountPeriod (Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_DiscountPeriod(
 INOUT ioId             Integer,       -- Ключ объекта <Названия накопительных скидок>            
 INOUT ioCode           Integer,       -- Код объекта <Названия накопительных скидок>             
    IN inUnitId         Integer,       -- Ключ объекта <>
    IN inPeriodId       Integer,       -- Ключ объекта <>
    IN inStartDate      TDateTime ,
    IN inEndDate        TDateTime ,
    IN inSession        TVarChar       -- сессия пользователя                     
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_DiscountPeriod());
   vbUserId:= lpGetUserBySession (inSession);

   -- Нужен ВСЕГДА- ДЛЯ НОВОЙ СХЕМЫ С ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) <> 0 THEN ioCode := NEXTVAL ('Object_DiscountPeriod_seq'); 
   END IF; 

   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_DiscountPeriod(), ioCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_DiscountPeriod(), ioCode, '');
  
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_DiscountPeriod_Unit(), ioId, inUnitId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_DiscountPeriod_Period(), ioId, inPeriodId);

   -- сохранили <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_DiscountPeriod_StartDate(), ioId, inStartDate);
   -- сохранили <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_DiscountPeriod_EndDate(), ioId, inEndDate);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

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