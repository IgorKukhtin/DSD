-- Function: gpInsertUpdate_ObjectHistory_PriceListItemLast (Integer, Integer, Integer, TDateTime, TFloat, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListItemLast (Integer, Integer, Integer, TDateTime, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_PriceListItemLast(
 INOUT ioId                     Integer,    -- ���� ������� <������� �������>
    IN inPriceListId            Integer,    -- �����-����
    IN inGoodsId                Integer,    -- �����
    IN inOperDate               TDateTime,  -- ���� �������� ����
   OUT outStartDate             TDateTime,  -- ���� �������� ����
   OUT outEndDate               TDateTime,  -- ���� �������� ����
    IN inValue                  TFloat,     -- ����
    IN inIsLast                 Boolean,    -- 
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
DECLARE
   DECLARE vbUserId Integer;
   DECLARE vbPriceListItemId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem());

   -- !!!������ ��������!!!
   IF inIsLast = TRUE THEN ioId:= 0; END IF;

   -- ����� <������� ����>
   vbPriceListItemId := lpGetInsert_Object_PriceListItem (inPriceListId, inGoodsId, vbUserId);
 
   -- ��������� �������
   ioId := lpInsertUpdate_ObjectHistory (ioId, zc_ObjectHistory_PriceListItem(), vbPriceListItemId, inOperDate, vbUserId);
   -- ��������� ����
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceListItem_Value(), ioId, inValue);

   --
   IF inIsLast = TRUE AND EXISTS (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate)
   THEN
         -- ��������� �������� - "��������"
         PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, vbUserId, ObjectHistory.StartDate, ObjectHistory.EndDate, ObjectHistoryFloat_Value.ValueData, TRUE, TRUE)
         FROM ObjectHistory
              LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                           ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory.Id
                                          AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
         WHERE ObjectHistory.DescId = zc_ObjectHistory_PriceListItem() AND ObjectHistory.ObjectId = vbPriceListItemId AND ObjectHistory.StartDate > inOperDate;

         -- �������
         DELETE FROM ObjectHistoryDate WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistoryFloat WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistoryString WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistoryLink WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistory WHERE Id IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate);
         -- ����� ���� �������� ��-�� EndDate
         UPDATE ObjectHistory SET EndDate = zc_DateEnd() WHERE Id = ioId;
   END IF;


   -- ������� ��������
   SELECT StartDate, EndDate INTO outStartDate, outEndDate FROM ObjectHistory WHERE Id = ioId;

   -- ��������
   IF inIsLast = TRUE AND COALESCE (outEndDate, zc_DateStart()) <> zc_DateEnd()
   THEN
       RAISE EXCEPTION '������. inIsLast = TRUE AND outEndDate = <%>', outEndDate;
   END IF;
   

   -- !!!�� ������ - c�������� ��������� ���� � �������!!!
   IF inPriceListId = zc_PriceList_Basis()
   THEN
       PERFORM lpUpdate_Object_PartionGoods_PriceSale (inGoodsId:= inGoodsId, inUserId:= vbUserId);
   END IF;


   -- ��������� ��������
   PERFORM lpInsert_ObjectHistoryProtocol (inObjectId:= vbPriceListItemId, inUserId:= vbUserId, inStartDate:= outStartDate, inEndDate:= outEndDate, inPrice:= inValue, inIsUpdate:= TRUE, inIsErased:= FALSE);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 20.08.15         * lpInsert_ObjectHistoryProtocol
 09.12.14                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_ObjectHistory_PriceListItemLast (ioId := 0 , inPriceListId := 372 , inGoodsId := 406 , inOperDate := ('20.08.2015')::TDateTime , inValue := 59 , inIsLast := 'False' ,  inSession := '2');
