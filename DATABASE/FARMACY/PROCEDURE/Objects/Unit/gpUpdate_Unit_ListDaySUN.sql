-- Function: gpUpdate_Unit_ListDaySUN()

DROP FUNCTION IF EXISTS gpUpdate_Unit_ListDaySUN(Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Unit_ListDaySUN(
    IN inId             Integer   ,    -- ���� ������� <�������������>
    IN inListDaySUN     TVarChar   ,    -- 
    IN inSession        TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- �� ����� ���� ������ �� ���
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Unit_ListDaySUN(), inId, inListDaySUN);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.04.20                                                       *

*/
--