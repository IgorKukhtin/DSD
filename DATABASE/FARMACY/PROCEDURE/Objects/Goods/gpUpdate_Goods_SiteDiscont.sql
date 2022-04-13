-- Function: gpUpdate_Goods_SiteDiscont()

DROP FUNCTION IF EXISTS gpUpdate_Goods_SiteDiscont(Integer, TDateTime, TDateTime, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_SiteDiscont(
    IN inGoodsId             Integer   ,    -- ���� ������� <�����>
    IN inDiscontSiteStart    TDateTime ,    -- ���� ������ ������ �� �����
    IN inDiscontSiteEnd      TDateTime ,    -- ���� ��������� ������ �� �����
    IN inDiscontPercentSite  TFloat    ,    -- ����� ������ �� �����
    IN inDiscontAmountSite   TFloat    ,    -- ������� ������ �� �����
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inGoodsId, 0) = 0 THEN
      RETURN;
   END IF;

   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Goods_DiscontSiteStart(), inGoodsId, inDiscontSiteStart);
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Goods_DiscontSiteEnd(), inGoodsId, inDiscontSiteEnd);
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_DiscontAmountSite(), inGoodsId, inDiscontAmountSite);
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_DiscontPercentSite(), inGoodsId, inDiscontPercentSite);
   
    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Retail SET DiscontSiteStart   = inDiscontSiteStart
                                  , DiscontSiteEnd     = inDiscontSiteEnd
                                  , DiscontPercentSite = inDiscontPercentSite
                                  , DiscontAmountSite  = inDiscontAmountSite
     WHERE Object_Goods_Retail.Id = inGoodsId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpInsertUpdate_Object_Goods', text_var1::TVarChar, vbUserId);
   END;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inGoodsId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.02.22                                                       *  

*/

-- ����
-- SELECT * FROM gpUpdate_Goods_SiteDiscont(inGoodsId := 19456 , inDiscontSiteStart := ('16.02.2022')::TDateTime , inDiscontSiteEnd := ('28.02.2022')::TDateTime , inDiscontPercentSite := 20 , inDiscontAmountSite := 0 ,  inSession := '3');