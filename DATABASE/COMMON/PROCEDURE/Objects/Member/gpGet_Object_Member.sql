-- Function: gpGet_Object_Member (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Member (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Member(
    IN inId          Integer,        -- Физические лица 
    IN inSession     TVarChar        -- сессия пользователя
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
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
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
           , FALSE                  AS isNotCompensation;
   ELSE
       RETURN QUERY
       WITH tmpPersonal AS (SELECT ObjectLink_Personal_Member.ObjectId        AS PersonalId
                                 , ObjectLink_Personal_Unit.ChildObjectId     AS UnitId
                                 , ObjectLink_Personal_Position.ChildObjectId AS PositionId
                                 , ObjectLink_Personal_PersonalServiceList.ChildObjectId AS PersonalServiceListId
                                 , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Personal_Member.ChildObjectId
                                                      -- сортировкой определяется приоритет для выбора, т.к. выбираем с Ord = 1
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
       -- Результат
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
      
        WHERE Object_Member.Id = inId;
     
   END IF;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
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

-- тест
-- SELECT * FROM gpGet_Object_Member (13117, '5')
