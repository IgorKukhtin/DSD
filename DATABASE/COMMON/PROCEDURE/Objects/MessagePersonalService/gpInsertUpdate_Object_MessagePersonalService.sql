-- 

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MessagePersonalService (Integer, Integer, TVarChar, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MessagePersonalService (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MessagePersonalService(
 INOUT ioId                      Integer,       -- ���� �������
 INOUT ioCode                    Integer,       -- � ������
    IN inName                    TVarChar,      -- ��������� �� ������
    IN inUnitId                  Integer,       --
    IN inPersonalServiceListId   Integer,       --
    IN inMemberId                Integer,       --
    IN inComment                 TVarChar,      -- ����������
    IN inSession                 TVarChar       -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;  
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_MessagePersonalService());


   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;
   
    -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   ioCode:= lfGet_ObjectCode (ioCode, zc_Object_MessagePersonalService()); 

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_MessagePersonalService(), ioCode, inName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MessagePersonalService_Unit(), ioId, inUnitId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MessagePersonalService_PersonalServiceList(), ioId, inPersonalServiceListId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MessagePersonalService_Member(), ioId, inMemberId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_MessagePersonalService_Comment(), ioId, inComment);

   IF vbIsInsert = TRUE THEN
      -- ��������� �������� <���� ��������>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- ��������� �������� <������������ (��������)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.02.25         *
*/

-- ����
--
