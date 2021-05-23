-- Function: gpInsertUpdate_ObjectBoolean_Goods_Partion

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectBoolean_Goods_Partion (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectBoolean_Goods_Partion(
    IN inId             Integer   , -- ключ объекта <Товар>
    IN inPartionCount   Boolean   , -- Партии поставщика в учете количеств
    IN inPartionSumm    Boolean   , -- Партии поставщика в учете себестоимости
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectString_Goods_Partion());
   vbUserId:= lpGetUserBySession (inSession);

   
   -- сохранили свойство <Партии поставщика в учете количеств>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_PartionCount(), inId, inPartionCount);
   -- сохранили свойство <Партии поставщика в учете себестоимости>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_PartionSumm(), inId, inPartionSumm);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_ObjectBoolean_Goods_Partion (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.07.13                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_ObjectBoolean_Goods_Partion (inId:=1000, inPartionCount:= TRUE, inPartionSumm:= TRUE, inSession:= '2')
