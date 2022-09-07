-- Function: gpUpdate_Object_Unit_Personal

DROP FUNCTION IF EXISTS gpUpdate_Object_Unit_Personal (Integer, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Unit_Personal(
    IN inId                    Integer   , -- ���� ������� <�������������>
    IN inPersonalServiceDate   TDateTime , -- 
    IN inisPersonalService     Boolean   , -- 
    IN inSession               TVarChar    -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Object_Unit_Personal());

   IF inId = 0
   THEN
       Return;
   END IF;
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_PersonalService(), inId, inisPersonalService);
   -- ��������� �������� <>
   --PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_PersonalService(), inId, inPersonalServiceDate);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.09.22         *            
*/

-- ����
--