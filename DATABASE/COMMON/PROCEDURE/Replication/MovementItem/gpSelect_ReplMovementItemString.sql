-- для SessionGUID - возвращает данные из табл. ReplMovement -> Movement - для формирования скриптов

DROP FUNCTION IF EXISTS gpSelect_ReplMovementItemString (TVarChar, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ReplMovementItemString(
    IN inSessionGUID  TVarChar,      --
    IN inStartId      Integer,       --
    IN inEndId        Integer,       --
    IN inDataBaseId   Integer,       -- для формирования "виртуального" GUID
    IN gConnectHost   TVarChar,      -- виртуальный, что б в exe - использовать другой сервак
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS TABLE (OperDate_last    TDateTime
             , MovementDescId   Integer
             , MovementDescName VarChar (100)
             , MovementId       Integer

             , MovementItemId   Integer
             , DescId           Integer
             , DescName         VarChar (100)
             , ItemName         VarChar (100)

             , ValueDataS     TVarChar
             , ValueDataF     TFloat
             , ValueDataD     TDateTime
             , ValueDataB     Boolean
             , isValuDNull    Boolean
             , isValuBNull    Boolean

             , GUID           VarChar (100)
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

        , MovementItemString.MovementItemId               AS MovementItemId
        , MovementItemString.DescId                       AS DescId
        , MovementItemStringDesc.Code    :: VarChar (100) AS DescName
        , MovementItemStringDesc.ItemName:: VarChar (100) AS ItemName
                                                    
        , MovementItemString.ValueData                AS ValueDataS
        , 0                        :: TFloat          AS ValueDataF
        , NULL                     :: TDateTime       AS ValueDataD
        , NULL                     :: Boolean         AS ValueDataB
        , FALSE                    :: Boolean         AS isValuDNull
        , FALSE                    :: Boolean         AS isValuBNull

        , (CASE WHEN MIString_GUID.ValueData <> '' THEN MIString_GUID.ValueData ELSE MovementItem.Id :: TVarChar || ' - ' || inDataBaseId :: TVarChar END) :: VarChar (100) AS GUID

     FROM ReplMovement
          INNER JOIN Movement     ON Movement.Id        = ReplMovement.MovementId
                                 AND (Movement.StatusId <> zc_Enum_Status_Complete()
                                   OR Movement.DescId   <> zc_Movement_WeighingPartner()
                                     )
          LEFT JOIN  MovementDesc ON MovementDesc.Id         = Movement.DescId
          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id

          INNER JOIN MovementItemString     ON MovementItemString.MovementItemId = MovementItem.Id AND MovementItemString.DescId <> zc_MIString_GUID()
          LEFT JOIN  MovementItemStringDesc ON MovementItemStringDesc.Id         = MovementItemString.DescId

          LEFT JOIN MovementItemString AS MIString_GUID
                                       ON MIString_GUID.MovementItemId = MovementItem.Id
                                      AND MIString_GUID.DescId         = zc_MIString_GUID()

     WHERE ReplMovement.SessionGUID = inSessionGUID
       AND ((ReplMovement.Id BETWEEN inStartId AND inEndId) OR inEndId = 0)
       AND MIString_GUID.ValueData <> ''
     ORDER BY MovementItemString.MovementItemId, MovementItemString.DescId
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
-- SELECT * FROM gpSelect_ReplMovementItemString  (inSessionGUID:= CURRENT_TIMESTAMP :: TVarChar, inStartId:= 0, inEndId:= 0, inDataBaseId:= 0, gConnectHost:= '', inSession:= zfCalc_UserAdmin()) -- ORDER BY 1
