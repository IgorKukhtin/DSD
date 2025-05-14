-- View: _bi_Guide_Personal_View

 DROP VIEW IF EXISTS _bi_Guide_Personal_View;

-- ���������� ����������

/*
--���������
Id
Code
Name
-- ������� "������ ��/���"
isErased
--��� ����
MemberId
--������ ���������
AccesskeyId
--���������
PositionId
PositionCode
Positionname
--������ ���������
PositionlevelId
PositionlevelCode
Positionlevelname
-- �������������  - ������
BranchId
BranchCode
Branchname
--�������������
UnitId
UnitCode
Unitname
--����������� �����������
PersonalGroupId
PersonalGroupCode
PersonalGroupname
--���� ������
DateIn
--���� ����������
Dateout
--���� ��������
Datesend
--�������� ����� ������
isMain
--����������� ����������
isOfficial
--����� ������������ 	
StorageLineId
StorageLineCode
StorageLinename
--������� �������������
Member_ReferId
Member_ReferCode
Member_Refername
--������� ����������
Member_MentorId
Member_MentorCode
Member_Mentorname
--������� ����������
ReasonOutId
ReasonOutCode
ReasonOutname
--��������� ����������(�������) 	
PersonalServiceListId
PersonalServiceListName
--��������� ����������(��)
PersonalServiceListOfficialId
PersonalServiceListOfficialName
--��������� ����������(����� ����� �2)
ServiceListId_AvanceF2
ServiceListName_AvanceF2
--��������� ����������(����� �2)
PersonalServiceListCardSecondId
PersonalServiceListCardSecondName         
--����� ������ (������ ������ �.��.)
SheetWorkTimeId
SheetWorkTimeName
--��� 1�
Code1C
--����������
Comment
--����
isIrna

*/

