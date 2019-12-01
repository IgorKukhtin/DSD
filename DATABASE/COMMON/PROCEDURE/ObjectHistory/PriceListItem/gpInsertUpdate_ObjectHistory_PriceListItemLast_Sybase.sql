-- Function: gpInsertUpdate_ObjectHistory_PriceListItemLast_Sybase()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListItemLast_Sybase();

--DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListItemLast_Sybase(Integer, Integer, Integer, TDateTime, TDateTime, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListItemLast_Sybase(Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_PriceListItemLast_Sybase(
 INOUT ioId                     Integer,    -- ���� ������� <������� �����-�����>
    IN inPriceListId            Integer,    -- �����-����
    IN inGoodsId                Integer,    -- �����
    IN inGoodsKindId            Integer,    -- ��� ������
    IN inOperDate               TDateTime,  -- ���� �������� �����-�����
    IN inEndDate                TDateTime,  -- ����
    IN inValue                  TFloat,     -- �������� ����
    IN inIsLast                 Boolean,    -- 
    IN inSession                TVarChar    -- ������ ������������
)
  RETURNS Integer AS
$BODY$
DECLARE
   DECLARE vbUserId Integer;
   DECLARE vbPriceListItemId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem());

   -- �������� ������ �� ������ ���
   vbPriceListItemId := lpGetInsert_Object_PriceListItem (inPriceListId, inGoodsId, inGoodsKindId, vbUserId);
 
   -- ��������� ��� ������ ������ ������� ���
   ioId := lpInsertUpdate_ObjectHistory (ioId, zc_ObjectHistory_PriceListItem(), vbPriceListItemId, inOperDate, vbUserId);


   -- Check
   IF NOT EXISTS (SELECT Id FROM ObjectHistory WHERE Id = ioId AND ObjectId = vbPriceListItemId)
   THEN
       RAISE EXCEPTION 'Error. Id = % where ObjectId <> vbPriceListItemId %', ioId, vbPriceListItemId;
   END IF;


   -- ������������� ����
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceListItem_Value(), ioId, inValue);


   -- !!!������ ��� ���������!!!!
   IF inIsLast = FALSE AND NOT EXISTS (SELECT Id FROM ObjectHistory WHERE Id = ioId AND EndDate = (inEndDate + INTERVAL '1 DAY'))
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


   -- ��������� ��������
   PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, vbUserId, StartDate, EndDate, inValue)
   FROM ObjectHistory WHERE Id = ioId;



END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 28.11.19         * inGoodsKindId
 09.12.14                                        *
*/
