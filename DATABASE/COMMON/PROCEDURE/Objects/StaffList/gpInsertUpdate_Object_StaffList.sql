-- Function: gpInsertUpdate_Object_StaffList(Integer, Integer, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_StaffList (Integer, Integer, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_StaffList (Integer, Integer, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_StaffList (Integer, Integer, TFloat, TFloat, TFloat, Boolean, TVarChar, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_StaffList(
 INOUT ioId                  Integer   , -- ���� ������� <������� ����������>
    IN inCode                Integer   , -- �������� <���>
    IN inHoursPlan           TFloat    , -- ����� ���� ����� �� ����� �� ��������
    IN inHoursDay            TFloat    , -- ������� ���� ����� �� ��������
    IN inPersonalCount       TFloat    , -- ���. �������
    IN inisPositionLevel     Boolean   , -- ��� "������� ���������"
    IN inComment             TVarChar  , -- �����������
    IN inUnitId              Integer   , -- �������������
    IN inPositionId          Integer   , -- ���������
    IN inPositionLevelId     Integer   , -- ������ ���������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer; 
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_StaffList());
   vbUserId:= lpGetUserBySession (inSession);

   -- �������� ����
   IF vbUserId <> 5 AND NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_Update_Object_StaffList())
   THEN
        RAISE EXCEPTION '������.%��� ���� �������������� = <%>.'
                      , CHR (13)
                      , (SELECT ObjectDesc.ItemName FROM ObjectDesc WHERE ObjectDesc.Id = zc_Object_StaffList())
                       ;
   END IF;


   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode:= lfGet_ObjectCode (inCode, zc_Object_StaffList());

   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_StaffList(), vbCode);
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_StaffList(), vbCode, '');
   
   -- ��������� �������� <����� ���� ����� �� ����� �� ��������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StaffList_HoursPlan(), ioId, inHoursPlan);
   -- ��������� �������� <������� ���� ����� �� ��������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StaffList_HoursDay(), ioId, inHoursDay);
   -- ��������� �������� <���. �������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StaffList_PersonalCount(), ioId, inPersonalCount);
  
   -- ��������� �������� <>   
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_StaffList_PositionLevel(), ioId, inisPositionLevel);

   -- ��������� �������� <>   
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_StaffList_Comment(), ioId, inComment);
   
   -- ��������� ����� � <��������������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StaffList_Unit(), ioId, inUnitId);   
   -- ��������� ����� � <����������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StaffList_Position(), ioId, inPositionId);
   -- ��������� ����� � <�������� ���������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StaffList_PositionLevel(), ioId, inPositionLevelId);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_StaffList (Integer, Integer, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.03.16         * 
 30.11.13                                        * add zc_ObjectFloat_StaffList_HoursDay
 31.10.13         * add Code 
 18.10.13         * add FundPayMonth, FundPayTurn, Comment  
 17.10.13         * 
*/

/*
insert into ObjectFloat (ObjectId, DescId, ValueData)
select ObjectLink_StaffListSumm_StaffList.ChildObjectId, zc_ObjectFloat_StaffList_HoursDay(), ObjectFloat_Value.ValueData
from ObjectLink 
JOIN ObjectFloat AS ObjectFloat_Value 
                 ON ObjectFloat_Value.ObjectId = ObjectLink .ObjectId 
                AND ObjectFloat_Value.DescId = zc_ObjectFloat_StaffListSumm_Value()
LEFT JOIN ObjectLink AS ObjectLink_StaffListSumm_StaffList
                     ON ObjectLink_StaffListSumm_StaffList.ObjectId = ObjectLink .ObjectId 
                    AND ObjectLink_StaffListSumm_StaffList.DescId = zc_ObjectLink_StaffListSumm_StaffList()

where ObjectLink.ChildObjectId = zc_Enum_StaffListSummKind_WorkHours() AND ObjectLink.DescId = zc_ObjectLink_StaffListSumm_StaffListSummKind()

delete from ObjectFloat where ObjectId in (select ObjectLink .ObjectId from ObjectLink where ChildObjectId = zc_Enum_StaffListSummKind_WorkHours() AND DescId = zc_ObjectLink_StaffListSumm_StaffListSummKind());
delete from ObjectString where ObjectId in (select ObjectLink .ObjectId from ObjectLink where ChildObjectId = zc_Enum_StaffListSummKind_WorkHours() AND DescId = zc_ObjectLink_StaffListSumm_StaffListSummKind());
delete from ObjectLink where ObjectId in (select ObjectLink .ObjectId from ObjectLink where ChildObjectId = zc_Enum_StaffListSummKind_WorkHours() AND DescId = zc_ObjectLink_StaffListSumm_StaffListSummKind());
delete from ObjectProtocol where ObjectId in (select Object.Id from Object left join ObjectLink on ObjectId= Object.Id AND ObjectLink.DescId = zc_ObjectLink_StaffListSumm_StaffListSummKind() where Object.DescId =  zc_Object_StaffListSumm() and ObjectId is null);
delete from Object where Id in (select Object.Id from Object left join ObjectLink on ObjectId= Object.Id AND ObjectLink.DescId = zc_ObjectLink_StaffListSumm_StaffListSummKind() where Object.DescId =  zc_Object_StaffListSumm() and ObjectId is null);
delete from ObjectString where ObjectId in (select zc_Enum_StaffListSummKind_WorkHours() union select zc_Enum_StaffListSummKind_HoursDayConst());
delete from Object where Id in (12316, 12334 );

DROP FUNCTION IF EXISTS zc_Enum_StaffListSummKind_WorkHours(); 
DROP FUNCTION IF EXISTS zc_Enum_StaffListSummKind_HoursDayConst()
*/
-- ����
-- SELECT * FROM gpInsertUpdate_Object_StaffList (0,  198, 2, 1000, 1, 5, 6, '2')
