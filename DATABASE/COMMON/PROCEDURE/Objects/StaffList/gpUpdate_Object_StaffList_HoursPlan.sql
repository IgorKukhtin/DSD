-- Function: gpUpdate_Object_StaffList_HoursPlan(

DROP FUNCTION IF EXISTS gpUpdate_Object_StaffList_HoursPlan (Integer, TFloat, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_StaffList_HoursPlan(
    IN inId                  Integer,       -- 
    IN inHoursPlan           TFloat    , -- ����� ���� ����� �� ����� �� ��������
    IN inHoursPlan_new       TFloat    , -- ����� ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_StaffList());
   vbUserId:= lpGetUserBySession (inSession);

   -- �������� ����
   IF NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_Update_Object_StaffList())
   THEN
        RAISE EXCEPTION '������.%��� ���� �������������� = <%>.'
                      , CHR (13)
                      , (SELECT ObjectDesc.ItemName FROM ObjectDesc WHERE ObjectDesc.Id = zc_Object_StaffList())
                       ;
   END IF;

   --���� �� ������ ������� 0 - ����������
   IF COALESCE (inHoursPlan_new,0) = 0
   THEN
       RAISE EXCEPTION '������.��������� ������������� �������� = 0';
   END IF;

   --�������� ������������� �� ��������� ������� ������� 
   IF (SELECT OF.ValueData FROM ObjectFloat AS OF WHERE OF.DescId = zc_ObjectFloat_StaffList_HoursPlan() AND OF.ObjectId = inId) <> inHoursPlan
   THEN
       RETURN;
   END IF;
   
   -- ������������� �������� <����� ���� ����� �� ����� �� ��������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StaffList_HoursPlan(), inId, inHoursPlan_new);
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
 
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.04.23         * 
*/

-- ����
--