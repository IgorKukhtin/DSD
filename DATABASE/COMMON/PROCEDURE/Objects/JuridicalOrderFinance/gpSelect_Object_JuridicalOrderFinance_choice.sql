-- Function: gpSelect_Object_JuridicalOrderFinance_choice()

DROP FUNCTION IF EXISTS gpSelect_Object_JuridicalOrderFinance_choice(Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_JuridicalOrderFinance_choice(
    IN inMovementId        Integer,       -- док zc_Movement_JuridicalOrderFinance
    IN inOrderFinanceId    Integer,       -- вид планирования платежа
    IN inIsShowAll         Boolean,       -- True - показать все, False - показать только сохраненные
    IN inIsErased          Boolean,       -- True - показать так же удаленные, False - показать только рабочие
    IN inSession           TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , OKPO TVarChar, INN TVarChar, isCorporate Boolean
             , RetailId Integer, RetailName TVarChar
             , BankId_main Integer, BankName_main TVarChar, MFO_main TVarChar, BankAccountId_main Integer, BankAccountName_main TVarChar
             , BankId Integer, BankName TVarChar, MFO TVarChar, BankAccountId Integer, BankAccountName TVarChar
             , NumGroup Integer
             , InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyId Integer
             , InfoMoneyCode Integer
             , InfoMoneyName TVarChar
             , InfoMoneyName_all TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar, ContractStateKindCode Integer, PaidKindName TVarChar
             , SummOrderFinance TFloat
             , Comment_pay TVarChar
             , isErased Boolean
             ) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_JuridicalOrderFinance());

     -- Результат
     RETURN QUERY
       WITH tmpMI AS (SELECT MovementItem.Id                AS MovementItemId
                           , MovementItem.ObjectId          AS JuridicalId
                           , MILinkObject_Contract.ObjectId AS ContractId
                      FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                           JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = tmpIsErased.isErased
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                            ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                     )

       -- УП-Статья или Группа или ...
     , tmpOrderFinanceProperty AS (SELECT DISTINCT
                                          -- УП - Статья или Группа или ...
                                          OL_OrderFinanceProperty_Object.ChildObjectId               AS ObjectId
                                          -- Форма оплаты
                                        , OL_OrderFinance_PaidKind.ChildObjectId                     AS PaidKindId
                                          -- № п/п группы
                                        , ObjectFloat_Group.ValueData                                AS NumGroup
                                   FROM ObjectLink AS OL_OrderFinanceProperty_OrderFinance
                                        INNER JOIN Object ON Object.Id       = OL_OrderFinanceProperty_OrderFinance.ObjectId
                                                         -- не удален
                                                         AND Object.isErased = FALSE
                                        -- Форма оплаты
                                        INNER JOIN ObjectLink AS OL_OrderFinance_PaidKind
                                                              ON OL_OrderFinance_PaidKind.ObjectId      = OL_OrderFinanceProperty_OrderFinance.ChildObjectId
                                                             AND OL_OrderFinance_PaidKind.DescId        = zc_ObjectLink_OrderFinance_PaidKind()
                                                             AND OL_OrderFinance_PaidKind.ChildObjectId > 0
                                        -- УП - Статья или Группа или ...
                                        INNER JOIN ObjectLink AS OL_OrderFinanceProperty_Object
                                                              ON OL_OrderFinanceProperty_Object.ObjectId      = OL_OrderFinanceProperty_OrderFinance.ObjectId
                                                             AND OL_OrderFinanceProperty_Object.DescId        = zc_ObjectLink_OrderFinanceProperty_Object()
                                                             AND OL_OrderFinanceProperty_Object.ChildObjectId > 0
                                        -- № п/п группы
                                        LEFT JOIN ObjectFloat AS ObjectFloat_Group
                                                              ON ObjectFloat_Group.ObjectId = OL_OrderFinanceProperty_OrderFinance.ObjectId
                                                             AND ObjectFloat_Group.DescId   = zc_ObjectFloat_OrderFinanceProperty_Group()

                                   WHERE OL_OrderFinanceProperty_OrderFinance.ChildObjectId = inOrderFinanceId
                                     AND OL_OrderFinanceProperty_OrderFinance.DescId        = zc_ObjectLink_OrderFinanceProperty_OrderFinance()
                                  )
       -- разворачивается по УП-статьям + № группы
     , tmpInfoMoney AS (SELECT DISTINCT
                               Object_InfoMoney_View.InfoMoneyId
                             , tmpOrderFinanceProperty.PaidKindId
                             , tmpOrderFinanceProperty.NumGroup
                        FROM Object_InfoMoney_View
                             INNER JOIN tmpOrderFinanceProperty ON (tmpOrderFinanceProperty.ObjectId = Object_InfoMoney_View.InfoMoneyId
                                                                 OR tmpOrderFinanceProperty.ObjectId = Object_InfoMoney_View.InfoMoneyDestinationId
                                                                 OR tmpOrderFinanceProperty.ObjectId = Object_InfoMoney_View.InfoMoneyGroupId
                                                                   )
                       )
       -- Договора - только tmpInfoMoney or tmpMI
     , tmpData AS (SELECT DISTINCT
                          Object_Contract_View.JuridicalId
                        , Object_Contract_View.InfoMoneyId
                        , Object_Contract_View.ContractId
                        , Object_Contract_View.ContractCode
                        , Object_Contract_View.InvNumber             AS ContractName
                        , Object_Contract_View.ContractStateKindCode AS ContractStateKindCode
                        , Object_PaidKind.ValueData                  AS PaidKindName
                          -- № п/п группы
                        , tmpInfoMoney.NumGroup

                   FROM Object_Contract_View
                        -- ограничение
                        INNER JOIN tmpInfoMoney ON tmpInfoMoney.InfoMoneyId = Object_Contract_View.InfoMoneyId
                                               -- еще это условие
                                               AND tmpInfoMoney.PaidKindId  = Object_Contract_View.PaidKindId
                        --
                        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Object_Contract_View.PaidKindId
                   WHERE Object_Contract_View.isErased = FALSE
                     AND Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                     -- ???
                     AND Object_Contract_View.EndDate >= CURRENT_DATE
                     -- !!! Только для этого режима
                     AND inIsShowAll = TRUE

                 UNION
                  -- только договора tmpMI
                  SELECT DISTINCT
                          tmpMI.JuridicalId
                        , Object_Contract_View.InfoMoneyId
                        , tmpMI.ContractId
                        , Object_Contract_View.ContractCode
                        , Object_Contract_View.InvNumber             AS ContractName
                        , Object_Contract_View.ContractStateKindCode AS ContractStateKindCode
                        , Object_PaidKind.ValueData                  AS PaidKindName
                          -- № п/п группы
                        , tmpInfoMoney.NumGroup

                   FROM tmpMI
                        INNER JOIN Object_Contract_View ON Object_Contract_View.ContractId = tmpMI.ContractId
                        -- Не ошибка? - не нужен zc_ObjectLink_OrderFinance_PaidKind
                        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Object_Contract_View.PaidKindId
                        -- ?только для NumGroup
                        LEFT JOIN tmpInfoMoney ON tmpInfoMoney.InfoMoneyId = Object_Contract_View.InfoMoneyId
                -- !!! Только для этого режима
                -- WHERE inIsShowAll = FALSE
                  -- еще это условие
                  -- AND Object_Contract_View.PaidKindId IN (SELECT DISTINCT tmpInfoMoney.PaidKindId FROM tmpInfoMoney)
                  )
       --  Параметры Юр.лица в планировании
     , tmpJuridicalOrderFinance AS (SELECT Object_JuridicalOrderFinance.Id
                                         , OL_JuridicalOrderFinance_InfoMoney.ChildObjectId AS InfoMoneyId
                                         , OL_JuridicalOrderFinance_Juridical.ChildObjectId AS JuridicalId

                                         , Main_BankAccount_View.BankId           AS BankId_main
                                         , Main_BankAccount_View.BankName         AS BankName_main
                                         , Main_BankAccount_View.MFO              AS MFO_main
                                         , Main_BankAccount_View.Id               AS BankAccountId_main
                                         , Main_BankAccount_View.Name             AS BankAccountName_main

                                         , Partner_BankAccount_View.BankId
                                         , Partner_BankAccount_View.BankName
                                         , Partner_BankAccount_View.MFO
                                         , Partner_BankAccount_View.Id            AS BankAccountId
                                         , Partner_BankAccount_View.Name          AS BankAccountName

                                          -- Лимит по сумме отсрочки
                                         , ObjectFloat_SummOrderFinance.ValueData AS SummOrderFinance
                                          -- Назначение платежа
                                         , ObjectString_Comment.ValueData         AS Comment_pay
                                           --
                                         , Object_JuridicalOrderFinance.isErased  AS isErased

                                    FROM Object AS Object_JuridicalOrderFinance

                                         LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_InfoMoney
                                                              ON OL_JuridicalOrderFinance_InfoMoney.ObjectId = Object_JuridicalOrderFinance.Id
                                                             AND OL_JuridicalOrderFinance_InfoMoney.DescId   = zc_ObjectLink_JuridicalOrderFinance_InfoMoney()
                                         LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_Juridical
                                                              ON OL_JuridicalOrderFinance_Juridical.ObjectId = Object_JuridicalOrderFinance.Id
                                                             AND OL_JuridicalOrderFinance_Juridical.DescId   = zc_ObjectLink_JuridicalOrderFinance_Juridical()

                                         LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_BankAccountMain
                                                              ON OL_JuridicalOrderFinance_BankAccountMain.ObjectId = Object_JuridicalOrderFinance.Id
                                                             AND OL_JuridicalOrderFinance_BankAccountMain.DescId   = zc_ObjectLink_JuridicalOrderFinance_BankAccountMain()
                                         LEFT JOIN Object_BankAccount_View AS Main_BankAccount_View ON Main_BankAccount_View.Id = OL_JuridicalOrderFinance_BankAccountMain.ChildObjectId

                                         LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_BankAccount
                                                              ON OL_JuridicalOrderFinance_BankAccount.ObjectId = Object_JuridicalOrderFinance.Id
                                                             AND OL_JuridicalOrderFinance_BankAccount.DescId   = zc_ObjectLink_JuridicalOrderFinance_BankAccount()
                                         LEFT JOIN Object_BankAccount_View AS Partner_BankAccount_View ON Partner_BankAccount_View.Id = OL_JuridicalOrderFinance_BankAccount.ChildObjectId

                                         -- Лимит по сумме отсрочки
                                         LEFT JOIN ObjectFloat AS ObjectFloat_SummOrderFinance
                                                               ON ObjectFloat_SummOrderFinance.ObjectId = Object_JuridicalOrderFinance.Id
                                                              AND ObjectFloat_SummOrderFinance.DescId = zc_ObjectFloat_JuridicalOrderFinance_SummOrderFinance()

                                         -- Назначение платежа
                                         LEFT JOIN ObjectString AS ObjectString_Comment
                                                                ON ObjectString_Comment.ObjectId = Object_JuridicalOrderFinance.Id
                                                               AND ObjectString_Comment.DescId = zc_ObjectString_JuridicalOrderFinance_Comment()

                                    WHERE Object_JuridicalOrderFinance.DescId   = zc_Object_JuridicalOrderFinance()
                                      AND Object_JuridicalOrderFinance.isErased = FALSE
                                   )
        -- Результат
        SELECT tmpJuridicalOrderFinance.Id

             , Object_Juridical.Id              AS JuridicalId
             , Object_Juridical.ObjectCode      AS JuridicalCode
             , Object_Juridical.ValueData       AS JuridicalName

             , ObjectHistory_JuridicalDetails_View.OKPO
             , ObjectHistory_JuridicalDetails_View.INN
             , ObjectBoolean_isCorporate.ValueData AS isCorporate

             , Object_Retail.Id                 AS RetailId
             , Object_Retail.ValueData          AS RetailName

             , tmpJuridicalOrderFinance.BankId_main
             , tmpJuridicalOrderFinance.BankName_main
             , tmpJuridicalOrderFinance.MFO_main
             , tmpJuridicalOrderFinance.BankAccountId_main
             , tmpJuridicalOrderFinance.BankAccountName_main

             , tmpJuridicalOrderFinance.BankId
             , tmpJuridicalOrderFinance.BankName
             , tmpJuridicalOrderFinance.MFO
             , tmpJuridicalOrderFinance.BankAccountId
             , tmpJuridicalOrderFinance.BankAccountName

               -- № п/п группы
             , tmpData.NumGroup :: Integer AS NumGroup
               --
             , Object_InfoMoney_View.InfoMoneyGroupName
             , Object_InfoMoney_View.InfoMoneyDestinationName
             , Object_InfoMoney_View.InfoMoneyId
             , Object_InfoMoney_View.InfoMoneyCode
             , Object_InfoMoney_View.InfoMoneyName
             , Object_InfoMoney_View.InfoMoneyName_all

             , tmpData.ContractId
             , tmpData.ContractCode
             , tmpData.ContractName
             , tmpData.ContractStateKindCode
             , tmpData.PaidKindName

               -- Лимит по сумме отсрочки
             , tmpJuridicalOrderFinance.SummOrderFinance
               -- Назначение платежа
             , tmpJuridicalOrderFinance.Comment_pay
               --
             , tmpJuridicalOrderFinance.isErased

        FROM tmpData
             LEFT JOIN tmpJuridicalOrderFinance ON tmpJuridicalOrderFinance.JuridicalId = tmpData.JuridicalId
                                               AND tmpJuridicalOrderFinance.InfoMoneyId = tmpData.InfoMoneyId

             LEFT JOIN Object AS Object_Juridical          ON Object_Juridical.Id                             = tmpData.JuridicalId
             LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = tmpData.JuridicalId
             LEFT JOIN Object_InfoMoney_View               ON Object_InfoMoney_View.InfoMoneyId               = tmpData.InfoMoneyId

             LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                  ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                                 AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
             LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

             LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                     ON ObjectBoolean_isCorporate.ObjectId = Object_Juridical.Id
                                    AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.09.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_JuridicalOrderFinance_choice (4529011,3988054, FALSE , FALSE ,'5')
