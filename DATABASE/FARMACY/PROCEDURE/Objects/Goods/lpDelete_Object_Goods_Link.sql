-- Function: lpDelete_Object_Goods_Link()

DROP FUNCTION IF EXISTS lpDelete_Object_Goods_Link(Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpDelete_Object_Goods_Link(
    IN inGoodsId             Integer   ,    -- ключ объекта <Товар>
    IN inGoodsMainId         Integer   ,    -- ключ объекта <Главный товар>
    IN inObjectId            Integer   ,    -- Юр лицо или торговая сеть

    IN inUserId              Integer       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE text_var1 text;
BEGIN

     -- Сохранили в плоскую таблицй
    BEGIN

         -- ****** Если товар поставщика
       IF EXISTS (SELECT 1 FROM Object WHERE Object.ID = inObjectId AND Object.DescId = zc_Object_Juridical())
       THEN

            -- Если есть связь убоераем
            IF EXISTS(SELECT 1 FROM Object_Goods_Juridical
                      WHERE COALESCE(Object_Goods_Juridical.GoodsMainId, 0) <> 0
                        AND Object_Goods_Juridical.Id = inGoodsId
                        AND (COALESCE(Object_Goods_Juridical.GoodsMainId, 0) = COALESCE(inGoodsMainId, 0) 
                          OR COALESCE(inGoodsMainId, 0) = 0))
            THEN
              UPDATE Object_Goods_Juridical SET GoodsMainId = NULL
                                              , UserUpdateId = inUserId
                                              , DateUpdate   = CURRENT_TIMESTAMP
              WHERE Object_Goods_Juridical.Id = inGoodsId;
            END IF;

         -- ************* Если товар сети
       ELSEIF EXISTS (SELECT 1 FROM Object WHERE Object.ID = inObjectId AND Object.DescId = zc_Object_Retail())
       THEN

            -- Если есть связь убоераем
            IF EXISTS(SELECT 1 FROM Object_Goods_Retail
                      WHERE COALESCE(Object_Goods_Retail.GoodsMainId, 0) <> 0
                        AND Object_Goods_Retail.Id = inGoodsId
                        AND (COALESCE(Object_Goods_Retail.GoodsMainId, 0) = COALESCE(inGoodsMainId, 0) 
                          OR COALESCE(inGoodsMainId, 0) = 0))
            THEN
              UPDATE Object_Goods_Retail SET GoodsMainId = NULL
                                           , UserUpdateId = inUserId
                                           , DateUpdate   = CURRENT_TIMESTAMP
              WHERE Object_Goods_Retail.Id = inGoodsId;
            END IF;
       
         -- Связь с Штрихкодом
       ELSEIF inObjectId =zc_Enum_GlobalConst_BarCode()
       THEN
       
         -- Удаляем связь с кодом Штрихкодом       
         
         IF EXISTS(SELECT 1 FROM Object_Goods_BarCode WHERE  GoodsMainId = inGoodsMainId AND BarCodeId = inGoodsId)
         THEN
         
           DELETE FROM Object_Goods_BarCode WHERE  GoodsMainId = inGoodsMainId AND BarCodeId = inGoodsId;
         END IF;
       ELSEIF inObjectId =  zc_Enum_GlobalConst_Marion()
       THEN
          UPDATE Object_Goods_Main SET MorionCode = NULL
          WHERE Object_Goods_Main.Id = inGoodsMainId;
       ELSE
    /*     RAISE EXCEPTION 'Значение <(%) %> не допустимо.', inObjectId,
           COALESCE((SELECT ObjectDesc_GoodsObject.ItemName
                     FROM Object AS Object_GoodsObject
                          LEFT JOIN ObjectDesc AS ObjectDesc_GoodsObject ON ObjectDesc_GoodsObject.Id = Object_GoodsObject.DescId
                     WHERE Object_GoodsObject.Id = inObjectId), '');
    */
            PERFORM lpAddObject_Goods_Temp_Error('lpDelete_Object_Goods_Link',
                Format('Значение <(%s) %s> не допустимо. Товар %s Главный товар %s', inObjectId,
                       COALESCE((SELECT ObjectDesc_GoodsObject.ItemName
                       FROM Object AS Object_GoodsObject
                          LEFT JOIN ObjectDesc AS ObjectDesc_GoodsObject ON ObjectDesc_GoodsObject.Id = Object_GoodsObject.DescId
                       WHERE Object_GoodsObject.Id = inObjectId), ''), inGoodsId, inGoodsMainId) , inUserId);
       END IF;

    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
         PERFORM lpAddObject_Goods_Temp_Error('lpDelete_Object_Goods_Link', text_var1::TVarChar, inUserId);
    END;

END;$BODY$

	LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpDelete_Object_Goods_Link(Integer, Integer, Integer, Integer) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 21.10.19                                                      *

*/

-- тест
-- SELECT * FROM lpDelete_Object_Goods_Link