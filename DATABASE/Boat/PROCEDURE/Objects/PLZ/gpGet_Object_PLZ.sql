-- Function: gpGet_Object_PLZ()

DROP FUNCTION IF EXISTS gpGet_Object_PLZ (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PLZ(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , CountryId Integer, CountryName TVarChar
             , City TVarChar, AreaCode TVarChar
             , Comment TVarChar) 
  AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PLZ());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer                          AS Id
           , lfGet_ObjectCode(0, zc_Object_PLZ())   AS Code
           , '' :: TVarChar                         AS Name
           , 0                                      AS CountryId
           , '' :: TVarChar                         AS CountryName
           , '' :: TVarChar                         AS City
           , '' :: TVarChar                         AS AreaCode
           , '' :: TVarChar                         AS Comment
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object_PLZ.Id              AS Id
           , Object_PLZ.ObjectCode      AS Code
           , Object_PLZ.ValueData       AS Name
           , Object_Country.Id          AS CountryId
           , Object_Country.ValueData   AS CountryName
           , OS_PLZ_City.ValueData      AS City
           , OS_PLZ_AreaCode.ValueData  AS AreaCode
           , OS_PLZ_Comment.ValueData   AS Comment

       FROM Object AS Object_PLZ
           LEFT JOIN ObjectString AS OS_PLZ_City
                                  ON OS_PLZ_City.ObjectId = Object_PLZ.Id
                                 AND OS_PLZ_City.DescId = zc_ObjectString_PLZ_City()       

           LEFT JOIN ObjectString AS OS_PLZ_AreaCode
                                  ON OS_PLZ_AreaCode.ObjectId = Object_PLZ.Id
                                 AND OS_PLZ_AreaCode.DescId = zc_ObjectString_PLZ_AreaCode()

           LEFT JOIN ObjectString AS OS_PLZ_Comment
                                  ON OS_PLZ_Comment.ObjectId = Object_PLZ.Id
                                 AND OS_PLZ_Comment.DescId = zc_ObjectString_PLZ_Comment()

           LEFT JOIN ObjectLink AS ObjectLink_Country
                                ON ObjectLink_Country.ObjectId = Object_PLZ.Id
                               AND ObjectLink_Country.DescId = zc_ObjectLink_PLZ_Country()
           LEFT JOIN Object AS Object_Country ON Object_Country.Id = ObjectLink_Country.ChildObjectId       
       WHERE Object_PLZ.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.11.20         *
*/

-- тест
-- SELECT * FROM gpSelect_PLZ (1,'2')
