-- Function: gpUpdate_Goods_PercentWagesStore()

DROP FUNCTION IF EXISTS gpUpdate_Goods_PercentWagesStore(Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_PercentWagesStore(
    IN inId               Integer   ,    -- ���� ������� <�����>
    IN inPercentWagesStore     TFloat    ,    -- % �� ������� � ��������
    IN inSession          TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   --
   vbUserId := lpGetUserBySession (inSession);
   
   -- ��������� ��-��
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_PercentWagesStore(), inId, inPercentWagesStore);

    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Retail SET PercentWagesStore = inPercentWagesStore
     WHERE Object_Goods_Retail.Id = inId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_PercentWagesStore', text_var1::TVarChar, vbUserId);
   END;


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
06.01.21                                                        *
*/