-- для SessionGUID - возвращает данные из табл. ReplObject -> ObjectHistory - для формирования скриптов

DROP FUNCTION IF EXISTS gpSelect_ReplObjectHistory (TVarChar, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ReplObjectHistory(
    IN inSessionGUID  TVarChar,      --
    IN inStartId      Integer,       --
    IN inEndId        Integer,       --
    IN inDataBaseId   Integer,       -- для формирования "виртуального" GUID
    IN gConnectHost   TVarChar,      -- виртуальный, что б в exe - использовать другой сервак
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS TABLE (OperDate_last         TDateTime
             , DescId                Integer
             , DescName              VarChar (100)
             , ItemName              VarChar (100)
             , ObjectHistoryId       Integer
             , StartDate             TDateTime
             , EndDate               TDateTime
             , ObjectId              Integer
             , ObjectDescName        VarChar (100)
             , ObjectCode            Integer
             , ValueData             TVarChar
             , AccessKeyId           Integer
             , isErased              Boolean
             , UserId                Integer
             , UserCode              Integer
             , UserName              VarChar (30)
             , MemberId              Integer
             , MemberName            VarChar (30)
             , UnitName              VarChar (30)
             , PositionName          VarChar (30)
             , BranchName            VarChar (30)
             , GUID                  VarChar (100)
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PaidKind());


     -- Результат

     -- 1. Object
     RETURN QUERY
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
          ReplObject.OperDate_last                    AS OperDate_last
        , ObjectHistory.DescId                        AS DescId
        , ObjectHistoryDesc.Code     :: VarChar (100) AS DescName
        , ObjectHistoryDesc.ItemName :: VarChar (100) AS ItemName
        , ObjectHistory.Id                            AS ObjectHistoryId
        , ObjectHistory.StartDate                     AS StartDate
        , ObjectHistory.EndDate                       AS EndDate
        , Object.Id                                   AS ObjectId
        , ObjectDesc.Code            :: VarChar (100) AS ObjectDescName
        , Object.ObjectCode                           AS ObjectCode
        , Object.ValueData                            AS ValueData
        , Object.AccessKeyId                          AS AccessKeyId
        , Object.isErased                             AS isErased
        , Object_User.Id                              AS UserId
        , Object_User.ObjectCode                      AS UserCode
        , Object_User.ValueData      :: VarChar (30)  AS UserName
        , tmpPersonal.MemberId                        AS MemberId
        , tmpPersonal.MemberName     :: VarChar (30)  AS MemberName
        , tmpPersonal.UnitName       :: VarChar (30)  AS UnitName
        , tmpPersonal.PositionName   :: VarChar (30)  AS PositionName
        , tmpPersonal.BranchName     :: VarChar (30)  AS BranchName

        , (CASE WHEN ObjectString_GUID.ValueData <> '' THEN ObjectString_GUID.ValueData ELSE Object.Id :: TVarChar || ' - ' || inDataBaseId :: TVarChar END) :: VarChar (100) AS GUID

     FROM ReplObject
          INNER JOIN ObjectHistory ON ObjectHistory.ObjectId = ReplObject.ObjectId
          LEFT JOIN  ObjectHistoryDesc ON ObjectHistoryDesc.Id = ObjectHistory.DescId

          INNER JOIN Object     ON Object.Id     = ReplObject.ObjectId
          LEFT JOIN  ObjectDesc ON ObjectDesc.Id = Object.DescId

          LEFT JOIN Object AS Object_User ON Object_User.Id = ReplObject.UserId_last
          LEFT JOIN tmpPersonal ON tmpPersonal.UserId = ReplObject.UserId_last

          LEFT JOIN ObjectString AS ObjectString_GUID
                                 ON ObjectString_GUID.ObjectId = ReplObject.ObjectId
                                AND ObjectString_GUID.DescId   = zc_ObjectString_GUID()

     WHERE ReplObject.SessionGUID = inSessionGUID
       AND ((ReplObject.Id BETWEEN inStartId AND inEndId) OR inEndId = 0)

     ORDER BY Object.Id, ObjectHistory.StartDate
    ;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.07.18                                        *
*/

-- тест
-- SELECT * FROM gpSelect_ReplObjectHistory  (inSessionGUID:= '"2018-07-25 15:09:07 - {202258A1-B4FF-4E87-96B5-41317AA74824}"' :: TVarChar, inStartId:= 14427720, inEndId:= 14427720, inDataBaseId:= 0, gConnectHost:= '', inSession:= zfCalc_UserAdmin()) -- ORDER BY 1
-- SELECT * FROM gpSelect_ReplObjectHistory  (inSessionGUID:= CURRENT_TIMESTAMP :: TVarChar, inStartId:= 0, inEndId:= 0, inDataBaseId:= 0, gConnectHost:= '', inSession:= zfCalc_UserAdmin()) -- ORDER BY 1
