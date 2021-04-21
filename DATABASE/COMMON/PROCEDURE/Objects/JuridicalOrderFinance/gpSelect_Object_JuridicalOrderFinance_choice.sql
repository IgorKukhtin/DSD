-- Function: gpSelect_Object_JuridicalOrderFinance_choice()

DROP FUNCTION IF EXISTS gpSelect_Object_JuridicalOrderFinance_choice(Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_JuridicalOrderFinance_choice(
    IN inBankAccountMainId Integer,       -- с какого счета оплата
    IN inOrderFinanceId    Integer,       -- вид планирования платежа
    IN inisShowAll         Boolean,       -- True - показать все, False - показать только сохраненные
    IN inisErased          Boolean,       -- True - показать так же удаленные, False - показать только рабочие
    IN inSession           TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , OKPO TVarChar, INN TVarChar, isCorporate Boolean
             , RetailId Integer, RetailName TVarChar
             , BankName_main TVarChar, MFO_main TVarChar, BankAccountId_main Integer, BankAccountName_main TVarChar
             , BankName TVarChar, MFO TVarChar, BankAccountId Integer, BankAccountName TVarChar
             , InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyId Integer
             , InfoMoneyCode Integer
             , InfoMoneyName TVarChar
             , InfoMoneyName_all TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar, PaidKindName TVarChar
             , SummOrderFinance TFloat
             , Comment TVarChar
             , isErased Boolean
             ) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_JuridicalOrderFinance());
    
    IF inisShowAll = True
    THEN
        RETURN QUERY
        WITH
        tmpData AS (SELECT DISTINCT Object_Contract_View.JuridicalId
                         , Object_Contract_View.InfoMoneyId
                         , Object_Contract_View.ContractId
                         , Object_Contract_View.ContractCode
                         , Object_Contract_View.InvNumber AS ContractName
                         , Object_PaidKind.ValueData      AS PaidKindName
                    FROM Object_Contract_View
                        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Object_Contract_View.PaidKindId
                    WHERE Object_Contract_View.isErased = FALSE
                      AND Object_Contract_View.EndDate >= CURRENT_DATE
                      AND Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                      AND Object_Contract_View.isErased = FALSE
                      AND Object_Contract_View.PaidKindId = zc_Enum_PaidKind_FirstForm()
                   )

       -- по inOrderFinanceId выбираем статьи, которые отображать в документе
      , tmpOrderFinanceProperty AS (SELECT DISTINCT OrderFinanceProperty_Object.ChildObjectId AS Id
                                    FROM ObjectLink AS OrderFinanceProperty_OrderFinance
                                         INNER JOIN ObjectLink AS OrderFinanceProperty_Object
                                                               ON OrderFinanceProperty_Object.ObjectId = OrderFinanceProperty_OrderFinance.ObjectId
                                                              AND OrderFinanceProperty_Object.DescId = zc_ObjectLink_OrderFinanceProperty_Object()
                                                              AND COALESCE (OrderFinanceProperty_Object.ChildObjectId,0) <> 0
                                         INNER JOIN Object ON Object.Id = OrderFinanceProperty_Object.ObjectId
                                                          AND Object.isErased = False
                                    WHERE OrderFinanceProperty_OrderFinance.ChildObjectId = inOrderFinanceId
                                      AND OrderFinanceProperty_OrderFinance.DescId = zc_ObjectLink_OrderFinanceProperty_OrderFinance()
                                   )

      , tmpInfoMoney AS (SELECT DISTINCT Object_InfoMoney_View.InfoMoneyId
                         FROM Object_InfoMoney_View
                              INNER JOIN tmpOrderFinanceProperty ON (tmpOrderFinanceProperty.Id = Object_InfoMoney_View.InfoMoneyId
                                                                  OR tmpOrderFinanceProperty.Id = Object_InfoMoney_View.InfoMoneyDestinationId
                                                                  OR tmpOrderFinanceProperty.Id = Object_InfoMoney_View.InfoMoneyGroupId)
                         )

      , tmpJuridicalOrderFinance AS (SELECT Object_JuridicalOrderFinance.Id
                                          , OL_JuridicalOrderFinance_Juridical.ChildObjectId       AS JuridicalId
                                          , OL_JuridicalOrderFinance_BankAccountMain.ChildObjectId AS BankAccountId_main
                                          , OL_JuridicalOrderFinance_BankAccount.ChildObjectId     AS BankAccountId
                                          , OL_JuridicalOrderFinance_InfoMoney.ChildObjectId       AS InfoMoneyId
                                          , ObjectFloat_SummOrderFinance.ValueData :: TFloat       AS SummOrderFinance
                                          , ObjectString_Comment.ValueData ::TVarChar              AS Comment
                                          , Object_JuridicalOrderFinance.isErased                  AS isErased

                                     FROM Object AS Object_JuridicalOrderFinance
                                         INNER JOIN ObjectLink AS OL_JuridicalOrderFinance_BankAccountMain
                                                               ON OL_JuridicalOrderFinance_BankAccountMain.ObjectId = Object_JuridicalOrderFinance.Id
                                                              AND OL_JuridicalOrderFinance_BankAccountMain.DescId = zc_ObjectLink_JuridicalOrderFinance_BankAccountMain()
                                                              AND (OL_JuridicalOrderFinance_BankAccountMain.ChildObjectId = inBankAccountMainId OR inBankAccountMainId = 0)

                                         LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_InfoMoney
                                                              ON OL_JuridicalOrderFinance_InfoMoney.ObjectId = Object_JuridicalOrderFinance.Id
                                                             AND OL_JuridicalOrderFinance_InfoMoney.DescId = zc_ObjectLink_JuridicalOrderFinance_InfoMoney()
                                         LEFT JOIN tmpInfoMoney ON tmpInfoMoney.InfoMoneyId = OL_JuridicalOrderFinance_InfoMoney.ChildObjectId

                                         LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_Juridical
                                                              ON OL_JuridicalOrderFinance_Juridical.ObjectId = Object_JuridicalOrderFinance.Id
                                                             AND OL_JuridicalOrderFinance_Juridical.DescId = zc_ObjectLink_JuridicalOrderFinance_Juridical()

                                         LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_BankAccount
                                                              ON OL_JuridicalOrderFinance_BankAccount.ObjectId = Object_JuridicalOrderFinance.Id
                                                             AND OL_JuridicalOrderFinance_BankAccount.DescId = zc_ObjectLink_JuridicalOrderFinance_BankAccount()

                                         LEFT JOIN ObjectFloat AS ObjectFloat_SummOrderFinance
                                                               ON ObjectFloat_SummOrderFinance.ObjectId = Object_JuridicalOrderFinance.Id
                                                              AND ObjectFloat_SummOrderFinance.DescId = zc_ObjectFloat_JuridicalOrderFinance_SummOrderFinance()

                                         LEFT JOIN ObjectString AS ObjectString_Comment
                                                                ON ObjectString_Comment.ObjectId = Object_JuridicalOrderFinance.Id
                                                               AND ObjectString_Comment.DescId = zc_ObjectString_JuridicalOrderFinance_Comment()
                                                               
                                     WHERE Object_JuridicalOrderFinance.DescId = zc_Object_JuridicalOrderFinance()
                                        AND (Object_JuridicalOrderFinance.isErased = inisErased OR inisErased = TRUE)
                                        AND (tmpInfoMoney.InfoMoneyId IS NOT NULL OR inOrderFinanceId = 0)
                                     )

        --Результат
        SELECT COALESCE (tmpJuridicalOrderFinance.Id,0) AS Id
             , Object_Juridical.Id              AS JuridicalId
             , Object_Juridical.ObjectCode      AS JuridicalCode
             , Object_Juridical.ValueData       AS JuridicalName
 
             , ObjectHistory_JuridicalDetails_View.OKPO
             , ObjectHistory_JuridicalDetails_View.INN
             , ObjectBoolean_isCorporate.ValueData AS isCorporate

             , Object_Retail.Id                 AS RetailId
             , Object_Retail.ValueData          AS RetailName

             , Main_BankAccount_View.BankName   AS BankName_main
             , Main_BankAccount_View.MFO        AS MFO_main
             , Main_BankAccount_View.Id         AS BankAccountId_main
             , Main_BankAccount_View.Name       AS BankAccountName_main

             , Partner_BankAccount_View.BankName
             , Partner_BankAccount_View.MFO
             , Partner_BankAccount_View.Id      AS BankAccountId
             , Partner_BankAccount_View.Name    AS BankAccountName
             
             , Object_InfoMoney_View.InfoMoneyGroupName
             , Object_InfoMoney_View.InfoMoneyDestinationName
             , Object_InfoMoney_View.InfoMoneyId
             , Object_InfoMoney_View.InfoMoneyCode
             , Object_InfoMoney_View.InfoMoneyName
             , Object_InfoMoney_View.InfoMoneyName_all

             , tmpData.ContractId
             , tmpData.ContractCode
             , tmpData.ContractName
             , tmpData.PaidKindName

             , COALESCE (tmpJuridicalOrderFinance.SummOrderFinance,0) :: TFloat  AS SummOrderFinance
             , COALESCE (tmpJuridicalOrderFinance.Comment,'')         ::TVarChar AS Comment
            
             , COALESCE (tmpJuridicalOrderFinance.isErased, FALSE)    :: Boolean AS isErased
             
        FROM tmpData
             FULL JOIN tmpJuridicalOrderFinance ON tmpJuridicalOrderFinance.JuridicalId = tmpData.JuridicalId
                                               AND tmpJuridicalOrderFinance.InfoMoneyId = tmpData.InfoMoneyId
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = COALESCE (tmpJuridicalOrderFinance.JuridicalId, tmpData.JuridicalId)
             LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = COALESCE (tmpJuridicalOrderFinance.InfoMoneyId, tmpData.InfoMoneyId)
             LEFT JOIN Object_BankAccount_View AS Partner_BankAccount_View ON Partner_BankAccount_View.Id = tmpJuridicalOrderFinance.BankAccountId
             
             LEFT JOIN Object_BankAccount_View AS Main_BankAccount_View ON Main_BankAccount_View.Id = tmpJuridicalOrderFinance.BankAccountId_main
           
             LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id
 
             LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                  ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                                 AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
             LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
 
             LEFT JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                  ON ObjectLink_Juridical_GoodsProperty.ObjectId = Object_Juridical.Id
                                 AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
             LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = ObjectLink_Juridical_GoodsProperty.ChildObjectId
 
             LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                     ON ObjectBoolean_isCorporate.ObjectId = Object_Juridical.Id
                                    AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
             
        ;
    ELSE
        RETURN QUERY 
       WITH
       -- по inOrderFinanceId выбираем статьи, которые отображать в документе
       tmpOrderFinanceProperty AS (SELECT DISTINCT OrderFinanceProperty_Object.ChildObjectId AS Id
                                   FROM ObjectLink AS OrderFinanceProperty_OrderFinance
                                        INNER JOIN ObjectLink AS OrderFinanceProperty_Object
                                                              ON OrderFinanceProperty_Object.ObjectId = OrderFinanceProperty_OrderFinance.ObjectId
                                                             AND OrderFinanceProperty_Object.DescId = zc_ObjectLink_OrderFinanceProperty_Object()
                                                             AND COALESCE (OrderFinanceProperty_Object.ChildObjectId,0) <> 0
                                        INNER JOIN Object ON Object.Id = OrderFinanceProperty_Object.ObjectId
                                                         AND Object.isErased = False
                                   WHERE OrderFinanceProperty_OrderFinance.ChildObjectId = inOrderFinanceId
                                     AND OrderFinanceProperty_OrderFinance.DescId = zc_ObjectLink_OrderFinanceProperty_OrderFinance()
                                  )
     , tmpInfoMoney AS (SELECT DISTINCT Object_InfoMoney_View.InfoMoneyId
                        FROM Object_InfoMoney_View
                             INNER JOIN tmpOrderFinanceProperty ON (tmpOrderFinanceProperty.Id = Object_InfoMoney_View.InfoMoneyId
                                                                 OR tmpOrderFinanceProperty.Id = Object_InfoMoney_View.InfoMoneyDestinationId
                                                                 OR tmpOrderFinanceProperty.Id = Object_InfoMoney_View.InfoMoneyGroupId)
                        )

     , tmpData AS (SELECT DISTINCT Object_Contract_View.JuridicalId
                        , Object_Contract_View.InfoMoneyId
                        , Object_Contract_View.ContractId
                        , Object_Contract_View.ContractCode
                        , Object_Contract_View.InvNumber AS ContractName
                        , Object_PaidKind.ValueData      AS PaidKindName
                   FROM Object_Contract_View
                        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Object_Contract_View.PaidKindId
                   WHERE Object_Contract_View.isErased = FALSE
                     AND Object_Contract_View.EndDate >= CURRENT_DATE
                     AND Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                     AND Object_Contract_View.isErased = FALSE
                     --AND Object_Contract_View.PaidKindId = zc_Enum_PaidKind_FirstForm()
                  )



        SELECT Object_JuridicalOrderFinance.Id  AS Id
 
             , Object_Juridical.Id              AS JuridicalId
             , Object_Juridical.ObjectCode      AS JuridicalCode
             , Object_Juridical.ValueData       AS JuridicalName
 
             , ObjectHistory_JuridicalDetails_View.OKPO
             , ObjectHistory_JuridicalDetails_View.INN
             , ObjectBoolean_isCorporate.ValueData AS isCorporate

             , Object_Retail.Id                 AS RetailId
             , Object_Retail.ValueData          AS RetailName

             , Main_BankAccount_View.BankName   AS BankName_main
             , Main_BankAccount_View.MFO        AS MFO_main
             , Main_BankAccount_View.Id         AS BankAccountId_main
             , Main_BankAccount_View.Name       AS BankAccountName_main

             , Partner_BankAccount_View.BankName
             , Partner_BankAccount_View.MFO
             , Partner_BankAccount_View.Id      AS BankAccountId
             , Partner_BankAccount_View.Name    AS BankAccountName
             
             , Object_InfoMoney_View.InfoMoneyGroupName
             , Object_InfoMoney_View.InfoMoneyDestinationName
             , Object_InfoMoney_View.InfoMoneyId
             , Object_InfoMoney_View.InfoMoneyCode
             , Object_InfoMoney_View.InfoMoneyName
             , Object_InfoMoney_View.InfoMoneyName_all
             
             , tmpData.ContractId
             , tmpData.ContractCode
             , tmpData.ContractName
             , tmpData.PaidKindName

             , ObjectFloat_SummOrderFinance.ValueData :: TFloat   AS SummOrderFinance
             , ObjectString_Comment.ValueData         :: TVarChar AS Comment
            
             , Object_JuridicalOrderFinance.isErased  AS isErased
 
        FROM Object AS Object_JuridicalOrderFinance
             INNER JOIN ObjectLink AS OL_JuridicalOrderFinance_BankAccountMain
                                   ON OL_JuridicalOrderFinance_BankAccountMain.ObjectId = Object_JuridicalOrderFinance.Id
                                  AND OL_JuridicalOrderFinance_BankAccountMain.DescId = zc_ObjectLink_JuridicalOrderFinance_BankAccountMain()
                                  AND (OL_JuridicalOrderFinance_BankAccountMain.ChildObjectId = inBankAccountMainId OR inBankAccountMainId = 0)
             LEFT JOIN Object_BankAccount_View AS Main_BankAccount_View ON Main_BankAccount_View.Id = OL_JuridicalOrderFinance_BankAccountMain.ChildObjectId

             LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_InfoMoney
                                  ON OL_JuridicalOrderFinance_InfoMoney.ObjectId = Object_JuridicalOrderFinance.Id
                                 AND OL_JuridicalOrderFinance_InfoMoney.DescId = zc_ObjectLink_JuridicalOrderFinance_InfoMoney()
             LEFT JOIN tmpInfoMoney ON tmpInfoMoney.InfoMoneyId = OL_JuridicalOrderFinance_InfoMoney.ChildObjectId
             LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = OL_JuridicalOrderFinance_InfoMoney.ChildObjectId

             LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_Juridical
                                  ON OL_JuridicalOrderFinance_Juridical.ObjectId = Object_JuridicalOrderFinance.Id
                                 AND OL_JuridicalOrderFinance_Juridical.DescId = zc_ObjectLink_JuridicalOrderFinance_Juridical()
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = OL_JuridicalOrderFinance_Juridical.ChildObjectId

             LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_BankAccount
                                  ON OL_JuridicalOrderFinance_BankAccount.ObjectId = Object_JuridicalOrderFinance.Id
                                 AND OL_JuridicalOrderFinance_BankAccount.DescId = zc_ObjectLink_JuridicalOrderFinance_BankAccount()
             LEFT JOIN Object_BankAccount_View AS Partner_BankAccount_View ON Partner_BankAccount_View.Id = OL_JuridicalOrderFinance_BankAccount.ChildObjectId

             LEFT JOIN ObjectFloat AS ObjectFloat_SummOrderFinance
                                   ON ObjectFloat_SummOrderFinance.ObjectId = Object_JuridicalOrderFinance.Id
                                  AND ObjectFloat_SummOrderFinance.DescId = zc_ObjectFloat_JuridicalOrderFinance_SummOrderFinance()
  
             LEFT JOIN ObjectString AS ObjectString_Comment
                                    ON ObjectString_Comment.ObjectId = Object_JuridicalOrderFinance.Id
                                   AND ObjectString_Comment.DescId = zc_ObjectString_JuridicalOrderFinance_Comment()

             LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id
 
             LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                  ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                                 AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
             LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
 
             LEFT JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                  ON ObjectLink_Juridical_GoodsProperty.ObjectId = Object_Juridical.Id
                                 AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
             LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = ObjectLink_Juridical_GoodsProperty.ChildObjectId
 
             LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                     ON ObjectBoolean_isCorporate.ObjectId = Object_Juridical.Id
                                    AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()

             LEFT JOIN tmpData ON tmpData.InfoMoneyId = Object_InfoMoney_View.InfoMoneyId
                              AND tmpData.JuridicalId = Object_Juridical.Id

        WHERE Object_JuridicalOrderFinance.DescId = zc_Object_JuridicalOrderFinance()
         AND (Object_JuridicalOrderFinance.isErased = inisErased OR inisErased = TRUE)
         AND (tmpInfoMoney.InfoMoneyId IS NOT NULL OR inOrderFinanceId = 0)
        ;
    END IF;
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
