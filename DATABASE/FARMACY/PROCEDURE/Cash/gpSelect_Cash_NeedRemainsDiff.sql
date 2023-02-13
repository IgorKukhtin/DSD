-- Function: gpSelect_Cash_NeedRemainsDiff()

--DROP FUNCTION IF EXISTS gpSelect_Cash_NeedRemainsDiff (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Cash_NeedRemainsDiff (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Cash_NeedRemainsDiff (
    IN inCashSessionId  TVarChar,      -- Сессия кассового места
   OUT outIsRemainsDiff Boolean,       -- Надо обновить
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbLastRemainsDiff TDateTime;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);
   vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');

   IF vbUnitKey = '' THEN
      vbUnitKey := '0';
   END IF;
   vbUnitId := vbUnitKey::Integer;

   outIsRemainsDiff := False;

   IF EXISTS(SELECT * FROM CashSession WHERE Id = inCashSessionId)
   THEN
     SELECT LastConnect INTO vbLastRemainsDiff
     FROM CashSession WHERE Id = inCashSessionId;
   ELSE
     RETURN;
   END IF;

   IF vbLastRemainsDiff + INTERVAL '2 MIN' > CURRENT_TIMESTAMP
   THEN
     RETURN;
   END IF;
   

   IF EXISTS(SELECT 1 FROM MovementItemContainer
             WHERE OperDate > vbLastRemainsDiff
             AND WhereObjectId_Analyzer = vbUnitId)
   THEN
     outIsRemainsDiff := True;
   END IF;

END;
$BODY$


LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.05.19                                                       *
*/

-- тест
-- 
SELECT * FROM gpSelect_Cash_NeedRemainsDiff('{97F4F76A-F627-47B2-8147-0B2A79B6C09D}', '3')