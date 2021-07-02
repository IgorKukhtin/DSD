-- Function: gpGet_CheckoutTesting_CashGUID()

DROP FUNCTION IF EXISTS gpGet_CheckoutTesting_CashGUID (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_CheckoutTesting_CashGUID(
    IN inCashSessionId  TVarChar  , -- ИД сессии
   OUT outOk            boolean   , -- Есть тестовая версия
    IN inSession        TVarChar    -- сессия пользователя  
)
RETURNS boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);
    
   IF EXISTS(SELECT Object_CheckoutTesting.Id
             FROM Object AS Object_CheckoutTesting
                                                       
                  LEFT JOIN ObjectBoolean AS ObjectBoolean_Updates
                                          ON ObjectBoolean_Updates.ObjectId = Object_CheckoutTesting.Id
                                         AND ObjectBoolean_Updates.DescId = zc_ObjectBoolean_CheckoutTesting_Updates()
                                      
             WHERE Object_CheckoutTesting.DescId = zc_Object_CheckoutTesting()
               AND Object_CheckoutTesting.isErased = False
               AND COALESCE (ObjectBoolean_Updates.ValueData, False) = FALSE
               AND Object_CheckoutTesting.ValueData = inCashSessionId)
   THEN
     outOk := True;
   ELSE
     outOk := False;
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