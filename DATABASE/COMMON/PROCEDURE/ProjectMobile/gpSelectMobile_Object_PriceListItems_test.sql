-- Function: gpSelectMobile_Object_PriceListItems_test (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_PriceListItems_test (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_PriceListItems_test (
    IN inPriceListId  Integer  ,   -- �����-����
    IN inGoodsId      Integer  , -- �����
    IN inSession      TVarChar   -- ������ ������������
)
RETURNS TABLE (Id              Integer
             , GoodsId         Integer   -- �����
             , PriceListId     Integer   -- �����-����
             , ReturnStartDate TDateTime -- ���� � ������� ��������� ���� ��������
             , ReturnEndDate   TDateTime -- ���� �� ������� ��������� ���� ��������
             , ReturnPrice     TFloat    -- ���� ��������
              )
AS 
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbReturnDate TDateTime;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      
      vbReturnDate:= CURRENT_DATE - INTERVAL '14 DAY';


           -- ���������
           RETURN QUERY
                  SELECT Object_PriceListItem.Id
                  , ObjectLink_PriceListItem_Goods.ChildObjectId            AS GoodsId
                  , ObjectLink_PriceListItem_PriceList.ChildObjectId        AS PriceListId
                  , ObjectHistory_PriceListItem_Return.StartDate            AS ReturnStartDate
                  , ObjectHistory_PriceListItem_Return.EndDate              AS ReturnEndDate
                  , ObjectHistoryFloat_PriceListItem_Value_Return.ValueData AS ReturnPrice
             FROM Object AS Object_PriceListItem
                  JOIN ObjectLink AS ObjectLink_PriceListItem_Goods 
                                  ON ObjectLink_PriceListItem_Goods.ObjectId = Object_PriceListItem.Id
                                 AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                                 AND ObjectLink_PriceListItem_Goods.ChildObjectId = inGoodsId
                                 
                  JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                  ON ObjectLink_PriceListItem_PriceList.ObjectId = Object_PriceListItem.Id
                                 AND ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                                 AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
                  -- ���� ��������
                  LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem_Return
                                          ON ObjectHistory_PriceListItem_Return.ObjectId = Object_PriceListItem.Id
                                         AND ObjectHistory_PriceListItem_Return.DescId = zc_ObjectHistory_PriceListItem() 
                                         AND vbReturnDate >= ObjectHistory_PriceListItem_Return.StartDate AND vbReturnDate < ObjectHistory_PriceListItem_Return.EndDate
                  LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value_Return
                                               ON ObjectHistoryFloat_PriceListItem_Value_Return.ObjectHistoryId = ObjectHistory_PriceListItem_Return.Id
                                              AND ObjectHistoryFloat_PriceListItem_Value_Return.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

             WHERE Object_PriceListItem.DescId = zc_Object_PriceListItem()
               AND ObjectHistoryFloat_PriceListItem_Value_Return.ValueData <> 0.0
            ;

END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 17.02.17                                                         *
*/

-- ����
-- SELECT * FROM gpSelectMobile_Object_PriceListItems_test (inSyncDateIn := zc_DateStart(), inSession := '1059546') WHERE GoodsId = 1045379 and PriceListId = zc_PriceList_Basis()
-- SELECT * FROM gpSelectMobile_Object_PriceListItems_test (inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())
-- SELECT * FROM gpSelectMobile_Object_PriceListItems_test (inPriceListId:= 18840, ingoodsId:= 2537, inSession := '2845741')
