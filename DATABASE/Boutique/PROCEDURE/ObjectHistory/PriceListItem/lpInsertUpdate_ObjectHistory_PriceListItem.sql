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
  RETURNS Integer AS
$BODY$
DECLARE
   DECLARE vbPriceListItemId Integer;
   DECLARE vbCurrencyId_pl Integer;
   DECLARE vbDiscountPeriodItemId Integer;
BEGIN

   -- ����� <������� ����>
   vbPriceListItemId := lpGetInsert_Object_PriceListItem (inPriceListId, inGoodsId, inUserId);

   -- ��������� �������
   ioId := lpInsertUpdate_ObjectHistory (ioId, zc_ObjectHistory_PriceListItem(), vbPriceListItemId, inOperDate, inUserId);

   -- ��������� ����
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceListItem_Value(), ioId, inValue);


   IF zc_Enum_GlobalConst_isTerry() = FALSE
   THEN
       -- ����� <������� ������>
       vbDiscountPeriodItemId := lpGetInsert_Object_DiscountPeriodItem ((SELECT OL.ObjectId FROM ObjectLink AS OL WHERE OL.ChildObjectId = inPriceListId AND OL.DescId = zc_ObjectLink_Unit_PriceList())
                                                                      , inGoodsId, inUserId);
       -- ��������
       IF EXISTS (SELECT 1 FROM ObjectHistory AS OH WHERE OH.DescId = zc_ObjectHistory_PriceListItem() AND OH.ObjectId = vbPriceListItemId AND OH.EndDate = inOperDate)
          AND inValue < (SELECT COALESCE (OFl.ValueData, 0) FROM ObjectHistory AS OH LEFT JOIN ObjectHistoryFloat AS OFl ON OFl.ObjectHistoryId = OH.Id AND OFl.DescId = zc_ObjectHistoryFloat_PriceListItem_Value() WHERE OH.DescId = zc_ObjectHistory_PriceListItem() AND OH.ObjectId = vbPriceListItemId AND OH.EndDate = inOperDate)
          AND 0 < (SELECT COALESCE (OFl.ValueData, 0) FROM ObjectHistory AS OH LEFT JOIN ObjectHistoryFloat AS OFl ON OFl.ObjectHistoryId = OH.Id AND OFl.DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_Value() WHERE OH.DescId = zc_ObjectHistory_DiscountPeriodItem() AND OH.ObjectId = vbDiscountPeriodItemId AND OH.StartDate <= inOperDate AND inOperDate < OH.EndDate)
       THEN
           RAISE EXCEPTION '������.��� ������ ������� �������� ������ = <% %>.���������� �������� ������.'
                         , zfConvert_FloatToString ((SELECT COALESCE (OFl.ValueData, 0) FROM ObjectHistory AS OH LEFT JOIN ObjectHistoryFloat AS OFl ON OFl.ObjectHistoryId = OH.Id AND OFl.DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_Value() WHERE OH.DescId = zc_ObjectHistory_DiscountPeriodItem() AND OH.ObjectId = vbDiscountPeriodItemId AND OH.StartDate <= inOperDate AND inOperDate < OH.EndDate))
                         , '%'
                          ;
       END IF;

   END IF;

   -- ����� ������
   vbCurrencyId_pl:= COALESCE (-- ������ �� ������� - � ���� ��������� ���������� ...
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
                              );
   -- ��������� ������
   PERFORM lpInsertUpdate_ObjectHistoryLink (zc_ObjectHistoryLink_PriceListItem_Currency(), ioId, vbCurrencyId_pl);


   -- �� ������ - c�������� ��������� ���� � �������
   IF inPriceListId = zc_PriceList_Basis()
   THEN
       PERFORM lpUpdate_Object_PartionGoods_OperPriceList (inGoodsId:= inGoodsId, inUserId:= inUserId);
   END IF;

   -- ��������� ��������
   PERFORM lpInsert_ObjectHistoryProtocol (inObjectId:= ObjectHistory.ObjectId, inUserId:= inUserId, inStartDate:= StartDate, inEndDate:= EndDate, inPrice:= inValue, inIsUpdate:= TRUE, inIsErased:= FALSE)
   FROM ObjectHistory WHERE Id = ioId;


   IF inUserId :: TVarChar = zfCalc_UserAdmin()
   THEN
       RAISE EXCEPTION 'Error.Admin test - ok';
   END IF;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 21.08.15         *
*/
