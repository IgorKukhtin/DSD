-- Function: zfCalc_SalePriceSite

DROP FUNCTION IF EXISTS zfCalc_SalePriceSite(TFloat, TFloat, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SalePriceSite(
    IN inPriceWithVAT        TFloat    , -- ���� � ���
    IN inMarginPercent       TFloat    , -- % ������� � ���������
    IN inIsTop               Boolean   , -- ��� �������
    IN inPercentMarkup       TFloat    , -- % ������� � ������
    IN inPercentMarkupPrice  TFloat    , -- % ������� � ������ ��� �����
    IN inPrice               TFloat    , -- ���� � ������ (�������������)
    IN inPriceGods           TFloat    , -- ���� � ������ (������������� �� ����)
    IN inPriceMax            TFloat      -- ������������ ���� ��� ������
)
RETURNS TFloat AS
$BODY$
  DECLARE vbPercent TFloat;
  DECLARE vbPrice TFloat;
BEGIN

     -- !!!���� � ������ (�������������)!!!
     IF COALESCE(inPrice, 0) <> 0  THEN 
        RETURN inPrice;
     END IF;
     
     -- ������ % �������
     IF COALESCE(inPercentMarkupPrice, 0) > 0
     THEN
       vbPercent := COALESCE (inPercentMarkupPrice, 0);
     ELSEIF inIsTop AND COALESCE (inPercentMarkup, 0) > 0 AND COALESCE (inPercentMarkup, 0) < COALESCE (inMarginPercent, 0)  THEN
        -- ��� ��� = % ������� � ������ - % ������������� � �� ���� ��� ����
        vbPercent := COALESCE (inPercentMarkup, 0);
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
     
     IF inIsTop AND COALESCE(inPriceGods, 0) > 0 AND COALESCE(inPriceGods, 0) < vbPrice
     THEN
       vbPrice := COALESCE(inPriceGods, 0);
     END IF; 

     IF inPriceMax IS NOT NULL AND COALESCE (inPriceMax, 0) > 0 AND inPriceMax < vbPrice
     THEN
       vbPrice := inPriceMax;
     END IF;
     
     RETURN vbPrice;

/*     if inPriceWithVAT = 155.6
     THEN
     RAISE notice '<%> <%> <%> <%> <%> <%> <%> <%> ', 
        inPriceWithVAT
       ,inMarginPercent
       ,inIsTop
       ,inPercentMarkup
       ,inPercentMarkupPrice
       ,inPrice
       ,inPriceGods
       ,inPriceMax ;
     END IF;
*/
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_SalePriceSite(TFloat, TFloat, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.06.21                                                       * 
*/
-- ���� 

select zfCalc_SalePriceSite(155.6, 4, True, 4, 0, 0, 0.0, 0.0) 