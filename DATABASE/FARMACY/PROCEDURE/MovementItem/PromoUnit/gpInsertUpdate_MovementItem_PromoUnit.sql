-- Function: gpInsertUpdate_MovementItem_PromoUnit()
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoUnit (Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, Boolean, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PromoUnit(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inAmountPlanMax       TFloat    , -- ���-�� ��� ������
    IN inPrice               TFloat    , -- ����
   OUT outSumm               TFloat    , -- �����
   OUT outSummPlanMax        TFloat    , -- �����
    IN inComment             TVarChar  , -- ����������
    IN inisFixedPercent      Boolean   , -- ������������� ������� ����������
    IN inAddBonusPercent     TFloat    , -- ���. ������� �������������
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PromoUnit());
    vbUserId := lpGetUserBySession (inSession);

    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    --��������� �����
    outSumm := ROUND(COALESCE(inAmount,0)*COALESCE(inPrice,0),2);
    outSummPlanMax := ROUND(COALESCE(inAmountPlanMax,0)*COALESCE(inPrice,0),2);

     -- ��������� <������� ���������>
     ioId:= lpInsertUpdate_MovementItem_PromoUnit (ioId                 := ioId
                                                 , inMovementId         := inMovementId
                                                 , inGoodsId            := inGoodsId
                                                 , inAmount             := inAmount
                                                 , inAmountPlanMax      := inAmountPlanMax
                                                 , inPrice              := inPrice
                                                 , inComment            := inComment
                                                 , inisFixedPercent     := inisFixedPercent
                                                 , inAddBonusPercent    := inAddBonusPercent
                                                 , inUserId             := vbUserId
                                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.    ��������� �.�.
 04.02.17         *
*/