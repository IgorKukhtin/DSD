-- Function: gpUpdate_Goods_isUploadBadm()

DROP FUNCTION IF EXISTS gpUpdate_Goods_isUploadBadm(Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Goods_isUploadBadm(
    IN inId                  Integer   ,    -- ���� ������� <�������������>
    IN inisUploadBadm        Boolean   ,    -- 
   OUT outisUploadBadm       Boolean   ,
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      -- ���������� �������
      outisUploadBadm:= inisUploadBadm;
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- ���������� �������
   outisUploadBadm:= inisUploadBadm;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_UploadBadm(), inId, outisUploadBadm);

     -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Juridical SET isUploadBadm = COALESCE(inisUploadBadm, FALSE)
                                     , UserUpdateId = vbUserId
                                     , DateUpdate   = CURRENT_TIMESTAMP
     WHERE Object_Goods_Juridical.Id = inId
       AND Object_Goods_Juridical.isUploadBadm <> COALESCE(inisUploadBadm, FALSE);  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_isUploadBadm', text_var1::TVarChar, vbUserId);
   END;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.  ������ �.�.
 17.10.19                                                                      * 
 18.01.17         *

*/
--select * from gpUpdate_Goods_isUploadBadm(inId := 1393106 , inisUploadBadm := 'False' ,  inSession := '3');
--select * from gpUpdate_Goods_isUploadBadm(inId := 0 , inisUploadBadm := 'False' ,  inSession := '3');