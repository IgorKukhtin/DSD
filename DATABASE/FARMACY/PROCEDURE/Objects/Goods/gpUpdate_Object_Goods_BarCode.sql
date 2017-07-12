-- Function: gpInsertUpdate_OgpUpdate_Object_Goods_BarCodebject_Goods()

DROP FUNCTION IF EXISTS gpUpdate_Object_Goods_BarCode (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Goods_BarCode(
    IN inId                  Integer   ,    -- ключ объекта <Товар>
    IN inBarCode             TVarChar  ,    -- Штрих-код производителя
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbObjectId Integer;
   DECLARE vbCode Integer;
   DECLARE vbMainGoodsId Integer;
   DECLARE vbBarCodeGoodsId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяется <Торговая сеть>
     vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

     -- проверка <Торговой сети> - !!!только для Insert!!!
     IF COALESCE (vbObjectId, 0) <= 0 AND COALESCE (inId, 0) = 0 THEN
        RAISE EXCEPTION 'У пользователя "%" не установлена торговая сеть', lfGet_Object_ValueData (vbUserId);
     END IF;

     -- <Код>
     IF COALESCE (inId, 0) = 0
     THEN
          RAISE EXCEPTION 'Товар должен быть определен';
     END IF;
  
     -- !!!код не меняется!!!
      vbCode:= (SELECT ObjectCode FROM Object WHERE Id = inId);

     -- !!!поиск по коду - vbCode!!!
     vbMainGoodsId:= (SELECT Object_Goods_Main_View.Id FROM Object_Goods_Main_View  WHERE Object_Goods_Main_View.GoodsCode = vbCode);

     IF COALESCE (inBarCode, '') <> '' 
     THEN
          -- Устанавливаем связь со штрих-кодом
          SELECT Id INTO vbBarCodeGoodsId
          FROM Object_Goods_View 
          WHERE ObjectId = zc_Enum_GlobalConst_BarCode() 
            AND GoodsName = inBarCode;

          IF COALESCE (vbBarCodeGoodsId, 0) = 0 
          THEN
               -- Создаем штрих коды, которых еще нет
               vbBarCodeGoodsId:= lpInsertUpdate_Object(0, zc_Object_Goods(), 0, inBarCode);
               PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Object(), vbBarCodeGoodsId, zc_Enum_GlobalConst_BarCode());
          END IF;       

          IF NOT EXISTS (SELECT 1 FROM Object_LinkGoods_View 
                         WHERE ObjectId = zc_Enum_GlobalConst_BarCode() 
                           AND GoodsId = vbBarCodeGoodsId 
                           AND GoodsMainId = vbMainGoodsId) 
          THEN
               PERFORM gpInsertUpdate_Object_LinkGoods(0, vbMainGoodsId, vbBarCodeGoodsId, inSession);
          END IF;     
      END IF;          
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Ярошенко Р.Ф.
 11.07.17         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Goods
