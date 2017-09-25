-- Function: gpSelect_Object_JuridicalArea()

DROP FUNCTION IF EXISTS gpSelect_Object_JuridicalArea(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_JuridicalArea(
    IN inJuridicalId Integer,       -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Comment TVarChar 
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , AreaId Integer, AreaCode Integer, AreaName TVarChar
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

     WHERE Object_JuridicalArea.DescId = zc_Object_JuridicalArea()
         ;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.09.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_JuridicalArea('2')