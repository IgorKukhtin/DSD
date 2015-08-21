-- Function: gpInsertUpdate_ObjectHistory_PriceListItem()

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListItem (Integer,Integer,Integer,TDateTime,TFloat,TVarChar);

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
   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem());

    -- 
   ioId := lpInsertUpdate_ObjectHistory_PriceListItem (ioId := ioId
                                                     , inPriceListId := inPriceListId
                                                     , inGoodsId     := inGoodsId
                                                     , inOperDate    := inOperDate
                                                     , inValue       := inValue
                                                     , inUserId      := vbUserId
                                                     );
 

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 21.08.15         * lpInsertUpdate_ObjectHistory_PriceListItem
 18.04.14                                        * add zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem
 06.06.13                        *
*/
