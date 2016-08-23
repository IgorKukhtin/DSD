--Function: gpSelect_Object_MarginCategoryItem(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MarginCategoryItem(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MarginCategoryItem(
    IN inMarginCategoryId Integer,
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, MarginPercent TFloat, MinPrice TFloat
             , isSite Boolean
             , isErased boolean
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_MarginCategory());

   RETURN QUERY 
   SELECT 
         Object_MarginCategoryItem.Id            AS Id 
       , Object_MarginCategoryItem.MarginPercent AS MarginPercent
       , Object_MarginCategoryItem.MinPrice      AS MinPrice
      
       , COALESCE(ObjectBoolean_Site.ValueData, FALSE)   AS isSite
       , MarginCategoryItem.isErased          AS isErased

       , Object_Insert.ValueData              AS InsertName
       , ObjectDate_Protocol_Insert.ValueData AS InsertDate
       , Object_Update.ValueData              AS UpdateName
       , ObjectDate_Protocol_Update.ValueData AS UpdateDate

    FROM Object_MarginCategoryItem_View AS Object_MarginCategoryItem
          LEFT JOIN Object AS MarginCategoryItem ON MarginCategoryItem.Id = Object_MarginCategoryItem.Id
          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                               ON ObjectDate_Protocol_Insert.ObjectId = Object_MarginCategoryItem.Id
                              AND ObjectDate_Protocol_Insert.DescId = zc_ObjectDate_Protocol_Insert()
          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                               ON ObjectDate_Protocol_Update.ObjectId = Object_MarginCategoryItem.Id
                              AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_MarginCategoryItem.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId   

          LEFT JOIN ObjectLink AS ObjectLink_Update
                               ON ObjectLink_Update.ObjectId = Object_MarginCategoryItem.Id
                              AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
          LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId  
 
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Site 	
                                  ON ObjectBoolean_Site.ObjectId = inMarginCategoryId
                                 AND ObjectBoolean_Site.DescId = zc_ObjectBoolean_MarginCategory_Site() 

   WHERE Object_MarginCategoryItem.MarginCategoryId = inMarginCategoryId



;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_MarginCategoryItem(Integer, TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.04.16         *
 09.04.15                         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_MarginCategoryItem('2') 