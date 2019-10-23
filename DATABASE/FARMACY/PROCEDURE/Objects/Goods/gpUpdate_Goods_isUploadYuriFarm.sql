-- Function: gpUpdate_Goods_isUploadYuriFarm()

DROP FUNCTION IF EXISTS gpUpdate_Goods_isUploadYuriFarm(Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Goods_isUploadYuriFarm(
    IN inId                Integer   ,    -- ���� ������� <�������������>
    IN inisUploadYuriFarm  Boolean   ,    --
   OUT outisUploadYuriFarm Boolean   ,
    IN inSession           TVarChar       -- ������� ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE text_var1 text;
BEGIN


      
      IF COALESCE(inId, 0) = 0 
      THEN
           -- ���������� �������
           outisUploadYuriFarm:= inisUploadYuriFarm;
           RETURN;
      END IF;

      vbUserId := lpGetUserBySession (inSession);

      -- ���������� �������
      outisUploadYuriFarm:= inisUploadYuriFarm;

      PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_UploadYuriFarm(), inId, outisUploadYuriFarm);

        -- ��������� � ������� �������
      BEGIN
        UPDATE Object_Goods_Juridical SET isUploadYuriFarm = COALESCE(inisUploadYuriFarm, FALSE)
                                        , UserUpdateId = vbUserId
                                        , DateUpdate   = CURRENT_TIMESTAMP
        WHERE Object_Goods_Juridical.Id = inId
          AND Object_Goods_Juridical.isUploadYuriFarm <> COALESCE(inisUploadYuriFarm, FALSE);  
      EXCEPTION
         WHEN others THEN 
           GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
           PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_isUploadYuriFarm', text_var1::TVarChar, vbUserId);
      END;

      -- ��������� ��������
      PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 23.10.19                                                      * 

*/
--select * from gpUpdate_Goods_isUploadYuriFarm(inId := 1393106 , inisUploadYuriFarm := 'False' ,  inSession := '3');