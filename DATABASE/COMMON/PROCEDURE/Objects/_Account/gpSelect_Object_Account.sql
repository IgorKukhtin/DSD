-- Function: gpSelect_Object_Account(TVarChar)

-- DROP FUNCTION gpSelect_Object_Account(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Account(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               AccountGroupId Integer, AccountGroupCode Integer, AccountGroupName TVarChar, 
               AccountDirectionId Integer, AccountDirectionCode Integer, AccountDirectionName TVarChar, 
               InfoMoneyGroupId Integer, InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar, 
               InfoMoneyDestinationId Integer, InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar, 
               InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, 
               isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Account());
   
   -- таблица для справочника уп-назначения (на самом деле это три спраочника)
   CREATE TEMP TABLE tmpInfoMoney2 (InfoMoneyGroupId Integer, InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar, 
                                   InfoMoneyDestinationId Integer, InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar);

   -- таблица для 
   CREATE TEMP TABLE tmpInfoMoney (InfoMoneyGroupId Integer, InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar, 
                                   InfoMoneyDestinationId Integer, InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar, 
                                   InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar);
   
   -- Выбираем данные для справочника уп-назначения (на самом деле это три спраочника)
   INSERT INTO tmpInfoMoney (InfoMoneyGroupId, InfoMoneyGroupCode, InfoMoneyGroupName, 
                             InfoMoneyDestinationId, InfoMoneyDestinationCode, InfoMoneyDestinationName, 
                             InfoMoneyId, InfoMoneyCode, InfoMoneyName)
     SELECT 
           Object_InfoMoneyGroup.Id
          ,Object_InfoMoneyGroup.ObjectCode 
          ,Object_InfoMoneyGroup.ValueData
          
          ,Object_InfoMoneyDestination.Id
          ,Object_InfoMoneyDestination.ObjectCode
          ,Object_InfoMoneyDestination.ValueData
          
          ,Object_InfoMoney.Id
          ,Object_InfoMoney.ObjectCode
          ,Object_InfoMoney.ValueData
          
     FROM Object AS Object_InfoMoney
         
            LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyGroup
                   ON ObjectLink_InfoMoney_InfoMoneyGroup.ObjectId = Object_InfoMoney.Id 
                  AND ObjectLink_InfoMoney_InfoMoneyGroup.DescId = zc_ObjectLink_InfoMoney_InfoMoneyGroup()
            LEFT JOIN Object AS Object_InfoMoneyGroup ON Object_InfoMoneyGroup.Id = ObjectLink_InfoMoney_InfoMoneyGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyDestination
                   ON ObjectLink_InfoMoney_InfoMoneyDestination.ObjectId = Object_InfoMoney.Id 
                  AND ObjectLink_InfoMoney_InfoMoneyDestination.DescId = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
            LEFT JOIN Object AS Object_InfoMoneyDestination ON Object_InfoMoneyDestination.Id = ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId

     WHERE Object_InfoMoney.DescId = zc_Object_InfoMoney();

   -- группируем данные из справочника уп-назначения (по двум справоникам)
   INSERT INTO tmpInfoMoney2 (InfoMoneyGroupId, InfoMoneyGroupCode, InfoMoneyGroupName, InfoMoneyDestinationId, InfoMoneyDestinationCode, InfoMoneyDestinationName)
      SELECT tmpInfoMoney.InfoMoneyGroupId, tmpInfoMoney.InfoMoneyGroupCode, tmpInfoMoney.InfoMoneyGroupName, tmpInfoMoney.InfoMoneyDestinationId, tmpInfoMoney.InfoMoneyDestinationCode, tmpInfoMoney.InfoMoneyDestinationName
      FROM tmpInfoMoney
      GROUP BY tmpInfoMoney.InfoMoneyGroupId, tmpInfoMoney.InfoMoneyGroupCode, tmpInfoMoney.InfoMoneyGroupName, tmpInfoMoney.InfoMoneyDestinationId, tmpInfoMoney.InfoMoneyDestinationCode, tmpInfoMoney.InfoMoneyDestinationName;

     RETURN QUERY 
       SELECT 
             Object_Account.Id               AS Id
           , Object_Account.ObjectCode       AS Code
           , Object_Account.ValueData        AS Name

           , Object_AccountGroup.Id          AS AccountGroupId
           , Object_AccountGroup.ObjectCode  AS AccountGroupCode
           , Object_AccountGroup.ValueData   AS AccountGroupName
           
           , Object_AccountDirection.Id         AS AccountDirectionId
           , Object_AccountDirection.ObjectCode AS AccountDirectionCode
           , Object_AccountDirection.ValueData  AS AccountDirectionName
           
           , COALESCE (tmpInfoMoney2.InfoMoneyGroupId, tmpInfoMoney.InfoMoneyGroupId)     AS InfoMoneyGroupId
           , COALESCE (tmpInfoMoney2.InfoMoneyGroupCode, tmpInfoMoney.InfoMoneyGroupCode) AS InfoMoneyGroupCode
           , COALESCE (tmpInfoMoney2.InfoMoneyGroupName, tmpInfoMoney.InfoMoneyGroupName) AS InfoMoneyGroupName

           , COALESCE (tmpInfoMoney2.InfoMoneyDestinationId, tmpInfoMoney.InfoMoneyDestinationId)     AS InfoMoneyDestinationId
           , COALESCE (tmpInfoMoney2.InfoMoneyDestinationCode, tmpInfoMoney.InfoMoneyDestinationCode) AS InfoMoneyDestinationCode
           , COALESCE (tmpInfoMoney2.InfoMoneyDestinationName, tmpInfoMoney.InfoMoneyDestinationName) AS InfoMoneyDestinationName

           , tmpInfoMoney.InfoMoneyId     AS InfoMoneyId
           , tmpInfoMoney.InfoMoneyCode   AS InfoMoneyCode
           , tmpInfoMoney.InfoMoneyName   AS InfoMoneyName
           
           , Object_Account.isErased      AS isErased

       FROM Object AS Object_Account
            LEFT JOIN ObjectLink AS ObjectLink_Account_AccountGroup
                   ON ObjectLink_Account_AccountGroup.ObjectId = Object_Account.Id
                  AND ObjectLink_Account_AccountGroup.DescId = zc_ObjectLink_Account_AccountGroup()
            LEFT JOIN Object AS Object_AccountGroup ON Object_AccountGroup.Id = ObjectLink_Account_AccountGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Account_AccountDirection
                   ON ObjectLink_Account_AccountDirection.ObjectId = Object_Account.Id
                  AND ObjectLink_Account_AccountDirection.DescId = zc_ObjectLink_Account_AccountDirection()
            LEFT JOIN Object AS Object_AccountDirection ON Object_AccountDirection.Id = ObjectLink_Account_AccountDirection.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Account_InfoMoneyDestination
                   ON ObjectLink_Account_InfoMoneyDestination.ObjectId = Object_Account.Id
                  AND ObjectLink_Account_InfoMoneyDestination.DescId = zc_ObjectLink_Account_InfoMoneyDestination()
            LEFT JOIN ObjectLink AS ObjectLink_Account_InfoMoney
                   ON ObjectLink_Account_InfoMoney.ObjectId = Object_Account.Id
                  AND ObjectLink_Account_InfoMoney.DescId = zc_ObjectLink_Account_InfoMoney()
         
            LEFT JOIN tmpInfoMoney2 ON tmpInfoMoney2.InfoMoneyDestinationId = ObjectLink_Account_InfoMoneyDestination.ChildObjectId
            LEFT JOIN tmpInfoMoney ON tmpInfoMoney.InfoMoneyId = ObjectLink_Account_InfoMoneyDestination.ChildObjectId

       WHERE Object_Account.DescId = zc_Object_Account();

   DROP TABLE tmpInfoMoney;
   DROP TABLE tmpInfoMoney2;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Account (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.06.13                                         *  errors
 21.06.13          *                              *  создание врем.таблиц
 17.06.13          *
 
*/

-- тест
-- SELECT * FROM gpSelect_Object_Account('2')