-- Function: gpUpdate_Goods_IdSP()

DROP FUNCTION IF EXISTS gpUpdate_Goods_IdSP_Add(Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_IdSP_Add(
    IN inGoodsMainId             Integer   ,   -- ���� ������� <�����>
    IN inIdSP                    TVarChar  ,   -- ID ���������� ������ � ��
    IN inSession                 TVarChar      -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbIdSP              TVarChar;
BEGIN

   IF COALESCE(inGoodsMainId, 0) = 0 THEN
      RETURN;
   END IF;
   
   vbUserId := lpGetUserBySession (inSession);
   
   vbIdSP := COALESCE((SELECT Object_Goods_Main.IdSP FROM Object_Goods_Main WHERE Object_Goods_Main.Id = inGoodsMainId), '');
   
   IF vbIdSP = '' OR NOT vbIdSP ILIKE '%'||inIdSP||'%'
   THEN
     IF vbIdSP <> '' THEN vbIdSP := vbIdSP||';'; END IF; 
     
     vbIdSP := vbIdSP||inIdSP;
   ELSE
     RETURN;
   END IF;
   
   PERFORM gpUpdate_Goods_IdSP(inGoodsMainId := inGoodsMainId, inIdSP := vbIdSP,  inSession := inSession);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 01.09.23                                                       *  

*/

-- ����
--select * from gpUpdate_Goods_IdSP_Add(inGoodsMainId := 39513 , inIdSP := '',  inSession := '3');