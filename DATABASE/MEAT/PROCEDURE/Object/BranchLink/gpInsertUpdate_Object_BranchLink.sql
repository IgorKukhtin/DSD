-- Function: gpInsertUpdate_Object_(Integer,Integer,TVarChar,TVarChar,TDateTime,TDateTime,Integer,Integer,Integer,Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BranchLink (Integer, Integer, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_BranchLink(
 INOUT ioId                       Integer   ,    -- ключ объекта  
    IN inCode                     Integer   ,    -- Код объекта
    IN inName                     TVarChar  ,    -- Название объекта 
    IN inBranchId                 Integer   ,    -- Филиал
    IN inPaidKindId               Integer   ,    -- Тип оплаты
    IN inSession                  TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_BranchLink(), 0, inName);

   -- сохранили связь с <Филиал>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BranchLink_Branch(), ioId, inBranchId);

   -- сохранили связь с <Тип оплаты>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BranchLink_PaidKind(), ioId, inPaidKindId);

   -- сохранили протокол
--   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_BranchLink (Integer, Integer, TVarChar, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.08.14                         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Car()
