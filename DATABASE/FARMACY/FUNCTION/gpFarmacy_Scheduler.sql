-- Function: gpFarmacy_Scheduler()

DROP FUNCTION IF EXISTS gpFarmacy_Scheduler(TVarChar);

CREATE OR REPLACE FUNCTION gpFarmacy_Scheduler(
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE text_var1 Text;
BEGIN
      -- проверка прав пользователя на вызов процедуры

    vbUserId := inSession;
      
    BEGIN
       PERFORM gpInsertUpdate_Movement_TechnicalRediscount_Formation (inSession := zfCalc_UserAdmin());
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpInsertUpdate_Movement_TechnicalRediscount_Formation', True, text_var1::TVarChar, vbUserId);
    END;
      
      
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.03.20                                                       * add gpInsertUpdate_Movement_TechnicalRediscount_Formation
 15.02.20                                                       *
*/

-- SELECT * FROM Log_Run_Schedule_Function
-- SELECT * FROM gpFarmacy_Scheduler (inSession := zfCalc_UserAdmin())
