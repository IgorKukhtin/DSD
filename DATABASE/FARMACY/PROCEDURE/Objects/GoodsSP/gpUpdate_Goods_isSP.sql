-- Function: gpUpdate_Goods_isSP()

DROP FUNCTION IF EXISTS gpUpdate_Goods_isSP(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_isSP(
    IN inId                Integer   ,    -- ���� ������� <�����>
    IN inisSP              Boolean   ,    -- ��������� � ���. �������
   OUT outisSP             Boolean   ,
    IN inSession           TVarChar       -- ������� ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- ���������� �������
   outisSP:= NOT inisSP;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_SP(), inId, outisSP);

     -- ��������� � ������� �������
    BEGIN

      UPDATE Object_Goods_SP SET isSP = outisSP
      WHERE Object_Goods_SP.Id = inId;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
         PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_isSP', text_var1::TVarChar, vbUserId);
    END;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.   ������ �.�.
 22.10.19                                                                       *
 19.12.16         *

*/