-- Function: gpSelect_Object_ImportSettings_Email (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ImportSettings_Email (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ImportSettings_Email(
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Host TVarChar, Port TVarChar, Mail TVarChar
             , UserName TVarChar, PasswordValue TVarChar, Directory TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Member());
   vbUserId:= lpGetUserBySession (inSession);


   -- Результат
   RETURN QUERY 
     SELECT 'pop.ua.fm'       :: TVarChar AS Host
          , '110'             :: TVarChar AS Port
          , ''                :: TVarChar AS Mail
          , 'Ashtu777@ua.fm'  :: TVarChar AS UserName
          , 'qsxqsxw1'        :: TVarChar AS PasswordValue
          , '\inbox'          :: TVarChar AS Directory
    ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.03.16                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ImportSettings_Email (zfCalc_UserAdmin()) order by 3
