-- Function: zfCalc_CurrencyTo_Cross

DROP FUNCTION IF EXISTS zfCalc_CurrencyTo_Cross (TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_CurrencyTo_Cross(
    IN inCurrencyValue      TFloat, -- ���� � EUR
    IN inCurrencyValueCross TFloat  -- �����-����
)
RETURNS NUMERIC (20, 10)
AS
$BODY$
BEGIN
    -- ���������� 2 �����
    RETURN ROUND (inCurrencyValue / CASE WHEN inCurrencyValueCross > 0 THEN inCurrencyValueCross ELSE 1 END, 2);
    -- ��� ����������
    --RETURN inCurrencyValue / CASE WHEN inCurrencyValueCross > 0 THEN inCurrencyValueCross ELSE 1 END

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.05.21                                        *
*/

-- ����
-- SELECT * FROM zfCalc_CurrencyTo_Cross (inCurrencyValue:= 33, inCurrencyValueCross:= 1.2)
