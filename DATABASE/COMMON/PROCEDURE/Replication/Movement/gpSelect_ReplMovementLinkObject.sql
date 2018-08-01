-- для SessionGUID - возвращает данные из табл. ReplMovement -> Movement - для формирования скриптов

DROP FUNCTION IF EXISTS gpSelect_ReplMovementLinkObject (TVarChar, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ReplMovementLinkObject(
    IN inSessionGUID  TVarChar,      --
    IN inStartId      Integer,       --
    IN inEndId        Integer,       --
    IN inDataBaseId   Integer,       -- для формирования "виртуального" GUID
    IN gConnectHost   TVarChar,      -- виртуальный, что б в exe - использовать другой сервак
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS TABLE (OperDate_last      TDateTime
             , MovementDescId     Integer
             , MovementId         Integer
             , DescId             Integer
             , DescName           VarChar (100)
             , ItemName           VarChar (100)
             , ChildObjectDescId  Integer
             , ChildObjectId      Integer
             , GUID               VarChar (100)
             , GUID_child         VarChar (100)
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PaidKind());


     -- Результат

     -- 1. Movement
     RETURN QUERY
     SELECT
          ReplMovement.OperDate_last                        AS OperDate_last
        , ReplMovement.DescId                               AS MovementDescId
        , ReplMovement.MovementId                           AS MovementId
        , MovementLinkObject.DescId                         AS DescId
        , MovementLinkObjectDesc.Code      :: VarChar (100) AS DescName
        , MovementLinkObjectDesc.ItemName  :: VarChar (100) AS ItemName
        , 0                                :: Integer       AS ChildObjectDescId
        , MovementLinkObject.ObjectId                       AS ChildObjectId

        , (CASE WHEN MovementString_GUID.ValueData     <> '' THEN MovementString_GUID.ValueData     ELSE ReplMovement.MovementId     :: TVarChar || ' - ' || inDataBaseId :: TVarChar END) :: VarChar (100) AS GUID
        , (CASE WHEN ObjectString_GUID_child.ValueData <> '' THEN ObjectString_GUID_child.ValueData ELSE MovementLinkObject.ObjectId :: TVarChar || ' - ' || inDataBaseId :: TVarChar END) :: VarChar (100) AS GUID_child

     FROM ReplMovement
          INNER JOIN Movement ON Movement.Id     = ReplMovement.MovementId
                             AND (Movement.StatusId <> zc_Enum_Status_Complete()
                               OR Movement.DescId <> zc_Movement_WeighingPartner()
                                 )
          INNER JOIN MovementLinkObject     ON MovementLinkObject.MovementId = ReplMovement.MovementId
          LEFT JOIN  MovementLinkObjectDesc ON MovementLinkObjectDesc.Id     = MovementLinkObject.DescId

          LEFT JOIN MovementString AS MovementString_GUID
                                   ON MovementString_GUID.MovementId = ReplMovement.MovementId
                                  AND MovementString_GUID.DescId     = zc_MovementString_GUID()
          LEFT JOIN ObjectString AS ObjectString_GUID_child
                                 ON ObjectString_GUID_child.ObjectId = MovementLinkObject.ObjectId
                                AND ObjectString_GUID_child.DescId   = zc_ObjectString_GUID()

     WHERE ReplMovement.SessionGUID = inSessionGUID
       AND ((ReplMovement.Id BETWEEN inStartId AND inEndId) OR inEndId = 0)
     ORDER BY ReplMovement.MovementId
    ;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.06.18                                        *
*/

-- тест
-- SELECT * FROM gpSelect_ReplMovementLinkObject  (inSessionGUID:= CURRENT_TIMESTAMP :: TVarChar, inStartId:= 0, inEndId:= 0, inDataBaseId:= 0, gConnectHost:= '', inSession:= zfCalc_UserAdmin()) -- ORDER BY 1
