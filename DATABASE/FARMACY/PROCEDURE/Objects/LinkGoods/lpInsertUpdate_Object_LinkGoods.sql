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
   DECLARE vbObjectId     Integer;
   DECLARE text_var1      text;
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
   
    -- Сохранили в плоскую таблицй
   BEGIN
    
      SELECT ObjectLink_Goods_Object.ChildObjectId
      INTO vbObjectId
      FROM ObjectLink AS ObjectLink_Goods_Object
      WHERE ObjectLink_Goods_Object.ObjectId = inGoodsId
        AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object();

      PERFORM lpInsertUpdate_Object_Goods_Link(inGoodsId, inGoodsMainId, vbObjectId, inUserId);
   EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
         PERFORM lpAddObject_Goods_Temp_Error('gpDelete_Object_LinkGoods', text_var1::TVarChar, inUserId);
   END;
   

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inObjectId:= ioId, inUserId:= inUserId, inIsUpdate:= vbIsUpdate, inIsErased:= NULL);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 21.10.19                                                      *
 13.02.19                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Object_LinkGoods (ioId:=0, inGoodsMainId:=5, inGoodsId:=6, inRetailId:=0, inSession:='2')
