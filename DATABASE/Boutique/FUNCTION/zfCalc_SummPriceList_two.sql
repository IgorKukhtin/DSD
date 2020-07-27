-- Function: ������� ����� �� ����� ������� - ���������� �� 0 ������

DROP FUNCTION IF EXISTS zfCalc_SummPriceList (TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SummPriceList(
    IN inAmount        TFloat, -- ���-��
    IN inOperPriceList TFloat, -- ���� �� ������, � ���
    IN inChangePercent TFloat  -- 
)
RETURNS TFloat
AS
$BODY$
BEGIN

    -- ���������� �� 0 ������
    RETURN CAST (zfCalc_SummPriceList (inAmount, inOperPriceList) -- ���������� �� 0 ������
               * (1 - COALESCE (inChangePercent, 0) / 100)
                AS NUMERIC (16, 0)); -- ��� ��� ��������� �� 0 ������

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
-- SELECT * FROM zfCalc_SummPriceList (inAmount:= 2, inOperPriceList:= 3, inChangePercent: 1)
