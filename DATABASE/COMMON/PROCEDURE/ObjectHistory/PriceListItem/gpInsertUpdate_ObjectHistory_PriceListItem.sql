-- Function: gpInsertUpdate_ObjectHistory_PriceListItem()

--DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListItem (Integer,Integer,Integer,TDateTime,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListItem (Integer,Integer,Integer,Integer,TDateTime,TFloat,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_PriceListItem(
 INOUT ioId                     Integer,    -- ���� ������� <������� �����-�����>
    IN inPriceListId            Integer,    -- �����-����
    IN inGoodsId                Integer,    -- �����
    IN inGoodsKindId            Integer,    -- ��� ������
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
                                                     , inGoodsKindId := inGoodsKindId
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
 30.01.20         * add inGoodsKindId
 21.08.15         * lpInsertUpdate_ObjectHistory_PriceListItem
 18.04.14                                        * add zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem
 06.06.13                        *
*/