-- Function: gpInsertUpdate_MI_EDI()

DROP FUNCTION IF EXISTS gpUpdate_Movement_DeclarAmount(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_DeclarAmount(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inAmount              Integer   , -- �������� Declar
    IN inSession             TVarChar     -- ������������
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDI());
   vbUserId := lpGetUserBySession(inSession);

   PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Amount(), inMovementId, inAmount);

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
