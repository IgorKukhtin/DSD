-- Function: gpUpdate_Goods_IdSP_Del()

DROP FUNCTION IF EXISTS gpUpdate_Goods_IdSP_Del(Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_IdSP_Del(
    IN inGoodsMainId             Integer   ,   -- ���� ������� <�����>
    IN inIdSP                    TVarChar  ,   -- ID ���������� ������ � ��
    IN inSession                 TVarChar      -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbIdSPOld           TVarChar;
   DECLARE vbIdSP              TVarChar;
   DECLARE vbIndex             Integer;
BEGIN

   IF COALESCE(inGoodsMainId, 0) = 0 THEN
      RETURN;
   END IF;
   
   vbUserId := lpGetUserBySession (inSession);
   
   vbIdSPOld := COALESCE((SELECT Object_Goods_Main.IdSP FROM Object_Goods_Main WHERE Object_Goods_Main.Id = inGoodsMainId), '');
   
   IF vbIdSPOld = '' OR NOT vbIdSPOld ILIKE '%'||inIdSP||'%'
   THEN
     RETURN;
   END IF;

   vbIdSP := '';

   -- ������
   vbIndex := 1;
   WHILE SPLIT_PART (vbIdSPOld, ';', vbIndex) <> '' LOOP
     -- ��������� �� ��� �����
     IF SPLIT_PART (vbIdSPOld, ';', vbIndex) <> inIdSP
     THEN

       IF vbIdSP <> '' THEN vbIdSP := vbIdSP||';'; END IF; 
       
       vbIdSP := vbIdSP||SPLIT_PART (vbIdSPOld, ';', vbIndex);
     
     END IF;
     
     -- ������ ����������
     vbIndex := vbIndex + 1;
   END LOOP;   
   
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
--select * from gpUpdate_Goods_IdSP_Del(inGoodsMainId := 39513 , inIdSP := '',  inSession := '3');