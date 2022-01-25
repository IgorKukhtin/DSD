-- Function: gpUpdate_Object_PickUpLogsAndDBF_GetArchive()

DROP FUNCTION IF EXISTS gpUpdate_Object_PickUpLogsAndDBF_GetArchive (Integer, Boolean, TVarchar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_PickUpLogsAndDBF_GetArchive(
    IN inId                      Integer   ,   	-- ���� ������� <>
 INOUT ioisGetArchive            Boolean   ,   	-- �������� � ����� �����
    IN inSession                 TVarChar       -- ������ ������������
)
  RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_CorrectMinAmount());
   vbUserId := lpGetUserBySession (inSession); 

   
   IF COALESCE(inId, 0) = 0
   THEN
     RAISE EXCEPTION '������ �� ���������.';
   END IF;
   
   ioisGetArchive := not ioisGetArchive;

   -- ��������� ����� � <�������� � ����� �����>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_PickUpLogsAndDBF_GetArchive(), inId, ioisGetArchive);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.01.22                                                       *
*/

-- ����
-- 
