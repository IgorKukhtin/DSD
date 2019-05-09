-- Function: zfCalc_PriceTruncate

DROP FUNCTION IF EXISTS zfCalc_PriceTruncate (TFloat, TFloat, Boolean);
DROP FUNCTION IF EXISTS zfCalc_PriceTruncate (TDateTime, TFloat, TFloat, Boolean);


CREATE OR REPLACE FUNCTION zfCalc_PriceTruncate(
    IN inOperDate            TDateTime , -- 
    IN inChangePercent       TFloat    , -- 
    IN inPrice               TFloat    , -- 
    IN inIsWithVAT           Boolean     -- 
)
RETURNS TFloat
AS
$BODY$
BEGIN
     IF COALESCE (inChangePercent, 0) = 0
     THEN
         RETURN (inPrice);
     ELSEIF COALESCE (inOperDate, zc_DateEnd()) < zc_DateStart_PriceTruncate()
     THEN
         -- ���������� ���������, ��� ����������� �� 2-� ������
         RETURN (CAST (COALESCE (inPrice, 0) * (1 + inChangePercent / 100) AS NUMERIC (16, 2)));
     ELSE
         -- ���������� ���������, ��� ����������� �� 2-� ������
         RETURN (CASE WHEN COALESCE (inIsWithVAT, FALSE) = TRUE
                           -- ���� ���� � ���, ����� �� ������� ������ �������� �� 6
                           THEN 6 * CAST (COALESCE (inPrice, 0) * (1 + inChangePercent / 100) / 6 AS Numeric (16, 2))
                      -- ���� ���� ��� ���, ����� �� ������� ������ �������� �� 5
                      ELSE 5 * CAST (COALESCE (inPrice, 0) * (1 + inChangePercent / 100) / 5 AS Numeric (16, 2))
                 END :: TFloat
                );
     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.05.19                                        *
*/

-- ����
-- SELECT zfCalc_PriceTruncate (inOperDate:= CURRENT_DATE, inChangePercent:= 5, inPrice:= 7, inIsWithVAT:= FALSE), zfCalc_PriceTruncate (inOperDate:= CURRENT_DATE, inChangePercent:= 5, inPrice:= 7, inIsWithVAT:= TRUE)
