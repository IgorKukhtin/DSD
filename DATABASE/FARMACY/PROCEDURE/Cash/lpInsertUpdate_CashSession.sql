-- Function: lpInsertUpdate_CashSession()

DROP FUNCTION IF EXISTS lpInsertUpdate_CashSession (TVarChar, TDateTime);

CREATE OR REPLACE FUNCTION lpInsertUpdate_CashSession(
    IN inCashSessionId       TVarChar  , -- ИД сессии
    IN inDateConnect         TDateTime   -- Дата последнего соединения по сессиии
)
RETURNS Void AS
$BODY$
BEGIN
    
    IF EXISTS(SELECT 1
              FROM CashSession
              WHERE CashSession.Id = inCashSessionId)
    THEN
        UPDATE CashSession SET
            LastConnect = inDateConnect
        WHERE
            CashSession.Id = inCashSessionId;
    ELSE
        INSERT INTO CashSession(Id,LastConnect)
        VALUES(inCashSessionId,inDateConnect);
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 10.09.15                                                         *
*/
