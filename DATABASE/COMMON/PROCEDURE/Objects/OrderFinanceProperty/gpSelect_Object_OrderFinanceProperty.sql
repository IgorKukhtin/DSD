-- Function: gpSelect_Object_OrderFinanceProperty()

--DROP FUNCTION IF EXISTS gpSelect_Object_OrderFinanceProperty(TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_OrderFinanceProperty(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_OrderFinanceProperty(
    IN inisErased    Boolean ,      -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ObjectId Integer
             , OrderFinanceId Integer, OrderFinanceCode Integer, OrderFinanceName TVarChar
             --, ObjectId Integer, ObjectCode Integer, ObjectName TVarChar
             , InfoMoneyGroupId Integer
             , InfoMoneyGroupCode Integer
             , InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationId Integer
             , InfoMoneyDestinationCode Integer
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyId Integer
             , InfoMoneyCode Integer
             , InfoMoneyName TVarChar
             , isErased Boolean
             ) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_OrderFinanceProperty());

   RETURN QUERY 
   WITH 
   tmpObject AS (SELECT DISTINCT ObjectLink_Object.ObjectId AS OrderFinancePropertyId
                      , Object.Id                                     AS ObjectId
                      , CASE WHEN Object.DescId = zc_Object_InfoMoneyGroup() THEN Object.Id
                             WHEN Object.DescId <> zc_Object_InfoMoneyGroup() THEN Object_InfoMoney_View.InfoMoneyGroupId
                             ELSE NULL 
                        END AS InfoMoneyGroupId
  
                      , CASE WHEN Object.DescId = zc_Object_InfoMoneyDestination() THEN Object.Id 
                             WHEN Object.DescId = zc_Object_InfoMoney() THEN Object_InfoMoney_View.InfoMoneyDestinationId
                             ELSE NULL
                        END AS InfoMoneyDestinationId

                      , CASE WHEN Object.DescId = zc_Object_InfoMoney() THEN Object.Id ELSE NULL END AS InfoMoneyId

                 FROM ObjectLink AS ObjectLink_Object
                      INNER JOIN Object ON Object.Id = ObjectLink_Object.ChildObjectId
                      INNER JOIN Object_InfoMoney_View ON (Object_InfoMoney_View.InfoMoneyId = Object.Id
                                                        OR Object_InfoMoney_View.InfoMoneyDestinationId = Object.Id
                                                        OR Object_InfoMoney_View.InfoMoneyGroupId = Object.Id
                                                           )
                 WHERE ObjectLink_Object.DescId = zc_ObjectLink_OrderFinanceProperty_Object()
                )

       SELECT Object_OrderFinanceProperty.Id   AS Id

            , tmpObject.ObjectId               AS ObjectId
            , Object_OrderFinance.Id           AS OrderFinanceId
            , Object_OrderFinance.ObjectCode   AS OrderFinanceCode
            , Object_OrderFinance.ValueData    AS OrderFinanceName

            , Object_InfoMoneyGroup.Id               AS InfoMoneyGroupId
            , Object_InfoMoneyGroup.ObjectCode       AS InfoMoneyGroupCode
            , Object_InfoMoneyGroup.ValueData        AS InfoMoneyGroupName
            , Object_InfoMoneyDestination.Id         AS InfoMoneyDestinationId
            , Object_InfoMoneyDestination.ObjectCode AS InfoMoneyDestinationCode
            , Object_InfoMoneyDestination.ValueData  AS InfoMoneyDestinationName
            , Object_InfoMoney.Id                    AS InfoMoneyId
            , Object_InfoMoney.ObjectCode            AS InfoMoneyCode
            , Object_InfoMoney.ValueData             AS InfoMoneyName
            
            , Object_OrderFinanceProperty.isErased AS isErased

       FROM Object AS Object_OrderFinanceProperty
           LEFT JOIN ObjectLink AS OrderFinanceProperty_OrderFinance
                                ON OrderFinanceProperty_OrderFinance.ObjectId = Object_OrderFinanceProperty.Id
                               AND OrderFinanceProperty_OrderFinance.DescId = zc_ObjectLink_OrderFinanceProperty_OrderFinance()
           LEFT JOIN Object AS Object_OrderFinance ON Object_OrderFinance.Id = OrderFinanceProperty_OrderFinance.ChildObjectId

           LEFT JOIN tmpObject ON tmpObject.OrderFinancePropertyId = Object_OrderFinanceProperty.Id
                               
           LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpObject.InfoMoneyId
           LEFT JOIN Object AS Object_InfoMoneyDestination ON Object_InfoMoneyDestination.Id = tmpObject.InfoMoneyDestinationId
           LEFT JOIN Object AS Object_InfoMoneyGroup ON Object_InfoMoneyGroup.Id = tmpObject.InfoMoneyGroupId

       WHERE Object_OrderFinanceProperty.DescId = zc_Object_OrderFinanceProperty()
         AND (Object_OrderFinanceProperty.isErased = FALSE OR inisErased = TRUE);
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.11.20         * add inisErased
 29.07.19         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_OrderFinanceProperty (TRUE,'2')