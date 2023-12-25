-- Function: gpInsertUpdate_Object_StaffListSumm(Integer, TFloat, TVarChar, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_StaffListSumm(Integer, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_StaffListSumm(
 INOUT ioId                  Integer   , -- ���� ������� <������� ����������>
    IN inValue               TFloat    , -- �����, ���
    IN inComment             TVarChar  , -- �����������
    IN inStaffListId         Integer   , -- ������� ����������
    IN inStaffListMasterId   Integer   , -- ������� ���������� (����� �� "��������" �������� ����� ��� ��������)
    IN inStaffListSummKindId Integer   , -- ���� ���� ��� �������� ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
--raise exception '%', inStaffListId;
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_StaffListSumm());
   vbUserId:= lpGetUserBySession (inSession);

   -- �������� ����
   IF NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_Update_Object_StaffList())
      AND vbUserId <> 5
   THEN
        RAISE EXCEPTION '������.%��� ���� �������������� = <%>.'
                      , CHR (13)
                      , (SELECT ObjectDesc.ItemName FROM ObjectDesc WHERE ObjectDesc.Id = zc_Object_StaffListSumm())
                       ;
   END IF;

    -- ��������
   IF COALESCE (inStaffListId, 0) = 0
   THEN
       RAISE EXCEPTION '������! ������� �������� ���������� �� �����������!';
   END IF;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_StaffListSumm(), 0, '');

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StaffListSumm_Value(), ioId, inValue);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_StaffListSumm_Comment(), ioId, inComment);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StaffListSumm_StaffList(), ioId, inStaffListId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StaffListSumm_StaffListMaster(), ioId, inStaffListMasterId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StaffListSumm_StaffListSummKind(), ioId, inStaffListSummKindId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.10.13         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_StaffListSumm (0, 1000, 'StaffListSumm', 1, 5, 6, '2')
