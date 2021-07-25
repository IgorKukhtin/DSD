-- Function: ������� ����� �� ����� ������� �� ������� - ���������� �� 0 ������

DROP FUNCTION IF EXISTS zfCalc_SummChangePercentNext (TFloat, TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SummChangePercentNext(
    IN inAmount             TFloat, -- ���-��
    IN inOperPriceList      TFloat, -- ���� �� ������, � ���
    IN inChangePercent      TFloat, -- % ������ �1
    IN inChangePercentNext  TFloat  -- % ������ �2
)
RETURNS TFloat
AS
$BODY$
BEGIN

     RETURN zfCalc_SummChangePercent (1, zfCalc_SummChangePercent (inAmount, inOperPriceList, inChangePercent), inChangePercentNext);
                
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.07.21                                        *
*/

-- ����
-- SELECT * FROM zfCalc_SummChangePercentNext (inAmount:= 1, inOperPriceList:= 1000, inChangePercent:= 40, inChangePercentNext:= 10)
