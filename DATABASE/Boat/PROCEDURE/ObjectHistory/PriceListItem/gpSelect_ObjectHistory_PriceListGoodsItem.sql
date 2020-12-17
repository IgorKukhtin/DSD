-- Function: gpSelect_ObjectHistory_PriceListGoodsItem ()

DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_PriceListGoodsItem (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_PriceListGoodsItem(
    IN inPriceListId        Integer   , -- �����-���� 
    IN inGoodsId            Integer   , -- �����
    IN inSession            TVarChar    -- ������ ������������
)                              
RETURNS TABLE (Id Integer, StartDate TDateTime, EndDate TDateTime
             , ValuePrice TFloat, isErased Boolean)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- ����������� - ���� ���� ��������� ���������
     /*IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = 80548 AND UserId = vbUserId)
        AND COALESCE (inPriceListId, 0) NOT IN (140208 -- ���-�� ������
                                              , 140209 -- ���-�� �������
                                               )
     THEN
         --RAISE EXCEPTION '������. ��� ���� �� �������� ������ <%>', lfGet_Object_ValueData (inPriceListId);
         RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������. ��� ���� �� �������� ������ <%>'     :: TVarChar
                                               , inProcedureName := 'gpInsertUpdate_ObjectHistory_PriceListTax'   :: TVarChar
                                               , inUserId        := vbUserId
                                               , inParam1        := lfGet_Object_ValueData (inPriceListId)        :: TVarChar
                                               );
     END IF;*/

/*
     -- ����������� - ���� ���� ���������� ���������-����
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = 78489 AND UserId = vbUserId)
        AND COALESCE (inPriceListId, 0) NOT IN (zc_PriceList_Fuel()
                                               )
     THEN
         --RAISE EXCEPTION '������. ��� ���� �� �������� ������ <%>', lfGet_Object_ValueData (inPriceListId);
         RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������. ��� ���� �� �������� ������ <%>'     :: TVarChar
                                               , inProcedureName := 'gpInsertUpdate_ObjectHistory_PriceListTax'   :: TVarChar
                                               , inUserId        := vbUserId
                                               , inParam1        := lfGet_Object_ValueData (inPriceListId)        :: TVarChar
                                               );
     END IF;
*/

     -- �������� ������
     
       RETURN QUERY 
       SELECT
             ObjectHistory_PriceListItem.Id

           , ObjectHistory_PriceListItem.StartDate
           , ObjectHistory_PriceListItem.EndDate
           , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice
           , False AS isErased
       FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
            LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                 ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()

            LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                    ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                   AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                         ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                        AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

       WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
         AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
         AND ObjectLink_PriceListItem_Goods.ChildObjectId = inGoodsId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.11.20         *
*/

-- ����
-- SELECT * FROM gpSelect_ObjectHistory_PriceListGoodsItem (zc_PriceList_ProductionSeparate(), 0, zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_ObjectHistory_PriceListGoodsItem (zc_PriceList_Basis(), 0, zfCalc_UserAdmin())
