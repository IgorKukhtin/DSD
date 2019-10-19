-- Function: gpUpdate_Object_Goods_IsUpload()

DROP FUNCTION IF EXISTS gpUpdate_Goods_isUpload(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_IsUpload(
    IN inId                  Integer   ,    -- ���� ������� <�����>
    IN inisUpload            BOOLEAN   ,    -- ����������� � ������ ��� ����������
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_IsUpload(), inId, inisUpload);

     -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Juridical SET isUpload     = COALESCE(inisUpload, FALSE)
                                     , UserUpdateId = vbUserId
                                     , DateUpdate   = CURRENT_TIMESTAMP
     WHERE Object_Goods_Juridical.Id = inId
       AND Object_Goods_Juridical.isUpload <> COALESCE(inisUpload, FALSE);  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_isUpload', text_var1::TVarChar, vbUserId);
   END;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Goods_isUpload(Integer, Boolean, TVarChar) OWNER TO postgres;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.  ������ �.�.
 17.10.19                                                                      * 
 23.11.15                                                         *

*/