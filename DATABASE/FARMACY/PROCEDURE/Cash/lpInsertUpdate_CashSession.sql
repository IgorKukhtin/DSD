-- Function: lpInsertUpdate_CashSession()

-- DROP FUNCTION IF EXISTS lpInsertUpdate_CashSession (TVarChar, TDateTime);
DROP FUNCTION IF EXISTS lpInsertUpdate_CashSession (TVarChar, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_CashSession(
    IN inCashSessionId  TVarChar  , -- ИД сессии
    IN inDateConnect    TDateTime , -- Дата последнего соединения по сессиии
    IN inUserId         Integer   
)
RETURNS Void AS
$BODY$
BEGIN
    
    IF EXISTS(SELECT 1 FROM CashSession WHERE CashSession.Id = inCashSessionId)
    THEN
        UPDATE CashSession SET
            LastConnect = inDateConnect
          , UserId      = inUserId
        WHERE
            CashSession.Id = inCashSessionId;
    ELSE
        INSERT INTO CashSession (Id, LastConnect, UserId)
           VALUES (inCashSessionId, inDateConnect, inUserId);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 10.09.15                                                         *
*/
