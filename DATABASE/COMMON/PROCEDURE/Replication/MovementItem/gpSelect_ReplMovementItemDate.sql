-- для SessionGUID - возвращает данные из табл. ReplMovement -> MovementItem - для формирования скриптов

DROP FUNCTION IF EXISTS gpSelect_ReplMovementItemDate (TVarChar, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ReplMovementItemDate(
    IN inSessionGUID  TVarChar,      --
    IN inStartId      Integer,       --
    IN inEndId        Integer,       --
    IN inDataBaseId   Integer,       -- для формирования "виртуального" GUID
    IN gConnectHost   TVarChar,      -- виртуальный, что б в exe - использовать другой сервак
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS TABLE (OperDate_last  TDateTime
             , MovementDescId   Integer
             , MovementDescName VarChar (100)
             , MovementId       Integer

             , MovementItemId   Integer
             , DescId           Integer
             , DescName         VarChar (100)
             , ItemName         VarChar (100)

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
        , MovementDesc.Code        :: VarChar (100)   AS MovementDescName
        , ReplMovement.MovementId                     AS MovementId

        , MovementItemDate.MovementItemId                 AS MovementItemId
        , MovementItemDate.DescId                         AS DescId
        , MovementItemDateDesc.Code      :: VarChar (100) AS DescName
        , MovementItemDateDesc.ItemName  :: VarChar (100) AS ItemName

        , ''                       :: VarChar (1)     AS ValueDataS
        , 0                        :: TFloat          AS ValueDataF
        , MovementItemDate.ValueData                  AS ValueDataD
        , NULL :: Boolean                             AS ValueDataB
        , CASE WHEN MovementItemDate.ValueData IS NULL THEN TRUE ELSE FALSE END :: Boolean AS isValuDNull
        , FALSE                    :: Boolean         AS isValuBNull

        , (CASE WHEN MIString_GUID.ValueData <> '' THEN MIString_GUID.ValueData ELSE MovementItem.Id :: TVarChar || ' - ' || inDataBaseId :: TVarChar END) :: VarChar (100) AS GUID

     FROM ReplMovement
          INNER JOIN Movement     ON Movement.Id        = ReplMovement.MovementId
                                 AND (Movement.StatusId <> zc_Enum_Status_Complete()
                                   OR Movement.DescId   <> zc_Movement_WeighingPartner()
                                     )
          LEFT JOIN  MovementDesc ON MovementDesc.Id         = Movement.DescId
          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id

          INNER JOIN MovementItemDate     ON MovementItemDate.MovementItemId = MovementItem.Id
          LEFT JOIN  MovementItemDateDesc ON MovementItemDateDesc.Id         = MovementItemDate.DescId

          LEFT JOIN MovementItemString AS MIString_GUID
                                       ON MIString_GUID.MovementItemId = MovementItem.Id
                                      AND MIString_GUID.DescId         = zc_MIString_GUID()

     WHERE ReplMovement.SessionGUID = inSessionGUID
       AND ((ReplMovement.Id BETWEEN inStartId AND inEndId) OR inEndId = 0)
       AND MIString_GUID.ValueData <> ''
     ORDER BY MovementItemDate.MovementItemId, MovementItemDate.DescId
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
-- SELECT * FROM gpSelect_ReplMovementItemDate  (inSessionGUID:= CURRENT_TIMESTAMP :: TVarChar, inStartId:= 0, inEndId:= 0, inDataBaseId:= 0, gConnectHost:= '', inSession:= zfCalc_UserAdmin()) -- ORDER BY 1
