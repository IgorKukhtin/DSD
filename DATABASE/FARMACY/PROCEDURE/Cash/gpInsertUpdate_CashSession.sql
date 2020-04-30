-- Function: gpInsertUpdate_CashSession()

DROP FUNCTION IF EXISTS gpInsertUpdate_CashSession (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_CashSession(
    IN inCashSessionId  TVarChar  , -- ИД сессии
    IN inSession        TVarChar         -- сессия пользователя 
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);

    IF EXISTS(SELECT 1 FROM CashSession WHERE CashSession.Id = inCashSessionId)
    THEN
        UPDATE CashSession SET
            StartUpdate = CURRENT_TIMESTAMP
          , UserId      = vbUserId
        WHERE
            CashSession.Id = inCashSessionId;
    ELSE
      PERFORM lpInsertUpdate_CashSession (inCashSessionId := inCashSessionId
                                        , inDateConnect   := CURRENT_TIMESTAMP :: TDateTime
                                        , inUserId        := vbUserId
                                         );    
    END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 29.04.20                                                      *
*/

/*
*/