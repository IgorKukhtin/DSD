-- Function: ��������� �� ������ - ����������, �.�. � ���

DROP FUNCTION IF EXISTS zfCalc_CurrencyFrom_2 (TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_CurrencyFrom_2(
    IN inAmount        TFloat, -- ����� � ������
    IN inCurrencyValue TFloat, -- ����
    IN inParValue      TFloat  -- �������
)
RETURNS TFloat
AS
$BODY$
BEGIN
    -- ��� ����������
    RETURN CAST (COALESCE (inAmount, 0)
               * COALESCE (inCurrencyValue, 0)
               / CASE WHEN inParValue > 0 THEN inParValue ELSE 1 END

           AS NUMERIC (16, 2));

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
-- SELECT zfCalc_CurrencyFrom_2 (inAmount:= 2, inCurrencyValue:= 5.1234, inParValue:= 1), zfCalc_CurrencyFrom (inAmount:= 2, inCurrencyValue:= 5.1234, inParValue:= 1)
