-- Function: gpUpdate_Object_Personal_Property ()

--DROP FUNCTION IF EXISTS gpUpdate_Object_Personal_Property (Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpUpdate_Object_Personal_Property (Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Personal_Property (Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Personal_Property(
    IN inId                                Integer   , -- ���� ������� <����������>
    IN inPositionId                        Integer   , -- ������ �� ���������
    IN inUnitId                            Integer   , -- ������ �� �������������
    IN inPersonalServiceListOfficialId     Integer   , -- ��������� ����������(��)
    IN inPersonalServiceListCardSecondId   Integer   , -- ��������� ����������(����� �2)  
    IN inPersonalServiceListId_AvanceF2    Integer   , -- ��������� ����������(����� ����� �2)
    IN inStorageLineId                     Integer   , -- ������ �� ����� ������������
    IN inCode1C                            TVarChar  , --��� 1�
    IN inIsMain                            Boolean   , -- �������� ����� ������
    IN inSession                           TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbMemberId Integer;
   DECLARE vbCode     Integer;
   DECLARE vbName     TVarChar;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Personal());


   -- �������� ����� ������ - ������ ����
   vbMemberId:=  (SELECT View_Personal.MemberId FROM Object_Personal_View AS View_Personal WHERE View_Personal.PersonalId = inId);
   -- �������� ����� ������ - ������ ����
   IF inIsMain = TRUE
      AND EXISTS (SELECT 1 FROM Object_Personal_View AS View_Personal WHERE View_Personal.MemberId = vbMemberId AND View_Personal.isMain = TRUE AND View_Personal.PersonalId <> COALESCE(inId, 0)) THEN
      RAISE EXCEPTION '�������� <�������� ����� ������> = ��, ��� ����������� ��� �������������: <%> ���������: <%> ������ ���������: <%>. ���� ������� ����� ���������� ������ 1 ���.'
                    , lfGet_Object_ValueData_sh ((SELECT View_Personal.UnitId          FROM Object_Personal_View AS View_Personal WHERE View_Personal.MemberId = vbMemberId AND View_Personal.isMain = TRUE ORDER BY View_Personal.PersonalId LIMIT 1))
                    , lfGet_Object_ValueData_sh ((SELECT View_Personal.PositionId      FROM Object_Personal_View AS View_Personal WHERE View_Personal.MemberId = vbMemberId AND View_Personal.isMain = TRUE ORDER BY View_Personal.PersonalId LIMIT 1))
                    , lfGet_Object_ValueData_sh ((SELECT View_Personal.PositionLevelId FROM Object_Personal_View AS View_Personal WHERE View_Personal.MemberId = vbMemberId AND View_Personal.isMain = TRUE ORDER BY View_Personal.PersonalId LIMIT 1))
                     ;
   END IF;

   -- ��������� ����� � <����������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Position(), inId, inPositionId);
   -- ��������� �������� <�������� ����� ������>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Personal_Main(), inId, inIsMain);
   -- ��������� ����� � <��������������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Unit(), inId, inUnitId);
   -- ��������� ����� � <��������� ����������(��)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_PersonalServiceListOfficial(), inId, inPersonalServiceListOfficialId); 
   -- ��������� ����� � <��������� ����������(����� �2)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_PersonalServiceListCardSecond(), inId, inPersonalServiceListCardSecondId);
   -- ��������� ����� � <��������� ����������(����� ����� �2)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_PersonalServiceListAvance_F2(), inId, CASE WHEN EXISTS (SELECT 1 FROM Object WHERE Object.Id = inPersonalServiceListId_AvanceF2 AND TRIM (Object.ValueData) = '' ) THEN 0 ELSE inPersonalServiceListId_AvanceF2 END);
   -- ��������� ����� � <����� ������������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_StorageLine(), inId, inStorageLineId); 
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Personal_Code1C(), inId, inCode1C);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpUpdate_Object_Personal_Property (Integer, Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;

/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.
 27,04,23         *
 13.04.22         * add inCode1C
 13.07.17         * add inPersonalServiceListCardSecondId
 25.05.17         * add inStorageLineId
 26.08.15         * add inPersonalServiceListOfficialId
 15.09.14                                                       *
 12.09.14                                                       *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Personal_Property (inId:=0, inPositionId:=0, inIsMain:=False, inSession:='2')