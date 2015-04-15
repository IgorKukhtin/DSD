-- Function: zfCalc_RateFuelValue

DROP FUNCTION IF EXISTS zfCalc_SalePrice(TFloat, TFloat, Boolean, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SalePrice(
    IN inPriceWithVAT        TFloat    , -- ���� � ���
    IN inMarginPercent       TFloat    , -- % �������
    IN inIsTop               Boolean   , -- ��� �������
    IN inPercentMarkup       TFloat    , -- % ������� � ������
    IN inJuridicalPercent    TFloat     -- % ������������� � �� ���� ���� ����
)
RETURNS TFloat AS
$BODY$
  DECLARE vbPercent TFloat;
BEGIN

     -- ������ % �������
   
     IF inIsTop THEN 
        vbPercent := COALESCE(inPercentMarkup, 0) - COALESCE(inJuridicalPercent, 0);
     ELSE
        vbPercent := COALESCE(inMarginPercent, 0);
     END IF;

     RETURN (ROUND((100 + vbPercent) * inPriceWithVAT / 100, 1));
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_RateFuelValue (TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.04.15                        * 
*/
/*
-- ����
*/