-- Function: gpUpdate_Unit_ShowMessageSite()

DROP FUNCTION IF EXISTS gpUpdate_Unit_ShowMessageSite(Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Unit_ShowMessageSite(
    IN inId                      Integer   ,    -- ���� ������� <�������������>
    IN inisShowMessageSite       Boolean   ,    -- 
    IN inSession                 TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_ShowMessageSite(), inId, NOT inisShowMessageSite);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 17.02.22                                                      *

*/
--select * from gpUpdate_Unit_ShowMessageSite(inId := 1393106 , inisShowMessageSite := 'False' ,  inSession := '3');