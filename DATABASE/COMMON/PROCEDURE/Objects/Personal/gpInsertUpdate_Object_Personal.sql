-- Function: gpInsertUpdate_Object_Personal()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Personal (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, Boolean, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Personal (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, Boolean, Boolean, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Personal (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TDateTime, Boolean, Boolean, Boolean, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Personal (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TDateTime, Boolean, Boolean, Boolean, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Personal(
 INOUT ioId                                Integer   , -- ���� ������� <����������>
    IN inMemberId                          Integer   , -- ������ �� ���.����
    IN inPositionId                        Integer   , -- ������ �� ���������
    IN inPositionLevelId                   Integer   , -- ������ �� ������ ���������
    IN inUnitId                            Integer   , -- ������ �� �������������
    IN inPersonalGroupId                   Integer   , -- ����������� �����������
    IN inPersonalServiceListId             Integer   , -- ��������� ����������(�������)
    IN inPersonalServiceListOfficialId     Integer   , -- ��������� ����������(��)
    IN inPersonalServiceListCardSecondId   Integer   , -- ��������� ����������(����� �2) 
    IN inPersonalServiceListId_AvanceF2    Integer   , --  ��������� ����������(����� ����� �2)
    IN inSheetWorkTimeId                   Integer   , -- ����� ������ (������ ������ �.��.)
    IN inStorageLineId                     Integer   , -- ������ �� ����� ������������
    
    IN inMember_ReferId                    Integer   , -- �������� �������������
    IN inMember_MentorId                   Integer   , -- ������� ���������� 	
    IN inReasonOutId                       Integer   , -- ������� ���������� 	
    
    IN inDateIn                            TDateTime , -- ���� ��������
    IN inDateOut                           TDateTime , -- ���� ���������� 
    IN inDateSEnd                          TDateTime , -- ���� ��������
    IN inIsDateOut                         Boolean   , -- ������
    IN inIsDateSend                        Boolean   , -- ���������
    IN inIsMain                            Boolean   , -- �������� ����� ������
    IN inComment                           TVarChar  ,
    IN inSession                           TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;
   DECLARE vbName TVarChar;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Personal());

   -- ��������
   IF COALESCE (inMemberId, 0) = 0
   THEN
       RAISE EXCEPTION '������. <���> �� �������.';
   END IF;
   -- ��������
   IF COALESCE (inUnitId, 0) = 0
   THEN
       RAISE EXCEPTION '������. <�������������> �� �������.';
   END IF;
   -- ��������
   IF COALESCE (inPositionId, 0) = 0
   THEN
       RAISE EXCEPTION '������. <���������> �� �������.';
   END IF;

   -- ���������� ���������, �.�. �������� ������ ���� ���������������� � �������� <���������� ����>
   SELECT ObjectCode, ValueData INTO vbCode, vbName FROM Object WHERE Id = inMemberId;

   -- !!! ��� �������� !!!
   -- IF COALESCE(ioId, 0) = 0
   -- THEN ioId := (SELECT PersonalId FROM Object_Personal_View WHERE PersonalName = vbName AND UnitId = inUnitId AND PositionId = COALESCE (inPositionId, 0) AND PositionLevelId = COALESCE (inPositionLevelId, 0));
   -- END IF;

   -- ��������  ������������ ��� �������: <���> + <�������������> + <���������> + <������ ���������>
   IF EXISTS (SELECT 1 FROM Object_Personal_View WHERE PersonalName = vbName AND UnitId = inUnitId AND PositionId = COALESCE (inPositionId, 0) AND PositionLevelId = COALESCE (inPositionLevelId, 0) AND StorageLineId = COALESCE (inStorageLineId, 0) AND PersonalId <> COALESCE(ioId, 0)) THEN
      RAISE EXCEPTION '�������� <%>%��� �������������: <%>%���������: <%>% % %�� ��������� � ����������� <%>.'
                    , vbName
                    , CHR (13)
                    , lfGet_Object_ValueData_sh (inUnitId)
                    , CHR (13)
                    , lfGet_Object_ValueData_sh (inPositionId)

                    , CASE WHEN inPositionLevelId > 0 THEN CHR (13) || '������ ���������: ' || '<' || lfGet_Object_ValueData_sh (inPositionLevelId) || '>' ELSE '' END
                    , CASE WHEN inStorageLineId > 0 THEN CHR (13) || '����� ������������: ' || '<' || lfGet_Object_ValueData_sh (inStorageLineId) || '>' ELSE '' END

                    , CHR (13)
                    , (SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Personal())
                     ;
   END IF;
   -- �������� ����� ������ - ������ ����
   IF inIsMain = TRUE
      AND EXISTS (SELECT 1 FROM Object_Personal_View AS View_Personal WHERE View_Personal.MemberId = inMemberId AND View_Personal.isMain = TRUE AND View_Personal.PersonalId <> COALESCE(ioId, 0)) THEN
      RAISE EXCEPTION '�������� <�������� ����� ������> = ��, ��� ����������� ��� �������������: <%> ���������: <%> ������ ���������: <%>. ���� ������� ����� ���������� ������ 1 ���.'
                    , lfGet_Object_ValueData_sh ((SELECT View_Personal.UnitId          FROM Object_Personal_View AS View_Personal WHERE View_Personal.MemberId = inMemberId AND View_Personal.isMain = TRUE ORDER BY View_Personal.PersonalId LIMIT 1))
                    , lfGet_Object_ValueData_sh ((SELECT View_Personal.PositionId      FROM Object_Personal_View AS View_Personal WHERE View_Personal.MemberId = inMemberId AND View_Personal.isMain = TRUE ORDER BY View_Personal.PersonalId LIMIT 1))
                    , lfGet_Object_ValueData_sh ((SELECT View_Personal.PositionLevelId FROM Object_Personal_View AS View_Personal WHERE View_Personal.MemberId = inMemberId AND View_Personal.isMain = TRUE ORDER BY View_Personal.PersonalId LIMIT 1))
                     ;
   END IF;
   


   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Personal(), vbCode, vbName
                                , inAccessKeyId:= COALESCE ((SELECT Object_Branch.AccessKeyId FROM ObjectLink LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink.ChildObjectId WHERE ObjectLink.ObjectId = inUnitId AND ObjectLink.DescId = zc_ObjectLink_Unit_Branch())
                                                            -- ���� ��� "������������" �������������
                                                          , (SELECT zc_Enum_Process_AccessKey_TrasportDnepr() WHERE EXISTS (SELECT 1 FROM ObjectLink WHERE DescId = zc_ObjectLink_Car_Unit() AND ChildObjectId = inUnitId))
                                                           )
                                 );
   -- ��������� ����� � <���.�����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Member(), ioId, inMemberId);
   -- ��������� ����� � <����������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Position(), ioId, inPositionId);
   -- ��������� ����� � <������ ���������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_PositionLevel(), ioId, inPositionLevelId);
   -- ��������� ����� � <��������������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Unit(), ioId, inUnitId);
   -- ��������� ����� � <����������� �����������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_PersonalGroup(), ioId, inPersonalGroupId);
   -- ��������� ����� � <��������� ����������()>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_PersonalServiceList(), ioId, inPersonalServiceListId);
   -- ��������� ����� � <��������� ����������(��)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_PersonalServiceListOfficial(), ioId, inPersonalServiceListOfficialId);
   -- ��������� ����� � <��������� ����������(����� �2)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_PersonalServiceListCardSecond(), ioId, inPersonalServiceListCardSecondId);
   -- ��������� ����� � <��������� ����������(����� ����� �2)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_PersonalServiceListAvance_F2(), ioId, inPersonalServiceListId_AvanceF2);
   -- ��������� ����� � <����� ������ (������ ������ �.��.)>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Personal_SheetWorkTime(), ioId, inSheetWorkTimeId);
   -- ��������� ����� � <����� ������������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_StorageLine(), ioId, inStorageLineId);
   -- ��������� �������� <���� ��������>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Personal_In(), ioId, inDateIn);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Member_Refer(), ioId, inMember_ReferId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Member_Mentor(), ioId, inMember_MentorId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_ReasonOut(), ioId, inReasonOutId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Personal_Comment(), ioId, inComment);


   -- ��������� �������� <���� ����������>
   IF inIsDateOut = TRUE
   THEN
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Personal_Out(), ioId, inDateOut);
   ELSE
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Personal_Out(), ioId, zc_DateEnd());
   END IF;  
   
   IF inIsDateSend = TRUE
   THEN
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Personal_Send(), ioId, inDateSEnd);
   ELSE
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Personal_Send(), ioId, Null);
   END IF;


   -- ��������� �������� <�������� ����� ������>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Personal_Main(), ioId, inIsMain);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

   -- ��� ������
   IF vbUserId IN (5, 9457)
   THEN
       RAISE EXCEPTION '������.test=ok';
   END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.04.23         *
 19.04.23         *
 06.08.21         *
 13.07.17         * add PersonalServiceListCardSecond
 25.05.16         * add StorageLine
 16.11.16         * add inSheetWorkTimeId
 26.08.15         * add PersonalServiceListOfficial
 07.05.15         * add PersonalServiceList
 12.09.14                                        * add inIsDateOut and inIsOfficial
 21.05.14                        * add inOfficial
 14.12.13                                        * add inAccessKeyId ����� �� �������
 08.12.13                                        * add inAccessKeyId ����� � <���������� ����>
 21.11.13                                        * add �������� ������������ ��� �������
 21.11.13                                        * add inPositionLevelId
 09.11.13                                        * �������������� � �������� <���������� ����>
 28.10.13                                        * add RAISE...
 30.09.13                                        * del vbCode
 25.09.13         * add _PersonalGroup; remove _Juridical, _Business
 06.09.13                         * inName - �����. �� ����� ��� ���� ����������
 24.07.13                                        * inName - ���� !!! ��� ���� �� vbMemberName
 01.07.13          *
 19.07.13                         *
 19.07.13         *    rename zc_ObjectDate...
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Personal (ioId:=0, inCode:=0, inName:='����� ������������', inMemberId:=26622, inPositionId:=0, inUnitId:=21778, inJuridicalId:=23966, inBusinessId:=0, inDateIn:=null, inDateOut:=null, inSession:='2')
