-- Function: gpGetDate_MovementJournal()

-- DROP FUNCTION IF EXISTS gpGetDate_MovementJournal (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGetDate_MovementJournal (TDateTime, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGetDate_MovementJournal(
    IN inStartDate        TDateTime,  --
    IN inEndDate          TDateTime,  --
   OUT outStartDate       TDateTime,  -- 
   OUT outEndDate         TDateTime,  --
    IN inMovementDescCode TVarChar,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     IF EXISTS (SELECT 1
                FROM MovementDesc
                WHERE MovementDesc.Code ILIKE inMovementDescCode
                  AND MovementDesc.Id IN (zc_Movement_Cash(), zc_Movement_CashSend())
               )
     THEN
         -- 1 День
         SELECT CURRENT_DATE :: TDateTime
              , CURRENT_DATE :: TDateTime
         INTO outStartDate
            , outEndDate
             ;
     ELSE
         -- 1 Месяц + ....
         SELECT DATE_TRUNC ('MONTH', CURRENT_DATE - INTERVAL '1 MONTH') :: TDateTime
              , CURRENT_DATE :: TDateTime
         INTO outStartDate
            , outEndDate
             ;
     END IF;

     
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.08.22         * add inMovementDescCode
 14.05.18         *

*/

-- тест
-- SELECT * FROM gpGetDate_MovementJournal ('07.04.2018', '07.05.2018', inMovementDescCode := 'zc_Movement_Cash', inSession:= '2')
