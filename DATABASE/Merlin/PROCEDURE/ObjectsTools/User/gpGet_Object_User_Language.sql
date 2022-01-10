-- Function: gpGet_Object_User_Language()

DROP FUNCTION IF EXISTS gpGet_Object_User_Language (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_User_Language(
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (UserId       Integer
             , UserName     TVarChar
             , LanguageId   Integer
             , LanguageCode Integer
             , LanguageName TVarChar
             , isLock_CTRL_L_0 Boolean
              ) 
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbLanguageId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);
      
      -- Проверка
      IF COALESCE (vbUserId, 0) = 0
      THEN
          --RAISE EXCEPTION 'Ошибка.Не найден пользователь для сессии = <%>', inSession;
          RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Не найден пользователь для сессии = <%>' :: TVarChar
                                                , inProcedureName := 'gpGet_Object_User_Language' :: TVarChar
                                                , inUserId        := vbUserId
                                                , inParam1        := inSession :: TVarChar
                                                );
      END IF;

      vbLanguageId:= COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbUserId AND OL.DescId = zc_ObjectLink_User_Language())
                             , (WITH tmpList AS (SELECT Object.Id, ROW_NUMBER() OVER (ORDER BY Object.Id ASC) AS Ord FROM Object WHERE Object.DescId = zc_Object_Language() AND Object.isErased = FALSE)
                                SELECT tmpList.Id FROM tmpList WHERE tmpList.Ord = 1)
                              );

      -- Результат
      RETURN QUERY
      SELECT COALESCE (vbUserId, 0)                   :: Integer  AS UserId
           , lfGet_Object_ValueData_sh (vbUserId)     :: TVarChar AS UserName
           , vbLanguageId                             :: Integer  AS LanguageId
           , (SELECT Object.ObjectCode FROM Object WHERE Object.Id = vbLanguageId) AS LanguageCode
           , lfGet_Object_ValueData_sh (vbLanguageId) :: TVarChar AS LanguageName
           , FALSE                                                AS isLock_CTRL_L_0
      ; 
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.08.20                                         *
*/

-- тест
-- SELECT * FROM gpGet_Object_User_Language (zfCalc_UserAdmin())
