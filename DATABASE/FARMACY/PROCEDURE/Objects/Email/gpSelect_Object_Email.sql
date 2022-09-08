-- Function: gpSelect_Object_Email()

DROP FUNCTION IF EXISTS gpSelect_Object_Email (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Email(
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , EmailKindId Integer, EmailKindName TVarChar
             , ErrorTo TVarChar
             , AreaId Integer, AreaName TVarChar
             , isErased boolean
               ) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Email());

   RETURN QUERY 
   SELECT Object_Email.Id             AS Id
        , Object_Email.ObjectCode     AS Code
        , Object_Email.ValueData      AS Name
        , Object_EmailKind.Id         AS EmailKindId
        , Object_EmailKind.ValueData  AS EmailKindName
        , ObjectString_ErrorTo.ValueData  AS ErrorTo
        , Object_Area.Id              AS AreaId
        , Object_Area.ValueData       AS AreaName
        , Object_Email.isErased       AS isErased
   FROM Object AS Object_Email
      LEFT JOIN ObjectLink AS ObjectLink_EmailKind
                           ON ObjectLink_EmailKind.ObjectId = Object_Email.Id
                          AND ObjectLink_EmailKind.DescId = zc_ObjectLink_Email_EmailKind()
      LEFT JOIN Object AS Object_EmailKind ON Object_EmailKind.Id = ObjectLink_EmailKind.ChildObjectId

      LEFT JOIN ObjectString AS ObjectString_ErrorTo
                             ON ObjectString_ErrorTo.ObjectId = Object_Email.Id 
                            AND ObjectString_ErrorTo.DescId = zc_ObjectString_Email_ErrorTo()

      LEFT JOIN ObjectLink AS ObjectLink_Email_Area
                           ON ObjectLink_Email_Area.ObjectId = Object_Email.Id 
                          AND ObjectLink_Email_Area.DescId = zc_ObjectLink_Email_Area()
      LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Email_Area.ChildObjectId
        
   WHERE Object_Email.DescId = zc_Object_Email()
  ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.10.16         *
 27.06.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Email ('2')
