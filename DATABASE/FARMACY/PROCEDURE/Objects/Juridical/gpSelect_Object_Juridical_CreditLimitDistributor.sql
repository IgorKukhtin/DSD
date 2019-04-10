-- Function: gpSelect_Object_CreditLimitDistributor()

DROP FUNCTION IF EXISTS gpSelect_Object_CreditLimitDistributor(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CreditLimitDistributor(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, 
               CreditLimit TFloat,
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

           , ObjectFloat_CreditLimit.ValueData   AS Percent

           , Object_Juridical.isErased           AS isErased
                      
       FROM Object AS Object_Juridical

           JOIN ObjectFloat AS ObjectFloat_CreditLimit
                                 ON ObjectFloat_CreditLimit.ObjectId = Object_Juridical.Id
                                AND ObjectFloat_CreditLimit.DescId = zc_ObjectFloat_Juridical_CreditLimit()

       WHERE Object_Juridical.DescId = zc_Object_Juridical();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 10.04.19                                                        *
*/

-- тест
--
 SELECT * FROM gpSelect_Object_CreditLimitDistributor('3')