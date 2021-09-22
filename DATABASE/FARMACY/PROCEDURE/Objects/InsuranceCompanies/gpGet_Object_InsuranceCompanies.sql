-- Function: gpGet_Object_InsuranceCompanies()

DROP FUNCTION IF EXISTS gpGet_Object_InsuranceCompanies(Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_InsuranceCompanies(
    IN inId          Integer,       -- ключ объекта <>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , isErased boolean
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_InsuranceCompanies());

   IF COALESCE (inId, 0) = 0 
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_InsuranceCompanies()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST (0 as Integer)    AS JuridicalId
           , CAST (0 as Integer)    AS JuridicalCode
           , CAST ('' as TVarChar)  AS JuridicalName

           , CAST (NULL AS Boolean) AS isErased
;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_InsuranceCompanies.Id          AS Id
           , Object_InsuranceCompanies.ObjectCode  AS Code
           , Object_InsuranceCompanies.ValueData   AS Name
           
           , Object_Juridical.Id               AS JuridicalId
           , Object_Juridical.ObjectCode       AS JuridicalCode
           , Object_Juridical.ValueData        AS JuridicalName

           , Object_InsuranceCompanies.isErased    AS isErased
           
       FROM Object AS Object_InsuranceCompanies
       
           LEFT JOIN ObjectLink AS ObjectLink_InsuranceCompanies_Juridical 
                                ON ObjectLink_InsuranceCompanies_Juridical.ObjectId = Object_InsuranceCompanies.Id 
                               AND ObjectLink_InsuranceCompanies_Juridical.DescId = zc_ObjectLink_InsuranceCompanies_Juridical()
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_InsuranceCompanies_Juridical.ChildObjectId              

       WHERE Object_InsuranceCompanies.Id = inId;
      
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_InsuranceCompanies(integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.09.21                                                       *
*/

-- тест
-- 
SELECT * FROM gpGet_Object_InsuranceCompanies (0, '3')
