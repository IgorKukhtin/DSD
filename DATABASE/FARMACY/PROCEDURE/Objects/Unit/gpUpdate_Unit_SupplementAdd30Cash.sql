-- Function: gpUpdate_Unit_SupplementAdd30Cash()

DROP FUNCTION IF EXISTS gpUpdate_Unit_SupplementAdd30Cash(Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Unit_SupplementAdd30Cash(
    IN inId                      Integer   ,    -- ���� ������� <�������������>
    IN inisSupplementAdd30Cash       Boolean   ,    -- 
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

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SUN_SupplementAdd30Cash(), inId, NOT inisSupplementAdd30Cash);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 17.02.22                                                      *

*/
--select * from gpUpdate_Unit_SupplementAdd30Cash(inId := 1393106 , inisSupplementAdd30Cash := 'False' ,  inSession := '3');