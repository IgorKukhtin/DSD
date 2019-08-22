-- Function: gpInsertUpdate_Object_WorkTimeKind (Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_WorkTimeKind (Integer, TVarChar, integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_WorkTimeKind(
 INOUT ioId             Integer   ,    -- ���� ������� <>
    IN inShortName      TVarChar  ,    -- �������� ������������ 	
    IN inPayrollTypeID  integer   ,    -- ���� ������� ���������� �����
    IN inSession        TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_WorkTimeKind());
   vbUserId := inSession;

   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_WorkTimeKind_ShortName(), ioId, inShortName);

   -- ��������� ����� � <���� ������� ���������� �����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_WorkTimeKind_PayrollType(), ioId, inPayrollTypeID);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$ LANGUAGE plpgsql;
ALTER FUNCTION gpInsertUpdate_Object_WorkTimeKind (Integer, TVarChar, integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.08.19                                                       *
 01.10.13         * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_WorkTimeKind()
