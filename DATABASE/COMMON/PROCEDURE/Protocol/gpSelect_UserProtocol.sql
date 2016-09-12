-- Function: gpSelect_Protocol()

DROP FUNCTION IF EXISTS gpSelect_UserProtocol (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_UserProtocol(
    IN inStartDate     TDateTime , -- 
    IN inEndDate       TDateTime , --
    IN inUserId        Integer,    -- пользователь  
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime, ProtocolData TBlob, UserName TVarChar
             , MemberName TVarChar
             , BranchCode Integer
             , BranchName TVarChar
             , UnitCode Integer
             , UnitName TVarChar
             , PositionName TVarChar)
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

  RETURN QUERY 
   WITH tmpPersonal AS (SELECT View_Personal.MemberId
                             , MAX (View_Personal.UnitId) AS UnitId
                             , MAX (View_Personal.PositionId) AS PositionId
                        FROM Object_Personal_View AS View_Personal
                        WHERE View_Personal.isErased = FALSE
                        GROUP BY View_Personal.MemberId
                       )

  SELECT UserProtocol.OperDate
       , UserProtocol.ProtocolData
       , Object_User.ValueData     AS UserName

       , Object_Member.ValueData   AS MemberName
       , Object_Branch.ObjectCode  AS BranchCode
       , Object_Branch.ValueData   AS BranchName
       , Object_Unit.ObjectCode    AS UnitCode
       , Object_Unit.ValueData     AS UnitName
       , Object_Position.ValueData AS PositionName
  FROM UserProtocol 
        JOIN Object AS Object_User ON Object_User.Id = UserProtocol.UserId

        LEFT JOIN ObjectLink AS ObjectLink_User_Member
                             ON ObjectLink_User_Member.ObjectId = Object_User.Id
                            AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
        LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

        LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
        LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId
        LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                             ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
        LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId

 WHERE UserProtocol.OperDate BETWEEN inStartDate AND inEndDate
   AND (UserProtocol.UserId = inUserId OR 0 = inUserId);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_UserProtocol (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.09.16         * 
 04.11.13                        *  add inObjectId
 01.11.13                        * 
*/

-- тест
-- SELECT * FROM gpSelect_UserProtocol (inStartDate:= '01.01.2013', inEndDate:= '01.02.2013', inFuelId:= null, inCarId:= null, inSession:= '2'); 
