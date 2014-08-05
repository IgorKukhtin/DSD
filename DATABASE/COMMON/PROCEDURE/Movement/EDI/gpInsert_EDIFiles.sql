-- Function: gpInsert_EDIFiles()

DROP FUNCTION IF EXISTS gpInsert_EDIFiles(Integer, TVarChar, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_EDIFiles(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inFileName            TVarChar  , -- �������� �������
    IN inFileText            TBlob     , 
    IN inSession             TVarChar     -- ������������
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDI());
   vbUserId := lpGetUserBySession(inSession);

   PERFORM lpInsertUpdate_MovementString(zc_MovementString_FileName(), inMovementId, inFileName);

   PERFORM lpInsertUpdate_MovementBlob(zc_MovementBlob_Comdoc(), inMovementId, inFileText);


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.06.14                         * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_EDI (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountSecond:= 0, inGoodsKindId:= 0, inSession:= '2')
