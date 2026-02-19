-- Function: gpGet_Movement_OrderFinance()

DROP FUNCTION IF EXISTS gpGet_Movement_OrderFinance (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_OrderFinance(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, OperDate_Amount TDateTime
             , StatusCode Integer, StatusName TVarChar
             , OrderFinanceId Integer, OrderFinanceName TVarChar, isSignSB_guide Boolean
             , BankAccountId Integer, BankAccountName TVarChar
             , BankId Integer, BankName TVarChar, BankAccountNameAll TVarChar
             , WeekNumber TFloat
             , TotalSumm_1 TFloat, TotalSumm_2 TFloat, TotalSumm_3 TFloat
             , StartDate_WeekNumber TDateTime, EndDate_WeekNumber TDateTime
             , DateUpdate_report TDateTime
             , UserUpdate_report TVarChar
             , UserMemberId_1 Integer, UserMember_1 TVarChar
             , UserMemberId_2 Integer, UserMember_2 TVarChar
             , Comment TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             , UnitName_insert     TVarChar
             , PositionName_insert TVarChar
             , Date_SignWait_1 TDateTime, Date_Sign_1 TDateTime
             , isSignWait_1 Boolean, isSign_1 Boolean
             , Date_SignSB TDateTime, isSignSB Boolean
             , TotalText_1 TVarChar, TotalText_2 TVarChar, TotalText_3 TVarChar
               --
             , CashId Integer, CashName TVarChar
             )
AS
$BODY$
  DECLARE vbUserId Integer;
          vbOperDate TDateTime;
          vbMemberId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_OrderFinance());
     vbUserId:= lpGetUserBySession (inSession);

     vbMemberId:= (SELECT ObjectLink_User_Member.ChildObjectId AS MemberId
                   FROm ObjectLink AS ObjectLink_User_Member
                   WHERE ObjectLink_User_Member.ObjectId = vbUserId
                     AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                  );

     vbOperDate := COALESCE ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId), CURRENT_DATE);


     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
     WITH
     tmpPersonal AS (SELECT lfSelect.MemberId
                          , lfSelect.UnitId
                          , lfSelect.PositionId
                     FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                     WHERE lfSelect.MemberId = vbMemberId
                     )

   , tmpOrderFinance AS (SELECT Object_OrderFinance.Id           AS OrderFinanceId
                              , Object_OrderFinance.ObjectCode   AS OrderFinanceCode
                              , Object_OrderFinance.ValueData    AS OrderFinanceName
                              , ObjectBoolean_SB.ValueData       AS isSignSB_guide


                              , Object_BankAccount_View.Id       AS BankAccountId
                              , Object_BankAccount_View.Name     AS BankAccountName
                              , Object_BankAccount_View.BankId   AS BankId
                              , Object_BankAccount_View.BankName AS BankName
                              , (Object_BankAccount_View.BankName || '' || Object_BankAccount_View.Name) :: TVarChar AS BankAccountNameAll

                              , Object_Member_1.Id               AS MemberId_1
                              , Object_Member_1.ValueData        AS MemberName_1
                              , Object_Member_2.Id               AS MemberId_2
                              , Object_Member_2.ValueData        AS MemberName_2

                              , CASE WHEN ObjectBoolean_Plan_1.ValueData = TRUE THEN 0
                                     WHEN ObjectBoolean_Plan_2.ValueData = TRUE THEN 1
                                     WHEN ObjectBoolean_Plan_3.ValueData = TRUE THEN 2
                                     WHEN ObjectBoolean_Plan_4.ValueData = TRUE THEN 3
                                     WHEN ObjectBoolean_Plan_5.ValueData = TRUE THEN 4
                                     ELSE 0
                                END AS addDayPlan

                         FROM Object AS Object_OrderFinance

                             LEFT JOIN ObjectBoolean  AS ObjectBoolean_SB
                                                      ON ObjectBoolean_SB.ObjectId = Object_OrderFinance.Id
                                                     AND ObjectBoolean_SB.DescId = zc_ObjectBoolean_OrderFinance_SB()

                             LEFT JOIN ObjectLink AS OrderFinance_Member_insert
                                                  ON OrderFinance_Member_insert.ObjectId = Object_OrderFinance.Id
                                                 AND OrderFinance_Member_insert.DescId = zc_ObjectLink_OrderFinance_Member_insert()
                             LEFT JOIN ObjectLink AS OrderFinance_Member_insert_2
                                                  ON OrderFinance_Member_insert_2.ObjectId = Object_OrderFinance.Id
                                                 AND OrderFinance_Member_insert_2.DescId = zc_ObjectLink_OrderFinance_Member_insert_2()
                             LEFT JOIN ObjectLink AS OrderFinance_Member_insert_3
                                                  ON OrderFinance_Member_insert_3.ObjectId = Object_OrderFinance.Id
                                                 AND OrderFinance_Member_insert_3.DescId = zc_ObjectLink_OrderFinance_Member_insert_3()
                             LEFT JOIN ObjectLink AS OrderFinance_Member_insert_4
                                                  ON OrderFinance_Member_insert_4.ObjectId = Object_OrderFinance.Id
                                                 AND OrderFinance_Member_insert_4.DescId = zc_ObjectLink_OrderFinance_Member_insert_4()
                             LEFT JOIN ObjectLink AS OrderFinance_Member_insert_5
                                                  ON OrderFinance_Member_insert_5.ObjectId = Object_OrderFinance.Id
                                                 AND OrderFinance_Member_insert_5.DescId = zc_ObjectLink_OrderFinance_Member_insert_5()

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

                             -- Платим 1.пн.(да/нет)
                             LEFT JOIN ObjectBoolean AS ObjectBoolean_Plan_1
                                                     ON ObjectBoolean_Plan_1.ObjectId = Object_OrderFinance.Id
                                                    AND ObjectBoolean_Plan_1.DescId   = zc_ObjectBoolean_OrderFinance_Plan_1()
                             LEFT JOIN ObjectBoolean AS ObjectBoolean_Plan_2
                                                     ON ObjectBoolean_Plan_2.ObjectId = Object_OrderFinance.Id
                                                    AND ObjectBoolean_Plan_2.DescId   = zc_ObjectBoolean_OrderFinance_Plan_2()
                             LEFT JOIN ObjectBoolean AS ObjectBoolean_Plan_3
                                                     ON ObjectBoolean_Plan_3.ObjectId = Object_OrderFinance.Id
                                                    AND ObjectBoolean_Plan_3.DescId   = zc_ObjectBoolean_OrderFinance_Plan_3()
                             LEFT JOIN ObjectBoolean AS ObjectBoolean_Plan_4
                                                     ON ObjectBoolean_Plan_4.ObjectId = Object_OrderFinance.Id
                                                    AND ObjectBoolean_Plan_4.DescId   = zc_ObjectBoolean_OrderFinance_Plan_4()
                             LEFT JOIN ObjectBoolean AS ObjectBoolean_Plan_5
                                                     ON ObjectBoolean_Plan_5.ObjectId = Object_OrderFinance.Id
                                                    AND ObjectBoolean_Plan_5.DescId   = zc_ObjectBoolean_OrderFinance_Plan_5()

                         WHERE Object_OrderFinance.DescId = zc_Object_OrderFinance()
                           AND Object_OrderFinance.isErased = FALSE
                           AND (OrderFinance_Member_insert.ChildObjectId = vbMemberId
                             OR OrderFinance_Member_insert_2.ChildObjectId = vbMemberId
                             OR OrderFinance_Member_insert_3.ChildObjectId = vbMemberId
                             OR OrderFinance_Member_insert_4.ChildObjectId = vbMemberId
                             OR OrderFinance_Member_insert_5.ChildObjectId = vbMemberId
                               )
                         -- временно
                         ORDER BY Object_OrderFinance.ObjectCode ASC
                         -- обязательно ОДИН, т.к. сотруднику могут быть назначены несколько OrderFinance
                         LIMIT 1
                         )


