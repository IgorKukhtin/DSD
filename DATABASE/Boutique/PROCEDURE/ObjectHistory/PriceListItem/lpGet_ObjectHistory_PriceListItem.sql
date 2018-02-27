-- Function: lpGet_ObjectHistory_PriceListItem ()

DROP FUNCTION IF EXISTS lpGet_ObjectHistory_PriceListItem (TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpGet_ObjectHistory_PriceListItem(
    IN inOperDate           TDateTime , -- Äàòà äåéñòâèÿ
    IN inPriceListId        Integer   , -- êëþ÷ 
    IN inGoodsId            Integer     -- Òîâàð
)                              
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , StartDate TDateTime, EndDate TDateTime
             , ValuePrice TFloat
)
AS
$BODY$
BEGIN

     -- Âûáèðàåì äàííûå
     RETURN QUERY 
       SELECT
             ObjectHistory_PriceListItem.Id AS Id
           , ObjectLink_Goods.ChildObjectId AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , Object_Goods.ValueData         AS GoodsName

           , ObjectHistory_PriceListItem.StartDate
           , ObjectHistory_PriceListItem.EndDate
           , ObjectHistoryFloat_Value.ValueData AS ValuePrice

       FROM ObjectLink AS ObjectLink_Goods
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods.ChildObjectId

            INNER JOIN ObjectLink AS ObjectLink_PriceList
                                  ON ObjectLink_PriceList.ObjectId      = ObjectLink_Goods.ObjectId
                                 AND ObjectLink_PriceList.ChildObjectId = inPriceListId
                                 AND ObjectLink_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()

            LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                    ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_Goods.ObjectId
                                   AND ObjectHistory_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                                   AND inOperDate >= ObjectHistory_PriceListItem.StartDate AND inOperDate < ObjectHistory_PriceListItem.EndDate
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                         ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                        AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

       WHERE ObjectLink_Goods.ChildObjectId = inGoodsId
         AND ObjectLink_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.   Ìàíüêî Ä.
 16.05.15                                        *
*/

-- òåñò
-- SELECT * FROM lpGet_ObjectHistory_PriceListItem (CURRENT_TIMESTAMP, zc_PriceList_ProductionSeparate(), 0)
-- SELECT * FROM lpGet_ObjectHistory_PriceListItem (CURRENT_TIMESTAMP, zc_PriceList_Basis(), 0)
