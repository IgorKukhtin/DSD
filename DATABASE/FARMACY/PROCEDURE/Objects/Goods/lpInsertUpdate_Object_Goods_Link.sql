-- Function: lpInsertUpdate_Object_Goods_Link()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods_Link(Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Goods_Link(
    IN inGoodsId             Integer   ,    -- ключ объекта <Товар>
    IN inGoodsMainId         Integer   ,    -- Ссылка на главный товар
    IN inObjectId            Integer   ,    -- Юр лицо или торговая сеть

    IN inUserId              Integer       -- текущий пользователь
)
RETURNS integer AS
$BODY$
   DECLARE text_var1 text;
BEGIN

     -- Сохранили в плоскую таблицй
    BEGIN

         -- ****** Если товар поставщика
       IF EXISTS (SELECT 1 FROM Object WHERE Object.ID = inObjectId AND Object.DescId = zc_Object_Juridical())
       THEN

          IF COALESCE(inGoodsMainId, 0) = 0
          THEN

            -- Если есть связь убоераем
            IF EXISTS(SELECT 1 FROM Object_Goods_Juridical
                      WHERE COALESCE(Object_Goods_Juridical.GoodsMainId, 0) <> 0
                        AND Object_Goods_Juridical.Id = inGoodsId)
            THEN
              UPDATE Object_Goods_Juridical SET GoodsMainId = NULL
                                              , UserUpdateId = inUserId
                                              , DateUpdate   = CURRENT_TIMESTAMP
              WHERE Object_Goods_Juridical.Id = inGoodsId;
            END IF;

          ELSE

            -- Если есть связь на другой товар убоераем
            IF EXISTS(SELECT 1 FROM Object_Goods_Juridical
                      WHERE Object_Goods_Juridical.GoodsMainId = inGoodsMainId
                        AND Object_Goods_Juridical.Id <> inGoodsId)
            THEN
              UPDATE Object_Goods_Juridical SET GoodsMainId = NULL
                                              , UserUpdateId = inUserId
                                              , DateUpdate   = CURRENT_TIMESTAMP
              WHERE Object_Goods_Juridical.GoodsMainId = inGoodsMainId
                AND Object_Goods_Juridical.Id <> inGoodsId;
            END IF;

            -- Устанавливаем связь
            UPDATE Object_Goods_Juridical SET GoodsMainId = NULLIF(inGoodsMainId, 0)
                                            , UserUpdateId = inUserId
                                            , DateUpdate   = CURRENT_TIMESTAMP
            WHERE Object_Goods_Juridical.Id = inGoodsId
              AND COALESCE(Object_Goods_Juridical.GoodsMainId, 0) <> COALESCE(inGoodsMainId, 0);
          END IF;

         -- ************* Если товар сети
       ELSEIF EXISTS (SELECT 1 FROM Object WHERE Object.ID = inObjectId AND Object.DescId = zc_Object_Retail())
       THEN

          IF COALESCE(inGoodsMainId, 0) = 0
          THEN

            -- Если есть связь убоераем
            IF EXISTS(SELECT 1 FROM Object_Goods_Retail
                      WHERE COALESCE(Object_Goods_Retail.GoodsMainId, 0) <> 0
                        AND Object_Goods_Retail.Id = inGoodsId)
            THEN
              UPDATE Object_Goods_Retail SET GoodsMainId = NULL
                                           , UserUpdateId = inUserId
                                           , DateUpdate   = CURRENT_TIMESTAMP
              WHERE Object_Goods_Retail.Id = inGoodsId;
            END IF;

          ELSE

            -- Если есть связь на другой товар убоераем
            IF EXISTS(SELECT 1 FROM Object_Goods_Retail
                      WHERE Object_Goods_Retail.GoodsMainId = inGoodsMainId
                        AND Object_Goods_Retail.Id <> inGoodsId)
            THEN
              UPDATE Object_Goods_Retail SET GoodsMainId = NULL
                                              , UserUpdateId = inUserId
                                              , DateUpdate   = CURRENT_TIMESTAMP
              WHERE Object_Goods_Retail.GoodsMainId = inGoodsMainId
                AND Object_Goods_Retail.Id <> inGoodsId;
            END IF;

            -- Устанавливаем связь
            UPDATE Object_Goods_Retail SET GoodsMainId = NULLIF(inGoodsMainId, 0)
                                            , UserUpdateId = inUserId
                                            , DateUpdate   = CURRENT_TIMESTAMP
            WHERE Object_Goods_Retail.Id = inGoodsId
              AND COALESCE(Object_Goods_Retail.GoodsMainId, 0) <> COALESCE(inGoodsMainId, 0);
          END IF;
       
       ELSE
    /*     RAISE EXCEPTION 'Значение <(%) %> не допустимо.', inObjectId,
           COALESCE((SELECT ObjectDesc_GoodsObject.ItemName
                     FROM Object AS Object_GoodsObject
                          LEFT JOIN ObjectDesc AS ObjectDesc_GoodsObject ON ObjectDesc_GoodsObject.Id = Object_GoodsObject.DescId
                     WHERE Object_GoodsObject.Id = inObjectId), '');
    */
            PERFORM lpAddObject_Goods_Temp_Error('lpInsertUpdate_Object_Goods_Link',
                Format('Значение <(%s) %s> не допустимо.', inObjectId,
                       COALESCE((SELECT ObjectDesc_GoodsObject.ItemName
                       FROM Object AS Object_GoodsObject
                          LEFT JOIN ObjectDesc AS ObjectDesc_GoodsObject ON ObjectDesc_GoodsObject.Id = Object_GoodsObject.DescId
                       WHERE Object_GoodsObject.Id = inObjectId), '')) , inUserId);
       END IF;

    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
         PERFORM lpAddObject_Goods_Temp_Error('lpInsertUpdate_Object_Goods_Link', text_var1::TVarChar, vbUserId);
    END;

END;$BODY$

	LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_Object_Goods_Link(Integer, Integer, Integer, Integer) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 21.10.19                                                      *

*/

-- тест
-- SELECT * FROM lpInsertUpdate_Object_Goods_Link