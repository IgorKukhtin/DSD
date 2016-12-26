-- Function: gpUpdate_Object_Goods_IsUpload()

DROP FUNCTION IF EXISTS gpUpdate_isDeferred(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_isDeferred(
    IN inMovementId          Integer   ,    -- ключ документа
    IN inisDeferred          Boolean   ,    -- Отложен
   OUT outisDeferred         Boolean   ,
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inMovementId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- определили признак
   outisDeferred:=  inisDeferred;

   PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_Deferred(), inMovementId, outisDeferred);

   -- сохранили протокол
   PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, false);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 22.12.16         *
*/