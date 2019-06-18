DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_BarCode (Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods_BarCode(
 INOUT ioBarCodeGoodsId      Integer   ,    -- ключ объекта <Штрих-код>
 INOUT ioGoodsMainId         Integer   ,    -- ключ объекта <Главный товар>
    IN inGoodsId             Integer   ,    -- ключ объекта <Товар>
    IN inBarCode             TVarChar  ,    -- Штрих-код производителя
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbObjectId Integer;
   DECLARE vbCode Integer;
   DECLARE vbLinkGoodsId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяется <Торговая сеть>
     vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

     -- проверка <Торговой сети> - !!!только для Insert!!!
     IF COALESCE (vbObjectId, 0) <= 0 AND COALESCE (inGoodsId, 0) = 0 THEN
        RAISE EXCEPTION 'У пользователя "%" не установлена торговая сеть', lfGet_Object_ValueData (vbUserId);
     END IF;

     -- <Код>
     IF COALESCE (inGoodsId, 0) = 0
     THEN
        RAISE EXCEPTION 'Товар должен быть определен';
     END IF;

     -- Контроль  штрих-кода
     IF COALESCE (inBarCode, '') <> ''
     THEN
        PERFORM zfCheck_BarCode(inBarCode, True);
     END IF;

     IF COALESCE (ioBarCodeGoodsId, 0) = 0
     THEN

       -- Контроль  штрих-кода
       IF COALESCE (inBarCode, '') = ''
       THEN
          RAISE EXCEPTION 'Не введен штрих-код.';
       END IF;

       -- !!!код не меняется!!!
       vbCode:= (SELECT ObjectCode FROM Object WHERE Id = inGoodsId);

       -- !!!поиск по коду - vbCode!!!
       ioGoodsMainId:= (SELECT Object_Goods_Main_View.Id FROM Object_Goods_Main_View  WHERE Object_Goods_Main_View.GoodsCode = vbCode);

       -- Устанавливаем связь со штрих-кодом
       SELECT Id INTO ioBarCodeGoodsId
       FROM Object_Goods_View
       WHERE ObjectId = zc_Enum_GlobalConst_BarCode()
         AND GoodsName = inBarCode;

       IF COALESCE (ioBarCodeGoodsId, 0) = 0
       THEN
            -- Создаем штрих коды, которых еще нет
            ioBarCodeGoodsId:= lpInsertUpdate_Object(0, zc_Object_Goods(), 0, inBarCode);
            PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Object(), ioBarCodeGoodsId, zc_Enum_GlobalConst_BarCode());
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
                                        AND ObjectLink_LinkGoods_GoodsMain.ChildObjectId <> ioGoodsMainId
                   WHERE ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                     AND ObjectLink_Goods_Object.ChildObjectId = zc_Enum_GlobalConst_BarCode()
                     AND ObjectLink_Goods_Object.ObjectId = ioBarCodeGoodsId)
          THEN
             RAISE EXCEPTION 'Штрих-код "%" использован у другого товара..', inBarCode;
          END IF;
       END IF;

       SELECT ObjectLink_LinkGoods_Goods.ObjectId
       INTO vbLinkGoodsId
       FROM ObjectLink AS ObjectLink_LinkGoods_Goods
        JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                        ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId
                       AND ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                       AND ObjectLink_LinkGoods_GoodsMain.ChildObjectId = ioGoodsMainId
       WHERE ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
       AND ObjectLink_LinkGoods_Goods.ChildObjectId = ioBarCodeGoodsId;

       IF COALESCE (vbLinkGoodsId, 0) = 0
       THEN
           vbLinkGoodsId:= gpInsertUpdate_Object_LinkGoods (0, ioGoodsMainId, ioBarCodeGoodsId, inSession);
       END IF;

       IF COALESCE (vbLinkGoodsId, 0) <> 0
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
                            AND ObjectLink_LinkGoods_GoodsMain.ChildObjectId = ioGoodsMainId
        WHERE ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
          AND ObjectLink_Goods_Object.ChildObjectId = zc_Enum_GlobalConst_BarCode();
       END IF;
     ELSE
       -- Проверяем на уникальность
       IF COALESCE (inBarCode, '') <> '' AND
          EXISTS(SELECT * FROM Object WHERE Object.ObjectCode = 0
                                        AND Object.ValueData = inBarCode
                                        AND Object.Id <> ioBarCodeGoodsId
                                        AND Object.DescId = zc_Object_Goods())
       THEN
          RAISE EXCEPTION 'Штрих-код "%" не уникален.', inBarCode;
       END IF;

       -- изменили элемент справочника по значению <Ключ объекта>
       IF COALESCE (inBarCode, '') = ''
       THEN
          PERFORM lpDelete_Object(ObjectLink_LinkGoods_Goods.ObjectId, zfCalc_UserAdmin())
          FROM ObjectLink AS ObjectLink_Goods_Object
               JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                               ON ObjectLink_LinkGoods_Goods.ChildObjectId = ObjectLink_Goods_Object.ObjectId
                              AND ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
               JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                               ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId
                              AND ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                               AND ObjectLink_LinkGoods_GoodsMain.ChildObjectId = ioGoodsMainId
         WHERE ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
           AND ObjectLink_Goods_Object.ChildObjectId = zc_Enum_GlobalConst_BarCode()
           AND ObjectLink_Goods_Object.ObjectId = ioBarCodeGoodsId;
         ioBarCodeGoodsId := NULL;
         ioGoodsMainId := NULL;
       ELSE
         UPDATE Object SET ValueData = inBarCode WHERE Id = ioBarCodeGoodsId AND DescId = zc_Object_Goods();
       END IF;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Ярошенко Р.Ф.   Шаблий О.В.
 17.06.19                                                                      *
*/

-- тест
-- select * from gpInsertUpdate_Object_Goods_BarCode(inId := 3690795 , inBarCode := '' ,  inSession := '3');