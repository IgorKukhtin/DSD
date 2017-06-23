-- Function: gpInsertUpdate_Object_GoodsBarCode

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsBarCode (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsBarCode (
    IN inId               Integer,
    IN inCode             Integer,   -- Наш Код товара
    IN inBarCode          TVarChar,  -- Штрих-код
    IN inSession          TVarChar   -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbItemId Integer;
  DECLARE vbErrorText TVarChar;
  DECLARE vbObjectId Integer;
  DECLARE vbGoodsId Integer;
  DECLARE vbGoodsMainId Integer;
  DECLARE vbGoodsBarCodeId Integer;
  DECLARE vbLinkGoodsId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);
      -- определяется <Торговая сеть>
      vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

      IF NOT EXISTS (SELECT 1 FROM LoadGoodsBarCode WHERE Id = inId)
      THEN
           RAISE EXCEPTION 'Задан неверный идентификатор записи';
      END IF;

      IF NOT EXISTS (SELECT 1 FROM LoadGoodsBarCode WHERE Id = inId AND RetailId = vbObjectId)
      THEN
           RAISE EXCEPTION 'Попытка изменения записи чужой сети';
      END IF;

      vbErrorText:= '';

      IF COALESCE (inCode, 0) = 0
      THEN
           vbErrorText:= vbErrorText || 'Нулевой код нашего товара;';
      END IF;

      -- ищем ИД нашего товара по коду
      SELECT Object_Goods.Id
      INTO vbGoodsId
      FROM Object AS Object_Goods
           JOIN ObjectLink AS ObjectLink_Goods_Object
                           ON ObjectLink_Goods_Object.ObjectId = Object_Goods.Id
                          AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                          AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
      WHERE Object_Goods.DescId = zc_Object_Goods()
        AND Object_Goods.ObjectCode = COALESCE (inCode, 0);

      IF COALESCE (vbGoodsId, 0) = 0
      THEN
           vbErrorText:= vbErrorText || 'Не найден товар нашей сети;';
      ELSE -- ищем ИД главного товара
           SELECT ObjectLink_LinkGoods_GoodsMain.ChildObjectId
           INTO vbGoodsMainId
           FROM ObjectLink AS ObjectLink_LinkGoods_Goods
                JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId
                               AND ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
           WHERE ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
             AND ObjectLink_LinkGoods_Goods.ChildObjectId = vbGoodsId;

           IF COALESCE (vbGoodsMainId, 0) = 0
           THEN
                vbErrorText:= vbErrorText || 'Не найден главный товар;';
           END IF; 
      END IF;

      IF COALESCE (inBarCode, '') = ''
      THEN 
           vbErrorText:= vbErrorText || 'Не задан штрих-код;';
      ELSE -- ищем ИД штрих-кода
           SELECT Object_Goods.Id
           INTO vbGoodsBarCodeId
           FROM Object AS Object_Goods
                JOIN ObjectLink AS ObjectLink_Goods_Object
                                ON ObjectLink_Goods_Object.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                               AND ObjectLink_Goods_Object.ChildObjectId = zc_Enum_GlobalConst_BarCode()
           WHERE Object_Goods.DescId = zc_Object_Goods()
             AND Object_Goods.ValueData = inBarCode;

           IF COALESCE (vbGoodsBarCodeId, 0) = 0
           THEN
                vbGoodsBarCodeId:= lpInsertUpdate_Object(0, zc_Object_Goods(), 0, inBarCode);
                PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Object(), vbGoodsBarCodeId, zc_Enum_GlobalConst_BarCode());
           END IF;  

           IF COALESCE (vbGoodsMainId, 0) <> 0
           THEN
                SELECT ObjectLink_LinkGoods_Goods.ObjectId
                INTO vbLinkGoodsId 
                FROM ObjectLink AS ObjectLink_LinkGoods_Goods
                     JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                     ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId
                                    AND ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                                    AND ObjectLink_LinkGoods_GoodsMain.ChildObjectId = vbGoodsMainId
                WHERE ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                  AND ObjectLink_LinkGoods_Goods.ChildObjectId = vbGoodsBarCodeId;

                IF COALESCE (vbLinkGoodsId, 0) = 0
                THEN
                     vbLinkGoodsId:= gpInsertUpdate_Object_LinkGoods (0, vbGoodsMainId, vbGoodsBarCodeId, inSession);
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
                                         AND ObjectLink_LinkGoods_GoodsMain.ChildObjectId = vbGoodsMainId
                     WHERE ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                       AND ObjectLink_Goods_Object.ChildObjectId = zc_Enum_GlobalConst_BarCode();
                END IF;
           END IF;
      END IF;

      IF COALESCE (inId, 0) <> 0
      THEN
           UPDATE LoadGoodsBarCode
           SET GoodsMainId    = COALESCE (vbGoodsMainId, 0)::Integer
             , GoodsBarCodeId = COALESCE (vbGoodsBarCodeId, 0)::Integer
             , BarCode        = inBarCode
             , ErrorText      = vbErrorText
           WHERE Id = inId; 

           SELECT LoadGoodsBarCodeItem.Id 
           INTO vbItemId 
           FROM LoadGoodsBarCodeItem 
                JOIN LoadGoodsBarCode ON LoadGoodsBarCode.JuridicalId = LoadGoodsBarCodeItem.JuridicalId
           WHERE LoadGoodsBarCodeItem.LoadGoodsBarCodeId = inId;
      END IF;

      IF COALESCE (vbItemId, 0) <> 0
      THEN
           UPDATE LoadGoodsBarCodeItem
           SET UserId   = vbUserId
             , OperDate = CURRENT_TIMESTAMP
             , BarCode  = inBarCode
           WHERE Id = vbItemId; 
      END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 05.06.2017                                                      *
*/

/* 
SELECT * FROM gpInsertUpdate_Object_GoodsBarCode (inId:= 1,
                                                  inCode:= 5622,   -- Наш Код товара
                                                  inBarCode:= '4823000800725',  -- Штрих-код
                                                  inSession:= zfCalc_UserAdmin()   -- сессия пользователя
                                                 );
*/
/*
SELECT * FROM gpInsertUpdate_Object_GoodsBarCode (inId:= 2,
                                                  inCode:= 9851,   -- Наш Код товара
                                                  inBarCode:= '4820101882315',  -- Штрих-код
                                                  inSession:= zfCalc_UserAdmin()   -- сессия пользователя
                                                 );
*/
