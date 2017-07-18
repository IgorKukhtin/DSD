-- Function: ��������� �� ������ - ����������, �.�. � ���

DROP FUNCTION IF EXISTS zfCalc_CurrencyFrom (TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_CurrencyFrom(
    IN inAmount        TFloat, -- ����� � ������
    IN inCurrencyValue TFloat, -- ����
    IN inParValue      TFloat  -- �������
)
RETURNS NUMERIC (20, 10)
AS
$BODY$
BEGIN
    -- ��� ����������
    RETURN COALESCE (inAmount, 0)
         * COALESCE (inCurrencyValue, 0)
         / CASE WHEN inParValue > 0 THEN inParValue ELSE 1 END
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
-- SELECT * FROM zfCalc_CurrencyFrom (inAmount:= 2, inCurrencyValue:= 5, inParValue:= 1)
