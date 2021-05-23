-- Function: gpUpdateObject_Goods_isPartionSumm()

DROP FUNCTION IF EXISTS gpUpdateObject_Goods_isPartionSumm (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObject_Goods_isPartionSumm(
    IN inId                  Integer   , -- Ключ объекта <Документ>
    IN inisPartionSumm       Boolean   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectString_Goods_Partion());
     vbUserId:= lpGetUserBySession (inSession);


     -- меняется признак
     inisPartionSumm:= NOT inisPartionSumm;

     -- сохранили свойство
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_PartionSumm(), inId, inisPartionSumm);

     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 02.07.16         *
*/


-- тест
-- SELECT * FROM gpUpdateObject_Goods_isPartionSumm (ioId:= 275079, inisVAT:= 'False', inSession:= '2')
