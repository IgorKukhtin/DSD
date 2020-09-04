-- Function: gpInsertUpdate_Object_MemberMinus()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberMinus(Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberMinus(
 INOUT ioId                  Integer   ,    -- ключ объекта < >
    IN inName                TVarChar  ,    -- Примечание 
    IN inBankAccountTo       TVarChar  ,    -- № счета получателя платежа
    IN inDetailPayment       TVarChar  ,    -- Назначение платежа
    IN inFromId              Integer   ,    -- Физические лица
    IN inToId                Integer   ,    -- Физические лица(сторонние) / Юридические лица
    IN inBankAccountFromId   Integer   ,    -- IBAN плательщика платежа
    IN inBankAccountToId     Integer   ,    -- IBAN получателя платежа
    IN inTotalSumm           TFloat    ,     -- Сумма Итого
    IN inSumm                TFloat    ,     -- Сумма к удержанию ежемесячно
    IN inSession             TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_MemberMinus());
   vbUserId:= inSession;


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_MemberMinus(), 0, inName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_MemberMinus_DetailPayment(), ioId, inDetailPayment);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_MemberMinus_BankAccountTo(), ioId, inBankAccountTo);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MemberMinus_From(), ioId, inFromId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MemberMinus_To(), ioId, inToId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MemberMinus_BankAccountFrom(), ioId, inBankAccountFromId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MemberMinus_BankAccountTo(), ioId, inBankAccountToId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MemberMinus_TotalSumm(), ioId, inTotalSumm);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MemberMinus_Summ(), ioId, inSumm);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.09.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_MemberMinus()
