-- Function: lpInsertUpdate_Object_LinkGoods(Integer, TFloat, Integer, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_LinkGoods (Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_LinkGoods(
 INOUT ioId               Integer   , -- ключ объекта <Условия договора>
    IN inGoodsMainId      Integer   , -- Главный товар
    IN inGoodsId          Integer   , -- Товар для замены
    IN inUserId           Integer     -- Пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsUpdate Boolean;
BEGIN
   -- проверка
   IF COALESCE (inGoodsMainId, 0) = 0 THEN
      RAISE EXCEPTION 'Ошибка.Главный товар не определен';
   END IF;
   -- проверка
   IF COALESCE (inGoodsId, 0) = 0 THEN
      RAISE EXCEPTION 'Ошибка.Товар не определен';
   END IF;


   -- определили <Признак>
   vbIsUpdate:= COALESCE (ioId, 0) > 0;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_LinkGoods(), 0, '');

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_LinkGoods_GoodsMain(), ioId, inGoodsMainId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_LinkGoods_Goods(), ioId, inGoodsId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inObjectId:= ioId, inUserId:= inUserId, inIsUpdate:= vbIsUpdate, inIsErased:= NULL);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.02.19                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Object_LinkGoods (ioId:=0, inGoodsMainId:=5, inGoodsId:=6, inRetailId:=0, inSession:='2')
