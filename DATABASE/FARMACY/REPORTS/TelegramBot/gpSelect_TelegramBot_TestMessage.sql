-- Function: gpSelect_TelegramBot_TestMessage()

DROP FUNCTION IF EXISTS gpSelect_TelegramBot_TestMessage (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_TelegramBot_TestMessage(
    IN inOperDate      TDateTime ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (ObjectId Integer
             , TelegramId TVarChar
             , Message TBLOB
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
     SELECT 3, '568330367'::TVarChar, 'Тестово сообщение.'::TBLOB
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_Movement_Check (TDateTime, TDateTime, Boolean, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 04.11.21                                                       * 
*/

-- тест

select * from gpSelect_TelegramBot_TestMessage(inOperDate := CURRENT_TIMESTAMP::TDateTime,  inSession := '3');