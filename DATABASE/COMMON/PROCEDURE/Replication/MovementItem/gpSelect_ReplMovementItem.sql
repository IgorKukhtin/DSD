-- для SessionGUID - возвращает данные из табл. ReplMovement -> MovementItem - для формирования скриптов

DROP FUNCTION IF EXISTS gpSelect_ReplMovementItem (TVarChar, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ReplMovementItem(
    IN inSessionGUID      TVarChar,      --
    IN inStartId          Integer,       --
    IN inEndId            Integer,       --
    IN inDataBaseId       Integer,       -- для формирования "виртуального" GUID
    IN gConnectHost       TVarChar,      -- виртуальный, что б в exe - использовать другой сервак
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (OperDate_last    TDateTime
             , MovementId       Integer
             , MovementDescId   Integer
             , MovementDescName VarChar (100)
             , InvNumber        VarChar (30)
             , OperDate         TDateTime
             , StatusName       VarChar (30)

             , MovementItemId Integer
             , DescId         Integer
             , DescName       VarChar (100)
             , ItemName       VarChar (100)
             , ObjectId       Integer
             , Amount         TFloat
             , ParentId       Integer
             , isErased       Boolean

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
             , GUID_movement  VarChar (100)
             , GUID_object    VarChar (100)
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
        , Movement.DescId                           AS MovementDescId
        , MovementDesc.Code        :: VarChar (100) AS MovementDescName
        , Movement.InvNumber       :: VarChar (30)  AS InvNumber
        , Movement.OperDate                         AS OperDate
        , Object_Status.ValueData  :: VarChar (30)  AS StatusName

        , MovementItem.Id                               AS MovementItemId
        , MovementItem.DescId                           AS DescId
        , MovementItemDesc.Code        :: VarChar (100) AS DescName
        , MovementItemDesc.ItemName    :: VarChar (100) AS ItemName
        , MovementItem.ObjectId                         AS ObjectId
        , MovementItem.Amount                           AS Amount
        , MovementItem.ParentId                         AS ParentId
        , MovementItem.isErased                         AS isErased

        , Object_User.Id                            AS UserId
        , Object_User.ObjectCode                    AS UserCode
        , Object_User.ValueData    :: VarChar (30)  AS UserName
        , tmpPersonal.MemberId                      AS MemberId
        , tmpPersonal.MemberName   :: VarChar (30)  AS MemberName
        , tmpPersonal.UnitName     :: VarChar (30)  AS UnitName
        , tmpPersonal.PositionName :: VarChar (30)  AS PositionName
        , tmpPersonal.BranchName   :: VarChar (30)  AS BranchName

        , (CASE WHEN MIString_GUID.ValueData                <> '' THEN MIString_GUID.ValueData                ELSE MovementItem.Id         :: TVarChar || ' - ' || inDataBaseId :: TVarChar END) :: VarChar (100) AS GUID
        , (CASE WHEN MIString_GUID_parent.ValueData         <> '' THEN MIString_GUID_parent.ValueData         ELSE MovementItem.ParentId   :: TVarChar || ' - ' || inDataBaseId :: TVarChar END) :: VarChar (100) AS GUID_parent
        , (CASE WHEN MovementString_GUID_movement.ValueData <> '' THEN MovementString_GUID_movement.ValueData ELSE ReplMovement.MovementId :: TVarChar || ' - ' || inDataBaseId :: TVarChar END) :: VarChar (100) AS GUID_movement
        , (CASE WHEN ObjectString_GUID.ValueData            <> '' THEN ObjectString_GUID.ValueData            ELSE MovementItem.ObjectId   :: TVarChar || ' - ' || inDataBaseId :: TVarChar END) :: VarChar (100) AS GUID_object
        

     FROM ReplMovement
          INNER JOIN Movement     ON Movement.Id        = ReplMovement.MovementId
                                 AND (Movement.StatusId <> zc_Enum_Status_Complete()
                                   OR Movement.DescId   <> zc_Movement_WeighingPartner()
                                     )
          LEFT JOIN  MovementDesc ON MovementDesc.Id = Movement.DescId
          LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

          INNER JOIN MovementItem     ON MovementItem.MovementId = Movement.Id
          LEFT JOIN  MovementItemDesc ON MovementItemDesc.Id     = MovementItem.DescId

          LEFT JOIN Object AS Object_User ON Object_User.Id = ReplMovement.UserId_last
          LEFT JOIN tmpPersonal ON tmpPersonal.UserId = ReplMovement.UserId_last

          LEFT JOIN MovementItemString AS MIString_GUID
                                       ON MIString_GUID.MovementItemId = MovementItem.Id
                                      AND MIString_GUID.DescId         = zc_MIString_GUID()
          LEFT JOIN MovementItemString AS MIString_GUID_parent
                                       ON MIString_GUID_parent.MovementItemId = MovementItem.ParentId
                                      AND MIString_GUID_parent.DescId         = zc_MIString_GUID()
          LEFT JOIN MovementString AS MovementString_GUID_movement
                                   ON MovementString_GUID_movement.MovementId = ReplMovement.MovementId
                                  AND MovementString_GUID_movement.DescId     = zc_MovementString_GUID()

          LEFT JOIN ObjectString AS ObjectString_GUID
                                 ON ObjectString_GUID.ObjectId = MovementItem.ObjectId
                                AND ObjectString_GUID.DescId   = zc_ObjectString_GUID()

     WHERE ReplMovement.SessionGUID = inSessionGUID
       AND ((ReplMovement.Id BETWEEN inStartId AND inEndId) OR inEndId = 0)
       AND MIString_GUID.ValueData <> ''
     ORDER BY MovementItem.Id
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
-- SELECT * FROM gpSelect_ReplMovementItem  (inSessionGUID:= CURRENT_TIMESTAMP :: TVarChar, inStartId:= 0, inEndId:= 0, inDataBaseId:= 0, gConnectHost:= '', inSession:= zfCalc_UserAdmin()) -- ORDER BY 1
