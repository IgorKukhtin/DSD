-- Function: gpInsertUpdate_ObjectHistory_DiscountPeriodItemLast (Integer, Integer, Integer, TDateTime, TFloat, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_DiscountPeriodItemLast (Integer, Integer, Integer, TDateTime, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_DiscountPeriodItemLast(
 INOUT ioId                     Integer,    -- ���� ������� <������� �������� ������>
    IN inUnitId                 Integer,    -- �������������
    IN inGoodsId                Integer,    -- �����
    IN inOperDate               TDateTime,  -- ���� �������� % ������
   OUT outStartDate             TDateTime,  -- ���� �������� % ������
   OUT outEndDate               TDateTime,  -- ���� �������� % ������
    IN inValue                  TFloat,     -- �������� ����
    IN inIsLast                 Boolean,    -- 
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
DECLARE
   DECLARE vbUserId Integer;
   DECLARE vbDiscountPeriodItemId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_DiscountPeriodItem());

   -- !!!������������!!!
   IF inIsLast = TRUE THEN ioId:= 0; END IF;

   -- �������� ������ �� ������ % ������
   vbDiscountPeriodItemId := lpGetInsert_Object_DiscountPeriodItem (inUnitId, inGoodsId, vbUserId);
 
   -- ��������� ��� ������ ������ % ������
   ioId := lpInsertUpdate_ObjectHistory (ioId, zc_ObjectHistory_DiscountPeriodItem(), vbDiscountPeriodItemId, inOperDate, vbUserId);
   -- ������������� ����
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_DiscountPeriodItem_Value(), ioId, inValue);

   --
   IF inIsLast = TRUE AND EXISTS (SELECT Id 
                                  FROM ObjectHistory 
                                  WHERE DescId = zc_ObjectHistory_DiscountPeriodItem()
                                    AND ObjectId = vbDiscountPeriodItemId 
                                    AND StartDate > inOperDate)
   THEN
         -- ��������� �������� - "��������"
         PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, vbUserId, ObjectHistory.StartDate, ObjectHistory.EndDate, ObjectHistoryFloat_Value.ValueData, TRUE, TRUE)
         FROM ObjectHistory
              LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                           ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory.Id
                                          AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_Value()
         WHERE ObjectHistory.DescId = zc_ObjectHistory_DiscountPeriodItem() AND ObjectHistory.ObjectId = vbDiscountPeriodItemId AND ObjectHistory.StartDate > inOperDate;

         -- �������
         DELETE FROM ObjectHistoryDate WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_DiscountPeriodItem() AND ObjectId = vbDiscountPeriodItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistoryFloat WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_DiscountPeriodItem() AND ObjectId = vbDiscountPeriodItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistoryString WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_DiscountPeriodItem() AND ObjectId = vbDiscountPeriodItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistoryLink WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_DiscountPeriodItem() AND ObjectId = vbDiscountPeriodItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistory WHERE Id IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_DiscountPeriodItem() AND ObjectId = vbDiscountPeriodItemId AND StartDate > inOperDate);
         -- ����� ���� �������� ��-�� EndDate
         UPDATE ObjectHistory SET EndDate = zc_DateEnd() WHERE Id = ioId;
   END IF;


   -- ������� ��������
   SELECT StartDate, EndDate INTO outStartDate, outEndDate FROM ObjectHistory WHERE Id = ioId;

   -- ��������� ��������
   PERFORM lpInsert_ObjectHistoryProtocol (inObjectId:= vbDiscountPeriodItemId, inUserId:= vbUserId, inStartDate:= outStartDate, inEndDate:= outEndDate, inPrice:= inValue, inIsUpdate:= TRUE, inIsErased:= FALSE);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 28.04.17         * 
*/

--test
--select * from gpInsertUpdate_ObjectHistory_DiscountPeriodItemLast(ioId := 0 , inUnitId := 311 , inGoodsId := 271 , inOperDate := ('08.05.2017')::TDateTime , inValue := 0 , inIsLast := 'False' ,  inSession := '2');