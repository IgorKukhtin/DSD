-- Function: gpGet_Object_Fiscal (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_CreditLimitJuridical (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_CreditLimitJuridical(
    IN inId                     Integer,       -- ключ объекта <>
    IN inSession                TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , ProviderId Integer, ProviderName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , CreditLimit TFloat
             , isErased boolean
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_CreditLimitJuridical());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_CreditLimitJuridical()) AS Code
           
           , CAST (0 as Integer)    AS ProviderId
           , CAST ('' as TVarChar)  AS ProviderName

           , CAST (0 as Integer)    AS JuridicalId
           , CAST ('' as TVarChar)  AS JuridicalName

           , CAST (NULL AS TFloat) AS CreditLimit

           , CAST (NULL AS Boolean) AS isErased
           ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_CreditLimitJuridical.Id            AS Id
           , Object_CreditLimitJuridical.ObjectCode    AS Code
           
           , Object_Provider.Id                        AS ProviderId
           , Object_Provider.ValueData                 AS ProviderName 
           
           , Object_Juridical.Id                       AS JuridicalId
           , Object_Juridical.ValueData                AS JuridicalName 
           
           , ObjectFloat_CreditLimit.ValueData         AS CreditLimit 
           
           , Object_CreditLimitJuridical.isErased      AS isErased
           
       FROM Object AS Object_CreditLimitJuridical
       
          LEFT JOIN ObjectLink AS ObjectLink_CreditLimitJuridical_Provider
                               ON ObjectLink_CreditLimitJuridical_Provider.ObjectId = Object_CreditLimitJuridical.Id 
                              AND ObjectLink_CreditLimitJuridical_Provider.DescId = zc_ObjectLink_CreditLimitJuridical_Provider()
          LEFT JOIN Object AS Object_Provider ON Object_Provider.Id = ObjectLink_CreditLimitJuridical_Provider.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_CreditLimitJuridical_Juridical
                               ON ObjectLink_CreditLimitJuridical_Juridical.ObjectId = Object_CreditLimitJuridical.Id 
                              AND ObjectLink_CreditLimitJuridical_Juridical.DescId = zc_ObjectLink_CreditLimitJuridical_Juridical()
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_CreditLimitJuridical_Juridical.ChildObjectId
      
          LEFT JOIN ObjectFloat AS ObjectFloat_CreditLimit
                                 ON ObjectFloat_CreditLimit.ObjectId = Object_CreditLimitJuridical.Id 
                                AND ObjectFloat_CreditLimit.DescId = zc_ObjectFloat_CreditLimitJuridical_CreditLimit()

       WHERE Object_CreditLimitJuridical.Id = inId;
      
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.06.19                                                       *
*/

-- тест
-- SELECT * FROM gpGet_Object_CreditLimitJuridical (inId:=0, inSession := '5')
