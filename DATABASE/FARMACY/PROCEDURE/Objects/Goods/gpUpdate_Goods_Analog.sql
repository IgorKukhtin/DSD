-- Function: gpUpdate_Goods_Analog()

DROP FUNCTION IF EXISTS gpUpdate_Goods_Analog(Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Goods_Analog(Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_Analog(
    IN inGoodsMainId             Integer   ,    -- ���� ������� <�����>
 INOUT ioAnalog                  TVarChar  ,    -- �������� �������� ������
 INOUT ioAnalogATC               TVarChar  ,    -- �������� �������� ������ ATC
 INOUT ioActiveSubstance         TVarChar  ,    -- ����������� ��������
    IN inSession                 TVarChar       -- ������� ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbLastPriceOldDate  TDateTime;
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inGoodsMainId, 0) = 0 THEN
      ioAnalog := '';
      ioAnalogATC := '';
      ioActiveSubstance := '';
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- ��������� �������� <�������� �������� ������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_Analog(), inGoodsMainId, ioAnalog);
   -- ��������� �������� <�������� �������� ������ ATC>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_AnalogATC(), inGoodsMainId, ioAnalogATC);
   -- ��������� �������� <����������� ��������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_ActiveSubstance(), inGoodsMainId, ioActiveSubstance);

    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Main SET Analog = ioAnalog
                                , AnalogATC = ioAnalogATC
                                , ActiveSubstance = ioActiveSubstance
     WHERE Object_Goods_Main.Id = inGoodsMainId;
   EXCEPTION
      WHEN others THEN
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_Analog', text_var1::TVarChar, vbUserId);
   END;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 24.04.19                                                       *
 17.10.19                                                       *
 16.08.17                                                       *

*/

-- ����
--select * from gpUpdate_Goods_Analog(inGoodsMainId := 39513 , ioAnalog := '',  inSession := '3');