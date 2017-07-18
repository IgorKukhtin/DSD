-- Function: ������� ����� �� ����� ������� - ���������� �� 0 ������

DROP FUNCTION IF EXISTS zfCalc_SummPriceList (TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SummPriceList(
    IN inAmount        TFloat, -- ���-��
    IN inOperPriceList TFloat  -- ���� �� ������, � ���
)
RETURNS TFloat
AS
$BODY$
BEGIN

    -- ���������� �� 0 ������
    RETURN CAST (COALESCE (inAmount, 0) * COALESCE (inOperPriceList, 0)
                 AS NUMERIC (16, 0));

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
-- SELECT * FROM zfCalc_SummPriceList (inAmount:= 2, inOperPriceList:= 3)
