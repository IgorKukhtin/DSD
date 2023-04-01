-- Function: ��������� �� ������ - ����������, �.�. � ���

DROP FUNCTION IF EXISTS zfCalc_CurrencyFrom_all (TFloat, Integer, TFloat, TFloat, Integer, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION zfCalc_CurrencyFrom_all(
    IN inAmount            TFloat, -- ����� � ������ / ��� � ���
    IN inCurrencyId_from   Integer,
    IN inCurrencyValue_1   TFloat, -- ����
    IN inParValue_1        TFloat, -- �������
    IN inCurrencyId_1      Integer,
    IN inCurrencyValue_2   TFloat, -- ����
    IN inParValue_2        TFloat, -- �������
    IN inCurrencyId_2      Integer
)
RETURNS TFloat
AS
$BODY$
BEGIN
    -- ����������
    RETURN zfCalc_SummPriceList (1, CASE WHEN inCurrencyId_from = inCurrencyId_1
                                              THEN zfCalc_CurrencyFrom (inAmount, inCurrencyValue_1, inParValue_1)
                                         WHEN inCurrencyId_from = inCurrencyId_2
                                              THEN zfCalc_CurrencyFrom (inAmount, inCurrencyValue_2, inParValue_2)
                                         ELSE inAmount
                                    END)
          ;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.07.17                                        *
*/

-- ����
-- SELECT * FROM zfCalc_CurrencyFrom_all (inAmount:= 2, inCurrencyId_from:= zc_Currency_USD(), inCurrencyValue_1:= 40, inParValue_1:= 1, inCurrencyId_1:= zc_Currency_EUR(), inCurrencyValue_2:= 20, inParValue_2:= 1, inCurrencyId_2:= zc_Currency_USD())
