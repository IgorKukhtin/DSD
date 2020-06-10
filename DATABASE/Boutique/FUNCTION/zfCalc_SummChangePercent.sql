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
   DECLARE vbSumm TFloat;
BEGIN
    -- ���������� �� 0 ������
    vbSumm:= zfCalc_SummPriceList (inAmount, inOperPriceList);

    IF zc_Enum_GlobalConst_isTerry() = TRUE
    THEN
        -- ��� ��� ��������� �� 0 ������
        RETURN vbSumm
             - CAST (vbSumm * COALESCE (inChangePercent, 0) / 100 AS NUMERIC (16, 0));
    ELSE
        -- ��� ��� ��������� �� 0 ������
        RETURN vbSumm
             - CAST (vbSumm * COALESCE (inChangePercent, 0) / 100 AS NUMERIC (16, 0));
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
-- SELECT * FROM zfCalc_SummChangePercent (inAmount:= 1, inOperPriceList:= 250, inChangePercent:= 15)
