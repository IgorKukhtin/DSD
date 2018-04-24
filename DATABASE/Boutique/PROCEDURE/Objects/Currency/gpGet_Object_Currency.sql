-- Function: gpGet_Object_Currency()

DROP FUNCTION IF EXISTS gpGet_Object_Currency (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Currency(
    IN inId          Integer,       -- Currency
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , IncomeKoeff TFloat) 
AS
$BODY$
BEGIN
  -- проверка прав пользователя на вызов процедуры
  PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Object_Currency());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer    AS Id
           , lfGet_ObjectCode(0, zc_Object_Currency())   AS Code
           , '' :: TVarChar   AS Name
           ,  0 :: TFloat     AS IncomeKoeff 
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object_Currency.Id                AS Id
           , Object_Currency.ObjectCode        AS Code
           , Object_Currency.ValueData         AS Name
           , ObjectFloat_IncomeKoeff.ValueData AS IncomeKoeff
       FROM Object AS Object_Currency
            LEFT JOIN ObjectFloat AS ObjectFloat_IncomeKoeff 
                                  ON ObjectFloat_IncomeKoeff.ObjectId = Object_Currency.Id 
                                 AND ObjectFloat_IncomeKoeff.DescId = zc_ObjectFloat_Currency_IncomeKoeff()
       WHERE Object_Currency.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
24.04.18          *
08.05.17                                                          *
02.03.17                                                          *
20.02.17                                                          *
*/

-- тест
-- SELECT * FROM gpGet_Object_Currency (1, zfCalc_UserAdmin())
