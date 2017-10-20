-- Function: gpGet_Area_byUser()

DROP FUNCTION IF EXISTS gpGet_Area_byUser (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Area_byUser(
   OUT outAreaId       Integer  ,  -- Подразделение
   OUT outAreaName     TVarChar ,  -- Подразделение
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
     
     WITH tmpPersonal AS (SELECT View_Personal.MemberId
                               , MAX (View_Personal.UnitId) AS UnitId
                               , MAX (View_Personal.PositionId) AS PositionId
                          FROM Object_Personal_View AS View_Personal
                          WHERE View_Personal.isErased = FALSE
                          GROUP BY View_Personal.MemberId
                         )
  
     SELECT Object_Area.Id        AS AreaId
          , Object_Area.ValueData AS AreaName
         INTO outAreaId, outAreaName  
     FROM ObjectLink AS ObjectLink_User_Member
          LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
          LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                               ON ObjectLink_Unit_Area.ObjectId = tmpPersonal.UnitId
                              AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
          LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Unit_Area.ChildObjectId
     WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
       AND ObjectLink_User_Member.ObjectId = vbUserId; --3353661
     

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.10.17         *
*/

-- тест
-- SELECT * FROM gpGet_Area_byUser (inSession:= '3353661')
