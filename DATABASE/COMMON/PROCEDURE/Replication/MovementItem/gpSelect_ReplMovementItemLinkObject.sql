-- для SessionGUID - возвращает данные из табл. ReplMovement -> MovementItem - для формирования скриптов

DROP FUNCTION IF EXISTS gpSelect_ReplMovementItemLinkObject (TVarChar, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ReplMovementItemLinkObject(
    IN inSessionGUID  TVarChar,      --
    IN inStartId      Integer,       --
    IN inEndId        Integer,       --
    IN inDataBaseId   Integer,       -- для формирования "виртуального" GUID
    IN gConnectHost   TVarChar,      -- виртуальный, что б в exe - использовать другой сервак
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS TABLE (OperDate_last      TDateTime
             , MovementDescId     Integer
             , MovementDescName   VarChar (100)
             , MovementId         Integer
                                  
             , MovementItemId     Integer
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
          ReplMovement.OperDate_last                  AS OperDate_last
        , ReplMovement.DescId                         AS MovementDescId
        , MovementDesc.Code        :: VarChar (100)   AS MovementDescName
        , ReplMovement.MovementId                     AS MovementId

        , MovementItemLinkObject.MovementItemId                 AS MovementItemId
        , MovementItemLinkObject.DescId                         AS DescId
        , MovementItemLinkObjectDesc.Code      :: VarChar (100) AS DescName
        , MovementItemLinkObjectDesc.ItemName  :: VarChar (100) AS ItemName

        , 0                                :: Integer           AS ChildObjectDescId
        , MovementItemLinkObject.ObjectId                       AS ChildObjectId

        , (CASE WHEN MIString_GUID.ValueData           <> '' THEN MIString_GUID.ValueData           ELSE MovementItem.Id                 :: TVarChar || ' - ' || inDataBaseId :: TVarChar END) :: VarChar (100) AS GUID
        , (CASE WHEN ObjectString_GUID_child.ValueData <> '' THEN ObjectString_GUID_child.ValueData ELSE MovementItemLinkObject.ObjectId :: TVarChar || ' - ' || inDataBaseId :: TVarChar END) :: VarChar (100) AS GUID_child

     FROM ReplMovement
          INNER JOIN Movement     ON Movement.Id        = ReplMovement.MovementId
                                 AND (Movement.StatusId <> zc_Enum_Status_Complete()
                                   OR Movement.DescId   <> zc_Movement_WeighingPartner()
                                     )
          LEFT JOIN  MovementDesc ON MovementDesc.Id         = Movement.DescId
          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id

          INNER JOIN MovementItemLinkObject     ON MovementItemLinkObject.MovementItemId = MovementItem.Id
          LEFT JOIN  MovementItemLinkObjectDesc ON MovementItemLinkObjectDesc.Id         = MovementItemLinkObject.DescId

          LEFT JOIN MovementItemString AS MIString_GUID
                                       ON MIString_GUID.MovementItemId = MovementItem.Id
                                      AND MIString_GUID.DescId         = zc_MIString_GUID()

          LEFT JOIN ObjectString AS ObjectString_GUID_child
                                 ON ObjectString_GUID_child.ObjectId = MovementItemLinkObject.ObjectId
                                AND ObjectString_GUID_child.DescId   = zc_ObjectString_GUID()

     WHERE ReplMovement.SessionGUID = inSessionGUID
       AND ((ReplMovement.Id BETWEEN inStartId AND inEndId) OR inEndId = 0)
       AND MIString_GUID.ValueData <> ''
     ORDER BY MovementItemLinkObject.MovementItemId, MovementItemLinkObject.DescId
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
-- SELECT * FROM gpSelect_ReplMovementItemLinkObject  (inSessionGUID:= CURRENT_TIMESTAMP :: TVarChar, inStartId:= 0, inEndId:= 0, inDataBaseId:= 0, gConnectHost:= '', inSession:= zfCalc_UserAdmin()) -- ORDER BY 1
