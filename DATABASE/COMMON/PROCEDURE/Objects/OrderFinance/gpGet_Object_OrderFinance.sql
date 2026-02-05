-- Function: gpGet_Object_OrderFinance()

DROP FUNCTION IF EXISTS gpGet_Object_OrderFinance(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_OrderFinance(
    IN inId          Integer,       -- Подразделение 
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , BankAccountId Integer, BankAccountName TVarChar
             , BankId Integer, BankName TVarChar
             , MemberId_insert Integer, MemberName_insert TVarChar
             , MemberId_insert_2 Integer, MemberName_insert_2 TVarChar
             , MemberId_insert_3 Integer, MemberName_insert_3 TVarChar
             , MemberId_insert_4 Integer, MemberName_insert_4 TVarChar
             , MemberId_insert_5 Integer, MemberName_insert_5 TVarChar
             , MemberId_1 Integer, MemberName_1 TVarChar
             , MemberId_2 Integer, MemberName_2 TVarChar
             , Comment TVarChar
             , isStatus_off Boolean, isOperDate Boolean
             , isPlan_1 Boolean, isPlan_2 Boolean, isPlan_3 Boolean, isPlan_4 Boolean, isPlan_5 Boolean
             , isSB Boolean
             , isInvNumber Boolean, isInvNumber_Invoice Boolean
             , isErased Boolean
             )
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_OrderFinance());
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_OrderFinance()) AS Code
           , CAST ('' as TVarChar)  AS Name

           , 0                      AS PaidKindId
           , CAST ('' as TVarChar)  AS PaidKindName 

           , 0                      AS BankAccountId
           , CAST ('' as TVarChar)  AS BankAccountName

           , 0                      AS BankId
           , CAST ('' as TVarChar)  AS BankName

           , 0                      AS MemberId_insert
           , CAST ('' as TVarChar)  AS MemberName_insert   

           , 0                      AS MemberId_insert_2
           , CAST ('' as TVarChar)  AS MemberName_insert_2
           , 0                      AS MemberId_insert_3
           , CAST ('' as TVarChar)  AS MemberName_insert_3
           , 0                      AS MemberId_insert_4
           , CAST ('' as TVarChar)  AS MemberName_insert_4
           , 0                      AS MemberId_insert_5
           , CAST ('' as TVarChar)  AS MemberName_insert_5
           
           , 0                      AS MemberId_1
           , CAST ('' as TVarChar)  AS MemberName_1

           , 0                      AS MemberId_2
           , CAST ('' as TVarChar)  AS MemberName_2

           , CAST ('' as TVarChar)  AS Comment     

           , FALSE     ::Boolean AS isStatus_off
           , FALSE     ::Boolean AS isOperDate
           , FALSE     ::Boolean AS isPlan_1
           , FALSE     ::Boolean AS isPlan_2
           , FALSE     ::Boolean AS isPlan_3
           , FALSE     ::Boolean AS isPlan_4
           , FALSE     ::Boolean AS isPlan_5
           
           , FALSE     ::Boolean AS isSB
           , FALSE     ::Boolean AS isInvNumber
           , FALSE     ::Boolean AS isInvNumber_Invoice
       
           , CAST (NULL AS Boolean) AS isErased;
   
   ELSE
       RETURN QUERY 
       SELECT Object_OrderFinance.Id           AS Id
            , Object_OrderFinance.ObjectCode   AS Code
            , Object_OrderFinance.ValueData    AS Name

            , Object_PaidKind.Id               AS PaidKindId
            , Object_PaidKind.ValueData        AS PaidKindName   

            , Object_BankAccount.Id            AS BankAccountId
            , Object_BankAccount.ValueData     AS BankAccountName

            , Object_Bank.Id                   AS BankId
            , Object_Bank.ValueData            AS BankName

            , Object_Member_insert.Id          AS MemberId_insert
            , Object_Member_insert.ValueData   AS MemberName_insert   

            , Object_Member_insert_2.Id        AS MemberId_insert_2
            , Object_Member_insert_2.ValueData AS MemberName_insert_2
            , Object_Member_insert_3.Id        AS MemberId_insert_3
            , Object_Member_insert_3.ValueData AS MemberName_insert_3
            , Object_Member_insert_4.Id        AS MemberId_insert_4
            , Object_Member_insert_4.ValueData AS MemberName_insert_4
            , Object_Member_insert_5.Id        AS MemberId_insert_5
            , Object_Member_insert_5.ValueData AS MemberName_insert_5

            , Object_Member_1.Id               AS MemberId_1
            , Object_Member_1.ValueData        AS MemberName_1

            , Object_Member_2.Id               AS MemberId_2
            , Object_Member_2.ValueData        AS MemberName_2

            , ObjectString_Comment.ValueData   AS Comment
 
            , COALESCE (ObjectBoolean_Status_off.ValueData, FALSE) ::Boolean AS isStatus_off
            , COALESCE (ObjectBoolean_OperDate.ValueData, FALSE)   ::Boolean AS isOperDate
            , COALESCE (ObjectBoolean_Plan_1.ValueData, FALSE)     ::Boolean AS isPlan_1
            , COALESCE (ObjectBoolean_Plan_2.ValueData, FALSE)     ::Boolean AS isPlan_2
            , COALESCE (ObjectBoolean_Plan_3.ValueData, FALSE)     ::Boolean AS isPlan_3
            , COALESCE (ObjectBoolean_Plan_4.ValueData, FALSE)     ::Boolean AS isPlan_4
            , COALESCE (ObjectBoolean_Plan_5.ValueData, FALSE)     ::Boolean AS isPlan_5
          
            , COALESCE (ObjectBoolean_SB.ValueData, FALSE)         ::Boolean AS isSB
            , COALESCE (ObjectBoolean_InvNumber_Invoice.ValueData, FALSE) ::Boolean AS isInvNumber
            , COALESCE (ObjectBoolean_InvNumber.ValueData, FALSE)         ::Boolean AS isInvNumber_Invoice

            , Object_OrderFinance.isErased     AS isErased
           
       FROM Object AS Object_OrderFinance
           LEFT JOIN ObjectString AS ObjectString_Comment 
                                  ON ObjectString_Comment.ObjectId = Object_OrderFinance.Id
                                 AND ObjectString_Comment.DescId = zc_ObjectString_OrderFinance_Comment()

           LEFT JOIN ObjectLink AS OrderFinance_PaidKind
                                ON OrderFinance_PaidKind.ObjectId = Object_OrderFinance.Id
                               AND OrderFinance_PaidKind.DescId = zc_ObjectLink_OrderFinance_PaidKind()
           LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = OrderFinance_PaidKind.ChildObjectId

           LEFT JOIN ObjectLink AS OrderFinance_BankAccount
                                ON OrderFinance_BankAccount.ObjectId = Object_OrderFinance.Id
                               AND OrderFinance_BankAccount.DescId = zc_ObjectLink_OrderFinance_BankAccount()
           LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = OrderFinance_BankAccount.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                                ON ObjectLink_BankAccount_Bank.ObjectId = OrderFinance_BankAccount.ChildObjectId
                               AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
           LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId

           LEFT JOIN ObjectLink AS OrderFinance_Member_insert
                                ON OrderFinance_Member_insert.ObjectId = Object_OrderFinance.Id
                               AND OrderFinance_Member_insert.DescId = zc_ObjectLink_OrderFinance_Member_insert()
           LEFT JOIN Object AS Object_Member_insert ON Object_Member_insert.Id = OrderFinance_Member_insert.ChildObjectId

           LEFT JOIN ObjectLink AS OrderFinance_Member_insert_2
                                ON OrderFinance_Member_insert_2.ObjectId = Object_OrderFinance.Id
                               AND OrderFinance_Member_insert_2.DescId = zc_ObjectLink_OrderFinance_Member_insert_2()
           LEFT JOIN Object AS Object_Member_insert_2 ON Object_Member_insert_2.Id = OrderFinance_Member_insert_2.ChildObjectId

           LEFT JOIN ObjectLink AS OrderFinance_Member_insert_3
                                ON OrderFinance_Member_insert_3.ObjectId = Object_OrderFinance.Id
                               AND OrderFinance_Member_insert_3.DescId = zc_ObjectLink_OrderFinance_Member_insert_3()
           LEFT JOIN Object AS Object_Member_insert_3 ON Object_Member_insert_3.Id = OrderFinance_Member_insert_3.ChildObjectId

           LEFT JOIN ObjectLink AS OrderFinance_Member_insert_4
                                ON OrderFinance_Member_insert_4.ObjectId = Object_OrderFinance.Id
                               AND OrderFinance_Member_insert_4.DescId = zc_ObjectLink_OrderFinance_Member_insert_4()
           LEFT JOIN Object AS Object_Member_insert_4 ON Object_Member_insert_4.Id = OrderFinance_Member_insert_4.ChildObjectId

           LEFT JOIN ObjectLink AS OrderFinance_Member_insert_5
                                ON OrderFinance_Member_insert_5.ObjectId = Object_OrderFinance.Id
                               AND OrderFinance_Member_insert_5.DescId = zc_ObjectLink_OrderFinance_Member_insert_5()
           LEFT JOIN Object AS Object_Member_insert_5 ON Object_Member_insert_5.Id = OrderFinance_Member_insert_5.ChildObjectId

           LEFT JOIN ObjectLink AS OrderFinance_Member_1
                                ON OrderFinance_Member_1.ObjectId = Object_OrderFinance.Id
                               AND OrderFinance_Member_1.DescId = zc_ObjectLink_OrderFinance_Member_1()
           LEFT JOIN Object AS Object_Member_1 ON Object_Member_1.Id = OrderFinance_Member_1.ChildObjectId

           LEFT JOIN ObjectLink AS OrderFinance_Member_2
                                ON OrderFinance_Member_2.ObjectId = Object_OrderFinance.Id
                               AND OrderFinance_Member_2.DescId = zc_ObjectLink_OrderFinance_Member_2()
           LEFT JOIN Object AS Object_Member_2 ON Object_Member_2.Id = OrderFinance_Member_2.ChildObjectId

           LEFT JOIN ObjectBoolean  AS ObjectBoolean_Status_off 
                                    ON ObjectBoolean_Status_off.ObjectId = Object_OrderFinance.Id
                                   AND ObjectBoolean_Status_off.DescId = zc_ObjectBoolean_OrderFinance_Status_off()
           LEFT JOIN ObjectBoolean  AS ObjectBoolean_OperDate 
                                    ON ObjectBoolean_OperDate.ObjectId = Object_OrderFinance.Id
                                   AND ObjectBoolean_OperDate.DescId = zc_ObjectBoolean_OrderFinance_OperDate()

           LEFT JOIN ObjectBoolean  AS ObjectBoolean_Plan_1 
                                    ON ObjectBoolean_Plan_1.ObjectId = Object_OrderFinance.Id
                                   AND ObjectBoolean_Plan_1.DescId = zc_ObjectBoolean_OrderFinance_Plan_1()
           LEFT JOIN ObjectBoolean  AS ObjectBoolean_Plan_2 
                                    ON ObjectBoolean_Plan_2.ObjectId = Object_OrderFinance.Id
                                   AND ObjectBoolean_Plan_2.DescId = zc_ObjectBoolean_OrderFinance_Plan_2()
           LEFT JOIN ObjectBoolean  AS ObjectBoolean_Plan_3 
                                    ON ObjectBoolean_Plan_3.ObjectId = Object_OrderFinance.Id
                                   AND ObjectBoolean_Plan_3.DescId = zc_ObjectBoolean_OrderFinance_Plan_3()
           LEFT JOIN ObjectBoolean  AS ObjectBoolean_Plan_4 
                                    ON ObjectBoolean_Plan_4.ObjectId = Object_OrderFinance.Id
                                   AND ObjectBoolean_Plan_4.DescId = zc_ObjectBoolean_OrderFinance_Plan_4()
           LEFT JOIN ObjectBoolean  AS ObjectBoolean_Plan_5 
                                    ON ObjectBoolean_Plan_5.ObjectId = Object_OrderFinance.Id
                                   AND ObjectBoolean_Plan_5.DescId = zc_ObjectBoolean_OrderFinance_Plan_5()

           LEFT JOIN ObjectBoolean  AS ObjectBoolean_SB 
                                    ON ObjectBoolean_SB.ObjectId = Object_OrderFinance.Id
                                   AND ObjectBoolean_SB.DescId = zc_ObjectBoolean_OrderFinance_SB()

           LEFT JOIN ObjectBoolean  AS ObjectBoolean_InvNumber 
                                    ON ObjectBoolean_InvNumber.ObjectId = Object_OrderFinance.Id
                                   AND ObjectBoolean_InvNumber.DescId = zc_ObjectBoolean_OrderFinance_InvNumber()
           LEFT JOIN ObjectBoolean  AS ObjectBoolean_InvNumber_Invoice 
                                    ON ObjectBoolean_InvNumber_Invoice.ObjectId = Object_OrderFinance.Id
                                   AND ObjectBoolean_InvNumber_Invoice.DescId = zc_ObjectBoolean_OrderFinance_InvNumber_Invoice()

       WHERE Object_OrderFinance.Id = inId;
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.01.26         *
 24.12.25         *
 08.12.25         *
 02.11.20         * add BankName
 12.08.19         *
 29.07.19         *
*/

-- тест
-- SELECT * FROM gpGet_Object_OrderFinance(0,'2')