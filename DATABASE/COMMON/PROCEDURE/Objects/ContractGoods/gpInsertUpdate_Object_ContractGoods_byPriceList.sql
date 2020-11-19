-- Function: gpInsertUpdate_Object_ContractGoods_byPriceList  ()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractGoods_byPriceList(Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ContractGoods_byPriceList(
    IN inContractId        Integer   ,    --   
    IN inPriceListId       Integer   ,    --   
    IN inSession           TVarChar       -- сессия пользователя
)
 RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStartDate TDateTime;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ContractGoods());
   
   IF COALESCE (inContractId,0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка. Не выбран Договор';
   END IF;

   IF COALESCE (inPriceListId,0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка. Не выбран прайс лист';
   END IF;

   --Записываем свойство договора  zc_ObjectLink_Contract_PriceListGoods
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Contract_PriceListGoods(), inContractId, inPriceListId);
   
   -- дата начала договора
   vbStartDate := (SELECT ObjectDate_Start.ValueData
                   FROM ObjectDate AS ObjectDate_Start
                   WHERE ObjectDate_Start.ObjectId = inContractId
                     AND ObjectDate_Start.DescId = zc_ObjectDate_Contract_Start()
                   );

   -- выбираем данные из спр. ContractTradeMark 
   CREATE TEMP TABLE tmpContractTradeMark ON COMMIT DROP AS (
          SELECT ObjectLink_ContractTradeMark_TradeMark.ChildObjectId  AS TradeMarkId
          FROM ObjectLink AS ObjectLink_ContractTradeMark_Contract
               INNER JOIN ObjectLink AS ObjectLink_ContractTradeMark_TradeMark
                                     ON ObjectLink_ContractTradeMark_TradeMark.ObjectId = ObjectLink_ContractTradeMark_Contract.ObjectId
                                    AND ObjectLink_ContractTradeMark_TradeMark.DescId = zc_ObjectLink_ContractTradeMark_TradeMark()
          WHERE ObjectLink_ContractTradeMark_Contract.DescId = zc_ObjectLink_ContractTradeMark_Contract()
            AND ObjectLink_ContractTradeMark_Contract.ChildObjectId = inContractId
          );
   
   
   -- выбираем последние цены из прайслиста
   CREATE TEMP TABLE tmpPrice ON COMMIT DROP AS (
          SELECT ObjectLink_PriceListItem_Goods.ChildObjectId     AS GoodsId
               , ObjectLink_PriceListItem_GoodsKind.ChildObjectId AS GoodsKindId
               , ObjectHistoryFloat_PriceListItem_Value.ValueData AS Price
          FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
               LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                    ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                   AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()

               LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                    ON ObjectLink_Goods_TradeMark.ObjectId = ObjectLink_PriceListItem_Goods.ChildObjectId
                                   AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
               -- ограничиваем товары торговой маркой
               INNER JOIN tmpContractTradeMark ON tmpContractTradeMark.TradeMarkId = ObjectLink_Goods_TradeMark.ChildObjectId

               LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                    ON ObjectLink_PriceListItem_GoodsKind.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                   AND ObjectLink_PriceListItem_GoodsKind.DescId   = zc_ObjectLink_PriceListItem_GoodsKind()

               LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                       ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                      AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                      AND ObjectHistory_PriceListItem.EndDate = zc_DateEnd()
               LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                            ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                           AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                                           
          WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
            AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId --2707438  --
        --  limit 5
          );

   --получаем уже сохраненные данные ContractGoods, последние
   CREATE TEMP TABLE tmpContractGoods ON COMMIT DROP AS (
          SELECT Object_ContractGoods.Id
               , ContractGoods_Contract.ChildObjectId             AS ContractId
               , ObjectLink_Contract_PriceList.ChildObjectId      AS PriceListId
               , ObjectLink_ContractGoods_Goods.ChildObjectId     AS GoodsId
               , ObjectLink_ContractGoods_GoodsKind.ChildObjectId AS GoodsKindId
               , ObjectDate_Start.ValueData          ::TDateTime  AS StartDate
               , ObjectDate_End.ValueData            ::TDateTime  AS EndDate
               , ObjectFloat_Price.ValueData                      AS Price
          FROM Object AS Object_ContractGoods
               INNER JOIN ObjectLink AS ContractGoods_Contract
                                     ON ContractGoods_Contract.ObjectId = Object_ContractGoods.Id
                                    AND ContractGoods_Contract.DescId = zc_ObjectLink_ContractGoods_Contract()
                                    AND ContractGoods_Contract.ChildObjectId = inContractId

               INNER JOIN ObjectLink AS ObjectLink_Contract_PriceList
                                     ON ObjectLink_Contract_PriceList.ObjectId = ContractGoods_Contract.ChildObjectId
                                    AND ObjectLink_Contract_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
                                    AND ObjectLink_Contract_PriceList.ChildObjectId = inPriceListId

               LEFT JOIN ObjectLink AS ObjectLink_ContractGoods_Goods
                                    ON ObjectLink_ContractGoods_Goods.ObjectId = Object_ContractGoods.Id
                                   AND ObjectLink_ContractGoods_Goods.DescId = zc_ObjectLink_ContractGoods_Goods()

               LEFT JOIN ObjectLink AS ObjectLink_ContractGoods_GoodsKind
                                    ON ObjectLink_ContractGoods_GoodsKind.ObjectId = Object_ContractGoods.Id
                                   AND ObjectLink_ContractGoods_GoodsKind.DescId = zc_ObjectLink_ContractGoods_GoodsKind()

               LEFT JOIN ObjectDate AS ObjectDate_Start
                                    ON ObjectDate_Start.ObjectId = Object_ContractGoods.Id
                                   AND ObjectDate_Start.DescId = zc_ObjectDate_ContractGoods_Start()
               LEFT JOIN ObjectDate AS ObjectDate_End
                                    ON ObjectDate_End.ObjectId = Object_ContractGoods.Id
                                   AND ObjectDate_End.DescId = zc_ObjectDate_ContractGoods_End()

               LEFT JOIN ObjectFloat AS ObjectFloat_Price
                                     ON ObjectFloat_Price.ObjectId = Object_ContractGoods.Id 
                                    AND ObjectFloat_Price.DescId = zc_ObjectFloat_ContractGoods_Price() 

          WHERE Object_ContractGoods.DescId = zc_Object_ContractGoods()
            AND (Object_ContractGoods.isErased = FALSE)
            AND COALESCE (ObjectDate_End.ValueData, zc_DateEnd()) = zc_DateEnd()
   );

   --если для товара/вида товара уже есть цена, нужно проставить дату окончания
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ContractGoods_End(), tmpContractGoods.Id, CURRENT_DATE - INTERVAL '1 DAY')
   FROM tmpContractGoods
        INNER JOIN tmpPrice ON tmpPrice.GoodsId = tmpContractGoods.GoodsId
                           AND COALESCE (tmpPrice.GoodsKindId,0) = COALESCE (tmpContractGoods.GoodsKindId,0)
                           AND tmpPrice.Price <> tmpContractGoods.Price;

   --записываем новые записи, если такого эл. не было нач.цена = дате нач. договора
   PERFORM lpInsertUpdate_Object_ContractGoods(ioId          := 0                    :: Integer
                                             , inCode        := lfGet_ObjectCode(0, zc_Object_ContractGoods()) ::Integer
                                             , inContractId  := inContractId
                                             , inGoodsId     := tmpPrice.GoodsId
                                             , inGoodsKindId := tmpPrice.GoodsKindId ::Integer
                                             , inStartDate   := CASE WHEN COALESCE (tmpContractGoods.Id,0) <> 0 THEN CURRENT_DATE ELSE vbStartDate END ::TDateTime    --
                                             , inEndDate     :=  zc_DateEnd()        ::TDateTime    --
                                             , inPrice       := tmpPrice.Price       ::Tfloat    
                                             , inUserId      := vbUserId
                                              )
   FROM tmpPrice
        LEFT JOIN tmpContractGoods ON tmpContractGoods.GoodsId = tmpPrice.GoodsId
                                  AND COALESCE (tmpContractGoods.GoodsKindId,0) = COALESCE (tmpPrice.GoodsKindId,0)
   WHERE (tmpPrice.Price <> tmpContractGoods.Price OR tmpContractGoods.Id IS NULL)
      AND COALESCE (tmpPrice.Price,0) <> 0;
   


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.11.20         *
*/

-- тест
--