-- Function: gpInsertUpdate_MovementItem_IncomeAsset()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_IncomeAsset (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_IncomeAsset(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
 INOUT ioAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ����
    IN inMIId_Invoice        TFloat    , -- ������� ��������� C���
 INOUT ioCountForPrice       TFloat    , -- ���� �� ����������
   OUT outAmountSumm         TFloat    , -- ����� ���������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_IncomeAsset());
     vbUserId:= lpGetUserBySession (inSession);

     -- �������� �������� <���� �� ����������>
     IF COALESCE (ioCountForPrice, 0) = 0 THEN ioCountForPrice := 1; END IF;

     -- ���������
     ioId:= lpInsertUpdate_MovementItem_IncomeAsset (ioId                 := ioId
                                                   , inMovementId         := inMovementId
                                                   , inGoodsId            := inGoodsId
                                                   , inAmount             := ioAmount
                                                   , inPrice              := inPrice
                                                   , inCountForPrice      := ioCountForPrice
                                                   , inMIId_Invoice       := inMIId_Invoice
                                                   , inUserId             := vbUserId
                                                    );


     -- ��������� ����� �� ��������, ��� �����
     outAmountSumm := CASE WHEN ioCountForPrice > 0
                                THEN CAST (ioAmount * inPrice / ioCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (ioAmount * inPrice AS NUMERIC (16, 2))
                      END;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.07.16         *
*/

-- ����
-- 