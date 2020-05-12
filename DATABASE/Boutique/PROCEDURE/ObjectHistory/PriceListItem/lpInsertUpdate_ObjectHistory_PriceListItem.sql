-- Function: lpInsertUpdate_ObjectHistory_PriceListItem()

DROP FUNCTION IF EXISTS lpInsertUpdate_ObjectHistory_PriceListItem (Integer,Integer,Integer,TDateTime,TFloat,Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectHistory_PriceListItem(
 INOUT ioId                     Integer,    -- ���� ������� <������� �������>
    IN inPriceListId            Integer,    -- �����-����
    IN inGoodsId                Integer,    -- �����
    IN inOperDate               TDateTime,  -- ���� �������� ����
    IN inValue                  TFloat,     -- ����
    IN inUserId                 Integer     -- ������ ������������
)
  RETURNS integer AS
$BODY$
DECLARE
   DECLARE vbPriceListItemId Integer;
BEGIN

   -- ����� <������� ����>
   vbPriceListItemId := lpGetInsert_Object_PriceListItem (inPriceListId, inGoodsId, inUserId);

   -- ��������� �������
   ioId := lpInsertUpdate_ObjectHistory (ioId, zc_ObjectHistory_PriceListItem(), vbPriceListItemId, inOperDate, inUserId);

   -- ��������� ����
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceListItem_Value(), ioId, inValue);

   -- ��������� ������
   PERFORM lpInsertUpdate_ObjectHistoryLink (zc_ObjectHistoryLink_PriceListItem_Currency(), ioId
                                           , COALESCE (-- ������ �� ������� - � ���� ��������� ���������� ...
                                                       (SELECT DISTINCT OHL_Currency.ObjectId
                                                        FROM ObjectHistory AS OH_PriceListItem
                                                             LEFT JOIN ObjectHistoryLink AS OHL_Currency
                                                                                         ON OHL_Currency.ObjectHistoryId = OH_PriceListItem.Id
                                                                                        AND OHL_Currency.DescId          = zc_ObjectHistoryLink_PriceListItem_Currency()
                                                        WHERE OH_PriceListItem.ObjectId = vbPriceListItemId
                                                          AND OHL_Currency.ObjectId     > 0
                                                       )
                                                       -- ������ ������
                                                     , (SELECT OL_Currency.ChildObjectId
                                                        FROM ObjectLink AS OL_Currency
                                                        WHERE OL_Currency.ObjectId = inPriceListId
                                                          AND OL_Currency.DescId   = zc_ObjectLink_PriceList_Currency()
                                                       )
                                                     , zc_Currency_GRN()
                                                      )
                                            );


   -- �� ������ - c�������� ��������� ���� � �������
   IF inPriceListId = zc_PriceList_Basis()
   THEN
       PERFORM lpUpdate_Object_PartionGoods_OperPriceList (inGoodsId:= inGoodsId, inUserId:= inUserId);
   END IF;

   -- ��������� ��������
   PERFORM lpInsert_ObjectHistoryProtocol (inObjectId:= ObjectHistory.ObjectId, inUserId:= inUserId, inStartDate:= StartDate, inEndDate:= EndDate, inPrice:= inValue, inIsUpdate:= TRUE, inIsErased:= FALSE)
   FROM ObjectHistory WHERE Id = ioId;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 21.08.15         *
*/
