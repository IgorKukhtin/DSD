-- Function: gpInsertUpdate_Object_ContractCondition()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_TaxUnit (Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_TaxUnit(
 INOUT ioId                      Integer ,    -- ключ объекта <>
    IN inUnitId                  Integer ,    -- ссылка на подразделение
    IN inPrice                   TFloat  ,    --  
    IN inValue                   TFloat  ,    --  
    IN inSession                 TVarChar     -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_TaxUnit());
   vbUserId := inSession;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_TaxUnit(), 0, '');
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_TaxUnit_Unit(), ioId, inUnitId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_TaxUnit_Price(), ioId, inPrice);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_TaxUnit_Value(), ioId, inValue);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.02.19         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_TaxUnit ()                            
