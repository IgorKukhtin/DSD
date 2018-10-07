-- Function: gpInsertUpdate_Object_ClientsByBank  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ClientsByBank (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ClientsByBank(
 INOUT ioId                       Integer   ,    -- ключ объекта < Улица/проспект> 
    IN inCode                     Integer   ,    -- Код объекта <>
    IN inName                     TVarChar  ,    -- Название объекта <>
    IN inOKPO                     TVarChar  ,
    IN inINN                      TVarChar  ,
    IN inPhone                    TVarChar  ,
    IN inContactPerson            TVarChar  ,
    IN inRegAddress               TVarChar  ,
    IN inSendingAddress           TVarChar  ,
    IN inAccounting               TVarChar  ,
    IN inPhoneAccountancy         TVarChar  ,
    IN inComment                  TVarChar  ,
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ClientsByBank()); 
   
   -- проверка прав уникальности для свойства <Наименование > + <Object> + <ClientsByBankKind>
--   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_ClientsByBank(), inName);
--   IF COALESCE((SELECT ), 0) = ioId THEN
--      RAISE EXCEPTION '';
--   END IF;
   -- проверка прав уникальности для свойства <Код > + <Object> 
--   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ClientsByBank(), vbCode_calc);

   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ClientsByBank(), vbCode_calc, inName);

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ClientsByBank_OKPO(), ioId, inOKPO);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ClientsByBank_INN(), ioId, inINN);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ClientsByBank_Phone(), ioId, inPhone);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ClientsByBank_ContactPerson(), ioId, inContactPerson);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ClientsByBank_RegAddress(), ioId, inRegAddress);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ClientsByBank_SendingAddress(), ioId, inSendingAddress);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ClientsByBank_Accounting(), ioId, inAccounting);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ClientsByBank_PhoneAccountancy(), ioId, inPhoneAccountancy);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ClientsByBank_Comment(), ioId, inComment);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 28.09.18         * 
*/

-- тест
-- 