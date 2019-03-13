-- Function: gpInsertUpdate_Object_ProfitLossDemo()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProfitLossDemo(Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProfitLossDemo(
 INOUT ioId                Integer,    -- ключ объекта <>
    IN inProfitLossId      Integer,    -- 
    IN inUnitId            Integer,    --  
    IN inValue             TFloat ,    --
    IN inSession           TVarChar    -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
 
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ProfitLoss());
    vbUserId := inSession;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ProfitLossDemo(), 0, '');

   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProfitLossDemo_Value(), ioId, inValue);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ProfitLossDemo_ProfitLoss(), ioId, inProfitLossId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ProfitLossDemo_Unit(), ioId, inUnitId);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.04.14         *
*/
-- тест
-- SELECT * FROM gpInsertUpdate_Object_ProfitLossDemo()