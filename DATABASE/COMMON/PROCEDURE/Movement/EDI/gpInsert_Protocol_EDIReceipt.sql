-- Function: gpInsertUpdate_MI_EDI()

DROP FUNCTION IF EXISTS gpInsert_Protocol_EDIReceipt(TVarChar, TVarChar, TVarChar, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Protocol_EDIReceipt(
    IN inOKPOIn              TVarChar  ,
    IN inOKPOOut             TVarChar  ,
    IN inTaxNumber           TVarChar  , 
    IN inEDIEvent            TVarChar  , -- �������� �������
    IN inOperMonth           TDateTime , 
    IN inSession             TVarChar     -- ������������
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDI());
   vbUserId := lpGetUserBySession(inSession);

   PERFORM lpInsert_Movement_EDIEvents(inMovementId, inEDIEvent, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.08.14                         * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_EDI (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountSecond:= 0, inGoodsKindId:= 0, inSession:= '2')
