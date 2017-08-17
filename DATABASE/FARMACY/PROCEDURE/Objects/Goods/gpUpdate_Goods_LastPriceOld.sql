-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpUpdate_Goods_LastPriceOld(Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_LastPriceOld(
    IN inGoodsMainId             Integer   ,    -- ���� ������� <�����>
    IN inLastPriceDate           TDateTime ,    -- ������. ���� ������� �� �����
    IN inLastPriceOldDate        TDateTime ,    -- ���� ������. ���� ������� �� �����
   OUT outCountDays              TFloat    ,
    IN inSession                 TVarChar       -- ������� ������������
)
RETURNS TFloat AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbLastPriceOldDate  TDateTime;
BEGIN

   IF COALESCE(inGoodsMainId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- ������� ����������� ��������
   vbLastPriceOldDate := (SELECT COALESCE (ObjectDate_LastPriceOld.ValueData, Null)
                          FROM ObjectDate AS ObjectDate_LastPriceOld
                          WHERE ObjectDate_LastPriceOld.ObjectId = inGoodsMainId
                            AND ObjectDate_LastPriceOld.DescId = zc_ObjectDate_Goods_LastPriceOld()) :: TDateTime;
   
   outCountDays := CAST (DATE_PART ('DAY', (inLastPriceOldDate - inLastPriceDate)) AS NUMERIC (15,2))  :: TFloat;

   -- ��������� �������� <���� ������. ���� ������� �� �����>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Goods_LastPriceOld(), inGoodsMainId, inLastPriceOldDate);
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.08.17         *

*/

-- ����
--select * from gpUpdate_Goods_LastPriceOld(inGoodsMainId := 39513 , inLastPriceDate := ('07.07.2017')::TDateTime , inLastPriceOldDate := ('14.08.2017')::TDateTime ,  inSession := '3');