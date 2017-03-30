-- Function: gpUpdate_Goods_isUploadTeva()

DROP FUNCTION IF EXISTS gpUpdate_Goods_isUploadTeva(Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Goods_isUploadTeva(
    IN inId            Integer   ,    -- ���� ������� <�������������>
    IN inisUploadTeva  Boolean   ,    --
   OUT outisUploadTeva Boolean   ,
    IN inSession       TVarChar       -- ������� ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

      IF COALESCE(inId, 0) = 0 
      THEN
           RETURN;
      END IF;

      vbUserId := lpGetUserBySession (inSession);

      -- ���������� �������
      outisUploadTeva:= inisUploadTeva;

      PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_UploadTeva(), inId, outisUploadTeva);

      -- ��������� ��������
      PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.  �������� �.�.
 30.03.17                                                                       *

*/
--select * from gpUpdate_Goods_isUploadTeva(inId := 1393106 , inisUploadTeva := 'False' ,  inSession := '3');