-- Function: gpInsertUpdate_Object_JuridicalOrderFinance_forMovement()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalOrderFinance_forMovement (Integer, Integer, Integer, Integer, Integer,Integer, Tvarchar, Tvarchar, TFloat, Tvarchar, Tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_JuridicalOrderFinance_forMovement(
 INOUT ioId                      Integer   ,   	-- ключ объекта <>
    IN inJuridicalId             Integer   ,    --  
    IN inInfoMoneyId             Integer   ,    -- 
    IN inBankMainId              Integer   ,
    IN inBankId                  Integer   ,
    IN inBankAccountMainId_top   Integer   ,
    IN inBankAccountMainName     Tvarchar  ,    --
    IN inBankAccountName         Tvarchar  ,    --
    IN inSummOrderFinance        TFloat    ,    -- 
    IN inComment                 TVarChar  ,
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId            Integer;
           vbBankAccountMainId Integer;
           vbBankAccountId     Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpGetUserBySession (inSession); 

   IF COALESCE (inJuridicalId,0) = 0
   THEN
       RETURN;
   END IF;

   --сначала ищем Р/счета , если нет то сохраняем их
     -- BankAccountMain
     IF COALESCE (inBankAccountMainName,'') <> ''
     THEN
         IF COALESCE (inBankMainId, 0) = 0
         THEN
           RAISE EXCEPTION 'Ошибка.Банк(Плательщик) не выбран для <%> ', inBankAccountMainName;
         END IF; 
          
         --пробуем найти
         vbBankAccountMainId:= (SELECT Object_BankAccount_View.Id
                                FROM Object_BankAccount_View 
                                     -- Покажем счета только по внутренним фирмам
                                     INNER JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                                              ON ObjectBoolean_isCorporate.ObjectId = Object_BankAccount_View.JuridicalId
                                                             AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
                                                             AND (ObjectBoolean_isCorporate.ValueData = TRUE
                                                               OR Object_BankAccount_View.JuridicalId = 15505 -- ДУКО ТОВ 
                                                               OR Object_BankAccount_View.JuridicalId = 15512 -- Ірна-1 Фірма ТОВ
                                                               OR Object_BankAccount_View.isCorporate = TRUE
                                                                 )
                                WHERE UPPER (TRIM (Object_BankAccount_View.Name)) = UPPER (TRIM (inBankAccountMainName))
                                  AND Object_BankAccount_View.isErased = FALSE
                                  AND (Object_BankAccount_View.BankId = inBankMainId OR inBankMainId = 0)
                                );   
         
         IF COALESCE (vbBankAccountMainId, 0) = 0
         THEN
             -- сохранили <Объект>
             vbBankAccountMainId := lpInsertUpdate_Object(vbBankAccountMainId, zc_Object_BankAccount(), 0, TRIM (inBankAccountMainName));

             --PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Juridical(), vbBankAccountMainId, inJuridicalId);
             PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Bank(), vbBankAccountMainId, inBankMainId);

             -- сохранили протокол
             PERFORM lpInsert_ObjectProtocol (vbBankAccountMainId, vbUserId);
         END IF;
     ELSE
         --если пусто берем значение р/с из шапки документа
         vbBankAccountMainId := inBankAccountMainId_top;
     END IF;


     -- BankAccount
     IF COALESCE (inBankAccountName,'') <> ''
     THEN
         IF COALESCE (inBankId, 0) = 0
         THEN
           RAISE EXCEPTION 'Ошибка.Банк(Получатель) не выбран для <%> ', inBankAccountName;
         END IF; 
          
         --пробуем найти
         vbBankAccountId:= (SELECT Object_BankAccount_View.Id
                            FROM Object_BankAccount_View 
                                 -- Покажем счета только по внутренним фирмам
                                 INNER JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                                          ON ObjectBoolean_isCorporate.ObjectId = Object_BankAccount_View.JuridicalId
                                                         AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
                                                         AND (ObjectBoolean_isCorporate.ValueData = TRUE
                                                           OR Object_BankAccount_View.JuridicalId = 15505 -- ДУКО ТОВ 
                                                           OR Object_BankAccount_View.JuridicalId = 15512 -- Ірна-1 Фірма ТОВ
                                                           OR Object_BankAccount_View.isCorporate = TRUE
                                                             )
                            WHERE UPPER (TRIM (Object_BankAccount_View.Name)) = UPPER (TRIM (inBankAccountName))
                              AND Object_BankAccount_View.isErased = FALSE
                              AND (Object_BankAccount_View.BankId = inBankId OR inBankId = 0)
                            );  
         
         IF COALESCE (vbBankAccountId, 0) = 0
         THEN
             -- сохранили <Объект>
             vbBankAccountId := lpInsertUpdate_Object(vbBankAccountId, zc_Object_BankAccount(), 0, TRIM (inBankAccountName));

             PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Juridical(), vbBankAccountId, inJuridicalId);
             PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Bank(), vbBankAccountId, inBankId);

             -- сохранили протокол
             PERFORM lpInsert_ObjectProtocol (vbBankAccountId, vbUserId);
         END IF;
     END IF;
   
   -- проверка уникальности
   IF EXISTS (SELECT 1
              FROM ObjectLink AS ObjectLink_JuridicalOrderFinance_Juridical

                   LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_BankAccountMain
                                        ON OL_JuridicalOrderFinance_BankAccountMain.ObjectId = ObjectLink_JuridicalOrderFinance_Juridical.ObjectId
                                       AND OL_JuridicalOrderFinance_BankAccountMain.DescId = zc_ObjectLink_JuridicalOrderFinance_BankAccountMain()
             
                   LEFT JOIN ObjectLink AS ObjectLink_JuridicalOrderFinance_BankAccount
                                        ON ObjectLink_JuridicalOrderFinance_BankAccount.ObjectId = ObjectLink_JuridicalOrderFinance_Juridical.ObjectId
                                       AND ObjectLink_JuridicalOrderFinance_BankAccount.DescId = zc_ObjectLink_JuridicalOrderFinance_BankAccount()

                   LEFT JOIN ObjectLink AS ObjectLink_JuridicalOrderFinance_InfoMoney
                                        ON ObjectLink_JuridicalOrderFinance_InfoMoney.ObjectId = ObjectLink_JuridicalOrderFinance_Juridical.ObjectId
                                       AND ObjectLink_JuridicalOrderFinance_InfoMoney.DescId = zc_ObjectLink_JuridicalOrderFinance_InfoMoney()

              WHERE ObjectLink_JuridicalOrderFinance_Juridical.DescId = zc_ObjectLink_JuridicalOrderFinance_Juridical()
                AND ObjectLink_JuridicalOrderFinance_Juridical.ChildObjectId = inJuridicalId
                AND COALESCE (OL_JuridicalOrderFinance_BankAccountMain.ChildObjectId, 0) = COALESCE (vbBankAccountMainId, 0)
                AND COALESCE (ObjectLink_JuridicalOrderFinance_BankAccount.ChildObjectId, 0) = COALESCE (vbBankAccountId, 0)
                AND COALESCE (ObjectLink_JuridicalOrderFinance_InfoMoney.ChildObjectId, 0) = COALESCE (inInfoMoneyId, 0)
                AND ObjectLink_JuridicalOrderFinance_Juridical.ObjectId <> COALESCE (ioId, 0))
   THEN 
       RAISE EXCEPTION 'Ошибка.Значение  <%> + <%> + <%> уже есть в справочнике. Дублирование запрещено.', lfGet_Object_ValueData (inJuridicalId), inBankAccountName, lfGet_Object_ValueData (inInfoMoneyId);
   END IF; 

   -- проверка
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_JuridicalOrderFinance(), 0, '');

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalOrderFinance_Juridical(), ioId, inJuridicalId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalOrderFinance_BankAccountMain(), ioId, vbBankAccountMainId);   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalOrderFinance_BankAccount(), ioId, vbBankAccountId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalOrderFinance_InfoMoney(), ioId, inInfoMoneyId);

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_JuridicalOrderFinance_SummOrderFinance(), ioId, inSummOrderFinance);

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_JuridicalOrderFinance_Comment(), ioId, inComment);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

   if vbUserId = 9457 then RAISE EXCEPTION 'Админ.Test Ok.'; end if;
 
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.11.25         *
*/

-- тест
--