-- Function: gpSelect_Object_ModelServiceItemChild()

DROP FUNCTION IF EXISTS gpSelect_Object_ModelServiceItemChild(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ModelServiceItemChild(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Comment TVarChar
             , FromId Integer, FromName TVarChar                
             , ToId Integer, ToName TVarChar                
             , isErased boolean
             ) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ModelServiceItemChild());

   RETURN QUERY 
     SELECT 
           Object_ModelServiceItemChild.Id    AS Id
 
         , ObjectString_Comment.ValueData      AS Comment
                                                        
         , Object_From.Id          AS FromId
         , Object_From.ValueData   AS FromName

         , Object_To.Id         AS ToId
         , Object_To.ValueData  AS ToName

         , Object_ModelServiceItemChild.isErased AS isErased
         
     FROM OBJECT AS Object_ModelServiceItemChild
          LEFT JOIN ObjectLink AS ObjectLink_ModelServiceItemChild_From
                               ON ObjectLink_ModelServiceItemChild_From.ObjectId = Object_ModelServiceItemChild.Id
                              AND ObjectLink_ModelServiceItemChild_From.DescId = zc_ObjectLink_ModelServiceItemChild_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = ObjectLink_ModelServiceItemChild_From.ChildObjectId
 
          LEFT JOIN ObjectLink AS ObjectLink_ModelServiceItemChild_To
                               ON ObjectLink_ModelServiceItemChild_To.ObjectId = Object_ModelServiceItemChild.Id
                              AND ObjectLink_ModelServiceItemChild_To.DescId = zc_ObjectLink_ModelServiceItemChild_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = ObjectLink_ModelServiceItemChild_To.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ModelServiceItemChild.Id 
                                AND ObjectString_Comment.DescId = zc_ObjectString_ModelServiceItemChild_Comment()

     WHERE Object_ModelServiceItemChild.DescId = zc_Object_ModelServiceItemChild();
  
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Object_ModelServiceItemChild (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.10.13         * 
*/

-- тест
-- SELECT * FROM gpSelect_Object_ModelServiceItemChild ('2')