-- Function: gpReport_LoginProtocol (TDateTime, TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpReport_LoginProtocol (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_LoginProtocol(
    IN inStartDate   TDateTime , -- 
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (UserId Integer, UserCode Integer, UserName TVarChar
             , MemberId Integer, MemberName TVarChar
             , PositionName TVarChar
             , UnitName TVarChar
             , BranchName TVarChar
             , operDate TDateTime
             , ProtocolData TVarChar
             
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- Результат
   RETURN QUERY 
    WITH tmpPersonal AS (SELECT View_Personal.MemberId
                             , MAX (View_Personal.UnitId) AS UnitId
                             , MAX (View_Personal.PositionId) AS PositionId
                        FROM Object_Personal_View AS View_Personal
                        WHERE View_Personal.isErased = FALSE
                        GROUP BY View_Personal.MemberId
                       )

    SELECT Object_User.Id             AS UserId
         , Object_User.ObjectCode     AS UserCode
         , Object_User.ValueData      AS UserName
         , Object_Member.Id           AS MemberId 
         , Object_Member.ValueData    AS MemberName 
         , Object_Position.ValueData  AS PositionName 
         , Object_Unit.ValueData      AS UnitName
         , Object_Branch.ValueData    AS BranchName
         , LoginProtocol.operDate
         , LoginProtocol.ProtocolData :: TVarChar

    FROM LoginProtocol
        LEFT JOIN Object AS Object_User ON Object_User.Id = LoginProtocol.UserId
        LEFT JOIN ObjectLink AS ObjectLink_User_Member
                             ON ObjectLink_User_Member.ObjectId = LoginProtocol.UserId
                            AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
        LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

        LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
        LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId

        LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                             ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
        LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId

    WHERE LoginProtocol.operDate BETWEEN inStartDate AND inEndDate

;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_LoginProtocol (TDateTime, TDateTime, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.09.15         *
*/
-- тест
 --SELECT * FROM gpReport_LoginProtocol ('01.09.2015','01.10.2015','5')
