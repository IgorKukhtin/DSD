 -- Function: gpUpdate_Object_Goods_ScaleName_Load()

DROP FUNCTION IF EXISTS gpUpdate_Object_Goods_ScaleName_Load (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Goods_ScaleName_Load(
    IN inGoodsCode           Integer   , -- Код объекта <Товар> 
    IN inName_Scale           TVarChar  , -- новое название
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


     -- сохранили свойство <Название для Scale>
     PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_Scale(), vbGoodsId, inName_Scale);
          
     IF vbUserId  = 9457  
     THEN
          RAISE EXCEPTION 'ОК. <%>', inName_Scale;
     END IF;
     
     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (vbGoodsId, vbUserId, FALSE);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.01.24         *
*/

-- тест
--

