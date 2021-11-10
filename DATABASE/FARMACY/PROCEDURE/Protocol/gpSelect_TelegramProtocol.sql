
-- Function: gpSelect_TelegramProtocol()

DROP FUNCTION IF EXISTS gpSelect_TelegramProtocol (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_TelegramProtocol(
    IN inStartDate     TDateTime , -- 
    IN inEndDate       TDateTime , --
    IN inObjectId      Integer,    -- Получатель
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , UserName TVarChar
             , DateSend TDateTime
             , ObjectName TVarChar
             , TelegramId TVarChar
             , isError Boolean
             , Message TBlob
             , Error TVarChar)
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

  RETURN QUERY 
  SELECT Log_Send_Telegram.Id
       , Object_User.ValueData          AS UserName
       , Log_Send_Telegram.DateSend
       , Object.ValueData               AS ObjectName

       , Log_Send_Telegram.TelegramId
       , Log_Send_Telegram.isError
       , Log_Send_Telegram.Message
       , Log_Send_Telegram.Error
  FROM Log_Send_Telegram 
   
       JOIN Object AS Object ON Object.Id = Log_Send_Telegram.ObjectId

       JOIN Object AS Object_User ON Object_User.Id = Log_Send_Telegram.UserId

 WHERE Log_Send_Telegram.DateSend BETWEEN inStartDate AND inEndDate
   AND (Log_Send_Telegram.ObjectId = inObjectId OR 0 = inObjectId);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_TelegramProtocol (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 04.11.21                                                       * 
*/

-- тест
-- 

select * from gpSelect_TelegramProtocol(inStartDate := ('02.11.2021')::TDateTime , inEndDate := ('10.11.2021')::TDateTime , inObjectId := 0 ,  inSession := '3');