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
        INSERT INTO CashSession (Id, LastConnect, UserId, StartUpdate)
           VALUES (inCashSessionId, inDateConnect, inUserId, CURRENT_TIMESTAMP);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.  Шаблий О.В.
 29.04.20                                                                      *
 10.09.15                                                         *
*/

/*
-- select  * from CashSession ORDER BY 2 -- select count (*) from CashSessionSnapShot
-- select  * from CashSession WHERE lastConnect < CURRENT_TIMESTAMP - INTERVAL '180 MIN' ORDER BY 2 
-- delete from CashSessionSnapShot WHERE CashSessionId IN (select Id from CashSession WHERE lastConnect < CURRENT_TIMESTAMP - INTERVAL '180 MIN');
-- delete from CashSession WHERE Id NOT IN (SELECT DISTINCT CashSessionId FROM CashSessionSnapShot) AND lastConnect < CURRENT_TIMESTAMP - INTERVAL '180 MIN';
*/