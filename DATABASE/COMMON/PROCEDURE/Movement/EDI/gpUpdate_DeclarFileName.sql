-- Function: gpInsert_EDIFiles()

DROP FUNCTION IF EXISTS gpUpdate_DeclarFileName(Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_DeclarFileName(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inFileName            TVarChar  , -- �������� �������
    IN inSession             TVarChar     -- ������������
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDI());
   vbUserId := lpGetUserBySession(inSession);

   PERFORM lpInsertUpdate_MovementString(zc_MovementString_DeclarFileName(), inMovementId, inFileName);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.03.15                         * 
 14.10.14                         * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_EDI (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountSecond:= 0, inGoodsKindId:= 0, inSession:= '2')
