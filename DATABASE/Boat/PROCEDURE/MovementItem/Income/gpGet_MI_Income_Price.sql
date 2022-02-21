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


     -- ���� ���-�� ��� ��. ���� ��� ������
     IF COALESCE (inAmount_old,0) <> COALESCE (ioAmount,0) OR COALESCE (inOperPrice_orig_old,0) <> COALESCE (ioOperPrice_orig,0)
     THEN
         -- ������ ��. ���� � ������ ������
         ioOperPrice := zfCalc_SummDiscountTax(ioOperPrice_orig, ioDiscountTax);
         -- ����� ��. � ������ ������
         ioSummIn    := zfCalc_SummIn (ioAmount, ioOperPrice, inCountForPrice);

     -- ���� % ������
     ELSEIF COALESCE (inDiscountTax_old,0) <> COALESCE (ioDiscountTax,0)
     THEN
         -- ������ ��. ���� � ������ ������
         ioOperPrice := zfCalc_SummDiscountTax(ioOperPrice_orig, ioDiscountTax);
         -- ����� ��. � ������ ������
         ioSummIn    := zfCalc_SummIn (ioAmount, ioOperPrice, inCountForPrice);

     -- ���� ��. ���� � ������ ������ � ��������
     ELSEIF COALESCE (inOperPrice_old,0) <> COALESCE (ioOperPrice,0)
     THEN
         -- ����� ��. � ������ ������
         ioSummIn    := zfCalc_SummIn (ioAmount, ioOperPrice, inCountForPrice);
         -- ������ % ������
         ioDiscountTax := zfCalc_DiscountTax (ioOperPrice_orig - ioOperPrice, ioOperPrice_orig);

     -- ���� ����� ��. � ������ ������
     ELSEIF COALESCE (inSummIn_old,0) <> COALESCE (ioSummIn,0)
     THEN
         -- ������ ��. ���� � ������ ������
         ioOperPrice   := CASE WHEN COALESCE (ioAmount,0) <> 0 THEN ioSummIn / ioAmount ELSE 0.0 END;
         -- % ������ - ��������
         ioDiscountTax := 0 ::TFloat;

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
