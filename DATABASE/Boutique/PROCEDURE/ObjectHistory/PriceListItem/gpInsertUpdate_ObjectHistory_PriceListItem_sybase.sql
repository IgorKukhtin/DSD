-- Function: gpInsertUpdate_ObjectHistory_PriceListItem_sybase (Integer, Integer, Integer, TDateTime, TFloat, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListItem_sybase (Integer, Integer, Integer, TDateTime, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_PriceListItem_sybase(
 INOUT ioId                     Integer,    -- ���� ������� <������� �������>
    IN inPriceListId            Integer,    -- �����-����
    IN inGoodsId                Integer,    -- �����
    IN inStartDate              TDateTime,  -- ���� �������� ����
    IN inEndDate                TDateTime,  -- ���� �������� ����
    IN inValue                  TFloat,     -- ����
    IN inIsLast                 Boolean,    -- 
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
DECLARE
BEGIN
   -- !!!������ ��������!!!
   IF inIsLast = TRUE
   THEN PERFORM gpInsertUpdate_ObjectHistory_PriceListItemLast (ioId          := ioId
                                                              , inPriceListId := inPriceListToId
                                                              , inGoodsId     := inGoodsId
                                                              , inOperDate    := inStartDate
                                                              , inValue       := inValue
                                                              , inIsLast      := inIsLast
                                                              , inUserId      := vbUserId
                                                               );
   ELSE
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
-- SELECT * FROM gpInsertUpdate_ObjectHistory_PriceListItem_sybase (ioId := 0 , inPriceListId := 372 , inGoodsId := 406 , inOperDate := ('20.08.2015')::TDateTime , inValue := 59 , inIsLast := 'False' ,  inSession := '2');
