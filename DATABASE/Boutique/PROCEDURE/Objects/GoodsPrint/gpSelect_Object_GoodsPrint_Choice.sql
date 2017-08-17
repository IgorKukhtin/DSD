-- Function: gpSelect_Object_GoodsPrint_Choice (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsPrint_Choice (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsPrint_Choice(
    IN inUserId      Integer,       --  пользовать 
    IN inSession     TVarChar       --  сессия пользователя
)
RETURNS TABLE (Id                   Integer
             , UnitId               Integer
             , UnitName             TVarChar
             , UserId               Integer
             , UserName             TVarChar
             , Amount               TFloat
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
       SELECT DISTINCT
             Object_GoodsPrint.Id           AS Id
           , Object_Unit.Id                 AS UnitId
           , Object_Unit.ValueData          AS UnitName
           , Object_User.Id                 AS UserId
           , Object_User.ValueData          AS UserName 
           , Object_GoodsPrint.Amount       AS Amount       
           , Object_GoodsPrint.InsertDate   AS InsertDate
                      
       FROM Object_GoodsPrint
            
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id        = Object_GoodsPrint.UnitId 
            LEFT JOIN Object AS Object_User ON Object_User.Id        = Object_GoodsPrint.UserId 
            
     WHERE Object_GoodsPrint.UserId = inUserId OR inUserId = 0
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