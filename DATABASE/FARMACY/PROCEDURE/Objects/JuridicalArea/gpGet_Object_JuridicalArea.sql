-- Function: gpGet_Object_JuridicalArea()

DROP FUNCTION IF EXISTS gpGet_Object_JuridicalArea(Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_JuridicalArea(
    IN inId          Integer,       -- ключ объекта <>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Comment TVarChar 
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , AreaId Integer, AreaCode Integer, AreaName TVarChar
             , Email TVarChar
             , isDefault Boolean
             , isGoodsCode Boolean
             , isOnly Boolean
             , isErased boolean
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_JuridicalArea());

   IF COALESCE (inId, 0) = 0 
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE (MAX (Object_JuridicalArea.ObjectCode), 0) + 1 AS Code
           , CAST ('' as TVarChar)  AS Comment
           
           , CAST (0 as Integer)    AS JuridicalId
           , CAST (0 as Integer)    AS JuridicalCode
           , CAST ('' as TVarChar)  AS JuridicalName
                                    
           , CAST (0 as Integer)    AS AreaId
           , CAST (0 as Integer)    AS AreaCode
           , CAST ('' as TVarChar)  AS AreaName

           , CAST ('' as TVarChar)  AS Email
           , FALSE     ::Boolean    AS isDefault
           , FALSE     ::Boolean    AS isGoodsCode
           , FALSE     ::Boolean    AS isOnly

           , CAST (NULL AS Boolean) AS isErased

       FROM Object AS Object_JuridicalArea
       WHERE Object_JuridicalArea.DescId = zc_Object_JuridicalArea();
   ELSE
       RETURN QUERY 
       SELECT 
             Object_JuridicalArea.Id          AS Id
           , Object_JuridicalArea.ObjectCode  AS Code
           , Object_JuridicalArea.ValueData   AS Comment
           
           , Object_Juridical.Id              AS JuridicalId
           , Object_Juridical.ObjectCode      AS JuridicalCode
           , Object_Juridical.ValueData       AS JuridicalName

           , Object_Area.Id                   AS AreaId
           , Object_Area.ObjectCode           AS AreaCode
           , Object_Area.ValueData            AS AreaName
           
           , ObjectString_JuridicalArea_Email.ValueData  AS Email
           , COALESCE (ObjectBoolean_JuridicalArea_Default.ValueData, FALSE)    AS isDefault
           , COALESCE (ObjectBoolean_JuridicalArea_GoodsCode.ValueData, FALSE)  AS isGoodsCode
           , COALESCE (ObjectBoolean_JuridicalArea_Only.ValueData, FALSE)       AS isOnly

           , Object_JuridicalArea.isErased    AS isErased
           
       FROM Object AS Object_JuridicalArea
       
           LEFT JOIN ObjectLink AS ObjectLink_JuridicalArea_Juridical
                                ON ObjectLink_JuridicalArea_Juridical.ObjectId = Object_JuridicalArea.Id 
                               AND ObjectLink_JuridicalArea_Juridical.DescId = zc_ObjectLink_JuridicalArea_Juridical()
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_JuridicalArea_Juridical.ChildObjectId       
           
           LEFT JOIN ObjectLink AS ObjectLink_JuridicalArea_Area
                                ON ObjectLink_JuridicalArea_Area.ObjectId = Object_JuridicalArea.Id 
                               AND ObjectLink_JuridicalArea_Area.DescId = zc_ObjectLink_JuridicalArea_Area()
           LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_JuridicalArea_Area.ChildObjectId        
   
           LEFT JOIN ObjectString AS ObjectString_JuridicalArea_Email
                                  ON ObjectString_JuridicalArea_Email.ObjectId = Object_JuridicalArea.Id 
                                 AND ObjectString_JuridicalArea_Email.DescId = zc_ObjectString_JuridicalArea_Email()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_JuridicalArea_Default
                                   ON ObjectBoolean_JuridicalArea_Default.ObjectId = Object_JuridicalArea.Id
                                  AND ObjectBoolean_JuridicalArea_Default.DescId = zc_ObjectBoolean_JuridicalArea_Default()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_JuridicalArea_GoodsCode
                                   ON ObjectBoolean_JuridicalArea_GoodsCode.ObjectId = Object_JuridicalArea.Id
                                  AND ObjectBoolean_JuridicalArea_GoodsCode.DescId = zc_ObjectBoolean_JuridicalArea_GoodsCode()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_JuridicalArea_Only
                                   ON ObjectBoolean_JuridicalArea_Only.ObjectId = Object_JuridicalArea.Id
                                  AND ObjectBoolean_JuridicalArea_Only.DescId = zc_ObjectBoolean_JuridicalArea_Only()
       WHERE Object_JuridicalArea.Id = inId;
      
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.02.18         *
 20.10.17         *
 25.09.17         *  
*/

-- тест
-- SELECT * FROM gpGet_Object_JuridicalArea (2, '')
