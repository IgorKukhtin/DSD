-- Function: gpInsert_MovementItem_AsinoPharmaSP()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_AsinoPharmaSP (Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_AsinoPharmaSP(
 INOUT ioId                   Integer   , -- ���� ������
    IN inMovementId           Integer   ,
    IN inGoodsId              Integer   , -- ������
    IN inPriceOptSP           TFloat    ,
    IN inNDS                  TFloat    ,
   OUT outPriceSale           TFloat    ,

    IN inSession              TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbOperDate_StartBegin TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
    
    outPriceSale := ROUND(inPriceOptSP *  1.1 * 1.1 * (1.0 + COALESCE(inNDS, 0) / 100), 2);  

    -- ��������� ������
    ioId := lpInsertUpdate_MovementItem_AsinoPharmaSP (ioId                  := COALESCE(ioId,0)
                                                    , inMovementId          := inMovementId
                                                    , inGoodsId             := inGoodsId
                                                    , inPriceOptSP          := inPriceOptSP
                                                    , inPriceSale           := outPriceSale
                                                    , inUserId              := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.04.22                                                       *
*/
--