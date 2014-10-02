-- Function: gpSelect_Object_PersonalServiceList()

DROP FUNCTION IF EXISTS gpSelect_Object_PersonalServiceList(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PersonalServiceList(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , JuridicalId Integer, JuridicalName TVarChar 
             , isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PersonalServiceList()());

   RETURN QUERY 
       SELECT 
             Object_PersonalServiceList.Id         AS Id
           , Object_PersonalServiceList.ObjectCode AS Code
           , Object_PersonalServiceList.ValueData  AS NAME
           , Object_Juridical.Id                   AS JuridicalId
           , Object_Juridical.ValueData            AS JuridicalName
           , Object_PersonalServiceList.isErased   AS isErased
       FROM Object AS Object_PersonalServiceList
           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Juridical
                                ON ObjectLink_PersonalServiceList_Juridical.ObjectId = Object_PersonalServiceList.Id 
                               AND ObjectLink_PersonalServiceList_Juridical.DescId = zc_ObjectLink_PersonalServiceList_Juridical()
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_PersonalServiceList_Juridical.ChildObjectId
   WHERE Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_PersonalServiceList(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.09.14          * add Juridical
 12.09.14          *

*/

-- тест
-- SELECT * FROM gpSelect_Object_PersonalServiceList('2')