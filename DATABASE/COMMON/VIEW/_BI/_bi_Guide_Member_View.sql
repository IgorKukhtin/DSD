-- View: _bi_Guide_Member_View

 DROP VIEW IF EXISTS _bi_Guide_Member_View;

-- ���������� ���.����
CREATE OR REPLACE VIEW _bi_Guide_Member_View
AS
WITH tmpPersonal AS (SELECT lfSelect.MemberId
                                , lfSelect.PersonalId
                                , lfSelect.UnitId
                                , lfSelect.PositionId
                                , lfSelect.PositionLevelId
                                , lfSelect.BranchId
                                , lfSelect.DateIn
                                , lfSelect.DateOut
                                , lfSelect.isDateOut
                                , lfSelect.Ord
                           FROM lfSelect_Object_Member_findPersonal (zfCalc_UserAdmin()) AS lfSelect
                           WHERE lfSelect.Ord = 1
                          )


       SELECT
             Object_Member.Id         AS Id
           , Object_Member.ObjectCode AS Code
           , Object_Member.ValueData  AS Name
             -- ������� "������ ��/���"
           , Object_Member.isErased   AS isErased

         --��� 1�
         , ObjectString_Code1C.ValueData ::TVarChar AS Code1C
         --���
         , ObjectString_INN.ValueData               AS INN
         --������������ �������������
         , ObjectString_DriverCertificate.ValueData AS DriverCertificate
         --� ���������� ����� �� - ������ �����
         , ObjectString_Card.ValueData              AS Card
         --� ���������� ����� �� - �2(������)
         , ObjectString_CardSecond.ValueData        AS CardSecond
         --� ���������� ����� �� - �������� (���������)
         , ObjectString_CardChild.ValueData         AS CardChild
         --� ���������� ����� IBAN �� - ������ �����
         , ObjectString_CardIBAN.ValueData          AS CardIBAN
         --� ���������� IBAN����� �� - �2(������)
         , ObjectString_CardIBANSecond.ValueData    AS CardIBANSecond
         --����� ���������� �������� �� �1
         , ObjectString_CardBank.ValueData          AS CardBank
         --����� ���������� �������� �� - �2(������)
         , ObjectString_CardBankSecond.ValueData    AS CardBankSecond 
         --����� ���������� �������� �� - �2(���)    
         , ObjectString_CardBankSecondTwo.ValueData    AS CardBankSecondTwo
         --� ���������� IBAN����� �� - �2(���)
         , ObjectString_CardIBANSecondTwo.ValueData    AS CardIBANSecondTwo
         --� ���������� ����� �� - �2(���) 
         , ObjectString_CardSecondTwo.ValueData        AS CardSecondTwo
         --����� ���������� �������� �� - �2(������)
         , ObjectString_CardBankSecondDiff.ValueData   AS CardBankSecondDiff
         --� ���������� IBAN����� �� - �2(������)
         , ObjectString_CardIBANSecondDiff.ValueData   AS CardIBANSecondDiff
         --� ���������� ����� �� - �2(������) 
         , ObjectString_CardSecondDiff.ValueData       AS CardSecondDiff
         --����������    
         , ObjectString_Comment.ValueData              AS Comment

         --��������� �� ����������� �������
         , COALESCE (ObjectBoolean_NotCompensation.ValueData, FALSE) :: Boolean  AS isNotCompensation
         --Bank - �� �1
         , Object_Bank.Id               AS BankId
         , Object_Bank.ValueData        AS BankName
         --Bank - �2(������)
         , Object_BankSecond.Id         AS BankSecondId
         , Object_BankSecond.ValueData  AS BankSecondName
         --Bank - �������� (���������)
         , Object_BankChild.Id          AS BankChildId
         , Object_BankChild.ValueData   AS BankChildName
         --Bank - �2(���)
         , Object_BankSecondTwo.Id          AS BankSecondTwoId
         , Object_BankSecondTwo.ValueData   AS BankSecondTwoName
         --Bank - �2(������)
         , Object_BankSecondDiff.Id         AS BankSecondDiffId
         , Object_BankSecondDiff.ValueData  AS BankSecondDiffName
         --������ ����������
         , Object_InfoMoney_View.InfoMoneyId
         , Object_InfoMoney_View.InfoMoneyCode
         , Object_InfoMoney_View.InfoMoneyName
         , Object_InfoMoney_View.InfoMoneyName_all
         -- ��������� ���� ��� ����� ���� ����
         , COALESCE(ObjectDate_StartSummer.ValueData, Null)  ::TDateTime  AS StartSummerDate
         --�������� ���� ��� ����� ���� ����
         , COALESCE(ObjectDate_EndSummer.ValueData, Null)    ::TDateTime  AS EndSummerDate
         --����� ���� ����� ����
         , COALESCE(ObjectFloat_SummerFuel.ValueData, 0) ::TFloat  AS SummerFuel
         --����� ���� ����� ����
         , COALESCE(ObjectFloat_WinterFuel.ValueData, 0) ::TFloat  AS WinterFuel
         --����������� �� 1 ��., ���.
         , COALESCE(ObjectFloat_Reparation.ValueData, 0) ::TFloat  AS Reparation
         --����� ���
         , COALESCE(ObjectFloat_Limit.ValueData, 0)         ::TFloat   AS LimitMoney
         --����� ��
         , COALESCE(ObjectFloat_LimitDistance.ValueData, 0) ::TFloat   AS LimitDistance

         --������������ �� �������� ����� - ������
         , Object_Branch.Id           AS BranchId
         , Object_Branch.ObjectCode   AS BranchCode
         , Object_Branch.ValueData    AS BranchName
         --������������ �� �������� ����� - �������������
         , Object_Unit.Id             AS UnitId
         , Object_Unit.ObjectCode     AS UnitCode
         , Object_Unit.ValueData      AS UnitName 
         --������������ �� �������� ����� - ���������
         , Object_Position.Id         AS PositionId
         , Object_Position.ObjectCode AS PositionCode
         , Object_Position.ValueData  AS PositionName 
         --������������ �� �������� ����� - ������
         , Object_PositionLevel.Id         AS PositionLevelId
         , Object_PositionLevel.ObjectCode AS PositionLevelCode
         , Object_PositionLevel.ValueData  AS PositionLevelName
         --������������ �� �������� ����� - ������ ��/���
         , tmpPersonal.isDateOut :: Boolean AS isDateOut
         --������������ �� �������� ����� - ���� ��������
         , tmpPersonal.DateIn
         --������������ �� �������� ����� - ���� ����������
         , tmpPersonal.DateOut
         --������������ �� �������� ����� - ���������
         , tmpPersonal.PersonalId
         
         
         --�������������(������ ���������)
         , Object_UnitMobile.Id         AS UnitMobileId
         , Object_UnitMobile.ObjectCode AS UnitMobileCode
         , Object_UnitMobile.ValueData  AS UnitMobileName

         ----����������/ �������������/����������  - �� ���� "�����������" ������� � "������ � ��" ��� � "��������� �����" 
         , ObjectTo.Id                AS ObjectToId
         , ObjectTo.ValueData         AS ObjectToName
         , ObjectDesc.ItemName        AS DescName

         --���
         , Object_Gender.Id              AS GenderId
         , Object_Gender.ValueData       AS GenderName
         --������������ 
         , Object_MemberSkill.Id         AS MemberSkillId
         , Object_MemberSkill.ValueData  AS MemberSkillName
         --�������� ���������� � ��������
         , Object_JobSource.Id           AS JobSourceId
         , Object_JobSource.ValueData    AS JobSourceName 
         --�������, ����� ��������
         , Object_Region.Id              AS RegionId
         , Object_Region.ValueData       AS RegionName
         --�������, ����� ����������
         , Object_Region_Real.Id         AS RegionId_Real
         , Object_Region_Real.ValueData  AS RegionName_Real
         --�����/����/���, ����� ��������
         , Object_City.Id                AS CityId
         , Object_City.ValueData         AS CityName
         --�����/����/���, ����� ����������
         , Object_City_Real.Id           AS CityId_Real
         , Object_City_Real.ValueData    AS CityName_Real
         --�����, ����� ����, ����� ��������, ����� ��������
         , ObjectString_Street.ValueData               AS Street
         , ObjectString_Street_Real.ValueData          AS Street_Real

         --���������
         , Object_RouteNum.Id            AS RouteNumId
         , Object_RouteNum.ValueData     AS RouteNumName
         --�������, ���� ��������
         , COALESCE(ObjectDate_Birthday.ValueData, Null)   ::TDateTime  AS Birthday_Date
         --������� 1, ���� ��������
         , COALESCE(ObjectDate_Children1.ValueData, Null)  ::TDateTime  AS Children1_Date
         --������� 2, ���� ��������
         , COALESCE(ObjectDate_Children2.ValueData, Null)  ::TDateTime  AS Children2_Date
         --������� 3, ���� ��������
         , COALESCE(ObjectDate_Children3.ValueData, Null)  ::TDateTime  AS Children3_Date
         --������� 4, ���� ��������
         , COALESCE(ObjectDate_Children4.ValueData, Null)  ::TDateTime  AS Children4_Date
         --������� 5, ���� ��������
         , COALESCE(ObjectDate_Children5.ValueData, Null)  ::TDateTime  AS Children5_Date
         --�������, ���� �������� �
         , COALESCE(ObjectDate_PSP_Start.ValueData, Null)  ::TDateTime  AS PSP_StartDate
         --�������, ���� �������� ��
         , COALESCE(ObjectDate_PSP_End.ValueData, Null)    ::TDateTime  AS PSP_EndDate
         --������ �
         , COALESCE(ObjectDate_Dekret_Start.ValueData, Null)  ::TDateTime  AS Dekret_StartDate
         --������ ��
         , COALESCE(ObjectDate_Dekret_End.ValueData, Null)    ::TDateTime  AS Dekret_EndDate
         --������� 1, ���
         , ObjectString_Children1.ValueData            AS Children1
         --������� 2, ���
         , ObjectString_Children2.ValueData            AS Children2
         --������� 3, ���
         , ObjectString_Children3.ValueData            AS Children3
         --������� 4, ���
         , ObjectString_Children4.ValueData            AS Children4
         --������� 5, ���
         , ObjectString_Children5.ValueData            AS Children5
         --���������
         , ObjectString_Law.ValueData                  AS Law
         --������������ ������������� ��� �������� ���� � �.�.
         , ObjectString_DriverCertificateAdd.ValueData AS DriverCertificateAdd
         --�������, �����
         , ObjectString_PSP_S.ValueData                AS PSP_S
         --�������, �����
         , ObjectString_PSP_N.ValueData                AS PSP_N
         --�������, ��� �����
         , ObjectString_PSP_W.ValueData                AS PSP_W
         --�������, ���� ������
         , ObjectString_PSP_D.ValueData                AS PSP_D
         --GLN
         , ObjectString_GLN.ValueData      :: TVarChar AS GLN  
         --E-Mail
         , ObjectString_EMail.ValueData    :: TVarChar AS EMail
         --Phone
         , ObjectString_Phone.ValueData    :: TVarChar AS Phone
     FROM Object AS Object_Member
          --��������� �� ����������� �������
          LEFT JOIN ObjectBoolean AS ObjectBoolean_NotCompensation
                                  ON ObjectBoolean_NotCompensation.ObjectId = Object_Member.Id
                                 AND ObjectBoolean_NotCompensation.DescId = zc_ObjectBoolean_Member_NotCompensation()
          --���
          LEFT JOIN ObjectString AS ObjectString_INN
                                 ON ObjectString_INN.ObjectId = Object_Member.Id
                                AND ObjectString_INN.DescId = zc_ObjectString_Member_INN()
          --� ���������� ����� �� - ������ �����
          LEFT JOIN ObjectString AS ObjectString_Card
                                 ON ObjectString_Card.ObjectId = Object_Member.Id
                                AND ObjectString_Card.DescId = zc_ObjectString_Member_Card()
          --� ���������� ����� �� - �2(������)
          LEFT JOIN ObjectString AS ObjectString_CardSecond
                                 ON ObjectString_CardSecond.ObjectId = Object_Member.Id
                                AND ObjectString_CardSecond.DescId = zc_ObjectString_Member_CardSecond()
          --� ���������� ����� �� - �������� (���������)
          LEFT JOIN ObjectString AS ObjectString_CardChild
                                 ON ObjectString_CardChild.ObjectId = Object_Member.Id
                                AND ObjectString_CardChild.DescId = zc_ObjectString_Member_CardChild()
          --� ���������� ����� IBAN �� - ������ �����
          LEFT JOIN ObjectString AS ObjectString_CardIBAN
                                 ON ObjectString_CardIBAN.ObjectId = Object_Member.Id 
                                AND ObjectString_CardIBAN.DescId = zc_ObjectString_Member_CardIBAN()
          --� ���������� IBAN����� �� - �2(������)
          LEFT JOIN ObjectString AS ObjectString_CardIBANSecond
                                 ON ObjectString_CardIBANSecond.ObjectId = Object_Member.Id 
                                AND ObjectString_CardIBANSecond.DescId = zc_ObjectString_Member_CardIBANSecond()
          --����� ���������� �������� �� �1
          LEFT JOIN ObjectString AS ObjectString_CardBank
                                 ON ObjectString_CardBank.ObjectId = Object_Member.Id 
                                AND ObjectString_CardBank.DescId = zc_ObjectString_Member_CardBank()
          --����� ���������� �������� �� - �2(������)
          LEFT JOIN ObjectString AS ObjectString_CardBankSecond
                                 ON ObjectString_CardBankSecond.ObjectId = Object_Member.Id 
                                AND ObjectString_CardBankSecond.DescId = zc_ObjectString_Member_CardBankSecond()
          --������������ �������������
          LEFT JOIN ObjectString AS ObjectString_DriverCertificate
                                 ON ObjectString_DriverCertificate.ObjectId = Object_Member.Id
                                AND ObjectString_DriverCertificate.DescId = zc_ObjectString_Member_DriverCertificate()
          --����� ���������� �������� �� - �2(���)
          LEFT JOIN ObjectString AS ObjectString_CardBankSecondTwo
                                 ON ObjectString_CardBankSecondTwo.ObjectId = Object_Member.Id 
                                AND ObjectString_CardBankSecondTwo.DescId = zc_ObjectString_Member_CardBankSecondTwo()
          --� ���������� IBAN����� �� - �2(���)
          LEFT JOIN ObjectString AS ObjectString_CardIBANSecondTwo
                                 ON ObjectString_CardIBANSecondTwo.ObjectId = Object_Member.Id 
                                AND ObjectString_CardIBANSecondTwo.DescId = zc_ObjectString_Member_CardIBANSecondTwo()
          LEFT JOIN ObjectString AS ObjectString_CardSecondTwo
                                 ON ObjectString_CardSecondTwo.ObjectId = Object_Member.Id 
                                AND ObjectString_CardSecondTwo.DescId = zc_ObjectString_Member_CardSecondTwo()
          --����� ���������� �������� �� - �2(������)
          LEFT JOIN ObjectString AS ObjectString_CardBankSecondDiff
                                 ON ObjectString_CardBankSecondDiff.ObjectId = Object_Member.Id 
                                AND ObjectString_CardBankSecondDiff.DescId = zc_ObjectString_Member_CardBankSecondDiff()
          --� ���������� IBAN����� �� - �2(������)
          LEFT JOIN ObjectString AS ObjectString_CardIBANSecondDiff
                                 ON ObjectString_CardIBANSecondDiff.ObjectId = Object_Member.Id 
                                AND ObjectString_CardIBANSecondDiff.DescId = zc_ObjectString_Member_CardIBANSecondDiff()
          --� ���������� ����� �� - �2(������) 
          LEFT JOIN ObjectString AS ObjectString_CardSecondDiff
                                 ON ObjectString_CardSecondDiff.ObjectId = Object_Member.Id 
                                AND ObjectString_CardSecondDiff.DescId = zc_ObjectString_Member_CardSecondDiff()
          --��� 1�
          LEFT JOIN ObjectString AS ObjectString_Code1C
                                 ON ObjectString_Code1C.ObjectId = Object_Member.Id
                                AND ObjectString_Code1C.DescId = zc_ObjectString_Member_Code1C()
          --����������
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_Member.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_Member_Comment() 
          --E-Mail
          LEFT JOIN ObjectString AS ObjectString_EMail
                                 ON ObjectString_EMail.ObjectId = Object_Member.Id
                                AND ObjectString_EMail.DescId = zc_ObjectString_Member_EMail()

         --������ ����������
         LEFT JOIN ObjectLink AS ObjectLink_Member_InfoMoney
                              ON ObjectLink_Member_InfoMoney.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_InfoMoney.DescId = zc_ObjectLink_Member_InfoMoney()
         LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Member_InfoMoney.ChildObjectId
         --����������/ �������������/����������  - �� ���� "�����������" ������� � "������ � ��" ��� � "��������� �����" 
         LEFT JOIN ObjectLink AS ObjectLink_Member_ObjectTo
                              ON ObjectLink_Member_ObjectTo.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_ObjectTo.DescId = zc_ObjectLink_Member_ObjectTo()
         LEFT JOIN Object AS ObjectTo ON ObjectTo.Id = ObjectLink_Member_ObjectTo.ChildObjectId
         LEFT JOIN ObjectDesc ON ObjectDesc.Id = ObjectTo.DescId
         --���
         LEFT JOIN ObjectLink AS ObjectLink_Member_Gender
                              ON ObjectLink_Member_Gender.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_Gender.DescId = zc_ObjectLink_Member_Gender()
         LEFT JOIN Object AS Object_Gender ON Object_Gender.Id = ObjectLink_Member_Gender.ChildObjectId
         --������������
         LEFT JOIN ObjectLink AS ObjectLink_Member_MemberSkill
                              ON ObjectLink_Member_MemberSkill.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_MemberSkill.DescId = zc_ObjectLink_Member_MemberSkill()
         LEFT JOIN Object AS Object_MemberSkill ON Object_MemberSkill.Id = ObjectLink_Member_MemberSkill.ChildObjectId
         --�������� ���������� � ��������
         LEFT JOIN ObjectLink AS ObjectLink_Member_JobSource
                              ON ObjectLink_Member_JobSource.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_JobSource.DescId = zc_ObjectLink_Member_JobSource()
         LEFT JOIN Object AS Object_JobSource ON Object_JobSource.Id = ObjectLink_Member_JobSource.ChildObjectId
         --�������, ����� ��������
         LEFT JOIN ObjectLink AS ObjectLink_Member_Region
                              ON ObjectLink_Member_Region.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_Region.DescId = zc_ObjectLink_Member_Region()
         LEFT JOIN Object AS Object_Region ON Object_Region.Id = ObjectLink_Member_Region.ChildObjectId
         --�����/����/���, ����� ��������
         LEFT JOIN ObjectLink AS ObjectLink_Member_City
                              ON ObjectLink_Member_City.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_City.DescId = zc_ObjectLink_Member_City()
         LEFT JOIN Object AS Object_City ON Object_City.Id = ObjectLink_Member_City.ChildObjectId
         ----�������, ����� ����������
         LEFT JOIN ObjectLink AS ObjectLink_Member_Region_Real
                              ON ObjectLink_Member_Region_Real.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_Region_Real.DescId = zc_ObjectLink_Member_Region_Real()
         LEFT JOIN Object AS Object_Region_Real ON Object_Region_Real.Id = ObjectLink_Member_Region_Real.ChildObjectId
         --�����/����/���, ����� ����������
         LEFT JOIN ObjectLink AS ObjectLink_Member_City_Real
                              ON ObjectLink_Member_City_Real.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_City_Real.DescId = zc_ObjectLink_Member_City_Real()
         LEFT JOIN Object AS Object_City_Real ON Object_City_Real.Id = ObjectLink_Member_City_Real.ChildObjectId
         --���������
         LEFT JOIN ObjectLink AS ObjectLink_Member_RouteNum
                              ON ObjectLink_Member_RouteNum.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_RouteNum.DescId = zc_ObjectLink_Member_RouteNum()
         LEFT JOIN Object AS Object_RouteNum ON Object_RouteNum.Id = ObjectLink_Member_RouteNum.ChildObjectId
         -- ��������� ���� ��� ����� ���� ����
         LEFT JOIN ObjectDate AS ObjectDate_StartSummer
                              ON ObjectDate_StartSummer.ObjectId = Object_Member.Id
                             AND ObjectDate_StartSummer.DescId = zc_ObjectDate_Member_StartSummer()
         --�������� ���� ��� ����� ���� ����
         LEFT JOIN ObjectDate AS ObjectDate_EndSummer
                              ON ObjectDate_EndSummer.ObjectId = Object_Member.Id
                             AND ObjectDate_EndSummer.DescId = zc_ObjectDate_Member_EndSummer()
         --�������, ���� ��������
         LEFT JOIN ObjectDate AS ObjectDate_Birthday
                              ON ObjectDate_Birthday.ObjectId = Object_Member.Id
                             AND ObjectDate_Birthday.DescId = zc_ObjectDate_Member_Birthday()
         --������� 1, ���� ��������
         LEFT JOIN ObjectDate AS ObjectDate_Children1
                              ON ObjectDate_Children1.ObjectId = Object_Member.Id
                             AND ObjectDate_Children1.DescId = zc_ObjectDate_Member_Children1()
         --������� 2, ���� ��������
         LEFT JOIN ObjectDate AS ObjectDate_Children2
                              ON ObjectDate_Children2.ObjectId = Object_Member.Id
                             AND ObjectDate_Children2.DescId = zc_ObjectDate_Member_Children2()
         --������� 3, ���� ��������
         LEFT JOIN ObjectDate AS ObjectDate_Children3
                              ON ObjectDate_Children3.ObjectId = Object_Member.Id
                             AND ObjectDate_Children3.DescId = zc_ObjectDate_Member_Children3()
         --������� 4, ���� ��������
         LEFT JOIN ObjectDate AS ObjectDate_Children4
                              ON ObjectDate_Children4.ObjectId = Object_Member.Id
                             AND ObjectDate_Children4.DescId = zc_ObjectDate_Member_Children4()
         --������� 5, ���� ��������
         LEFT JOIN ObjectDate AS ObjectDate_Children5
                              ON ObjectDate_Children5.ObjectId = Object_Member.Id
                             AND ObjectDate_Children5.DescId = zc_ObjectDate_Member_Children5()
         --�������, ���� �������� �
         LEFT JOIN ObjectDate AS ObjectDate_PSP_Start
                              ON ObjectDate_PSP_Start.ObjectId = Object_Member.Id
                             AND ObjectDate_PSP_Start.DescId = zc_ObjectDate_Member_PSP_Start()
         --�������, ���� �������� ��
         LEFT JOIN ObjectDate AS ObjectDate_PSP_End
                              ON ObjectDate_PSP_End.ObjectId = Object_Member.Id
                             AND ObjectDate_PSP_End.DescId = zc_ObjectDate_Member_PSP_End()
         --������ �
         LEFT JOIN ObjectDate AS ObjectDate_Dekret_Start
                              ON ObjectDate_Dekret_Start.ObjectId = Object_Member.Id
                             AND ObjectDate_Dekret_Start.DescId = zc_ObjectDate_Member_Dekret_Start()
         --������ �� 
         LEFT JOIN ObjectDate AS ObjectDate_Dekret_End
                              ON ObjectDate_Dekret_End.ObjectId = Object_Member.Id
                             AND ObjectDate_Dekret_End.DescId = zc_ObjectDate_Member_Dekret_End()
         --�����, ����� ����, ����� ��������, ����� ��������
         LEFT JOIN ObjectString AS ObjectString_Street
                                ON ObjectString_Street.ObjectId = Object_Member.Id
                               AND ObjectString_Street.DescId = zc_ObjectString_Member_Street()
         --�����, ����� ����, ����� ��������, ����� ����������
         LEFT JOIN ObjectString AS ObjectString_Street_Real
                                ON ObjectString_Street_Real.ObjectId = Object_Member.Id
                               AND ObjectString_Street_Real.DescId = zc_ObjectString_Member_Street_Real()
         --������� 1, ���
         LEFT JOIN ObjectString AS ObjectString_Children1
                                ON ObjectString_Children1.ObjectId = Object_Member.Id
                               AND ObjectString_Children1.DescId = zc_ObjectString_Member_Children1()
         --������� 2, ���
         LEFT JOIN ObjectString AS ObjectString_Children2
                                ON ObjectString_Children2.ObjectId = Object_Member.Id
                               AND ObjectString_Children2.DescId = zc_ObjectString_Member_Children2()
         --������� 3, ���
         LEFT JOIN ObjectString AS ObjectString_Children3
                                ON ObjectString_Children3.ObjectId = Object_Member.Id
                               AND ObjectString_Children3.DescId = zc_ObjectString_Member_Children3()
         --������� 4, ���
         LEFT JOIN ObjectString AS ObjectString_Children4
                                ON ObjectString_Children4.ObjectId = Object_Member.Id
                               AND ObjectString_Children4.DescId = zc_ObjectString_Member_Children4()
         --������� 5, ���
         LEFT JOIN ObjectString AS ObjectString_Children5
                                ON ObjectString_Children5.ObjectId = Object_Member.Id
                               AND ObjectString_Children5.DescId = zc_ObjectString_Member_Children5()
         --���������
         LEFT JOIN ObjectString AS ObjectString_Law
                                ON ObjectString_Law.ObjectId = Object_Member.Id
                               AND ObjectString_Law.DescId = zc_ObjectString_Member_Law()
         --������������ ������������� ��� �������� ���� � �.�.
         LEFT JOIN ObjectString AS ObjectString_DriverCertificateAdd
                                ON ObjectString_DriverCertificateAdd.ObjectId = Object_Member.Id
                               AND ObjectString_DriverCertificateAdd.DescId = zc_ObjectString_Member_DriverCertificateAdd()
         --�������, �����
         LEFT JOIN ObjectString AS ObjectString_PSP_S
                                ON ObjectString_PSP_S.ObjectId = Object_Member.Id
                               AND ObjectString_PSP_S.DescId = zc_ObjectString_Member_PSP_S()
         --�������, �����
         LEFT JOIN ObjectString AS ObjectString_PSP_N
                                ON ObjectString_PSP_N.ObjectId = Object_Member.Id
                               AND ObjectString_PSP_N.DescId = zc_ObjectString_Member_PSP_N()
         --�������, ��� �����
         LEFT JOIN ObjectString AS ObjectString_PSP_W
                                ON ObjectString_PSP_W.ObjectId = Object_Member.Id
                               AND ObjectString_PSP_W.DescId = zc_ObjectString_Member_PSP_W()
         --�������, ���� ������
         LEFT JOIN ObjectString AS ObjectString_PSP_D
                                ON ObjectString_PSP_D.ObjectId = Object_Member.Id
                               AND ObjectString_PSP_D.DescId = zc_ObjectString_Member_PSP_D()
         --��� GLN
         LEFT JOIN ObjectString AS ObjectString_GLN
                                ON ObjectString_GLN.ObjectId = Object_Member.Id
                               AND ObjectString_GLN.DescId = zc_ObjectString_Member_GLN()
         --Phone
         LEFT JOIN ObjectString AS ObjectString_Phone
                                ON ObjectString_Phone.ObjectId = Object_Member.Id
                               AND ObjectString_Phone.DescId = zc_ObjectString_Member_Phone()
         --����� ���� ����� ����
         LEFT JOIN ObjectFloat AS ObjectFloat_SummerFuel
                               ON ObjectFloat_SummerFuel.ObjectId = Object_Member.Id
                              AND ObjectFloat_SummerFuel.DescId = zc_ObjectFloat_Member_Summer()
         --����� ���� ����� ����
         LEFT JOIN ObjectFloat AS ObjectFloat_WinterFuel
                               ON ObjectFloat_WinterFuel.ObjectId = Object_Member.Id
                              AND ObjectFloat_WinterFuel.DescId = zc_ObjectFloat_Member_Winter()
         --����������� �� 1 ��., ���.
         LEFT JOIN ObjectFloat AS ObjectFloat_Reparation
                               ON ObjectFloat_Reparation.ObjectId = Object_Member.Id
                              AND ObjectFloat_Reparation.DescId = zc_ObjectFloat_Member_Reparation()
         --����� ���
         LEFT JOIN ObjectFloat AS ObjectFloat_Limit
                               ON ObjectFloat_Limit.ObjectId = Object_Member.Id
                              AND ObjectFloat_Limit.DescId = zc_ObjectFloat_Member_Limit()
         -- ����� ��
         LEFT JOIN ObjectFloat AS ObjectFloat_LimitDistance
                               ON ObjectFloat_LimitDistance.ObjectId = Object_Member.Id
                              AND ObjectFloat_LimitDistance.DescId = zc_ObjectFloat_Member_LimitDistance()
         --Bank - �� �1
         LEFT JOIN ObjectLink AS ObjectLink_Member_Bank
                              ON ObjectLink_Member_Bank.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_Bank.DescId = zc_ObjectLink_Member_Bank()
         LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_Member_Bank.ChildObjectId
         --Bank - �2(������)
         LEFT JOIN ObjectLink AS ObjectLink_Member_BankSecond
                              ON ObjectLink_Member_BankSecond.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_BankSecond.DescId = zc_ObjectLink_Member_BankSecond()
         LEFT JOIN Object AS Object_BankSecond ON Object_BankSecond.Id = ObjectLink_Member_BankSecond.ChildObjectId
         --Bank - �������� (���������)
         LEFT JOIN ObjectLink AS ObjectLink_Member_BankChild
                              ON ObjectLink_Member_BankChild.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_BankChild.DescId = zc_ObjectLink_Member_BankChild()
         LEFT JOIN Object AS Object_BankChild ON Object_BankChild.Id = ObjectLink_Member_BankChild.ChildObjectId
         --Bank - �2(���)
         LEFT JOIN ObjectLink AS ObjectLink_Member_BankSecondTwo
                              ON ObjectLink_Member_BankSecondTwo.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_BankSecondTwo.DescId = zc_ObjectLink_Member_BankSecondTwo()
         LEFT JOIN Object AS Object_BankSecondTwo ON Object_BankSecondTwo.Id = ObjectLink_Member_BankSecondTwo.ChildObjectId
         --Bank - �2(������)
         LEFT JOIN ObjectLink AS ObjectLink_Member_BankSecondDiff
                              ON ObjectLink_Member_BankSecondDiff.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_BankSecondDiff.DescId = zc_ObjectLink_Member_BankSecondDiff()
         LEFT JOIN Object AS Object_BankSecondDiff ON Object_BankSecondDiff.Id = ObjectLink_Member_BankSecondDiff.ChildObjectId
         --�������������(������ ���������)
         LEFT JOIN ObjectLink AS ObjectLink_Member_UnitMobile
                              ON ObjectLink_Member_UnitMobile.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_UnitMobile.DescId = zc_ObjectLink_Member_UnitMobile()
         LEFT JOIN Object AS Object_UnitMobile ON Object_UnitMobile.Id = ObjectLink_Member_UnitMobile.ChildObjectId

         LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = Object_Member.Id AND tmpPersonal.Ord = 1
         LEFT JOIN Object AS Object_Branch   ON Object_Branch.Id   = tmpPersonal.BranchId
         LEFT JOIN Object AS Object_Unit     ON Object_Unit.Id     = tmpPersonal.UnitId
         LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
         LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = tmpPersonal.PositionLevelId

       WHERE Object_Member.DescId = zc_Object_Member()
      ;

ALTER TABLE _bi_Guide_Member_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.05.25         * all
 09.05.25                                        *
*/

-- ����
-- SELECT * FROM _bi_Guide_Member_View
