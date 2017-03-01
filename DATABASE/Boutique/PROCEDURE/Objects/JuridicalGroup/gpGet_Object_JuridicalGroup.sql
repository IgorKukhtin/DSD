-- Function: gpGet_Object_JuridicalGroup()

DROP FUNCTION IF EXISTS gpGet_Object_JuridicalGroup (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_JuridicalGroup(
    IN inId          Integer,       -- Группы юридических лиц
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, JuridicalGroupId Integer, JuridicalGroupName TVarChar) 
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_JuridicalGroup());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE(MAX (Object.ObjectCode), 0) + 1 AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (0 as Integer)    AS JuridicalGroupId
           , CAST ('' as TVarChar)  AS JuridicalGroupName
       FROM Object
       WHERE Object.DescId = zc_Object_JuridicalGroup();
   ELSE
       RETURN QUERY
       SELECT 
             Object_JuridicalGroup.Id               AS Id
           , Object_JuridicalGroup.ObjectCode       AS Code
           , Object_JuridicalGroup.ValueData        AS Name    
           , Object_Parent.Id                       AS JuridicalGroupId
           , Object_Parent.ValueData                AS JuridicalGroupName
       FROM Object AS Object_JuridicalGroup
            LEFT JOIN ObjectLink AS ObjectLink_JuridicalGroup_Parent
                                 ON ObjectLink_JuridicalGroup_Parent.ObjectId = Object_JuridicalGroup.Id
                                AND ObjectLink_JuridicalGroup_Parent.DescId = zc_ObjectLink_JuridicalGroup_Parent()
            LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_JuridicalGroup_Parent.ChildObjectId

       WHERE Object_JuridicalGroup.Id = inId;




   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
27.02.17                                                          *
 
*/

-- тест
-- SELECT * FROM gpSelect_JuridicalGroup(1,'2')
