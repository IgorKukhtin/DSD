-- Function: gpInsertUpdate_Object_UnitBankPOSTerminal()

-- DROP FUNCTION gpInsertUpdate_Object_UnitBankPOSTerminal();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_UnitBankPOSTerminal(
 INOUT ioId	                Integer   ,     -- ключ объекта связи 
    IN inUnitId             Integer   ,     -- Подразделение
    IN inBankPOSTerminalID  Integer   ,     -- Банк
    IN inSession            TVarChar        -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

   -- проверка
   IF COALESCE (inUnitId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не установлено значение <Unit>.';
   END IF;
   -- проверка
   IF COALESCE (inBankPOSTerminalID, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не установлено значение <BankPOSTerminal>.';
   END IF;

   -- пытаемся найти
   IF COALESCE (ioId, 0) = 0
   THEN
       ioId:= (SELECT ObjectLink_UnitBankPOSTerminal_Unit.ObjectId
               FROM ObjectLink AS ObjectLink_UnitBankPOSTerminal_Unit
   
                    JOIN ObjectLink AS ObjectLink_UnitBankPOSTerminal_BankPOSTerminal 
                                    ON ObjectLink_UnitBankPOSTerminal_BankPOSTerminal.ObjectId = ObjectLink_UnitBankPOSTerminal_Unit.ObjectId
                                   AND ObjectLink_UnitBankPOSTerminal_BankPOSTerminal.ChildObjectId = inBankPOSTerminalID 
                                   AND ObjectLink_UnitBankPOSTerminal_BankPOSTerminal.DescId = zc_ObjectLink_UnitBankPOSTerminal_BankPOSTerminal()
                       
               WHERE ObjectLink_UnitBankPOSTerminal_Unit.ChildObjectId = inUnitId
                 AND ObjectLink_UnitBankPOSTerminal_Unit.DescId = zc_ObjectLink_UnitBankPOSTerminal_Unit()
               LIMIT 1);
   END IF;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_UnitBankPOSTerminal(), 0, '');

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UnitBankPOSTerminal_Unit(), ioId, inUnitId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UnitBankPOSTerminal_BankPOSTerminal(), ioId, inBankPOSTerminalID);

   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 18.02.19                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_UnitBankPOSTerminal()
