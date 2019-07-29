-- Function: gpSelect_Object_OrderFinanceProperty()

DROP FUNCTION IF EXISTS gpSelect_Object_OrderFinanceProperty(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_OrderFinanceProperty(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , OrderFinanceId Integer, OrderFinanceCode Integer, OrderFinanceName TVarChar
             , ObjectId Integer, ObjectCode Integer, ObjectName TVarChar
             , DescName TVarChar
             , isErased Boolean
             ) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_OrderFinanceProperty());

   RETURN QUERY 
       SELECT Object_OrderFinanceProperty.Id   AS Id

            , Object_OrderFinance.Id           AS OrderFinanceId
            , Object_OrderFinance.ObjectCode   AS OrderFinanceCode
            , Object_OrderFinance.ValueData    AS OrderFinanceName

            , Object_InfoMoney.Id              AS ObjectId
            , Object_InfoMoney.ObjectCode      AS ObjectCode
            , Object_InfoMoney.ValueData       AS ObjectName
            , Object_ObjectDesc.ItemName       AS DescName
            
            , Object_OrderFinanceProperty.isErased AS isErased

       FROM Object AS Object_OrderFinanceProperty
           LEFT JOIN ObjectLink AS OrderFinanceProperty_OrderFinance
                                ON OrderFinanceProperty_OrderFinance.ObjectId = Object_OrderFinanceProperty.Id
                               AND OrderFinanceProperty_OrderFinance.DescId = zc_ObjectLink_OrderFinanceProperty_OrderFinance()
           LEFT JOIN Object AS Object_OrderFinance ON Object_OrderFinance.Id = OrderFinanceProperty_OrderFinance.ChildObjectId

           LEFT JOIN ObjectLink AS OrderFinanceProperty_Object
                                ON OrderFinanceProperty_Object.ObjectId = Object_OrderFinanceProperty.Id
                               AND OrderFinanceProperty_Object.DescId = zc_ObjectLink_OrderFinanceProperty_Object()
           LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = OrderFinanceProperty_InfoMoney.ChildObjectId
           LEFT JOIN ObjectDesc AS Object_ObjectDesc ON Object_ObjectDesc.Id = Object_InfoMoney.DescId

       WHERE Object_OrderFinanceProperty.DescId = zc_Object_OrderFinanceProperty();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.07.19         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_OrderFinanceProperty ('2')