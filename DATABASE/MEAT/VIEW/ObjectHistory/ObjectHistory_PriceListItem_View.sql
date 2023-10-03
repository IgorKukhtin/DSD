-- View: ObjectHistory_PriceListItem_View

DROP VIEW IF EXISTS ObjectHistory_PriceListItem_View; -- CASCADE;

CREATE OR REPLACE VIEW ObjectHistory_PriceListItem_View AS
   SELECT ObjectLink_PriceListItem_PriceList.ChildObjectId AS PriceListId
        , ObjectLink_PriceListItem_Goods.ChildObjectId     AS GoodsId
        , COALESCE (ObjectLink_PriceListItem_GoodsKind.ChildObjectId, 0) AS GoodsKindId
        , ObjectLink_PriceListItem_GoodsKind.ChildObjectId AS GoodsKindId_real
        , ObjectHistory_PriceListItem.StartDate
        , ObjectHistory_PriceListItem.EndDate
        , ObjectHistoryFloat_PriceListItem_Value.ValueData AS Price
   FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
        LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                             ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                            AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
        LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                             ON ObjectLink_PriceListItem_GoodsKind.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                            AND ObjectLink_PriceListItem_GoodsKind.DescId = zc_ObjectLink_PriceListItem_GoodsKind()
        LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                               AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
        LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                     ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                    AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
   WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
  ;

ALTER TABLE ObjectHistory_PriceListItem_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 22.05.14                                        *
*/

-- ÚÂÒÚ
-- SELECT * FROM ObjectHistory_PriceListItem_View
