-- Function: gpInsertUpdate_MovementItem_OrderReturnTare()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderReturnTare (Integer, Integer, Integer, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderReturnTare (Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderReturnTare(
 INOUT ioId                     Integer   , -- ���� ������� <������� ���������>
    IN inMovementId             Integer   , -- ���� ������� <�������� ������� ����������>
    IN inGoodsId                Integer   , -- ������
    IN inPartnerId              Integer   , -- ����������
    IN inAmount                 TFloat    , -- ����������
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderReturnTare());
     vbUserId:= lpGetUserBySession (inSession);

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem_OrderReturnTare (ioId           := ioId
                                                        , inMovementId   := inMovementId
                                                        , inGoodsId      := inGoodsId
                                                        , inPartnerId    := inPartnerId
                                                        , inAmount       := inAmount
                                                        , inUserId       := vbUserId
                                                         ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.01.22         *
*/

-- ����
--