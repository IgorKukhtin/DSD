-- Function: gpInsertUpdate_MovementItem_UnnamedEnterprises()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_UnnamedEnterprises (Integer, Integer, Integer, TVarChar, TFloat, TFloat, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_UnnamedEnterprises (Integer, Integer, Integer, TVarChar, TFloat, TFloat, TFloat, TVarChar, Integer, TVarChar);

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

      IF EXISTS(SELECT 1 FROM MovementLinkMovement
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
      END IF;
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
                                            , inUserId             := vbUserId
                                             );

   IF (COALESCE (inGoodsNameUkr, '') <> '' OR COALESCE (inCodeUKTZED, '') <> '' OR COALESCE (inExchangeId, 0) <> 0)
     AND EXISTS(SELECT Object_Goods_View.Id
                FROM Object_Goods_View
                  LEFT JOIN ObjectString AS ObjectString_Goods_NameUkr
                                         ON ObjectString_Goods_NameUkr.ObjectId = Object_Goods_View.Id
                                        AND ObjectString_Goods_NameUkr.DescId = zc_ObjectString_Goods_NameUkr()

                  LEFT JOIN ObjectString AS ObjectString_Goods_CodeUKTZED
                                         ON ObjectString_Goods_CodeUKTZED.ObjectId = Object_Goods_View.Id
                                        AND ObjectString_Goods_CodeUKTZED.DescId = zc_ObjectString_Goods_CodeUKTZED()

                  LEFT JOIN ObjectLink AS ObjectLink_Goods_Exchange
                                       ON ObjectLink_Goods_Exchange.ObjectId = Object_Goods_View.Id
                                      AND ObjectLink_Goods_Exchange.DescId = zc_ObjectLink_Goods_Exchange()

             WHERE Object_Goods_View.Id = inGoodsId AND (
                 ((COALESCE (inGoodsNameUkr, '') <> '') AND COALESCE (ObjectString_Goods_NameUkr.ValueData, '') <> COALESCE (inGoodsNameUkr, '')) OR
                 ((COALESCE (inCodeUKTZED, '') <> '') AND COALESCE (ObjectString_Goods_CodeUKTZED.ValueData, '') <> COALESCE (inCodeUKTZED, '')) OR
                 ((COALESCE (inExchangeId, 0) <> 0) AND COALESCE (ObjectLink_Goods_Exchange.ChildObjectId, 0) <> COALESCE (inExchangeId, 0))))
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
 05.12.18         *
 02.10.18         *
 30.09.18         *
*/