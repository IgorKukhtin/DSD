-- Function: gpSelect_Object_Juridical()

--DROP FUNCTION gpSelect_Object_Juridical(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Juridical(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, JuridicalGroupName TVarChar, Name TVarChar, isErased BOOLEAN, JuridicalGroupId Integer) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT 
         Object_JuridicalGroup.Id         AS Id 
       , Object_JuridicalGroup.ObjectCode AS Code
       , Object_JuridicalGroup.ValueData  AS JuridicalGroupName
       , CAST ('' AS TVarChar)            AS Name
       , Object_JuridicalGroup.isErased   AS isErased
       , ObjectLink_JuridicalGroup_Parent.ChildObjectId AS JuridicalGroupId
   FROM Object AS Object_JuridicalGroup
        LEFT JOIN ObjectLink AS ObjectLink_JuridicalGroup_Parent
                 ON ObjectLink_JuridicalGroup_Parent.ObjectId = Object_JuridicalGroup.Id
                AND ObjectLink_JuridicalGroup_Parent.DescId = zc_ObjectLink_JuridicalGroup_Parent()
   WHERE Object_JuridicalGroup.DescId = zc_Object_JuridicalGroup()
  UNION
   SELECT 
         Object_Juridical.Id             AS Id 
       , Object_Juridical.ObjectCode     AS Code
       , CAST ('' AS TVarChar)           AS JuridicalGroupName
       , Object_Juridical.ValueData      AS Name
       , Object_Juridical.isErased       AS isErased
       , ObjectLink_Juridical_JuridicalGroup.ChildObjectId AS JuridicalGroupId
   FROM Object AS Object_Juridical
        LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                 ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id 
                AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
   WHERE Object_Juridical.DescId = zc_Object_Juridical();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Juridical (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.05.13                                        *

*/

-- тест
-- SELECT * FROM gpSelect_Object_Juridical('2')
