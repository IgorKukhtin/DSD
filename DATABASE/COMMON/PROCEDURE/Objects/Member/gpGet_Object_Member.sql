-- Function: gpGet_Object_Member (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Member (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Member(
    IN inId          Integer,        -- ���������� ���� 
    IN inSession     TVarChar        -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , INN TVarChar, DriverCertificate TVarChar
             , Card TVarChar, CardSecond TVarChar, CardChild TVarChar
             , CardIBAN TVarChar, CardIBANSecond TVarChar
             , Comment TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , BankId Integer, BankName TVarChar
             , BankSecondId Integer, BankSecondName TVarChar
             , BankChildId Integer, BankChildName TVarChar
             , PersonalId Integer
             , UnitId     Integer, UnitName TVarChar
             , PositionId Integer, PositionName TVarChar
             , PersonalServiceListId Integer, PersonalServiceListName TVarChar
             , isOfficial Boolean
             , isNotCompensation Boolean
             , GenderId Integer
             , GenderName TVarChar
             , MemberSkillId Integer
             , MemberSkillName TVarChar
             , JobSourceId Integer
             , JobSourceName TVarChar
             , RegionId Integer
             , RegionName TVarChar
             , RegionId_Real Integer
             , RegionName_Real TVarChar
             , CityId Integer
             , CityName TVarChar
             , CityId_Real Integer
             , CityName_Real TVarChar
             , Birthday_Date TDateTime
             , Children1_Date TDateTime
             , Children2_Date TDateTime
             , Children3_Date TDateTime
             , Children4_Date TDateTime
             , Children5_Date TDateTime
             , PSP_StartDate TDateTime
             , PSP_EndDate TDateTime
             , Dekret_StartDate TDateTime
             , Dekret_EndDate TDateTime
             , Street TVarChar
             , Street_Real TVarChar
             , Children1 TVarChar
             , Children2 TVarChar
             , Children3 TVarChar
             , Children4 TVarChar
             , Children5 TVarChar
             , Law TVarChar
             , DriverCertificateAdd TVarChar
             , PSP_S TVarChar
             , PSP_N TVarChar
             , PSP_W TVarChar
             , PSP_D TVarChar
              )
AS
$BODY$
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Member());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 AS Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Member()) AS Code
           , CAST ('' AS TVarChar)  AS NAME
           
           , CAST ('' AS TVarChar)  AS INN
           , CAST ('' AS TVarChar)  AS DriverCertificate
           , CAST ('' AS TVarChar)  AS Card
           , CAST ('' AS TVarChar)  AS CardSecond
           , CAST ('' AS TVarChar)  AS CardChild
           , CAST ('' AS TVarChar)  AS CardIBAN
           , CAST ('' AS TVarChar)  AS CardIBANSecond
           , CAST ('' AS TVarChar)  AS Comment
           , CAST (0 AS Integer)    AS InfoMoneyId
           , CAST (0 AS Integer)    AS InfoMoneyCode
           , CAST ('' AS TVarChar)  AS InfoMoneyName   
           , CAST ('' AS TVarChar)  AS InfoMoneyName_all  

           , CAST (0 AS Integer)    AS BankId
           , CAST ('' AS TVarChar)  AS BankName 
           , CAST (0 AS Integer)    AS BankSecondId
           , CAST ('' AS TVarChar)  AS BankSecondName 
           , CAST (0 AS Integer)    AS BankChildId
           , CAST ('' AS TVarChar)  AS BankChildName 
     
           , 0                      AS PersonalId
           , 0                      AS UnitId
           , CAST ('' AS TVarChar)  AS UnitName
           , 0                      AS PositionId
           , CAST ('' AS TVarChar)  AS PositionName
           , 0                      AS PersonalServiceListId
           , CAST ('' AS TVarChar)  AS PersonalServiceListName

           , FALSE                  AS isOfficial
           , FALSE                  AS isNotCompensation
           , CAST (0 as Integer)   AS GenderId
           , CAST ('' as TVarChar) AS GenderName
           , CAST (0 as Integer)   AS MemberSkillId
           , CAST ('' as TVarChar) AS MemberSkillName
           , CAST (0 as Integer)   AS JobSourceId
           , CAST ('' as TVarChar) AS JobSourceName
           , CAST (0 as Integer)   AS RegionId
           , CAST ('' as TVarChar) AS RegionName
           , CAST (0 as Integer)   AS RegionId_Real
           , CAST ('' as TVarChar) AS RegionName_Real
           , CAST (0 as Integer)   AS CityId
           , CAST ('' as TVarChar) AS CityName
           , CAST (0 as Integer)   AS CityId_Real
           , CAST ('' as TVarChar) AS CityName_Real

           , CAST (Null as TDateTime) AS Birthday_Date
           , CAST (Null as TDateTime) AS Children1_Date
           , CAST (Null as TDateTime) AS Children2_Date
           , CAST (Null as TDateTime) AS Children3_Date
           , CAST (Null as TDateTime) AS Children4_Date
           , CAST (Null as TDateTime) AS Children5_Date
           , CAST (Null as TDateTime) AS PSP_StartDate
           , CAST (Null as TDateTime) AS PSP_EndDate
           , CAST (Null as TDateTime) AS Dekret_StartDate
           , CAST (Null as TDateTime) AS Dekret_EndDate

           , CAST ('' as TVarChar) AS Street
           , CAST ('' as TVarChar) AS Street_Real
           , CAST ('' as TVarChar) AS Children1
           , CAST ('' as TVarChar) AS Children2
           , CAST ('' as TVarChar) AS Children3
           , CAST ('' as TVarChar) AS Children4
           , CAST ('' as TVarChar) AS Children5
           , CAST ('' as TVarChar) AS Law
           , CAST ('' as TVarChar) AS DriverCertificateAdd
           , CAST ('' as TVarChar) AS PSP_S
           , CAST ('' as TVarChar) AS PSP_N
           , CAST ('' as TVarChar) AS PSP_W
           , CAST ('' as TVarChar) AS PSP_D
           ;
   ELSE
       RETURN QUERY
       WITH tmpPersonal AS (SELECT ObjectLink_Personal_Member.ObjectId        AS PersonalId
                                 , ObjectLink_Personal_Unit.ChildObjectId     AS UnitId
                                 , ObjectLink_Personal_Position.ChildObjectId AS PositionId
                                 , ObjectLink_Personal_PersonalServiceList.ChildObjectId AS PersonalServiceListId
                                 , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Personal_Member.ChildObjectId
                                                      -- ����������� ������������ ��������� ��� ������, �.�. �������� � Ord = 1
                                                      ORDER BY CASE WHEN Object_Personal.isErased = FALSE THEN 0 ELSE 1 END
                                                             , CASE WHEN COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd() THEN 0 ELSE 1 END
                                                             -- , CASE WHEN ObjectLink_Personal_PersonalServiceList.ChildObjectId > 0 THEN 0 ELSE 1 END
                                                             , CASE WHEN ObjectBoolean_Official.ValueData = TRUE THEN 0 ELSE 1 END
                                                             , CASE WHEN ObjectBoolean_Main.ValueData = TRUE THEN 0 ELSE 1 END
                                                             , ObjectLink_Personal_Member.ObjectId
                                                     ) AS Ord
                            FROM ObjectLink AS ObjectLink_Personal_Member
                                 LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Personal_Member.ObjectId
                                 LEFT JOIN ObjectDate AS ObjectDate_DateOut
                                                      ON ObjectDate_DateOut.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                     AND ObjectDate_DateOut.DescId   = zc_ObjectDate_Personal_Out()          
                                 LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                      ON ObjectLink_Personal_Unit.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                     AND ObjectLink_Personal_Unit.DescId   = zc_ObjectLink_Personal_Unit()
                                 LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                                      ON ObjectLink_Personal_Position.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                     AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                 LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                                      ON ObjectLink_Personal_PersonalServiceList.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                     AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
                                 LEFT JOIN ObjectBoolean AS ObjectBoolean_Official
                                                         ON ObjectBoolean_Official.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                        AND ObjectBoolean_Official.DescId   = zc_ObjectBoolean_Member_Official()
                                 LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                                         ON ObjectBoolean_Main.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                        AND ObjectBoolean_Main.DescId   = zc_ObjectBoolean_Personal_Main()
                            WHERE ObjectLink_Personal_Member.ChildObjectId = inId
                              AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                           )
       -- ���������
       SELECT Object_Member.Id         AS Id
            , Object_Member.ObjectCode AS Code
            , Object_Member.ValueData  AS Name
            
            , ObjectString_INN.ValueData               AS INN
            , ObjectString_DriverCertificate.ValueData AS DriverCertificate
            , ObjectString_Card.ValueData              AS Card
            , ObjectString_CardSecond.ValueData        AS CardSecond3
            , ObjectString_CardChild.ValueData         AS CardChild
            , ObjectString_CardIBAN.ValueData          AS CardIBAN
            , ObjectString_CardIBANSecond.ValueData    AS CardIBANSecond
            , ObjectString_Comment.ValueData           AS Comment
            
            , Object_InfoMoney_View.InfoMoneyId
            , Object_InfoMoney_View.InfoMoneyCode
            , Object_InfoMoney_View.InfoMoneyName
            , Object_InfoMoney_View.InfoMoneyName_all
      
            , Object_Bank.Id               AS BankId
            , Object_Bank.ValueData        AS BankName
            , Object_BankSecond.Id         AS BankSecondId
            , Object_BankSecond.ValueData  AS BankSecondName
            , Object_BankChild.Id          AS BankChildId
            , Object_BankChild.ValueData   AS BankChildName
      
            , tmpPersonal.PersonalId
            , Object_Unit.Id            AS UnitId
            , Object_Unit.ValueData     AS UnitName
            , Object_Position.Id        AS PositionId
            , Object_Position.ValueData AS PositionName
            , Object_PersonalServiceList.Id        AS PersonalServiceListId
            , Object_PersonalServiceList.ValueData AS PersonalServiceListName
      
            , ObjectBoolean_Official.ValueData         AS isOfficial
            , COALESCE (ObjectBoolean_NotCompensation.ValueData,FALSE) ::Boolean  AS isNotCompensation
