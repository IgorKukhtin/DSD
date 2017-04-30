-- Function: gpInsertUpdate_ObjectHistory_DiscountPeriodItem()

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_DiscountPeriodItem (Integer,Integer,Integer,TDateTime,TFloat,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_DiscountPeriodItem(
 INOUT ioId                     Integer,    -- ���� ������� <�������>
    IN inUnitId                 Integer,    -- 
    IN inGoodsId                Integer,    -- �����
    IN inOperDate               TDateTime,  -- ���� �������� 
    IN inValue                  TFloat,     -- �������� % c�����
    IN inSession                TVarChar    -- ������ ������������
)
  RETURNS integer AS
$BODY$
DECLARE
   DECLARE vbUserId Integer;
   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_DiscountPeriodItem());

    -- 
   ioId := lpInsertUpdate_ObjectHistory_DiscountPeriodItem (ioId := ioId
                                                     , inUnitId := inUnitId
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
 21.08.15         * lpInsertUpdate_ObjectHistory_DiscountPeriodItem
 18.04.14                                        * add zc_Enum_Process_InsertUpdate_ObjectHistory_DiscountPeriodItem
 06.06.13                        *
*/
