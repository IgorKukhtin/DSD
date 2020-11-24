-- Function: gpSelect_Object_PriceList (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_PriceList (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PriceList(
    IN inShowAll        Boolean,   
    IN inSession        TVarChar         -- сессия пользователя
)
  RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, PriceWithVAT Boolean, CurrencyId Integer, CurrencyName TVarChar, isErased Boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PriceList());

     RETURN QUERY 
       WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)
     
       SELECT 
             Object_PriceList.Id                  AS Id
           , Object_PriceList.ObjectCode          AS Code
           , Object_PriceList.ValueData           AS Name
           , ObjectBoolean_PriceWithVAT.ValueData AS PriceWithVAT
           , Object_Currency.Id                   AS CurrencyId
           , Object_Currency.ValueData            AS CurrencyName
           , Object_PriceList.isErased            AS isErased
       FROM Object AS Object_PriceList
            JOIN tmpIsErased on tmpIsErased.isErased= Object_PriceList.isErased
            LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceWithVAT
                                    ON ObjectBoolean_PriceWithVAT.ObjectId = Object_PriceList.Id
                                   AND ObjectBoolean_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()
            LEFT JOIN ObjectLink AS ObjectLink_Currency
                                 ON ObjectLink_Currency.ObjectId = Object_PriceList.Id
                                AND ObjectLink_Currency.DescId = zc_ObjectLink_PriceList_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_Currency.ChildObjectId
       WHERE Object_PriceList.DescId = zc_Object_PriceList()
      UNION ALL
       SELECT 
             0 AS Id
           , NULL :: Integer AS Code
           , 'УДАЛИТЬ' :: TVarChar AS Name
           , FALSE AS PriceWithVAT
           , 0 AS CurrencyId
           , '' :: TVarChar AS CurrencyName
           , FALSE  AS isErased
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_PriceList (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 24.11.20         *
 23.02.15         * add inShowAll
 16.11.14                                        * add Currency...
 07.09.13                                        * add PriceWithVAT and VATPercent
*/

-- тест
-- SELECT * FROM gpSelect_Object_PriceList ( false , '5')
