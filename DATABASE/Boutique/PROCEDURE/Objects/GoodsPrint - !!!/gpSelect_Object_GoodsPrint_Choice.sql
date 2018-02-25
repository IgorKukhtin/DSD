-- Function: gpSelect_Object_GoodsPrint_Choice (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsPrint_Choice (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsPrint_Choice(
    IN inUserId      Integer,       --  Пользователь сессии GoodsPrint
    IN inSession     TVarChar       --  сессия пользователя
)
RETURNS TABLE (Ord                  Integer
             , Amount               TFloat
             , Name                 TVarChar
             , UserId               Integer
             , UserName             TVarChar
             , UnitId               Integer
             , UnitName             TVarChar
             , InsertDate           TDateTime
             , isReprice            Boolean
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
             ROW_NUMBER() OVER (PARTITION BY Object_GoodsPrint.UserId ORDER BY Object_GoodsPrint.InsertDate ASC) :: Integer AS Ord
           , SUM (Object_GoodsPrint.Amount) :: TFloat AS Amount
           , ('Кол-во: <' || (SUM (Object_GoodsPrint.Amount) :: Integer) :: TVarChar || '>'
                   ||' <' || COALESCE (Object_Unit.ValueData, '???') || '>'
                   ||' <' || zfConvert_DateTimeToString (Object_GoodsPrint.InsertDate) || '>'
                   ||' <' || Object_User.ValueData || '>'
              ) :: TVarChar AS Name
           , Object_GoodsPrint.UserId      AS UserId
           , Object_User.ValueData         AS UserName
           , Object_GoodsPrint.UnitId      AS UnitId
           , Object_Unit.ValueData         AS UnitName
           , Object_GoodsPrint.InsertDate  AS InsertDate
           , Object_GoodsPrint.isReprice   AS isReprice

       FROM Object_GoodsPrint
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Object_GoodsPrint.UnitId
            LEFT JOIN Object AS Object_User ON Object_User.Id = Object_GoodsPrint.UserId
       WHERE Object_GoodsPrint.UserId = inUserId OR inUserId = 0
       GROUP BY Object_GoodsPrint.InsertDate
              , Object_GoodsPrint.UserId
              , Object_User.ValueData
              , Object_GoodsPrint.UnitId
              , Object_Unit.ValueData
              , Object_GoodsPrint.isReprice
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
