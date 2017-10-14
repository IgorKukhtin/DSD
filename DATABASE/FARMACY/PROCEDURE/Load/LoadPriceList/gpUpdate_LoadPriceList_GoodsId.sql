-- Function: gpInsertUpdate_Movement_LoadPriceList()

DROP FUNCTION IF EXISTS gpUpdate_LoadPriceList_GoodsId (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_LoadPriceList_GoodsId(
    IN inPriceListItemId     Integer   , -- ������ �� ������� ������
    IN inGoodsId             Integer   , -- ������ �� �����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
BEGIN

     IF inGoodsId = 0 THEN 
        inGoodsId := NULL;
     END IF; 

     UPDATE LoadPriceListItem SET GoodsId = inGoodsId
      WHERE Id = inPriceListItemId;


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 23.07.14                        *


*/

-- ����
-- SELECT * FROM gpUpdate_LoadPriceList_GoodsId (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
