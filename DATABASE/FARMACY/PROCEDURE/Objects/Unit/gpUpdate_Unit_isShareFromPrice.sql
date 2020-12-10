-- Function: gpUpdate_Unit_isShareFromPrice()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isShareFromPrice(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_isShareFromPrice(
    IN inId                  Integer   ,    -- ���� ������� <�������������>
    IN inisShareFromPrice    Boolean   ,    -- ������ ����������� �� ����
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_ShareFromPrice(), inId, not inisShareFromPrice);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.12.20                                                       *
*/