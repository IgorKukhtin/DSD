-- Function: gpSelect_Object_JuridicalCorporate()

DROP FUNCTION IF EXISTS gpSelect_Object_JuridicalCorporate(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_JuridicalCorporate(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               RetailId Integer, RetailName TVarChar,
               isCorporate boolean,
               isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Juridical());

   RETURN QUERY 
       SELECT 
             Object_Juridical.Id           AS Id
           , Object_Juridical.ObjectCode   AS Code
           , Object_Juridical.ValueData    AS Name
         
           , Object_Retail.Id  AS RetailId
           , Object_Retail.ValueData  AS RetailName 

           , ObjectBoolean_isCorporate.ValueData AS isCorporate
           
           , Object_Juridical.isErased           AS isErased
           
       FROM Object AS Object_Juridical
           LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
           LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

           LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate 
                                   ON ObjectBoolean_isCorporate.ObjectId = Object_Juridical.Id
                                  AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
       WHERE Object_Juridical.DescId = zc_Object_Juridical() 
         AND ObjectBoolean_isCorporate.ValueData = TRUE;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_JuridicalCorporate(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.07.14         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_JuridicalCorporate ('2')