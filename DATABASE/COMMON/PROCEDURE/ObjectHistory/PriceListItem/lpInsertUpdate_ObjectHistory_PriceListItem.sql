-- Function: lpInsertUpdate_ObjectHistory_PriceListItem()

DROP FUNCTION IF EXISTS lpInsertUpdate_ObjectHistory_PriceListItem (Integer,Integer,Integer,TDateTime,TFloat,Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectHistory_PriceListItem(
 INOUT ioId                     Integer,    -- ���� ������� <������� �����-�����>
    IN inPriceListId            Integer,    -- �����-����
    IN inGoodsId                Integer,    -- �����
    IN inOperDate               TDateTime,  -- ���� �������� �����-�����
    IN inValue                  TFloat,     -- �������� ����
    IN inUserId                 Integer    -- ������ ������������
)
  RETURNS integer AS
$BODY$
DECLARE
   DECLARE vbPriceListItemId Integer;
BEGIN


   -- �������� ������ �� ������ ���
   vbPriceListItemId := lpGetInsert_Object_PriceListItem (inPriceListId, inGoodsId);
 
   -- ��������� ��� ������ ������ ������� ���
   ioId := lpInsertUpdate_ObjectHistory (ioId, zc_ObjectHistory_PriceListItem(), vbPriceListItemId, inOperDate, inUserId);
   -- ������������� ����
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceListItem_Value(), ioId, inValue);

   -- ��������� ��������
   PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, inUserId, StartDate, EndDate, inValue)
   FROM ObjectHistory WHERE Id = ioId;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 21.08.15         *
*/
