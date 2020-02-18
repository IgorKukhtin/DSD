-- Function: gpInsertUpdate_MovementItem_TechnicalRediscount()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_TechnicalRediscount(Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_TechnicalRediscount(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , --
    IN inRemains_Amount      TFloat    , --
   OUT outDiffSumm           TFloat    , --
   OUT outRemains_FactAmount TFloat    , --
   OUT outRemains_FactSumm   TFloat    , --
   OUT outDeficit            TFloat    , --
   OUT outDeficitSumm        TFloat    , --
   OUT outProficit           TFloat    , --
   OUT outProficitSumm       TFloat    , --
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementIncomeId Integer;
   DECLARE vbAmountIncome TFloat;
   DECLARE vbAmountOther TFloat;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_TechnicalRediscount());

     IF ROUND(inRemains_Amount + inAmount, 4) < 0
     THEN
       RAISE EXCEPTION '������.����������� ���������� �� ����� ���� ������ 0.';
     END IF;

     ioId := lpInsertUpdate_MovementItem_TechnicalRediscount(ioId, inMovementId, inGoodsId, inAmount, vbUserId);

     outDiffSumm           := inAmount * inPrice;
     outRemains_FactAmount := inRemains_Amount + inAmount;
     outRemains_FactSumm   := (inRemains_Amount + inAmount) * inPrice;
     outDeficit            := CASE WHEN inAmount < 0 THEN - inAmount ELSE 0 END;
     outDeficitSumm        := CASE WHEN inAmount < 0 THEN - inAmount * inPrice ELSE 0 END;
     outProficit           := CASE WHEN inAmount > 0 THEN inAmount ELSE 0 END;
     outProficitSumm       := CASE WHEN inAmount > 0 THEN inAmount * inPrice ELSE 0 END;


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.02.15                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_TechnicalRediscount (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')