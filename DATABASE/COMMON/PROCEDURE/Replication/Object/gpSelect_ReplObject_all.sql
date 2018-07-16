-- для SessionGUID - возвращает "блоками" данные из табл. ReplObject - для формирования скриптов

DROP FUNCTION IF EXISTS gpSelect_ReplObject_all (TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ReplObject_all(
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
        , ObjectDesc.Code          :: VarChar (100) AS DescName
        , ObjectDesc.ItemName      :: VarChar (100) AS ItemName
        , Object.ObjectCode                         AS ObjectCode
        , Object.ValueData                          AS ValueData
        , Object.AccessKeyId                        AS AccessKeyId
        , Object.isErased                           AS isErased
        , Object_User.Id                            AS UserId
        , Object_User.ObjectCode                    AS UserCode
        , Object_User.ValueData    :: VarChar (30)  AS UserName
        , tmpPersonal.MemberId                      AS MemberId
        , tmpPersonal.MemberName   :: VarChar (30)  AS MemberName
        , tmpPersonal.UnitName     :: VarChar (30)  AS UnitName
        , tmpPersonal.PositionName :: VarChar (30)  AS PositionName
        , tmpPersonal.BranchName   :: VarChar (30)  AS BranchName
        , (CASE WHEN ObjectString_GUID.ValueData <> '' THEN ObjectString_GUID.ValueData ELSE Object.Id :: TVarChar || ' - ' || inDataBaseId :: TVarChar END) :: VarChar (35) AS GUID

     FROM ReplObject
          INNER JOIN Object     ON Object.Id     = ReplObject.ObjectId
          LEFT JOIN  ObjectDesc ON ObjectDesc.Id = Object.DescId

          LEFT JOIN Object AS Object_User ON Object_User.Id = ReplObject.UserId_last
          LEFT JOIN tmpPersonal ON tmpPersonal.UserId = ReplObject.UserId_last

          LEFT JOIN ObjectString AS ObjectString_GUID
                                 ON ObjectString_GUID.ObjectId = ReplObject.ObjectId
                                AND ObjectString_GUID.DescId   = zc_ObjectString_GUID()

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
        , ReplObject.DescId                         AS ObjectDescId
        , ReplObject.ObjectId                       AS ObjectId
        , ObjectString.DescId                       AS DescId
        , ObjectStringDesc.Code    :: VarChar (100) AS DescName
        , ObjectStringDesc.ItemName:: VarChar (100) AS ItemName
                                                    
        , ObjectString.ValueData                    AS ValueDataS
        , 0                        :: TFloat        AS ValueDataF
        , NULL                     :: TDateTime     AS ValueDataD
        , NULL                     :: Boolean       AS ValueDataB
        , FALSE                    :: Boolean       AS isValuDNull
        , FALSE                    :: Boolean       AS isValuBNull

        , (CASE WHEN ObjectString_GUID.ValueData <> '' THEN ObjectString_GUID.ValueData ELSE ReplObject.ObjectId :: TVarChar || ' - ' || inDataBaseId :: TVarChar END) :: VarChar (35) AS GUID

     FROM ReplObject
          INNER JOIN ObjectString     ON ObjectString.ObjectId = ReplObject.ObjectId
          LEFT JOIN  ObjectStringDesc ON ObjectStringDesc.Id   = ObjectString.DescId
          LEFT JOIN ObjectString AS ObjectString_GUID
                                 ON ObjectString_GUID.ObjectId = ReplObject.ObjectId
                                AND ObjectString_GUID.DescId   = zc_ObjectString_GUID()
     WHERE ReplObject.SessionGUID = inSessionGUID
       AND ((ReplObject.Id BETWEEN inStartId AND inEndId) OR inEndId = 0)
     ORDER BY ReplObject.ObjectId, ObjectString.DescId
    ;
     --
     RETURN NEXT Cur_ObjectString;


     -- 3. ObjectFloat
     OPEN Cur_ObjectFloat FOR
     SELECT
          ReplObject.OperDate_last                  AS OperDate_last
        , ReplObject.DescId                         AS ObjectDescId
        , ReplObject.ObjectId                       AS ObjectId
        , ObjectFloat.DescId                        AS DescId
        , ObjectFloatDesc.Code     :: VarChar (100) AS DescName
        , ObjectFloatDesc.ItemName :: VarChar (100) AS ItemName
                                                    
        , ''                       :: VarChar (1)   AS ValueDataS
        , ObjectFloat.ValueData    :: TFloat        AS ValueDataF
        , NULL                     :: TDateTime     AS ValueDataD
        , NULL                     :: Boolean       AS ValueDataB
        , FALSE                    :: Boolean       AS isValuDNull
        , FALSE                    :: Boolean       AS isValuBNull

        , (CASE WHEN ObjectString_GUID.ValueData <> '' THEN ObjectString_GUID.ValueData ELSE ReplObject.ObjectId :: TVarChar || ' - ' || inDataBaseId :: TVarChar END) :: VarChar (35) AS GUID

     FROM ReplObject
          INNER JOIN ObjectFloat     ON ObjectFloat.ObjectId = ReplObject.ObjectId
          LEFT JOIN  ObjectFloatDesc ON ObjectFloatDesc.Id   = ObjectFloat.DescId
          LEFT JOIN ObjectString AS ObjectString_GUID
                                 ON ObjectString_GUID.ObjectId = ReplObject.ObjectId
                                AND ObjectString_GUID.DescId   = zc_ObjectString_GUID()
     WHERE ReplObject.SessionGUID = inSessionGUID
       AND ((ReplObject.Id BETWEEN inStartId AND inEndId) OR inEndId = 0)
     ORDER BY ReplObject.ObjectId, ObjectFloat.DescId
    ;
     --
     RETURN NEXT Cur_ObjectFloat;


     -- 4. ObjectDate
     OPEN Cur_ObjectDate FOR
     SELECT
          ReplObject.OperDate_last                  AS OperDate_last
        , ReplObject.DescId                         AS ObjectDescId
        , ReplObject.ObjectId                       AS ObjectId
        , ObjectDate.DescId                         AS DescId
        , ObjectDateDesc.Code      :: VarChar (100) AS DescName
        , ObjectDateDesc.ItemName  :: VarChar (100) AS ItemName

        , ''                       :: VarChar (1)   AS ValueDataS
        , 0                        :: TFloat        AS ValueDataF
        , ObjectDate.ValueData                      AS ValueDataD
        , NULL :: Boolean                           AS ValueDataB
        , CASE WHEN ObjectDate.ValueData IS NULL THEN TRUE ELSE FALSE END :: Boolean AS isValuDNull
        , FALSE                    :: Boolean       AS isValuBNull

        , (CASE WHEN ObjectString_GUID.ValueData <> '' THEN ObjectString_GUID.ValueData ELSE ReplObject.ObjectId :: TVarChar || ' - ' || inDataBaseId :: TVarChar END) :: VarChar (35) AS GUID

     FROM ReplObject
          INNER JOIN ObjectDate     ON ObjectDate.ObjectId = ReplObject.ObjectId
          LEFT JOIN  ObjectDateDesc ON ObjectDateDesc.Id   = ObjectDate.DescId
          LEFT JOIN ObjectString AS ObjectString_GUID
                                 ON ObjectString_GUID.ObjectId = ReplObject.ObjectId
                                AND ObjectString_GUID.DescId   = zc_ObjectString_GUID()
     WHERE ReplObject.SessionGUID = inSessionGUID
       AND ((ReplObject.Id BETWEEN inStartId AND inEndId) OR inEndId = 0)
     ORDER BY ReplObject.ObjectId, ObjectDate.DescId
    ;
     --
     RETURN NEXT Cur_ObjectDate;


     -- 5. ObjectBoolean
     OPEN Cur_ObjectBoolean FOR
     SELECT
          ReplObject.OperDate_last                  AS OperDate_last
        , ReplObject.DescId                         AS ObjectDescId
        , ReplObject.ObjectId                       AS ObjectId
        , ObjectBoolean.DescId                      AS DescId
        , ObjectBooleanDesc.Code    :: VarChar (100) AS DescName
        , ObjectBooleanDesc.ItemName:: VarChar (100) AS ItemName

        , ''                        :: VarChar (1)  AS ValueDataS
        , 0                         :: TFloat       AS ValueDataF
        , NULL                      :: TDateTime    AS ValueDataD
        , ObjectBoolean.ValueData                   AS ValueDataB
        , FALSE                     :: Boolean      AS isValuDNull
        , CASE WHEN ObjectBoolean.ValueData IS NULL THEN TRUE ELSE FALSE END :: Boolean AS isValuBNull

        , (CASE WHEN ObjectString_GUID.ValueData <> '' THEN ObjectString_GUID.ValueData ELSE ReplObject.ObjectId :: TVarChar || ' - ' || inDataBaseId :: TVarChar END) :: VarChar (35) AS GUID

     FROM ReplObject
          INNER JOIN ObjectBoolean     ON ObjectBoolean.ObjectId = ReplObject.ObjectId
          LEFT JOIN  ObjectBooleanDesc ON ObjectBooleanDesc.Id   = ObjectBoolean.DescId
          LEFT JOIN ObjectString AS ObjectString_GUID
                                 ON ObjectString_GUID.ObjectId = ReplObject.ObjectId
                                AND ObjectString_GUID.DescId   = zc_ObjectString_GUID()
     WHERE ReplObject.SessionGUID = inSessionGUID
       AND ((ReplObject.Id BETWEEN inStartId AND inEndId) OR inEndId = 0)
     ORDER BY ReplObject.ObjectId, ObjectBoolean.DescId
    ;
     --
     RETURN NEXT Cur_ObjectBoolean;


     OPEN Cur_ObjectLink FOR
     -- 5. ObjectLink
     SELECT
          ReplObject.OperDate_last                  AS OperDate_last
        , ReplObject.DescId                         AS ObjectDescId
        , ReplObject.ObjectId                       AS ObjectId
        , ObjectLink.DescId                         AS DescId
        , ObjectLinkDesc.Code      :: VarChar (100) AS DescName
        , ObjectLinkDesc.ItemName  :: VarChar (100) AS ItemName
        , ObjectLink.ChildObjectId :: Integer       AS ChildObjectId

        , (CASE WHEN ObjectString_GUID.ValueData <> '' THEN ObjectString_GUID.ValueData ELSE ReplObject.ObjectId :: TVarChar || ' - ' || inDataBaseId :: TVarChar END) :: VarChar (35) AS GUID

     FROM ReplObject
          INNER JOIN ObjectLink     ON ObjectLink.ObjectId = ReplObject.ObjectId
          LEFT JOIN  ObjectLinkDesc ON ObjectLinkDesc.Id   = ObjectLink.DescId
          LEFT JOIN ObjectString AS ObjectString_GUID
                                 ON ObjectString_GUID.ObjectId = ReplObject.ObjectId
                                AND ObjectString_GUID.DescId   = zc_ObjectString_GUID()
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
-- SELECT * FROM gpSelect_ReplObject_all  (inSessionGUID:= CURRENT_TIMESTAMP :: TVarChar, inStartId:= 0, inEndId:= 0, inDataBaseId:= 0, inSession:= zfCalc_UserAdmin()) -- ORDER BY 1
