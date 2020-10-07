-- Function: gpInsertUpdate_Object_MemberMinus()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberMinus(Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberMinus(Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberMinus(Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberMinus(
 INOUT ioId                    Integer   ,    -- ключ объекта < >
    IN inName                  TVarChar  ,    -- Примечание 
    IN inBankAccountTo         TVarChar  ,    -- № счета получателя платежа
    IN inDetailPayment         TVarChar  ,    -- Назначение платежа
    IN inINN_to                TVarChar  ,    -- ОКПО/ИНН получателя
    IN inFromId                Integer   ,    -- Физические лица
    IN inToId                  Integer   ,    -- Физические лица(сторонние) / Юридические лица
 INOUT ioBankAccountFromId     Integer   ,    -- IBAN плательщика платежа
    IN inBankAccountToId       Integer   ,    -- IBAN получателя платежа
    IN inBankAccountId_main    Integer   ,    --
   OUT outBankAccountFromName  TVarChar  ,    --
    IN inTotalSumm             TFloat    ,     -- Сумма Итого
    IN inSumm                  TFloat    ,     -- Сумма к удержанию ежемесячно
    IN inSession               TVarChar        -- сессия пользователя
)
  RETURNS Record AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDescId_to Integer;
   DECLARE vbINN_to TVarChar;
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_MemberMinus());
   vbUserId:= inSession;
   
   -- inBankAccountFromId заполнять из верхнего контрола (inBankAccountId_main) при добавлении, или когда вводят в гриде и "IBAN плательщика" не заполнен
   IF COALESCE (ioBankAccountFromId,0) = 0 AND COALESCE (inBankAccountId_main,0) <> 0
   THEN
       ioBankAccountFromId := inBankAccountId_main;
   END IF;

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
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MemberMinus_BankAccountFrom(), ioId, ioBankAccountFromId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MemberMinus_BankAccountTo(), ioId, inBankAccountToId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MemberMinus_TotalSumm(), ioId, inTotalSumm);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MemberMinus_Summ(), ioId, inSumm);

   vbINN_to := (SELECT ObjectString_INN_to.ValueData
                FROM ObjectString AS ObjectString_INN_to
                WHERE ObjectString_INN_to.ObjectId = inToId
                  AND ObjectString_INN_to.DescId = zc_ObjectString_Member_INN()
               );
   vbDescId_to := (SELECT Object.DescId FROM Object WHERE Object.Id = inToId);
               
   IF COALESCE (vbDescId_to,0) <> zc_Object_MemberExternal() AND COALESCE (vbINN_to,'') <> COALESCE (inINN_to,'')
      THEN
           RAISE EXCEPTION 'Ошибка.Ввод ИНН только для стронних физ.лиц.';
   END IF;
   
   IF vbDescId_to = zc_Object_MemberExternal() AND COALESCE (inINN_to,'') <> '' AND COALESCE (vbINN_to,'') <> COALESCE (inINN_to,'')
      THEN
          -- сохранили свойство <>
          PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_MemberExternal_INN(), inToId, inINN_to);
          -- сохранили протокол
          PERFORM lpInsert_ObjectProtocol (inToId, vbUserId);
   END IF;
   
   outBankAccountFromName:= (SELECT Object.ValueData FROM Object WHERE Object.Id = ioBankAccountFromId);

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
