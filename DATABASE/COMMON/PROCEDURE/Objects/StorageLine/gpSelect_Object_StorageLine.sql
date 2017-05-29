-- Function: gpSelect_Object_StorageLine()

DROP FUNCTION IF EXISTS gpSelect_Object_StorageLine(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StorageLine(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , UnitId Integer, UnitName TVarChar
             , Comment TVarChar
             , isErased boolean
) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_StorageLine()());

   RETURN QUERY 
       SELECT Object_StorageLine.Id         AS Id 
            , Object_StorageLine.ObjectCode AS Code
            , Object_StorageLine.ValueData  AS Name

            , Object_Unit.Id            AS UnitId
            , Object_Unit.ValueData     AS UnitName

            , ObjectString_StorageLine_Comment.ValueData   AS Comment

            , Object_StorageLine.isErased   AS isErased

       FROM Object AS Object_StorageLine
            LEFT JOIN ObjectString AS ObjectString_StorageLine_Comment
                                   ON ObjectString_StorageLine_Comment.ObjectId = Object_StorageLine.Id 
                                  AND ObjectString_StorageLine_Comment.DescId = zc_ObjectString_StorageLine_Comment()
            LEFT JOIN ObjectLink AS ObjectLink_StorageLine_Unit
                                 ON ObjectLink_StorageLine_Unit.ObjectId = Object_StorageLine.Id 
                                AND ObjectLink_StorageLine_Unit.DescId = zc_ObjectLink_StorageLine_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_StorageLine_Unit.ChildObjectId
       WHERE Object_StorageLine.DescId = zc_Object_StorageLine()

      UNION ALL
       SELECT 0 AS Id
            , 0 AS Code
            , 'УДАЛИТЬ' :: TVarChar AS Name
            , 0         :: Integer  AS UnitId
            , ''        :: TVarChar AS UnitName
            , ''        :: TVarChar AS Comment
            , FALSE                 AS isErased
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.05.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_StorageLine (inSession:= zfCalc_UserAdmin())
