-- Function: lpGet_ObjectHistory_PriceListItem ()

DROP FUNCTION IF EXISTS lpGet_ObjectHistory_PriceListItem (TDateTime, Integer, Integer);
DROP FUNCTION IF EXISTS lpGet_ObjectHistory_PriceListItem (TDateTime, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpGet_ObjectHistory_PriceListItem(
    IN inOperDate           TDateTime , -- ���� ��������
    IN inPriceListId        Integer   , -- ���� 
    IN inGoodsId            Integer   , -- �����
    IN inGoodsKindId        Integer     -- ��� ������
)                              
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , StartDate TDateTime, EndDate TDateTime, ValuePrice TFloat)
AS
$BODY$
BEGIN

       -- �������� ������
       RETURN QUERY 
         WITH tmpData AS (SELECT ObjectHistory_PriceListItem.Id
                               , ObjectLink_PriceListItem_Goods.ChildObjectId AS GoodsId
                               , Object_Goods.ObjectCode AS GoodsCode
                               , Object_Goods.ValueData AS GoodsName
                    
                               , ObjectLink_PriceListItem_GoodsKind.ChildObjectId AS GoodsKindId
                               , Object_GoodsKind.ValueData AS GoodsKindName
                    
                               , ObjectHistory_PriceListItem.StartDate
                               , ObjectHistory_PriceListItem.EndDate
                               , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice
                    
                          FROM ObjectLink AS ObjectLink_PriceListItem_Goods
                               INNER JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                     ON ObjectLink_PriceListItem_PriceList.ObjectId = ObjectLink_PriceListItem_Goods.ObjectId
                                                    AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
                                                    AND ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                               LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_PriceListItem_Goods.ChildObjectId
                    
                               LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                                     ON ObjectLink_PriceListItem_GoodsKind.ObjectId      = ObjectLink_PriceListItem_PriceList.ObjectId
                                                    AND ObjectLink_PriceListItem_GoodsKind.DescId        = zc_ObjectLink_PriceListItem_GoodsKind()
                               LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_PriceListItem_GoodsKind.ChildObjectId
                  
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
         -- ���������
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
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 16.05.15                                        *
*/

-- ����
-- SELECT * FROM lpGet_ObjectHistory_PriceListItem (CURRENT_TIMESTAMP, zc_PriceList_ProductionSeparate(), 0, 1)
-- SELECT * FROM lpGet_ObjectHistory_PriceListItem (CURRENT_TIMESTAMP, zc_PriceList_Basis(), 0, 0)
