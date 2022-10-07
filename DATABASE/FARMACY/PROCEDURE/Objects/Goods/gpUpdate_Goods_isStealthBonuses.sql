-- Function: gpUpdate_Goods_isStealthBonuses()

DROP FUNCTION IF EXISTS gpUpdate_Goods_isStealthBonuses(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_isStealthBonuses(
    IN inGoodsMainId             Integer   ,   -- ���� ������� <�����>
    IN inisStealthBonuses        Boolean  ,    -- ����� ��� ������� ���������� ����������
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
   
/*   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin()) 
   THEN
       RAISE EXCEPTION '������. � ������ ����� �������� ������� "����� ��� ������� ���������� ����������".';
   END IF;      */

   -- ��������� �������� <���������� ���1>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_StealthBonuses(), inGoodsMainId, NOT inisStealthBonuses);
   
    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Main SET isStealthBonuses = NOT inisStealthBonuses
     WHERE Object_Goods_Main.Id = inGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_isStealthBonuses', text_var1::TVarChar, vbUserId);
   END;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inGoodsMainId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.06.20                                                       *  

*/

-- ����
--select * from gpUpdate_Goods_isStealthBonuses(inGoodsMainId := 39513 , inisStealthBonuses := '',  inSession := '3');