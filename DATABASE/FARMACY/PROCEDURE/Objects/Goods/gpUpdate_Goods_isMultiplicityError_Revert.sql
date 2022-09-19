-- Function: gpUpdate_Goods_isMultiplicityError_Revert()

DROP FUNCTION IF EXISTS gpUpdate_Goods_isMultiplicityError_Revert(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_isMultiplicityError_Revert(
    IN inGoodsMainId             Integer   ,   -- ���� ������� <�����>
    IN inisMultiplicityError     Boolean  ,    -- ����������� ��� ��������� ��� �������
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
   
/*   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  
                  WHERE UserId = vbUserId AND RoleId in (11041603, zc_Enum_Role_Admin())) 
   THEN
       RAISE EXCEPTION '������. � ������ ����� �������� ������� ������ ��� �� "������� ���".';
   END IF;
   
*/   
   -- ��������� �������� <������������ ��� ��������� ��� �������>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_MultiplicityError(), inGoodsMainId, NOT inisMultiplicityError);
   
    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Main SET isMultiplicityError = NOT inisMultiplicityError
     WHERE Object_Goods_Main.Id = inGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_isMultiplicityError_Revert', text_var1::TVarChar, vbUserId);
   END;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.03.21                                                       *  

*/

-- ����
--select * from gpUpdate_Goods_isMultiplicityError_Revert(inGoodsMainId := 39513 , inisOnlySP := '',  inSession := '3');