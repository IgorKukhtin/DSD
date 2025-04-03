-- Function: gpGet_Object_PersonalServiceList()

DROP FUNCTION IF EXISTS gpGet_Object_PersonalServiceList(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PersonalServiceList(
    IN inId          Integer,       -- ключ объекта <Торговая сеть>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , JuridicalId Integer, JuridicalName TVarChar 
             , PaidKindId Integer, PaidKindName TVarChar 
             , BranchId Integer, BranchName TVarChar 
             , BankId Integer, BankName TVarChar
             , MemberId Integer, MemberName TVarChar
             , MemberHeadManagerId Integer, MemberHeadManagerName TVarChar
             , MemberManagerId Integer, MemberManagerName TVarChar
             , MemberBookkeeperId Integer, MemberBookkeeperName TVarChar
             , PersonalHeadId Integer, PersonalHeadName TVarChar
             , BankAccountId Integer, BankAccountName TVarChar
             , PSLExportKindId Integer, PSLExportKindName TVarChar
             , ServiceListId_AvanceF2 Integer, ServiceListName_AvanceF2 TVarChar
             , ContentType TVarChar
             , OnFlowType TVarChar
             , Compensation TFloat
             , SummAvance TFloat, SummAvanceMax TFloat, HourAvance TFloat
             , KoeffSummCardSecond NUMERIC (16,10)
             , isSecond Boolean
             , isRecalc Boolean
             , isBankOut Boolean
             , isDetail Boolean
             , isAvanceNot Boolean
             , isBankNot Boolean   
             , isCompensationNot Boolean 
             , isNotAuto Boolean
             , isNotRound Boolean
             , isErased Boolean
             ) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_PersonalServiceList()) AS Code
           , CAST ('' as TVarChar)  AS NAME

           , 0                      AS JuridicalId
           , CAST ('' as TVarChar)  AS JuridicalName
           , 0                      AS PaidKindId
           , CAST ('' as TVarChar)  AS PaidKindName
           , 0                      AS BranchId
           , CAST ('' as TVarChar)  AS BranchName
           , 0                      AS BankId
           , CAST ('' as TVarChar)  AS BankName
           , 0                      AS MemberId
           , CAST ('' as TVarChar)  AS MemberName

           , 0                      AS MemberHeadManagerId
           , CAST ('' as TVarChar)  AS MemberHeadManagerName
           , 0                      AS MemberManagerId
           , CAST ('' as TVarChar)  AS MemberManagerName
           , 0                      AS MemberBookkeeperId
           , CAST ('' as TVarChar)  AS MemberBookkeeperName

           , CAST (0 as Integer)    AS PersonalHeadId
           , CAST ('' as TVarChar)  AS PersonalHeadName
           
           , 0                      AS BankAccountId
           , CAST ('' as TVarChar)  AS BankAccountName
           , 0                      AS PSLExportKindId
           , CAST ('' as TVarChar)  AS PSLExportKindName
           , 0                      AS ServiceListId_AvanceF2
           , CAST ('' as TVarChar)  AS ServiceListName_AvanceF2

           , CAST ('' as TVarChar)  AS ContentType
           , CAST ('' as TVarChar)  AS OnFlowType
                      
           , CAST (0 AS TFloat)     AS Compensation

           , CAST (0 AS TFloat)     AS SummAvance
           , CAST (0 AS TFloat)     AS SummAvanceMax
           , CAST (0 AS TFloat)     AS HourAvance          
           
           , CAST (0 AS NUMERIC (16,10)) AS KoeffSummCardSecond

           , CAST(FALSE AS Boolean) AS isSecond
           , CAST(FALSE AS Boolean) AS isRecalc
           , CAST(FALSE AS Boolean) AS isBankOut
           , CAST(FALSE AS Boolean) AS isDetail
           , CAST(FALSE AS Boolean) AS isAvanceNot 
           , CAST(FALSE AS Boolean) AS isBankNot
           , CAST(FALSE AS Boolean) AS isCompensationNot
           , CAST(FALSE AS Boolean) AS isNotAuto
           , CAST(FALSE AS Boolean) AS isNotRound

           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_PersonalServiceList.Id         AS Id
           , Object_PersonalServiceList.ObjectCode AS Code
           , Object_PersonalServiceList.ValueData  AS NAME
           , Object_Juridical.Id                   AS JuridicalId
           , Object_Juridical.ValueData            AS JuridicalName

           , Object_PaidKind.Id                   AS PaidKindId
           , Object_PaidKind.ValueData            AS PaidKindName
           , Object_Branch.Id                     AS BranchId
           , Object_Branch.ValueData              AS BranchName
           , Object_Bank.Id                       AS BankId
           , Object_Bank.ValueData                AS BankName

           , Object_Member.Id                     AS MemberId
           , Object_Member.ValueData              AS MemberName

           , Object_MemberHeadManager.Id          AS MemberHeadManagerId
           , Object_MemberHeadManager.ValueData   AS MemberHeadManagerName
           , Object_MemberManager.Id              AS MemberManagerId
           , Object_MemberManager.ValueData       AS MemberManagerName
           , Object_MemberBookkeeper.Id           AS MemberBookkeeperId
           , Object_MemberBookkeeper.ValueData    AS MemberBookkeeperName

           , Object_PersonalHead.Id               AS PersonalHeadId
           , Object_PersonalHead.ValueData        AS PersonalHeadName

           , Object_BankAccount.Id             AS BankAccountId
           , Object_BankAccount.ValueData      AS BankAccountName
           , Object_PSLExportKind.Id           AS PSLExportKindId
           , Object_PSLExportKind.ValueData    AS PSLExportKindName

           , Object_Avance_F2.Id                  AS ServiceListId_AvanceF2
           , Object_Avance_F2.ValueData           AS ServiceListName_AvanceF2

           , ObjectString_ContentType.ValueData ::TVarChar   AS ContentType
           , ObjectString_OnFlowType.ValueData  ::TVarChar   AS OnFlowType

           
           , COALESCE (ObjectFloat_Compensation.ValueData, 0)        :: TFloat AS Compensation

           , COALESCE (ObjectFloat_SummAvance.ValueData, 0)          :: TFloat AS SummAvance
           , COALESCE (ObjectFloat_SummAvanceMax.ValueData, 0)       :: TFloat AS SummAvanceMax
           , COALESCE (ObjectFloat_HourAvance.ValueData, 0)          :: TFloat AS HourAvance

           , CAST ((COALESCE (ObjectFloat_KoeffSummCardSecond.ValueData, 0) / 1000) AS NUMERIC (16,10)) AS KoeffSummCardSecond

           , COALESCE (ObjectBoolean_Second.ValueData,FALSE)     ::Boolean AS isSecond
           , COALESCE (ObjectBoolean_Recalc.ValueData,FALSE)     ::Boolean AS isRecalc
           , COALESCE (ObjectBoolean_BankOut.ValueData, FALSE)   ::Boolean AS isBankOut
           , COALESCE (ObjectBoolean_Detail.ValueData, FALSE)    ::Boolean AS isDetail
           , COALESCE (ObjectBoolean_AvanceNot.ValueData, FALSE) ::Boolean AS isAvanceNot
           , COALESCE (ObjectBoolean_BankNot.ValueData, FALSE)   ::Boolean AS isBankNot
           , COALESCE (ObjectBoolean_CompensationNot.ValueData, FALSE) ::Boolean AS isCompensationNot
           , COALESCE (ObjectBoolean_NotAuto.ValueData, FALSE)   ::Boolean AS isNotAuto
           , COALESCE (ObjectBoolean_NotRound.ValueData, FALSE)  ::Boolean AS isNotRound
           , Object_PersonalServiceList.isErased   AS isErased

       FROM Object AS Object_PersonalServiceList
           LEFT JOIN ObjectBoolean AS ObjectBoolean_CompensationNot
                                   ON ObjectBoolean_CompensationNot.ObjectId  = Object_PersonalServiceList.Id
                                  AND ObjectBoolean_CompensationNot.DescId    = zc_ObjectBoolean_PersonalServiceList_CompensationNot()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_Second 
                                   ON ObjectBoolean_Second.ObjectId = Object_PersonalServiceList.Id 
                                  AND ObjectBoolean_Second.DescId = zc_ObjectBoolean_PersonalServiceList_Second()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_Recalc 
                                   ON ObjectBoolean_Recalc.ObjectId = Object_PersonalServiceList.Id 
                                  AND ObjectBoolean_Recalc.DescId = zc_ObjectBoolean_PersonalServiceList_Recalc()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_BankOut
                                   ON ObjectBoolean_BankOut.ObjectId = Object_PersonalServiceList.Id 
                                  AND ObjectBoolean_BankOut.DescId = zc_ObjectBoolean_PersonalServiceList_BankOut()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_Detail
                                   ON ObjectBoolean_Detail.ObjectId = Object_PersonalServiceList.Id 
                                  AND ObjectBoolean_Detail.DescId = zc_ObjectBoolean_PersonalServiceList_Detail()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_AvanceNot
                                   ON ObjectBoolean_AvanceNot.ObjectId = Object_PersonalServiceList.Id 
                                  AND ObjectBoolean_AvanceNot.DescId = zc_ObjectBoolean_PersonalServiceList_AvanceNot()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_BankNot
                                   ON ObjectBoolean_BankNot.ObjectId = Object_PersonalServiceList.Id 
                                  AND ObjectBoolean_BankNot.DescId = zc_ObjectBoolean_PersonalServiceList_BankNot()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_NotAuto
                                   ON ObjectBoolean_NotAuto.ObjectId = Object_PersonalServiceList.Id 
                                  AND ObjectBoolean_NotAuto.DescId = zc_ObjectBoolean_PersonalServiceList_NotAuto()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_NotRound
                                   ON ObjectBoolean_NotRound.ObjectId  = Object_PersonalServiceList.Id
                                  AND ObjectBoolean_NotRound.DescId    = zc_ObjectBoolean_PersonalServiceList_NotRound()

           LEFT JOIN ObjectFloat AS ObjectFloat_Compensation
                                 ON ObjectFloat_Compensation.ObjectId = Object_PersonalServiceList.Id 
                                AND ObjectFloat_Compensation.DescId = zc_ObjectFloat_PersonalServiceList_Compensation()
           LEFT JOIN ObjectFloat AS ObjectFloat_KoeffSummCardSecond
                                 ON ObjectFloat_KoeffSummCardSecond.ObjectId = Object_PersonalServiceList.Id 
                                AND ObjectFloat_KoeffSummCardSecond.DescId = zc_ObjectFloat_PersonalServiceList_KoeffSummCardSecond()

           LEFT JOIN ObjectFloat AS ObjectFloat_SummAvance
                                 ON ObjectFloat_SummAvance.ObjectId = Object_PersonalServiceList.Id 
                                AND ObjectFloat_SummAvance.DescId = zc_ObjectFloat_PersonalServiceList_SummAvance()

           LEFT JOIN ObjectFloat AS ObjectFloat_SummAvanceMax
                                 ON ObjectFloat_SummAvanceMax.ObjectId = Object_PersonalServiceList.Id 
                                AND ObjectFloat_SummAvanceMax.DescId = zc_ObjectFloat_PersonalServiceList_SummAvanceMax()

           LEFT JOIN ObjectFloat AS ObjectFloat_HourAvance
                                 ON ObjectFloat_HourAvance.ObjectId = Object_PersonalServiceList.Id 
                                AND ObjectFloat_HourAvance.DescId = zc_ObjectFloat_PersonalServiceList_HourAvance()

           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Juridical
                                ON ObjectLink_PersonalServiceList_Juridical.ObjectId = Object_PersonalServiceList.Id 
                               AND ObjectLink_PersonalServiceList_Juridical.DescId = zc_ObjectLink_PersonalServiceList_Juridical()
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_PersonalServiceList_Juridical.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_PaidKind
                                ON ObjectLink_PersonalServiceList_PaidKind.ObjectId = Object_PersonalServiceList.Id 
                               AND ObjectLink_PersonalServiceList_PaidKind.DescId = zc_ObjectLink_PersonalServiceList_PaidKind()
           LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ObjectLink_PersonalServiceList_PaidKind.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Branch
                                ON ObjectLink_PersonalServiceList_Branch.ObjectId = Object_PersonalServiceList.Id 
                               AND ObjectLink_PersonalServiceList_Branch.DescId = zc_ObjectLink_PersonalServiceList_Branch()
           LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_PersonalServiceList_Branch.ChildObjectId
         
           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Bank
                                ON ObjectLink_PersonalServiceList_Bank.ObjectId = Object_PersonalServiceList.Id 
                               AND ObjectLink_PersonalServiceList_Bank.DescId = zc_ObjectLink_PersonalServiceList_Bank()
           LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_PersonalServiceList_Bank.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Member
                                ON ObjectLink_PersonalServiceList_Member.ObjectId = Object_PersonalServiceList.Id 
                               AND ObjectLink_PersonalServiceList_Member.DescId = zc_ObjectLink_PersonalServiceList_Member()
           LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_PersonalServiceList_Member.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_MemberHeadManager
                                ON ObjectLink_PersonalServiceList_MemberHeadManager.ObjectId = Object_PersonalServiceList.Id 
                               AND ObjectLink_PersonalServiceList_MemberHeadManager.DescId = zc_ObjectLink_PersonalServiceList_MemberHeadManager()
           LEFT JOIN Object AS Object_MemberHeadManager ON Object_MemberHeadManager.Id = ObjectLink_PersonalServiceList_MemberHeadManager.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_MemberManager
                                ON ObjectLink_PersonalServiceList_MemberManager.ObjectId = Object_PersonalServiceList.Id 
                               AND ObjectLink_PersonalServiceList_MemberManager.DescId = zc_ObjectLink_PersonalServiceList_MemberManager()
           LEFT JOIN Object AS Object_MemberManager ON Object_MemberManager.Id = ObjectLink_PersonalServiceList_MemberManager.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_MemberBookkeeper
                                ON ObjectLink_PersonalServiceList_MemberBookkeeper.ObjectId = Object_PersonalServiceList.Id 
                               AND ObjectLink_PersonalServiceList_MemberBookkeeper.DescId = zc_ObjectLink_PersonalServiceList_MemberBookkeeper()
           LEFT JOIN Object AS Object_MemberBookkeeper ON Object_MemberBookkeeper.Id = ObjectLink_PersonalServiceList_MemberBookkeeper.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_BankAccount
                                ON ObjectLink_PersonalServiceList_BankAccount.ObjectId = Object_PersonalServiceList.Id 
                               AND ObjectLink_PersonalServiceList_BankAccount.DescId = zc_ObjectLink_PersonalServiceList_BankAccount()
           LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = ObjectLink_PersonalServiceList_BankAccount.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_PSLExportKind
                                ON ObjectLink_PersonalServiceList_PSLExportKind.ObjectId = Object_PersonalServiceList.Id 
                               AND ObjectLink_PersonalServiceList_PSLExportKind.DescId = zc_ObjectLink_PersonalServiceList_PSLExportKind()
           LEFT JOIN Object AS Object_PSLExportKind ON Object_PSLExportKind.Id = ObjectLink_PersonalServiceList_PSLExportKind.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_PersonalHead
                                ON ObjectLink_PersonalServiceList_PersonalHead.ObjectId = Object_PersonalServiceList.Id 
                               AND ObjectLink_PersonalServiceList_PersonalHead.DescId   = zc_ObjectLink_PersonalServiceList_PersonalHead()
           LEFT JOIN Object AS Object_PersonalHead ON Object_PersonalHead.Id = ObjectLink_PersonalServiceList_PersonalHead.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Avance_F2
                                ON ObjectLink_PersonalServiceList_Avance_F2.ObjectId = Object_PersonalServiceList.Id 
                               AND ObjectLink_PersonalServiceList_Avance_F2.DescId = zc_ObjectLink_PersonalServiceList_Avance_F2()
           LEFT JOIN Object AS Object_Avance_F2 ON Object_Avance_F2.Id = ObjectLink_PersonalServiceList_Avance_F2.ChildObjectId

           LEFT JOIN ObjectString AS ObjectString_ContentType 
                                  ON ObjectString_ContentType.ObjectId = Object_PersonalServiceList.Id 
                                 AND ObjectString_ContentType.DescId = zc_ObjectString_PersonalServiceList_ContentType()
           LEFT JOIN ObjectString AS ObjectString_OnFlowType 
                                  ON ObjectString_OnFlowType.ObjectId = Object_PersonalServiceList.Id 
                                 AND ObjectString_OnFlowType.DescId = zc_ObjectString_PersonalServiceList_OnFlowType()

       WHERE Object_PersonalServiceList.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpGet_Object_PersonalServiceList(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.03.25         * isNotRound
 21.03.25         * isNotAuto
 12.02.24         * isBankNot
 29.01.24         * isCompensationNot
 27.04.23         *
 09.03.22         *
 18.11.21         * KoeffSummCardSecond
 28.04.21         * add isDetail
 18.08.21         *
 17.11.20         * add isBankOut
 17.01.20         * add isRecalc
 27.01.20         * add Compensation
 16.12.15         * add MemberHeadManager, MemberManager, MemberBookkeeper
 26.08.15         * add Member
 15.04.15         * add PaidKind, Branch, Bank
 30.09.14         * add Juridical               
 12.09.14         *

*/

-- тест
-- SELECT * FROM gpGet_Object_PersonalServiceList (0, '2')