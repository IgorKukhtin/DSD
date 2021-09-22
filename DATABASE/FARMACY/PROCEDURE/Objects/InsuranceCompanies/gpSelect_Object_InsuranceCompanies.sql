-- Function: gpSelect_Object_InsuranceCompanies()

DROP FUNCTION IF EXISTS gpSelect_Object_InsuranceCompanies(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_InsuranceCompanies(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , isErased boolean
             ) AS
$BODY$BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_InsuranceCompanies());

     RETURN QUERY  
       SELECT 
             Object_InsuranceCompanies.Id          AS Id
           , Object_InsuranceCompanies.ObjectCode  AS Code
           , Object_InsuranceCompanies.ValueData   AS Name
           
           , Object_Juridical.Id               AS JuridicalId
           , Object_Juridical.ObjectCode       AS JuridicalCode
           , Object_Juridical.ValueData        AS JuridicalName

           , Object_InsuranceCompanies.isErased AS isErased
           
       FROM Object AS Object_InsuranceCompanies
   
           LEFT JOIN ObjectLink AS ObjectLink_InsuranceCompanies_Juridical 
                                ON ObjectLink_InsuranceCompanies_Juridical.ObjectId = Object_InsuranceCompanies.Id 
                               AND ObjectLink_InsuranceCompanies_Juridical.DescId = zc_ObjectLink_InsuranceCompanies_Juridical()
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_InsuranceCompanies_Juridical.ChildObjectId              

     WHERE Object_InsuranceCompanies.DescId = zc_Object_InsuranceCompanies();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_InsuranceCompanies(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.09.21                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Object_InsuranceCompanies('3')