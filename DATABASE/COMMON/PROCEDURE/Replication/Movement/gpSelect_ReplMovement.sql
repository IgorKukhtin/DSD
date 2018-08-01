-- для SessionGUID - возвращает данные из табл. ReplMovement -> Movement - для формирования скриптов

DROP FUNCTION IF EXISTS gpSelect_ReplMovement (TVarChar, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ReplMovement(
    IN inSessionGUID      TVarChar,      --
    IN inStartId          Integer,       --
    IN inEndId            Integer,       --
    IN inDataBaseId       Integer,       -- для формирования "виртуального" GUID
    IN gConnectHost       TVarChar,      -- виртуальный, что б в exe - использовать другой сервак
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (OperDate_last  TDateTime
             , MovementId     Integer
             , DescId         Integer
             , DescName       VarChar (100)
             , ItemName       VarChar (100)
             , InvNumber      VarChar (30)
             , OperDate       TDateTime
             , StatusId       Integer
             , StatusName     VarChar (30)
             , ParentId       Integer
             , AccessKeyId    Integer
             , UserId         Integer
             , UserCode       Integer
             , UserName       VarChar (30)
             , MemberId       Integer
             , MemberName     VarChar (30)
             , UnitName       VarChar (30)
             , PositionName   VarChar (30)
             , BranchName     VarChar (30)
             , GUID           VarChar (100)
             , GUID_parent    VarChar (100)
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PaidKind());


     -- Результат

     -- 1. Movement
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
          ReplMovement.OperDate_last                AS OperDate_last
        , Movement.Id                               AS MovementId
        , Movement.DescId                           AS DescId
        , MovementDesc.Code        :: VarChar (100) AS DescName
        , MovementDesc.ItemName    :: VarChar (100) AS ItemName
        , Movement.InvNumber       :: VarChar (30)  AS InvNumber
        , Movement.OperDate                         AS OperDate
        , Movement.StatusId                         AS StatusId
        , Object_Status.ValueData  :: VarChar (30)  AS StatusName
        , Movement.ParentId                         AS ParentId
        , Movement.AccessKeyId                      AS AccessKeyId
        , Object_User.Id                            AS UserId
        , Object_User.ObjectCode                    AS UserCode
        , Object_User.ValueData    :: VarChar (30)  AS UserName
        , tmpPersonal.MemberId                      AS MemberId
        , tmpPersonal.MemberName   :: VarChar (30)  AS MemberName
        , tmpPersonal.UnitName     :: VarChar (30)  AS UnitName
        , tmpPersonal.PositionName :: VarChar (30)  AS PositionName
        , tmpPersonal.BranchName   :: VarChar (30)  AS BranchName

        , (CASE WHEN MovementString_GUID.ValueData        <> '' THEN MovementString_GUID.ValueData        ELSE Movement.Id       :: TVarChar || ' - ' || inDataBaseId :: TVarChar END) :: VarChar (100) AS GUID
        , (CASE WHEN MovementString_GUID_parent.ValueData <> '' THEN MovementString_GUID_parent.ValueData ELSE Movement.ParentId :: TVarChar || ' - ' || inDataBaseId :: TVarChar END) :: VarChar (100) AS GUID_parent

     FROM ReplMovement
          INNER JOIN Movement ON Movement.Id     = ReplMovement.MovementId
                             AND (Movement.StatusId <> zc_Enum_Status_Complete()
                               OR Movement.DescId   <> zc_Movement_WeighingPartner()
                                 )
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
          LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

          LEFT JOIN Object AS Object_User ON Object_User.Id = ReplMovement.UserId_last
          LEFT JOIN tmpPersonal ON tmpPersonal.UserId = ReplMovement.UserId_last

          LEFT JOIN MovementString AS MovementString_GUID
                                   ON MovementString_GUID.MovementId = ReplMovement.MovementId
                                  AND MovementString_GUID.DescId     = zc_MovementString_GUID()
          LEFT JOIN MovementString AS MovementString_GUID_parent
                                   ON MovementString_GUID_parent.MovementId = Movement.ParentId
                                  AND MovementString_GUID_parent.DescId     = zc_MovementString_GUID()

     WHERE ReplMovement.SessionGUID = inSessionGUID
       AND ((ReplMovement.Id BETWEEN inStartId AND inEndId) OR inEndId = 0)
     ORDER BY Movement.Id
    ;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.07.18                                        *
*/

-- тест
-- SELECT * FROM gpSelect_ReplMovement  (inSessionGUID:= '2018-07-30 18:45:52 - {C3667554-FEB8-4865-A777-B656574CF74C}', inStartId:= 27973, inEndId:= 27983, inDataBaseId:= 0, gConnectHost:= '', inSession:= zfCalc_UserAdmin()) -- ORDER BY 1
-- SELECT * FROM gpSelect_ReplMovement  (inSessionGUID:= CURRENT_TIMESTAMP :: TVarChar, inStartId:= 0, inEndId:= 0, inDataBaseId:= 0, gConnectHost:= '', inSession:= zfCalc_UserAdmin()) -- ORDER BY 1
