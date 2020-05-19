-- Function: gpUpdate_Unit_OrderPromo()

DROP FUNCTION IF EXISTS gpUpdate_Unit_OrderPromo(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_OrderPromo(
    IN inId                  Integer   ,    -- ���� ������� <�������������>
    IN inisOrderPromo        Boolean   ,    -- 
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);


   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_OrderPromo(), inId, inisOrderPromo);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.05.20         *

*/