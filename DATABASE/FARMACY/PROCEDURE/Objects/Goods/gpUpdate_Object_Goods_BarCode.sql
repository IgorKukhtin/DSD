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
   DECLARE vbLinkGoodsId Integer;
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
  
     -- Контроль  штрих-кода
     IF COALESCE (inBarCode, '') <> ''
     THEN
        PERFORM zfCheck_BarCode(inBarCode, True);
     END IF;

     -- !!!код не меняется!!!
     vbCode:= (SELECT ObjectCode FROM Object WHERE Id = inId);

     -- !!!поиск по коду - vbCode!!!
     vbMainGoodsId:= (SELECT Object_Goods_Main_View.Id FROM Object_Goods_Main_View  WHERE Object_Goods_Main_View.GoodsCode = vbCode);

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
     ELSE
          -- Проверяем использование
          IF EXISTS(SELECT ObjectLink_LinkGoods_Goods.ObjectId
                    FROM ObjectLink AS ObjectLink_Goods_Object
                         JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                         ON ObjectLink_LinkGoods_Goods.ChildObjectId = ObjectLink_Goods_Object.ObjectId
                                        AND ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                         JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                         ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId
                                        AND ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                                        AND ObjectLink_LinkGoods_GoodsMain.ChildObjectId <> vbMainGoodsId
                   WHERE ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                     AND ObjectLink_Goods_Object.ChildObjectId = zc_Enum_GlobalConst_BarCode()
                     AND ObjectLink_Goods_Object.ObjectId = vbBarCodeGoodsId)             
          THEN
             RAISE EXCEPTION 'Штрих-код "%" использован у другого товара..', inBarCode;
          END IF;
     END IF;       

     /*IF NOT EXISTS (SELECT 1 FROM Object_LinkGoods_View 
                    WHERE ObjectId = zc_Enum_GlobalConst_BarCode() 
                      AND GoodsId = vbBarCodeGoodsId 
                      AND GoodsMainId = vbMainGoodsId) 
     THEN
          PERFORM gpInsertUpdate_Object_LinkGoods(0, vbMainGoodsId, vbBarCodeGoodsId, inSession);
     END IF; */    
      
     SELECT ObjectLink_LinkGoods_Goods.ObjectId
     INTO vbLinkGoodsId 
     FROM ObjectLink AS ObjectLink_LinkGoods_Goods
      JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                      ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId
                     AND ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                     AND ObjectLink_LinkGoods_GoodsMain.ChildObjectId = vbMainGoodsId
     WHERE ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
     AND ObjectLink_LinkGoods_Goods.ChildObjectId = vbBarCodeGoodsId;
     
     IF COALESCE (vbLinkGoodsId, 0) = 0
     THEN
         vbLinkGoodsId:= gpInsertUpdate_Object_LinkGoods (0, vbMainGoodsId, vbBarCodeGoodsId, inSession);
     END IF;  
     
/*     IF COALESCE (vbLinkGoodsId, 0) <> 0  
     THEN -- чистим ненужные связи "товар штрих-код -> главный товар"
      PERFORM lpDelete_Object(ObjectLink_LinkGoods_Goods.ObjectId, zfCalc_UserAdmin())     
      FROM ObjectLink AS ObjectLink_Goods_Object
           JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                           ON ObjectLink_LinkGoods_Goods.ChildObjectId = ObjectLink_Goods_Object.ObjectId
                          AND ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                          AND ObjectLink_LinkGoods_Goods.ObjectId <> vbLinkGoodsId
           JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                           ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId
                          AND ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                          AND ObjectLink_LinkGoods_GoodsMain.ChildObjectId = vbMainGoodsId
      WHERE ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
        AND ObjectLink_Goods_Object.ChildObjectId = zc_Enum_GlobalConst_BarCode();
     END IF;
*/
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Ярошенко Р.Ф.
 11.07.17         *
*/

-- тест
-- select * from gpUpdate_Object_Goods_BarCode(inId := 3690795 , inBarCode := '' ,  inSession := '3');