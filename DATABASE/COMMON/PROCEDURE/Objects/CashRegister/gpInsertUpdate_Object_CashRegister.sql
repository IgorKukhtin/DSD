-- Function: gpInsertUpdate_Object_City()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CashRegister (Integer, Integer, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CashRegister (Integer, Integer, TVarChar, Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CashRegister (Integer, Integer, TVarChar, Integer, TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CashRegister(
 INOUT ioId                     Integer   ,     -- ключ объекта <Город>
    IN inCode                   Integer   ,     -- Код объекта
    IN inName                   TVarChar  ,     -- Название объекта
    IN inCashRegisterKindId     Integer   ,     -- 
    IN inTimePUSHFinal1         TDateTime ,     -- 
    IN inTimePUSHFinal2         TDateTime ,     -- 
    IN inGetHardwareData        Boolean ,     -- 
    IN inSession                TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_CashRegister());
   vbUserId:= lpGetUserBySession (inSession);

   
   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_CashRegister());

   -- проверка уникальности для свойства <Наименование> 
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_CashRegister(), inName);
   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_CashRegister(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_CashRegister(), vbCode_calc, inName);

  -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_CashRegister_CashRegisterKind(), ioId, inCashRegisterKindId);
   
   IF inTimePUSHFinal1 ::Time <> '00:00'
   THEN
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_CashRegister_TimePUSHFinal1(), ioId, inTimePUSHFinal1);
   ELSE
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_CashRegister_TimePUSHFinal1(), ioId, NULL);
   END IF;
   
   IF inTimePUSHFinal2 ::Time <> '00:00'
   THEN
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_CashRegister_TimePUSHFinal2(), ioId, inTimePUSHFinal2);
   ELSE
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_CashRegister_TimePUSHFinal2(), ioId, NULL);
   END IF;

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashRegister_GetHardwareData(), ioId, inGetHardwareData);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_CashRegister (Integer, Integer, TVarChar, Integer, TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;


-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Манько Д.А.   Шаблий О.В.
 08.04.20                                                                      *  
 04.03.19                                                                      *  
 22.05.15                        *  
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_CashRegister(ioId:=null, inCode:=null, inName:='Регион 1', inSession:='2')