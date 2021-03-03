-- Function: zfCalc_RateFuelValue

--DROP FUNCTION IF EXISTS zfCalc_SalePrice(TFloat, TFloat, Boolean, TFloat, TFloat);
--DROP FUNCTION IF EXISTS zfCalc_SalePrice(TFloat, TFloat, Boolean, TFloat, TFloat, TFloat);
DROP FUNCTION IF EXISTS zfCalc_SalePrice(TFloat, TFloat, Boolean, TFloat, TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SalePrice(
    IN inPriceWithVAT        TFloat    , -- ���� � ���
    IN inMarginPercent       TFloat    , -- % ������� � ���������
    IN inIsTop               Boolean   , -- ��� �������
    IN inPercentMarkup       TFloat    , -- % ������� � ������
    IN inJuridicalPercent    TFloat    , -- % ������������� � �� ���� ��� ����
    IN inPrice               TFloat    , -- ���� � ������ (�������������)
    IN inPriceMax            TFloat      -- ������������ ���� ��� ������
)
RETURNS TFloat AS
$BODY$
  DECLARE vbPercent TFloat;
  DECLARE vbPrice TFloat;
BEGIN
     -- !!!���� � ������ (�������������)!!!
     IF COALESCE(inPrice, 0) <> 0 THEN 
        RETURN inPrice;
     END IF;

     -- ������ % �������
     IF inIsTop THEN
        -- ��� ��� = % ������� � ������ - % ������������� � �� ���� ��� ����
        vbPercent := COALESCE (inPercentMarkup, 0) - COALESCE (inJuridicalPercent, 0);
     ELSE
        -- ��������� = % ������� � ���������
        vbPercent := COALESCE (inMarginPercent, 0);
     END IF;

     -- ������� ����
     IF (ROUND((100 + vbPercent) * inPriceWithVAT / 100, 1)) < inPriceWithVAT
     THEN
       vbPrice := (CEIL((100 + vbPercent) * inPriceWithVAT / 10) / 10.0);     
     ELSE
       vbPrice := (ROUND((100 + vbPercent) * inPriceWithVAT / 100, 1));
     END IF;
     
     IF inPriceMax IS NOT NULL AND COALESCE (inPriceMax, 0) > 0 AND inPriceMax < vbPrice
     THEN
       vbPrice := inPriceMax;
     END IF;
     
     RETURN vbPrice;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_SalePrice(TFloat, TFloat, Boolean, TFloat, TFloat, TFloat) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.02.21                                                       * 
 10.06.15                        * 
 13.04.15                        * 
*/
-- ���� select zfCalc_SalePrice(0.41, 4, False, 0, 0, 0, 0.0) 