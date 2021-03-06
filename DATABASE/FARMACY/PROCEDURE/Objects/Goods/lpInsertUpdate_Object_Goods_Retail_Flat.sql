-- Function: lpInsertUpdate_Object_Goods_Retail_Flat()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods_Retail_Flat (Integer, TVarChar, TVarChar, Integer, Integer, Integer, TFloat, Integer, TFloat, TFloat, Boolean, Boolean, TFloat, TVarChar, TVarChar, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods_Retail_Flat (Integer, TVarChar, TVarChar, Integer, Integer, Integer, TFloat, Integer, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, TFloat, TVarChar, TVarChar, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Goods_Retail_Flat(
 INOUT ioId                  Integer   ,    -- ключ объекта <Товар>
    IN inCode                TVarChar  ,    -- Код объекта <Товар>
    IN inName                TVarChar  ,    -- Название объекта <Товар>
    IN inGoodsGroupId        Integer   ,    -- группы товаров
    IN inMeasureId           Integer   ,    -- ссылка на единицу измерения
    IN inNDSKindId           Integer   ,    -- НДС
    IN inMinimumLot          TFloat    ,    -- Групповая упаковка
    IN inReferCode           Integer   ,    -- Код для стыковки спецпроекта
    IN inReferPrice          TFloat    ,    -- Референтная цена упаковки
    IN inPrice               TFloat    ,    -- Цена реализации
    IN inIsClose             Boolean   ,    -- Код закрыт
    IN inTOP                 Boolean   ,    -- ТОП - позиция
    IN inisSun_v3            Boolean   ,    -- Работают по Э-СУН
    IN inKoeffSUN_v3	     TFloat    ,    -- Кратность по Э-СУН
    IN inPercentMarkup	     TFloat    ,    -- % наценки
    IN inNameUkr             TVarChar  ,    -- Название украинское
    IN inCodeUKTZED          TVarChar  ,    -- Код УКТЗЭД
    IN inExchangeId          Integer   ,    -- Од:
    IN inObjectId            Integer   ,    --
    IN inUserId              Integer        -- Пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbObjectId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbGoodsMainID Integer;
BEGIN
     -- определяется <Торговая сеть>
     vbObjectId := lpGet_DefaultValue('zc_Object_Retail', inUserId);

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Товар Торговой сети>
     ioId:= lpInsertUpdate_Object_Goods (ioId, inCode, inName, inGoodsGroupId, inMeasureId, inNDSKindId, inObjectId, inUserId, 0, '',
                                         True, 0, inNameUkr, inCodeUKTZED, inExchangeId
                                       --, CASE WHEN inUserId = 3 THEN FALSE ELSE TRUE END -- !!!только когда руками новую сеть!!!
                                        );

       -- Находим главный товар
     SELECT Object_Goods_Retail.GoodsMainID
     INTO vbGoodsMainID
     FROM Object_Goods_Retail
     WHERE Object_Goods_Retail.ID = ioId;

     IF COALESCE (vbGoodsMainID, 0) = 0
     THEN
--       RAISE EXCEPTION 'По коду товара <%> не не найден главный товар.', inCode;
         PERFORM lpAddObject_Goods_Temp_Error('lpInsertUpdate_Object_Goods_Retail_Flat',
           Format('По коду товара <%s> не не найден главный товар.', inCode) , inUserId);
     END IF;

     -- !!!замена!!!
     IF inMinimumLot = 0 THEN inMinimumLot := NULL; END IF;

       -- Изменяем поля в главном товаре
     UPDATE Object_Goods_Main SET ObjectCode       = inCode::Integer
                                , Name             = inName
                                , GoodsGroupID     = inGoodsGroupId
                                , MeasureID        = inMeasureId
                                , NDSKindID        = inNDSKindId
                                , ReferCode        = inReferCode
                                , ReferPrice       = inReferPrice
                                , IsClose          = inIsClose
                                , NameUkr          = inNameUkr
                                , CodeUKTZED       = inCodeUKTZED
                                , ExchangeId       = inExchangeId
                                , DateUpdateClose  = CASE WHEN IsClose = inIsClose THEN DateUpdateClose ELSE CURRENT_TIMESTAMP END
     WHERE Object_Goods_Main.ID = vbGoodsMainID;


     -- !!!только для торговой сети vbObjectId!!!
     IF vbObjectId = inObjectId
     THEN
         -- Изменяем поля в товаре сети
         UPDATE Object_Goods_Retail SET MinimumLot      = inMinimumLot
                                      , PercentMarkup   = inPercentMarkup
                                      , Price           = inPrice
                                      , isTOP           = inTOP
                                      , UserUpdateID    = inUserId
                                      , DateUpdate      = CURRENT_TIMESTAMP
                                      , isSun_v3        = inisSun_v3
                                      , KoeffSUN_v3     = inKoeffSUN_v3
         WHERE Object_Goods_Retail.ID = ioId;
     END IF;

/*     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (ioId, inUserId);
*/

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION lpInsertUpdate_Object_Goods_Retail_Flat (Integer, TVarChar, TVarChar, Integer, Integer, Integer, TFloat, Integer, TFloat, TFloat, Boolean, Boolean, TFloat, TVarChar, TVarChar, Integer, Integer, Integer) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 15.10.19                                                       *
*/
/*
  SELECT * FROM lpInsertUpdate_Object_Goods_Retail_Flat (ioId             :=  30502
                                                       , inCode           :=  '6'
                                                       , inName           :=  'Лаферон фл 1млн ЕД N5 '
                                                       , inGoodsGroupId   :=  394770
                                                       , inMeasureId      :=  323
                                                       , inNDSKindId      :=  9
                                                       , inMinimumLot     :=  Null
                                                       , inReferCode      := 0
                                                       , inReferPrice     := 0
                                                       , inPrice          :=  Null
                                                       , inIsClose        :=  False
                                                       , inTOP            :=  False
                                                       , inPercentMarkup  :=  Null
                                                       , inNameUkr        := ''
                                                       , inCodeUKTZED     := ''
                                                       , inExchangeId     :=  0
                                                       , inObjectId       :=  59610
                                                       , inUserId         :=  3)


select GoodsGroupId, * from Object_Goods_Retail
    left outer join Object_Goods_Main on Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainID
where Object_Goods_Retail.ID = 30502

select * from Object_Goods_View  where ID =   30502
*/
-- тест
-- SELECT * FROM lpInsertUpdate_Object_Goods_Retail_Flat
