-- Function: gpInsertUpdate_MovementItem_Tax()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Tax (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Tax (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Tax (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Tax(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ����
 INOUT ioCountForPrice       TFloat    , -- ���� �� ����������
   OUT outAmountSumm         TFloat    , -- ����� ���������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inLineNumTax          Integer   , -- 
    IN inisName_new          Boolean   , -- ������������ ����� ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Tax());

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;


     -- ��������� <������� ���������>
     SELECT tmp.ioId, tmp.ioCountForPrice, tmp.outAmountSumm
            INTO ioId, ioCountForPrice, outAmountSumm
     FROM lpInsertUpdate_MovementItem_Tax (ioId                 := ioId
                                         , inMovementId         := inMovementId
                                         , inGoodsId            := inGoodsId
                                         , inAmount             := inAmount
                                         , inPrice              := inPrice
                                         , ioCountForPrice      := ioCountForPrice
                                         , inGoodsKindId        := inGoodsKindId
                                         , inUserId             := vbUserId
                                          ) AS tmp;

     IF inLineNumTax <> COALESCE ((SELECT gpSelect.LineNum FROM gpSelect_MovementItem_Tax (inMovementId:= inMovementId, inShowAll:= FALSE, inisErased:= FALSE, inSession:= inSession) AS gpSelect WHERE gpSelect.Id = ioId), 0)
        AND vbIsInsert = FALSE
        AND inLineNumTax > 0
     THEN
         -- ��������
         IF inLineNumTax <> COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_NPP()), 0)
            AND NOT EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.ValueData = TRUE AND MB.DescId = zc_MovementBoolean_DisableNPP_auto())
         THEN
              RAISE EXCEPTION '������.�� ���������� ������� <��������� �������� � �/�> = ��.';
         END IF;
    
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_NPP(), ioId, inLineNumTax);
     END IF;

     -- ��������� �������� <������������ ����� ��������>  --�������������� � �����
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Goods_Name_new(), ioId, inisName_new);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 08.08.21         * inisName_new
 10.02.14                                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Tax (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPrice:= 1, ioCountForPrice:= 1, inGoodsKindId:= 0, inSession:= '2')
