-- Function: gpReport_TestingUser (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpReport_TestingUser (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_TestingUser(
    IN inOperDate    TDateTime,     -- ‰‡Ú‡
    IN inSession     TVarChar       -- ÒÂÒÒËˇ ÔÓÎ¸ÁÓ‚‡ÚÂÎˇ
)
RETURNS TABLE (
         Id           Integer
       , Code         Integer
       , MemberName   TVarChar
       , UnitName     TVarChar
       , Result       TFloat
       , DateTimeTest TDateTime
)
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbDateStart TDateTime;
BEGIN

   vbDateStart := date_trunc('month', inOperDate);

   RETURN QUERY
   WITH tmpPersonal AS (SELECT View_Personal.MemberId
                             , MAX (View_Personal.UnitId) AS UnitId
                        FROM Object_Personal_View AS View_Personal
                        WHERE View_Personal.isErased = FALSE
                          AND View_Personal.PositionId = 1672498
                          AND vbDateStart >= date_trunc('month', CURRENT_TIMESTAMP::TDateTime)
                        GROUP BY View_Personal.MemberId
                       )

   SELECT
         Object_User.Id                             AS Id
       , Object_User.ObjectCode                     AS Code
       , Object_Member.ValueData                    AS MemberName
       , Object_Unit.ValueData                      AS UnitName
       , NULL::TFloat                               AS Result
       , NULL::TDateTime                            AS DateTimeTest 
   FROM Object AS Object_User

        INNER JOIN ObjectLink AS ObjectLink_User_Member
                             ON ObjectLink_User_Member.ObjectId = Object_User.Id
                            AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
        INNER JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

        INNER JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId

        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId
   WHERE Object_User.DescId = zc_Object_User()
   ORDER BY Object_Member.ValueData;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_TestingUser (TDateTime, TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ÿ‡·ÎËÈ Œ.¬.
 11.09.18         *
*/

-- ÚÂÒÚ
-- SELECT * FROM gpReport_TestingUser ('20180101', '3')