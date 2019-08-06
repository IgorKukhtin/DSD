-- Function: gpInsertUpdate_Object_ImportTypeItems()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalOrderFinance (Integer, Integer, Integer, Integer, TFloat, Tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_JuridicalOrderFinance(
 INOUT ioId                      Integer   ,   	-- ключ объекта <>
    IN inJuridicalId             Integer   ,    -- 
    IN inBankAccountId           Integer   ,    -- 
    IN inInfoMoneyId             Integer   ,    -- 
    IN inSummOrderFinance        TFloat   ,    -- 
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpGetUserBySession (inSession); 


   -- проверка уникальности
   IF EXISTS (SELECT 1
              FROM ObjectLink AS ObjectLink_JuridicalOrderFinance_Juridical

                   LEFT JOIN ObjectLink AS ObjectLink_JuridicalOrderFinance_BankAccount
                                        ON ObjectLink_JuridicalOrderFinance_BankAccount.ObjectId = ObjectLink_JuridicalOrderFinance_Juridical.ObjectId
                                       AND ObjectLink_JuridicalOrderFinance_BankAccount.DescId = zc_ObjectLink_JuridicalOrderFinance_BankAccount()

                   LEFT JOIN ObjectLink AS ObjectLink_JuridicalOrderFinance_InfoMoney
                                        ON ObjectLink_JuridicalOrderFinance_InfoMoney.ObjectId = ObjectLink_JuridicalOrderFinance_Juridical.ObjectId
                                       AND ObjectLink_JuridicalOrderFinance_InfoMoney.DescId = zc_ObjectLink_JuridicalOrderFinance_InfoMoney()

              WHERE ObjectLink_JuridicalOrderFinance_Juridical.DescId = zc_ObjectLink_JuridicalOrderFinance_Juridical()
                AND ObjectLink_JuridicalOrderFinance_Juridical.ChildObjectId = inJuridicalId
                AND COALESCE (ObjectLink_JuridicalOrderFinance_BankAccount.ChildObjectId, 0) = COALESCE (inBankAccountId, 0)
                AND COALESCE (ObjectLink_JuridicalOrderFinance_InfoMoney.ChildObjectId, 0) = COALESCE (inInfoMoneyId, 0)
                AND ObjectLink_JuridicalOrderFinance_Juridical.ObjectId <> COALESCE (ioId, 0))
   THEN 
       RAISE EXCEPTION 'Ошибка.Значение  <%> + <%> + <%> уже есть в справочнике. Дублирование запрещено.', lfGet_Object_ValueData (inJuridicalId), lfGet_Object_ValueData (inBankAccountId), lfGet_Object_ValueData (inInfoMoneyId);
   END IF; 

   -- проверка
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_JuridicalOrderFinance(), 0, '');

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalOrderFinance_Juridical(), ioId, inJuridicalId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalOrderFinance_BankAccount(), ioId, inBankAccountId);   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalOrderFinance_InfoMoney(), ioId, inInfoMoneyId);

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_JuridicalOrderFinance_SummOrderFinance(), ioId, inSummOrderFinance);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.08.19         * 
*/

-- тест
--