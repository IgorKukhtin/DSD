-- Function: lpGetUserBySession (TVarChar)

DROP FUNCTION IF EXISTS lpGetUnitBySession (TVarChar);

CREATE OR REPLACE FUNCTION lpGetUnitBySession (
    IN inSession TVarChar
)
RETURNS Integer
AS
$BODY$  
   DECLARE vbUserId Integer;
BEGIN
     
     vbUserId:= lpGetUserBySession (inSession);

     RETURN  COALESCE ((SELECT ObjectLink_User_Unit.ChildObjectId AS UnitId
                        FROM ObjectLink AS ObjectLink_User_Unit
                        WHERE ObjectLink_User_Unit.DescId = zc_ObjectLink_User_Unit()
                          AND ObjectLink_User_Unit.ObjectId = vbUserId)
                       , 0);

/*     RETURN  COALESCE ((SELECT tmpPersonal.UnitId
                        FROM ObjectLink AS ObjectLink_User_Member
                             LEFT JOIN (SELECT View_Personal.MemberId
                                           , MAX (View_Personal.UnitId) AS UnitId
                                      FROM Object_Personal_View AS View_Personal
                                      WHERE View_Personal.isErased = FALSE
                                      GROUP BY View_Personal.MemberId
                                     ) AS tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
                        WHERE ObjectLink_User_Member.ObjectId = vbUserId
                          AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()), 0);
*/
END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.03.18         * берем подразделение из свойства zc_ObjectLink_User_Unit
 19.08.17         *
*/

-- тест
-- SELECT * FROM lpGetUnitBySession (inSession:= zfCalc_UserAdmin())
