 -- Function: lpUpdate_MI_Income_Price()

DROP FUNCTION IF EXISTS lpUpdate_MI_Income_Price (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_MI_Income_Price(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inAmount              TFloat    , -- 
    IN inOperPrice_orig      TFloat    , -- ��. ���� ��� ������
    IN inCountForPrice       TFloat    , -- ���� �� ���.
 INOUT ioDiscountTax         TFloat    , -- % ������
 INOUT ioOperPrice           TFloat    , -- ��. ���� � ������ ������ � ��������
 INOUT ioSummIn              TFloat    , -- ����� ��. � ������ ������
    IN inAmount_old          TFloat    , --
    IN inOperPrice_orig_old  TFloat    , --
    IN inDiscountTax_old     TFloat    , --
    IN inOperPrice_old       TFloat    , --
    IN inSummIn_old          TFloat    , --
    IN inUserId              Integer    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
BEGIN

     -- �����������
     SELECT gpGet.ioDiscountTax, gpGet.ioOperPrice, gpGet.ioSummIn
            INTO ioDiscountTax, ioOperPrice, ioSummIn
     FROM gpGet_MI_Income_Price (ioAmount              := inAmount
                               , ioOperPrice_orig      := inOperPrice_orig
                               , inCountForPrice       := inCountForPrice
                               , ioDiscountTax         := ioDiscountTax
                               , ioOperPrice           := ioOperPrice
                               , ioSummIn              := ioSummIn
                               , inAmount_old          := inAmount_old
                               , inOperPrice_orig_old  := inOperPrice_orig_old
                               , inDiscountTax_old     := inDiscountTax_old
                               , inOperPrice_old       := inOperPrice_old
                               , inSummIn_old          := inSummIn_old
                               , inSession             := inUserId :: TVarChar
                                ) AS gpGet;
     

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice_orig(), inId, inOperPrice_orig);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), inId, inCountForPrice);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DiscountTax(), inId, ioDiscountTax);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), inId, ioOperPrice);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummIn(), inId, ioSummIn);

     RAISE EXCEPTION '������.<%>', ioSummIn;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm ((SELECT MovementItem.MovementId FROM MovementItem WHERE MovementItem.Id = inId));

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
