-- Function: gpUpdate_Goods_Analog()

DROP FUNCTION IF EXISTS gpUpdate_Goods_Analog(Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_Analog(
    IN inGoodsMainId             Integer   ,    -- ���� ������� <�����>
 INOUT ioAnalog                  TVarChar  ,    -- �������� �������� ������
    IN inSession                 TVarChar       -- ������� ������������
)
RETURNS TVarChar AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbLastPriceOldDate  TDateTime;
BEGIN

   IF COALESCE(inGoodsMainId, 0) = 0 THEN
      ioAnalog := '';
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);
   
   -- ��������� �������� <�������� �������� ������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_Analog(), inGoodsMainId, ioAnalog);
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.08.17         *

*/

-- ����
--select * from gpUpdate_Goods_Analog(inGoodsMainId := 39513 , ioAnalog := '',  inSession := '3');