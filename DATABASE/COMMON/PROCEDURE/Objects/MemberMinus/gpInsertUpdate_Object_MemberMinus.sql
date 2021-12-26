-- Function: gpInsertUpdate_Object_MemberMinus()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberMinus(Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberMinus(Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberMinus(Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberMinus(Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberMinus(Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberMinus(Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberMinus(
 INOUT ioId                    Integer   ,    -- ключ объекта < >
    IN inName                  TVarChar  ,    -- Примечание 
    IN inBankAccountTo         TVarChar  ,    -- № счета получателя платежа
    IN inDetailPayment         TVarChar  ,    -- Назначение платежа
    IN inINN_to                TVarChar  ,    -- ОКПО/ИНН получателя
    IN inToShort               TVarChar  ,    -- Юр. лицо (сокращенное значение) 
    IN inNumber                TVarChar  ,    -- № исполнительного листа
    IN inFromId                Integer   ,    -- Физические лица
    IN inToId                  Integer   ,    -- Физические лица(сторонние) / Юридические лица
 INOUT ioBankAccountFromId     Integer   ,    -- IBAN плательщика платежа
    IN inBankAccountToId       Integer   ,    -- IBAN получателя платежа
    IN inBankAccountId_main    Integer   ,    --
   OUT outBankAccountFromName  TVarChar  ,    --
    IN inTotalSumm             TFloat    ,     -- Сумма Итого
    IN inSumm                  TFloat    ,     -- Сумма к удержанию ежемесячно
    IN inTax                   TFloat    ,     -- % удержания
   OUT outisToShort            Boolean   ,     -- > 36 символов
    IN inisChild               Boolean   ,     -- Алименты (да/нет)
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
   vbUserId:= lpGetUserBySession (inSession);
   
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
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_MemberMinus_ToShort(), ioId, inToShort);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_MemberMinus_Number(), ioId, inNumber);
      
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MemberMinus_From(), ioId, inFromId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MemberMinus_To(), ioId, inToId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MemberMinus_BankAccountFrom(), ioId, ioBankAccountFromId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MemberMinus_BankAccountTo(), ioId, inBankAccountToId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_MemberMinus_Child(), ioId, inisChild);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MemberMinus_TotalSumm(), ioId, inTotalSumm);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MemberMinus_Summ(), ioId, inSumm);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MemberMinus_Tax(), ioId, inTax);

   SELECT CASE WHEN Object_To.DescId = zc_Object_Juridical() THEN ObjectHistory_JuridicalDetails_View.OKPO
               ELSE ObjectString_INN_to.ValueData
          END              AS INN_to
        , Object_To.DescId AS DescId
 INTO vbINN_to, vbDescId_to
   FROM Object AS Object_to
        LEFT JOIN ObjectString AS ObjectString_INN_to
                               ON ObjectString_INN_to.ObjectId = Object_To.Id
                              AND ObjectString_INN_to.DescId IN (zc_ObjectString_MemberExternal_INN(), zc_ObjectString_Member_INN())
                              AND Object_To.DescId <> zc_Object_Juridical()
        LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_To.Id
                                                     AND Object_To.DescId = zc_Object_Juridical()
   WHERE Object_to.Id = inToId;
   
   
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
   outisToShort := (SELECT CASE WHEN LENGTH (Object.ValueData) > 36 THEN TRUE ELSE FALSE END :: Boolean
                    FROM Object
                    WHERE Object.Id = inToId);
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.12.21         *
 04.09.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_MemberMinus()
