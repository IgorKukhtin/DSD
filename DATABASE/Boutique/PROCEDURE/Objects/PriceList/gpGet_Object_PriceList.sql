-- Function: gpGet_Object_PriceList()

DROP FUNCTION IF EXISTS gpGet_Object_PriceList (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PriceList(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , CurrencyId Integer, CurrencyName TVarChar
) 
  AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PriceList());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer                              AS Id    
           , lfGet_ObjectCode(0, zc_Object_PriceList()) AS Code
           , '' :: TVarChar                             AS Name
           ,  0 :: Integer                              AS CurrencyId
           , '' :: TVarChar                             AS CurrencyName
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object_PriceList.Id              AS Id
           , Object_PriceList.ObjectCode      AS Code
           , Object_PriceList.ValueData       AS Name
           , Object_Currency.Id               AS CurrencyId
           , Object_Currency.ValueData        AS CurrencyName
       FROM Object AS Object_PriceList
            LEFT JOIN ObjectLink AS Object_PriceList_Currency
                                 ON Object_PriceList_Currency.ObjectId = Object_PriceList.Id
                                AND Object_PriceList_Currency.DescId = zc_ObjectLink_PriceList_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = Object_PriceList_Currency.ChildObjectId
       WHERE Object_PriceList.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
08.05.17                                                          *
28.04.17          *
*/

-- тест
-- SELECT * FROM gpSelect_PriceList (1,'2')