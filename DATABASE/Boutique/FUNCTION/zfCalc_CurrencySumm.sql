-- Function: ��������� � ������ ������

DROP FUNCTION IF EXISTS zfCalc_CurrencySumm (TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_CurrencySumm(
    IN inAmount          TFloat , -- ����� � ������ inCurrencyId_from
    IN inCurrencyId_from Integer,
    IN inCurrencyId_to   Integer,
    IN inCurrencyValue   TFloat ,
    IN inParValue        TFloat
)
RETURNS NUMERIC (20, 10)
AS
$BODY$
BEGIN
    -- ��� ����������
    RETURN COALESCE (CASE WHEN COALESCE (inCurrencyId_from, zc_Currency_Basis()) = COALESCE (inCurrencyId_to, zc_Currency_Basis())
                               -- ��������� ��� ����
                               THEN inAmount
          
                          WHEN COALESCE (inCurrencyId_from, zc_Currency_Basis()) = zc_Currency_Basis()
                               -- �� ��� -> � ������ 
                               THEN zfCalc_CurrencyTo (inAmount, inCurrencyValue, inParValue)
          
                          WHEN COALESCE (inCurrencyId_to, zc_Currency_Basis()) = zc_Currency_Basis()
                               -- �� ������ -> � ���
                               THEN zfCalc_CurrencyFrom (inAmount, inCurrencyValue, inParValue)
                     END, 0.0)
          ;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.05.20                                        *
*/

-- ����
-- SELECT * FROM zfCalc_CurrencySumm (inAmount:= 10, inCurrencyId_from:= zc_Currency_Basis(), inCurrencyId_to:= zc_Currency_EUR(),   inCurrencyValue:= 5, inParValue:= 1)
-- SELECT * FROM zfCalc_CurrencySumm (inAmount:= 10, inCurrencyId_from:= zc_Currency_EUR(),   inCurrencyId_to:= zc_Currency_Basis(), inCurrencyValue:= 5, inParValue:= 1)
