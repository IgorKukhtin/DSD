-- Function: gpSelect_Movement_OrderFinance_SB()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderFinance_SB (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderFinance_SB (
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inBankMainId        Integer , -- банк  Плательщик
    IN inStartWeekNumber   Integer , --
    IN inEndWeekNumber     Integer , -- временно, только 1 неделя
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , OrderFinanceId Integer, OrderFinanceName TVarChar
             , WeekNumber TFloat

             , StartDate_WeekNumber TDateTime, EndDate_WeekNumber TDateTime
             , DateDay TDateTime, DateDay_old TDateTime, WeekDay TVarChar

             , UserMember_1      TVarChar
             , UserMember_2      TVarChar

             , Comment_mov TVarChar

             , InsertName TVarChar, InsertDate TDateTime
             , Date_Sign_1 TDateTime
             , isSign_1    Boolean
             , Date_SignSB TDateTime, isSignSB Boolean

             --
             , MovementItemId Integer
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , OKPO TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar, PersonalName_contract TVarChar
             , PaidKindName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar

             , Condition TVarChar, ContractStateKindCode Integer
             , StartDate TDateTime, EndDate_real TDateTime, EndDate TVarChar

             , Comment            TVarChar
             , Comment_SB         TVarChar

              -- child
             , MovementItemId_Child Integer
             , Amount               TFloat   --из мастера информативно
             , Amount_Child         TFloat
             , InvNumber_Child      TVarChar
             , GoodsName_Child      TVarChar
             , isSign_Child         Boolean
             , TextSign_Child       TVarChar

             , ColorFon_record Integer
              )
AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbIsDocumentUser Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderFinance());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- Замена, т.к. 1-ая неделя может быть переходящей в следующий год
     inStartDate:= zfCalc_Week_StartDate (inStartDate, inStartWeekNumber :: TFloat);
     -- временно, только 1 неделя
     inEndDate:= zfCalc_Week_EndDate (inStartDate, inStartWeekNumber :: TFloat);


     -- Результат
     RETURN QUERY
     WITH
       tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
               UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                    )
     , tmpMovement AS (SELECT Movement.*
                            , MovementFloat_WeekNumber.ValueData AS WeekNumber
                       FROM Movement
                            INNER JOIN MovementFloat AS MovementFloat_WeekNumber
                                                     ON MovementFloat_WeekNumber.MovementId = Movement.Id
                                                    AND MovementFloat_WeekNumber.DescId = zc_MovementFloat_WeekNumber()
                                                    AND MovementFloat_WeekNumber.ValueData BETWEEN inStartWeekNumber AND inEndWeekNumber
                           -- временно - Відділ забезбечення - 1
                           INNER JOIN MovementLinkObject AS MovementLinkObject_OrderFinance
                                                         ON MovementLinkObject_OrderFinance.MovementId = Movement.Id
                                                        AND MovementLinkObject_OrderFinance.DescId     = zc_MovementLinkObject_OrderFinance()
                                                      --AND MovementLinkObject_OrderFinance.ObjectId   = 3988049

                           LEFT JOIN ObjectBoolean  AS ObjectBoolean_SB
                                                    ON ObjectBoolean_SB.ObjectId = MovementLinkObject_OrderFinance.ObjectId
                                                   AND ObjectBoolean_SB.DescId = zc_ObjectBoolean_OrderFinance_SB()

                       WHERE Movement.DescId = zc_Movement_OrderFinance()
                         AND Movement.StatusId IN (SELECT tmpStatus.StatusId FROM tmpStatus)
                         AND Movement.OperDate BETWEEN inStartDate - INTERVAL '14 DAY' AND inEndDate
                         -- только те виды планировани, где нужно согласовывать СБ
                         AND ObjectBoolean_SB.ValueData = TRUE
                       )

     , tmpMI_Master AS (SELECT MovementItem.*
                        FROM MovementItem
                        WHERE MovementItem.MovementId IN (SELECT tmpMovement.Id FROM tmpMovement)
                          AND MovementItem.DescId     = zc_MI_Master()
                          AND MovementItem.isErased   = FALSE
                          -- есть Juridical
                          AND MovementItem.ObjectId   <> 0
                       )

     , tmpMI_Child AS (SELECT MovementItem.*
                       FROM MovementItem
                       WHERE MovementItem.MovementId IN (SELECT tmpMovement.Id FROM tmpMovement)
                         AND MovementItem.DescId     = zc_MI_Child()
                         AND MovementItem.isErased   = FALSE
                      )

     , tmpMIString_Child AS (SELECT *
                             FROM MovementItemString
                             WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                               AND MovementItemString.DescId IN (zc_MIString_GoodsName()
                                                               , zc_MIString_InvNumber()
                                                               )
                             )

     , tmpMIBoolean AS (SELECT *
                        FROM MovementItemBoolean
                        WHERE MovementItemBoolean.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                          AND MovementItemBoolean.DescId IN (zc_MIBoolean_Sign()
                                                           )
                        )

     , tmpMI_Data_Child AS (SELECT MovementItem.Id
                                 , MovementItem.Amount
                                 , MovementItem.ParentId
                                 , MIString_InvNumber.ValueData ::TVarChar AS InvNumber
                                 , MIString_GoodsName.ValueData ::TVarChar AS GoodsName
                                 , MIBoolean_Sign.ValueData     ::Boolean  AS isSign
                            FROM tmpMI_Child AS MovementItem
                                 LEFT JOIN tmpMIString_Child AS MIString_GoodsName
                                                             ON MIString_GoodsName.MovementItemId = MovementItem.Id
                                                            AND MIString_GoodsName.DescId = zc_MIString_GoodsName()

                                 LEFT JOIN tmpMIString_Child AS MIString_InvNumber
                                                             ON MIString_InvNumber.MovementItemId = MovementItem.Id
                                                            AND MIString_InvNumber.DescId = zc_MIString_InvNumber()

                                 LEFT JOIN tmpMIBoolean AS MIBoolean_Sign
                                                        ON MIBoolean_Sign.MovementItemId = MovementItem.Id
                                                       AND MIBoolean_Sign.DescId = zc_MIBoolean_Sign()

                            )
       --мастер у которого есть чайлд + чайлд
     , tmpMI AS (SELECT tmpMI_Master.Id
                      , tmpMI_Master.ObjectId
                      , tmpMI_Master.MovementId
                      , tmpMI_Master.Amount
                        --
                      , tmpMI_Child.Id         AS MovementItemId_Child
                      , tmpMI_Child.Amount     AS Amount_Child
                      , tmpMI_Child.InvNumber  AS InvNumber_Child
                      , tmpMI_Child.GoodsName  AS GoodsName_Child
                      , tmpMI_Child.isSign     AS isSign_Child
                     FROM tmpMI_Master
                          LEFT JOIN tmpMI_Data_Child AS tmpMI_Child
                                                     ON tmpMI_Child.ParentId = tmpMI_Master.Id
                     )

     , tmpMILO_Contract AS (SELECT *
                            FROM MovementItemLinkObject
                            WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                              AND MovementItemLinkObject.DescId IN (zc_MILinkObject_Contract()
                                                                   )
                            )

     , tmpContractCondition AS (SELECT Object_ContractCondition_View.ContractId
                                     , (Object_ContractCondition_View.Value::Integer
                                       ||' '|| CASE WHEN Object_ContractCondition_View.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayDayCalendar()
                                                        THEN 'К.дн.'
                                                    WHEN Object_ContractCondition_View.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayDayBank()
                                                            THEN 'Б.дн.'
                                                    ELSE ''
                                               END
                                        ) AS Condition
                                     , Object_ContractCondition_View.StartDate
                                     , Object_ContractCondition_View.EndDate
                                FROM Object_ContractCondition_View
                                WHERE Object_ContractCondition_View.ContractConditionKindId IN (zc_Enum_ContractConditionKind_DelayDayCalendar(), zc_Enum_ContractConditionKind_DelayDayBank())
                                  AND Object_ContractCondition_View.Value <> 0
                                  AND Object_ContractCondition_View.ContractId IN (SELECT DISTINCT tmpMILO_Contract.ObjectId FROM tmpMILO_Contract)
                                  --AND vbOperDate BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                                )
     , tmpContract_View AS (SELECT * FROM Object_Contract_View WHERE Object_Contract_View.ContractId IN (SELECT DISTINCT tmpMILO_Contract.ObjectId FROM tmpMILO_Contract))
     , tmpJuridicalDetails_View AS (SELECT * FROM ObjectHistory_JuridicalDetails_View WHERE ObjectHistory_JuridicalDetails_View.JuridicalId IN (SELECT DISTINCT tmpMI.ObjectId FROM tmpMI))

     , tmpMovementItemFloat AS (SELECT *
                                FROM MovementItemFloat
                                WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                  AND MovementItemFloat.DescId IN (zc_MIFloat_AmountPlan_1()
                                                                 , zc_MIFloat_AmountPlan_2()
                                                                 , zc_MIFloat_AmountPlan_3()
                                                                 , zc_MIFloat_AmountPlan_4()
                                                                 , zc_MIFloat_AmountPlan_5()
                                                                 , zc_MIFloat_Number_1()
                                                                 , zc_MIFloat_Number_2()
                                                                 , zc_MIFloat_Number_3()
                                                                 , zc_MIFloat_Number_4()
                                                                 , zc_MIFloat_Number_5()
                                                                  )
                                )

     , tmpMovementItemDate AS (SELECT *
                               FROM MovementItemDate
                               WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                 AND MovementItemDate.DescId IN (zc_MIDate_Insert()
                                                                , zc_MIDate_Update())
                                )
     , tmpMovementItemLinkObject AS (SELECT *
                                     FROM MovementItemLinkObject
                                     WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                       AND MovementItemLinkObject.DescId IN (zc_MILinkObject_Insert()
                                                                           , zc_MILinkObject_Update()
                                                                            )
                                     )
     , tmpMovementItemString AS (SELECT *
                                 FROM MovementItemString
                                 WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                   AND MovementItemString.DescId IN (zc_MIString_Comment()
                                                                   )
                                UNION ALL
                                 SELECT *
                                 FROM MovementItemString
                                 WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId_Child FROM tmpMI)
                                   AND MovementItemString.DescId IN (zc_MIString_Comment()
                                                                   , zc_MIString_Comment_SB()
                                                                   )
                                 )

       -- План оплат Master + Child по дняи - ВЕРТИКАЛЬНО
     , tmpMI_Union AS (SELECT tmpMI.*
                               -- План оплат на день недели
                             , tmp.AmountPlan_day
                               -- день недели
                             , tmp.NumDay
                               --
                             , ROW_NUMBER() OVER (PARTITION BY tmpMI.Id ORDER BY COALESCE (tmp.NumDay,0)) AS Ord

                        FROM tmpMI --tmpMI_Master AS tmpMI
                             LEFT JOIN (SELECT MovementItem.Id
                                               -- План оплат на день недели
                                             , MIFloat_AmountPlan_day.ValueData    :: TFloat AS AmountPlan_day
                                               -- день недели
                                             , 1 AS NumDay

                                        FROM tmpMI_Master AS MovementItem
                                             INNER JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_day
                                                                             ON MIFloat_AmountPlan_day.MovementItemId = MovementItem.Id
                                                                            AND MIFloat_AmountPlan_day.DescId = zc_MIFloat_AmountPlan_1()
                                        WHERE MIFloat_AmountPlan_day.ValueData <> 0

                                      UNION ALL
                                        SELECT MovementItem.Id
                                               -- План оплат на день недели
                                             , MIFloat_AmountPlan_day.ValueData    :: TFloat AS AmountPlan_day
                                               -- день недели
                                             , 2 AS NumDay

                                        FROM tmpMI_Master AS MovementItem
                                             INNER JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_day
                                                                             ON MIFloat_AmountPlan_day.MovementItemId = MovementItem.Id
                                                                            AND MIFloat_AmountPlan_day.DescId = zc_MIFloat_AmountPlan_2()
                                        WHERE MIFloat_AmountPlan_day.ValueData <> 0

                                      UNION ALL
                                        SELECT MovementItem.Id
                                               -- План оплат на день недели
                                             , MIFloat_AmountPlan_day.ValueData    :: TFloat AS AmountPlan_day
                                               -- день недели
                                             , 3 AS NumDay

                                        FROM tmpMI_Master AS MovementItem
                                             INNER JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_day
                                                                             ON MIFloat_AmountPlan_day.MovementItemId = MovementItem.Id
                                                                            AND MIFloat_AmountPlan_day.DescId = zc_MIFloat_AmountPlan_3()
                                        WHERE MIFloat_AmountPlan_day.ValueData <> 0

                                      UNION ALL
                                        SELECT MovementItem.Id
                                               -- План оплат на день недели
                                             , MIFloat_AmountPlan_day.ValueData    :: TFloat AS AmountPlan_day
                                               -- день недели
                                             , 4 AS NumDay

                                        FROM tmpMI_Master AS MovementItem
                                             INNER JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_day
                                                                             ON MIFloat_AmountPlan_day.MovementItemId = MovementItem.Id
                                                                            AND MIFloat_AmountPlan_day.DescId = zc_MIFloat_AmountPlan_4()
                                        WHERE MIFloat_AmountPlan_day.ValueData <> 0

                                      UNION ALL
                                        SELECT MovementItem.Id
                                               -- План оплат на день недели
                                             , MIFloat_AmountPlan_day.ValueData    :: TFloat AS AmountPlan_day
                                               -- день недели
                                             , 5 AS NumDay

                                        FROM tmpMI_Master AS MovementItem
                                             INNER JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_day
                                                                             ON MIFloat_AmountPlan_day.MovementItemId = MovementItem.Id
                                                                            AND MIFloat_AmountPlan_day.DescId = zc_MIFloat_AmountPlan_5()
                                        WHERE MIFloat_AmountPlan_day.ValueData <> 0

                                       ) AS tmp ON tmp.Id = tmpMI.Id
                       )

      , tmpMI_Data AS (SELECT MovementItem.MovementId
                            , MovementItem.Id                  AS Id
                            , MovementItem.NumDay
                            , Object_Juridical.Id              AS JuridicalId
                            , Object_Juridical.ObjectCode      AS JuridicalCode
                            , Object_Juridical.ValueData       AS JuridicalName
                            , tmpJuridicalDetails_View.OKPO
                            , Object_Contract.Id               AS ContractId
                            , Object_Contract.ObjectCode       AS ContractCode
                            , Object_Contract.ValueData        AS ContractName
                            , Object_PaidKind.ValueData        AS PaidKindName
                            , Object_InfoMoney.Id              AS InfoMoneyId
                            , Object_InfoMoney.ObjectCode      AS InfoMoneyCode
                            , Object_InfoMoney.ValueData       AS InfoMoneyName


                            , View_Contract.ContractStateKindCode  ::Integer  AS ContractStateKindCode
                            , View_Contract.StartDate
                            , View_Contract.EndDate_real
                            , (''|| CASE WHEN View_Contract.ContractTermKindId = zc_Enum_ContractTermKind_Long() THEN '* ' ELSE '' END
                                 || (LPAD (EXTRACT (Day FROM View_Contract.EndDate_term) :: TVarChar,2,'0') ||'.'||LPAD (EXTRACT (Month FROM View_Contract.EndDate_term) :: TVarChar,2,'0') ||'.'||EXTRACT (YEAR FROM View_Contract.EndDate_term) :: TVarChar)
                              ) ::TVarChar AS EndDate
                            , Object_Personal.ValueData ::TVarChar AS PersonalName_contract

                            , CASE WHEN MovementItem.Ord = 1 THEN MovementItem.Amount ELSE 0 END :: TFloat AS Amount

                            --, CASE WHEN MovementItem.Ord = 1 THEN MovementItem.AmountPlan_total ELSE 0 END :: TFloat AS AmountPlan_total

                              -- Сумма План оплат на дату
                            , MovementItem.AmountPlan_day       :: TFloat

                            , MIString_Comment.ValueData       AS Comment_mov

                              -- убирается дублирование
                            , ROW_NUMBER() OVER (PARTITION BY Object_Juridical.Id
                                                            , Object_Contract.Id
                                                            , Object_InfoMoney.Id
                                                            , Object_PaidKind.Id
                                                 ORDER BY CASE WHEN MovementItem.AmountPlan_day > 0 THEN 0 ELSE 1 END ASC
                                                        , CASE WHEN MovementItem.Amount         > 0 THEN 0 ELSE 1 END ASC
                                                        , MovementItem.Id ASC
                                                ) AS Ord_Juridical
                             -- строки для согласования СБ
                            , MovementItem.MovementItemId_Child
                            , MovementItem.Amount_Child
                            , MovementItem.InvNumber_Child
                            , MovementItem.GoodsName_Child
                            , MovementItem.isSign_Child
                            , MIString_Comment_Child.ValueData    AS Comment_Child
                            , MIString_Comment_SB_Child.ValueData AS Comment_SB_Child

                        FROM tmpMI_Union AS MovementItem
                             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementItem.ObjectId
                                                                 AND Object_Juridical.DescId = zc_Object_Juridical()

                             LEFT JOIN tmpMovementItemString AS MIString_Comment
                                                             ON MIString_Comment.MovementItemId = MovementItem.Id
                                                            AND MIString_Comment.DescId = zc_MIString_Comment()
                             LEFT JOIN tmpMovementItemString AS MIString_Comment_Child
                                                             ON MIString_Comment_Child.MovementItemId = MovementItem.MovementItemId_Child
                                                            AND MIString_Comment_Child.DescId = zc_MIString_Comment()
                             LEFT JOIN tmpMovementItemString AS MIString_Comment_SB_Child
                                                             ON MIString_Comment_SB_Child.MovementItemId = MovementItem.MovementItemId_Child
                                                            AND MIString_Comment_SB_Child.DescId = zc_MIString_Comment_SB()

                             LEFT JOIN tmpMILO_Contract AS MILinkObject_Contract
                                                        ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                             LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MILinkObject_Contract.ObjectId

                             LEFT JOIN tmpJuridicalDetails_View ON tmpJuridicalDetails_View.JuridicalId = Object_Juridical.Id

                             LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                                  ON ObjectLink_Contract_InfoMoney.ObjectId = Object_Contract.Id
                                                 AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                             LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = CASE WHEN Object_Juridical.DescId = zc_Object_Juridical() THEN ObjectLink_Contract_InfoMoney.ChildObjectId ELSE MovementItem.ObjectId END

                             LEFT JOIN tmpContract_View AS View_Contract ON View_Contract.ContractId = Object_Contract.Id
                             LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = View_Contract.PaidKindId

                             LEFT JOIN ObjectLink AS ObjectLink_Contract_Personal
                                                  ON ObjectLink_Contract_Personal.ObjectId = View_Contract.ContractId
                                                 AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
                             LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Contract_Personal.ChildObjectId
                     )
       --
     , tmpMovement_Data AS (SELECT
                            Movement.Id                            AS MovementId
                          , Movement.InvNumber                     AS InvNumber
                          , Movement.OperDate                      AS OperDate
                          , Object_Status.ObjectCode               AS StatusCode
                          , Object_Status.ValueData                AS StatusName

                          , Object_OrderFinance.Id                 AS OrderFinanceId
                          , Object_OrderFinance.ValueData          AS OrderFinanceName

                          , Movement.WeekNumber        ::TFloat    AS WeekNumber

                          , zfCalc_Week_StartDate (Movement.OperDate, MovementFloat_WeekNumber.ValueData) AS StartDate_WeekNumber
                          , zfCalc_Week_EndDate   (Movement.OperDate, MovementFloat_WeekNumber.ValueData) AS EndDate_WeekNumber

                          , Object_Member_1.ValueData            ::TVarChar  AS UserMember_1
                          , Object_Member_2.ValueData            ::TVarChar  AS UserMember_2
                          , Object_Insert.ValueData                AS InsertName
                          , MovementDate_Insert.ValueData          AS InsertDate
                          , COALESCE (MovementDate_Sign_1.ValueData, NULL)         ::TDateTime AS Date_Sign_1
                          , COALESCE (MovementBoolean_Sign_1.ValueData, FALSE)     ::Boolean   AS isSign_1

                          , MovementDate_SignSB.ValueData                          ::TDateTime AS Date_SignSB
                          , COALESCE (MovementBoolean_SignSB.ValueData, FALSE)     ::Boolean   AS isSignSB
                      FROM tmpMovement AS Movement

                           LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

                           LEFT JOIN MovementFloat AS MovementFloat_WeekNumber
                                                   ON MovementFloat_WeekNumber.MovementId = Movement.Id
                                                  AND MovementFloat_WeekNumber.DescId = zc_MovementFloat_WeekNumber()

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_OrderFinance
                                                        ON MovementLinkObject_OrderFinance.MovementId = Movement.Id
                                                       AND MovementLinkObject_OrderFinance.DescId = zc_MovementLinkObject_OrderFinance()
                           LEFT JOIN Object AS Object_OrderFinance ON Object_OrderFinance.Id = MovementLinkObject_OrderFinance.ObjectId

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Member_1
                                                        ON MovementLinkObject_Member_1.MovementId = Movement.Id
                                                       AND MovementLinkObject_Member_1.DescId = zc_MovementLinkObject_Member_1()
                           LEFT JOIN Object AS Object_Member_1 ON Object_Member_1.Id = MovementLinkObject_Member_1.ObjectId

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Member_2
                                                        ON MovementLinkObject_Member_2.MovementId = Movement.Id
                                                       AND MovementLinkObject_Member_2.DescId = zc_MovementLinkObject_Member_2()
                           LEFT JOIN Object AS Object_Member_2 ON Object_Member_2.Id = MovementLinkObject_Member_2.ObjectId

                           LEFT JOIN MovementDate AS MovementDate_Insert
                                                  ON MovementDate_Insert.MovementId = Movement.Id
                                                 AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                                        ON MovementLinkObject_Insert.MovementId = Movement.Id
                                                       AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
                           LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

                           LEFT JOIN MovementDate AS MovementDate_Sign_1
                                                  ON MovementDate_Sign_1.MovementId = Movement.Id
                                                 AND MovementDate_Sign_1.DescId = zc_MovementDate_Sign_1()
                           LEFT JOIN MovementBoolean AS MovementBoolean_Sign_1
                                                     ON MovementBoolean_Sign_1.MovementId = Movement.Id
                                                    AND MovementBoolean_Sign_1.DescId = zc_MovementBoolean_Sign_1()

                           LEFT JOIN MovementDate AS MovementDate_SignSB
                                                  ON MovementDate_SignSB.MovementId = Movement.Id
                                                 AND MovementDate_SignSB.DescId = zc_MovementDate_SignSB()
                           LEFT JOIN MovementBoolean AS MovementBoolean_SignSB
                                                     ON MovementBoolean_SignSB.MovementId = Movement.Id
                                                    AND MovementBoolean_SignSB.DescId = zc_MovementBoolean_SignSB()
                    )
   -- Результат
   SELECT tmpMovement.MovementId
        , tmpMovement.InvNumber
        , tmpMovement.OperDate
        , tmpMovement.StatusCode
        , tmpMovement.StatusName
        , tmpMovement.OrderFinanceId
        , tmpMovement.OrderFinanceName

        , tmpMovement.WeekNumber
        , tmpMovement.StartDate_WeekNumber ::TDateTime
        , tmpMovement.EndDate_WeekNumber   ::TDateTime  --20
          -- дата по дню недели
        , CASE WHEN tmpMI.NumDay = 1 THEN tmpMovement.StartDate_WeekNumber
               WHEN tmpMI.NumDay = 2 THEN tmpMovement.StartDate_WeekNumber + INTERVAL'1 day'
               WHEN tmpMI.NumDay = 3 THEN tmpMovement.StartDate_WeekNumber + INTERVAL'2 day'
               WHEN tmpMI.NumDay = 4 THEN tmpMovement.StartDate_WeekNumber + INTERVAL'3 day'
               WHEN tmpMI.NumDay = 5 THEN tmpMovement.StartDate_WeekNumber + INTERVAL'4 day'
               ELSE NULL
          END ::TDateTime AS DateDay
        , CASE WHEN tmpMI.NumDay = 1 THEN tmpMovement.StartDate_WeekNumber
               WHEN tmpMI.NumDay = 2 THEN tmpMovement.StartDate_WeekNumber + INTERVAL'1 day'
               WHEN tmpMI.NumDay = 3 THEN tmpMovement.StartDate_WeekNumber + INTERVAL'2 day'
               WHEN tmpMI.NumDay = 4 THEN tmpMovement.StartDate_WeekNumber + INTERVAL'3 day'
               WHEN tmpMI.NumDay = 5 THEN tmpMovement.StartDate_WeekNumber + INTERVAL'4 day'
               ELSE NULL
          END ::TDateTime AS DateDay_old
          -- дата по дню недели
        , CASE WHEN tmpMI.NumDay = 1 THEN '1.Пн.'
               WHEN tmpMI.NumDay = 2 THEN '2.Вт.'
               WHEN tmpMI.NumDay = 3 THEN '3.Ср.'
               WHEN tmpMI.NumDay = 4 THEN '4.Чт.'
               WHEN tmpMI.NumDay = 5 THEN '5.Пт.'
               ELSE NULL
          END ::TVarChar AS WeekDay

        , tmpMovement.UserMember_1      ::TVarChar
        , tmpMovement.UserMember_2      ::TVarChar

        , tmpMI.Comment_mov             ::TVarChar  AS Comment_mov

        , tmpMovement.InsertName
        , tmpMovement.InsertDate

        , tmpMovement.Date_Sign_1     ::TDateTime
        , tmpMovement.isSign_1        ::Boolean


        , tmpMovement.Date_SignSB       ::TDateTime AS Date_SignSB
        , tmpMovement.isSignSB          ::Boolean   AS isSignSB

          --
        , tmpMI.Id AS MovementItemId
        , tmpMI.JuridicalId
        , tmpMI.JuridicalCode
        , tmpMI.JuridicalName
        , tmpMI.OKPO
        , tmpMI.ContractId
        , tmpMI.ContractCode
        , tmpMI.ContractName
        , tmpMI.PersonalName_contract  ::TVarChar
        , tmpMI.PaidKindName
        , tmpMI.InfoMoneyId
        , tmpMI.InfoMoneyCode
        , tmpMI.InfoMoneyName
        , tmpContractCondition.Condition       ::TVarChar AS Condition
        , tmpMI.ContractStateKindCode  ::Integer
        , tmpMI.StartDate              ::TDateTime
        , tmpMI.EndDate_real           ::TDateTime
        , tmpMI.EndDate                ::TVarChar

        , tmpMI.Comment_Child          ::TVarChar AS Comment
        , tmpMI.Comment_SB_Child       ::TVarChar AS Comment_SB

          -- строки для согласования СБ
        , tmpMI.MovementItemId_Child
        , tmpMI.Amount
        , COALESCE (tmpMI.Amount_Child, tmpMI.Amount) ::TFloat AS Amount_Child
        , tmpMI.InvNumber_Child
        , tmpMI.GoodsName_Child
        , tmpMI.isSign_Child
        , CASE WHEN tmpMI.isSign_Child = TRUE THEN 'Погоджено'
               WHEN tmpMI.isSign_Child = FALSE THEN 'Не погоджено'
               ELSE ''
          END                  ::TVarChar AS TextSign_Child

        , CASE WHEN tmpMI.isSign_Child = FALSE
                    -- подсветили если Не погоджено
                    THEN zc_Color_Aqua()
               ELSE zc_Color_White()
          END ::Integer AS ColorFon_record

   FROM tmpMovement_Data AS tmpMovement
        INNER JOIN tmpMI_Data AS tmpMI ON tmpMI.MovementId = tmpMovement.MovementId
                                      -- убирается дублирование
                                      AND (tmpMI.Ord_Juridical = 1 OR tmpMI.Amount <> 0 OR tmpMI.AmountPlan_day <> 0)

        LEFT JOIN tmpContractCondition ON tmpContractCondition.ContractId = tmpMI.ContractId
                                      AND tmpMovement.OperDate BETWEEN tmpContractCondition.StartDate AND tmpContractCondition.EndDate
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.12.25         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderFinance_SB (inStartDate:= '05.01.2026', inEndDate:= '11.01.2026', inBankMainId:=0, inStartWeekNumber:=1, inEndWeekNumber := 1, inSession:= '2')
