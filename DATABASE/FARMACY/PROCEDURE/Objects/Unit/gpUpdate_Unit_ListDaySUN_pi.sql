-- Function: gpUpdate_Unit_ListDaySUN_pi()

DROP FUNCTION IF EXISTS gpUpdate_Unit_ListDaySUN_pi(Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Unit_ListDaySUN_pi(
    IN inId                Integer   ,    -- ���� ������� <�������������>
    IN inListDaySUN_pi     TVarChar  ,    -- 
    IN inSession           TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- �� ����� ���� ������ �� ���2
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Unit_ListDaySUN_pi(), inId, inListDaySUN_pi);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.04.20         *
*/
--