-- для SessionGUID - возвращает данные из табл. ReplMovement -> Movement - для формирования скриптов

DROP FUNCTION IF EXISTS gpSelect_ReplMovementFloat (TVarChar, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ReplMovementFloat(
    IN inSessionGUID  TVarChar,      --
    IN inStartId      Integer,       --
    IN inEndId        Integer,       --
    IN inDataBaseId   Integer,       -- для формирования "виртуального" GUID
    IN gConnectHost   TVarChar,      -- виртуальный, что б в exe - использовать другой сервак
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS TABLE (OperDate_last  TDateTime
             , MovementDescId Integer
             , MovementId     Integer
             , DescId         Integer
             , DescName       VarChar (100)
             , ItemName       VarChar (100)

             , ValueDataS     VarChar (1)
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
        , ReplMovement.MovementId                     AS MovementId
        , MovementFloat.DescId                        AS DescId
        , MovementFloatDesc.Code     :: VarChar (100) AS DescName
        , MovementFloatDesc.ItemName :: VarChar (100) AS ItemName
                                                    
        , ''                       :: VarChar (1)     AS ValueDataS
        , MovementFloat.ValueData    :: TFloat        AS ValueDataF
        , NULL                     :: TDateTime       AS ValueDataD
        , NULL                     :: Boolean         AS ValueDataB
        , FALSE                    :: Boolean         AS isValuDNull
        , FALSE                    :: Boolean         AS isValuBNull

        , (CASE WHEN MovementString_GUID.ValueData <> '' THEN MovementString_GUID.ValueData ELSE ReplMovement.MovementId :: TVarChar || ' - ' || inDataBaseId :: TVarChar END) :: VarChar (100) AS GUID

     FROM ReplMovement
          INNER JOIN Movement ON Movement.Id     = ReplMovement.MovementId
                             AND (Movement.StatusId <> zc_Enum_Status_Complete()
                               OR Movement.DescId <> zc_Movement_WeighingPartner()
                                 )
          INNER JOIN MovementFloat     ON MovementFloat.MovementId = ReplMovement.MovementId
          LEFT JOIN  MovementFloatDesc ON MovementFloatDesc.Id   = MovementFloat.DescId

          LEFT JOIN MovementString AS MovementString_GUID
                                   ON MovementString_GUID.MovementId = ReplMovement.MovementId
                                  AND MovementString_GUID.DescId     = zc_MovementString_GUID()

     WHERE ReplMovement.SessionGUID = inSessionGUID
       AND ((ReplMovement.Id BETWEEN inStartId AND inEndId) OR inEndId = 0)
     ORDER BY ReplMovement.MovementId, MovementFloat.DescId
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
-- SELECT * FROM gpSelect_ReplMovementFloat  (inSessionGUID:= CURRENT_TIMESTAMP :: TVarChar, inStartId:= 0, inEndId:= 0, inDataBaseId:= 0, gConnectHost:= '', inSession:= zfCalc_UserAdmin()) -- ORDER BY 1
