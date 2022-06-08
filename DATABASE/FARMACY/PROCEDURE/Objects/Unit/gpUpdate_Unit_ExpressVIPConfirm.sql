-- Function: gpUpdate_Unit_ExpressVIPConfirm()

DROP FUNCTION IF EXISTS gpUpdate_Unit_ExpressVIPConfirm(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_ExpressVIPConfirm(
    IN inId                     Integer   ,    -- ���� ������� <�������������>
    IN inisExpressVIPConfirm    Boolean   ,    -- �������� ������������� ���
    IN inSession                TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_ExpressVIPConfirm(), inId, not inisExpressVIPConfirm);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.06.22                                                       *
*/

-- select * from gpUpdate_Unit_ExpressVIPConfirm(inId := 13338606 , inisExpressVIPConfirm := 'False' ,  inSession := '3');