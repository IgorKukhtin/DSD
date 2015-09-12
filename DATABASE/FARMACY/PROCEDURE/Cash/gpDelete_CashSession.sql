-- Function: lpDelete_CashSession()

DROP FUNCTION IF EXISTS gpDelete_CashSession (TVarChar);
DROP FUNCTION IF EXISTS gpDelete_CashSession (TVarChar,TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_CashSession(
    IN inCashSessionId       TVarChar, -- ИД сессии
    IN inSession             TVarChar  -- Сессия пользователя
)
RETURNS Void AS
$BODY$
BEGIN
    --Очистили снапшот
    DELETE FROM CashSessionSnapShot
    WHERE CashSessionId = inCashSessionId;
    --Удалили сессию
    DELETE FROM CashSession
    WHERE Id = inCashSessionId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpDelete_CashSession (TVarChar,TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 10.09.15                                                         *
*/
