-- Function: zfCalc_RateFuelValue_Distance

-- DROP FUNCTION zfCalc_RateFuelValue_Distance (TFloat, TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_RateFuelValue_Distance(
    IN inDistance            TFloat    , -- ���������� ���� ��
    IN inAmountFuel          TFloat    , -- ���-�� ����� �� 100 ��
    IN inFuel_Ratio          TFloat    , -- ������������ �������� �����
    IN inRateFuelKindTax     TFloat      -- % ��������������� ������� � ����� � �������/������������
)
RETURNS TFloat AS
$BODY$
  DECLARE vbValue TFloat;
BEGIN

     -- ������������� �� ���� ������
     inDistance         := COALESCE (inDistance, 0);
     inAmountFuel       := COALESCE (inAmountFuel, 0);
     inFuel_Ratio       := COALESCE (inFuel_Ratio, 1); -- !!! ����� ����������� ����!!!
     inRateFuelKindTax  := COALESCE (inRateFuelKindTax, 0);

     -- ���������� ������� �� ���� ������
     inFuel_Ratio := CASE WHEN inFuel_Ratio = 0 THEN 1 ELSE inFuel_Ratio END;


     -- ����� ����������� �� "������������ �������� �����" � ��������� �� 2-� ������
     inAmountFuel := CAST (inAmountFuel * inFuel_Ratio AS NUMERIC (16, 2));

     -- ������ �����: ��� ����������/100 � ��������� �� 2-� ������
     vbValue := CAST ((inDistance / 100) * inAmountFuel AS NUMERIC (16, 2));

     -- ��������� � ����e % ��������������� ������� � ����� � �������/������������ � ��������� �� 2-� ������
     vbValue := CAST (vbValue * (1 + inRateFuelKindTax / 100) AS NUMERIC (16, 2));

     -- ���������� ���������, ��� ����������� �� 2-� ������
     RETURN (vbValue);

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_RateFuelValue_Distance (TFloat, TFloat, TFloat, TFloat) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.10.13                        * -- VOLATILE -->> IMMUTABLE
 24.10.13                                        *
*/
/*
-- ����
SELECT * FROM zfCalc_RateFuelValue_Distance (inDistance           := 100
                                           , inAmountFuel         := 17
                                           , inFuel_Ratio         := 1.3059
                                           , inRateFuelKindTax    := 0)
*/