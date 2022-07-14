-- Function: gpUpdate_Goods_SupplementSUN1()

DROP FUNCTION IF EXISTS gpUpdate_Goods_ClearSupplementSUN1(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_ClearSupplementSUN1(
    IN inGoodsMainId             Integer   ,   -- ���� ������� <�����>
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
   
   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin()) 
   THEN
       RAISE EXCEPTION '������. � ������ ����� �������� ������� "���������� ���1".';
   END IF;      

   -- ��������� �������� <���������� ���1>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_SupplementSUN1(), inGoodsMainId, False);
   -- ��������� �������� <���������� ���1 ���������>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_SupplementMarkSUN1(), inGoodsMainId, False);

   -- ��������� �������� <���������� ���1>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_UnitSupplementSUN1Out(), inGoodsMainId, NULL);
   -- ��������� �������� <���������� ���1>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_UnitSupplementSUN2Out(), inGoodsMainId, NULL);
   -- ��������� �������� <���������� ���1>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_UnitSupplementSUN1In(), inGoodsMainId, NULL);

   -- ��������� �������� <���������� ���1>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_SupplementSUN1Smudge(), inGoodsMainId, False);

   -- ��������� �������� <���������� ���1>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_SupplementMin(), inGoodsMainId, 0);
   -- ��������� �������� <���������� ���1>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_SupplementMinPP(), inGoodsMainId, 0);
   
    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Main SET isSupplementSUN1 = False
                                , isSupplementMarkSUN1 = False
                                , UnitSupplementSUN1OutId = NULL
                                , UnitSupplementSUN2OutId = NULL
                                , UnitSupplementSUN1InId = NULL
                                , isSupplementSmudge = False
                                , SupplementMin = 0
                                , SupplementMinPP = 0
     WHERE Object_Goods_Main.Id = inGoodsMainId;  

     UPDATE Object_Goods_Blob SET UnitSupplementSUN1Out = NULL
     WHERE Object_Goods_Blob.UnitSupplementSUN1Out IS NOT NULL;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_ClearSupplementSUN1', text_var1::TVarChar, vbUserId);
   END;
	
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inGoodsMainId, vbUserId);
   
    -- !!!�������� ��� �����!!!
 /*   IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION '���� ������ ������� ��� <%> <%>', inGoodsMainId, inSession;
    END IF;   */

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.07.22                                                       *  

*/

-- ����
-- select * from gpUpdate_Goods_ClearSupplementSUN1(inGoodsMainId := 39513 , inSession := '3');