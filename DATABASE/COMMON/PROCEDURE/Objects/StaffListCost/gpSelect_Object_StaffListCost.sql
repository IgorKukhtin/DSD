-- Function: gpSelect_Object_StaffListCost()

DROP FUNCTION IF EXISTS gpSelect_Object_StaffListCost(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StaffListCost(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Price TFloat
             , Comment TVarChar
             , StaffListId Integer
             , ModelServiceId Integer, ModelServiceName TVarChar                
             , isErased boolean
             ) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_StaffListCost());

   RETURN QUERY 
     SELECT 
           Object_StaffListCost.Id        AS Id
 
         , ObjectFloat_Price.ValueData     AS Price
         , ObjectString_Comment.ValueData  AS Comment
                                                        
         , Object_StaffList.Id            AS StaffListId
         
         , Object_ModelService.Id         AS ModelServiceId
         , Object_ModelService.ValueData  AS ModelServiceName

         , Object_StaffListCost.isErased  AS isErased
         
     FROM OBJECT AS Object_StaffListCost
          LEFT JOIN ObjectLink AS ObjectLink_StaffListCost_StaffList
                               ON ObjectLink_StaffListCost_StaffList.ObjectId = Object_StaffListCost.Id
                              AND ObjectLink_StaffListCost_StaffList.DescId = zc_ObjectLink_StaffListCost_StaffList()
          LEFT JOIN Object AS Object_StaffList ON Object_StaffList.Id = ObjectLink_StaffListCost_StaffList.ChildObjectId
 
          LEFT JOIN ObjectLink AS ObjectLink_StaffListCost_ModelService
                               ON ObjectLink_StaffListCost_ModelService.ObjectId = Object_StaffListCost.Id
                              AND ObjectLink_StaffListCost_ModelService.DescId = zc_ObjectLink_StaffListCost_ModelService()
          LEFT JOIN Object AS Object_ModelService ON Object_ModelService.Id = ObjectLink_StaffListCost_ModelService.ChildObjectId

          LEFT JOIN ObjectFloat AS ObjectFloat_Price 
                                ON ObjectFloat_Price.ObjectId = Object_StaffListCost.Id 
                               AND ObjectFloat_Price.DescId = zc_ObjectFloat_StaffListCost_Price()
          
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_StaffListCost.Id 
                                AND ObjectString_Comment.DescId = zc_ObjectString_StaffListCost_Comment()

     WHERE Object_StaffListCost.DescId = zc_Object_StaffListCost();
  
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Object_StaffListCost (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.11.13                                        * Cyr1251
 19.10.13         * 
*/

-- тест
-- SELECT * FROM gpSelect_Object_StaffListCost ('2')