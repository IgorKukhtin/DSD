-- Function: lpGet_ObjectHistory_DiscountPeriodItem ()

DROP FUNCTION IF EXISTS lpGet_ObjectHistory_DiscountPeriodItem (TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpGet_ObjectHistory_DiscountPeriodItem(
    IN inOperDate           TDateTime , -- Äàòà äåéñòâèÿ
    IN inUnitId             Integer   , -- êëþ÷ 
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
             ObjectHistory_DiscountPeriodItem.Id
           , ObjectLink_DiscountPeriodItem_Goods.ChildObjectId AS GoodsId
           , Object_Goods.ObjectCode AS GoodsCode
           , Object_Goods.ValueData AS GoodsName

           , ObjectHistory_DiscountPeriodItem.StartDate
           , ObjectHistory_DiscountPeriodItem.EndDate
           , ObjectHistoryFloat_DiscountPeriodItem_Value.ValueData AS ValuePrice

       FROM ObjectLink AS ObjectLink_DiscountPeriodItem_Goods
            INNER JOIN ObjectLink AS ObjectLink_DiscountPeriodItem_Unit
                                  ON ObjectLink_DiscountPeriodItem_Unit.ObjectId = ObjectLink_DiscountPeriodItem_Goods.ObjectId
                                 AND ObjectLink_DiscountPeriodItem_Unit.ChildObjectId = inUnitId
                                 AND ObjectLink_DiscountPeriodItem_Unit.DescId = zc_ObjectLink_DiscountPeriodItem_Unit()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_DiscountPeriodItem_Goods.ChildObjectId

            LEFT JOIN ObjectHistory AS ObjectHistory_DiscountPeriodItem
                                    ON ObjectHistory_DiscountPeriodItem.ObjectId = ObjectLink_DiscountPeriodItem_Unit.ObjectId
                                   AND ObjectHistory_DiscountPeriodItem.DescId = zc_ObjectHistory_DiscountPeriodItem()
                                   AND inOperDate >= ObjectHistory_DiscountPeriodItem.StartDate AND inOperDate < ObjectHistory_DiscountPeriodItem.EndDate
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_DiscountPeriodItem_Value
                                         ON ObjectHistoryFloat_DiscountPeriodItem_Value.ObjectHistoryId = ObjectHistory_DiscountPeriodItem.Id
                                        AND ObjectHistoryFloat_DiscountPeriodItem_Value.DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_Value()

       WHERE ObjectLink_DiscountPeriodItem_Goods.DescId = zc_ObjectLink_DiscountPeriodItem_Goods()
         AND ObjectLink_DiscountPeriodItem_Goods.ChildObjectId = inGoodsId
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
-- SELECT * FROM lpGet_ObjectHistory_DiscountPeriodItem (CURRENT_TIMESTAMP, zc_Unit_ProductionSeparate(), 0)
-- SELECT * FROM lpGet_ObjectHistory_DiscountPeriodItem (CURRENT_TIMESTAMP, zc_Unit_Basis(), 0)
