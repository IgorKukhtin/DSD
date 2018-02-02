-- Function: ������� ���� �� ������� ����� - !!!� ������� ������!!! - ���������� �� 2 ������ + !!!�������� � inCountForPrice!!!

DROP FUNCTION IF EXISTS zfCalc_PriceIn_Basis (TFloat, TFloat, TFloat, TFloat);
DROP FUNCTION IF EXISTS zfCalc_PriceIn_Basis (Integer, TFloat, TFloat, TFloat, TFloat);
DROP FUNCTION IF EXISTS zfCalc_PriceIn_Basis (Integer, TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_PriceIn_Basis(
    IN inCurrencyId    Integer, -- � ����� ������
    IN inOperPrice     TFloat , -- ���� �������, � ������
    IN inCurrencyValue TFloat , -- ����
    IN inParValue      TFloat   -- �������
)
RETURNS TFloat
AS
$BODY$
BEGIN

    IF inCurrencyId = zc_Currency_Basis()
    THEN
        -- ������ �� ������, � ��� � ��� ������ Basis
        RETURN inOperPrice;
    ELSE
        -- ���������� �� 2 ������ - �������� �� ����, �.�. ���� ��� - � ����� ����� 1/inCurrencyValue
        RETURN CAST (COALESCE (inOperPrice, 0)
                   * COALESCE (inCurrencyValue, 0) / CASE WHEN inParValue > 0 THEN inParValue ELSE 1 END
                     AS NUMERIC (16, 2));
    END IF;

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
-- SELECT * FROM zfCalc_PriceIn_Basis (inCurrencyId:= 1, inOperPrice:= 100, inCurrencyValue:= 25.55, inParValue:= 1)
