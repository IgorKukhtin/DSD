-- Function: lpInsertFind_wms_Object_GoodsByGoodsKind

DROP FUNCTION IF EXISTS lpInsertFind_wms_Object_GoodsByGoodsKind (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpInsertFind_wms_Object_GoodsByGoodsKind(
    IN inGoodsId            Integer, -- *
    IN inGoodsKindId        Integer, -- *
    IN inSession            TVarChar -- сессия пользователя
)
RETURNS TABLE (ObjectId     Integer
             , sku_id_Sh    TVarChar
             , sku_id_Nom   TVarChar
             , sku_id_Ves   TVarChar
             , sku_code_Sh  TVarChar
             , sku_code_Nom TVarChar
             , sku_code_Ves TVarChar
              )
AS
$BODY$
   DECLARE vbObjectId      Integer;
   DECLARE vb_sku_id_Sh    TVarChar;
   DECLARE vb_sku_id_Nom   TVarChar;
   DECLARE vb_sku_id_Ves   TVarChar;
   DECLARE vb_sku_code_Sh  TVarChar;
   DECLARE vb_sku_code_Nom TVarChar;
   DECLARE vb_sku_code_Ves TVarChar;
BEGIN

     -- проверка
     IF COALESCE (inGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не определено значение <inGoodsId>.';
     END IF;
     -- проверка
     IF COALESCE (inGoodsKindId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не определено значение <inGoodsKindId>.';
     END IF;


     -- Находим по св-вам
     SELECT Object_GoodsByGoodsKind.ObjectId
          , Object_GoodsByGoodsKind.sku_id_Sh
          , Object_GoodsByGoodsKind.sku_id_Nom
          , Object_GoodsByGoodsKind.sku_id_Ves
          , Object_GoodsByGoodsKind.sku_code_Sh
          , Object_GoodsByGoodsKind.sku_code_Nom
          , Object_GoodsByGoodsKind.sku_code_Ves
            INTO vbObjectId
               , vb_sku_id_Sh
               , vb_sku_id_Nom
               , vb_sku_id_Ves
               , vb_sku_code_Sh
               , vb_sku_code_Nom
               , vb_sku_code_Ves
     FROM wms_Object_GoodsByGoodsKind AS Object_GoodsByGoodsKind
     WHERE Object_GoodsByGoodsKind.GoodsId     = inGoodsId
       AND Object_GoodsByGoodsKind.GoodsKindId = inGoodsKindId
      ;


     -- Если не нашли
     IF COALESCE (vbObjectId, 0) = 0
     THEN
         -- сохранили
         PERFORM gpInsertUpdate_wms_Object_GoodsByGoodsKind (inSession);

         -- Еще раз - Находим по св-вам
         SELECT Object_GoodsByGoodsKind.ObjectId
              , Object_GoodsByGoodsKind.sku_id_Sh
              , Object_GoodsByGoodsKind.sku_id_Nom
              , Object_GoodsByGoodsKind.sku_id_Ves
              , Object_GoodsByGoodsKind.sku_code_Sh
              , Object_GoodsByGoodsKind.sku_code_Nom
              , Object_GoodsByGoodsKind.sku_code_Ves
                INTO vbObjectId
                   , vb_sku_id_Sh
                   , vb_sku_id_Nom
                   , vb_sku_id_Ves
                   , vb_sku_code_Sh
                   , vb_sku_code_Nom
                   , vb_sku_code_Ves
         FROM wms_Object_GoodsByGoodsKind AS Object_GoodsByGoodsKind
         WHERE Object_GoodsByGoodsKind.GoodsId     = inGoodsId
           AND Object_GoodsByGoodsKind.GoodsKindId = inGoodsKindId
          ;

        -- Если не нашли
        IF COALESCE (vbObjectId, 0) = 0
        THEN
            RAISE EXCEPTION 'Ошибка.Не нашли в wms_Object_GoodsByGoodsKind : <% (%)> + <% (%)>'
                          , lfGet_Object_ValueData (inGoodsId)
                          , inGoodsId
                          , lfGet_Object_ValueData_sh (inGoodsKindId)
                          , inGoodsKindId
                           ;
        END IF;

     END IF;


     -- Результат - 1 запись
     RETURN QUERY
       SELECT vbObjectId
            , vb_sku_id_Sh
            , vb_sku_id_Nom
            , vb_sku_id_Ves
            , vb_sku_code_Sh
            , vb_sku_code_Nom
            , vb_sku_code_Ves
             ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.08.19                                        *
*/

-- тест
-- SELECT * FROM lpInsertFind_wms_Object_GoodsByGoodsKind ();
