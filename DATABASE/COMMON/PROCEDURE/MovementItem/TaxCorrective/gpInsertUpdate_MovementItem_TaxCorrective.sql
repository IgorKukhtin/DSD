-- Function: gpInsertUpdate_MovementItem_TaxCorrective()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_TaxCorrective (integer, integer, integer, tfloat, tfloat, tfloat, integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_TaxCorrective (integer, integer, integer, tfloat, tfloat, tfloat, integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_TaxCorrective(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ����
 INOUT ioCountForPrice       TFloat    , -- ���� �� ����������
   OUT outAmountSumm         TFloat    , -- ����� ���������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inLineNumTaxOld       Integer   , -- � �/� � ��
    IN inLineNumTax          Integer   , -- � �/� � �� ����� ��������
   OUT outisAuto             Boolean   , -- ����������� ��������� (� �/� � ��)
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_TaxCorrective());

     -- ��������� <������� ���������>
     SELECT tmp.ioId, tmp.ioCountForPrice, tmp.outAmountSumm
            INTO ioId, ioCountForPrice, outAmountSumm
     FROM lpInsertUpdate_MovementItem_TaxCorrective (ioId            := ioId
                                                   , inMovementId    := inMovementId
                                                   , inGoodsId       := inGoodsId
                                                   , inAmount        := inAmount
                                                   , inPrice         := inPrice
                                                   , inPriceTax_calc := (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = @ioId AND MIF.DescId = zc_MIFloat_PriceTax_calc())
                                                   , ioCountForPrice := ioCountForPrice
                                                   , inGoodsKindId   := inGoodsKindId
                                                   , inUserId        := vbUserId
                                                    ) AS tmp;

     -- ��������� �������� � �� ��, ���� �������� , ������������� �������� ���� = False
     outisAuto :=TRUE;
     IF COALESCE (inLineNumTaxOld, 0) <> COALESCE (inLineNumTax, 0) AND COALESCE (inLineNumTax, 0) <> 0
      THEN 
          PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isAuto(), ioId, FALSE);
          PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_NPP(), ioId, inLineNumTax);
          outisAuto := FALSE;
     END IF;
     IF COALESCE (inLineNumTaxOld, 0) <> COALESCE (inLineNumTax, 0) AND COALESCE (inLineNumTax, 0) = 0
      THEN 
          PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isAuto(), ioId, TRUE);
     END IF;
 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 30.03.16         *
 10.02.14                                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_TaxCorrective (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPrice:= 1, ioCountForPrice:= 1, inGoodsKindId:= 0, inSession:= '2')
