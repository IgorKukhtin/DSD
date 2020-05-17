-- Function: gpUpdate_Goods_LimitSUN_T()

DROP FUNCTION IF EXISTS gpUpdate_Goods_LimitSUN_T(Integer, Boolean, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_LimitSUN_T(
    IN inId             Integer   ,    -- ���� ������� <>
    IN inis_v1          Boolean   ,    --
    IN inLimitSUN_T1    TFloat    ,    --
    IN inSession        TVarChar       -- ������� ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE text_var1    text;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;
   
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpGetUserBySession (inSession);

   IF COALESCE (inis_v1, FALSE) = TRUE
   THEN
       -- ��������� <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Goods_LimitSUN_T1(), inId, inLimitSUN_T1);

        -- ��������� � ������� �������
       BEGIN
         UPDATE Object_Goods_Retail SET LimitSUN_T1 = inLimitSUN_T1
         WHERE Object_Goods_Retail.Id = inId;  
       EXCEPTION
          WHEN others THEN 
            GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
            PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_LimitSUN_T1', text_var1::TVarChar, vbUserId);
       END;

   END IF;
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.05.20         *
*/