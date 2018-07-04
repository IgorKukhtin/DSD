-- Function: gpSelect_ReplObject(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_ReplObject (TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ReplObject(
    IN inSessionGUID  TVarChar,      -- 
    IN inStartId      Integer,       -- 
    IN inEndId        Integer,       -- 
    IN inDataBaseId   Integer,       -- для формирования "виртуального" GUID
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE Cur_Object        refcursor;
    DECLARE Cur_ObjectString  refcursor;
    DECLARE Cur_ObjectFloat   refcursor;
    DECLARE Cur_ObjectDate    refcursor;
    DECLARE Cur_ObjectBoolean refcursor;
    DECLARE Cur_ObjectLink    refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PaidKind());


     -- Результат

     -- 1. Object
     OPEN Cur_Object FOR
     WITH tmpPersonal AS (SELECT ObjectLink_User_Member.ObjectId AS UserId
                               , lfSelect.MemberId               AS MemberId
                               , Object_Member.ObjectCode        AS MemberCode
                               , Object_Member.ValueData         AS MemberName
                               , lfSelect.UnitId                 AS UnitId
                               , Object_Unit.ObjectCode          AS UnitCode
                               , Object_Unit.ValueData           AS UnitName
                               , lfSelect.PositionId             AS PositionId
                               , Object_Position.ObjectCode      AS PositionCode
                               , Object_Position.ValueData       AS PositionName
                               , Object_Branch.Id                AS BranchId
                               , Object_Branch.ObjectCode        AS BranchCode
                               , Object_Branch.ValueData         AS BranchName
                          FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = lfSelect.UnitId
                               LEFT JOIN Object AS Object_Position ON Object_Position.Id = lfSelect.PositionId
                               LEFT JOIN Object AS Object_Member ON Object_Member.Id = lfSelect.MemberId
                               LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                                    ON ObjectLink_User_Member.ChildObjectId = lfSelect.MemberId
                                                   AND ObjectLink_User_Member.DescId        = zc_ObjectLink_User_Member()
                               LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                                    ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                                                   AND ObjectLink_Unit_Branch.DescId   = zc_ObjectLink_Unit_Branch()
                               LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId
                         )
     SELECT
          ReplObject.OperDate_last                  AS OperDate_last
        , Object.Id                                 AS ObjectId
        , Object.DescId                             AS DescId
        , ObjectDesc.Code           :: VarChar (50) AS DescName
        , ObjectDesc.ItemName       :: VarChar (50) AS ItemName
        , Object.ObjectCode                         AS ObjectCode
        , Object.ValueData                          AS ValueData
        , Object.AccessKeyId                        AS AccessKeyId
        , Object.isErased                           AS isErased
        , Object_User.Id                            AS UserId
        , Object_User.ObjectCode                    AS UserCode
        , Object_User.ValueData     :: VarChar (30) AS UserName
        , tmpPersonal.MemberId                      AS MemberId
        , tmpPersonal.MemberName    :: VarChar (30) AS MemberName
        , tmpPersonal.UnitName      :: VarChar (30) AS UnitName
        , tmpPersonal.PositionName  :: VarChar (30) AS PositionName
        , tmpPersonal.BranchName    :: VarChar (30) AS BranchName
        , (Object.Id :: TVarChar || ' - ' || inDataBaseId :: TVarChar) :: TVarChar AS GUID

     FROM ReplObject
          INNER JOIN Object     ON Object.Id     = ReplObject.ObjectId
          LEFT JOIN  ObjectDesc ON ObjectDesc.Id = Object.DescId

          LEFT JOIN Object AS Object_User ON Object_User.Id = ReplObject.UserId_last
          LEFT JOIN tmpPersonal ON tmpPersonal.UserId = ReplObject.UserId_last
     WHERE ReplObject.SessionGUID = inSessionGUID
       AND ((ReplObject.Id BETWEEN inStartId AND inEndId) OR inEndId = 0)
     ORDER BY Object.Id
    ;
     --
     RETURN NEXT Cur_Object;


     -- 2. ObjectString
     OPEN Cur_ObjectString FOR
     SELECT
          ReplObject.OperDate_last                  AS OperDate_last
        , ReplObject.ObjectId                       AS ObjectId
        , ObjectString.DescId                       AS DescId
        , ObjectStringDesc.Code     :: VarChar (50) AS DescName
        , ObjectStringDesc.ItemName :: VarChar (50) AS ItemName

        , ObjectString.ValueData                    AS ValueData
        , (ReplObject.ObjectId :: TVarChar || ' - ' || inDataBaseId :: TVarChar) :: TVarChar AS GUID

     FROM ReplObject
          INNER JOIN ObjectString     ON ObjectString.ObjectId = ReplObject.ObjectId
          LEFT JOIN  ObjectStringDesc ON ObjectStringDesc.Id   = ObjectString.DescId
     WHERE ReplObject.SessionGUID = inSessionGUID
       AND ((ReplObject.Id BETWEEN inStartId AND inEndId) OR inEndId = 0)
     ORDER BY ReplObject.ObjectId
    ;
     --
     RETURN NEXT Cur_ObjectString;


     -- 3. ObjectFloat
     OPEN Cur_ObjectFloat FOR
     SELECT
          ReplObject.OperDate_last                  AS OperDate_last
        , ReplObject.ObjectId                       AS ObjectId
        , ObjectFloat.DescId                        AS DescId
        , ObjectFloatDesc.Code      :: VarChar (50) AS DescName
        , ObjectFloatDesc.ItemName  :: VarChar (50) AS ItemName
        , ObjectFloat.ValueData     :: TFloat       AS ValueData
        , (ReplObject.ObjectId :: TVarChar || ' - ' || inDataBaseId :: TVarChar) :: TVarChar AS GUID

     FROM ReplObject
          INNER JOIN ObjectFloat     ON ObjectFloat.ObjectId = ReplObject.ObjectId
          LEFT JOIN  ObjectFloatDesc ON ObjectFloatDesc.Id   = ObjectFloat.DescId
     WHERE ReplObject.SessionGUID = inSessionGUID
       AND ((ReplObject.Id BETWEEN inStartId AND inEndId) OR inEndId = 0)
     ORDER BY ReplObject.ObjectId
    ;
     --
     RETURN NEXT Cur_ObjectFloat;


     -- 4. ObjectDate
     OPEN Cur_ObjectDate FOR
     SELECT
          ReplObject.OperDate_last                  AS OperDate_last
        , ReplObject.ObjectId                       AS ObjectId
        , ObjectDate.DescId                         AS DescId
        , ObjectDateDesc.Code       :: VarChar (50) AS DescName
        , ObjectDateDesc.ItemName   :: VarChar (50) AS ItemName
        , ObjectDate.ValueData                      AS ValueData
        , CASE WHEN ObjectDate.ValueData IS NULL THEN TRUE ELSE FALSE END :: Boolean AS isValueNull
        , (ReplObject.ObjectId :: TVarChar || ' - ' || inDataBaseId :: TVarChar) :: TVarChar AS GUID

     FROM ReplObject
          INNER JOIN ObjectDate     ON ObjectDate.ObjectId = ReplObject.ObjectId
          LEFT JOIN  ObjectDateDesc ON ObjectDateDesc.Id   = ObjectDate.DescId
     WHERE ReplObject.SessionGUID = inSessionGUID
       AND ((ReplObject.Id BETWEEN inStartId AND inEndId) OR inEndId = 0)
     ORDER BY ReplObject.ObjectId
    ;
     --
     RETURN NEXT Cur_ObjectDate;


     -- 5. ObjectBoolean
     OPEN Cur_ObjectBoolean FOR
     SELECT
          ReplObject.OperDate_last                  AS OperDate_last
        , ReplObject.ObjectId                       AS ObjectId
        , ObjectBoolean.DescId                      AS DescId
        , ObjectBooleanDesc.Code    :: VarChar (50) AS DescName
        , ObjectBooleanDesc.ItemName:: VarChar (50) AS ItemName
        , ObjectBoolean.ValueData                   AS ValueData
        , (ReplObject.ObjectId :: TVarChar || ' - ' || inDataBaseId :: TVarChar) :: TVarChar AS GUID

     FROM ReplObject
          INNER JOIN ObjectBoolean     ON ObjectBoolean.ObjectId = ReplObject.ObjectId
          LEFT JOIN  ObjectBooleanDesc ON ObjectBooleanDesc.Id   = ObjectBoolean.DescId
     WHERE ReplObject.SessionGUID = inSessionGUID
       AND ((ReplObject.Id BETWEEN inStartId AND inEndId) OR inEndId = 0)
     ORDER BY ReplObject.ObjectId
    ;
     --
     RETURN NEXT Cur_ObjectBoolean;


     OPEN Cur_ObjectLink FOR
     -- 5. ObjectLink
     SELECT
          ReplObject.OperDate_last                  AS OperDate_last
        , ReplObject.ObjectId                       AS ObjectId
        , ObjectLink.DescId                         AS DescId
        , ObjectLinkDesc.Code       :: VarChar (50) AS DescName
        , ObjectLinkDesc.ItemName   :: VarChar (50) AS ItemName
        , ObjectLink.ChildObjectId  :: Integer      AS ChildObjectId
        , (ReplObject.ObjectId :: TVarChar || ' - ' || inDataBaseId :: TVarChar) :: TVarChar AS GUID
     FROM ReplObject
          INNER JOIN ObjectLink     ON ObjectLink.ObjectId = ReplObject.ObjectId
          LEFT JOIN  ObjectLinkDesc ON ObjectLinkDesc.Id   = ObjectLink.DescId
     WHERE ReplObject.SessionGUID = inSessionGUID
       AND ((ReplObject.Id BETWEEN inStartId AND inEndId) OR inEndId = 0)
     ORDER BY ReplObject.ObjectId
    ;
     --
     RETURN NEXT Cur_ObjectLink;



END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.06.18                                        *
*/

-- тест
-- SELECT * FROM gpSelect_ReplObject  (inSessionGUID:= CURRENT_TIMESTAMP :: TVarChar, inStartId:= 0, inEndId:= 0, inDataBaseId:= 0, inSession:= zfCalc_UserAdmin()) -- ORDER BY 1
