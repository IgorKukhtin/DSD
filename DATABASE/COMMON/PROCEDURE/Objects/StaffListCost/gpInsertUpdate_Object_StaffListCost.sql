-- Function: gpInsertUpdate_Object_StaffListCost(Integer,  TFloat, TVarChar, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_StaffListCost(Integer,  TFloat, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_StaffListCost(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �������� ����������>
    IN inPrice               TFloat    , -- �������� ���./��.
    IN inComment             TVarChar  , -- �����������
    IN inStaffListId         Integer   , -- ������� ����������
    IN inModelServiceId      Integer   , -- ������ ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_StaffListCost());
   vbUserId:= lpGetUserBySession (inSession);

   -- �������� ����
   IF NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_Update_Object_StaffList())
      AND vbUserId <> 5
   THEN
        RAISE EXCEPTION '������.%��� ���� �������������� = <%>.'
                      , CHR (13)
                      , (SELECT ObjectDesc.ItemName FROM ObjectDesc WHERE ObjectDesc.Id = zc_Object_StaffListCost())
                       ;
   END IF;

    -- ��������
   IF COALESCE (inStaffListId, 0) = 0
   THEN
       RAISE EXCEPTION '������. ������� �������� ���������� �� �����������.';
   END IF;

    -- ��������
   IF COALESCE (inModelServiceId, 0) = 0 AND COALESCE (ioId, 0) = 0
   THEN
       RAISE EXCEPTION '������. ������ ���������� �� �����������.';
   END IF;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_StaffListCost(), 0, '');

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StaffListCost_Price(), ioId, inPrice);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_StaffListCost_Comment(), ioId, inComment);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StaffListCost_StaffList(), ioId, inStaffListId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StaffListCost_ModelService(), ioId, inModelServiceId);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.10.13         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_StaffListCost (0,  198, 'flgks', 5, 6, '2')
