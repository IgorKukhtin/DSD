-- Function: gpUpdate_Goods_IdSP()

DROP FUNCTION IF EXISTS gpUpdate_Goods_IdSP(Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_IdSP(
    IN inGoodsMainId             Integer   ,   -- ���� ������� <�����>
    IN inIdSP                    TVarChar  ,   -- ID ���������� ������ � ��
    IN inSession                 TVarChar      -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbLastPriceOldDate  TDateTime;
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inGoodsMainId, 0) = 0 THEN
      RETURN;
   END IF;
   
   vbUserId := lpGetUserBySession (inSession);
   

   -- ��������� �������� <ID ���������� ������ � ��>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_IdSP(), inGoodsMainId, inIdSP);
   
    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Main SET IdSP = inIdSP
     WHERE Object_Goods_Main.Id = inGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_IdSP', text_var1::TVarChar, vbUserId);
   END;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inGoodsMainId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 31.10.22                                                       *  

*/

-- ����
--select * from gpUpdate_Goods_IdSP(inGoodsMainId := 39513 , inIdSP := '',  inSession := '3');