-- Function: gpSelect_Object_StaffListCost()

DROP FUNCTION IF EXISTS gpSelect_Object_StaffListCost(TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_StaffListCost(Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StaffListCost(
    IN inIsShowAll   Boolean,       --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Price TFloat
             , Comment TVarChar
             , StaffListId Integer
             , ModelServiceId Integer, ModelServiceName TVarChar                
             , isErased boolean 
             , UpdateName TVarChar, UpdateDate TDateTime
             ) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_StaffListCost());

   RETURN QUERY 
     WITH
     tmpObject AS (SELECT Object.*
                   FROM Object
                   WHERE Object.DescId = zc_Object_StaffListCost()  
                    AND (Object.isErased = FALSE OR inIsShowAll = TRUE)
                   )
      
   , tmpProtocol AS (SELECT tmp.ObjectId
                          , tmp.UserId
                          , Object_User.ValueData AS UserName
                          , tmp.OperDate
                     FROM (SELECT ObjectProtocol.*
                                  -- № п/п
                                , ROW_NUMBER() OVER (PARTITION BY ObjectProtocol.ObjectId ORDER BY ObjectProtocol.OperDate DESC) AS Ord
                           FROM ObjectProtocol
                           WHERE ObjectProtocol.ObjectId IN (SELECT tmpObject.Id FROM tmpObject)
                           ) AS tmp 
                           LEFT JOIN Object AS Object_User ON Object_User.Id = tmp.UserId  
                     WHERE tmp.Ord = 1
                     )

     SELECT 
           Object_StaffListCost.Id        AS Id
 
         , ObjectFloat_Price.ValueData     AS Price
         , ObjectString_Comment.ValueData  AS Comment
                                                        
         , Object_StaffList.Id            AS StaffListId
         
         , Object_ModelService.Id         AS ModelServiceId
         , Object_ModelService.ValueData  AS ModelServiceName

         , Object_StaffListCost.isErased  AS isErased

         , tmpProtocol.UserName    ::TVarChar  AS UpdateName
         , tmpProtocol.OperDate    ::TDateTime AS UpdateDate         
     FROM tmpObject AS Object_StaffListCost
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

          LEFT JOIN tmpProtocol ON tmpProtocol.ObjectId = Object_StaffListCost.Id
     ;
  
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_Object_StaffListCost (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.06.17         * add inIsShowAll
 22.11.13                                        * Cyr1251
 19.10.13         * 
*/

-- тест
-- SELECT * FROM gpSelect_Object_StaffListCost (False,'2')