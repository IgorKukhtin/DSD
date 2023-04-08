-- Function: gpUpdate_Object_StaffList_HoursPlan(

DROP FUNCTION IF EXISTS gpUpdate_Object_StaffList_HoursPlan (Integer, TFloat, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_StaffList_HoursPlan(
    IN inUnitId              Integer,       -- �������������
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

  IF inUnitId <> 0 
  THEN 
      INSERT INTO _tmpUnit(UnitId)
                 SELECT inUnitId;
  ELSE 
      INSERT INTO _tmpUnit (UnitId)
                 SELECT OBJECT.Id FROM OBJECT
                 WHERE OBJECT.DescId = zc_Object_Unit();
  END IF;


   -- ������������� �������� <����� ���� ����� �� ����� �� ��������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StaffList_HoursPlan(), Object_StaffList.Id, inHoursPlan_new)
         , lpInsert_ObjectProtocol (Object_StaffList.Id, vbUserId)
   FROM _tmpUnit
          LEFT JOIN ObjectLink AS ObjectLink_StaffList_Unit
                               ON ObjectLink_StaffList_Unit.ChildObjectId = _tmpUnit.UnitId
                              AND ObjectLink_StaffList_Unit.DescId = zc_ObjectLink_StaffList_Unit()
                                
          LEFT JOIN Object AS Object_StaffList ON Object_StaffList.Id = ObjectLink_StaffList_Unit.ObjectId
          
          LEFT JOIN ObjectFloat AS ObjectFloat_HoursPlan 
                                ON ObjectFloat_HoursPlan.ObjectId = Object_StaffList.Id 
                               AND ObjectFloat_HoursPlan.DescId = zc_ObjectFloat_StaffList_HoursPlan()

   WHERE Object_StaffList.DescId = zc_Object_StaffList()
     AND Object_StaffList.isErased = False
     AND COALESCE (ObjectFloat_HoursPlan.ValueData,0) = inHoursPlan;
 
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