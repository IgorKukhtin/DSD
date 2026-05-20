-- Function: lpGet_ObjectHistory_PricePlanItem ()

DROP FUNCTION IF EXISTS lpGet_ObjectHistory_PricePlanItem (TDateTime, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpGet_ObjectHistory_PricePlanItem(
    IN inOperDate           TDateTime , -- Äàòà äåéñòâèÿ
    IN inPriceListId        Integer   , -- êëþ÷ 
    IN inGoodsId            Integer   , -- Òîâàð
    IN inGoodsKindId        Integer     -- Âèä òîâàðà
)                              
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , StartDate TDateTime, EndDate TDateTime, ValuePrice TFloat)
AS
$BODY$
BEGIN

       -- Âûáèðàåì äàííûå
       RETURN QUERY 
         WITH tmpData AS (SELECT ObjectHistory_PricePlanItem.Id
                               , ObjectLink_PricePlanItem_Goods.ChildObjectId AS GoodsId
                               , Object_Goods.ObjectCode AS GoodsCode
                               , Object_Goods.ValueData AS GoodsName
                    
                               , ObjectLink_PricePlanItem_GoodsKind.ChildObjectId AS GoodsKindId
                               , Object_GoodsKind.ValueData AS GoodsKindName
                    
                               , ObjectHistory_PricePlanItem.StartDate
                               , ObjectHistory_PricePlanItem.EndDate
                               , ObjectHistoryFloat_PricePlanItem_Value.ValueData AS ValuePrice
                    
                          FROM ObjectLink AS ObjectLink_PricePlanItem_Goods
                               INNER JOIN ObjectLink AS ObjectLink_PricePlanItem_PriceList
                                                     ON ObjectLink_PricePlanItem_PriceList.ObjectId = ObjectLink_PricePlanItem_Goods.ObjectId
                                                    AND ObjectLink_PricePlanItem_PriceList.ChildObjectId = inPriceListId
                                                    AND ObjectLink_PricePlanItem_PriceList.DescId = zc_ObjectLink_PricePlanItem_PriceList()
                               LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_PricePlanItem_Goods.ChildObjectId
                    
                               LEFT JOIN ObjectLink AS ObjectLink_PricePlanItem_GoodsKind
                                                     ON ObjectLink_PricePlanItem_GoodsKind.ObjectId      = ObjectLink_PricePlanItem_PriceList.ObjectId
                                                    AND ObjectLink_PricePlanItem_GoodsKind.DescId        = zc_ObjectLink_PricePlanItem_GoodsKind()
                               LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_PricePlanItem_GoodsKind.ChildObjectId
                  
                               LEFT JOIN ObjectHistory AS ObjectHistory_PricePlanItem
                                                       ON ObjectHistory_PricePlanItem.ObjectId = ObjectLink_PricePlanItem_PriceList.ObjectId
                                                      AND ObjectHistory_PricePlanItem.DescId = zc_ObjectHistory_PricePlanItem()
                                                      AND inOperDate >= ObjectHistory_PricePlanItem.StartDate AND inOperDate < ObjectHistory_PricePlanItem.EndDate
                               LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PricePlanItem_Value
                                                            ON ObjectHistoryFloat_PricePlanItem_Value.ObjectHistoryId = ObjectHistory_PricePlanItem.Id
                                                           AND ObjectHistoryFloat_PricePlanItem_Value.DescId = zc_ObjectHistoryFloat_PricePlanItem_Value()
                    
                          WHERE ObjectLink_PricePlanItem_Goods.DescId        = zc_ObjectLink_PricePlanItem_Goods()
                            AND ObjectLink_PricePlanItem_Goods.ChildObjectId = inGoodsId
                         )
         -- Ðåçóëüòàò
         SELECT tmpData.Id
              , tmpData.GoodsId
              , tmpData.GoodsCode
              , tmpData.GoodsName
              , tmpData.GoodsKindId
              , tmpData.GoodsKindName
                  
              , tmpData.StartDate
              , tmpData.EndDate
              , tmpData.ValuePrice
         FROM tmpData
         WHERE tmpData.GoodsKindId = inGoodsKindId
        UNION
         SELECT tmpData.Id
              , tmpData.GoodsId
              , tmpData.GoodsCode
              , tmpData.GoodsName
              , tmpData.GoodsKindId
              , tmpData.GoodsKindName
                  
              , tmpData.StartDate
              , tmpData.EndDate
              , tmpData.ValuePrice
         FROM tmpData
              LEFT JOIN tmpData AS tmpData_kind ON tmpData_kind.GoodsKindId = inGoodsKindId
         WHERE tmpData.GoodsKindId IS NULL
           AND tmpData_kind.GoodsKindId IS NULL
        ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 18.05.26         *
*/

-- òåñò
-- SELECT * FROM lpGet_ObjectHistory_PricePlanItem (CURRENT_TIMESTAMP, zc_PriceList_ProductionSeparate(), 0, 1)
-- SELECT * FROM lpGet_ObjectHistory_PricePlanItem (CURRENT_TIMESTAMP, zc_PriceList_Basis(), 0, 0)
