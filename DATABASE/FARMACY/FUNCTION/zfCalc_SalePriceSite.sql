-- Function: zfCalc_SalePriceSite

DROP FUNCTION IF EXISTS zfCalc_SalePriceSite(TFloat, TFloat, Boolean, TFloat, TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SalePriceSite(
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

     -- ������ % �������
     IF inIsTop AND COALESCE (inPercentMarkup, 0) > 0 THEN
        -- ��� ��� = % ������� � ������ - % ������������� � �� ���� ��� ����
        vbPercent := COALESCE (inPercentMarkup, 0) - COALESCE (inJuridicalPercent, 0);
     ELSE
        -- ��������� = % ������� � ���������
        vbPercent := COALESCE (inMarginPercent, 0);
     END IF;
     
     -- ���� �� ��������� ������     
     IF vbPercent > COALESCE (inMarginPercent, 0)
     THEN
        vbPercent := COALESCE (inMarginPercent, 0);     
     END IF;

     -- ������� ����
     IF (ROUND((100 + vbPercent) * inPriceWithVAT / 100, 1)) < inPriceWithVAT
     THEN
       vbPrice := (CEIL((100 + vbPercent) * inPriceWithVAT / 10) / 10.0);     
     ELSE
       vbPrice := (ROUND((100 + vbPercent) * inPriceWithVAT / 100, 1));
     END IF;
     
     -- !!!���� � ������ (�������������)!!!
     IF COALESCE(inPrice, 0) <> 0 AND COALESCE(inPrice, 0) < vbPrice THEN 
        vbPrice := inPrice;
     END IF;


     IF inPriceMax IS NOT NULL AND COALESCE (inPriceMax, 0) > 0 AND inPriceMax < vbPrice
     THEN
       vbPrice := inPriceMax;
     END IF;
     
     RETURN vbPrice;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_SalePriceSite(TFloat, TFloat, Boolean, TFloat, TFloat, TFloat, TFloat) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.06.21                                                       * 
*/
-- ���� select zfCalc_SalePriceSite(0.41, 4, False, 0, 0, 0, 0.0) 