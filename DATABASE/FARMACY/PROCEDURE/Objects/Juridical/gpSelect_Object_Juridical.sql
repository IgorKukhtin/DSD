-- Function: gpSelect_Object_Juridical()

DROP FUNCTION IF EXISTS gpSelect_Object_Juridical(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Juridical(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, OKPO TVarChar,
               RetailId Integer, RetailName TVarChar,
               isCorporate boolean,
               Percent TFloat, PayOrder TFloat,
               isLoadBarcode Boolean,
               isDeferred Boolean,
               isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Juridical());

   RETURN QUERY 
       SELECT 
             Object_Juridical.Id                 AS Id
           , Object_Juridical.ObjectCode         AS Code
           , Object_Juridical.ValueData          AS Name
           , ObjectHistory_JuridicalDetails_View.OKPO

           , Object_Retail.Id                    AS RetailId
           , Object_Retail.ValueData             AS RetailName 

           , ObjectBoolean_isCorporate.ValueData AS isCorporate
           , ObjectFloat_Percent.ValueData       AS Percent
           , ObjectFloat_PayOrder.ValueData      AS PayOrder
           
           , COALESCE (ObjectBoolean_LoadBarcode.ValueData, FALSE)     AS isLoadBarcode
           , COALESCE (ObjectBoolean_Deferred.ValueData, FALSE)        AS isDeferred

           , Object_Juridical.isErased           AS isErased
           
       FROM Object AS Object_Juridical

           LEFT JOIN ObjectFloat AS ObjectFloat_Percent
                                 ON ObjectFloat_Percent.ObjectId = Object_Juridical.Id
                                AND ObjectFloat_Percent.DescId = zc_ObjectFloat_Juridical_Percent()

           LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
           LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

           LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate 
                                   ON ObjectBoolean_isCorporate.ObjectId = Object_Juridical.Id
                                  AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
           LEFT JOIN ObjectFloat AS ObjectFloat_PayOrder
                                   ON ObjectFloat_PayOrder.ObjectId = Object_Juridical.Id
                                  AND ObjectFloat_PayOrder.DescId = zc_ObjectFloat_Juridical_PayOrder()
           LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id

           LEFT JOIN ObjectBoolean AS ObjectBoolean_LoadBarcode 
                                   ON ObjectBoolean_LoadBarcode.ObjectId = Object_Juridical.Id
                                  AND ObjectBoolean_LoadBarcode.DescId = zc_ObjectBoolean_Juridical_LoadBarcode()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_Deferred
                                   ON ObjectBoolean_Deferred.ObjectId = Object_Juridical.Id
                                  AND ObjectBoolean_Deferred.DescId = zc_ObjectBoolean_Juridical_Deferred()
       WHERE Object_Juridical.DescId = zc_Object_Juridical();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Juridical(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.  Ярошенко Р.Ф.
 22.02.18         * dell OrderSumm, OrderSummComment, OrderTime
 17.08.17         * add isDeferred
 27.06.17                                                                        * isLoadBarcode
 14.01.17         * 
 02.12.15                                                         * PayOrder
 01.07.14         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_Juridical ('2')