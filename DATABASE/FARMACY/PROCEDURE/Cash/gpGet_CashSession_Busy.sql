-- Function: gpGet_CashSession_Busy()

DROP FUNCTION IF EXISTS gpGet_CashSession_Busy (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_CashSession_Busy(
    IN inCashSessionId  TVarChar  , -- ИД сессии
   OUT outisBusy        Boolean   , -- Занят CashSessionId
    IN inSession        TVarChar    -- сессия пользователя 
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);

    IF EXISTS(SELECT 1 
              FROM CashSession 
              WHERE CashSession.Id = inCashSessionId 
                AND CashSession.UserId <> vbUserId
                AND StartUpdate > CURRENT_DATE)
    THEN
      outisBusy := True;  
    ELSE
      outisBusy := False;  
    END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 13.03.21                                                      *
*/

SELECT * FROM gpGet_CashSession_Busy('{0B05C610-B172-4F81-99B8-25BF5385ADD6}', '3' );