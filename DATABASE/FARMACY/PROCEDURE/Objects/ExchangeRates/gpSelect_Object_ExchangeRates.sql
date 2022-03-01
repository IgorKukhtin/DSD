-- Function: gpSelect_Object_ExchangeRates()

DROP FUNCTION IF EXISTS gpSelect_Object_ExchangeRates(boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ExchangeRates(
    IN inisShowAll   boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , OperDate TDateTime, Exchange TFloat, PercentСhange TFloat, Ord Integer
             , isErased boolean) AS
$BODY$
  DECLARE vbUserId      Integer;
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Area()());
  vbUserId:= lpGetUserBySession (inSession);

   RETURN QUERY 
   WITH tmpExchangeRates AS (SELECT Object_ExchangeRates.Id                             AS Id 
                                  , Object_ExchangeRates.ObjectCode                     AS Code
                                  , Object_ExchangeRates.ValueData                      AS Name
                                  , ObjectDate_ExchangeRates_OperDate.ValueData         AS OperDate 
                                  , ObjectFloat_ExchangeRates_Exchange.ValueData        AS Exchange
                                  , (ROW_NUMBER() OVER (ORDER BY ObjectDate_ExchangeRates_OperDate.ValueData DESC))::Integer AS Ord
                                  , Object_ExchangeRates.isErased                       AS isErased
                             FROM Object AS Object_ExchangeRates

                                  LEFT JOIN ObjectDate AS ObjectDate_ExchangeRates_OperDate
                                                       ON ObjectDate_ExchangeRates_OperDate.ObjectId = Object_ExchangeRates.Id
                                                      AND ObjectDate_ExchangeRates_OperDate.DescId = zc_ObjectDate_ExchangeRates_OperDate()

                                  LEFT JOIN ObjectFloat AS ObjectFloat_ExchangeRates_Exchange
                                                        ON ObjectFloat_ExchangeRates_Exchange.ObjectId = Object_ExchangeRates.Id
                                                       AND ObjectFloat_ExchangeRates_Exchange.DescId = zc_ObjectFloat_ExchangeRates_Exchange()

                             WHERE Object_ExchangeRates.DescId = zc_Object_ExchangeRates()
                               AND (Object_ExchangeRates.isErased = False OR inisShowAll = True))
 
    SELECT Object_ExchangeRates.Id 
         , Object_ExchangeRates.Code
         , Object_ExchangeRates.Name
         , Object_ExchangeRates.OperDate 
         , Object_ExchangeRates.Exchange
         , CASE WHEN COALESCE (ExchangeRatesPrev.Exchange, 0) > 0 
                THEN Object_ExchangeRates.Exchange * 100 / ExchangeRatesPrev.Exchange - 100.0
                ELSE 0 END ::TFloat                          AS PercentСhange
         , Object_ExchangeRates.Ord
         , Object_ExchangeRates.isErased
    FROM tmpExchangeRates AS Object_ExchangeRates
    
         LEFT JOIN tmpExchangeRates AS ExchangeRatesPrev
                                    ON ExchangeRatesPrev.Ord = Object_ExchangeRates.Ord + 1
    
    ORDER BY Object_ExchangeRates.OperDate DESC
    ;  
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ExchangeRates(boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 24.02.22                                                       *
*/

-- тест
-- 

select * from gpSelect_Object_ExchangeRates(inisShowAll := 'True' ,  inSession := '3');