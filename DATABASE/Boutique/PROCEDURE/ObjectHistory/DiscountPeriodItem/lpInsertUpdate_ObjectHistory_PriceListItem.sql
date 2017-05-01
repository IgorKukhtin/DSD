-- Function: lpInsertUpdate_ObjectHistory_DiscountPeriodItem()

DROP FUNCTION IF EXISTS lpInsertUpdate_ObjectHistory_DiscountPeriodItem (Integer,Integer,Integer,TDateTime,TFloat,Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectHistory_DiscountPeriodItem(
 INOUT ioId                     Integer,    -- ���� ������� <�������>
    IN inUnitId                 Integer,    -- 
    IN inGoodsId                Integer,    -- �����
    IN inOperDate               TDateTime,  -- ���� �������� 
    IN inValue                  TFloat,     -- �������� ����
    IN inUserId                 Integer    -- ������ ������������
)
  RETURNS integer AS
$BODY$
DECLARE
   DECLARE vbDiscountPeriodItemId Integer;
BEGIN

   THEN
       RAISE EXCEPTION '������. ��� ���� �������������� ����� <%>', lfGet_Object_ValueData (inUnitId);
   END IF;

   -- �������� ������ �� ������ ���
   vbDiscountPeriodItemId := lpGetInsert_Object_DiscountPeriodItem (inUnitId, inGoodsId, inUserId);
 
   -- ��������� ��� ������ ������ ������� ���
   ioId := lpInsertUpdate_ObjectHistory (ioId, zc_ObjectHistory_DiscountPeriodItem(), vbDiscountPeriodItemId, inOperDate, inUserId);
   -- ������������� ����
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_DiscountPeriodItem_Value(), ioId, inValue);

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
