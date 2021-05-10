-- Function: ��������� � ������ - ��������, �.�. �� USD -> EUR

DROP FUNCTION IF EXISTS zfCalc_CurrencyCross (TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_CurrencyCross(
    IN inAmount        TFloat, -- ����� � USD
    IN inCurrencyValue TFloat, -- �����-����
    IN inParValue      TFloat  -- ������� ��� �����-�����
)
RETURNS NUMERIC (20, 10)
AS
$BODY$
BEGIN
    -- ����������
    RETURN CAST (CASE WHEN inCurrencyValue > 0
                           THEN COALESCE (inAmount, 0)
                              / inCurrencyValue
                              * CASE WHEN inParValue > 0 THEN inParValue ELSE 1 END
                      ELSE 0
                 END
                 AS NUMERIC (16, 0))
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
-- SELECT * FROM zfCalc_CurrencyCross (inAmount:= 600, inCurrencyValue:= 1.2, inParValue:= 1)
