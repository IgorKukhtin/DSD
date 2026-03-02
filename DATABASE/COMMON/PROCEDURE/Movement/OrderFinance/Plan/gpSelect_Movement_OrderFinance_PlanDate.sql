-- Function: gpSelect_Movement_OrderFinance_PlanDate()

--DROP FUNCTION IF EXISTS gpSelect_Movement_OrderFinance_PlanDate (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_OrderFinance_PlanDate_4 (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderFinance_PlanDate_4 (
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inBankMainId        Integer , -- банк  Плательщик
    IN inStartWeekNumber   Integer , --
    IN inEndWeekNumber     Integer , -- временно, только 1 неделя
    IN inIsShowAll         Boolean , --показать детально, т.е. показать данные из чайлд 
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , OrderFinanceId Integer, OrderFinanceName TVarChar
             , BankAccountId Integer, BankAccountName TVarChar
             , BankId Integer, BankName TVarChar, BankAccountNameAll TVarChar, MFO TVarChar
             , WeekNumber TFloat

             , StartDate_WeekNumber TDateTime, EndDate_WeekNumber TDateTime

             , DateUpdate_report TDateTime
             , UserUpdate_report TVarChar
             , UserMember_1      TVarChar
             , UserMember_2      TVarChar
             , Comment_mov TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             , UnitName_insert     TVarChar
             , PositionName_insert TVarChar
             , Date_SignWait_1 TDateTime, Date_Sign_1 TDateTime
             , isSignWait_1 Boolean, isSign_1 Boolean

             , Date_SignSB TDateTime, isSignSB Boolean
             , FonColor_string Integer

               --
             , MovementItemId Integer
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , OKPO TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar, PersonalName_contract TVarChar
             , PaidKindName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, NumGroup Integer
             , Condition TVarChar, ContractStateKindCode Integer
             , StartDate TDateTime, EndDate_real TDateTime, EndDate TVarChar

               -- Нач. долг
             , AmountRemains TFloat
               -- Долг с отсрочкой
             , AmountPartner TFloat
               -- Приход
             , AmountSumm         TFloat
               -- Просроченный долг 7 дн.
             , AmountPartner_1    TFloat
             , AmountPartner_2    TFloat
             , AmountPartner_3    TFloat
             , AmountPartner_4    TFloat


               -- Первичный план на неделю - Предварительный План на неделю
             , Amount TFloat

               -- Платежный план на неделю
             , AmountPlan_next TFloat
             , OperDate_next   TDateTime

               -- Согласовано к оплате
             , Amount_Plan_day     TFloat

               -- Дата Согласовано к оплате
             , OperDate_Plan_day TDateTime, OperDate_Plan_day_old TDateTime
              -- Название дня недели
             , WeekDay TVarChar

               -- № в очереди на ***
             , Number_day         TFloat

               -- Согласовано - План оплат на 1.пн-5,пт
             , AmountPlan_1         TFloat
             , AmountPlan_2         TFloat
             , AmountPlan_3         TFloat
             , AmountPlan_4         TFloat
             , AmountPlan_5         TFloat

             , FonColor_AmountPlan_day  Integer
             , isAmountPlan_day   Boolean
             , Comment            TVarChar
             , Comment_pay        TVarChar
             , JuridicalOrderFinanceId Integer    -- JuridicalOrderFinance
             , Comment_jof             TVarChar   -- JuridicalOrderFinance
             , BankAccountId_jof Integer, BankAccountName_jof     TVarChar   -- JuridicalOrderFinance

             , BankId_jof Integer
             , BankName_jof TVarChar
             , MFO_jof      TVarChar
               -- 
             , MovementItemId_detail   Integer
               -- 
             , MovementItemId_child    Integer
             , InvNumber_Child         TVarChar
             , InvNumber_Invoice_Child TVarChar
             , GoodsName_Child         TVarChar
             , Comment_Child           TVarChar
             , Comment_SB_Child        TVarChar
             , isSign_Child            Boolean
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
                       WHERE Movement.DescId = zc_Movement_OrderFinance()
                         AND Movement.StatusId IN (SELECT tmpStatus.StatusId FROM tmpStatus)
                         AND Movement.OperDate BETWEEN inStartDate - INTERVAL '14 DAY' AND inEndDate
                      )

     , tmpMLO AS (SELECT * FROM MovementLinkObject AS MLO WHERE MLO.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement) AND MLO.DescId = zc_MovementLinkObject_OrderFinance())

     , tmpMI_Master AS (SELECT MovementItem.*
                        FROM MovementItem
                        WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                          AND MovementItem.DescId     = zc_MI_Master()
                          AND MovementItem.isErased   = FALSE
                          -- есть Juridical
                          AND MovementItem.ObjectId   <> 0
                       )
       -- Child - Данные с № заявки 1С + № Счета
     , tmpMI_Child AS (WITH
                       tmpMI_Child AS (SELECT MovementItem.*
                                       FROM MovementItem
                                       WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                         AND MovementItem.DescId     = zc_MI_Child()
                                         AND MovementItem.isErased   = FALSE
                                      )
 
                     , tmpMIFloat_Child AS (SELECT *
                                            FROM MovementItemFloat
                                            WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                                              AND MovementItemFloat.DescId IN (zc_MIFloat_AmountPlan_next()
                                                                              )
                                           )
                      , tmpMIDate_Child AS (SELECT *
                                            FROM MovementItemDate
                                            WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                                              AND MovementItemDate.DescId IN (zc_MIDate_Amount_next()
                                                                             )
                                            )
                    , tmpMIString_Child AS (SELECT *
                                            FROM MovementItemString
                                            WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                                              AND MovementItemString.DescId IN (zc_MIString_GoodsName()
                                                                              , zc_MIString_InvNumber()
                                                                              , zc_MIString_InvNumber_Invoice() 
                                                                              , zc_MIString_Comment()
                                                                              , zc_MIString_Comment_SB()
                                                                              )
                                           )

               , tmpMIBoolean_Child AS (SELECT *
                                        FROM MovementItemBoolean
                                        WHERE MovementItemBoolean.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                                          AND MovementItemBoolean.DescId IN (zc_MIBoolean_Sign()
                                                                           , zc_MIBoolean_AmountPlan_1()
                                                                           , zc_MIBoolean_AmountPlan_2()
                                                                           , zc_MIBoolean_AmountPlan_3()
                                                                           , zc_MIBoolean_AmountPlan_4()
                                                                           , zc_MIBoolean_AmountPlan_5()
                                                                            )
                                        )
                       -- Результат
                       SELECT MovementItem.Id
                            , MovementItem.ParentId
                            , MovementItem.MovementId
                              -- Первичный план на неделю
                            , MovementItem.Amount
                              -- Платежный план на неделю
                            , COALESCE (MIFloat_AmountPlan_next.ValueData, 0) AS AmountPlan_next
                              -- Дата Платежный план
                            , MIDate_Amount_next.ValueData                    AS OperDate_next

                              -- Согласовано к оплате
                            , COALESCE (MIFloat_AmountPlan_next.ValueData, 0) AS AmountPlan
                              -- Дата Согласовано к оплате
                            , MIDate_Amount_next.ValueData                    AS OperDate

                              -- Платим да/нет
                            , CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount_next.ValueData) = 1 THEN COALESCE (MIBoolean_AmountPlan_1.ValueData, TRUE)
                                   WHEN zfCalc_DayOfWeekNumber (MIDate_Amount_next.ValueData) = 2 THEN COALESCE (MIBoolean_AmountPlan_2.ValueData, TRUE)
                                   WHEN zfCalc_DayOfWeekNumber (MIDate_Amount_next.ValueData) = 3 THEN COALESCE (MIBoolean_AmountPlan_2.ValueData, TRUE)
                                   WHEN zfCalc_DayOfWeekNumber (MIDate_Amount_next.ValueData) = 4 THEN COALESCE (MIBoolean_AmountPlan_2.ValueData, TRUE)
                                   WHEN zfCalc_DayOfWeekNumber (MIDate_Amount_next.ValueData) = 5 THEN COALESCE (MIBoolean_AmountPlan_2.ValueData, TRUE)
                                   ELSE TRUE
                              END AS isAmountPlan
                              --
                            , MIString_InvNumber.ValueData               ::TVarChar AS InvNumber
                            , MIString_InvNumber_Invoice.ValueData       ::TVarChar AS InvNumber_Invoice
                            , MIString_GoodsName.ValueData               ::TVarChar AS GoodsName
                            , MIString_Comment.ValueData                 ::TVarChar AS Comment
                            , MIString_Comment_SB.ValueData              ::TVarChar AS Comment_SB
                            , COALESCE (MIBoolean_Sign.ValueData, FALSE) ::Boolean  AS isSign

                            , Object_Insert.ValueData          AS InsertName
                            , Object_Update.ValueData          AS UpdateName
                            , MIDate_Insert.ValueData          AS InsertDate
                            , MIDate_Update.ValueData          AS UpdateDate

                       FROM tmpMI_Child AS MovementItem
                            LEFT JOIN tmpMIFloat_Child AS MIFloat_AmountPlan_next
                                                       ON MIFloat_AmountPlan_next.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPlan_next.DescId = zc_MIFloat_AmountPlan_next()
                            LEFT JOIN tmpMIDate_Child AS MIDate_Amount_next
                                                      ON MIDate_Amount_next.MovementItemId = MovementItem.Id
                                                     AND MIDate_Amount_next.DescId = zc_MIDate_Amount_next()

                            LEFT JOIN tmpMIString_Child AS MIString_GoodsName
                                                        ON MIString_GoodsName.MovementItemId = MovementItem.Id
                                                       AND MIString_GoodsName.DescId = zc_MIString_GoodsName()
          
                            LEFT JOIN tmpMIString_Child AS MIString_InvNumber
                                                        ON MIString_InvNumber.MovementItemId = MovementItem.Id
                                                       AND MIString_InvNumber.DescId = zc_MIString_InvNumber()
                            LEFT JOIN tmpMIString_Child AS MIString_InvNumber_Invoice
                                                        ON MIString_InvNumber_Invoice.MovementItemId = MovementItem.Id
                                                       AND MIString_InvNumber_Invoice.DescId = zc_MIString_InvNumber_Invoice()

                            LEFT JOIN tmpMIString_Child AS MIString_Comment
                                                        ON MIString_Comment.MovementItemId = MovementItem.Id
                                                       AND MIString_Comment.DescId = zc_MIString_Comment()
                            LEFT JOIN tmpMIString_Child AS MIString_Comment_SB
                                                        ON MIString_Comment_SB.MovementItemId = MovementItem.Id
                                                       AND MIString_Comment_SB.DescId = zc_MIString_Comment_SB()

                            LEFT JOIN tmpMIBoolean_Child AS MIBoolean_Sign
                                                         ON MIBoolean_Sign.MovementItemId = MovementItem.Id
                                                        AND MIBoolean_Sign.DescId = zc_MIBoolean_Sign()
                            -- Платим (да/нет)
                            LEFT JOIN tmpMIBoolean_Child AS MIBoolean_AmountPlan_1
                                                         ON MIBoolean_AmountPlan_1.MovementItemId = MovementItem.Id
                                                        AND MIBoolean_AmountPlan_1.DescId = zc_MIBoolean_AmountPlan_1()
                            LEFT JOIN tmpMIBoolean_Child AS MIBoolean_AmountPlan_2
                                                         ON MIBoolean_AmountPlan_2.MovementItemId = MovementItem.Id
                                                        AND MIBoolean_AmountPlan_2.DescId = zc_MIBoolean_AmountPlan_2()
                            LEFT JOIN tmpMIBoolean_Child AS MIBoolean_AmountPlan_3
                                                         ON MIBoolean_AmountPlan_3.MovementItemId = MovementItem.Id
                                                        AND MIBoolean_AmountPlan_3.DescId = zc_MIBoolean_AmountPlan_3()
                            LEFT JOIN tmpMIBoolean_Child AS MIBoolean_AmountPlan_4
                                                         ON MIBoolean_AmountPlan_4.MovementItemId = MovementItem.Id
                                                        AND MIBoolean_AmountPlan_4.DescId = zc_MIBoolean_AmountPlan_4()
                            LEFT JOIN tmpMIBoolean_Child AS MIBoolean_AmountPlan_5
                                                         ON MIBoolean_AmountPlan_5.MovementItemId = MovementItem.Id
                                                        AND MIBoolean_AmountPlan_5.DescId = zc_MIBoolean_AmountPlan_5()

                            LEFT JOIN MovementItemDate AS MIDate_Insert
                                                       ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                      AND MIDate_Insert.DescId = zc_MIDate_Insert()
                            LEFT JOIN MovementItemDate AS MIDate_Update
                                                       ON MIDate_Update.MovementItemId = MovementItem.Id
                                                      AND MIDate_Update.DescId = zc_MIDate_Update()
     
                            LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                             ON MILO_Insert.MovementItemId = MovementItem.Id
                                                            AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId
                            LEFT JOIN MovementItemLinkObject AS MILO_Update
                                                             ON MILO_Update.MovementItemId = MovementItem.Id
                                                            AND MILO_Update.DescId = zc_MILinkObject_Update()
                            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILO_Update.ObjectId

                      )
      -- Detail - Согласовано к оплате
    , tmpMI_Detail AS (WITH tmpMI_Detail AS (SELECT MovementItem.*
                                             FROM MovementItem
                                             WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                               AND MovementItem.DescId     = zc_MI_Detail()
                                               AND MovementItem.isErased   = FALSE
                                            )
 
                      , tmpMIDate_d AS (SELECT *
                                            FROM MovementItemDate
                                            WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI_Detail.Id FROM tmpMI_Detail)
                                              AND MovementItemDate.DescId IN (zc_MIDate_Amount()
                                                                            , zc_MIDate_Insert()
                                                                            , zc_MIDate_Update()
                                                                             )
                                            )
               , tmpMIBoolean_d AS (SELECT *
                                        FROM MovementItemBoolean
                                        WHERE MovementItemBoolean.MovementItemId IN (SELECT DISTINCT tmpMI_Detail.Id FROM tmpMI_Detail)
                                          AND MovementItemBoolean.DescId IN (zc_MIBoolean_AmountPlan()
                                                                            )
                                        )
               , tmpMILO_d AS (SELECT *
                                        FROM MovementItemLinkObject
                                        WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_Detail.Id FROM tmpMI_Detail)
                                          AND MovementItemLinkObject.DescId IN (zc_MILinkObject_Insert()
                                                                              , zc_MILinkObject_Update()
                                                                               )
                                        )
                       -- Результат
                       SELECT MovementItem.Id
                            , MovementItem.ParentId
                            , MovementItem.MovementId
                              -- Согласовано к оплате
                            , MovementItem.Amount     AS AmountPlan
                              -- Дата Согласовано к оплате
                            , MIDate_Amount.ValueData AS OperDate
                              -- Платим да/нет
                            , COALESCE (MIBoolean_AmountPlan.ValueData, TRUE) AS isAmountPlan

                            , Object_Insert.ValueData          AS InsertName
                            , Object_Update.ValueData          AS UpdateName
                            , MIDate_Insert.ValueData          AS InsertDate
                            , MIDate_Update.ValueData          AS UpdateDate

                       FROM tmpMI_Detail AS MovementItem
                            -- Дата Согласовано к оплате
                            LEFT JOIN tmpMIDate_d AS MIDate_Amount
                                                  ON MIDate_Amount.MovementItemId = MovementItem.Id
                                                 AND MIDate_Amount.DescId         = zc_MIDate_Amount()
                            -- Платим (да/нет)
                            LEFT JOIN tmpMIBoolean_d AS MIBoolean_AmountPlan
                                                     ON MIBoolean_AmountPlan.MovementItemId = MovementItem.Id
                                                    AND MIBoolean_AmountPlan.DescId         = zc_MIBoolean_AmountPlan()

                            LEFT JOIN tmpMIDate_d AS MIDate_Insert
                                                  ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                 AND MIDate_Insert.DescId = zc_MIDate_Insert()
                            LEFT JOIN tmpMIDate_d AS MIDate_Update
                                                  ON MIDate_Update.MovementItemId = MovementItem.Id
                                                 AND MIDate_Update.DescId = zc_MIDate_Update()

                            LEFT JOIN tmpMILO_d AS MILO_Insert
                                                ON MILO_Insert.MovementItemId = MovementItem.Id
                                               AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId
                            LEFT JOIN tmpMILO_d AS MILO_Update
                                                ON MILO_Update.MovementItemId = MovementItem.Id
                                               AND MILO_Update.DescId = zc_MILinkObject_Update()
                            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILO_Update.ObjectId

                      )

     , tmpMILO_Contract AS (SELECT *
                            FROM MovementItemLinkObject
                            WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
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
     , tmpJuridicalDetails_View AS (SELECT * FROM ObjectHistory_JuridicalDetails_View WHERE ObjectHistory_JuridicalDetails_View.JuridicalId IN (SELECT DISTINCT tmpMI_Master.ObjectId FROM tmpMI_Master))

     , tmpMovementItemFloat AS (SELECT *
                                FROM MovementItemFloat
                                WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                                  AND MovementItemFloat.DescId IN (zc_MIFloat_AmountRemains()
                                                                 , zc_MIFloat_AmountPartner()
                                                                 , zc_MIFloat_AmountSumm()
                                                                 , zc_MIFloat_AmountPartner_1()
                                                                 , zc_MIFloat_AmountPartner_2()
                                                                 , zc_MIFloat_AmountPartner_3()
                                                                 , zc_MIFloat_AmountPartner_4()
                                                                 , zc_MIFloat_AmountPlan_1()
                                                                 , zc_MIFloat_AmountPlan_2()
                                                                 , zc_MIFloat_AmountPlan_3()
                                                                 , zc_MIFloat_AmountPlan_4()
                                                                 , zc_MIFloat_AmountPlan_5()
                                                                 , zc_MIFloat_AmountPlan_next()
                                                                  )
                               )

     , tmpMovementItemDate AS (SELECT *
                               FROM MovementItemDate
                               WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                                 AND MovementItemDate.DescId IN (zc_MIDate_Insert()
                                                               , zc_MIDate_Update()
                                                               , zc_MIDate_Amount_next()
                                                                )
                              )
     , tmpMovementItemLinkObject AS (SELECT *
                                     FROM MovementItemLinkObject
                                     WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                                       AND MovementItemLinkObject.DescId IN (zc_MILinkObject_Insert()
                                                                           , zc_MILinkObject_Update()
                                                                            )
                                    )
     , tmpMovementItemString AS (SELECT *
                                 FROM MovementItemString
                                 WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                                   AND MovementItemString.DescId IN (zc_MIString_Comment()
                                                                   , zc_MIString_Comment_Partner()
                                                                   , zc_MIString_Comment_Contract()
                                                                    )
                                )

     , tmpMovementItemBoolean AS (SELECT *
                                  FROM MovementItemBoolean
                                  WHERE MovementItemBoolean.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                                    AND MovementItemBoolean.DescId IN (zc_MIBoolean_AmountPlan_1()
                                                                     , zc_MIBoolean_AmountPlan_2()
                                                                     , zc_MIBoolean_AmountPlan_3()
                                                                     , zc_MIBoolean_AmountPlan_4()
                                                                     , zc_MIBoolean_AmountPlan_5()
                                                                      )
                                 )


       -- статьи для группировки
     , tmpOrderFinanceProperty AS (SELECT DISTINCT
                                          OrderFinanceProperty_OrderFinance.ChildObjectId          AS OrderFinanceId
                                        , OrderFinanceProperty_Object.ChildObjectId                AS Id
                                        , ObjectFloat_Group.ValueData                              AS NumGroup
                                        , COALESCE (ObjectBoolean_Group.ValueData,FALSE) ::Boolean AS isGroup
                                   FROM ObjectLink AS OrderFinanceProperty_OrderFinance
                                        INNER JOIN ObjectLink AS OrderFinanceProperty_Object
                                                              ON OrderFinanceProperty_Object.ObjectId = OrderFinanceProperty_OrderFinance.ObjectId
                                                             AND OrderFinanceProperty_Object.DescId = zc_ObjectLink_OrderFinanceProperty_Object()
                                                             AND COALESCE (OrderFinanceProperty_Object.ChildObjectId,0) <> 0

                                        INNER JOIN Object ON Object.Id = OrderFinanceProperty_Object.ObjectId
                                                         AND Object.isErased = False

                                        LEFT JOIN ObjectFloat AS ObjectFloat_Group
                                                              ON ObjectFloat_Group.ObjectId = OrderFinanceProperty_Object.ObjectId
                                                             AND ObjectFloat_Group.DescId = zc_ObjectFloat_OrderFinanceProperty_Group()

                                        LEFT JOIN ObjectBoolean AS ObjectBoolean_Group
                                                                ON ObjectBoolean_Group.ObjectId = OrderFinanceProperty_Object.ObjectId
                                                               AND ObjectBoolean_Group.DescId = zc_ObjectBoolean_OrderFinanceProperty_Group()
                                   WHERE OrderFinanceProperty_OrderFinance.DescId = zc_ObjectLink_OrderFinanceProperty_OrderFinance()
                                   )

      , tmpInfoMoney_OFP AS (SELECT DISTINCT Object_InfoMoney_View.InfoMoneyId
                                  , tmpOrderFinanceProperty.NumGroup
                                  , tmpOrderFinanceProperty.isGroup
                                  , tmpOrderFinanceProperty.OrderFinanceId
                             FROM Object_InfoMoney_View
                                  INNER JOIN tmpOrderFinanceProperty ON (tmpOrderFinanceProperty.Id = Object_InfoMoney_View.InfoMoneyId
                                                                      OR tmpOrderFinanceProperty.Id = Object_InfoMoney_View.InfoMoneyDestinationId
                                                                      OR tmpOrderFinanceProperty.Id = Object_InfoMoney_View.InfoMoneyGroupId
                                                                        )
                            )

 , tmpMI_Master_all AS (SELECT MovementItem.Id
                               -- Согласовано к оплате
                             , MIFloat_AmountPlan_day.ValueData    :: TFloat AS AmountPlan
                               -- Дата Согласовано к оплате
                             , inStartDate + INTERVAL '0 DAY' AS OperDate
                               -- Платим (да/нет)
                             , COALESCE (MIBoolean_AmountPlan_day.ValueData, TRUE) ::Boolean AS isAmountPlan

                        FROM tmpMI_Master AS MovementItem
                             INNER JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_day
                                                             ON MIFloat_AmountPlan_day.MovementItemId = MovementItem.Id
                                                            AND MIFloat_AmountPlan_day.DescId = zc_MIFloat_AmountPlan_1()
                             LEFT JOIN tmpMovementItemBoolean AS MIBoolean_AmountPlan_day
                                                              ON MIBoolean_AmountPlan_day.MovementItemId = MovementItem.Id
                                                             AND MIBoolean_AmountPlan_day.DescId = zc_MIBoolean_AmountPlan_1()
                        WHERE MIFloat_AmountPlan_day.ValueData <> 0

                       UNION ALL
                        SELECT MovementItem.Id
                               -- Согласовано к оплате
                             , MIFloat_AmountPlan_day.ValueData    :: TFloat AS AmountPlan
                               -- Дата Согласовано к оплате
                             , inStartDate + INTERVAL '1 DAY' AS OperDate
                               -- Платим (да/нет)
                             , COALESCE (MIBoolean_AmountPlan_day.ValueData, TRUE) ::Boolean AS isAmountPlan

                        FROM tmpMI_Master AS MovementItem
                             INNER JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_day
                                                             ON MIFloat_AmountPlan_day.MovementItemId = MovementItem.Id
                                                            AND MIFloat_AmountPlan_day.DescId = zc_MIFloat_AmountPlan_2()
                             LEFT JOIN tmpMovementItemBoolean AS MIBoolean_AmountPlan_day
                                                              ON MIBoolean_AmountPlan_day.MovementItemId = MovementItem.Id
                                                             AND MIBoolean_AmountPlan_day.DescId = zc_MIBoolean_AmountPlan_2()
                        WHERE MIFloat_AmountPlan_day.ValueData <> 0

                       UNION ALL
                        SELECT MovementItem.Id
                               -- Согласовано к оплате
                             , MIFloat_AmountPlan_day.ValueData    :: TFloat AS AmountPlan
                               -- Дата Согласовано к оплате
                             , inStartDate + INTERVAL '2 DAY' AS OperDate
                               -- Платим (да/нет)
                             , COALESCE (MIBoolean_AmountPlan_day.ValueData, TRUE) ::Boolean AS isAmountPlan

                        FROM tmpMI_Master AS MovementItem
                             INNER JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_day
                                                             ON MIFloat_AmountPlan_day.MovementItemId = MovementItem.Id
                                                            AND MIFloat_AmountPlan_day.DescId = zc_MIFloat_AmountPlan_3()
                             LEFT JOIN tmpMovementItemBoolean AS MIBoolean_AmountPlan_day
                                                              ON MIBoolean_AmountPlan_day.MovementItemId = MovementItem.Id
                                                             AND MIBoolean_AmountPlan_day.DescId = zc_MIBoolean_AmountPlan_3()
                        WHERE MIFloat_AmountPlan_day.ValueData <> 0

                       UNION ALL
                        SELECT MovementItem.Id
                               -- Согласовано к оплате
                             , MIFloat_AmountPlan_day.ValueData    :: TFloat AS AmountPlan
                               -- Дата Согласовано к оплате
                             , inStartDate + INTERVAL '3 DAY' AS OperDate
                               -- Платим (да/нет)
                             , COALESCE (MIBoolean_AmountPlan_day.ValueData, TRUE) ::Boolean AS isAmountPlan

                        FROM tmpMI_Master AS MovementItem
                             INNER JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_day
                                                             ON MIFloat_AmountPlan_day.MovementItemId = MovementItem.Id
                                                            AND MIFloat_AmountPlan_day.DescId = zc_MIFloat_AmountPlan_4()
                             LEFT JOIN tmpMovementItemBoolean AS MIBoolean_AmountPlan_day
                                                              ON MIBoolean_AmountPlan_day.MovementItemId = MovementItem.Id
                                                             AND MIBoolean_AmountPlan_day.DescId = zc_MIBoolean_AmountPlan_4()
                        WHERE MIFloat_AmountPlan_day.ValueData <> 0

                       UNION ALL
                        SELECT MovementItem.Id
                               -- Согласовано к оплате
                             , MIFloat_AmountPlan_day.ValueData    :: TFloat AS AmountPlan
                               -- Дата Согласовано к оплате
                             , inStartDate + INTERVAL '4 DAY' AS OperDate
                               -- Платим (да/нет)
                             , COALESCE (MIBoolean_AmountPlan_day.ValueData, TRUE) ::Boolean AS isAmountPlan

                        FROM tmpMI_Master AS MovementItem
                             INNER JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_day
                                                             ON MIFloat_AmountPlan_day.MovementItemId = MovementItem.Id
                                                            AND MIFloat_AmountPlan_day.DescId = zc_MIFloat_AmountPlan_5()
                             LEFT JOIN tmpMovementItemBoolean AS MIBoolean_AmountPlan_day
                                                              ON MIBoolean_AmountPlan_day.MovementItemId = MovementItem.Id
                                                             AND MIBoolean_AmountPlan_day.DescId = zc_MIBoolean_AmountPlan_5()
                        WHERE MIFloat_AmountPlan_day.ValueData <> 0
                       )
          -- Master + Child  + Detail
        , tmpMI AS (SELECT tmpMI_Master.Id
                         , tmpMI_Master.ObjectId
                         , tmpMI_Master.MovementId

                           -- Первичный план на неделю
                         , COALESCE (tmpMI_Child.Amount, tmpMI_Master.Amount) AS Amount

                           -- Платежный план на неделю
                         , COALESCE (tmpMI_Child.AmountPlan_next, MIFloat_AmountPlan_next.ValueData) :: TFloat    AS AmountPlan_next
                           -- Дата Платежный план
                         , COALESCE (tmpMI_Child.OperDate_next,   MIDate_Amount_next.ValueData)      :: TDateTime AS OperDate_next

                           -- Согласовано к оплате
                         , COALESCE (tmpMI_Detail_1.AmountPlan, tmpMI_Detail_2.AmountPlan, tmpMI_Child.AmountPlan, tmpMI_Master_all.AmountPlan) AS Amount_plan_day
                           -- ДатаСогласовано к оплате
                         , COALESCE (tmpMI_Detail_1.OperDate, tmpMI_Detail_2.OperDate, tmpMI_Child.OperDate, tmpMI_Master_all.OperDate)         AS OperDate_plan_day

                           -- Платим да/нет
                         , COALESCE (tmpMI_Detail_1.isAmountPlan, tmpMI_Detail_2.isAmountPlan, tmpMI_Child.isAmountPlan, tmpMI_Master_all.isAmountPlan, TRUE) AS isAmountPlan_day

                         , COALESCE (tmpMI_Child.InsertName, Object_Insert.ValueData) AS InsertName
                         , COALESCE (tmpMI_Child.InsertDate, MIDate_Insert.ValueData) AS InsertDate

                         , COALESCE (tmpMI_Detail_1.UpdateName, tmpMI_Detail_2.UpdateName, tmpMI_Child.UpdateName, Object_Update.ValueData) AS UpdateName
                         , COALESCE (tmpMI_Detail_1.UpdateDate, tmpMI_Detail_2.UpdateDate, tmpMI_Child.UpdateDate, MIDate_Update.ValueData) AS UpdateDate

                           --
                         , COALESCE (tmpMI_Detail_1.Id, tmpMI_Detail_2.Id) AS Id_Detail

                           --
                         , tmpMI_Child.Id                AS Id_child
                         , tmpMI_Child.InvNumber         AS InvNumber_Child
                         , tmpMI_Child.InvNumber_Invoice AS InvNumber_Invoice_Child
                         , tmpMI_Child.GoodsName         AS GoodsName_Child
                         , tmpMI_Child.Comment           AS Comment_Child
                         , tmpMI_Child.Comment_SB        AS Comment_SB_Child
                         , tmpMI_Child.isSign            AS isSign_Child

                           -- № п/п - какие данные мастера выводить 1 раз
                         , ROW_NUMBER() OVER (PARTITION BY tmpMI_Master.Id ORDER BY tmpMI_Child.Id ASC) AS Ord_master

                           -- № п/п - какие данные Первичный план + Первичный план выводить 1 раз
                         , ROW_NUMBER() OVER (PARTITION BY tmpMI_Master.Id, tmpMI_Child.Id ORDER BY COALESCE (tmpMI_Detail_1.Id, tmpMI_Detail_2.Id, 0) ASC) AS Ord_child

                    FROM tmpMI_Master
                         -- Master - такой
                         LEFT JOIN tmpMI_Master_all ON tmpMI_Master_all.Id = tmpMI_Master.Id -- AND 1=1

                         -- Child - Данные с № заявки 1С + ...
                         LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpMI_Master.Id
                         -- Detail-1 - Согласовано к оплате
                         LEFT JOIN tmpMI_Detail AS tmpMI_Detail_1 ON tmpMI_Detail_1.ParentId = tmpMI_Master.Id
                         -- Detail-2 - Согласовано к оплате
                         LEFT JOIN tmpMI_Detail AS tmpMI_Detail_2 ON tmpMI_Detail_2.ParentId = tmpMI_Child.Id

                         -- Платежный план на неделю
                         LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_next
                                                        ON MIFloat_AmountPlan_next.MovementItemId = tmpMI_Master.Id
                                                       AND MIFloat_AmountPlan_next.DescId         = zc_MIFloat_AmountPlan_next()
                         -- Дата Платежный план
                         LEFT JOIN tmpMovementItemDate AS MIDate_Amount_next
                                                       ON MIDate_Amount_next.MovementItemId = tmpMI_Master.Id
                                                      AND MIDate_Amount_next.DescId         = zc_MIDate_Amount_next()

                         LEFT JOIN tmpMovementItemDate AS MIDate_Insert
                                                       ON MIDate_Insert.MovementItemId = tmpMI_Master.Id
                                                      AND MIDate_Insert.DescId = zc_MIDate_Insert()
                         LEFT JOIN tmpMovementItemDate AS MIDate_Update
                                                       ON MIDate_Update.MovementItemId = tmpMI_Master.Id
                                                      AND MIDate_Update.DescId = zc_MIDate_Update()
                         LEFT JOIN tmpMovementItemLinkObject AS MILO_Insert
                                                             ON MILO_Insert.MovementItemId = tmpMI_Master.Id
                                                            AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                         LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId

                         LEFT JOIN tmpMovementItemLinkObject AS MILO_Update
                                                             ON MILO_Update.MovementItemId = tmpMI_Master.Id
                                                            AND MILO_Update.DescId = zc_MILinkObject_Update()
                         LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILO_Update.ObjectId

                   )

      , tmpMI_Data AS (SELECT MovementItem.MovementId
                            , MovementItem.Id                  AS Id
                            , zfCalc_DayOfWeekNumber (MovementItem.OperDate_plan_day) AS NumDay
                            , Object_Juridical.Id              AS JuridicalId
                            , Object_Juridical.ObjectCode      AS JuridicalCode
                            , Object_Juridical.ValueData       AS JuridicalName
                            , tmpJuridicalDetails_View.OKPO
                            , Object_Contract.Id               AS ContractId
                            , Object_Contract.ObjectCode       AS ContractCode
                            , Object_Contract.ValueData        AS ContractName

                            , CASE WHEN View_Contract.PaidKindId > 0 THEN Object_PaidKind.ValueData
                                   WHEN COALESCE (ObjectBoolean_OrderFinance_OperDate.ValueData, FALSE) = FALSE THEN Object_PaidKind_1.ValueData
                                   WHEN Object_InfoMoney.Id = MovementItem.ObjectId THEN Object_PaidKind_2.ValueData
                              END :: TVarChar AS PaidKindName

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


                            , MIFloat_AmountRemains.ValueData   :: TFloat AS AmountRemains
                            , MIFloat_AmountPartner.ValueData   :: TFloat AS AmountPartner
                            , MIFloat_AmountSumm.ValueData      :: TFloat AS AmountSumm

                            , MIFloat_AmountPartner_1.ValueData :: TFloat AS AmountPartner_1
                            , MIFloat_AmountPartner_2.ValueData :: TFloat AS AmountPartner_2
                            , MIFloat_AmountPartner_3.ValueData :: TFloat AS AmountPartner_3
                            , MIFloat_AmountPartner_4.ValueData :: TFloat AS AmountPartner_4

                              -- Первичный план на неделю
                            , CASE WHEN MovementItem.Ord_child = 1 THEN MovementItem.Amount ELSE 0 END :: TFloat AS Amount

                              -- Платежный план на неделю
                            , CASE WHEN MovementItem.Ord_child = 1 THEN MovementItem.AmountPlan_next ELSE 0 END :: TFloat AS AmountPlan_next
                              -- Дата Платежный план
                            , MovementItem.OperDate_next

                              -- Согласовано к оплате
                            , MovementItem.Amount_plan_day AS Amount_plan_day
                            , MovementItem.OperDate_plan_day AS OperDate_plan_day

                              -- Платим (да/нет)
                            , COALESCE (MovementItem.isAmountPlan_day, TRUE) ::Boolean AS isAmountPlan_day

                            , MIString_Comment.ValueData          AS Comment
                            , MIString_Comment_Partner.ValueData  AS Comment_Partner
                            , MIString_Comment_Contract.ValueData AS Comment_Contract

                            , MovementItem.InsertName
                            , MovementItem.UpdateName
                            , MovementItem.InsertDate
                            , MovementItem.UpdateDate

                             --
                           , MovementItem.Id_Detail
                             --
                           , MovementItem.Id_child
                           , MovementItem.InvNumber_Child
                           , MovementItem.InvNumber_Invoice_Child
                           , MovementItem.GoodsName_Child
                           , MovementItem.Comment_Child
                           , MovementItem.Comment_SB_Child
                           , MovementItem.isSign_Child

                        FROM tmpMI AS MovementItem
                             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementItem.ObjectId
                                                                 AND Object_Juridical.DescId = zc_Object_Juridical()

                             LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountRemains
                                                            ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                                           AND MIFloat_AmountRemains.DescId = zc_MIFloat_AmountRemains()
                                                           AND MovementItem.Ord_master = 1

                             LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPartner
                                                            ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                           AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                                           AND MovementItem.Ord_master = 1

                             LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPartner_1
                                                            ON MIFloat_AmountPartner_1.MovementItemId = MovementItem.Id
                                                           AND MIFloat_AmountPartner_1.DescId = zc_MIFloat_AmountPartner_1()
                                                           AND MovementItem.Ord_master = 1

                             LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPartner_2
                                                            ON MIFloat_AmountPartner_2.MovementItemId = MovementItem.Id
                                                           AND MIFloat_AmountPartner_2.DescId = zc_MIFloat_AmountPartner_2()
                                                           AND MovementItem.Ord_master = 1

                             LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPartner_3
                                                            ON MIFloat_AmountPartner_3.MovementItemId = MovementItem.Id
                                                           AND MIFloat_AmountPartner_3.DescId = zc_MIFloat_AmountPartner_3()
                                                           AND MovementItem.Ord_master = 1

                             LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPartner_4
                                                            ON MIFloat_AmountPartner_4.MovementItemId = MovementItem.Id
                                                           AND MIFloat_AmountPartner_4.DescId = zc_MIFloat_AmountPartner_4()
                                                           AND MovementItem.Ord_master = 1

                             LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountSumm
                                                            ON MIFloat_AmountSumm.MovementItemId = MovementItem.Id
                                                           AND MIFloat_AmountSumm.DescId         = zc_MIFloat_AmountSumm()
                                                           AND MovementItem.Ord_master = 1

                             LEFT JOIN tmpMovementItemString AS MIString_Comment
                                                             ON MIString_Comment.MovementItemId = MovementItem.Id
                                                            AND MIString_Comment.DescId = zc_MIString_Comment()

                            LEFT JOIN tmpMovementItemString AS MIString_Comment_Partner
                                                            ON MIString_Comment_Partner.MovementItemId = MovementItem.Id
                                                           AND MIString_Comment_Partner.DescId         = zc_MIString_Comment_Partner()
                            LEFT JOIN tmpMovementItemString AS MIString_Comment_Contract
                                                            ON MIString_Comment_Contract.MovementItemId = MovementItem.Id
                                                           AND MIString_Comment_Contract.DescId         = zc_MIString_Comment_Contract()

                             LEFT JOIN tmpMILO_Contract AS MILinkObject_Contract
                                                        ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                             LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MILinkObject_Contract.ObjectId


                             LEFT JOIN tmpJuridicalDetails_View ON tmpJuridicalDetails_View.JuridicalId = Object_Juridical.Id

                             LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                                  ON ObjectLink_Contract_InfoMoney.ObjectId = Object_Contract.Id
                                                 AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                             LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = CASE WHEN Object_Juridical.DescId IN (zc_Object_Juridical(), zc_Object_Partner()) THEN ObjectLink_Contract_InfoMoney.ChildObjectId ELSE MovementItem.ObjectId END

                             LEFT JOIN tmpMLO AS MovementLinkObject_OrderFinance
                                              ON MovementLinkObject_OrderFinance.MovementId = MovementItem.MovementId
                                             AND MovementLinkObject_OrderFinance.DescId = zc_MovementLinkObject_OrderFinance()
                             -- Заполнение дата предварительный план (да/нет)
                             LEFT JOIN ObjectBoolean AS ObjectBoolean_OrderFinance_OperDate
                                                     ON ObjectBoolean_OrderFinance_OperDate.ObjectId = MovementLinkObject_OrderFinance.ObjectId
                                                    AND ObjectBoolean_OrderFinance_OperDate.DescId = zc_ObjectBoolean_OrderFinance_OperDate()

                             LEFT JOIN tmpContract_View AS View_Contract ON View_Contract.ContractId = Object_Contract.Id
                             LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = View_Contract.PaidKindId
                                                                                       /*CASE WHEN View_Contract.PaidKindId > 0 THEN View_Contract.PaidKindId
                                                                                              WHEN COALESCE (ObjectBoolean_OrderFinance_OperDate.ValueData, FALSE) = FALSE THEN zc_Enum_PaidKind_FirstForm()
                                                                                              WHEN Object_InfoMoney.Id = MovementItem.ObjectId THEN zc_Enum_PaidKind_SecondForm()
                                                                                         END*/
                             LEFT JOIN Object AS Object_PaidKind_1 ON Object_PaidKind_1.Id = zc_Enum_PaidKind_FirstForm()
                             LEFT JOIN Object AS Object_PaidKind_2 ON Object_PaidKind_2.Id = zc_Enum_PaidKind_SecondForm()

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

                          , Movement.WeekNumber              ::TFloat    AS WeekNumber

                          , zfCalc_Week_StartDate (Movement.OperDate, MovementFloat_WeekNumber.ValueData) AS StartDate_WeekNumber
                          , zfCalc_Week_EndDate   (Movement.OperDate, MovementFloat_WeekNumber.ValueData) AS EndDate_WeekNumber

                          , MovementDate_Update_report.ValueData ::TDateTime AS DateUpdate_report
                          , Object_Update_report.ValueData       ::TVarChar  AS UserUpdate_report
                          , Object_Member_1.ValueData            ::TVarChar  AS UserMember_1
                          , Object_Member_2.ValueData            ::TVarChar  AS UserMember_2

                          , MovementString_Comment.ValueData       AS Comment

                          , Object_Insert.ValueData                AS InsertName
                          , MovementDate_Insert.ValueData          AS InsertDate
                          , Object_Update.ValueData                AS UpdateName
                          , MovementDate_Update.ValueData          AS UpdateDate

                          , Object_Unit_insert.ValueData      ::TVarChar AS UnitName_insert
                          , Object_Position_insert.ValueData  ::TVarChar AS PositionName_insert

                          , COALESCE (MovementDate_SignWait_1.ValueData, NULL)     ::TDateTime AS Date_SignWait_1
                          , COALESCE (MovementDate_Sign_1.ValueData, NULL)         ::TDateTime AS Date_Sign_1
                          , COALESCE (MovementBoolean_SignWait_1.ValueData, FALSE) ::Boolean   AS isSignWait_1
                          , COALESCE (MovementBoolean_Sign_1.ValueData, FALSE)     ::Boolean   AS isSign_1

                          , COALESCE (MovementDate_SignSB.ValueData, NULL)         ::TDateTime AS Date_SignSB
                          , COALESCE (MovementBoolean_SignSB.ValueData, FALSE)     ::Boolean   AS isSignSB

                          , CASE WHEN Object_Status.Id = zc_Enum_Status_UnComplete() AND COALESCE (ObjectBoolean_Status_off.ValueData, FALSE) <> TRUE
                                     THEN zc_Color_Yelow()
                                 WHEN COALESCE (MovementBoolean_Sign_1.ValueData, FALSE) = FALSE
                                 OR (COALESCE (ObjectBoolean_SB.ValueData, FALSE) = TRUE AND COALESCE (MovementBoolean_SignSB.ValueData, FALSE) = FALSE)
                                     THEN zc_Color_Aqua()

                                 ELSE zc_Color_White()
                            END  ::Integer AS FonColor_string

                      FROM tmpMovement AS Movement

                           LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

                           LEFT JOIN MovementFloat AS MovementFloat_WeekNumber
                                                   ON MovementFloat_WeekNumber.MovementId = Movement.Id
                                                  AND MovementFloat_WeekNumber.DescId = zc_MovementFloat_WeekNumber()

                           LEFT JOIN MovementString AS MovementString_Comment
                                                    ON MovementString_Comment.MovementId = Movement.Id
                                                   AND MovementString_Comment.DescId = zc_MovementString_Comment()

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_OrderFinance
                                                        ON MovementLinkObject_OrderFinance.MovementId = Movement.Id
                                                       AND MovementLinkObject_OrderFinance.DescId = zc_MovementLinkObject_OrderFinance()
                           LEFT JOIN Object AS Object_OrderFinance ON Object_OrderFinance.Id = MovementLinkObject_OrderFinance.ObjectId

                           LEFT JOIN ObjectBoolean AS ObjectBoolean_SB
                                                   ON ObjectBoolean_SB.ObjectId = MovementLinkObject_OrderFinance.ObjectId
                                                  AND ObjectBoolean_SB.DescId = zc_ObjectBoolean_OrderFinance_SB()
                           LEFT JOIN ObjectBoolean AS ObjectBoolean_Status_off
                                                   ON ObjectBoolean_Status_off.ObjectId = MovementLinkObject_OrderFinance.ObjectId
                                                  AND ObjectBoolean_Status_off.DescId = zc_ObjectBoolean_OrderFinance_Status_off()

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

                           LEFT JOIN MovementDate AS MovementDate_Update_report
                                                  ON MovementDate_Update_report.MovementId = Movement.Id
                                                 AND MovementDate_Update_report.DescId = zc_MovementDate_Update_report()

                           LEFT JOIN MovementDate AS MovementDate_Insert
                                                  ON MovementDate_Insert.MovementId = Movement.Id
                                                 AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
                           LEFT JOIN MovementDate AS MovementDate_Update
                                                  ON MovementDate_Update.MovementId = Movement.Id
                                                 AND MovementDate_Update.DescId = zc_MovementDate_Update()

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                                        ON MovementLinkObject_Insert.MovementId = Movement.Id
                                                       AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
                           LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Update
                                                        ON MovementLinkObject_Update.MovementId = Movement.Id
                                                       AND MovementLinkObject_Update.DescId = zc_MovementLinkObject_Update()
                           LEFT JOIN Object AS Object_Update ON Object_Update.Id = MovementLinkObject_Update.ObjectId

                           LEFT JOIN MovementDate AS MovementDate_SignWait_1
                                                  ON MovementDate_SignWait_1.MovementId = Movement.Id
                                                 AND MovementDate_SignWait_1.DescId = zc_MovementDate_SignWait_1()
                           LEFT JOIN MovementDate AS MovementDate_Sign_1
                                                  ON MovementDate_Sign_1.MovementId = Movement.Id
                                                 AND MovementDate_Sign_1.DescId = zc_MovementDate_Sign_1()
                           LEFT JOIN MovementBoolean AS MovementBoolean_SignWait_1
                                                     ON MovementBoolean_SignWait_1.MovementId = Movement.Id
                                                    AND MovementBoolean_SignWait_1.DescId = zc_MovementBoolean_SignWait_1()
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

   , tmpJuridicalOrderFinance AS (SELECT Object_JuridicalOrderFinance.Id                   AS JuridicalOrderFinanceId
                                       , OL_JuridicalOrderFinance_Juridical.ChildObjectId  AS JuridicalId

                                       , Main_BankAccount_View.BankId     AS BankId_main
                                       , Main_BankAccount_View.BankName   AS BankName_main
                                       , Main_BankAccount_View.MFO        AS MFO_main
                                       , Main_BankAccount_View.Id         AS BankAccountId_main
                                       , Main_BankAccount_View.Name       AS BankAccountName_main
                                       , (Main_BankAccount_View.BankName || '' || Main_BankAccount_View.Name) :: TVarChar AS BankAccountNameAll_main
                                       , Partner_BankAccount_View.BankId
                                       , Partner_BankAccount_View.BankName
                                       , Partner_BankAccount_View.MFO
                                       , Partner_BankAccount_View.Id      AS BankAccountId
                                       , Partner_BankAccount_View.Name    AS BankAccountName
                                       , OL_JuridicalOrderFinance_InfoMoney.ChildObjectId AS InfoMoneyId
                                       , ObjectFloat_SummOrderFinance.ValueData :: TFloat AS SummOrderFinance
                                       , ObjectString_Comment.ValueData         :: TVarChar AS Comment
                                         -- № п/п
                                       , ROW_NUMBER() OVER (PARTITION BY OL_JuridicalOrderFinance_Juridical.ChildObjectId
                                                                       , OL_JuridicalOrderFinance_InfoMoney.ChildObjectId
                                                            ORDER BY CASE WHEN ObjectString_Comment.ValueData ILIKE '%SUMMA_P%' THEN 0 ELSE 1 END
                                                                   , CASE WHEN ObjectString_Comment.ValueData <>    ''          THEN 0 ELSE 1 END
                                                                   , ObjectDate_OperDate.ValueData DESC
                                                           ) AS Ord
                                  FROM Object AS Object_JuridicalOrderFinance
                                       LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_Juridical
                                                            ON OL_JuridicalOrderFinance_Juridical.ObjectId = Object_JuridicalOrderFinance.Id
                                                           AND OL_JuridicalOrderFinance_Juridical.DescId = zc_ObjectLink_JuridicalOrderFinance_Juridical()

                                       LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_BankAccountMain
                                                            ON OL_JuridicalOrderFinance_BankAccountMain.ObjectId = Object_JuridicalOrderFinance.Id
                                                           AND OL_JuridicalOrderFinance_BankAccountMain.DescId = zc_ObjectLink_JuridicalOrderFinance_BankAccountMain()
                                       LEFT JOIN Object_BankAccount_View AS Main_BankAccount_View ON Main_BankAccount_View.Id = OL_JuridicalOrderFinance_BankAccountMain.ChildObjectId

                                       LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_BankAccount
                                                            ON OL_JuridicalOrderFinance_BankAccount.ObjectId = Object_JuridicalOrderFinance.Id
                                                           AND OL_JuridicalOrderFinance_BankAccount.DescId = zc_ObjectLink_JuridicalOrderFinance_BankAccount()
                                       LEFT JOIN Object_BankAccount_View AS Partner_BankAccount_View ON Partner_BankAccount_View.Id = OL_JuridicalOrderFinance_BankAccount.ChildObjectId

                                       LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_InfoMoney
                                                            ON OL_JuridicalOrderFinance_InfoMoney.ObjectId = Object_JuridicalOrderFinance.Id
                                                           AND OL_JuridicalOrderFinance_InfoMoney.DescId = zc_ObjectLink_JuridicalOrderFinance_InfoMoney()

                                       LEFT JOIN ObjectFloat AS ObjectFloat_SummOrderFinance
                                                             ON ObjectFloat_SummOrderFinance.ObjectId = Object_JuridicalOrderFinance.Id
                                                            AND ObjectFloat_SummOrderFinance.DescId = zc_ObjectFloat_JuridicalOrderFinance_SummOrderFinance()

                                       LEFT JOIN ObjectString AS ObjectString_Comment
                                                              ON ObjectString_Comment.ObjectId = Object_JuridicalOrderFinance.Id
                                                             AND ObjectString_Comment.DescId = zc_ObjectString_JuridicalOrderFinance_Comment()

                                       LEFT JOIN ObjectDate AS ObjectDate_OperDate
                                                            ON ObjectDate_OperDate.ObjectId = Object_JuridicalOrderFinance.Id
                                                           AND ObjectDate_OperDate.DescId = zc_ObjectDate_JuridicalOrderFinance_OperDate()
                                  WHERE Object_JuridicalOrderFinance.DescId = zc_Object_JuridicalOrderFinance()
                                   AND Object_JuridicalOrderFinance.isErased = FALSE
                                   -- !!! по Этому банку
                                   AND Main_BankAccount_View.BankId = inBankMainId
                                   AND inBankMainId <> 0
                                   -- !!! НЕ ОТКЛЮЧЕНО
                                   AND 1=1
                                 )
   , tmpJuridicalOrderFinance_last AS (SELECT Object_JuridicalOrderFinance.Id  AS JuridicalOrderFinanceId
                                            , OL_JuridicalOrderFinance_Juridical.ChildObjectId       AS JuridicalId

                                            , Main_BankAccount_View.BankId     AS BankId_main
                                            , Main_BankAccount_View.BankName   AS BankName_main
                                            , Main_BankAccount_View.MFO        AS MFO_main
                                            , Main_BankAccount_View.Id         AS BankAccountId_main
                                            , Main_BankAccount_View.Name       AS BankAccountName_main
                                            , (Main_BankAccount_View.BankName || '' || Main_BankAccount_View.Name) :: TVarChar AS BankAccountNameAll_main
                                            , Partner_BankAccount_View.BankId
                                            , Partner_BankAccount_View.BankName
                                            , Partner_BankAccount_View.MFO
                                            , Partner_BankAccount_View.Id      AS BankAccountId
                                            , Partner_BankAccount_View.Name    AS BankAccountName
                                            , OL_JuridicalOrderFinance_InfoMoney.ChildObjectId AS InfoMoneyId
                                            , ObjectFloat_SummOrderFinance.ValueData :: TFloat AS SummOrderFinance
                                            , ObjectString_Comment.ValueData         :: TVarChar AS Comment
                                              -- № п/п
                                            , ROW_NUMBER() OVER (PARTITION BY OL_JuridicalOrderFinance_Juridical.ChildObjectId
                                                                            , OL_JuridicalOrderFinance_InfoMoney.ChildObjectId
                                                                 ORDER BY CASE WHEN ObjectString_Comment.ValueData ILIKE '%SUMMA_P%' THEN 0 ELSE 1 END
                                                                        , CASE WHEN ObjectString_Comment.ValueData <>    ''          THEN 0 ELSE 1 END
                                                                        , ObjectDate_OperDate.ValueData DESC
                                                                ) AS Ord
                                       FROM Object AS Object_JuridicalOrderFinance
                                            LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_Juridical
                                                                 ON OL_JuridicalOrderFinance_Juridical.ObjectId = Object_JuridicalOrderFinance.Id
                                                                AND OL_JuridicalOrderFinance_Juridical.DescId = zc_ObjectLink_JuridicalOrderFinance_Juridical()

                                            LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_BankAccountMain
                                                                 ON OL_JuridicalOrderFinance_BankAccountMain.ObjectId = Object_JuridicalOrderFinance.Id
                                                                AND OL_JuridicalOrderFinance_BankAccountMain.DescId = zc_ObjectLink_JuridicalOrderFinance_BankAccountMain()
                                            LEFT JOIN Object_BankAccount_View AS Main_BankAccount_View ON Main_BankAccount_View.Id = OL_JuridicalOrderFinance_BankAccountMain.ChildObjectId

                                            LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_BankAccount
                                                                 ON OL_JuridicalOrderFinance_BankAccount.ObjectId = Object_JuridicalOrderFinance.Id
                                                                AND OL_JuridicalOrderFinance_BankAccount.DescId = zc_ObjectLink_JuridicalOrderFinance_BankAccount()
                                            LEFT JOIN Object_BankAccount_View AS Partner_BankAccount_View ON Partner_BankAccount_View.Id = OL_JuridicalOrderFinance_BankAccount.ChildObjectId

                                            LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_InfoMoney
                                                                 ON OL_JuridicalOrderFinance_InfoMoney.ObjectId = Object_JuridicalOrderFinance.Id
                                                                AND OL_JuridicalOrderFinance_InfoMoney.DescId = zc_ObjectLink_JuridicalOrderFinance_InfoMoney()

                                            LEFT JOIN ObjectFloat AS ObjectFloat_SummOrderFinance
                                                                  ON ObjectFloat_SummOrderFinance.ObjectId = Object_JuridicalOrderFinance.Id
                                                                 AND ObjectFloat_SummOrderFinance.DescId = zc_ObjectFloat_JuridicalOrderFinance_SummOrderFinance()

                                            LEFT JOIN ObjectString AS ObjectString_Comment
                                                                   ON ObjectString_Comment.ObjectId = Object_JuridicalOrderFinance.Id
                                                                  AND ObjectString_Comment.DescId = zc_ObjectString_JuridicalOrderFinance_Comment()

                                            LEFT JOIN ObjectDate AS ObjectDate_OperDate
                                                                 ON ObjectDate_OperDate.ObjectId = Object_JuridicalOrderFinance.Id
                                                                AND ObjectDate_OperDate.DescId = zc_ObjectDate_JuridicalOrderFinance_OperDate()
                                       WHERE Object_JuridicalOrderFinance.DescId = zc_Object_JuridicalOrderFinance()
                                         AND Object_JuridicalOrderFinance.isErased = FALSE
                                     -- AND inBankMainId = 0
                                      )
   -- Результат
   SELECT tmpMovement.MovementId
        , tmpMovement.InvNumber
        , tmpMovement.OperDate
        , tmpMovement.StatusCode
        , tmpMovement.StatusName
        , tmpMovement.OrderFinanceId
        , tmpMovement.OrderFinanceName

        , COALESCE (tmpJuridicalOrderFinance.BankAccountId_main, tmpJuridicalOrderFinance_last.BankAccountId_main)          ::Integer  AS BankAccountId
        , COALESCE (tmpJuridicalOrderFinance.BankAccountName_main, tmpJuridicalOrderFinance_last.BankAccountName_main)      ::TVarChar AS BankAccountName
        , COALESCE (tmpJuridicalOrderFinance.BankId_main, tmpJuridicalOrderFinance_last.BankId_main)                        ::Integer  AS BankId
        , COALESCE (tmpJuridicalOrderFinance.BankName_main, tmpJuridicalOrderFinance_last.BankName_main)                    ::TVarChar AS BankName
        , COALESCE (tmpJuridicalOrderFinance.BankAccountNameAll_main, tmpJuridicalOrderFinance_last.BankAccountNameAll_main)::TVarChar AS BankAccountNameAll
        , COALESCE (tmpJuridicalOrderFinance.MFO_main, tmpJuridicalOrderFinance_last.MFO_main)                              ::TVarChar AS MFO

        , tmpMovement.WeekNumber
        , tmpMovement.StartDate_WeekNumber ::TDateTime
        , tmpMovement.EndDate_WeekNumber   ::TDateTime  --20

        , tmpMovement.DateUpdate_report ::TDateTime
        , tmpMovement.UserUpdate_report ::TVarChar

        , tmpMovement.UserMember_1      ::TVarChar
        , tmpMovement.UserMember_2      ::TVarChar

        , tmpMovement.Comment           ::TVarChar  AS Comment_mov

        , CASE WHEN vbUserId = 5 AND 1=0 THEN 'ФИО Автор' ELSE tmpMovement.InsertName END :: TVarChar AS InsertName
        , tmpMovement.InsertDate
        , tmpMovement.UpdateName
        , tmpMovement.UpdateDate

        , tmpMovement.UnitName_insert      ::TVarChar
        , tmpMovement.PositionName_insert  ::TVarChar

        , tmpMovement.Date_SignWait_1 ::TDateTime
        , tmpMovement.Date_Sign_1     ::TDateTime
        , CASE WHEN tmpMovement.isSign_1 = TRUE THEN FALSE ELSE tmpMovement.isSignWait_1 END :: Boolean
        , tmpMovement.isSign_1        ::Boolean

        , tmpMovement.Date_SignSB     ::TDateTime
        , tmpMovement.isSignSB        ::Boolean
        , tmpMovement.FonColor_string ::Integer

          --
        , tmpMI.Id AS MovementItemId
        , tmpMI.JuridicalId
        , tmpMI.JuridicalCode
        , CASE WHEN tmpMI.JuridicalName <> '' THEN tmpMI.JuridicalName ELSE tmpMI.Comment_Partner END :: TVarChar AS JuridicalName
        , tmpMI.OKPO
        , tmpMI.ContractId
        , tmpMI.ContractCode
        , CASE WHEN tmpMI.ContractName <> '' THEN tmpMI.ContractName ELSE tmpMI.Comment_Contract END :: TVarChar AS ContractName
        , tmpMI.PersonalName_contract  ::TVarChar
        , tmpMI.PaidKindName
        , tmpMI.InfoMoneyId
        , tmpMI.InfoMoneyCode
        , tmpMI.InfoMoneyName
        --, tmpMI.NumGroup
        --, tmpMI.Condition              ::TVarChar
        , COALESCE (tmpInfoMoney_OFP.NumGroup, Null) ::Integer AS NumGroup
        , tmpContractCondition.Condition       ::TVarChar AS Condition
        , tmpMI.ContractStateKindCode  ::Integer
        , tmpMI.StartDate              ::TDateTime
        , tmpMI.EndDate_real           ::TDateTime
        , tmpMI.EndDate                ::TVarChar

          -- Нач. долг
        , tmpMI.AmountRemains   :: TFloat AS AmountRemains
          -- Долг с отсрочкой
        , tmpMI.AmountPartner   :: TFloat AS AmountPartner
          -- Приход
        , tmpMI.AmountSumm      :: TFloat AS AmountSumm
          -- Просроченный долг 7 дн.
        , tmpMI.AmountPartner_1 :: TFloat AS AmountPartner_1
        , tmpMI.AmountPartner_2 :: TFloat AS AmountPartner_2
        , tmpMI.AmountPartner_3 :: TFloat AS AmountPartner_3
        , tmpMI.AmountPartner_4 :: TFloat AS AmountPartner_4

          -- Первичный план на неделю
        , tmpMI.Amount          :: TFloat AS Amount
          -- Платежный план на неделю
        , tmpMI.AmountPlan_next :: TFloat    AS AmountPlan_next
        , tmpMI.OperDate_next   :: TDateTime AS OperDate_next

          -- Согласовано к оплате
        , tmpMI.Amount_Plan_day    :: TFloat

          -- Дата Согласовано к оплате
        , tmpMI.OperDate_Plan_day ::TDateTime AS OperDate_Plan_day
        , tmpMI.OperDate_Plan_day ::TDateTime AS OperDate_Plan_day_old

          -- Название дня недели
        , CASE WHEN tmpMI.NumDay = 1 THEN '1.Пн.'
               WHEN tmpMI.NumDay = 2 THEN '2.Вт.'
               WHEN tmpMI.NumDay = 3 THEN '3.Ср.'
               WHEN tmpMI.NumDay = 4 THEN '4.Чт.'
               WHEN tmpMI.NumDay = 5 THEN '5.Пт.'
               ELSE NULL
          END ::TVarChar AS WeekDay

          -- № в очереди
        , 0 :: TFloat AS Number_day

          -- План оплат на 1.пн-5,пт
        , CASE WHEN tmpMI.NumDay = 1 THEN tmpMI.Amount_Plan_day
               ELSE 0
          END ::TFloat AS AmountPlan_1
        , CASE WHEN tmpMI.NumDay = 2 THEN tmpMI.Amount_Plan_day
               ELSE 0
          END ::TFloat AS AmountPlan_2
        , CASE WHEN tmpMI.NumDay = 3 THEN tmpMI.Amount_Plan_day
               ELSE 0
          END ::TFloat AS AmountPlan_3
        , CASE WHEN tmpMI.NumDay = 4 THEN tmpMI.Amount_Plan_day
               ELSE 0
          END ::TFloat AS AmountPlan_4
        , CASE WHEN tmpMI.NumDay = 5 THEN tmpMI.Amount_Plan_day
               ELSE 0
          END ::TFloat AS AmountPlan_5

        , CASE WHEN tmpMI.Amount_Plan_day > 0
                    THEN zc_Color_Yelow()
               ELSE zc_Color_White()
          END :: Integer AS FonColor_AmountPlan_day

          -- Платим (да/нет) 1.пн.
        , tmpMI.isAmountPlan_day ::Boolean

        , tmpMI.Comment        ::TVarChar AS Comment

          -- всегда считаем - ФАКТ Назначение платежа
        , zfCalc_Comment_pay_OrderFinance (inComment    := COALESCE (tmpJuridicalOrderFinance.Comment, tmpJuridicalOrderFinance_last.Comment)
                                         , inNOM_DOG    := COALESCE (tmpMI.ContractName, '')
                                         , inNOM_IVOICE := COALESCE (tmpMI.InvNumber_Invoice_Child, '')
                                         , inTOVAR      := COALESCE (tmpMI.GoodsName_Child, '')
                                         , inDATA_DOG   := COALESCE (tmpMI.StartDate, zc_DateStart())
                                         , inPDV        := 20
                                         , inSUMMA_P    := tmpMI.Amount_Plan_day
                                          ) :: TVarChar AS Comment_pay

        , COALESCE (tmpJuridicalOrderFinance.JuridicalOrderFinanceId, tmpJuridicalOrderFinance_last.JuridicalOrderFinanceId)  ::Integer  AS JuridicalOrderFinanceId
        , COALESCE (tmpJuridicalOrderFinance.Comment, tmpJuridicalOrderFinance_last.Comment)                                  ::TVarChar AS Comment_jof          -- JuridicalOrderFinance
        , COALESCE (tmpJuridicalOrderFinance.BankAccountId, tmpJuridicalOrderFinance_last.BankAccountId)                      ::Integer  AS BankAccountId_jof    -- JuridicalOrderFinance
        , COALESCE (tmpJuridicalOrderFinance.BankAccountName, tmpJuridicalOrderFinance_last.BankAccountName)                  ::TVarChar AS BankAccountName_jof  -- JuridicalOrderFinance
        , COALESCE (tmpJuridicalOrderFinance.BankId, tmpJuridicalOrderFinance_last.BankId )                                   ::Integer  AS BankId_jof
        , COALESCE (tmpJuridicalOrderFinance.BankName, tmpJuridicalOrderFinance_last.BankName)                                ::TVarChar AS BankName_jof
        , COALESCE (tmpJuridicalOrderFinance.MFO, tmpJuridicalOrderFinance_last.MFO)                                          ::TVarChar AS MFO_jof

          --
        , tmpMI.Id_detail :: Integer AS MovementItemId_detail
          --
        , tmpMI.Id_child :: Integer AS MovementItemId_child
        , tmpMI.InvNumber_Child   ::TVarChar
        , tmpMI.InvNumber_Invoice_Child ::TVarChar
        , tmpMI.GoodsName_Child   ::TVarChar
        , tmpMI.Comment_Child     ::TVarChar
        , tmpMI.Comment_SB_Child  ::TVarChar
        , tmpMI.isSign_Child      ::Boolean

   FROM tmpMovement_Data AS tmpMovement

        INNER JOIN tmpMI_Data AS tmpMI ON tmpMI.MovementId = tmpMovement.MovementId
                                      -- убирается дублирование
                                      -- AND (tmpMI.Ord_Juridical = 1 OR tmpMI.Amount <> 0 OR tmpMI.AmountPlan_next <> 0 OR tmpMI.Amount_Plan_day <> 0)

        -- Child - Данные с № заявки 1С
        --LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpMI.Id

        LEFT JOIN tmpContractCondition ON tmpContractCondition.ContractId = tmpMI.ContractId
                                      AND tmpMovement.OperDate BETWEEN tmpContractCondition.StartDate AND tmpContractCondition.EndDate

        LEFT JOIN tmpInfoMoney_OFP ON tmpInfoMoney_OFP.InfoMoneyId = tmpMI.InfoMoneyId
                                  AND tmpInfoMoney_OFP.OrderFinanceId = tmpMovement.OrderFinanceId

        -- привязка  юр.лицо + статья + выбранный банк (плательщик)
        LEFT JOIN tmpJuridicalOrderFinance ON tmpJuridicalOrderFinance.JuridicalId = tmpMI.JuridicalId
                                          AND tmpJuridicalOrderFinance.InfoMoneyId = tmpMI.InfoMoneyId
                                          AND inBankMainId <> 0
                                          AND tmpJuridicalOrderFinance.Ord = 1
        -- привязка  юр.лицо + статья + последний платеж
        LEFT JOIN tmpJuridicalOrderFinance_last ON tmpJuridicalOrderFinance_last.JuridicalId = tmpMI.JuridicalId
                                               AND tmpJuridicalOrderFinance_last.InfoMoneyId = tmpMI.InfoMoneyId
                                               AND tmpJuridicalOrderFinance_last.Ord = 1
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
-- SELECT * FROM gpSelect_Movement_OrderFinance_PlanDate_4 (inStartDate:= '01.01.2026', inEndDate:= '01.01.2026', inBankMainId:=76970, inStartWeekNumber:=47, inEndWeekNumber := 48, inIsShowAll := False, inSession:= '2')
