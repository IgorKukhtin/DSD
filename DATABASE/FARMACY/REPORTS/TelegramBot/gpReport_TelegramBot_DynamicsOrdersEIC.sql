-- Function: gpReport_TelegramBot_DynamicsOrdersEIC()

DROP FUNCTION IF EXISTS gpReport_TelegramBot_DynamicsOrdersEIC (TVarChar);

CREATE OR REPLACE FUNCTION gpReport_TelegramBot_DynamicsOrdersEIC(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime
             , CountNeBoley Integer
             , CountTabletki Integer
             , CountLiki24 Integer
             , CountAll Integer
             
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);
     
     -- Результат
     RETURN QUERY
      SELECT * 
      FROM gpReport_Movement_DynamicsOrdersEIC(inStartDate := '16.06.2021', inEndDate := CURRENT_DATE - INTERVAL '1 DAY', inSession := inSession);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_Movement_Check (TDateTime, TDateTime, Boolean, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.06.21                                                       * 
*/

-- тест

select * FROM gpReport_TelegramBot_DynamicsOrdersEIC(inSession := '3');