-- Function: zfCalc_RateFuelValue

DROP FUNCTION IF EXISTS zfCalc_RateFuelValue (TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat);
DROP FUNCTION IF EXISTS zfCalc_RateFuelValue (TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_RateFuelValue(
    IN inDistance            TFloat    , -- ���������� ���� ��
    IN inAmountFuel          TFloat    , -- ���-�� ����� �� 100 ��
    IN inColdHour            TFloat    , -- �����, ���-�� ���� �����
    IN inAmountColdHour      TFloat    , -- �����, ���-�� ����� � ���
    IN inColdDistance        TFloat    , -- �����, ���-�� ���� ��
    IN inAmountColdDistance  TFloat    , -- �����, ���-�� ����� �� 100 ��
    IN inFuel_Ratio          TFloat    , -- ������������ �������� �����
    IN inRateFuelKindTax     TFloat      -- % ��������������� ������� � ����� � �������/������������
)
RETURNS TFloat AS
$BODY$
  DECLARE vbValue TFloat;
BEGIN

     -- ������ �����
     vbValue := zfCalc_RateFuelValue_Distance     (inDistance           := inDistance
                                                 , inAmountFuel         := inAmountFuel
                                                 , inFuel_Ratio         := inFuel_Ratio
                                                 , inRateFuelKindTax    := inRateFuelKindTax)
              + zfCalc_RateFuelValue_ColdHour     (inColdHour           := inColdHour
                                                 , inAmountColdHour     := inAmountColdHour
                                                 , inFuel_Ratio         := inFuel_Ratio
                                                 , inRateFuelKindTax    := inRateFuelKindTax)
              + zfCalc_RateFuelValue_ColdDistance (inColdDistance       := inColdDistance
                                                 , inAmountColdDistance := inAmountColdDistance
                                                 , inFuel_Ratio         := inFuel_Ratio
                                                 , inRateFuelKindTax    := inRateFuelKindTax);
     -- ���������� ���������, ��� ����������� �� 2-� ������
     RETURN (vbValue);

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_RateFuelValue (TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.10.13                        * -- VOLATILE -->> IMMUTABLE
 23.10.13                                        * add zfCalc_RateFuelValue_...
 01.10.13                                        *
*/
/*
-- ����
SELECT * FROM zfCalc_RateFuelValue (inDistance           := 100
                                  , inAmountFuel         := 17
                                  , inColdHour           := 1
                                  , inAmountColdHour     := 17
                                  , inColdDistance       := 100
                                  , inAmountColdDistance := 17
                                  , inFuel_Ratio         := 1.3059
                                  , inRateFuelKindTax    := 0)
*/