-- Function: gpInsertUpdate_MovementItem_Promo()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Promo (Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Promo(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ����
   OUT outSumm               TFloat    , -- �����
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Promo());
    vbUserId := inSession;
    --��������� �����
    outSumm := ROUND(COALESCE(inAmount,0)*COALESCE(inPrice,0),2);
     -- ���������
    ioId := lpInsertUpdate_MovementItem_Promo (ioId                 := ioId
                                             , inMovementId         := inMovementId
                                             , inGoodsId            := inGoodsId
                                             , inAmount             := inAmount
                                             , inPrice              := inPrice
                                             , inUserId             := vbUserId
                                             );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.    ��������� �.�.
 24.04.16         *
*/