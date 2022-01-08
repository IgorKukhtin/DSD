-- Function: ������� ����� �� ����� ������� - ���������� �� 0 ������

DROP FUNCTION IF EXISTS zfCalc_SummPriceList (TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SummPriceList(
    IN inAmount        TFloat, -- ���-��
    IN inOperPriceList TFloat  -- ���� �� ������
)
RETURNS TFloat
AS
$BODY$
BEGIN

    -- ���������� �� 2-� ������
    RETURN CASE WHEN ABS (inOperPriceList) < 1
                THEN CAST (COALESCE (inAmount, 0) * COALESCE (inOperPriceList, 0)
                           AS NUMERIC (16, 2))
                ELSE CAST (COALESCE (inAmount, 0) * COALESCE (inOperPriceList, 0)
                           AS NUMERIC (16, 2))
           END;

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
