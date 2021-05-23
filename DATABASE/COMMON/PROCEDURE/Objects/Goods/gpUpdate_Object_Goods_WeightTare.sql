-- Function: gpUpdateObject_Goods_UKTZED()

DROP FUNCTION IF EXISTS gpUpdate_Object_Goods_WeightTare (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Goods_WeightTare(
    IN inId                  Integer   , -- Ключ объекта <товар>
    IN inWeightTare          TFloat    , -- Вес втулки/тары 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectString_Goods_UKTZED());
     vbUserId:= lpGetUserBySession (inSession);


     IF COALESCE (inId,0) = 0
     THEN
         RETURN;
     END IF;

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_WeightTare(), inId, inWeightTare);

     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.10.19         *
*/


-- тест
-- SELECT * FROM gpUpdateObject_Goods_UKTZED (ioId:= 275079, inUKTZED:= '456/45', inSession:= '2')
