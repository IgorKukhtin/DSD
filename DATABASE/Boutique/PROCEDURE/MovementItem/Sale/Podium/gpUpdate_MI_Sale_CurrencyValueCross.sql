-- Function: gpUpdate_MI_Sale_CurrencyValueCross()

DROP FUNCTION IF EXISTS gpUpdate_MI_Sale_CurrencyValueCross (TFloat,TFloat,TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Sale_CurrencyValueCross(
    IN inCurrencyValueUSD     TFloat   , --
    IN inCurrencyValueEUR     TFloat   , --
   OUT outCurrencyValueCross  TFloat   , --
    IN inSession              TVarChar   -- ������ ������������
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmountPay_GRN      TFloat;
   DECLARE vbAmountDiscount_GRN TFloat;
   DECLARE vbCurrencyValueUSD   NUMERIC (20, 10);
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     -- !������! ����, ����� ������������� ��-�� �����-�����, 2 �����
     IF COALESCE (inCurrencyValueUSD, 0) = 0
     THEN
       outCurrencyValueCross := 1;
     ELSE     
       outCurrencyValueCross := inCurrencyValueEUR / inCurrencyValueUSD;
     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.02.24                                                       *
*/

-- select * from gpUpdate_MI_Sale_CurrencyValueCross(inCurrencyValueUSD := 37.68 , inCurrencyValueEUR := 40.95 ,  inSession := '2');