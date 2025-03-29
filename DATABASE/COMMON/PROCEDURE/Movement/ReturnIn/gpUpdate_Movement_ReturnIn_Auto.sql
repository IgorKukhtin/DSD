-- Function: gpUpdate_Movement_ReturnIn_Auto()

DROP FUNCTION IF EXISTS gpUpdate_Movement_ReturnIn_Auto (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ReturnIn_Auto(
    IN inMovementId        Integer               , -- ключ Документа
    IN inStartDateSale     TDateTime             , --
   OUT outMessageText      Text                  , --
    IN inSession           TVarChar                -- сессия пользователя
)
RETURNS Text
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbOperDate_Begin1 TDateTime;
BEGIN
     -- сразу запомнили время начала выполнения Проц.
     vbOperDate_Begin1:= CLOCK_TIMESTAMP();

     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ReturnIn());

     -- автоматом сформировалась строчная часть - zc_MI_Child
     outMessageText:= lpUpdate_Movement_ReturnIn_Auto (inStartDateSale := inStartDateSale
                                                     , inEndDateSale   := NULL
                                                     , inMovementId    := inMovementId
                                                     , inUserId        := vbUserId
                                                      );

     -- !!!временно - ПРОТОКОЛ - ЗАХАРДКОДИЛ!!!
     INSERT INTO ResourseProtocol (UserId
                                 , OperDate
                                 , Value1
                                 , Value2
                                 , Value3
                                 , Value4
                                 , Value5
                                 , Time1
                                 , Time2
                                 , Time3
                                 , Time4
                                 , Time5
                                 , ProcName
                                 , ProtocolData
                                  )
        WITH tmp_pg AS (SELECT * FROM pg_stat_activity WHERE state = 'active')
        SELECT vbUserId
               -- во сколько началась
             , CURRENT_TIMESTAMP
             , (SELECT COUNT (*) FROM tmp_pg)                                                    AS Value1
             , (SELECT COUNT (*) FROM tmp_pg WHERE position( 'autovacuum: VACUUM' in query) = 1) AS Value2
             , NULL AS Value3
             , NULL AS Value4
             , NULL AS Value5
               -- сколько всего выполнялась проц
             , (CLOCK_TIMESTAMP() - vbOperDate_Begin1) :: INTERVAL AS Time1
               -- сколько всего выполнялась проц ДО lpSelectMinPrice_List
             , NULL AS Time2
               -- сколько всего выполнялась проц lpSelectMinPrice_List
             , NULL AS Time3
               -- сколько всего выполнялась проц ПОСЛЕ lpSelectMinPrice_List
             , NULL AS Time4
               -- во сколько закончилась
             , CLOCK_TIMESTAMP() AS Time5
               -- ProcName
             , ('gpUpdate_Movement_ReturnIn_Auto - ' || outMessageText) :: TVarChar
               -- ProtocolData
             , inMovementId :: TVarChar
    || ', ' || CHR (39) || zfConvert_DateToString (inStartDateSale) || CHR (39)
    || ', ' || inSession
              ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 18.05.16                                        *
*/

-- тест
-- SELECT * FROM MovementItem WHERE MovementId = 3662505 AND DescId = zc_MI_Child() -- SELECT * FROM MovementItemFloat WHERE MovementItemId IN (SELECT Id FROM MovementItem WHERE MovementId = 3662505 AND DescId = zc_MI_Child())
-- SELECT gpUpdate_Movement_ReturnIn_Auto (inMovementId:= Movement.Id, inStartDateSale:= Movement.OperDate - INTERVAL '15 DAY' , inUserId:= zfCalc_UserAdmin() :: Integer) || CHR (13), Movement.* FROM Movement WHERE Movement.Id = 3662505
-- SELECT gpUpdate_Movement_ReturnIn_Auto (inMovementId:= Movement.Id, inStartDateSale:= Movement.OperDate - INTERVAL '4 MONTH', inUserId:= zfCalc_UserAdmin() :: Integer) || CHR (13), Movement.* FROM Movement WHERE Movement.Id = 3662505
