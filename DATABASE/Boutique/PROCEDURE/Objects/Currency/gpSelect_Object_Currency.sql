-- Function: gpSelect_Object_Currency()

DROP FUNCTION IF EXISTS gpSelect_Object_Currency (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Currency (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Currency(
    IN inIsShowAll   Boolean,            -- признак показать удаленные да / нет 
    IN inSession     TVarChar            -- сессия пользователя
   
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , IncomeKoeff TFloat
             , isErased boolean)
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Currency());


   -- результат
   RETURN QUERY
      SELECT Object_Currency.Id                 AS Id
           , Object_Currency.ObjectCode         AS Code
           , Object_Currency.ValueData          AS Name
           , ObjectFloat_IncomeKoeff.ValueData  AS IncomeKoeff
           , Object_Currency.isErased           AS isErased
       FROM Object AS Object_Currency
            LEFT JOIN ObjectFloat AS ObjectFloat_IncomeKoeff 
                                  ON ObjectFloat_IncomeKoeff.ObjectId = Object_Currency.Id 
                                 AND ObjectFloat_IncomeKoeff.DescId = zc_ObjectFloat_Currency_IncomeKoeff()
       WHERE Object_Currency.DescId = zc_Object_Currency()
         AND (Object_Currency.isErased = FALSE OR inIsShowAll = TRUE)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
24.04.18          *
02.03.17                                                         *
20.02.17                                                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Currency (inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())
