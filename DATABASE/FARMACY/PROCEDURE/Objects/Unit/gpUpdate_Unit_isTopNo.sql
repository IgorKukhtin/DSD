-- Function: gpUpdate_Unit_isTopNo()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isTopNo(Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Unit_isTopNo(
    IN inId             Integer   ,    -- ���� ������� <�������������>
    IN inisTopNo        Boolean   ,    -- 
   OUT outisTopNo       Boolean   ,
    IN inSession        TVarChar       -- ������� ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- ���������� �������
   outisTopNo:= NOT inisTopNo;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_TopNo(), inId, outisTopNo);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.09.19         *

*/
--