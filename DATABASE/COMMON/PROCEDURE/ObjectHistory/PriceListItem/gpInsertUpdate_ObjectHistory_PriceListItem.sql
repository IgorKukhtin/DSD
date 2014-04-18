-- Function: gpInsertUpdate_ObjectHistory_PriceListItem()

-- DROP FUNCTION gpInsertUpdate_ObjectHistory_PriceListItem();

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_PriceListItem(
 INOUT ioId                     Integer,    -- ���� ������� <������� �����-�����>
    IN inPriceListId            Integer,    -- �����-����
    IN inGoodsId                Integer,    -- �����
    IN inOperDate               TDateTime,  -- ���� �������� �����-�����
    IN inValue                  TFloat,     -- �������� ����
    IN inSession                TVarChar    -- ������ ������������
)
  RETURNS integer AS
$BODY$
DECLARE
   DECLARE vbUserId Integer;
   DECLARE vbPriceListItemId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem());

   -- �������� ������ �� ������ ���
   vbPriceListItemId := lpGetInsert_Object_PriceListItem (inPriceListId, inGoodsId);
 
   -- ��������� ��� ������ ������ ������� ���
   ioId := lpInsertUpdate_ObjectHistory (ioId, zc_ObjectHistory_PriceListItem(), vbPriceListItemId, inOperDate);
   -- ������������� ����
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceListItem_Value(), ioId, inValue);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 18.04.14                                        * add zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem
 06.06.13                        *
*/
