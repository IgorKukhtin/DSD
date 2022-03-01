-- Function: gpGet_Object_ExchangeRates()

DROP FUNCTION IF EXISTS gpGet_Object_ExchangeRates(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ExchangeRates(
    IN inId          Integer,       -- ключ объекта <Регионы>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , OperDate TDateTime, Exchange TFloat
             , isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT  
             CAST (0 as Integer)                            AS Id
           , lfGet_ObjectCode(0, zc_Object_ExchangeRates()) AS Code
           , CAST ('' as TVarChar)                          AS Name
           , CURRENT_DATE::TDateTime                        AS OperDate
           , CAST (0 AS TFloat)                             AS Exchange
           , CAST (FALSE AS Boolean)                        AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_ExchangeRates.Id                             AS Id 
            , Object_ExchangeRates.ObjectCode                     AS Code
            , Object_ExchangeRates.ValueData                      AS Name
            , ObjectDate_ExchangeRates_OperDate.ValueData         AS OperDate 
            , ObjectFloat_ExchangeRates_Exchange.ValueData        AS Exchange
            , Object_ExchangeRates.isErased                       AS isErased
       FROM Object AS Object_ExchangeRates

            LEFT JOIN ObjectDate AS ObjectDate_ExchangeRates_OperDate
                                 ON ObjectDate_ExchangeRates_OperDate.ObjectId = Object_ExchangeRates.Id
                                AND ObjectDate_ExchangeRates_OperDate.DescId = zc_ObjectDate_ExchangeRates_OperDate()

            LEFT JOIN ObjectFloat AS ObjectFloat_ExchangeRates_Exchange
                                  ON ObjectFloat_ExchangeRates_Exchange.ObjectId = Object_ExchangeRates.Id
                                 AND ObjectFloat_ExchangeRates_Exchange.DescId = zc_ObjectFloat_ExchangeRates_Exchange()

       WHERE Object_ExchangeRates.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_ExchangeRates(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 24.02.22                                                       *

*/

-- тест
-- SELECT * FROM gpGet_Object_ExchangeRates (0, '3')