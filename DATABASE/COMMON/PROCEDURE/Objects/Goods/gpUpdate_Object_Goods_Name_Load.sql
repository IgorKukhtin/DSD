 -- Function: gpUpdate_Object_Goods_Name_Load()

DROP FUNCTION IF EXISTS gpUpdate_Object_Goods_Name_Load (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Goods_Name_Load(
    IN inGoodsCode           Integer   , -- Код объекта <Товар> 
    IN inGoodsName_new       TVarChar  , -- новое название
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbGoodsGroupPropertyId Integer;
   DECLARE vbGoodsGroupPropertyId_parent Integer;
   
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!Пустой код - Пропустили!!!
     IF COALESCE (inGoodsCode, 0) = 0 THEN
        RETURN; -- !!!ВЫХОД!!!
     END IF;
    
     IF inGoodsCode > 0 
     THEN
         -- !!!поиск ИД товара!!!
         vbGoodsId:= (SELECT Object_Goods.Id
                      FROM Object AS Object_Goods
                      WHERE Object_Goods.ObjectCode = inGoodsCode
                        AND Object_Goods.DescId     = zc_Object_Goods()
                        AND inGoodsCode > 0
                     );
     END IF;
     
     -- Проверка
     IF COALESCE (vbGoodsId, 0) = 0
     THEN 
        RETURN;
        RAISE EXCEPTION 'Ошибка.Не найден Товар с Код = <%> .', inGoodsCode;
     END IF;

     --проверка что Название (Scale) уже заполнено, т.е. предыдущее название товара перенесено в Название (Scale)
     IF TRIM (COALESCE ( (SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.DescId = zc_ObjectString_Goods_Scale() AND OS.ObjectId = vbGoodsId),'')) = '' 
     THEN
          RAISE EXCEPTION 'Ошибка.Название (Scale) не заполнено для Товара с Кодом = <%> .', inGoodsCode;
     END IF;
     
    -- сохранили новое название
    PERFORM lpInsertUpdate_Object (vbGoodsId, zc_Object_Goods(), inGoodsCode, inGoodsName_new);
     
    -- RAISE EXCEPTION 'Ошибка.Новое Название <%> для Товара с Кодом = <%> .', inGoodsName_new, inGoodsCode;
     
    IF vbUserId  = 9457  
    THEN
         RAISE EXCEPTION 'ОК. <%>', inGoodsName_new;
    END IF;
    
     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (vbGoodsId, vbUserId, FALSE);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.01.24         *
*/

-- тест
--

