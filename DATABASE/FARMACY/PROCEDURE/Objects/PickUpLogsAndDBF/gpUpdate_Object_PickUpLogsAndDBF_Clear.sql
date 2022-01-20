-- Function: gpUpdate_Object_PickUpLogsAndDBF_Clear()

DROP FUNCTION IF EXISTS gpUpdate_Object_PickUpLogsAndDBF_Clear (Integer, TVarchar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_PickUpLogsAndDBF_Clear(
    IN inId                      Integer   ,   	-- ���� ������� <>
    IN inSession                 TVarChar       -- ������ ������������
)
  RETURNS VOID AS
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

   -- ��������� ����� � <��� ������� ���������� �����>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_PickUpLogsAndDBF_Loaded(), inId, False);

   -- ��������� �������� <���� ������ ��������>
   PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_PickUpLogsAndDBF_DateLoaded(), inId, Null);
   
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

select * from gpUpdate_Object_PickUpLogsAndDBF_Clear(inId := 0, inSession := '3');