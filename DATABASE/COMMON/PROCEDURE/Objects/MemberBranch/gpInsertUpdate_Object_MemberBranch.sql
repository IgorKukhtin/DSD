-- Function: gpInsertUpdate_Object_MemberBranch()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberBranch (Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberBranch(
 INOUT ioId              Integer   , -- ���� ������� <>
    IN inBranchId        Integer   , -- ������ �� ������
    IN inMemberId        Integer   , -- ���.����
    IN inComment         TVarChar  , -- ����������
    IN inSession         TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean; 
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_MemberBranch());

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_MemberBranch(), 0, '');


   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MemberBranch_Branch(), ioId, inBranchId);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MemberBranch_Member(), ioId, inMemberId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_MemberBranch_Comment(), ioId, inComment);
    
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.10.20         *
*/

-- ����
--