-- Function: gpInsertUpdate_Object_Fiscal  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Fiscal (Integer,Integer,TVarChar,TVarChar,TVarChar,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Fiscal(
 INOUT ioId                       Integer   ,    -- ключ объекта <> 
    IN inCode                     Integer   ,    -- Код объекта <>
    IN inName                     TVarChar  ,    -- Название объекта <>
    IN inSerialNumber             TVarChar  ,    -- 
    IN inInvNumber                TVarChar  ,    --
    IN inUnitId                   Integer   ,    --
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbCode_calc Integer; 
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= inSession;

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Fiscal()); 
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Fiscal(), vbCode_calc, inName);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Fiscal_SerialNumber(), ioId, inSerialNumber);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Fiscal_InvNumber(), ioId, inInvNumber);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Fiscal_Unit(), ioId, inUnitId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 27.12.17         *
*/

-- тест
-- 