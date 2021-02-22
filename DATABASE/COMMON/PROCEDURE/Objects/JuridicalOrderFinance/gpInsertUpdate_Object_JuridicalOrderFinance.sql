-- Function: gpInsertUpdate_Object_ImportTypeItems()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalOrderFinance (Integer, Integer, Integer, Integer, TFloat, Tvarchar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalOrderFinance (Integer, Integer, Integer, Integer, Integer, TFloat, Tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalOrderFinance (Integer, Integer, Integer, Integer, Integer, TFloat, Tvarchar, Tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_JuridicalOrderFinance(
 INOUT ioId                      Integer   ,   	-- ключ объекта <>
    IN inJuridicalId             Integer   ,    -- 
    IN inBankAccountMainId       Integer   ,    --
    IN inBankAccountId           Integer   ,    -- 
    IN inInfoMoneyId             Integer   ,    -- 
    IN inSummOrderFinance        TFloat   ,    -- 
    IN inComment                 TVarChar ,
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpGetUserBySession (inSession); 

   IF COALESCE (inJuridicalId,0) = 0
   THEN
       RETURN;
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
                AND COALESCE (OL_JuridicalOrderFinance_BankAccountMain.ChildObjectId, 0) = COALESCE (inBankAccountMainId, 0)
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
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalOrderFinance_BankAccountMain(), ioId, inBankAccountMainId);   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalOrderFinance_BankAccount(), ioId, inBankAccountId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalOrderFinance_InfoMoney(), ioId, inInfoMoneyId);

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_JuridicalOrderFinance_SummOrderFinance(), ioId, inSummOrderFinance);

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_JuridicalOrderFinance_Comment(), ioId, inComment);
   
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.02.21         * inComment
 09.09.20         * add inBankAccountMainId
 06.08.19         * 
*/

-- тест
--

/*
    WITH 
_tmp AS ( SELECT DISTINCT
             *
FROM (SELECT DISTINCT
             Object_MoneyPlace.Id              AS MoneyPlaceId
           , (Object_MoneyPlace.ValueData) :: TVarChar AS MoneyPlaceName
    
           , MILinkObject_InfoMoney.ObjectId AS InfoMoneyId
           , Object_InfoMoney_View.InfoMoneyName

           , Partner_BankAccount_View.BankName
           , MILinkObject_BankAccount.ObjectId  AS BankAccountId
           , Partner_BankAccount_View.Name      AS BankAccountName
           
, row_number() over (Partition by  Object_MoneyPlace.Id, MILinkObject_InfoMoney.ObjectId, Partner_BankAccount_View.BankName ORDER BY MILinkObject_BankAccount.ObjectId DESC ) AS ord
       FROM Movement
          
            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
            
            LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                             ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                            AND MILinkObject_MoneyPlace.DescId         = zc_MILinkObject_MoneyPlace()
            INNER JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId
                                               AND Object_MoneyPlace.DescId = zc_Object_Juridical()
           
            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

            INNER JOIN MovementItemLinkObject AS MILinkObject_BankAccount
                                             ON MILinkObject_BankAccount.MovementItemId = MovementItem.Id
                                            AND MILinkObject_BankAccount.DescId = zc_MILinkObject_BankAccount()
            LEFT JOIN Object_BankAccount_View AS Partner_BankAccount_View ON Partner_BankAccount_View.Id = MILinkObject_BankAccount.ObjectId

      WHERE  Movement.DescId = zc_Movement_BankAccount()
                         AND Movement.OperDate BETWEEN '01.08.2020' AND '08.09.2020'
                         AND Movement.StatusId = zc_Enum_Status_Complete()
AND MovementItem.ObjectId = 4529011   --  р/сч. ОТП банк
order by 2)
as tmp
where tmp.ord = 1
order by 2
)


SELECT gpInsertUpdate_Object_JuridicalOrderFinance(
                                                   ioId                :=  0                 ::      Integer   ,   -- ключ объекта <>
                                                   inJuridicalId       := _tmp.MoneyPlaceId  ::      Integer   ,     
                                                   inBankAccountId     := _tmp.BankAccountId ::      Integer   ,     
                                                   inInfoMoneyId       := _tmp.InfoMoneyId   ::      Integer   ,     
                                                   inSummOrderFinance  :=  0                 ::      TFloat    , 
                                                   inSession           :=  '5'               ::      TVarChar)
FROM _tmp
--select * from gpSelect_Object_JuridicalOrderFinance(inShowAll := 'False' , inisErased := 'False' ,  inSession := '5');
*/