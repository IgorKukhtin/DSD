-- Function: gpSelect_ObjectHistory_PriceListItem_Period ()

DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_PriceListItem_Period (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_PriceListItem_Period(
    IN inPriceListId        Integer   , -- �����-���� 
    IN inOperDate           TDateTime , -- 
    IN inSession            TVarChar    -- ������ ������������
)                              
RETURNS TABLE (GoodsId Integer, GoodsKindId Integer, StartDate TDateTime, ValuePrice TFloat
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- ����������� - ���� ���� ���������� ���������-����
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = 78489 AND UserId = vbUserId)
        AND NOT EXISTS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
        AND COALESCE (inPriceListId, 0) NOT IN (zc_PriceList_Fuel())
     THEN
         RAISE EXCEPTION '������. ��� ���� �� �������� ������ <%>', lfGet_Object_ValueData (inPriceListId);
     END IF;


     -- ����������� - �����-���� - �������� � �������������
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = 10575455)
     THEN
         -- �����������
         IF NOT EXISTS (SELECT 1 AS Id FROM Object_ViewPriceList_View WHERE Object_ViewPriceList_View.UserId = vbUserId AND Object_ViewPriceList_View.PriceListId = inPriceListId)
            -- ���� �����������
            --AND EXISTS (SELECT 1 FROM Object_ViewPriceList_View WHERE Object_ViewPriceList_View.UserId = vbUserId AND Object_ViewPriceList_View.PriceListId > 0)
         THEN
             IF COALESCE (inPriceListId, 0) = 0
             THEN
                 RETURN;
             ELSE
                 RAISE EXCEPTION '������.��� ���� �� �������� ������ <%>.', lfGet_Object_ValueData (inPriceListId);
             END IF;
         END IF;
     END IF;


     -- ���������� ������ , ���� �� �����
     --vbStartDate := inOperDate - INTERVAL '1 MONTH' ; --DATE_TRUNC ('MONTH', inOperDate);
     --vbEndDate := inOperDate + INTERVAL '1 Day'; --vbStartDate + INTERVAL '1 MONTH';
     vbStartDate := CASE WHEN inOperDate + INTERVAL '1 Day'  =  DATE_TRUNC ('MONTH', inOperDate + INTERVAL '1 Day') THEN DATE_TRUNC ('MONTH', inOperDate) ELSE inOperDate - INTERVAL '1 MONTH' END; --DATE_TRUNC ('MONTH', inOperDate);
     vbEndDate   := inOperDate ; --vbStartDate + INTERVAL '1 MONTH';

     -- �������� ������
     RETURN QUERY 
     WITH
     tmpItem_all AS (SELECT ObjectLink_PriceListItem_Goods.ChildObjectId     AS GoodsId
                          , ObjectLink_PriceListItem_GoodsKind.ChildObjectId AS GoodsKindId
                          , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice
                          , ObjectHistory_PriceListItem.StartDate
                          , ObjectHistory_PriceListItem.EndDate
                     FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
                          LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                               ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                              AND ObjectLink_PriceListItem_Goods.DescId   = zc_ObjectLink_PriceListItem_Goods()
                          LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                               ON ObjectLink_PriceListItem_GoodsKind.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                              AND ObjectLink_PriceListItem_GoodsKind.DescId   = zc_ObjectLink_PriceListItem_GoodsKind()
                          LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                  ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                 AND ObjectHistory_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                          LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                       ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                      AND ObjectHistoryFloat_PriceListItem_Value.DescId          = zc_ObjectHistoryFloat_PriceListItem_Value()
  
                     WHERE ObjectLink_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                       AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
                       AND ObjectHistory_PriceListItem.EndDate              >= vbStartDate
                       AND ObjectHistory_PriceListItem.StartDate            <= vbEndDate
                    )
       -- ���������
       SELECT tmp.GoodsId
            , tmp.GoodsKindId
            , tmp.StartDate
            , tmp.ValuePrice

       FROM (SELECT tmpItem_all.GoodsId, tmpItem_all.GoodsKindId, tmpItem_all.ValuePrice, tmpItem_all.StartDate
             FROM tmpItem_all
             WHERE tmpItem_all.StartDate >= vbStartDate
            UNION ALL
             SELECT tmpItem_all.GoodsId, tmpItem_all.GoodsKindId, tmpItem_all.ValuePrice, tmpItem_all.StartDate
             FROM tmpItem_all
                  LEFT JOIN tmpItem_all AS tmpItem_all_check ON tmpItem_all_check.GoodsId   = tmpItem_all.GoodsId
                                                            AND COALESCE (tmpItem_all_check.GoodsKindId,0) = COALESCE (tmpItem_all.GoodsKindId,0)
                                                            AND tmpItem_all_check.StartDate = vbStartDate
             WHERE tmpItem_all.StartDate < vbStartDate
               AND tmpItem_all_check.GoodsId IS NULL
            ) AS tmp
       ORDER BY tmp.StartDate;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.11.19         * GoodsKind
 16.10.18         *
*/

-- ����
-- SELECT * FROM gpSelect_ObjectHistory_PriceListItem_Period (2707438, '25.10.2018', zfCalc_UserAdmin())
