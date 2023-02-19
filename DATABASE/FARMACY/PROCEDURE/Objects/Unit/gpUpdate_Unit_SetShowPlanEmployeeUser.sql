-- Function: gpUpdate_Unit_SetShowPlanEmployeeUser()

DROP FUNCTION IF EXISTS gpUpdate_Unit_SetShowPlanEmployeeUser(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_SetShowPlanEmployeeUser(
    IN inId                       Integer   ,    -- ���� ������� <�������������>
    IN inisShowPlanEmployeeUser   Boolean   ,    -- �������� ������������� ���
    IN inSession                  TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_ShowPlanEmployeeUser(), inId, inisShowPlanEmployeeUser);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.02.23                                                       *
*/

-- select * from gpUpdate_Unit_SetShowPlanEmployeeUser(inId := 13338606 , inisShowPlanEmployeeUser := 'False' ,  inSession := '3');