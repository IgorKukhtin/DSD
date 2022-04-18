-- Function: gpGet_Object_MarginCategoryItem (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_MarginCategoryItem (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MarginCategoryItem(
    IN inId                Integer,        -- Должности
    IN inMarginCategoryId  Integer,        -- Должности
    IN inSession           TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , MarginCategoryId Integer, MarginCategoryCode Integer, MarginCategoryName TVarChar
             , MinPrice TFloat, MarginPercent TFloat
             , isErased Boolean) 
AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_MarginCategory());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 AS Integer)                 AS Id
           , CAST (0 AS Integer)                 AS Code
           , CAST ('' AS TVarChar)               AS NAME
           , Object_MarginCategory.Id            AS MarginCategoryId
           , Object_MarginCategory.ObjectCode    AS MarginCategoryCode
           , Object_MarginCategory.ValueData     AS MarginCategoryName
           , 0::TFloat                           AS MinPrice
           , 0::TFloat                           AS MarginPercent
           , False                               AS isErased
       FROM Object AS Object_MarginCategory
       WHERE Object_MarginCategory.Id = inMarginCategoryId
       ;
   ELSE
       RETURN QUERY 
       SELECT Object_MarginCategoryItem.Id                            AS Id
            , Object_MarginCategoryItem.ObjectCode                    AS Code
            , Object_MarginCategoryItem.ValueData                     AS Name
            , Object_MarginCategory.Id                                AS MarginCategoryId
            , Object_MarginCategory.ObjectCode                        AS MarginCategoryCode
            , Object_MarginCategory.ValueData                         AS MarginCategoryName
            , ObjectFloat_MarginCategoryItem_MinPrice.ValueData       AS MinPrice
            , ObjectFloat_MarginCategory_MarginPercent.ValueData      AS MarginPercent
            , Object_MarginCategoryItem.isErased                      AS isErased
       FROM Object AS Object_MarginCategoryItem

            LEFT JOIN ObjectLink AS ObjectLink_MarginCategory
                                 ON ObjectLink_MarginCategory.ObjectId = Object_MarginCategoryItem.Id
                                AND ObjectLink_MarginCategory.DescId = zc_ObjectLink_MarginCategoryItem_MarginCategory()
            LEFT JOIN Object AS Object_MarginCategory ON Object_MarginCategory.Id = ObjectLink_MarginCategory.ChildObjectId   

            LEFT JOIN ObjectFloat AS ObjectFloat_MarginCategoryItem_MinPrice
                                  ON ObjectFloat_MarginCategoryItem_MinPrice.ObjectId = Object_MarginCategoryItem.Id 
                                 AND ObjectFloat_MarginCategoryItem_MinPrice.DescId = zc_ObjectFloat_MarginCategoryItem_MinPrice() 
            LEFT JOIN ObjectFloat AS ObjectFloat_MarginCategory_MarginPercent
                                  ON ObjectFloat_MarginCategory_MarginPercent.ObjectId = Object_MarginCategoryItem.Id 
                                 AND ObjectFloat_MarginCategory_MarginPercent.DescId = zc_ObjectFloat_MarginCategoryItem_MarginPercent() 

       WHERE Object_MarginCategoryItem.Id = inId;
   END IF;
   
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.11.19         * 
*/

-- тест
-- 
select * from gpGet_Object_MarginCategoryItem(inId := 10542480 , inMarginCategoryId := 10542373 ,  inSession := '3');