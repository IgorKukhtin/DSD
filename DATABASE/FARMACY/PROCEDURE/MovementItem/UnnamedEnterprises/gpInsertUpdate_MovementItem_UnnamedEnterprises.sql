-- Function: gpInsertUpdate_MovementItem_UnnamedEnterprises()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_UnnamedEnterprises (Integer, Integer, Integer, TVarChar, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_UnnamedEnterprises(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inGoodsNameUkr        TVarChar  , -- �������� ����������
    IN inAmount              TFloat    , -- ����������
    IN inAmountOrder         TFloat    , -- ���������� � �����
    IN inPrice               TFloat    , -- ����
   OUT outSumm               TFloat    , -- �����
   OUT outSummOrder          TFloat    , -- ����� � �����
    IN inCodeUKTZED          TVarChar  , -- ��� ������
    IN inExchangeId          Integer   , -- ��
    IN inNDSKindId           Integer   , -- ���
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS record
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbGoodsId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbAmountOrder TFloat;
   DECLARE vbPrice TFloat;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_UnnamedEnterprises());
    vbUserId := inSession;

    IF COALESCE (inNDSKindId, 0) = 0
    THEN
      inNDSKindId := COALESCE((SELECT Object_Goods_Main.NDSKindId FROM  Object_Goods_Retail
                                      LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                               WHERE Object_Goods_Retail.Id = inGoodsId), zc_Enum_NDSKind_Medical());
    
    END IF;

    SELECT
      MovementItem.ObjectId,
      MovementItem.Amount,
      MIFloat_AmountOrder.ValueData,
      MIFloat_Price.ValueData
    INTO
      vbGoodsId,
      vbAmount,
      vbAmountOrder,
      vbPrice
    FROM MovementItem
         LEFT JOIN MovementItemFloat AS MIFloat_AmountOrder
                                     ON MIFloat_AmountOrder.MovementItemId = MovementItem.Id
                                    AND MIFloat_AmountOrder.DescId = zc_MIFloat_AmountOrder()

         LEFT JOIN MovementItemFloat AS MIFloat_Price
                                     ON MIFloat_Price.MovementItemId = MovementItem.Id
                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()

    WHERE MovementItem.ID = ioId;
    
    IF COALESCE(ioId, 0) = 0 or COALESCE(inGoodsId, 0) <> COALESCE(vbGoodsId, 0) or COALESCE(inAmount, 0) <> COALESCE(vbAmount, 0) or
       COALESCE(inAmountOrder, 0) <> COALESCE(vbAmountOrder, 0) or COALESCE(inPrice, 0) <> COALESCE(vbPrice, 0)
    THEN
      IF EXISTS(SELECT 1 FROM MovementLinkMovement
                WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Sale()
                  AND MovementLinkMovement.MovementId = inMovementId)
      THEN
        RAISE EXCEPTION '������. �� ������� ����������� ������� ������� <%> �� <%>...',
          (SELECT Movement.InvNumber
           FROM MovementLinkMovement
                INNER JOIN Movement ON Movement.ID = MovementLinkMovement.MovementChildId
           WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Sale()
             AND MovementLinkMovement.MovementId = inMovementId),
          (SELECT to_char(Movement.OperDate, 'DD-MM-YYYY')
           FROM MovementLinkMovement
                INNER JOIN Movement ON Movement.ID = MovementLinkMovement.MovementChildId
           WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Sale()
             AND MovementLinkMovement.MovementId = inMovementId);
      END IF;

/*      IF EXISTS(SELECT 1 FROM MovementLinkMovement
                WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Order()
                  AND MovementLinkMovement.MovementId = inMovementId) AND
         NOT EXISTS(SELECT 1 FROM MovementItemFloat
               WHERE MovementItemFloat.DescId = zc_MIFloat_AmountOrder() AND MovementItemFloat.MovementItemId = ioId
                 AND COALESCE (MovementItemFloat.ValueData, 0) = COALESCE (inAmountOrder, 0))
      THEN
        RAISE EXCEPTION '������. ������ ��������� �� ���������� ����� ����� <%> �� <%>. ��������� ���������� � ����� ���������...',
          (SELECT Movement.InvNumber
           FROM MovementLinkMovement
                INNER JOIN Movement ON Movement.ID = MovementLinkMovement.MovementChildId
           WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Order()
             AND MovementLinkMovement.MovementId = inMovementId),
          (SELECT to_char(Movement.OperDate, 'DD-MM-YYYY')
           FROM MovementLinkMovement
                INNER JOIN Movement ON Movement.ID = MovementLinkMovement.MovementChildId
           WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Order()
             AND MovementLinkMovement.MovementId = inMovementId);
      END IF; */
    END IF; 

    --��������� �����
    outSumm := ROUND(COALESCE(inAmount,0)*COALESCE(inPrice,0),2);
    outSummOrder := ROUND(COALESCE(inAmountOrder,0)*COALESCE(inPrice,0),2);

     -- ���������
    ioId := lpInsertUpdate_MovementItem_UnnamedEnterprises (ioId                 := ioId
                                            , inMovementId         := inMovementId
                                            , inGoodsId            := inGoodsId
                                            , inAmount             := inAmount
                                            , inAmountOrder        := inAmountOrder
                                            , inPrice              := inPrice
                                            , inSumm               := outSumm
                                            , inSummOrder          := outSummOrder
                                            , inNDSKindId          := inNDSKindId 
                                            , inUserId             := vbUserId
                                             );

   IF (COALESCE (inGoodsNameUkr, '') <> '' OR COALESCE (inCodeUKTZED, '') <> '' OR COALESCE (inExchangeId, 0) <> 0)
     AND EXISTS(SELECT Object_Goods_View.Id
                FROM Object_Goods_Retail

                     LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

                WHERE Object_Goods_Retail.Id = inGoodsId AND (
                     ((COALESCE (inGoodsNameUkr, '') <> '') AND COALESCE (Object_Goods_Main.NameUkr, '') <> COALESCE (inGoodsNameUkr, '')) OR
                     ((COALESCE (inCodeUKTZED, '') <> '') AND COALESCE (Object_Goods_Main.CodeUKTZED, '') <> COALESCE (inCodeUKTZED, '')) OR
                     ((COALESCE (inExchangeId, 0) <> 0) AND COALESCE (Object_Goods_Main.ExchangeId, 0) <> COALESCE (inExchangeId, 0))))
   THEN
      PERFORM lpUpdate_MovementItem_UnnamedEnterprises_Goods(
                                              inId           := inGoodsId
                                            , inNameUkr      := inGoodsNameUkr
                                            , inCodeUKTZED   := inCodeUKTZED
                                            , inExchangeId   := inExchangeId
                                            , inSession      := inSession) ;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������ �.�.
 21.04.20         *
 05.12.18         *
 02.10.18         *
 30.09.18         *
*/