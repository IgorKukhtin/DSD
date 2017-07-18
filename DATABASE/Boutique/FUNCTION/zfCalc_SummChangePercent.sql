-- Function: ������� ����� �� ����� ������� �� ������� - ���������� �� 0 ������

DROP FUNCTION IF EXISTS zfCalc_SummChangePercent (TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SummChangePercent(
    IN inAmount        TFloat, -- ���-��
    IN inOperPriceList TFloat, -- ���� �� ������, � ���
    IN inChangePercent TFloat  -- % ������
)
RETURNS TFloat
AS
$BODY$
BEGIN

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
-- SELECT * FROM zfCalc_SummChangePercent (inAmount:= 2, inOperPriceList:= 3, inChangePercent:= 10)
