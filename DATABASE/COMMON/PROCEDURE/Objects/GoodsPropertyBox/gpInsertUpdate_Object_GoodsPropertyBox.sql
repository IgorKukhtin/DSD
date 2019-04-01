-- Function: gpInsertUpdate_Object_GoodsPropertyBox (Integer, Integer, Integer)

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsPropertyBox (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsPropertyBox(
 INOUT ioId                   Integer  , -- ключ объекта <>
    IN inBoxId                Integer  , -- Ящик
    IN inGoodsId              Integer  , -- Товары
    IN inGoodsKindId          Integer  , -- Виды товаров
    IN inCountOnBox           TFloat   , -- количество ед. в ящ.
    IN inWeightOnBox          TFloat   , -- количество кг. в ящ.
    IN inSession              TVarChar 
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsPropertyBox());
   vbUserId:= lpGetUserBySession (inSession);

   -- проверка
   IF COALESCE (inGoodsId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не установлено значение <Товар>.';
   END IF;

   
   -- проверка уникальности
   IF EXISTS (SELECT ObjectLink_GoodsPropertyBox_Goods.ChildObjectId
              FROM ObjectLink AS ObjectLink_GoodsPropertyBox_Goods
                   LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyBox_GoodsKind
                                        ON ObjectLink_GoodsPropertyBox_GoodsKind.ObjectId = ObjectLink_GoodsPropertyBox_Goods.ObjectId
                                       AND ObjectLink_GoodsPropertyBox_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyBox_GoodsKind()
                   LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyBox_Box
                                        ON ObjectLink_GoodsPropertyBox_Box.ObjectId = ObjectLink_GoodsPropertyBox_Goods.ObjectId
                                       AND ObjectLink_GoodsPropertyBox_Box.DescId = zc_ObjectLink_GoodsPropertyBox_Box()
                   LEFT JOIN Object AS Object_GoodsPropertyBox
                                    ON Object_GoodsPropertyBox.Id = ObjectLink_GoodsPropertyBox_Goods.ObjectId
                                   AND Object_GoodsPropertyBox.DescId = zc_Object_GoodsPropertyBox()
              WHERE ObjectLink_GoodsPropertyBox_Goods.DescId = zc_ObjectLink_GoodsPropertyBox_Goods()
                --AND ObjectLink_GoodsPropertyBox_Box.ChildObjectId = inBoxId
                AND ( (ObjectLink_GoodsPropertyBox_Box.ChildObjectId IN (zc_Box_E2(), zc_Box_E3())     AND inBoxId IN (zc_Box_E2(), zc_Box_E3()))
                   OR (ObjectLink_GoodsPropertyBox_Box.ChildObjectId NOT IN (zc_Box_E2(), zc_Box_E3()) AND inBoxId NOT IN (zc_Box_E2(), zc_Box_E3())) 
                    )
                AND ObjectLink_GoodsPropertyBox_Goods.ChildObjectId = inGoodsId
                AND COALESCE (ObjectLink_GoodsPropertyBox_GoodsKind.ChildObjectId, 0) = COALESCE (inGoodsKindId, 0)
                AND ObjectLink_GoodsPropertyBox_Goods.ObjectId <> COALESCE (ioId, 0)
                AND Object_GoodsPropertyBox.isErased = FALSE)

   THEN 
       RAISE EXCEPTION 'Ошибка.Значение  <%> + <%> + <%> уже есть в справочнике. Дублирование запрещено.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (inGoodsKindId), lfGet_Object_ValueData (inBoxId);
   END IF;   

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsPropertyBox(), 0, '');
   -- сохранили связь с <Товары>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsPropertyBox_Goods(), ioId, inGoodsId);
   -- сохранили связь с <Виды товаров>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsPropertyBox_GoodsKind(), ioId, inGoodsKindId);

   -- сохранили связь с <Ящик>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsPropertyBox_Box(), ioId, inBoxId);

   -- сохранили свойство <количество кг. в ящ.>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsPropertyBox_WeightOnBox(), ioId, inWeightOnBox);
   -- сохранили свойство <количество ед. в ящ.>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsPropertyBox_CountOnBox(), ioId, inCountOnBox);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  
 24.06.18         *
*/

-- тест
-- 
