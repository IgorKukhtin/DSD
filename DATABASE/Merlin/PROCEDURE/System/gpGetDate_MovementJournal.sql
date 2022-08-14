-- Function: gpGetDate_MovementJournal()

DROP FUNCTION IF EXISTS gpGetDate_MovementJournal (TDateTime, TDateTime, TVarChar);
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

     SELECT DATE_TRUNC ('MONTH', CURRENT_DATE - INTERVAL '1 MONTH') :: TDateTime
         , CURRENT_DATE :: TDateTime
     INTO outStartDate, outEndDate;

     /*SELECT DATE_TRUNC ('MONTH', inStartDate) :: TDateTime
         , (DATE_TRUNC ('MONTH', inEndDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY') :: TDateTime
       INTO outStartDate, outEndDate;*/
     
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
-- SELECT * FROM gpGetDate_MovementJournal ('07.04.2018', '07.05.2018', inSession:= '2')