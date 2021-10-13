-- Function: gpGet_MI_Income_OperPriceList()


DROP FUNCTION IF EXISTS gpGet_MI_Income_Price (TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Income_Price(
    IN inAmount                TFloat    , -- 
    IN ioOperPrice_orig        TFloat    , -- ���� ��.
    IN ioDiscountTax           TFloat    , -- % ������
    IN ioOperPrice             TFloat    , -- ���� ��. � ������ ������ � ��������
    IN ioSummIn                TFloat    , -- ����� ��. � ������ ������
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS TABLE (Amount      TFloat
             , OperPrice_orig  TFloat
             , DiscountTax TFloat
             , OperPrice   TFloat
             , SummIn      TFloat
              )
AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbOperPrice_orig TFloat;
   DECLARE vbDiscountTax TFloat;
   DECLARE vbOperPrice TFloat;
   DECLARE vbSummIn TFloat;
   DECLARE vbAmount TFloat;
   DECLARE vbPravilo TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpGetUserBySession (inSession);

     -- �������� ����������� ���������
     vbOperPrice_orig:= (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_OperPrice_orig());
     vbDiscountTax   := (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_DiscountTax());
     vbOperPrice     := (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_OperPrice());
     vbSummIn        := (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummIn());
     vbAmount        := (SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = inId AND MovementItem.DescId = zc_MI_Master());

     IF COALESCE (inOperPriceList,0) <> COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_OperPrice_orig()),0)
     THEN
         -- ��������� �������� <OperPriceList>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), inId, inOperPriceList);
     END IF;
     
     -- ���� ������ �� ���������� ����� �������
     IF vbAmount = inAmount AND vbOperPrice_orig = ioOperPrice_orig AND vbDiscountTax = ioDiscountTax AND vbOperPrice = ioOperPrice AND vbSummIn = ioSummIn
     THEN
         RETURN;
     END IF;
     
     
     --���������� ��� ����������
     IF COALESCE (vbAmount,0) <> COALESCE (inAmount,0) OR COALESCE (vbOperPrice_orig,0) <> COALESCE (ioOperPrice_orig,0)
     THEN
         vbPravilo := 'Amount';
     END IF;
     IF COALESCE (vbDiscountTax,0) <> COALESCE (ioDiscountTax,0)
     THEN
         vbPravilo := 'DiscountTax';
     END IF;
     IF COALESCE (vbOperPrice,0) <> COALESCE (ioOperPrice,0)
     THEN
         vbPravilo := 'OperPrice';
     END IF;
     IF COALESCE (vbSummIn,0) <> COALESCE (ioSummIn,0)
     THEN
         vbPravilo := 'SummIn';
     END IF;

     IF vbPravilo = 'Amount'
     THEN
     
         ioOperPrice := (ioOperPrice_orig * (1 - ioDiscountTax / 100)) ::TFloat;
         ioSummIn    := (inAmount * ioOperPrice) ::TFloat;

     END IF;

     IF vbPravilo = 'DiscountTax'
     THEN
         ioOperPrice := (ioOperPrice_orig * (1 - ioDiscountTax / 100)) ::TFloat;
         ioSummIn    := (inAmount * ioOperPrice) ::TFloat;
     END IF;
     
     IF vbPravilo = 'OperPrice'
     THEN
         ioDiscountTax := CASE WHEN COALESCE (ioOperPrice_orig,0) <> 0 THEN ((ioOperPrice_orig - ioOperPrice) * 100 / ioOperPrice_orig) ELSE 0 END ::TFloat;
         ioSummIn      := (inAmount * ioOperPrice) ::TFloat;

     END IF;

     IF vbPravilo = 'SummIn'
     THEN
         ioOperPrice   := CASE WHEN COALESCE (inAmount,0) <> 0 THEN ioSummIn /inAmount ELSE 0 END ::TFloat;
         ioDiscountTax := 0 ::TFloat;
         ioOperPrice_orig := ioOperPrice ::TFloat;
     END IF;

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), inId, ioOperPrice);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice_orig(), inId, ioOperPrice_orig);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DiscountTax(), inId, ioDiscountTax);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummIn(), inId, ioSummIn);
     
     RETURN QUERY
     SELECT inAmount      ::TFloat
          , ioOperPrice_orig :: TFloat
          , ioDiscountTax ::TFloat
          , ioOperPrice   ::TFloat
          , ioSummIn      ::TFloat
     ;



                
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 07.02.19         * inMovementItemId
 24.04.18         *
 24.03.18         *
 06.06.17         *
*/

-- ����
-- SELECT * FROM gpGet_MI_Income_OperPriceList (inMovementId := 248647 , inGoodsName := '961 * �5 *  *' ,inOperPrice:= 156, inCountForPrice:= 1, ioOperPriceList:= 256, inSession:= zfCalc_UserAdmin());
