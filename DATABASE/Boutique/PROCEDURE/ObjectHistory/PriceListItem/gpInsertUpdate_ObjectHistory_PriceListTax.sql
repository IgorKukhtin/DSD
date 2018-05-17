-- Function: gpInsertUpdate_ObjectHistory_PriceListItem()

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListTax(Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListTax(Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListTax(Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_PriceListTax(
    IN inPriceListId                Integer,    -- Прайс-лист результат
    IN inUnitId                     Integer,    -- Подразделение
    IN inGroupGoodsId               Integer,    -- Группа тов.
    IN inBrandId                    Integer,    -- Торг. марка
    IN inPeriodId                   Integer,    -- Сезон
    IN inLineFabricaId              Integer,    -- Линия
    IN inLabelId                    Integer,    -- Название для ценника
    IN inOperDate                   TDateTime,  -- Изменение цены с
    IN inPeriodYear                 TFloat,     -- Год
    IN inTax                        TFloat,     -- коэфф от входной цены
    IN inSession                    TVarChar    -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
DECLARE
   DECLARE vbUserId Integer;
   DECLARE vbPriceListItemId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem());

   -- Проверка
   IF COALESCE (inPriceListId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не определено значение <Прайс-лист>.';
   END IF;

   -- Проверка
   IF inOperDate < DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 MONTH'
   THEN
       RAISE EXCEPTION 'Ошибка.Значение <Изменение цены с...> не может быть раньше чем <%>.', DATE (DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 MONTH');
   END IF;


   -- (т.е. вх цена 100у.е. ввели коэф = 50, новая цена должна быть 5000грн, и так для каждого товра который на остатке в маг или на долге у покупателя по этому маг)

   -- выбираем все товары согл.вх.параметрам
   CREATE TEMP TABLE _tmpGoods (GoodsId Integer, OperPrice TFloat) ON COMMIT DROP;
      INSERT INTO _tmpGoods (GoodsId, OperPrice)
           WITH
           tmpPartionGoods AS (SELECT Object_PartionGoods.MovementItemId  AS PartionId
                                    , Object_PartionGoods.GoodsId         AS GoodsId
                                    , Object_PartionGoods.OperPrice       AS OperPrice
                               FROM Object_PartionGoods
                                    INNER JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                          ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_PartionGoods.GoodsId
                                                         AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                                                         AND ObjectLink_Goods_GoodsGroup.ChildObjectId = inGroupGoodsId

                                    INNER JOIN ObjectLink AS ObjectLink_Goods_LineFabrica
                                                          ON ObjectLink_Goods_LineFabrica.ObjectId = Object_PartionGoods.GoodsId
                                                         AND ObjectLink_Goods_LineFabrica.DescId = zc_ObjectLink_Goods_LineFabrica()
                                                         AND ObjectLink_Goods_LineFabrica.ChildObjectId = inLineFabricaId

                               WHERE Object_PartionGoods.isErased   = FALSE
                                 AND Object_PartionGoods.UnitId     = inUnitId
                                 AND Object_PartionGoods.BrandId    = inBrandId
                                 AND Object_PartionGoods.PeriodId   = inPeriodId
                                 AND Object_PartionGoods.PeriodYear = inPeriodYear
                                 AND Object_PartionGoods.LabelId    = inLabelId
                               )

           -- определяем остаток товара.
           SELECT Container.ObjectId AS GoodsId
                , tmpGoods.OperPrice
           FROM Container
                INNER JOIN (SELECT tmpPartionGoods.*
                            FROM tmpPartionGoods
                            ) AS tmpGoods ON tmpGoods.GoodsId = Container.ObjectId
                                         AND tmpGoods.PartionId = Container.PartionId
           WHERE Container.DescId = zc_Container_Count()
             AND Container.WhereObjectId = inUnitId
             AND Container.Amount <> 0
           GROUP BY Container.ObjectId , tmpGoods.OperPrice
           HAVING SUM (Container.Amount) <> 0
           ;

   -- Изменение цен (для каждого товара который на остатке в маг или на долге у покупателя по этому маг будем расчитывать цену)
   PERFORM lpInsertUpdate_ObjectHistory_PriceListItem (ioId          := 0
                                                     , inPriceListId := inPriceListId
                                                     , inGoodsId     := _tmpGoods.GoodsId
                                                     , inOperDate    := inOperDate
                                                                        -- округление без копеек и до +/-50 гривен, т.е. последние цифры или 50 или сотни
                                                     , inValue       := (CEIL ((_tmpGoods.OperPrice * inTax) / 50) * 50) :: TFloat
                                                  -- , inValue       := CAST ((_tmpGoods.OperPrice * inTax) AS NUMERIC (16, 0)) :: TFloat
                                                     , inUserId      := vbUserId
                                                      )

   FROM _tmpGoods;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 12.03.18         * add inLabelId
 01.03.18         *
 21.08.15         *
*/