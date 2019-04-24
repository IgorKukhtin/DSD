-- Function: gpGet_Object_RetailCostCredit()

DROP FUNCTION IF EXISTS gpGet_Object_RetailCostCredit(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_RetailCostCredit(
    IN inId          Integer,       -- Подразделение 
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS TABLE (Id Integer
             , RetailId Integer, RetailName TVarChar
             , MinPrice TFloat, Percent TFloat
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_RetailCostCredit());
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)   AS Id
          
           , CAST (0 as Integer)   AS RetailId
           , CAST ('' as TVarChar) AS RetailName 

           , CAST (NULL AS TFloat) AS MinPrice
           , CAST (NULL AS TFloat) AS Percent   
           ;
   
   ELSE
       RETURN QUERY 
       SELECT 
             Object_RetailCostCredit.Id           AS Id
         
           , Object_Retail.Id              AS RetailId
           , Object_Retail.ValueData       AS RetailName 

           , ObjectFloat_MinPrice.ValueData AS MinPrice
           , ObjectFloat_Percent.ValueData AS Percent
           
       FROM Object AS Object_RetailCostCredit
           LEFT JOIN ObjectFloat AS ObjectFloat_MinPrice
                                 ON ObjectFloat_MinPrice.ObjectId = Object_RetailCostCredit.Id
                                AND ObjectFloat_MinPrice.DescId = zc_ObjectFloat_RetailCostCredit_MinPrice()
           LEFT JOIN ObjectFloat AS ObjectFloat_Percent 
                                 ON ObjectFloat_Percent.ObjectId = Object_RetailCostCredit.Id
                                AND ObjectFloat_Percent.DescId = zc_ObjectFloat_RetailCostCredit_Percent()

           LEFT JOIN ObjectLink AS ObjectLink_RetailCostCredit_Retail
                                ON ObjectLink_RetailCostCredit_Retail.ObjectId = Object_RetailCostCredit.Id
                               AND ObjectLink_RetailCostCredit_Retail.DescId = zc_ObjectLink_RetailCostCredit_Retail()
           LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_RetailCostCredit_Retail.ChildObjectId
                                  
      WHERE Object_RetailCostCredit.Id = inId;
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.04.19         *
*/

-- тест
-- SELECT * FROM gpGet_Object_RetailCostCredit(0,'2')