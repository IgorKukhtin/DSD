-- Function: lpGet_ObjectHistory_PriceListItem ()

DROP FUNCTION IF EXISTS lpGet_ObjectHistory_PriceListItem (TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpGet_ObjectHistory_PriceListItem(
    IN inOperDate           TDateTime , -- Äàòà äåéñòâèÿ
    IN inPriceListId        Integer   , -- êëþ÷ 
    IN inGoodsId            Integer     -- Òîâàð
)                              
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , StartDate TDateTime, EndDate TDateTime
             , ValuePrice TFloat
              )
AS
$BODY$
BEGIN

       -- Âûáèðàåì äàííûå
       RETURN QUERY 
         WITH tmpData AS (SELECT ObjectHistory_PriceListItem.Id
                               , ObjectLink_PriceListItem_Goods.ChildObjectId AS GoodsId
                               , Object_Goods.ObjectCode AS GoodsCode
                               , Object_Goods.ValueData AS GoodsName
                    
                               , ObjectHistory_PriceListItem.StartDate
                               , ObjectHistory_PriceListItem.EndDate
                               , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice
                    
                          FROM ObjectLink AS ObjectLink_PriceListItem_Goods
                               INNER JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                     ON ObjectLink_PriceListItem_PriceList.ObjectId = ObjectLink_PriceListItem_Goods.ObjectId
                                                    AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
                                                    AND ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                               LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_PriceListItem_Goods.ChildObjectId
                  
                               LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                       ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                      AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                                      AND inOperDate >= ObjectHistory_PriceListItem.StartDate AND inOperDate < ObjectHistory_PriceListItem.EndDate
                               LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                            ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                           AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                    
                          WHERE ObjectLink_PriceListItem_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
                            AND ObjectLink_PriceListItem_Goods.ChildObjectId = inGoodsId
                         )
         -- Ðåçóëüòàò
         SELECT tmpData.Id
              , tmpData.GoodsId
              , tmpData.GoodsCode
              , tmpData.GoodsName
                  
              , tmpData.StartDate
              , tmpData.EndDate
              , tmpData.ValuePrice
         FROM tmpData
        ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 13.11.20         *
 16.05.15                                        *
*/

-- òåñò
-- SELECT * FROM lpGet_ObjectHistory_PriceListItem (CURRENT_TIMESTAMP, zc_PriceList_Basis(), 0)
