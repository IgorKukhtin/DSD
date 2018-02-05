-- Function: gpSelect_Object_JuridicalArea()

DROP FUNCTION IF EXISTS gpSelect_Object_JuridicalArea(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_JuridicalArea(
    IN inJuridicalId Integer,       -- 
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
$BODY$BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_JuridicalArea());

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
           
           , Object_JuridicalArea.isErased AS isErased
           
       FROM Object AS Object_JuridicalArea
            INNER JOIN ObjectLink AS ObjectLink_JuridicalArea_Juridical
                                  ON ObjectLink_JuridicalArea_Juridical.ObjectId = Object_JuridicalArea.Id 
                                 AND ObjectLink_JuridicalArea_Juridical.DescId = zc_ObjectLink_JuridicalArea_Juridical()
                                 AND (ObjectLink_JuridicalArea_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
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
     WHERE Object_JuridicalArea.DescId = zc_Object_JuridicalArea()
         ;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.02.18         *
 20.10.17         *
 25.09.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_JuridicalArea('2')