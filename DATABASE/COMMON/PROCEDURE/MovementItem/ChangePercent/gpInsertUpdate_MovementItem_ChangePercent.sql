-- Function: gpInsertUpdate_MovementItem_ChangePercent()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ChangePercent (integer, integer, integer, tfloat, tfloat, tfloat, integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ChangePercent(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ����
 INOUT ioCountForPrice       TFloat    , -- ���� �� ����������
   OUT outAmountSumm         TFloat    , -- ����� ���������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ChangePercent());
     vbUserId:= lpGetUserBySession (inSession);

     -- ��������� <������� ���������>
     SELECT tmp.ioId, tmp.ioCountForPrice, tmp.outAmountSumm
            INTO ioId, ioCountForPrice, outAmountSumm
     FROM lpInsertUpdate_MovementItem_ChangePercent (ioId            := ioId
                                                   , inMovementId    := inMovementId
                                                   , inGoodsId       := inGoodsId
                                                   , inAmount        := inAmount
                                                   , inPrice         := inPrice
                                                   , ioCountForPrice := ioCountForPrice
                                                   , inGoodsKindId   := inGoodsKindId
                                                   , inUserId        := vbUserId
                                                    ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.03.23         *
*/

-- ����
--