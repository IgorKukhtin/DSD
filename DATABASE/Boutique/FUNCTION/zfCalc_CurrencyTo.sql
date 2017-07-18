-- Function: ��������� � ������ - ��������, �.�. �� ���

DROP FUNCTION IF EXISTS zfCalc_CurrencyTo (TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_CurrencyTo(
    IN inAmount        TFloat, -- ����� � ���
    IN inCurrencyValue TFloat, -- ����
    IN inParValue      TFloat  -- �������
)
RETURNS NUMERIC (20, 10)
AS
$BODY$
BEGIN
    -- ��� ����������
    RETURN COALESCE (inAmount, 0)
         / CASE WHEN inCurrencyValue > 0 THEN inCurrencyValue ELSE 0 END
         * CASE WHEN inParValue      > 0 THEN inParValue      ELSE 1 END
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
-- SELECT * FROM zfCalc_CurrencyTo (inAmount:= 2, inCurrencyValue:= 5, inParValue:= 1)
