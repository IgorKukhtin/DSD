-- Function: gpGet_MI_Income_Price()

DROP FUNCTION IF EXISTS gpGet_MI_Income_Price (TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Income_Price(
 INOUT ioAmount              TFloat    , --
 INOUT ioOperPrice_orig      TFloat    , -- ��. ���� ��� ������
    IN inCountForPrice       TFloat    , -- ���� �� ���.
 INOUT ioDiscountTax         TFloat    , -- % ������
 INOUT ioOperPrice           TFloat    , -- ��. ���� � ������ ������ � ��������
 INOUT ioSummIn              TFloat    , -- ����� ��. � ������ ������
    IN inAmount_old          TFloat    , --
    IN inOperPrice_orig_old  TFloat    , --
    IN inDiscountTax_old     TFloat    , --
    IN inOperPrice_old       TFloat    , --
    IN inSummIn_old          TFloat    , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
BEGIN
     -- ���� ������ �� ���������� ����� �������
     IF inAmount_old = ioAmount AND inOperPrice_orig_old = ioOperPrice_orig AND inDiscountTax_old = ioDiscountTax AND inOperPrice_old = ioOperPrice AND inSummIn_old = ioSummIn
     THEN
         RETURN;
     END IF;


     -- ���� ���-��
     IF COALESCE (inAmount_old,0) <> COALESCE (ioAmount,0) OR COALESCE (inOperPrice_orig_old,0) <> COALESCE (ioOperPrice_orig,0)
     THEN
         -- ��. ���� � ������ ������ � ��������
         ioOperPrice := (ioOperPrice_orig * (1 - ioDiscountTax / 100)) ::TFloat;
         -- ����� ��. � ������ ������
         ioSummIn    := (ioAmount * ioOperPrice) ::TFloat;

     -- ���� % ������
     ELSEIF COALESCE (inDiscountTax_old,0) <> COALESCE (ioDiscountTax,0)
     THEN
         -- ��. ���� � ������ ������ � ��������
         ioOperPrice := (ioOperPrice_orig * (1 - ioDiscountTax / 100)) ::TFloat;
         -- ����� ��. � ������ ������
         ioSummIn    := (ioAmount * ioOperPrice) ::TFloat;

     -- ���� ��. ���� � ������ ������ � ��������
     ELSEIF COALESCE (inOperPrice_old,0) <> COALESCE (ioOperPrice,0)
     THEN
         -- % ������
         ioDiscountTax := CASE WHEN COALESCE (ioOperPrice_orig,0) <> 0 THEN ((ioOperPrice_orig - ioOperPrice) * 100 / ioOperPrice_orig) ELSE 0 END ::TFloat;
         -- ����� ��. � ������ ������
         ioSummIn      := (ioAmount * ioOperPrice) ::TFloat;

     -- ���� ����� ��. � ������ ������
     ELSEIF COALESCE (inSummIn_old,0) <> COALESCE (ioSummIn,0)
     THEN
         -- % ������ - ��������
         ioDiscountTax := 0 ::TFloat;
         -- ��. ���� � ������ ������ � ��������
         ioOperPrice   := CASE WHEN COALESCE (ioAmount,0) <> 0 THEN ioSummIn /ioAmount ELSE 0 END ::TFloat;

     END IF;

  --RAISE EXCEPTION '0. SummIn <%>  ioOperPrice <%>  ioDiscountTax <%> ioOperPrice_orig <%> ' , ioSummIn, ioOperPrice, ioDiscountTax, ioOperPrice_orig;

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