--и на гете определять по zc_ObjectLink_OrderFinance_Member_insert - какой подставить zc_MovementLinkObject_OrderFinance
--если не нашелся тогда уже вызывать справ. OrderFinance


         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_OrderFinance_seq') AS TVarChar) AS InvNumber
               -- Дата док.
             , CURRENT_DATE :: TDateTime                        AS OperDate
               -- Дата - ***План на неделю
             , (zfCalc_Week_StartDate (CURRENT_DATE
                                     , CASE WHEN EXTRACT (YEAR FROM CURRENT_DATE + INTERVAL '10 DAY') > EXTRACT (YEAR FROM CURRENT_DATE) THEN 1 ELSE EXTRACT (WEEK FROM CURRENT_DATE) + 1 END :: TFloat
                                      )
              + ((COALESCE (tmpOrderFinance.addDayPlan, 0) :: Integer) :: TVarChar || ' DAY') :: INTERVAL
               ) :: TDateTime AS OperDate_Amount
               --
             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName
             , COALESCE (tmpOrderFinance.OrderFinanceId,0)        ::Integer AS OrderFinanceId
             , COALESCE (tmpOrderFinance.OrderFinanceName,'')     ::TVarChar AS OrderFinanceName
             , COALESCE (tmpOrderFinance.isSignSB_guide, FALSE)   ::Boolean  AS isSignSB_guide

             , COALESCE (tmpOrderFinance.BankAccountId,0)     ::Integer  AS BankAccountId
             , COALESCE (tmpOrderFinance.BankAccountName,'')  ::TVarChar AS BankAccountName
             , COALESCE (tmpOrderFinance.BankId,0)            ::Integer  AS BankId
             , COALESCE (tmpOrderFinance.BankName,'')         ::TVarChar AS BankName
             , COALESCE (tmpOrderFinance.BankAccountNameAll,'') ::TVarChar AS BankAccountNameAll

             , CASE WHEN EXTRACT (YEAR FROM CURRENT_DATE + INTERVAL '10 DAY') > EXTRACT (YEAR FROM CURRENT_DATE) THEN 1 ELSE EXTRACT (WEEK FROM CURRENT_DATE) + 1 END :: TFloat AS WeekNumber
             , 0                                      :: TFloat   AS TotalSumm_1
             , 0                                      :: TFloat   AS TotalSumm_2
             , 0                                      :: TFloat   AS TotalSumm_3

             , DATE_TRUNC('WEEK', CURRENT_DATE + INTERVAL'7 DAY')                      ::TDateTime AS StartDate_WeekNumber
             , (DATE_TRUNC('WEEK', CURRENT_DATE + INTERVAL'7 DAY') + INTERVAL '6 DAY') ::TDateTime AS EndDate_WeekNumber
             , CAST (NULL AS TDateTime)                         AS DateUpdate_report
             , ''                                   ::TVarChar  AS UserUpdate_report

             , COALESCE (tmpOrderFinance.MemberId_1,0)     ::Integer   AS UserMemberId_1
             , CASE WHEN vbUserId = 5 AND 1=0 THEN '' ELSE COALESCE (tmpOrderFinance.MemberName_1,'' ) END ::TVarChar  AS UserMember_1

             , COALESCE (tmpOrderFinance.MemberId_2,0)     ::Integer   AS UserMemberId_2
             , CASE WHEN vbUserId = 5 AND 1=0 THEN '' ELSE COALESCE (tmpOrderFinance.MemberName_2,'')  END ::TVarChar  AS UserMember_2

             , CAST ('' AS TVarChar) 	                        AS Comment

             , CASE WHEN vbUserId = 5 AND 1=0 THEN 'ФИО' ELSE Object_Insert.ValueData END ::TVarChar AS InsertName
             , CURRENT_TIMESTAMP ::TDateTime                    AS InsertDate

             , CAST ('' AS TVarChar)                            AS UpdateName
             , CAST (NULL AS TDateTime)                         AS UpdateDate

             , CASE WHEN vbUserId = 5 AND 1=0 THEN 'Подразделение' ELSE Object_Unit.ValueData     END ::TVarChar AS UnitName_insert
             , CASE WHEN vbUserId = 5 AND 1=0 THEN 'Должность'     ELSE Object_Position.ValueData END ::TVarChar AS PositionName_insert

             , CAST (NULL AS TDateTime)                         AS Date_SignWait_1
             , CAST (NULL AS TDateTime)                         AS Date_Sign_1
             , FALSE                                 ::Boolean  AS isSignWait_1
             , FALSE                                 ::Boolean  AS isSign_1

             , CAST (NULL AS TDateTime)                         AS Date_SignSB
             , FALSE                                 ::Boolean  AS isSignSB

             , CASE WHEN tmpOrderFinance.OrderFinanceCode = 1
                         THEN 'Говядина на неделю:'
                    WHEN tmpOrderFinance.OrderFinanceCode = 2
                         THEN 'Лимит сырье упак.м-лы:'
                    ELSE 'нет группы:'
               END :: TVarChar AS TotalText_1

             , CASE WHEN tmpOrderFinance.OrderFinanceCode = 1
                         THEN 'Живой вес на неделю :'
                    ELSE 'нет группы:'
               END :: TVarChar AS TotalText_2

             , CASE WHEN tmpOrderFinance.OrderFinanceCode = 1
                         THEN 'Прочее мясн.с. на неделю :'
                    ELSE 'нет группы:'
               END :: TVarChar AS TotalText_3

               --
             , 0    ::Integer  AS CashId
             , ''   ::TVarChar AS CashName

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
              LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId

              LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = vbMemberId
              LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
              LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId
              LEFT JOIN tmpOrderFinance ON 1 = 1
          ;

     ELSE

     RETURN QUERY
       SELECT
             Movement.Id                                        AS Id
           , Movement.InvNumber                                 AS InvNumber
             -- Дата док.
           , Movement.OperDate                                  AS OperDate
             -- Дата - ***План на неделю
           , (zfCalc_Week_StartDate (Movement.OperDate, MovementFloat_WeekNumber.ValueData)
            + ((CASE WHEN ObjectBoolean_Plan_1.ValueData = TRUE THEN 0
                     WHEN ObjectBoolean_Plan_2.ValueData = TRUE THEN 1
                     WHEN ObjectBoolean_Plan_3.ValueData = TRUE THEN 2
                     WHEN ObjectBoolean_Plan_4.ValueData = TRUE THEN 3
                     WHEN ObjectBoolean_Plan_5.ValueData = TRUE THEN 4
                     ELSE 0
                END :: Integer) :: TVarChar || ' DAY') :: INTERVAL
             ) :: TDateTime AS OperDate_Amount
             --
           , Object_Status.ObjectCode                           AS StatusCode
           , Object_Status.ValueData                            AS StatusName

           , Object_OrderFinance.Id                             AS OrderFinanceId
           , Object_OrderFinance.ValueData                      AS OrderFinanceName
           , COALESCE (ObjectBoolean_SB.ValueData, FALSE) :: Boolean AS isSignSB_guide

           , Object_BankAccount_View.Id                         AS BankAccountId
           , Object_BankAccount_View.Name                       AS BankAccountName
           , Object_BankAccount_View.BankId
           , Object_BankAccount_View.BankName
           , (Object_BankAccount_View.BankName || '' || Object_BankAccount_View.Name) :: TVarChar AS BankAccountNameAll

           , COALESCE (MovementFloat_WeekNumber.ValueData, (EXTRACT (Week FROM vbOperDate) +1)) ::TFloat   AS WeekNumber
           , COALESCE (MovementFloat_TotalSumm_1.Valuedata, 0)                                  ::TFloat   AS TotalSumm_1
           , COALESCE (MovementFloat_TotalSumm_2.Valuedata, 0)                                  ::TFloat   AS TotalSumm_2
           , COALESCE (MovementFloat_TotalSumm_3.Valuedata, 0)                                  ::TFloat   AS TotalSumm_3

           , zfCalc_Week_StartDate (Movement.OperDate, MovementFloat_WeekNumber.ValueData) AS StartDate_WeekNumber
           , zfCalc_Week_EndDate   (Movement.OperDate, MovementFloat_WeekNumber.ValueData) AS EndDate_WeekNumber

           , CASE WHEN vbUserId = 5 AND 1=0 THEN MovementDate_Update_report.ValueData - INTERVAL '12 HOUR' ELSE MovementDate_Update_report.ValueData END ::TDateTime AS DateUpdate_report
           , CASE WHEN vbUserId = 5 AND 1=0 THEN 'ФИО' ELSE Object_Update_report.ValueData END       ::TVarChar  AS UserUpdate_report

           , Object_Member_1.Id                   ::Integer   AS UserMemberId_1
           , CASE WHEN vbUserId = 5 AND 1=0 THEN 'ФИО-1' ELSE COALESCE (Object_Member_1.ValueData,'' ) END ::TVarChar  AS UserMember_1

           , Object_Member_2.Id                   ::Integer   AS UserMemberId_2
           , CASE WHEN vbUserId = 5 AND 1=0 THEN 'ФИО-2' ELSE COALESCE (Object_Member_2.ValueData,'' ) END ::TVarChar  AS UserMember_2

           , MovementString_Comment.ValueData       AS Comment

           , CASE WHEN vbUserId = 5 AND 1=0 THEN 'ФИО' ELSE COALESCE (Object_Insert.ValueData,'' ) END ::TVarChar  AS InsertName

           , CASE WHEN vbUserId = 5 AND 1=0 THEN MovementDate_Insert.ValueData - INTERVAL '12 HOUR' ELSE MovementDate_Insert.ValueData END :: TDateTime          AS InsertDate
           , Object_Update.ValueData                AS UpdateName
           , MovementDate_Update.ValueData          AS UpdateDate

           , CASE WHEN vbUserId = 5 AND 1=0 THEN 'Подразделение' ELSE Object_Unit_insert.ValueData     END ::TVarChar AS UnitName_insert
           , CASE WHEN vbUserId = 5 AND 1=0 THEN 'Должность'     ELSE Object_Position_insert.ValueData END ::TVarChar AS PositionName_insert

           , CASE WHEN vbUserId = 5 AND 1=0 THEN MovementDate_SignWait_1.ValueData - INTERVAL '12 HOUR' ELSE MovementDate_SignWait_1.ValueData END ::TDateTime AS Date_SignWait_1
           , CASE WHEN vbUserId = 5 AND 1=0 THEN MovementDate_Sign_1.ValueData     - INTERVAL '12 HOUR' ELSE MovementDate_Sign_1.ValueData     END ::TDateTime AS Date_Sign_1
           , COALESCE (MovementBoolean_SignWait_1.ValueData, FALSE) ::Boolean   AS isSignWait_1
           , COALESCE (MovementBoolean_Sign_1.ValueData, FALSE)     ::Boolean   AS isSign_1

           , MovementDate_SignSB.ValueData                          ::TDateTime AS Date_SignSB
           , COALESCE (MovementBoolean_SignSB.ValueData, FALSE)     ::Boolean   AS isSignSB

           , CASE WHEN Object_OrderFinance.ObjectCode = 1
                       THEN 'Говядина на неделю:'
                  WHEN Object_OrderFinance.ObjectCode = 2
                       THEN 'Лимит сырье упак.м-лы:'
                  ELSE 'нет группы:'
             END :: TVarChar AS TotalText_1

           , CASE WHEN Object_OrderFinance.ObjectCode = 1
                       THEN 'Живой вес на неделю :'
                  ELSE 'нет группы:'
             END :: TVarChar AS TotalText_2

           , CASE WHEN Object_OrderFinance.ObjectCode = 1
                       THEN 'Прочее мясн.с. на неделю :'
                  ELSE 'нет группы:'
             END :: TVarChar AS TotalText_3

             --
           , 0    ::Integer  AS CashId
           , ''   ::TVarChar AS CashName

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementFloat AS MovementFloat_WeekNumber
                                    ON MovementFloat_WeekNumber.MovementId = Movement.Id
                                   AND MovementFloat_WeekNumber.DescId = zc_MovementFloat_WeekNumber()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm_1
                                    ON MovementFloat_TotalSumm_1.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm_1.DescId = zc_MovementFloat_TotalSumm_1()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm_2
                                    ON MovementFloat_TotalSumm_2.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm_2.DescId = zc_MovementFloat_TotalSumm_2()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm_3
                                    ON MovementFloat_TotalSumm_3.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm_3.DescId = zc_MovementFloat_TotalSumm_3()

            LEFT JOIN MovementDate AS MovementDate_Update_report
                                   ON MovementDate_Update_report.MovementId = Movement.Id
                                  AND MovementDate_Update_report.DescId = zc_MovementDate_Update_report()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()

            LEFT JOIN MovementDate AS MovementDate_SignWait_1
                                   ON MovementDate_SignWait_1.MovementId = Movement.Id
                                  AND MovementDate_SignWait_1.DescId = zc_MovementDate_SignWait_1()
            LEFT JOIN MovementDate AS MovementDate_Sign_1
                                   ON MovementDate_Sign_1.MovementId = Movement.Id
                                  AND MovementDate_Sign_1.DescId = zc_MovementDate_Sign_1()
            LEFT JOIN MovementDate AS MovementDate_SignSB
                                   ON MovementDate_SignSB.MovementId = Movement.Id
                                  AND MovementDate_SignSB.DescId = zc_MovementDate_SignSB()

            LEFT JOIN MovementBoolean AS MovementBoolean_SignWait_1
                                      ON MovementBoolean_SignWait_1.MovementId = Movement.Id
                                     AND MovementBoolean_SignWait_1.DescId = zc_MovementBoolean_SignWait_1()
            LEFT JOIN MovementBoolean AS MovementBoolean_Sign_1
                                      ON MovementBoolean_Sign_1.MovementId = Movement.Id
                                     AND MovementBoolean_Sign_1.DescId = zc_MovementBoolean_Sign_1()
            LEFT JOIN MovementBoolean AS MovementBoolean_SignSB
                                      ON MovementBoolean_SignSB.MovementId = Movement.Id
                                     AND MovementBoolean_SignSB.DescId = zc_MovementBoolean_SignSB()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = Movement.Id
                                        AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Update
                                         ON MovementLinkObject_Update.MovementId = Movement.Id
                                        AND MovementLinkObject_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MovementLinkObject_Update.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_OrderFinance
                                         ON MovementLinkObject_OrderFinance.MovementId = Movement.Id
                                        AND MovementLinkObject_OrderFinance.DescId = zc_MovementLinkObject_OrderFinance()
            LEFT JOIN Object AS Object_OrderFinance ON Object_OrderFinance.Id = MovementLinkObject_OrderFinance.ObjectId

            LEFT JOIN ObjectBoolean  AS ObjectBoolean_SB
                                     ON ObjectBoolean_SB.ObjectId = Object_OrderFinance.Id
                                    AND ObjectBoolean_SB.DescId   = zc_ObjectBoolean_OrderFinance_SB()


            LEFT JOIN MovementLinkObject AS MovementLinkObject_BankAccount
                                         ON MovementLinkObject_BankAccount.MovementId = Movement.Id
                                        AND MovementLinkObject_BankAccount.DescId = zc_MovementLinkObject_BankAccount()
            LEFT JOIN Object_BankAccount_View ON Object_BankAccount_View.Id = MovementLinkObject_BankAccount.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Update_report
                                         ON MovementLinkObject_Update_report.MovementId = Movement.Id
                                        AND MovementLinkObject_Update_report.DescId = zc_MovementLinkObject_Update_report()
            LEFT JOIN Object AS Object_Update_report ON Object_Update_report.Id = MovementLinkObject_Update_report.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member_1
                                         ON MovementLinkObject_Member_1.MovementId = Movement.Id
                                        AND MovementLinkObject_Member_1.DescId = zc_MovementLinkObject_Member_1()
            LEFT JOIN Object AS Object_Member_1 ON Object_Member_1.Id = MovementLinkObject_Member_1.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member_2
                                         ON MovementLinkObject_Member_2.MovementId = Movement.Id
                                        AND MovementLinkObject_Member_2.DescId = zc_MovementLinkObject_Member_2()
            LEFT JOIN Object AS Object_Member_2 ON Object_Member_2.Id = MovementLinkObject_Member_2.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit_insert ON Object_Unit_insert.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Position
                                         ON MovementLinkObject_Position.MovementId = Movement.Id
                                        AND MovementLinkObject_Position.DescId = zc_MovementLinkObject_Position()
            LEFT JOIN Object AS Object_Position_insert ON Object_Position_insert.Id = MovementLinkObject_Position.ObjectId

            -- Платим 1.пн.(да/нет)
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Plan_1
                                    ON ObjectBoolean_Plan_1.ObjectId = Object_OrderFinance.Id
                                   AND ObjectBoolean_Plan_1.DescId   = zc_ObjectBoolean_OrderFinance_Plan_1()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Plan_2
                                    ON ObjectBoolean_Plan_2.ObjectId = Object_OrderFinance.Id
                                   AND ObjectBoolean_Plan_2.DescId   = zc_ObjectBoolean_OrderFinance_Plan_2()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Plan_3
                                    ON ObjectBoolean_Plan_3.ObjectId = Object_OrderFinance.Id
                                   AND ObjectBoolean_Plan_3.DescId   = zc_ObjectBoolean_OrderFinance_Plan_3()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Plan_4
                                    ON ObjectBoolean_Plan_4.ObjectId = Object_OrderFinance.Id
                                   AND ObjectBoolean_Plan_4.DescId   = zc_ObjectBoolean_OrderFinance_Plan_4()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Plan_5
                                    ON ObjectBoolean_Plan_5.ObjectId = Object_OrderFinance.Id
                                   AND ObjectBoolean_Plan_5.DescId   = zc_ObjectBoolean_OrderFinance_Plan_5()

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_OrderFinance();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.01.26         *
 09.11.25         *
 29.07.19         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_OrderFinance (inMovementId:= 0, inOperDate:= CURRENT_DATE, inSession:= '9818')
