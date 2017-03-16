-- Function: gpSelectMobile_Object_PriceListItems (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_PriceListItems (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_PriceListItems (
    IN inSyncDateIn TDateTime, -- ����/����� ��������� ������������� - ����� "�������" ����������� �������� ���������� - ���������� �����������, ����, �����, �����, ������� � �.�
    IN inSession    TVarChar   -- ������ ������������
)
RETURNS TABLE (Id             Integer
             , GoodsId        Integer   -- �����
             , PriceListId    Integer   -- �����-����
             , OrderStartDate TDateTime -- ���� � ������� ��������� ���� ������
             , OrderEndDate   TDateTime -- ���� �� ������� ��������� ���� ������
             , OrderPrice     TFloat    -- ���� ������
             , SaleStartDate  TDateTime -- ���� � ������� ��������� ���� ��������
             , SaleEndDate    TDateTime -- ���� �� ������� ��������� ���� ��������
             , SalePrice      TFloat    -- ���� ��������
             , isSync         Boolean   -- ���������������� (��/���)
              )
AS 
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      vbPersonalId:= (SELECT PersonalId FROM gpGetMobile_Object_Const (inSession));

      -- ���������
      IF vbPersonalId IS NOT NULL 
      THEN
           CREATE TEMP TABLE tmpPriceList ON COMMIT DROP
           AS (SELECT DISTINCT COALESCE(ObjectLink_Partner_PriceList.ChildObjectId
                                      , ObjectLink_Contract_PriceList.ChildObjectId
                                      , ObjectLink_Juridical_PriceList.ChildObjectId
                                      , zc_PriceList_Basis()) AS PriceListId
                             , COALESCE(ObjectLink_Partner_PriceListPrior.ChildObjectId
                                      , ObjectLink_Juridical_PriceListPrior.ChildObjectId
                                      , zc_PriceList_BasisPrior()) AS PriceListPriorId
               FROM ObjectLink AS ObjectLink_Partner_PersonalTrade
                    LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList
                                         ON ObjectLink_Partner_PriceList.ObjectId = ObjectLink_Partner_PersonalTrade.ObjectId
                                        AND ObjectLink_Partner_PriceList.DescId = zc_ObjectLink_Partner_PriceList()
                    LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceListPrior
                                         ON ObjectLink_Partner_PriceListPrior.ObjectId = ObjectLink_Partner_PersonalTrade.ObjectId
                                        AND ObjectLink_Partner_PriceListPrior.DescId = zc_ObjectLink_Partner_PriceListPrior()
                    LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                         ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner_PersonalTrade.ObjectId
                                        AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                    LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                         ON ObjectLink_Contract_Juridical.ChildObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                        AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                    LEFT JOIN ObjectLink AS ObjectLink_Contract_PriceList
                                         ON ObjectLink_Contract_PriceList.ObjectId = ObjectLink_Contract_Juridical.ObjectId
                                        AND ObjectLink_Contract_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
                    LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                         ON ObjectLink_Juridical_PriceList.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                        AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()
                    LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceListPrior
                                         ON ObjectLink_Juridical_PriceListPrior.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                        AND ObjectLink_Juridical_PriceListPrior.DescId = zc_ObjectLink_Juridical_PriceListPrior()
               WHERE ObjectLink_Partner_PersonalTrade.ChildObjectId = vbPersonalId
                 AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
              );
                
           IF inSyncDateIn > zc_DateStart()
           THEN
                RETURN QUERY
                  WITH tmpProtocol AS (SELECT ObjectProtocol.ObjectId AS PriceListItemId, MAX(ObjectProtocol.OperDate) AS MaxOperDate
                                       FROM ObjectProtocol                                                                               
                                            JOIN Object AS Object_PriceListItem                                                              
                                                        ON Object_PriceListItem.Id = ObjectProtocol.ObjectId                                 
                                                       AND Object_PriceListItem.DescId = zc_Object_PriceListItem()
                                       WHERE ObjectProtocol.OperDate > inSyncDateIn
                                       GROUP BY ObjectProtocol.ObjectId                                                                  
                                      )
                  SELECT Object_PriceListItem.Id
                       , ObjectLink_PriceListItem_Goods.ChildObjectId           AS GoodsId
                       , ObjectLink_PriceListItem_PriceList.ChildObjectId       AS PriceListId
                       , ObjectHistory_PriceListItem_Order.StartDate            AS OrderStartDate
                       , ObjectHistory_PriceListItem_Order.EndDate              AS OrderEndDate
                       , COALESCE (ObjectHistoryFloat_PriceListItem_Value_Order.ValueData, 0.0)::TFloat AS OrderPrice
                       , ObjectHistory_PriceListItem_Sale.StartDate             AS SaleStartDate
                       , ObjectHistory_PriceListItem_Sale.EndDate               AS SaleEndDate
                       , COALESCE (ObjectHistoryFloat_PriceListItem_Value_Sale.ValueData, 0.0)::TFloat  AS SalePrice
                       , tmpPriceList.PriceListId IS NOT NULL AND tmpPriceList.PriceListPriorId IS NOT NULL
                         AND ((ABS (COALESCE (ObjectHistoryFloat_PriceListItem_Value_Order.ValueData, 0.0)) 
                             + ABS (COALESCE (ObjectHistoryFloat_PriceListItem_Value_Sale.ValueData, 0.0))) <> 0.0) AS isSync
                  FROM Object AS Object_PriceListItem
                       JOIN tmpProtocol ON tmpProtocol.PriceListItemId = Object_PriceListItem.Id
                       JOIN ObjectLink AS ObjectLink_PriceListItem_Goods 
                                       ON ObjectLink_PriceListItem_Goods.ObjectId = Object_PriceListItem.Id
                                      AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                       JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                       ON ObjectLink_PriceListItem_PriceList.ObjectId = Object_PriceListItem.Id
                                      AND ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                       LEFT JOIN tmpPriceList ON ObjectLink_PriceListItem_PriceList.ChildObjectId IN (tmpPriceList.PriceListId, tmpPriceList.PriceListPriorId)
                       LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem_Order
                                               ON ObjectHistory_PriceListItem_Order.ObjectId = Object_PriceListItem.Id
                                              AND ObjectHistory_PriceListItem_Order.DescId = zc_ObjectHistory_PriceListItem() 
                                              AND CURRENT_DATE BETWEEN ObjectHistory_PriceListItem_Order.StartDate AND ObjectHistory_PriceListItem_Order.EndDate
                       LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value_Order
                                                    ON ObjectHistoryFloat_PriceListItem_Value_Order.ObjectHistoryId = ObjectHistory_PriceListItem_Order.Id
                                                   AND ObjectHistoryFloat_PriceListItem_Value_Order.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                       LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem_Sale
                                               ON ObjectHistory_PriceListItem_Sale.ObjectId = Object_PriceListItem.Id
                                              AND ObjectHistory_PriceListItem_Sale.DescId = zc_ObjectHistory_PriceListItem() 
                                              AND (CURRENT_DATE + 1) BETWEEN ObjectHistory_PriceListItem_Sale.StartDate AND ObjectHistory_PriceListItem_Sale.EndDate
                       LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value_Sale
                                                    ON ObjectHistoryFloat_PriceListItem_Value_Sale.ObjectHistoryId = ObjectHistory_PriceListItem_Sale.Id
                                                   AND ObjectHistoryFloat_PriceListItem_Value_Sale.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                  WHERE Object_PriceListItem.DescId = zc_Object_PriceListItem();
           ELSE
                RETURN QUERY
                  SELECT Object_PriceListItem.Id
                       , ObjectLink_PriceListItem_Goods.ChildObjectId           AS GoodsId
                       , ObjectLink_PriceListItem_PriceList.ChildObjectId       AS PriceListId
                       , ObjectHistory_PriceListItem_Order.StartDate            AS OrderStartDate
                       , ObjectHistory_PriceListItem_Order.EndDate              AS OrderEndDate
                       , ObjectHistoryFloat_PriceListItem_Value_Order.ValueData AS OrderPrice
                       , ObjectHistory_PriceListItem_Sale.StartDate             AS SaleStartDate
                       , ObjectHistory_PriceListItem_Sale.EndDate               AS SaleEndDate
                       , ObjectHistoryFloat_PriceListItem_Value_Sale.ValueData  AS SalePrice
                       , CAST(true AS Boolean) AS isSync
                  FROM Object AS Object_PriceListItem
                       JOIN ObjectLink AS ObjectLink_PriceListItem_Goods 
                                       ON ObjectLink_PriceListItem_Goods.ObjectId = Object_PriceListItem.Id
                                      AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                       JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                       ON ObjectLink_PriceListItem_PriceList.ObjectId = Object_PriceListItem.Id
                                      AND ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                       JOIN tmpPriceList ON ObjectLink_PriceListItem_PriceList.ChildObjectId IN (tmpPriceList.PriceListId, tmpPriceList.PriceListPriorId)
                       LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem_Order
                                               ON ObjectHistory_PriceListItem_Order.ObjectId = Object_PriceListItem.Id
                                              AND ObjectHistory_PriceListItem_Order.DescId = zc_ObjectHistory_PriceListItem() 
                                              AND CURRENT_DATE BETWEEN ObjectHistory_PriceListItem_Order.StartDate AND ObjectHistory_PriceListItem_Order.EndDate
                       LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value_Order
                                                    ON ObjectHistoryFloat_PriceListItem_Value_Order.ObjectHistoryId = ObjectHistory_PriceListItem_Order.Id
                                                   AND ObjectHistoryFloat_PriceListItem_Value_Order.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                       LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem_Sale
                                               ON ObjectHistory_PriceListItem_Sale.ObjectId = Object_PriceListItem.Id
                                              AND ObjectHistory_PriceListItem_Sale.DescId = zc_ObjectHistory_PriceListItem() 
                                              AND (CURRENT_DATE + 1) BETWEEN ObjectHistory_PriceListItem_Sale.StartDate AND ObjectHistory_PriceListItem_Sale.EndDate
                       LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value_Sale
                                                    ON ObjectHistoryFloat_PriceListItem_Value_Sale.ObjectHistoryId = ObjectHistory_PriceListItem_Sale.Id
                                                   AND ObjectHistoryFloat_PriceListItem_Value_Sale.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                  WHERE Object_PriceListItem.DescId = zc_Object_PriceListItem()
                    AND ((ABS (COALESCE (ObjectHistoryFloat_PriceListItem_Value_Order.ValueData, 0.0)) 
                        + ABS (COALESCE (ObjectHistoryFloat_PriceListItem_Value_Sale.ValueData, 0.0))) <> 0.0);
           END IF;
      END IF;

END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 17.02.17                                                         *
*/

-- ����
-- SELECT * FROM gpSelectMobile_Object_PriceListItems(inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())
