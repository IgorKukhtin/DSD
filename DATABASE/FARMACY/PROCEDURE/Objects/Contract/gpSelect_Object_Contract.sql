-- Function: gpSelect_Object_Contract()

DROP FUNCTION IF EXISTS gpSelect_Object_Contract(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Contract(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               JuridicalBasisId Integer, JuridicalBasisName TVarChar,
               JuridicalId Integer, JuridicalName TVarChar,
               Comment TVarChar,
               isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Contract());

   RETURN QUERY 
       SELECT 
             Object_Contract.Id           AS Id
           , Object_Contract.ObjectCode   AS Code
           , Object_Contract.ValueData    AS Name
         
           , Object_JuridicalBasis.Id         AS JuridicalBasisId
           , Object_JuridicalBasis.ValueData  AS JuridicalBasisName 
                     
           , Object_Juridical.Id         AS JuridicalId
           , Object_Juridical.ValueData  AS JuridicalName 

           , ObjectString_Comment.ValueData AS Comment
           
           , Object_Contract.isErased           AS isErased
           
       FROM Object AS Object_Contract
           LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                                ON ObjectLink_Contract_JuridicalBasis.ObjectId = Object_Contract.Id
                               AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
           LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = ObjectLink_Contract_JuridicalBasis.ChildObjectId
           
           LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                ON ObjectLink_Contract_Juridical.ObjectId = Object_Contract.Id
                               AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Contract_Juridical.ChildObjectId           

           LEFT JOIN ObjectString AS ObjectString_Comment 
                                  ON ObjectString_Comment.ObjectId = Object_Contract.Id
                                 AND ObjectString_Comment.DescId = zc_ObjectString_Contract_Comment()
       WHERE Object_Contract.DescId = zc_Object_Contract();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Contract(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.07.14         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_Contract ('2')