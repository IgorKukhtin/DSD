 -- Function: gpUpdate_MI_Income_Price()

DROP FUNCTION IF EXISTS gpUpdate_MI_Income_Price (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_Income_Price (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_Income_Price (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_MI_Income_Price(
    IN inId                    Integer   , -- ���� ������� <������� ���������>
    IN inAmount                TFloat    , -- 
    IN ioOperPrice_orig        TFloat    , -- ���� ��.
 INOUT ioDiscountTax           TFloat    , -- % ������
 INOUT ioOperPrice             TFloat    , -- ���� ��. � ������ ������ � ��������
 INOUT ioSummIn                TFloat    , -- ����� ��. � ������ ������
 INOUT inSummIn_inf              TFloat    , -- ����� ���������������
    IN inOperPriceList            TFloat    , -- ���� �������
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperPrice_orig TFloat;
   DECLARE vbDiscountTax TFloat;
   DECLARE vbOperPrice TFloat;
   DECLARE vbSummIn TFloat;
   DECLARE vbAmount TFloat;
   DECLARE vbPravilo TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_Income_Price());
     vbUserId := lpGetUserBySession (inSession);


     -- �������� - �������� ������ ���� ��������
     IF COALESCE (inId, 0) = 0 THEN 

        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.������� �� ��������.' :: TVarChar
                                              , inProcedureName := 'gpUpdate_MI_Income_Price'   :: TVarChar
                                              , inUserId        := vbUserId);
     END IF;

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
     ELSE

     IF COALESCE (vbDiscountTax,0) <> COALESCE (ioDiscountTax,0)
     THEN
         vbPravilo := 'DiscountTax';
     ELSE 

    IF COALESCE (vbOperPrice,0) <> COALESCE (ioOperPrice,0)
     THEN
         vbPravilo := 'OperPrice';
     ELSE 

     IF COALESCE (vbSummIn,0) <> COALESCE (ioSummIn,0) --AND (vbAmount = inAmount AND vbOperPrice_orig = ioOperPrice_orig AND vbDiscountTax = ioDiscountTax AND vbOperPrice = ioOperPrice)
      -- AND COALESCE (vbSummIn,0) <> (inAmount * (ioOperPrice_orig * (1 - ioDiscountTax / 100)))   
     THEN
         vbPravilo := 'SummIn';
     END IF;


     END IF;


     END IF;

     END IF;

 


--RAISE EXCEPTION '0. vbPravilo <%> ' , vbPravilo;

----RAISE EXCEPTION '0. vbOperPrice_orig <%>  vbDiscountTax <%>  vbOperPrice <%>  vbSummIn <%>  vbAmount <%>' , vbOperPrice_orig, vbDiscountTax, vbOperPrice, vbSummIn , vbAmount;


/*
��� ��-�� zc_MI_Master - c_Movement_Income - ��� ��� ��� �������� � ���� ����� - 
1) ���-�� 
2)OperPrice_orig 
3)DiscountTax  
4)OperPrice 
5)SummIn 
6)OperPriceList

 - � ���� ����������, 
 1) ���� ��������� ������� DiscountTax  - ����������� 4�5 
 2) ���� ��������� ������� OperPrice  - ����������� 3�5 
 3) ���� ��������� ������� SummIn  - ����������� 4 � � 3 ��������� 0 
 4) ���� ��������� ������� ���-�� ��� OperPrice_orig - 4 � 5 ����������� � ��� ����� ������� ���� � DiscountTax <> 0 
 
 ��� ����������� ����� ������ ������� �������� - ������ ��� ������� ���� � ������� �������� ������ � ������������ ����� �������� ���������,
  � ����� ��� �������� ���������, ��� ��������� ������ - ����� ��� ����  � ����� ����� ���������� ����� ������� ��������
*/


     IF vbPravilo = 'Amount'
     THEN
     
         ioOperPrice := (ioOperPrice_orig * (1 - ioDiscountTax / 100)) ::TFloat;
         ioSummIn    := (inAmount * ioOperPrice) ::TFloat;

         -- ������������� <������� ���������>
         PERFORM lpInsertUpdate_MovementItem (inId
                                             , zc_MI_Master()
                                             , (SELECT MovementItem.ObjectId FROM MovementItem WHERE MovementItem.Id = inId AND MovementItem.DescId = zc_MI_Master()) --inGoodsId
                                             , inId
                                             , (SELECT MovementItem.MovementId FROM MovementItem WHERE MovementItem.Id = inId AND MovementItem.DescId = zc_MI_Master())--inMovementId
                                             , inAmount
                                             , NULL
                                             , vbUserId
                                             );
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
  --RAISE EXCEPTION '0. SummIn <%>  ioOperPrice <%>  ioDiscountTax <%> ioOperPrice_orig <%> ' , ioSummIn, ioOperPrice, ioDiscountTax, ioOperPrice_orig;
     END IF;

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), inId, ioOperPrice);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice_orig(), inId, ioOperPrice_orig);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DiscountTax(), inId, ioDiscountTax);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummIn(), inId, ioSummIn);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.10.21         *
*/

-- ����
-- 
