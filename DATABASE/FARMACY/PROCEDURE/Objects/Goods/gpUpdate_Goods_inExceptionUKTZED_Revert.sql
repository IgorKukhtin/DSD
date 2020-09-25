-- Function: gpUpdate_Goods_inExceptionUKTZED_Revert()

DROP FUNCTION IF EXISTS gpUpdate_Goods_inExceptionUKTZED_Revert(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_inExceptionUKTZED_Revert(
    IN inGoodsMainId             Integer   ,   -- ���� ������� <�����>
    IN inisExceptionUKTZED       Boolean  ,    -- ���������� ���1
    IN inSession                 TVarChar      -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inGoodsMainId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);
   
   -- ��������� �������� <���������� ���1>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_ExceptionUKTZED(), inGoodsMainId, NOT inisExceptionUKTZED);
   
    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Main SET isExceptionUKTZED = NOT inisExceptionUKTZED
     WHERE Object_Goods_Main.Id = inGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_inExceptionUKTZED_Revert', text_var1::TVarChar, vbUserId);
   END;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.09.20                                                       *  

*/

-- ����
-- select * from gpUpdate_Goods_inExceptionUKTZED_Revert(inGoodsMainId := 26898 , inisExceptionUKTZED := 'False' ,  inSession := '3');