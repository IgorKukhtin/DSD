-- Function: gpSelect_Object_Cash()

DROP FUNCTION IF EXISTS gpSelect_Object_Cash (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Cash(
    IN inIsShowAll   Boolean,            -- признак показать удаленные да / нет 
    IN inSession     TVarChar            -- сессия пользователя
   
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , CurrencyId Integer, CurrencyName TVarChar
             , isErased boolean)
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Cash());


   -- результат
   RETURN QUERY
      SELECT
             Object_Cash.Id               AS Id
           , Object_Cash.ObjectCode       AS Code
           , Object_Cash.ValueData        AS Name
           , Object_Currency.Id           AS CurrencyId
           , Object_Currency.ValueData    AS CurrencyName
           , Object_Cash.isErased         AS isErased
       FROM Object As Object_Cash
            LEFT JOIN ObjectLink AS ObjectLink_Cash_Currency
                                 ON ObjectLink_Cash_Currency.ObjectId = Object_Cash.Id
                                AND ObjectLink_Cash_Currency.DescId = zc_ObjectLink_Cash_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_Cash_Currency.ChildObjectId
       WHERE Object_Cash.DescId = zc_Object_Cash()
         AND (Object_Cash.isErased = FALSE OR inIsShowAll = TRUE)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.02.21         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Cash (inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())
