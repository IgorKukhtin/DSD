-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TFloat, Integer, Integer, Integer,Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TFloat, Integer, Integer, Integer,Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, Integer, Integer, Integer,Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, Integer, Integer, Integer,Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, Integer, Integer, Integer,Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, Boolean, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods(
 INOUT ioId                  Integer   , -- ключ объекта <Товар>
    IN inCode                Integer   , -- Код объекта <Товар>
    IN inName                TVarChar  , -- Название объекта <Товар>
    IN inShortName           TVarChar  , -- краткое Название 
    IN inComment             TVarChar  , --
    --IN inName_BUH            TVarChar  , -- Название БУХГ
    IN inWeight              TFloat    , -- Вес
    IN inWeightTare          TFloat    , -- Вес втулки/тары
    IN inCountForWeight      TFloat    , -- кол для веса
    IN inGoodsGroupId        Integer   , -- ссылка на группу Товаров
    IN inGroupStatId         Integer   , -- ссылка на группу Товаров (статистика)   
    IN inMeasureId           Integer   , -- ссылка на единицу измерения
    IN inTradeMarkId         Integer   , -- ***Торговая марка
    IN inInfoMoneyId         Integer   , -- ***УП статья назначения
    IN inBusinessId          Integer   , -- Бизнесы
    IN inFuelId              Integer   , -- Вид топлива
    IN inGoodsTagId          Integer   , -- ***Признак товара
    IN inGoodsGroupAnalystId Integer   , -- ***Группа аналитики
    IN inGoodsGroupPropertyId  Integer   , --Аналитический классификатор 
    IN inGoodsGroupDirectionId Integer   , --Аналитическая группа Направление
    IN inPriceListId         Integer   , -- прайс
    IN inStartDate           TDateTime , -- дата прайса
    --IN inDate_BUH            TDateTime , -- Дата до которой действует Название товара(бухг.)
    IN inValuePrice          TFloat    , -- значение цены   
    IN inisHeadCount         Boolean   , -- Проверка Количество голов 
    IN inisPartionDate       Boolean   , -- Учет по дате партии
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;   
   DECLARE vbGroupNameFull TVarChar;   
   DECLARE vbIsUpdate Boolean;  
   DECLARE vbGoodsPlatformId Integer; -- ***Производственная площадка
   DECLARE vbIsAsset Boolean;

BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Goods());
   
   -- !!! Если код не установлен, определяем его как последний+1 (!!! ПОТОМ НАДО БУДЕТ ЭТО ВКЛЮЧИТЬ !!!)
   -- vbCode:=lfGet_ObjectCode (inCode, zc_Object_Goods());
   vbCode:=inCode;
   
   -- проверка уникальности <Код>
   IF vbCode <> 0 THEN PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Goods(), vbCode); END IF;
   -- !!! проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Goods(), inName);

   -- проверка <inName>
   IF TRIM (COALESCE (inName, '')) = ''
   THEN
       RAISE EXCEPTION 'Ошибка.Значение <Название> должно быть установлено.';
   END IF;

   -- проверка <GoodsGroupId>
   IF COALESCE (inGoodsGroupId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Значение <Группа товаров> должно быть установлено.';
   END IF;
   -- проверка <Measure>
   IF COALESCE (inMeasureId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Значение <Единица измерения> должно быть установлено.';
   END IF;
   -- проверка <Measure>
   IF inMeasureId = zc_Measure_Sh() AND COALESCE (inWeight, 0) <= 0
   THEN
       RAISE EXCEPTION 'Ошибка.Для единицы измерения <%> должно быть установлено значение <Вес>.', lfGet_Object_ValueData (inMeasureId);
   END IF;

   -- из ближайшей группы где установлено <УП статья назначения>
   inInfomoneyId:= lfGet_Object_GoodsGroup_InfomoneyId (inGoodsGroupId);
   -- проверка <InfoMoneyId>
   IF COALESCE (inInfomoneyId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Значение <УП статья назначения> не найдена для группы <%>.', lfGet_Object_ValueData (inGoodsGroupId);
   END IF;
   -- из ближайшей группы где установлено <Торговая марка>
   inTradeMarkId:= lfGet_Object_GoodsGroup_TradeMarkId (inGoodsGroupId);
   -- из ближайшей группы где установлено <Признак товара>
   inGoodsTagId:= lfGet_Object_GoodsGroup_GoodsTagId (inGoodsGroupId);
   -- из ближайшей группы где установлено <Группа аналитики>
   inGoodsGroupAnalystId:= lfGet_Object_GoodsGroup_GoodsGroupAnalystId (inGoodsGroupId);
   -- из ближайшей группы где установлено <Производственная площадка>
   vbGoodsPlatformId:= lfGet_Object_GoodsGroup_GoodsPlatformId (inGoodsGroupId);
   -- из ближайшей группы где установлено <Производственная площадка>
   vbIsAsset:= lfGet_Object_GoodsGroup_isAsset (inGoodsGroupId);
   

   -- расчетно свойство <Полное название группы>
   vbGroupNameFull:= lfGet_Object_TreeNameFull (inGoodsGroupId, zc_ObjectLink_GoodsGroup_Parent());

   -- определили <Признак>
   vbIsUpdate:= COALESCE (ioId, 0) > 0;
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Goods(), vbCode, inName
                                , inAccessKeyId:= CASE WHEN inFuelId <> 0 AND NOT EXISTS (SELECT 1 FROM ObjectLink WHERE DescId = zc_ObjectLink_TicketFuel_Goods() AND ChildObjectId = ioId)
                                                            THEN zc_Enum_Process_AccessKey_TrasportAll()
                                                  END);

   -- сохранили свойство <Полное название группы>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_GroupNameFull(), ioId, vbGroupNameFull);

   -- сохранили свойство <Название БУХГ>
   --PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_BUH(), ioId, inName_BUH);
   -- сохранили свойство <Дата до которой действует Название товара(бухг.)>
   --PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Goods_BUH(), ioId, inDate_BUH);
   
   -- сохранили свойство <Вес>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_Weight(), ioId, inWeight);
   -- сохранили свойство <Вес>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_WeightTare(), ioId, inWeightTare);
   -- сохранили свойство <кол для Веса>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_CountForWeight(), ioId, inCountForWeight);
      
   -- сохранили связь с <Группой товара>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroup(), ioId, inGoodsGroupId);
   -- сохранили связь с <Группой товара(статистика)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroupStat(), ioId, inGroupStatId);
   -- сохранили связь с <Единицей измерения>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Measure(), ioId, inMeasureId);
   -- сохранили вязь с <Бизнесы>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Business(), ioId, inBusinessId);
   -- сохранили связь с <Вид топлива>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Fuel(), ioId, inFuelId);

   -- сохранили связь с ***<УП статья назначения>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_InfoMoney(), ioId, inInfomoneyId);
   -- сохранили связь с ***<Торговая марка>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_TradeMark(), ioId, inTradeMarkId);
   -- сохранили связь с ***<Признак товара>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsTag(), ioId, inGoodsTagId);
   -- сохранили связь с ***<Группа аналитики>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroupAnalyst(), ioId, inGoodsGroupAnalystId); 
   -- сохранили связь с < Аналитический классификатор>              
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroupProperty(), ioId, inGoodsGroupPropertyId); 
   
   -- сохранили связь с <>              
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroupDirection(), ioId, inGoodsGroupDirectionId);
   
   -- изменили свойство ***<Производственная площадка>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsPlatform(), ioId, vbGoodsPlatformId);
   
   -- изменили свойство <Признак - ОС>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_Asset(), ioId, vbIsAsset);
   

   -- сохранили свойство
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_ShortName(), ioId, inShortName);

   -- сохранили свойство
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_Comment(), ioId, inComment);

   -- сохранили свойство
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_HeadCount(), ioId, inisHeadCount);
   -- сохранили свойство
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_PartionDate(), ioId, inisPartionDate);

   
   IF inValuePrice <> 0 AND inPriceListId <> 0
      AND ((vbIsUpdate = FALSE) OR NOT EXISTS (SELECT 1 FROM gpSelect_ObjectHistory_PriceListGoodsItem (inPriceListId:= inPriceListId, inGoodsId:= ioId, inGoodsKindId:= 0, inSession := inSession) as tmp LIMIT 1))
   THEN
       PERFORM lpInsertUpdate_ObjectHistory_PriceListItem (ioId := 0
                                                         , inPriceListId := inPriceListId
                                                         , inGoodsId     := ioId
                                                         , inGoodsKindId := 0
                                                         , inOperDate    := inStartDate
                                                         , inValue       := inValuePrice
                                                         , inUserId      := vbUserId
                                                          );
   END IF;
  


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_Goods (Integer, Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;
 
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.01.25         * inisPartionDate
 12.11.24         * inisHeadCount
 18.10.24         * inComment
 22.08.24         *
 19.12.23         *
 30.06.22         *
 04.08.21         *
 23.10.19         * CountForWeight
 09.10.19         * inWeightTare
 24.11.14         * add inGoodsGroupAnalystId
 15.09.14         * add inGoodsTagId
 04.09.14         * add inGroupStatId
 13.01.14                                        * add vbGroupNameFull
 14.12.13                                        * add inAccessKeyId
 20.10.13                                        * vbCode:=0
 29.09.13                                        * add zc_ObjectLink_Goods_Fuel
 01.09.13                                        * add zc_ObjectLink_Goods_Business
 30.06.13                                        * add vb
 20.06.13          * vbCode:=lpGet_ObjectCode (inCode, zc_Object_Goods());
 16.06.13                                        * IF COALESCE (inCode, 0) = 0  THEN Code_max := NULL ...
 11.06.13          *
 11.05.13                                        * rem lpCheckUnique_Object_ValueData
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Goods (ioId:=0, inCode:=-1, inName:= 'TEST-GOODS', ... , inSession:= '2')
