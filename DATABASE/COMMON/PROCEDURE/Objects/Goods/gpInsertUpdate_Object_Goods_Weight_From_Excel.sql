 -- Function: gpInsertUpdate_Object_Goods_Weight_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_Weight_From_Excel (Integer, TFloat, TFloat, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods_Weight_From_Excel(
    IN inGoodsCode           Integer   , -- Код объекта <Товар>
    IN inWeight              TFloat    , -- вес
    IN inWeightTare          TFloat    , -- вес втулки
    IN inCountForWeight      TFloat    , -- кол-во для веса
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!Пустой код - Пропустили!!!
     IF COALESCE (inGoodsCode, 0) = 0 THEN
        RETURN; -- !!!ВЫХОД!!!
     END IF;


     -- !!!поиск ИД товара!!!
     vbGoodsId:= (SELECT Object_Goods.Id
                  FROM Object AS Object_Goods
                  WHERE Object_Goods.ObjectCode = inGoodsCode
                    AND Object_Goods.DescId     = zc_Object_Goods()
                    AND inGoodsCode > 0
                 );
     -- Проверка
     IF COALESCE (vbGoodsId, 0) = 0 THEN
        RETURN;
        RAISE EXCEPTION 'Ошибка.Не найден Товар с Код = <%> .', inGoodsCode;
     END IF;


     -- сохранили свойство <Вес>
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_Weight(), vbGoodsId, inWeight);
     -- сохранили свойство <Вес втулки>
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_WeightTare(), vbGoodsId, inWeightTare);
     -- сохранили свойство <кол для Веса>
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_CountForWeight(), vbGoodsId, inCountForWeight);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.10.197         *
*/

-- тест
--
