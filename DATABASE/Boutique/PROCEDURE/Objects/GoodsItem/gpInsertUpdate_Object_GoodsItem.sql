-- Function: gpInsertUpdate_Object_GoodsItem (Integer, Integer, Integer, Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsItem (Integer, Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsItem(
 INOUT ioId           Integer,       -- Ключ объекта <Товары с размерами>            
    IN inGoodsId      Integer,       -- Ключ объекта <Товары>             
    IN inGoodsSizeId  Integer,       -- Ключ объекта <Размер товара>
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS integer
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsInfo());
   vbUserId:= lpGetUserBySession (inSession);
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsInfo(), 0, '');

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
10.03.17                                                          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsInfo()
