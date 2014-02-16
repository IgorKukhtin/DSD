-- Function: lfSelect_ObjectHistory_PriceListItem ()

-- DROP FUNCTION lfSelect_ObjectHistory_PriceListItem (Integer, TDateTime);

CREATE OR REPLACE FUNCTION lfSelect_ObjectHistory_PriceListItem(
    IN inPriceListId        Integer   , -- ���� 
    IN inOperDate           TDateTime   -- ���� ��������
)                              
RETURNS TABLE (Id Integer, GoodsId Integer, StartDate TDateTime, EndDate TDateTime, ValuePrice TFloat)
AS
$BODY$
BEGIN

     -- �������� ������
     RETURN QUERY 
       SELECT
             ObjectHistory_PriceListItem.Id
           , ObjectLink_PriceListItem_Goods.ChildObjectId AS GoodsId

           , ObjectHistory_PriceListItem.StartDate
           , ObjectHistory_PriceListItem.EndDate
           , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice

       FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
            LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                 ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()

            LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                    ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                   AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                   AND inOperDate >= ObjectHistory_PriceListItem.StartDate AND inOperDate < ObjectHistory_PriceListItem.EndDate
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                         ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                        AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

       WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
         AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
         AND ObjectHistoryFloat_PriceListItem_Value.ValueData <> 0
       ;

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lfSelect_ObjectHistory_PriceListItem (Integer, TDateTime) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.08.13                                        * !!!� ���� �� ������������!!!
 21.07.13                                        *
*/

-- ����
-- SELECT * FROM lfSelect_ObjectHistory_PriceListItem (zc_PriceList_ProductionSeparate(), CURRENT_TIMESTAMP)
-- SELECT * FROM lfSelect_ObjectHistory_PriceListItem (zc_PriceList_Basis(), CURRENT_TIMESTAMP)
