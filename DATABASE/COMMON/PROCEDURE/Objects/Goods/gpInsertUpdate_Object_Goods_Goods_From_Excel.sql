 -- Function: gpInsertUpdate_Object_Goods_Group_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_Group_From_Excel (Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods_Group_From_Excel(
    IN inGoodsGroupId        Integer   ,
    IN inGoodsCode           Integer   , -- Код объекта <Товар>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbGroupNameFull TVarChar; 
   DECLARE vbIsAsset Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpGetUserBySession (inSession); 
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Goods_GoodsGroup());

     --проверка
     IF COALESCE (inGoodsGroupId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Новая группа не выбрана.'; 
     END IF;
     
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

   
   -- расчетно свойство <Полное название группы>
   vbGroupNameFull:= lfGet_Object_TreeNameFull (inGoodsGroupId, zc_ObjectLink_GoodsGroup_Parent());
   vbIsAsset:= lfGet_Object_GoodsGroup_isAsset (inGoodsGroupId);

   -- сохранили связь с <Группой товара>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroup(), vbGoodsId, inGoodsGroupId);
   -- сохранили свойство <Полное название группы>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_GroupNameFull(), vbGoodsId, vbGroupNameFull);
   -- изменили свойство <Признак - ОС>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_Asset(), vbGoodsId, vbIsAsset);

   
   IF vbUserId = 9457 OR vbUserId = 5
   THEN
         RAISE EXCEPTION 'Тест. Ок. <%>', vbGoodsId; 
   END IF;   
   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.09.23         *
*/

-- тест
--select * from gpInsertUpdate_Object_Goods_Group_From_Excel(inGoodsGroupId := 1858 , inGoodsCode:=38 , inSession := '9457');