--
            , Object_Gender.Id       AS GenderId
            , Object_Gender.ValueData       AS GenderName
            , Object_MemberSkill.Id         AS MemberSkillId
            , Object_MemberSkill.ValueData  AS MemberSkillName
            , Object_JobSource.Id           AS JobSourceId
            , Object_JobSource.ValueData    AS JobSourceName
            , Object_Region.Id              AS RegionId
            , Object_Region.ValueData       AS RegionName
            , Object_Region_Real.Id         AS RegionId_Real
            , Object_Region_Real.ValueData  AS RegionName_Real
            , Object_City.Id                AS CityId
            , Object_City.ValueData         AS CityName
            , Object_City_Real.Id           AS CityId_Real
            , Object_City_Real.ValueData    AS CityName_Real
            
            , COALESCE(ObjectDate_Birthday.ValueData, Null)   ::TDateTime  AS Birthday_Date
            , COALESCE(ObjectDate_Children1.ValueData, Null)  ::TDateTime  AS Children1_Date
            , COALESCE(ObjectDate_Children2.ValueData, Null)  ::TDateTime  AS Children2_Date
            , COALESCE(ObjectDate_Children3.ValueData, Null)  ::TDateTime  AS Children3_Date
            , COALESCE(ObjectDate_Children4.ValueData, Null)  ::TDateTime  AS Children4_Date
            , COALESCE(ObjectDate_Children5.ValueData, Null)  ::TDateTime  AS Children5_Date
            , COALESCE(ObjectDate_PSP_Start.ValueData, Null)  ::TDateTime  AS PSP_StartDate
            , COALESCE(ObjectDate_PSP_End.ValueData, Null)    ::TDateTime  AS PSP_EndDate
            , COALESCE(ObjectDate_Dekret_Start.ValueData, Null)  ::TDateTime  AS Dekret_StartDate
            , COALESCE(ObjectDate_Dekret_End.ValueData, Null)    ::TDateTime  AS Dekret_EndDate
            
            , ObjectString_Street.ValueData               AS Street
            , ObjectString_Street_Real.ValueData          AS Street_Real
            , ObjectString_Children1.ValueData            AS Children1
            , ObjectString_Children2.ValueData            AS Children2
            , ObjectString_Children3.ValueData            AS Children3
            , ObjectString_Children4.ValueData            AS Children4
            , ObjectString_Children5.ValueData            AS Children5
            , ObjectString_Law.ValueData                  AS Law
            , ObjectString_DriverCertificateAdd.ValueData AS DriverCertificateAdd
            , ObjectString_PSP_S.ValueData                AS PSP_S
            , ObjectString_PSP_N.ValueData                AS PSP_N
            , ObjectString_PSP_W.ValueData                AS PSP_W
            , ObjectString_PSP_D.ValueData                AS PSP_D
        FROM Object AS Object_Member
             LEFT JOIN tmpPersonal ON tmpPersonal.ord = 1
             LEFT JOIN Object AS Object_Unit                ON Object_Unit.Id                = tmpPersonal.UnitId
             LEFT JOIN Object AS Object_Position            ON Object_Position.Id            = tmpPersonal.PositionId
             LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = tmpPersonal.PersonalServiceListId

             LEFT JOIN ObjectBoolean AS ObjectBoolean_Official
                                     ON ObjectBoolean_Official.ObjectId = Object_Member.Id
                                    AND ObjectBoolean_Official.DescId = zc_ObjectBoolean_Member_Official()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_NotCompensation
                                     ON ObjectBoolean_NotCompensation.ObjectId = Object_Member.Id
                                    AND ObjectBoolean_NotCompensation.DescId = zc_ObjectBoolean_Member_NotCompensation()

             LEFT JOIN ObjectString AS ObjectString_INN 
                                    ON ObjectString_INN.ObjectId = Object_Member.Id 
                                   AND ObjectString_INN.DescId = zc_ObjectString_Member_INN()
      
             LEFT JOIN ObjectString AS ObjectString_Card
                                    ON ObjectString_Card.ObjectId = Object_Member.Id 
                                   AND ObjectString_Card.DescId = zc_ObjectString_Member_Card()
             LEFT JOIN ObjectString AS ObjectString_CardSecond
                                    ON ObjectString_CardSecond.ObjectId = Object_Member.Id 
                                   AND ObjectString_CardSecond.DescId = zc_ObjectString_Member_CardSecond()
             LEFT JOIN ObjectString AS ObjectString_CardChild
                                    ON ObjectString_CardChild.ObjectId = Object_Member.Id 
                                   AND ObjectString_CardChild.DescId = zc_ObjectString_Member_CardChild()

             LEFT JOIN ObjectString AS ObjectString_CardIBAN
                                    ON ObjectString_CardIBAN.ObjectId = Object_Member.Id 
                                   AND ObjectString_CardIBAN.DescId = zc_ObjectString_Member_CardIBAN()
             LEFT JOIN ObjectString AS ObjectString_CardIBANSecond
                                    ON ObjectString_CardIBANSecond.ObjectId = Object_Member.Id 
                                   AND ObjectString_CardIBANSecond.DescId = zc_ObjectString_Member_CardIBANSecond()

             LEFT JOIN ObjectString AS ObjectString_DriverCertificate 
                                    ON ObjectString_DriverCertificate.ObjectId = Object_Member.Id 
                                   AND ObjectString_DriverCertificate.DescId = zc_ObjectString_Member_DriverCertificate()
      
             LEFT JOIN ObjectString AS ObjectString_Comment 
                                    ON ObjectString_Comment.ObjectId = Object_Member.Id 
                                   AND ObjectString_Comment.DescId = zc_ObjectString_Member_Comment()
      
             LEFT JOIN ObjectLink AS ObjectLink_Member_InfoMoney
                                  ON ObjectLink_Member_InfoMoney.ObjectId = Object_Member.Id
                                 AND ObjectLink_Member_InfoMoney.DescId = zc_ObjectLink_Member_InfoMoney()
             LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Member_InfoMoney.ChildObjectId
       
             LEFT JOIN ObjectLink AS ObjectLink_Member_Bank
                                  ON ObjectLink_Member_Bank.ObjectId = Object_Member.Id
                                 AND ObjectLink_Member_Bank.DescId = zc_ObjectLink_Member_Bank()
             LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_Member_Bank.ChildObjectId
      
             LEFT JOIN ObjectLink AS ObjectLink_Member_BankSecond
                                  ON ObjectLink_Member_BankSecond.ObjectId = Object_Member.Id
                                 AND ObjectLink_Member_BankSecond.DescId = zc_ObjectLink_Member_BankSecond()
             LEFT JOIN Object AS Object_BankSecond ON Object_BankSecond.Id = ObjectLink_Member_BankSecond.ChildObjectId
      
             LEFT JOIN ObjectLink AS ObjectLink_Member_BankChild
                                  ON ObjectLink_Member_BankChild.ObjectId = Object_Member.Id
                                 AND ObjectLink_Member_BankChild.DescId = zc_ObjectLink_Member_BankChild()
             LEFT JOIN Object AS Object_BankChild ON Object_BankChild.Id = ObjectLink_Member_BankChild.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Member_Gender
                              ON ObjectLink_Member_Gender.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_Gender.DescId = zc_ObjectLink_Member_Gender()
         LEFT JOIN Object AS Object_Gender ON Object_Gender.Id = ObjectLink_Member_Gender.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Member_MemberSkill
                              ON ObjectLink_Member_MemberSkill.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_MemberSkill.DescId = zc_ObjectLink_Member_MemberSkill()
         LEFT JOIN Object AS Object_MemberSkill ON Object_MemberSkill.Id = ObjectLink_Member_MemberSkill.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Member_JobSource
                              ON ObjectLink_Member_JobSource.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_JobSource.DescId = zc_ObjectLink_Member_JobSource()
         LEFT JOIN Object AS Object_JobSource ON Object_JobSource.Id = ObjectLink_Member_JobSource.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Member_Region
                              ON ObjectLink_Member_Region.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_Region.DescId = zc_ObjectLink_Member_Region()
         LEFT JOIN Object AS Object_Region ON Object_Region.Id = ObjectLink_Member_Region.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Member_City
                              ON ObjectLink_Member_City.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_City.DescId = zc_ObjectLink_Member_City()
         LEFT JOIN Object AS Object_City ON Object_City.Id = ObjectLink_Member_City.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Member_Region_Real
                              ON ObjectLink_Member_Region_Real.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_Region_Real.DescId = zc_ObjectLink_Member_Region_Real()
         LEFT JOIN Object AS Object_Region_Real ON Object_Region_Real.Id = ObjectLink_Member_Region_Real.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Member_City_Real
                              ON ObjectLink_Member_City_Real.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_City_Real.DescId = zc_ObjectLink_Member_City_Real()
         LEFT JOIN Object AS Object_City_Real ON Object_City_Real.Id = ObjectLink_Member_City_Real.ChildObjectId

         LEFT JOIN ObjectDate AS ObjectDate_Birthday
                              ON ObjectDate_Birthday.ObjectId = Object_Member.Id
                             AND ObjectDate_Birthday.DescId = zc_ObjectDate_Member_Birthday()
         LEFT JOIN ObjectDate AS ObjectDate_Children1
                              ON ObjectDate_Children1.ObjectId = Object_Member.Id
                             AND ObjectDate_Children1.DescId = zc_ObjectDate_Member_Children1()
         LEFT JOIN ObjectDate AS ObjectDate_Children2
                              ON ObjectDate_Children2.ObjectId = Object_Member.Id
                             AND ObjectDate_Children2.DescId = zc_ObjectDate_Member_Children2()
         LEFT JOIN ObjectDate AS ObjectDate_Children3
                              ON ObjectDate_Children3.ObjectId = Object_Member.Id
                             AND ObjectDate_Children3.DescId = zc_ObjectDate_Member_Children3()
         LEFT JOIN ObjectDate AS ObjectDate_Children4
                              ON ObjectDate_Children4.ObjectId = Object_Member.Id
                             AND ObjectDate_Children4.DescId = zc_ObjectDate_Member_Children4()
         LEFT JOIN ObjectDate AS ObjectDate_Children5
                              ON ObjectDate_Children5.ObjectId = Object_Member.Id
                             AND ObjectDate_Children5.DescId = zc_ObjectDate_Member_Children5()
         LEFT JOIN ObjectDate AS ObjectDate_PSP_Start
                              ON ObjectDate_PSP_Start.ObjectId = Object_Member.Id
                             AND ObjectDate_PSP_Start.DescId = zc_ObjectDate_Member_PSP_Start()
         LEFT JOIN ObjectDate AS ObjectDate_PSP_End
                              ON ObjectDate_PSP_End.ObjectId = Object_Member.Id
                             AND ObjectDate_PSP_End.DescId = zc_ObjectDate_Member_PSP_End()
         LEFT JOIN ObjectDate AS ObjectDate_Dekret_Start
                              ON ObjectDate_Dekret_Start.ObjectId = Object_Member.Id
                             AND ObjectDate_Dekret_Start.DescId = zc_ObjectDate_Member_Dekret_Start()
         LEFT JOIN ObjectDate AS ObjectDate_Dekret_End
                              ON ObjectDate_Dekret_End.ObjectId = Object_Member.Id
                             AND ObjectDate_Dekret_End.DescId = zc_ObjectDate_Member_Dekret_End()

         LEFT JOIN ObjectString AS ObjectString_Street
                                ON ObjectString_Street.ObjectId = Object_Member.Id
                               AND ObjectString_Street.DescId = zc_ObjectString_Member_Street()
         LEFT JOIN ObjectString AS ObjectString_Street_Real
                                ON ObjectString_Street_Real.ObjectId = Object_Member.Id
                               AND ObjectString_Street_Real.DescId = zc_ObjectString_Member_Street_Real()
         LEFT JOIN ObjectString AS ObjectString_Children1
                                ON ObjectString_Children1.ObjectId = Object_Member.Id
                               AND ObjectString_Children1.DescId = zc_ObjectString_Member_Children1()
         LEFT JOIN ObjectString AS ObjectString_Children2
                                ON ObjectString_Children2.ObjectId = Object_Member.Id
                               AND ObjectString_Children2.DescId = zc_ObjectString_Member_Children2()
         LEFT JOIN ObjectString AS ObjectString_Children3
                                ON ObjectString_Children3.ObjectId = Object_Member.Id
                               AND ObjectString_Children3.DescId = zc_ObjectString_Member_Children3()
         LEFT JOIN ObjectString AS ObjectString_Children4
                                ON ObjectString_Children4.ObjectId = Object_Member.Id
                               AND ObjectString_Children4.DescId = zc_ObjectString_Member_Children4()
         LEFT JOIN ObjectString AS ObjectString_Children5
                                ON ObjectString_Children5.ObjectId = Object_Member.Id
                               AND ObjectString_Children5.DescId = zc_ObjectString_Member_Children5()
         LEFT JOIN ObjectString AS ObjectString_Law
                                ON ObjectString_Law.ObjectId = Object_Member.Id
                               AND ObjectString_Law.DescId = zc_ObjectString_Member_Law()
         LEFT JOIN ObjectString AS ObjectString_DriverCertificateAdd
                                ON ObjectString_DriverCertificateAdd.ObjectId = Object_Member.Id
                               AND ObjectString_DriverCertificateAdd.DescId = zc_ObjectString_Member_DriverCertificateAdd()
         LEFT JOIN ObjectString AS ObjectString_PSP_S
                                ON ObjectString_PSP_S.ObjectId = Object_Member.Id
                               AND ObjectString_PSP_S.DescId = zc_ObjectString_Member_PSP_S()
         LEFT JOIN ObjectString AS ObjectString_PSP_N
                                ON ObjectString_PSP_N.ObjectId = Object_Member.Id
                               AND ObjectString_PSP_N.DescId = zc_ObjectString_Member_PSP_N()
         LEFT JOIN ObjectString AS ObjectString_PSP_W
                                ON ObjectString_PSP_W.ObjectId = Object_Member.Id
                               AND ObjectString_PSP_W.DescId = zc_ObjectString_Member_PSP_W()
         LEFT JOIN ObjectString AS ObjectString_PSP_D
                                ON ObjectString_PSP_D.ObjectId = Object_Member.Id
                               AND ObjectString_PSP_D.DescId = zc_ObjectString_Member_PSP_D()
        WHERE Object_Member.Id = inId;
     
   END IF;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.02.20         * add isNotCompensation
 09.09.19         * CardIBAN, CardIBANSecond
 03.03.17         * add Bank, BankSecond, BankChild
 20.02.17         * add CardSecond
 19.02.15         * add InfoMoney
 12.09.14                                        * add isOfficial
 01.10.13         * add DriverCertificate, Comment             
 01.07.13         *
 19.07.13                        *
*/

-- ����
-- SELECT * FROM gpGet_Object_Member (13117, '5')
