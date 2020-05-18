-- Function: gpUpdate_Goods_GoodsPairSun()

DROP FUNCTION IF EXISTS gpUpdate_Goods_GoodsPairSun(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_GoodsPairSun(
    IN inId             Integer   ,    -- ���� ������� <>
    IN inGoodsPairSunId Integer   ,    --
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

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsPairSun(), inId, inGoodsPairSunId);

    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Retail SET GoodsPairSunId = inGoodsPairSunId
     WHERE Object_Goods_Retail.Id = inId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_GoodsPairSunId', text_var1::TVarChar, vbUserId);
   END;

   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.05.20         *
*/