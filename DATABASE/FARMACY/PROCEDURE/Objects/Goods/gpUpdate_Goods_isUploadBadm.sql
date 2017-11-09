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

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 18.01.17         *

*/
--select * from gpUpdate_Goods_isUploadBadm(inId := 1393106 , inisUploadBadm := 'False' ,  inSession := '3');
--select * from gpUpdate_Goods_isUploadBadm(inId := 0 , inisUploadBadm := 'False' ,  inSession := '3');