DROP FUNCTION IF EXISTS gpInsertUpdate_Object_AccountSalesDE (Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_AccountSalesDE(
    IN inMovementItemContainerId Integer    , -- ID движение по контейнеру MovementItemContainer
    IN inActNumber               TVarChar   , -- Номер акта
    IN inAmount                  TFloat     , -- Сумма акта
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbId       Integer;
   DECLARE vbIsUpdate Boolean;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpGetUserBySession(inSession);

   IF COALESCE (inMovementItemContainerId, 0) = 0 
   THEN
       RAISE EXCEPTION 'Не указана ID движение по контейнеру';
   END IF;
    
   SELECT Object.Id
   INTO vbId
   FROM Object
   WHERE Object.DescId = zc_Object_AccountSalesDE()
     AND Object.ObjectCode = inMovementItemContainerId;
   
   -- определили <Признак>
   vbIsUpdate:= COALESCE (vbId, 0) > 0;

   -- сохранили <Объект>
   vbId := lpInsertUpdate_Object (vbId, zc_Object_AccountSalesDE(), inMovementItemContainerId, inActNumber);
   
   -- сохранили связь с <главным товаром>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_AccountSalesDE_Amount(), vbId, inAmount);   

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inObjectId:= vbId, inUserId:= vbUserId, inIsUpdate:= vbIsUpdate, inIsErased:= NULL);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_AccountSalesDE (Integer, TVarChar, TFloat, TVarChar) OWNER TO postgres;

  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 11.10.15                                                          *
*/