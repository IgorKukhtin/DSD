-- Function: gpSelect_Object_OrderFinance()

--DROP FUNCTION IF EXISTS gpSelect_Object_OrderFinance(TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_OrderFinance(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_OrderFinance(
    IN inisErased    Boolean ,      -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , BankAccountId Integer, BankAccountName TVarChar
             , BankId Integer, BankName TVarChar, BankAccountNameAll TVarChar
             , MemberId_insert Integer, MemberCode_insert Integer, MemberName_insert TVarChar
             , UnitName_insert TVarChar, PositionName_insert TVarChar
             , MemberId_insert_2 Integer, MemberCode_insert_2 Integer, MemberName_insert_2 TVarChar
             , UnitName_insert_2 TVarChar, PositionName_insert_2 TVarChar
             , MemberId_insert_3 Integer, MemberCode_insert_3 Integer, MemberName_insert_3 TVarChar
             , UnitName_insert_3 TVarChar, PositionName_insert_3 TVarChar
             , MemberId_insert_4 Integer, MemberCode_insert_4 Integer, MemberName_insert_4 TVarChar
             , UnitName_insert_4 TVarChar, PositionName_insert_4 TVarChar
             , MemberId_insert_5 Integer, MemberCode_insert_5 Integer, MemberName_insert_5 TVarChar
             , UnitName_insert_5 TVarChar, PositionName_insert_5 TVarChar
             , MemberId_1 Integer, MemberCode_1 Integer, MemberName_1 TVarChar
             , MemberId_2 Integer, MemberCode_2 Integer, MemberName_2 TVarChar
             , Comment TVarChar
             , isErased Boolean
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= PERFORM lpCheckRight(inSession, zc_Enum_Process_OrderFinance());
   vbUserId:= lpGetUserBySession (inSession);

   RETURN QUERY
   WITH tmpPersonal AS (SELECT lfSelect.MemberId
                             , lfSelect.UnitId
                             , lfSelect.PositionId
                             , lfSelect.isDateOut
                             , lfSelect.DateOut
                        FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                       ) 

       SELECT Object_OrderFinance.Id           AS Id
            , Object_OrderFinance.ObjectCode   AS Code
            , Object_OrderFinance.ValueData    AS Name

            , Object_PaidKind.Id               AS PaidKindId
            , Object_PaidKind.ValueData        AS PaidKindName   

            , Object_BankAccount_View.Id       AS BankAccountId
            , Object_BankAccount_View.Name     AS BankAccountName
            , Object_BankAccount_View.BankId   AS BankId
            , Object_BankAccount_View.BankName AS BankName
            , (Object_BankAccount_View.BankName || '' || Object_BankAccount_View.Name) :: TVarChar AS BankAccountNameAll

            , Object_Member_insert.Id          AS MemberId_insert
            , Object_Member_insert.ObjectCode  AS MemberCode_insert
            , CASE WHEN vbUserId = 5 THEN 'ФИО' ELSE Object_Member_insert.ValueData END :: TVarChar   AS MemberName_insert   
            , Object_Unit.ValueData      ::TVarChar AS UnitName_insert
            , Object_Position.ValueData  ::TVarChar AS PositionName_insert

            , Object_Member_insert_2.Id          AS MemberId_insert_2
            , Object_Member_insert_2.ObjectCode  AS MemberCode_insert_2
            , CASE WHEN vbUserId = 5 THEN 'ФИО' ELSE Object_Member_insert_2.ValueData END :: TVarChar   AS MemberName_insert_2   
            , Object_Unit_2.ValueData      ::TVarChar AS UnitName_insert_2
            , Object_Position_2.ValueData  ::TVarChar AS PositionName_insert_2

            , Object_Member_insert_3.Id          AS MemberId_insert_3
            , Object_Member_insert_3.ObjectCode  AS MemberCode_insert_3
            , CASE WHEN vbUserId = 5 THEN 'ФИО' ELSE Object_Member_insert_3.ValueData END :: TVarChar   AS MemberName_insert_3   
            , Object_Unit_3.ValueData      ::TVarChar AS UnitName_insert_3
            , Object_Position_3.ValueData  ::TVarChar AS PositionName_insert_3

            , Object_Member_insert_4.Id          AS MemberId_insert_4
            , Object_Member_insert_4.ObjectCode  AS MemberCode_insert_4
            , CASE WHEN vbUserId = 5 THEN 'ФИО' ELSE Object_Member_insert_4.ValueData END :: TVarChar   AS MemberName_insert_4   
            , Object_Unit_4.ValueData      ::TVarChar AS UnitName_insert_4
            , Object_Position_4.ValueData  ::TVarChar AS PositionName_insert_4

            , Object_Member_insert_5.Id          AS MemberId_insert_5
            , Object_Member_insert_5.ObjectCode  AS MemberCode_insert_5
            , CASE WHEN vbUserId = 5 THEN 'ФИО' ELSE Object_Member_insert_5.ValueData END :: TVarChar   AS MemberName_insert_5   
            , Object_Unit_5.ValueData      ::TVarChar AS UnitName_insert_5
            , Object_Position_5.ValueData  ::TVarChar AS PositionName_insert_5

            , Object_Member_1.Id               AS MemberId_1
            , Object_Member_1.ObjectCode       AS MemberCode_1
            , CASE WHEN vbUserId = 5 THEN 'ФИО-1' ELSE Object_Member_1.ValueData END :: TVarChar AS MemberName_1

            , Object_Member_2.Id               AS MemberId_2
            , Object_Member_2.ObjectCode       AS MemberCode_2
            , Object_Member_2.ValueData        AS MemberName_2

            , ObjectString_Comment.ValueData   AS Comment

            , Object_OrderFinance.isErased     AS isErased

       FROM Object AS Object_OrderFinance
           LEFT JOIN ObjectString AS ObjectString_Comment 
                                  ON ObjectString_Comment.ObjectId = Object_OrderFinance.Id
                                 AND ObjectString_Comment.DescId = zc_ObjectString_OrderFinance_Comment()

           LEFT JOIN ObjectLink AS OrderFinance_PaidKind
                                ON OrderFinance_PaidKind.ObjectId = Object_OrderFinance.Id
                               AND OrderFinance_PaidKind.DescId = zc_ObjectLink_OrderFinance_PaidKind()
           LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = OrderFinance_PaidKind.ChildObjectId

           LEFT JOIN ObjectLink AS OrderFinance_Member_insert
                                ON OrderFinance_Member_insert.ObjectId = Object_OrderFinance.Id
                               AND OrderFinance_Member_insert.DescId = zc_ObjectLink_OrderFinance_Member_insert()
           LEFT JOIN Object AS Object_Member_insert ON Object_Member_insert.Id = OrderFinance_Member_insert.ChildObjectId

           LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = Object_Member_insert.Id
           LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId

           LEFT JOIN ObjectLink AS OrderFinance_Member_insert_2
                                ON OrderFinance_Member_insert_2.ObjectId = Object_OrderFinance.Id
                               AND OrderFinance_Member_insert_2.DescId = zc_ObjectLink_OrderFinance_Member_insert_2()
           LEFT JOIN Object AS Object_Member_insert_2 ON Object_Member_insert_2.Id = OrderFinance_Member_insert_2.ChildObjectId
 
           LEFT JOIN tmpPersonal AS tmpPersonal_2 ON tmpPersonal_2.MemberId = Object_Member_insert_2.Id
           LEFT JOIN Object AS Object_Position_2 ON Object_Position_2.Id = tmpPersonal_2.PositionId
           LEFT JOIN Object AS Object_Unit_2 ON Object_Unit_2.Id = tmpPersonal_2.UnitId

           LEFT JOIN ObjectLink AS OrderFinance_Member_insert_3
                                ON OrderFinance_Member_insert_3.ObjectId = Object_OrderFinance.Id
                               AND OrderFinance_Member_insert_3.DescId = zc_ObjectLink_OrderFinance_Member_insert_3()
           LEFT JOIN Object AS Object_Member_insert_3 ON Object_Member_insert_3.Id = OrderFinance_Member_insert_3.ChildObjectId

           LEFT JOIN tmpPersonal AS tmpPersonal_3 ON tmpPersonal_3.MemberId = Object_Member_insert_3.Id
           LEFT JOIN Object AS Object_Position_3 ON Object_Position_3.Id = tmpPersonal_3.PositionId
           LEFT JOIN Object AS Object_Unit_3 ON Object_Unit_3.Id = tmpPersonal_3.UnitId

           LEFT JOIN ObjectLink AS OrderFinance_Member_insert_4
                                ON OrderFinance_Member_insert_4.ObjectId = Object_OrderFinance.Id
                               AND OrderFinance_Member_insert_4.DescId = zc_ObjectLink_OrderFinance_Member_insert_4()
           LEFT JOIN Object AS Object_Member_insert_4 ON Object_Member_insert_4.Id = OrderFinance_Member_insert_4.ChildObjectId

           LEFT JOIN tmpPersonal AS tmpPersonal_4 ON tmpPersonal_4.MemberId = Object_Member_insert_4.Id
           LEFT JOIN Object AS Object_Position_4 ON Object_Position_4.Id = tmpPersonal_4.PositionId
           LEFT JOIN Object AS Object_Unit_4 ON Object_Unit_4.Id = tmpPersonal_4.UnitId

           LEFT JOIN ObjectLink AS OrderFinance_Member_insert_5
                                ON OrderFinance_Member_insert_5.ObjectId = Object_OrderFinance.Id
                               AND OrderFinance_Member_insert_5.DescId = zc_ObjectLink_OrderFinance_Member_insert_5()
           LEFT JOIN Object AS Object_Member_insert_5 ON Object_Member_insert_5.Id = OrderFinance_Member_insert_5.ChildObjectId

           LEFT JOIN tmpPersonal AS tmpPersonal_5 ON tmpPersonal_5.MemberId = Object_Member_insert_5.Id
           LEFT JOIN Object AS Object_Position_5 ON Object_Position_5.Id = tmpPersonal_5.PositionId
           LEFT JOIN Object AS Object_Unit_5 ON Object_Unit_5.Id = tmpPersonal_5.UnitId

           LEFT JOIN ObjectLink AS OrderFinance_Member_1
                                ON OrderFinance_Member_1.ObjectId = Object_OrderFinance.Id
                               AND OrderFinance_Member_1.DescId = zc_ObjectLink_OrderFinance_Member_1()
           LEFT JOIN Object AS Object_Member_1 ON Object_Member_1.Id = OrderFinance_Member_1.ChildObjectId

           LEFT JOIN ObjectLink AS OrderFinance_Member_2
                                ON OrderFinance_Member_2.ObjectId = Object_OrderFinance.Id
                               AND OrderFinance_Member_2.DescId = zc_ObjectLink_OrderFinance_Member_2()
           LEFT JOIN Object AS Object_Member_2 ON Object_Member_2.Id = OrderFinance_Member_2.ChildObjectId

           LEFT JOIN ObjectLink AS OrderFinance_BankAccount
                                ON OrderFinance_BankAccount.ObjectId = Object_OrderFinance.Id
                               AND OrderFinance_BankAccount.DescId = zc_ObjectLink_OrderFinance_BankAccount()
           LEFT JOIN Object_BankAccount_View ON Object_BankAccount_View.Id = OrderFinance_BankAccount.ChildObjectId

       WHERE Object_OrderFinance.DescId = zc_Object_OrderFinance()
         AND (Object_OrderFinance.isErased = FALSE OR inisErased = TRUE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.12.25         *
 02.11.20         * add inisErased
 12.08.19         *
 29.07.19         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_OrderFinance (true, '2')
