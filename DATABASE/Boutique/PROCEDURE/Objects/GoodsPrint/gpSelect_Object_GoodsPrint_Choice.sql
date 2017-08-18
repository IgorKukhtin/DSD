-- Function: gpSelect_Object_GoodsPrint_Choice (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsPrint_Choice (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsPrint_Choice(
    IN inUserId      Integer,       --  пользовать 
    IN inSession     TVarChar       --  сессия пользователя
)
RETURNS TABLE (Id                   Integer
             , Name                 TVarChar
             , UserId               Integer
             , UserName             TVarChar
             , InsertDate           TDateTime
 ) 
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsPrint());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY 
       SELECT 
             ROW_NUMBER() OVER( PARTITION BY Object_User.Id ORDER BY Object_GoodsPrint.InsertDate)  :: integer  AS Id
           , (Object_User.ValueData||' '||Object_GoodsPrint.InsertDate)                             :: TVarChar AS Name
           , Object_User.Id                 AS UserId
           , Object_User.ValueData          AS UserName 
           , Object_GoodsPrint.InsertDate   AS InsertDate
           
                      
       FROM Object_GoodsPrint
            LEFT JOIN Object AS Object_User ON Object_User.Id        = Object_GoodsPrint.UserId 
       WHERE Object_GoodsPrint.UserId = inUserId OR inUserId = 0
       GROUP BY Object_User.Id      
              , Object_GoodsPrint.InsertDate 
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятыкин А.А.
17.08.17          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsPrint_Choice (0, zfCalc_UserAdmin())