CREATE OR REPLACE VIEW _bi_Guide_Personal_View
AS
       SELECT
             Object_Personal.Id         AS Id
           , Object_Personal.ObjectCode AS Code
           , Object_Personal.ValueData  AS Name
             -- ������� "������ ��/���"
           , Object_Personal.isErased   AS isErased
           --��� ����
           , Object_Member.Id AS MemberId
             --������ ���������
           , Object_Personal.AccesskeyId
           --���������
           , Object_Position.Id              AS PositionId
           , Object_Position.ObjectCode      AS PositionCode
           , Object_Position.ValueData       AS Positionname
           --������ ���������
           , Object_Positionlevel.Id         AS PositionlevelId
           , Object_Positionlevel.ObjectCode AS PositionlevelCode
           , Object_Positionlevel.ValueData  AS Positionlevelname
           -- �������������  - ������
           , Object_Branch.Id                AS BranchId
           , Object_Branch.ObjectCode        AS BranchCode
           , Object_Branch.ValueData         AS Branchname
           --�������������
           , Object_Unit.Id                  AS UnitId
           , Object_Unit.ObjectCode          AS UnitCode
           , Object_Unit.ValueData           AS Unitname
           --����������� �����������
           , Object_PersonalGroup.Id         AS PersonalGroupId
           , Object_PersonalGroup.ObjectCode AS PersonalGroupCode
           , Object_PersonalGroup.ValueData  AS PersonalGroupname
           --���� ������
           , ObjectDate_DateIn.ValueData     AS DateIn
           --���� ����������
           , ObjectDate_Dateout.ValueData    AS Dateout
           --���� ��������
           , ObjectDate_send.ValueData       AS Datesend
  
           , CASE
                 WHEN COALESCE(ObjectDate_Dateout.ValueData, zc_Dateend())::timestamp with time zone = zc_Dateend()::timestamp with time zone OR Object_Personal.iserased = true THEN NULL::timestamp with time zone
                 ELSE ObjectDate_Dateout.ValueData::timestamp with time zone
             END::tDatetime AS Dateout_user
           , CASE
                 WHEN COALESCE(ObjectDate_Dateout.ValueData, zc_Dateend())::timestamp with time zone = zc_Dateend()::timestamp with time zone THEN false
                 ELSE true
             END AS isDateout
           --�������� ����� ������
           , COALESCE(Objectboolean_Main.ValueData, false)     AS isMain
           --����������� ����������
           , COALESCE(Objectboolean_Official.ValueData, false) AS isOfficial
           --����� ������������ 	
           , Object_storageline.Id              AS StorageLineId
           , Object_StorageLine.ObjectCode      AS StorageLineCode
           , Object_StorageLine.ValueData       AS StorageLinename
           --������� �������������
           , Object_Member_refer.Id             AS Member_ReferId
           , Object_Member_refer.ObjectCode     AS Member_ReferCode
           , Object_Member_refer.ValueData      AS Member_Refername
           --������� ����������
           , Object_Member_mentor.Id            AS Member_MentorId
           , Object_Member_mentor.ObjectCode    AS Member_MentorCode
           , Object_Member_mentor.ValueData     AS Member_Mentorname
           --������� ����������
           , Object_ReasonOut.Id                AS ReasonOutId
           , Object_ReasonOut.ObjectCode        AS ReasonOutCode
           , Object_ReasonOut.ValueData         AS ReasonOutname
           --��������� ����������(�������) 	
           , Object_PersonalServiceList.Id           AS PersonalServiceListId
           , Object_PersonalServiceList.ValueData    AS PersonalServiceListName
           --��������� ����������(��)
           , Object_PersonalServiceListOfficial.Id           AS PersonalServiceListOfficialId
           , Object_PersonalServiceListOfficial.ValueData    AS PersonalServiceListOfficialName
           --��������� ����������(����� ����� �2)
           , Object_PersonalServiceListAvance_F2.Id           AS ServiceListId_AvanceF2
           , Object_PersonalServiceListAvance_F2.ValueData    AS ServiceListName_AvanceF2
           --��������� ����������(����� �2)
           , Object_PersonalServiceListCardSecond.Id          AS PersonalServiceListCardSecondId
           , Object_PersonalServiceListCardSecond.ValueData   AS PersonalServiceListCardSecondName         
           --����� ������ (������ ������ �.��.)
           , Object_SheetWorkTime.Id                          AS SheetWorkTimeId
           , Object_SheetWorkTime.ValueData    ::TVarChar     AS SheetWorkTimeName
  
           --��� 1�
           , ObjectString_Code1C.ValueData ::TVarChar AS Code1C
           --����������
           , Objectstring_comment.ValueData     AS comment
           --����
           , COALESCE (ObjectBoolean_Guide_Irna.ValueData, FALSE)   :: Boolean AS isIrna
           , CASE
                 WHEN COALESCE(ObjectDate_send.ValueData, zc_Dateend())::timestamp with time zone = zc_Dateend()::timestamp with time zone THEN false
                 ELSE true
             END AS isDatesend           
       FROM Object AS Object_Personal
         --���.����
         LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                              ON ObjectLink_Personal_Member.ObjectId = Object_Personal.Id
                             AND ObjectLink_Personal_Member.descId = zc_ObjectLink_Personal_Member()
         LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_Personal_Member.ChildObjectId
         --���������
         LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                              ON ObjectLink_Personal_Position.ObjectId = Object_Personal.Id
                             AND ObjectLink_Personal_Position.descId = zc_ObjectLink_Personal_Position()
         LEFT JOIN Object Object_Position ON Object_Position.Id = ObjectLink_Personal_Position.ChildObjectId
         --������ ���������
         LEFT JOIN ObjectLink AS ObjectLink_Personal_Positionlevel
                              ON ObjectLink_Personal_Positionlevel.ObjectId = Object_Personal.Id
                             AND ObjectLink_Personal_Positionlevel.descId = zc_ObjectLink_Personal_Positionlevel()
         LEFT JOIN Object AS Object_Positionlevel ON Object_Positionlevel.Id = ObjectLink_Personal_Positionlevel.ChildObjectId
         --�������������
         LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                              ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                             AND ObjectLink_Personal_Unit.descId = zc_ObjectLink_Personal_Unit()
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Personal_Unit.ChildObjectId
         -- �������������  - ������
         LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                              ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                             AND ObjectLink_Unit_Branch.descId = zc_ObjectLink_Unit_Branch()
         LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId
         --����������� �����������
         LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                              ON ObjectLink_Personal_PersonalGroup.ObjectId = Object_Personal.Id
                             AND ObjectLink_Personal_PersonalGroup.descId = zc_ObjectLink_Personal_PersonalGroup()
         LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = ObjectLink_Personal_PersonalGroup.ChildObjectId
         --����� ������������ 	
         LEFT JOIN ObjectLink AS ObjectLink_Personal_storageline
                              ON ObjectLink_Personal_storageline.ObjectId = Object_Personal.Id
                             AND ObjectLink_Personal_storageline.descId = zc_ObjectLink_Personal_storageline()
         LEFT JOIN Object AS Object_storageline ON Object_storageline.Id = ObjectLink_Personal_storageline.ChildObjectId
         --������� �������������
         LEFT JOIN ObjectLink AS ObjectLink_Personal_Member_refer
                              ON ObjectLink_Personal_Member_refer.ObjectId = Object_Personal.Id
                             AND ObjectLink_Personal_Member_refer.descId = zc_ObjectLink_Personal_Member_refer()
         LEFT JOIN Object AS Object_Member_refer ON Object_Member_refer.Id = ObjectLink_Personal_Member_refer.ChildObjectId
         --������� ����������
         LEFT JOIN ObjectLink AS ObjectLink_Personal_Member_mentor
                              ON ObjectLink_Personal_Member_mentor.ObjectId = Object_Personal.Id
                             AND ObjectLink_Personal_Member_mentor.descId = zc_ObjectLink_Personal_Member_mentor()
         LEFT JOIN Object AS Object_Member_mentor ON Object_Member_mentor.Id = ObjectLink_Personal_Member_mentor.ChildObjectId
         --������� ����������
         LEFT JOIN ObjectLink AS ObjectLink_Personal_ReasonOut
                              ON ObjectLink_Personal_ReasonOut.ObjectId = Object_Personal.Id
                             AND ObjectLink_Personal_ReasonOut.descId = zc_ObjectLink_Personal_ReasonOut()
         LEFT JOIN Object AS Object_ReasonOut ON Object_ReasonOut.Id = ObjectLink_Personal_ReasonOut.ChildObjectId
         --����� ������ (������ ������ �.��.)
         LEFT JOIN ObjectLink AS ObjectLink_Personal_SheetWorkTime
                              ON ObjectLink_Personal_SheetWorkTime.ObjectId = Object_Personal.Id
                             AND ObjectLink_Personal_SheetWorkTime.DescId = zc_ObjectLink_Personal_SheetWorkTime()
         LEFT JOIN Object AS Object_SheetWorkTime ON Object_SheetWorkTime.Id = ObjectLink_Personal_SheetWorkTime.ChildObjectId
         --��������� ����������(�������)
         LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                              ON ObjectLink_Personal_PersonalServiceList.ObjectId = Object_Personal.Id
                             AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
         LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = ObjectLink_Personal_PersonalServiceList.ChildObjectId
         --��������� ����������(��)
         LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceListOfficial
                              ON ObjectLink_Personal_PersonalServiceListOfficial.ObjectId = Object_Personal.Id
                             AND ObjectLink_Personal_PersonalServiceListOfficial.DescId = zc_ObjectLink_Personal_PersonalServiceListOfficial()
         LEFT JOIN Object AS Object_PersonalServiceListOfficial ON Object_PersonalServiceListOfficial.Id = ObjectLink_Personal_PersonalServiceListOfficial.ChildObjectId
         --��������� ����������(����� �2)
         LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceListCardSecond
                              ON ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId = Object_Personal.Id
                             AND ObjectLink_Personal_PersonalServiceListCardSecond.DescId = zc_ObjectLink_Personal_PersonalServiceListCardSecond()
         LEFT JOIN Object AS Object_PersonalServiceListCardSecond ON Object_PersonalServiceListCardSecond.Id = ObjectLink_Personal_PersonalServiceListCardSecond.ChildObjectId
         --��������� ����������(����� ����� �2)
         LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Avance_F2
                              ON ObjectLink_PersonalServiceList_Avance_F2.ObjectId = Object_Personal.Id
                             AND ObjectLink_PersonalServiceList_Avance_F2.DescId = zc_ObjectLink_Personal_PersonalServiceListAvance_F2()
         LEFT JOIN Object AS Object_PersonalServiceListAvance_F2 ON Object_PersonalServiceListAvance_F2.Id = ObjectLink_PersonalServiceList_Avance_F2.ChildObjectId

         --���� ������
         LEFT JOIN ObjectDate AS ObjectDate_DateIn 
                              ON ObjectDate_DateIn.ObjectId = Object_Personal.Id
                             AND ObjectDate_DateIn.descId = zc_ObjectDate_Personal_in()
         --���� ����������
         LEFT JOIN ObjectDate AS ObjectDate_Dateout 
                              ON ObjectDate_Dateout.ObjectId = Object_Personal.Id
                             AND ObjectDate_Dateout.descId = zc_ObjectDate_Personal_out()
         --���� ��������
         LEFT JOIN ObjectDate AS ObjectDate_send
                              ON ObjectDate_send.ObjectId = Object_Personal.Id
                             AND ObjectDate_send.descId = zc_ObjectDate_Personal_send()
         --�������� ����� ������
         LEFT JOIN Objectboolean AS Objectboolean_main
                                 ON Objectboolean_main.ObjectId = Object_Personal.Id
                                AND Objectboolean_main.descId = zc_Objectboolean_Personal_main()
         --����������� ����������
         LEFT JOIN Objectboolean AS Objectboolean_official
                                 ON Objectboolean_official.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                AND Objectboolean_official.descId = zc_Objectboolean_Member_official()
         --����
         LEFT JOIN ObjectBoolean AS ObjectBoolean_Guide_Irna
                                 ON ObjectBoolean_Guide_Irna.ObjectId = Object_Personal.Id
                                AND ObjectBoolean_Guide_Irna.DescId = zc_ObjectBoolean_Guide_Irna()
         --����������
         LEFT JOIN Objectstring AS Objectstring_comment
                                ON Objectstring_comment.ObjectId = Object_Personal.Id
                               AND Objectstring_comment.descId = zc_Objectstring_Personal_comment()
         --��� 1�
         LEFT JOIN ObjectString AS ObjectString_Code1C
                                ON ObjectString_Code1C.ObjectId = Object_Personal.Id
                               AND ObjectString_Code1C.DescId = zc_ObjectString_Personal_Code1C()

       WHERE Object_Personal.DescId = zc_Object_Personal()
      ;

ALTER TABLE _bi_GuIde_Personal_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.05.25         * all
 09.05.25                                        *
*/

-- ����
-- SELECT * FROM _bi_GuIde_Personal_View