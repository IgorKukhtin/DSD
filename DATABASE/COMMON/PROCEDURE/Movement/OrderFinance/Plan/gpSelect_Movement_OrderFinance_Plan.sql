-- Function: gpSelect_Movement_OrderFinance_Plan()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderFinance_Plan_5 (TDateTime, TDateTime, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpSelect_Movement_OrderFinance_Plan_5 (TDateTime, TDateTime, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_OrderFinance_Plan_5 (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderFinance_Plan_5(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inBankMainId        Integer , -- банк  Плательщик
    IN inStartWeekNumber   Integer , --
    IN inEndWeekNumber     Integer , --
    IN inIsDay_1           Boolean    , --
    IN inIsDay_2           Boolean    , --
    IN inIsDay_3           Boolean    , --
    IN inIsDay_4           Boolean    , --
    IN inIsDay_5           Boolean    , --
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
             --
             , MovementItemId Integer
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , OKPO TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , PaidKindName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, NumGroup Integer
             , Condition TVarChar, ContractStateKindCode Integer
             , StartDate TDateTime, EndDate_real TDateTime, EndDate TVarChar

             , AmountRemains TFloat, AmountPartner TFloat
             , AmountSumm         TFloat
             , AmountPartner_1    TFloat
             , AmountPartner_2    TFloat
             , AmountPartner_3    TFloat
             , AmountPartner_4    TFloat

               -- Первичный план на неделю
             , Amount          TFloat
               -- Платежный план на неделю
             , AmountPlan_next TFloat

               -- Согласовано к оплате
             , AmountPlan_1       TFloat
             , AmountPlan_2       TFloat
             , AmountPlan_3       TFloat
             , AmountPlan_4       TFloat
             , AmountPlan_5       TFloat
             , AmountPlan_total   TFloat
             , AmountPlan_calc    TFloat
             
             , Number_1           TFloat
             , Number_2           TFloat
             , Number_3           TFloat
             , Number_4           TFloat
             , Number_5           TFloat
             , Number_calc        TFloat

             , FonColor_AmountPlan_1     Integer
             , FonColor_AmountPlan_2     Integer
             , FonColor_AmountPlan_3     Integer
             , FonColor_AmountPlan_4     Integer
             , FonColor_AmountPlan_5     Integer
             , FonColor_AmountPlan_calc  Integer

             , isAmountPlan_1     Boolean
             , isAmountPlan_2     Boolean
             , isAmountPlan_3     Boolean
             , isAmountPlan_4     Boolean
             , isAmountPlan_5     Boolean
             , isAmountPlan       Boolean

             , Comment            TVarChar
             , Comment_pay        TVarChar
             , JuridicalOrderFinanceId Integer    -- JuridicalOrderFinance
             , Comment_jof             TVarChar   -- JuridicalOrderFinance
             , BankAccountId_jof Integer, BankAccountName_jof     TVarChar   -- JuridicalOrderFinance

             , BankId_jof Integer
             , BankName_jof TVarChar
             , MFO_jof      TVarChar 
               -- child
             , MovementItemId_Child Integer
             , InvNumber_Child      TVarChar
             , InvNumber_Invoice_Child   TVarChar
             , GoodsName_Child      TVarChar
             , isSign_Child         Boolean
             , TextSign_Child       TVarChar
               -- Detail
             , MovementItemId_Detail_1 Integer
             , MovementItemId_Detail_2 Integer
             , MovementItemId_Detail_3 Integer
             , MovementItemId_Detail_4 Integer
             , MovementItemId_Detail_5 Integer

             , ColorFon_record      Integer
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
     , tmpMovement AS (
                       SELECT Movement.*
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
                                                        /*AND (MovementLinkObject_OrderFinance.ObjectId  IN (3988049  -- Мясо
                                                                                                         , 3988054  -- Сырье, упаковочные и расходные материалы
                                                                                                         , 13069438 -- Техническое Обслуживание и Основные Средства
                                                                                                          )
                                                          OR vbUserId = 5 OR vbUserId = 9457)*/

                       WHERE Movement.DescId = zc_Movement_OrderFinance()
                         AND Movement.StatusId IN (SELECT tmpStatus.StatusId FROM tmpStatus)
                         AND Movement.OperDate BETWEEN inStartDate - INTERVAL '14 DAY' AND inEndDate
                       )

     , tmpMI AS ( SELECT MovementItem.*
                 FROM MovementItem
                 WHERE MovementItem.MovementId IN (SELECT tmpMovement.Id FROM tmpMovement)
                   AND MovementItem.DescId = zc_MI_Master()
                   AND MovementItem.isErased = FALSE
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
                               WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                 AND MovementItemDate.DescId IN (zc_MIDate_Insert()
                                                               , zc_MIDate_Update()
                                                               , zc_MIDate_Amount_next()
                                                                )
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
                                                                 --, zc_MIString_Comment_pay()
                                                                    )
                                 )

     , tmpMovementItemBoolean AS (SELECT *
                                  FROM MovementItemBoolean
                                  WHERE MovementItemBoolean.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
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


     , tmpMI_Child AS (SELECT MovementItem.*
                       FROM MovementItem
                       WHERE MovementItem.MovementId IN (SELECT tmpMovement.Id FROM tmpMovement)
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

     , tmpMI_Data_Child AS (SELECT MovementItem.Id          AS MovementItemId
                                 , MovementItem.ParentId    AS MovementItemId_parent
                                 , MovementItem.MovementId
                                   -- Первичный план на неделю
                                 , MovementItem.Amount
                                   -- Платежный план на неделю
                                 , COALESCE (MIFloat_AmountPlan_next.ValueData, 0) AS AmountPlan_next
                                   -- Дата Платежный план
                                 , MIDate_Amount_next.ValueData                    AS OperDate_next
                                   -- Согласовано к оплате
                                 , CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount_next.ValueData) = 1 THEN COALESCE (MIFloat_AmountPlan_next.ValueData, 0) ELSE 0 END AS AmountPlan_1
                                 , CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount_next.ValueData) = 2 THEN COALESCE (MIFloat_AmountPlan_next.ValueData, 0) ELSE 0 END AS AmountPlan_2
                                 , CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount_next.ValueData) = 3 THEN COALESCE (MIFloat_AmountPlan_next.ValueData, 0) ELSE 0 END AS AmountPlan_3
                                 , CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount_next.ValueData) = 4 THEN COALESCE (MIFloat_AmountPlan_next.ValueData, 0) ELSE 0 END AS AmountPlan_4
                                 , CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount_next.ValueData) = 5 THEN COALESCE (MIFloat_AmountPlan_next.ValueData, 0) ELSE 0 END AS AmountPlan_5
                                   -- Платим да/нет
                                 , COALESCE (MIBoolean_AmountPlan_1.ValueData, TRUE) ::Boolean AS isAmountPlan_1
                                 , COALESCE (MIBoolean_AmountPlan_2.ValueData, TRUE) ::Boolean AS isAmountPlan_2
                                 , COALESCE (MIBoolean_AmountPlan_3.ValueData, TRUE) ::Boolean AS isAmountPlan_3
                                 , COALESCE (MIBoolean_AmountPlan_4.ValueData, TRUE) ::Boolean AS isAmountPlan_4
                                 , COALESCE (MIBoolean_AmountPlan_5.ValueData, TRUE) ::Boolean AS isAmountPlan_5
                                   --
                                 , MIString_InvNumber.ValueData               ::TVarChar AS InvNumber
                                 , MIString_InvNumber_Invoice.ValueData       ::TVarChar AS InvNumber_Invoice
                                 , MIString_GoodsName.ValueData               ::TVarChar AS GoodsName
                                 , COALESCE (MIString_Comment.ValueData, '')             AS Comment
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
                                 LEFT JOIN tmpMIString_Child AS MIString_Comment
                                                             ON MIString_Comment.MovementItemId = MovementItem.Id
                                                            AND MIString_Comment.DescId = zc_MIString_Comment()

                                 LEFT JOIN tmpMIString_Child AS MIString_InvNumber
                                                             ON MIString_InvNumber.MovementItemId = MovementItem.Id
                                                            AND MIString_InvNumber.DescId = zc_MIString_InvNumber()
                                 LEFT JOIN tmpMIString_Child AS MIString_InvNumber_Invoice
                                                             ON MIString_InvNumber_Invoice.MovementItemId = MovementItem.Id
                                                            AND MIString_InvNumber_Invoice.DescId = zc_MIString_InvNumber_Invoice()

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
    , tmpMI_Detail AS (SELECT MovementItem.ParentId AS MovementItemId_parent
                            , MAX (CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount.ValueData) = 1 THEN MovementItem.Id ELSE 0 END) AS MovementItemId_Detail_1
                            , MAX (CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount.ValueData) = 2 THEN MovementItem.Id ELSE 0 END) AS MovementItemId_Detail_2
                            , MAX (CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount.ValueData) = 3 THEN MovementItem.Id ELSE 0 END) AS MovementItemId_Detail_3
                            , MAX (CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount.ValueData) = 4 THEN MovementItem.Id ELSE 0 END) AS MovementItemId_Detail_4
                            , MAX (CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount.ValueData) = 5 THEN MovementItem.Id ELSE 0 END) AS MovementItemId_Detail_5
                              -- Согласовано к оплате
                            , SUM (CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount.ValueData) = 1 THEN MovementItem.Amount ELSE 0 END) AS AmountPlan_1
                            , SUM (CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount.ValueData) = 2 THEN MovementItem.Amount ELSE 0 END) AS AmountPlan_2
                            , SUM (CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount.ValueData) = 3 THEN MovementItem.Amount ELSE 0 END) AS AmountPlan_3
                            , SUM (CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount.ValueData) = 4 THEN MovementItem.Amount ELSE 0 END) AS AmountPlan_4
                            , SUM (CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount.ValueData) = 5 THEN MovementItem.Amount ELSE 0 END) AS AmountPlan_5

                              -- Платим да/нет
                            , MAX (CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount.ValueData) = 1 AND COALESCE (MIBoolean_AmountPlan.ValueData, TRUE) = TRUE THEN 2 ELSE 1 END) AS isAmountPlan_1_value
                            , MAX (CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount.ValueData) = 2 AND COALESCE (MIBoolean_AmountPlan.ValueData, TRUE) = TRUE THEN 2 ELSE 1 END) AS isAmountPlan_2_value
                            , MAX (CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount.ValueData) = 3 AND COALESCE (MIBoolean_AmountPlan.ValueData, TRUE) = TRUE THEN 2 ELSE 1 END) AS isAmountPlan_3_value
                            , MAX (CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount.ValueData) = 4 AND COALESCE (MIBoolean_AmountPlan.ValueData, TRUE) = TRUE THEN 2 ELSE 1 END) AS isAmountPlan_4_value
                            , MAX (CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount.ValueData) = 5 AND COALESCE (MIBoolean_AmountPlan.ValueData, TRUE) = TRUE THEN 2 ELSE 1 END) AS isAmountPlan_5_value

                            , MAX (COALESCE (MIDate_Update.ValueData, MIDate_Insert.ValueData)) AS UpdateDate
                            , MAX (COALESCE (MILO_Update.ObjectId,    MILO_Insert.ObjectId))    AS UserId_update

                       FROM MovementItem
                            -- Дата Согласовано к оплате
                            LEFT JOIN MovementItemDate AS MIDate_Amount
                                                       ON MIDate_Amount.MovementItemId = MovementItem.Id
                                                      AND MIDate_Amount.DescId         = zc_MIDate_Amount()
                            -- Платим (да/нет)
                            LEFT JOIN MovementItemBoolean AS MIBoolean_AmountPlan
                                                          ON MIBoolean_AmountPlan.MovementItemId = MovementItem.Id
                                                         AND MIBoolean_AmountPlan.DescId         = zc_MIBoolean_AmountPlan()

                            LEFT JOIN MovementItemDate AS MIDate_Insert
                                                       ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                      AND MIDate_Insert.DescId = zc_MIDate_Insert()
                            LEFT JOIN MovementItemDate AS MIDate_Update
                                                       ON MIDate_Update.MovementItemId = MovementItem.Id
                                                      AND MIDate_Update.DescId = zc_MIDate_Update()

                            LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                             ON MILO_Insert.MovementItemId = MovementItem.Id
                                                            AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                            LEFT JOIN MovementItemLinkObject AS MILO_Update
                                                             ON MILO_Update.MovementItemId = MovementItem.Id
                                                            AND MILO_Update.DescId = zc_MILinkObject_Update()

                       WHERE MovementItem.MovementId IN (SELECT tmpMovement.Id FROM tmpMovement)
                         AND MovementItem.DescId     = zc_MI_Detail()
                         AND MovementItem.isErased   = FALSE
                       GROUP BY MovementItem.ParentId
                      )
        -- Master + Child  + Detail
    , tmpMI_ord AS (SELECT tmpMI.Id
                         , tmpMI.MovementId
                         , tmpMI.ObjectId
                           -- Child
                         , COALESCE (tmpMI_Child.MovementItemId, 0) AS MovementItemId_child
                         , tmpMI_Child.GoodsName                    AS GoodsName_Child
                         , tmpMI_Child.InvNumber                    AS InvNumber_Child
                         , tmpMI_Child.InvNumber_Invoice            AS InvNumber_Invoice_Child 
                         , tmpMI_Child.Comment                      AS Comment_Child
                         , tmpMI_Child.isSign                       AS isSign_Child
                           -- Detail
                         , COALESCE (tmpMI_Detail_1.MovementItemId_Detail_1, tmpMI_Detail_2.MovementItemId_Detail_1) AS MovementItemId_Detail_1
                         , COALESCE (tmpMI_Detail_1.MovementItemId_Detail_2, tmpMI_Detail_2.MovementItemId_Detail_2) AS MovementItemId_Detail_2
                         , COALESCE (tmpMI_Detail_1.MovementItemId_Detail_3, tmpMI_Detail_2.MovementItemId_Detail_3) AS MovementItemId_Detail_3
                         , COALESCE (tmpMI_Detail_1.MovementItemId_Detail_4, tmpMI_Detail_2.MovementItemId_Detail_4) AS MovementItemId_Detail_4
                         , COALESCE (tmpMI_Detail_1.MovementItemId_Detail_5, tmpMI_Detail_2.MovementItemId_Detail_5) AS MovementItemId_Detail_5

                           -- Первичный план на неделю
                         , COALESCE (tmpMI_Child.Amount, tmpMI.Amount) AS Amount
  
                           -- Платежный план на неделю
                         , COALESCE (tmpMI_Child.AmountPlan_next, MIFloat_AmountPlan_next.ValueData) :: TFloat    AS AmountPlan_next
                           -- Дата Платежный план
                         , COALESCE (tmpMI_Child.OperDate_next,   MIDate_Amount_next.ValueData)      :: TDateTime AS OperDate_next

                           -- Согласовано к оплате
                         , COALESCE (tmpMI_Detail_1.AmountPlan_1, tmpMI_Detail_2.AmountPlan_1, tmpMI_Child.AmountPlan_1, MIFloat_AmountPlan_1.ValueData) AS AmountPlan_1
                         , COALESCE (tmpMI_Detail_1.AmountPlan_2, tmpMI_Detail_2.AmountPlan_2, tmpMI_Child.AmountPlan_2, MIFloat_AmountPlan_2.ValueData) AS AmountPlan_2
                         , COALESCE (tmpMI_Detail_1.AmountPlan_3, tmpMI_Detail_2.AmountPlan_3, tmpMI_Child.AmountPlan_3, MIFloat_AmountPlan_3.ValueData) AS AmountPlan_3
                         , COALESCE (tmpMI_Detail_1.AmountPlan_4, tmpMI_Detail_2.AmountPlan_4, tmpMI_Child.AmountPlan_4, MIFloat_AmountPlan_4.ValueData) AS AmountPlan_4
                         , COALESCE (tmpMI_Detail_1.AmountPlan_5, tmpMI_Detail_2.AmountPlan_5, tmpMI_Child.AmountPlan_5, MIFloat_AmountPlan_5.ValueData) AS AmountPlan_5

                           -- Платим да/нет
                         , CASE COALESCE (tmpMI_Detail_1.isAmountPlan_1_value, tmpMI_Detail_2.isAmountPlan_1_value) WHEN 2 THEN TRUE WHEN 1 THEN FALSE ELSE COALESCE (tmpMI_Child.isAmountPlan_1, MIBoolean_AmountPlan_1.ValueData, TRUE) END AS isAmountPlan_1
                         , CASE COALESCE (tmpMI_Detail_1.isAmountPlan_2_value, tmpMI_Detail_2.isAmountPlan_2_value) WHEN 2 THEN TRUE WHEN 1 THEN FALSE ELSE COALESCE (tmpMI_Child.isAmountPlan_2, MIBoolean_AmountPlan_2.ValueData, TRUE) END AS isAmountPlan_2
                         , CASE COALESCE (tmpMI_Detail_1.isAmountPlan_3_value, tmpMI_Detail_2.isAmountPlan_3_value) WHEN 2 THEN TRUE WHEN 1 THEN FALSE ELSE COALESCE (tmpMI_Child.isAmountPlan_3, MIBoolean_AmountPlan_3.ValueData, TRUE) END AS isAmountPlan_3
                         , CASE COALESCE (tmpMI_Detail_1.isAmountPlan_4_value, tmpMI_Detail_2.isAmountPlan_4_value) WHEN 2 THEN TRUE WHEN 1 THEN FALSE ELSE COALESCE (tmpMI_Child.isAmountPlan_4, MIBoolean_AmountPlan_4.ValueData, TRUE) END AS isAmountPlan_4
                         , CASE COALESCE (tmpMI_Detail_1.isAmountPlan_5_value, tmpMI_Detail_2.isAmountPlan_5_value) WHEN 2 THEN TRUE WHEN 1 THEN FALSE ELSE COALESCE (tmpMI_Child.isAmountPlan_5, MIBoolean_AmountPlan_5.ValueData, TRUE) END AS isAmountPlan_5

                         , COALESCE (tmpMI_Child.InsertName, Object_Insert.ValueData) AS InsertName
                         , COALESCE (tmpMI_Child.InsertDate, MIDate_Insert.ValueData) AS InsertDate

                         , COALESCE (Object_Update_detail.ValueData, tmpMI_Child.UpdateName, Object_Update.ValueData)                       AS UpdateName
                         , COALESCE (tmpMI_Detail_1.UpdateDate, tmpMI_Detail_2.UpdateDate, tmpMI_Child.UpdateDate, MIDate_Update.ValueData) AS UpdateDate

                             -- № п/п - какие данные мастера выводить 1 раз
                         , ROW_NUMBER() OVER (PARTITION BY tmpMI.Id ORDER BY tmpMI_Child.MovementItemId ASC) AS Ord_master

                    FROM tmpMI
                         -- Child - Данные с № заявки 1С + ...
                         LEFT JOIN tmpMI_Data_Child AS tmpMI_Child ON tmpMI_Child.MovementItemId_parent = tmpMI.Id

                         -- Detail-1 - Согласовано к оплате
                         LEFT JOIN tmpMI_Detail AS tmpMI_Detail_1 ON tmpMI_Detail_1.MovementItemId_parent = tmpMI.Id
                         -- Detail-2 - Согласовано к оплате
                         LEFT JOIN tmpMI_Detail AS tmpMI_Detail_2 ON tmpMI_Detail_2.MovementItemId_parent = tmpMI_Child.MovementItemId
  
                         LEFT JOIN Object AS Object_Update_detail ON Object_Update_detail.Id = COALESCE (tmpMI_Detail_1.UserId_update, tmpMI_Detail_2.UserId_update)

                         -- Платежный план на неделю
                         LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_next
                                                        ON MIFloat_AmountPlan_next.MovementItemId = tmpMI.Id
                                                       AND MIFloat_AmountPlan_next.DescId         = zc_MIFloat_AmountPlan_next()
                         -- Дата Платежный план
                         LEFT JOIN tmpMovementItemDate AS MIDate_Amount_next
                                                       ON MIDate_Amount_next.MovementItemId = tmpMI.Id
                                                      AND MIDate_Amount_next.DescId         = zc_MIDate_Amount_next()

                         -- Согласовано к оплате
                         LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_1
                                                        ON MIFloat_AmountPlan_1.MovementItemId = tmpMI.Id
                                                       AND MIFloat_AmountPlan_1.DescId = zc_MIFloat_AmountPlan_1() 
                         LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_2
                                                        ON MIFloat_AmountPlan_2.MovementItemId = tmpMI.Id
                                                       AND MIFloat_AmountPlan_2.DescId = zc_MIFloat_AmountPlan_2() 
                         LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_3
                                                        ON MIFloat_AmountPlan_3.MovementItemId = tmpMI.Id
                                                       AND MIFloat_AmountPlan_3.DescId = zc_MIFloat_AmountPlan_3()
                         LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_4
                                                        ON MIFloat_AmountPlan_4.MovementItemId = tmpMI.Id
                                                       AND MIFloat_AmountPlan_4.DescId = zc_MIFloat_AmountPlan_4()
                         LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_5
                                                        ON MIFloat_AmountPlan_5.MovementItemId = tmpMI.Id
                                                       AND MIFloat_AmountPlan_5.DescId = zc_MIFloat_AmountPlan_5()

                         -- Платим (да/нет)
                         LEFT JOIN tmpMovementItemBoolean AS MIBoolean_AmountPlan_1
                                                          ON MIBoolean_AmountPlan_1.MovementItemId = tmpMI.Id
                                                         AND MIBoolean_AmountPlan_1.DescId = zc_MIBoolean_AmountPlan_1()
                         LEFT JOIN tmpMovementItemBoolean AS MIBoolean_AmountPlan_2
                                                          ON MIBoolean_AmountPlan_2.MovementItemId = tmpMI.Id
                                                         AND MIBoolean_AmountPlan_2.DescId = zc_MIBoolean_AmountPlan_2()
                         LEFT JOIN tmpMovementItemBoolean AS MIBoolean_AmountPlan_3
                                                          ON MIBoolean_AmountPlan_3.MovementItemId = tmpMI.Id
                                                         AND MIBoolean_AmountPlan_3.DescId = zc_MIBoolean_AmountPlan_3()
                         LEFT JOIN tmpMovementItemBoolean AS MIBoolean_AmountPlan_4
                                                          ON MIBoolean_AmountPlan_4.MovementItemId = tmpMI.Id
                                                         AND MIBoolean_AmountPlan_4.DescId = zc_MIBoolean_AmountPlan_4()
                         LEFT JOIN tmpMovementItemBoolean AS MIBoolean_AmountPlan_5
                                                          ON MIBoolean_AmountPlan_5.MovementItemId = tmpMI.Id
                                                         AND MIBoolean_AmountPlan_5.DescId = zc_MIBoolean_AmountPlan_5()

                         LEFT JOIN tmpMovementItemDate AS MIDate_Insert
                                                       ON MIDate_Insert.MovementItemId = tmpMI.Id
                                                      AND MIDate_Insert.DescId = zc_MIDate_Insert()
                         LEFT JOIN tmpMovementItemDate AS MIDate_Update
                                                       ON MIDate_Update.MovementItemId = tmpMI.Id
                                                      AND MIDate_Update.DescId = zc_MIDate_Update()
                         LEFT JOIN tmpMovementItemLinkObject AS MILO_Insert
                                                             ON MILO_Insert.MovementItemId = tmpMI.Id
                                                            AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                         LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId

                         LEFT JOIN tmpMovementItemLinkObject AS MILO_Update
                                                             ON MILO_Update.MovementItemId = tmpMI.Id
                                                            AND MILO_Update.DescId = zc_MILinkObject_Update()
                         LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILO_Update.ObjectId

                    )
            
        -- Только БН
      , tmpMI_Data AS (SELECT MovementItem.MovementId
                            , MovementItem.Id                  AS Id
                            , Object_Juridical.Id              AS JuridicalId
                            , Object_Juridical.ObjectCode      AS JuridicalCode
                            , Object_Juridical.ValueData       AS JuridicalName
                            , tmpJuridicalDetails_View.OKPO
                            , Object_Contract.Id               AS ContractId
                            , Object_Contract.ObjectCode       AS ContractCode
                            , Object_Contract.ValueData        AS ContractName
                            , Object_PaidKind.Id               AS PaidKindId
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

                            , MIFloat_AmountRemains.ValueData   :: TFloat AS AmountRemains
                            , MIFloat_AmountPartner.ValueData   :: TFloat AS AmountPartner
                            , MIFloat_AmountSumm.ValueData      :: TFloat AS AmountSumm
                            , MIFloat_AmountPartner_1.ValueData :: TFloat AS AmountPartner_1
                            , MIFloat_AmountPartner_2.ValueData :: TFloat AS AmountPartner_2
                            , MIFloat_AmountPartner_3.ValueData :: TFloat AS AmountPartner_3
                            , MIFloat_AmountPartner_4.ValueData :: TFloat AS AmountPartner_4

                              -- Первичный план на неделю
                            , MovementItem.Amount
                              -- Платежный план на неделю
                            , MovementItem.AmountPlan_next
                              -- Дата Платежный план
                            , MovementItem.OperDate_next

                              -- Согласовано к оплате
                            , MovementItem.AmountPlan_1
                            , MovementItem.AmountPlan_2
                            , MovementItem.AmountPlan_3
                            , MovementItem.AmountPlan_4
                            , MovementItem.AmountPlan_5
                            
                            , 0        :: TFloat AS Number_1
                            , 0        :: TFloat AS Number_2
                            , 0        :: TFloat AS Number_3
                            , 0        :: TFloat AS Number_4
                            , 0        :: TFloat AS Number_5

                              -- Платим да/нет
                            , MovementItem.isAmountPlan_1
                            , MovementItem.isAmountPlan_2
                            , MovementItem.isAmountPlan_3
                            , MovementItem.isAmountPlan_4
                            , MovementItem.isAmountPlan_5

                            , CASE WHEN MovementItem.Comment_Child <> '' THEN MovementItem.Comment_Child ELSE MIString_Comment.ValueData END ::TVarChar AS Comment

                            , MovementItem.InsertName
                            , MovementItem.UpdateName
                            , MovementItem.InsertDate
                            , MovementItem.UpdateDate

                              -- Child
                            , MovementItem.MovementItemId_Child
                            , MovementItem.InvNumber_Child
                            , MovementItem.InvNumber_Invoice_Child 
                            , MovementItem.GoodsName_Child
                            , MovementItem.isSign_Child
                              -- Detail
                            , MovementItem.MovementItemId_Detail_1
                            , MovementItem.MovementItemId_Detail_2
                            , MovementItem.MovementItemId_Detail_3
                            , MovementItem.MovementItemId_Detail_4
                            , MovementItem.MovementItemId_Detail_5

                        FROM tmpMI_ord AS MovementItem
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

                             LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountSumm
                                                            ON MIFloat_AmountSumm.MovementItemId = MovementItem.Id
                                                           AND MIFloat_AmountSumm.DescId = zc_MIFloat_AmountSumm()
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

                             LEFT JOIN tmpMovementItemString AS MIString_Comment
                                                             ON MIString_Comment.MovementItemId = MovementItem.Id
                                                            AND MIString_Comment.DescId = zc_MIString_Comment()
                                                          --AND MovementItem.Ord_master = 1

                             LEFT JOIN tmpMILO_Contract AS MILinkObject_Contract
                                                        ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                                                     --AND MovementItem.Ord_master = 1
                             LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MILinkObject_Contract.ObjectId


                             LEFT JOIN tmpJuridicalDetails_View ON tmpJuridicalDetails_View.JuridicalId = Object_Juridical.Id

                             LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                                  ON ObjectLink_Contract_InfoMoney.ObjectId = Object_Contract.Id
                                                 AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                             LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = CASE WHEN Object_Juridical.DescId = zc_Object_Juridical() THEN ObjectLink_Contract_InfoMoney.ChildObjectId ELSE MovementItem.ObjectId END

                             LEFT JOIN tmpContract_View AS View_Contract ON View_Contract.ContractId = Object_Contract.Id
                             LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = View_Contract.PaidKindId
                             --LEFT JOIN tmpContractCondition ON tmpContractCondition.ContractId = Object_Contract.Id

                      -- Только БН
                      WHERE View_Contract.PaidKindId = zc_Enum_PaidKind_FirstForm()
                     )

       --
     , tmpMovement_Data AS (SELECT Movement.Id                            AS MovementId
                                 , Movement.InvNumber                     AS InvNumber
                                 , Movement.OperDate                      AS OperDate
                                 , Object_Status.ObjectCode               AS StatusCode
                                 , Object_Status.ValueData                AS StatusName
       
                                 , Object_OrderFinance.Id                 AS OrderFinanceId
                                 , Object_OrderFinance.ValueData          AS OrderFinanceName
       
                                 --Банк плательщик брать из справочника JuridicalOrderFinance
                                 --, Object_BankAccount_View.Id             AS BankAccountId
                                 --, Object_BankAccount_View.Name           AS BankAccountName
                                 --, Object_BankAccount_View.BankId
                                 --, Object_BankAccount_View.BankName
                                 --, (Object_BankAccount_View.BankName || '' || Object_BankAccount_View.Name) :: TVarChar AS BankAccountNameAll
                                 --, Object_BankAccount_View.MFO            AS MFO

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
        --, tmpMovement.BankAccountId
        --, tmpMovement.BankAccountName
        --, tmpMovement.BankId
        --, tmpMovement.BankName
        --, tmpMovement.BankAccountNameAll
        --, tmpMovement.MFO
        , COALESCE (tmpJuridicalOrderFinance.BankAccountId_main, tmpJuridicalOrderFinance_last.BankAccountId_main)          ::Integer  AS BankAccountId
        , COALESCE (tmpJuridicalOrderFinance.BankAccountName_main, tmpJuridicalOrderFinance_last.BankAccountName_main)      ::TVarChar AS BankAccountName
        , COALESCE (tmpJuridicalOrderFinance.BankId_main, tmpJuridicalOrderFinance_last.BankId_main)                        ::Integer  AS BankId
        , COALESCE (tmpJuridicalOrderFinance.BankName_main, tmpJuridicalOrderFinance_last.BankName_main)                    ::TVarChar AS BankName
        , COALESCE (tmpJuridicalOrderFinance.BankAccountNameAll_main, tmpJuridicalOrderFinance_last.BankAccountNameAll_main)::TVarChar AS BankAccountNameAll
        , COALESCE (tmpJuridicalOrderFinance.MFO_main, tmpJuridicalOrderFinance_last.MFO_main)                              ::TVarChar AS MFO

        , tmpMovement.WeekNumber
       /*   -- Предварительный План на неделю
        , tmpMovement.TotalSumm  ::TFloat
          -- Согласована сумма на неделю
        , tmpMovement.TotalSumm_all ::TFloat
        , tmpMovement.TotalSumm_1   ::TFloat
        , tmpMovement.TotalSumm_2   ::TFloat
        , tmpMovement.TotalSumm_3   ::TFloat

        , tmpMovement.AmountPlan_1    ::TFloat  AS TotalPlan_1
        , tmpMovement.AmountPlan_2    ::TFloat  AS TotalPlan_2
        , tmpMovement.AmountPlan_3    ::TFloat  AS TotalPlan_3
        , tmpMovement.AmountPlan_4    ::TFloat  AS TotalPlan_4
        , tmpMovement.AmountPlan_5    ::TFloat  AS TotalPlan_5
        */
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
        , tmpMovement.isSign_1        ::Boolean  --35

          --
        , tmpMI.Id AS MovementItemId
        , tmpMI.JuridicalId
        , tmpMI.JuridicalCode
        , tmpMI.JuridicalName
        , tmpMI.OKPO
        , tmpMI.ContractId
        , tmpMI.ContractCode
        , tmpMI.ContractName
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
        , tmpMI.AmountPlan_next :: TFloat AS AmountPlan_next

          -- Согласовано к оплате
        , tmpMI.AmountPlan_1    :: TFloat AS AmountPlan_1
        , tmpMI.AmountPlan_2    :: TFloat AS AmountPlan_2
        , tmpMI.AmountPlan_3    :: TFloat AS AmountPlan_3
        , tmpMI.AmountPlan_4    :: TFloat AS AmountPlan_4
        , tmpMI.AmountPlan_5    :: TFloat AS AmountPlan_5
        , (COALESCE (tmpMI.AmountPlan_1, 0)
         + COALESCE (tmpMI.AmountPlan_2, 0)
         + COALESCE (tmpMI.AmountPlan_3, 0)
         + COALESCE (tmpMI.AmountPlan_4, 0)
         + COALESCE (tmpMI.AmountPlan_5, 0)
          ) :: TFloat AS AmountPlan_total

          -- Платим да/нет (ввод)
        , CASE WHEN inIsDay_1 = TRUE AND COALESCE (tmpMI.isAmountPlan_1, TRUE) = TRUE
                    THEN tmpMI.AmountPlan_1
               WHEN inIsDay_2 = TRUE AND COALESCE (tmpMI.isAmountPlan_2, TRUE) = TRUE
                    THEN tmpMI.AmountPlan_2
               WHEN inIsDay_3 = TRUE AND COALESCE (tmpMI.isAmountPlan_3, TRUE) = TRUE
                    THEN tmpMI.AmountPlan_3
               WHEN inIsDay_4 = TRUE AND COALESCE (tmpMI.isAmountPlan_4, TRUE) = TRUE
                    THEN tmpMI.AmountPlan_4
               WHEN inIsDay_5 = TRUE AND COALESCE (tmpMI.isAmountPlan_5, TRUE) = TRUE
                    THEN tmpMI.AmountPlan_5
               ELSE 0
          END ::TFloat AS AmountPlan_calc

          -- № в очереди на 1.пн.
        , tmpMI.Number_1    :: TFloat AS Number_1
        , tmpMI.Number_2    :: TFloat AS Number_2
        , tmpMI.Number_3    :: TFloat AS Number_3
        , tmpMI.Number_4    :: TFloat AS Number_4
        , tmpMI.Number_5    :: TFloat AS Number_5

          -- № в очереди (ввод)
        , CASE WHEN inIsDay_1 = TRUE
                    THEN tmpMI.Number_1
               WHEN inIsDay_2 = TRUE
                    THEN tmpMI.Number_2
               WHEN inIsDay_3 = TRUE
                    THEN tmpMI.Number_3
               WHEN inIsDay_4 = TRUE
                    THEN tmpMI.Number_4
               WHEN inIsDay_5 = TRUE
                    THEN tmpMI.Number_5
               ELSE 0
          END ::TFloat AS Number_calc

        , CASE WHEN inIsDay_1 = TRUE AND COALESCE (tmpMI.isAmountPlan_1, TRUE) = TRUE AND tmpMI.AmountPlan_1 > 0
                    THEN zc_Color_Yelow()
               ELSE zc_Color_White()
          END :: Integer AS FonColor_AmountPlan_1
        , CASE WHEN inIsDay_2 = TRUE AND COALESCE (tmpMI.isAmountPlan_2, TRUE) = TRUE AND tmpMI.AmountPlan_2 > 0
                    THEN zc_Color_Yelow()
               ELSE zc_Color_White()
          END :: Integer AS FonColor_AmountPlan_2
        , CASE WHEN inIsDay_3 = TRUE AND COALESCE (tmpMI.isAmountPlan_3, TRUE) = TRUE AND tmpMI.AmountPlan_3 > 0
                    THEN zc_Color_Yelow()
               ELSE zc_Color_White()
          END :: Integer AS FonColor_AmountPlan_3
        , CASE WHEN inIsDay_4 = TRUE AND COALESCE (tmpMI.isAmountPlan_4, TRUE) = TRUE AND tmpMI.AmountPlan_4 > 0
                    THEN zc_Color_Yelow()
               ELSE zc_Color_White()
          END :: Integer AS FonColor_AmountPlan_3
        , CASE WHEN inIsDay_5 = TRUE AND COALESCE (tmpMI.isAmountPlan_5, TRUE) = TRUE AND tmpMI.AmountPlan_5 > 0
                    THEN zc_Color_Yelow()
               ELSE zc_Color_White()
          END :: Integer AS FonColor_AmountPlan_5

        , CASE WHEN 1=1
                    THEN zc_Color_White()
               WHEN inIsDay_1 = TRUE AND COALESCE (tmpMI.isAmountPlan_1, TRUE) = TRUE AND tmpMI.AmountPlan_1 > 0
                    THEN zc_Color_Yelow()
               WHEN inIsDay_2 = TRUE AND COALESCE (tmpMI.isAmountPlan_2, TRUE) = TRUE AND tmpMI.AmountPlan_2 > 0
                    THEN zc_Color_Yelow()
               WHEN inIsDay_3 = TRUE AND COALESCE (tmpMI.isAmountPlan_3, TRUE) = TRUE AND tmpMI.AmountPlan_3 > 0
                    THEN zc_Color_Yelow()
               WHEN inIsDay_4 = TRUE AND COALESCE (tmpMI.isAmountPlan_4, TRUE) = TRUE AND tmpMI.AmountPlan_4 > 0
                    THEN zc_Color_Yelow()
               WHEN inIsDay_5 = TRUE AND COALESCE (tmpMI.isAmountPlan_5, TRUE) = TRUE AND tmpMI.AmountPlan_5 > 0
                    THEN zc_Color_Yelow()
               ELSE zc_Color_White()
          END :: Integer AS FonColor_AmountPlan_calc

          -- Платим (да/нет) 1.пн.
        , tmpMI.isAmountPlan_1 ::Boolean
        , tmpMI.isAmountPlan_2 ::Boolean
        , tmpMI.isAmountPlan_3 ::Boolean
        , tmpMI.isAmountPlan_4 ::Boolean
        , tmpMI.isAmountPlan_5 ::Boolean

          -- по умолчанию платим , если нет снимают галку  -- надо еще колонку одну, где будут ставить  да/нет, а в шапке вывести 5 дней недели и там где галку поставят, тогда и будем понимать в какой это день
        , CASE WHEN inIsDay_1 = TRUE AND COALESCE (tmpMI.isAmountPlan_1, TRUE) = TRUE
                    THEN TRUE
               WHEN inIsDay_2 = TRUE AND COALESCE (tmpMI.isAmountPlan_2, TRUE) = TRUE
                    THEN TRUE
               WHEN inIsDay_3 = TRUE AND COALESCE (tmpMI.isAmountPlan_3, TRUE) = TRUE
                    THEN TRUE
               WHEN inIsDay_4 = TRUE AND COALESCE (tmpMI.isAmountPlan_4, TRUE) = TRUE
                    THEN TRUE
               WHEN inIsDay_5 = TRUE AND COALESCE (tmpMI.isAmountPlan_5, TRUE) = TRUE
                    THEN TRUE
               ELSE FALSE
          END ::Boolean  AS isAmountPlan

        , tmpMI.Comment        ::TVarChar AS Comment

          -- всегда считаем - ФАКТ Назначение платежа
        , CASE WHEN inIsDay_1 = TRUE AND COALESCE (tmpMI.isAmountPlan_1, TRUE) = TRUE AND tmpMI.AmountPlan_1 > 0
                    THEN zfCalc_Comment_pay_OrderFinance (inComment    := COALESCE (tmpJuridicalOrderFinance.Comment, tmpJuridicalOrderFinance_last.Comment)
                                                        , inNOM_DOG    := COALESCE (tmpMI.ContractName, '')
                                                        , inNOM_IVOICE := COALESCE (tmpMI.InvNumber_Invoice_Child, '')
                                                        , inTOVAR      := COALESCE (tmpMI.GoodsName_Child, '')
                                                        , inDATA_DOG   := COALESCE (tmpMI.StartDate, zc_DateStart())
                                                        , inPDV        := 20
                                                        , inSUMMA_P    := tmpMI.AmountPlan_1
                                                         )

               WHEN inIsDay_2 = TRUE AND COALESCE (tmpMI.isAmountPlan_2, TRUE) = TRUE AND tmpMI.AmountPlan_2 > 0
                    THEN zfCalc_Comment_pay_OrderFinance (inComment    := COALESCE (tmpJuridicalOrderFinance.Comment, tmpJuridicalOrderFinance_last.Comment)
                                                        , inNOM_DOG    := COALESCE (tmpMI.ContractName, '')
                                                        , inNOM_IVOICE := COALESCE (tmpMI.InvNumber_Invoice_Child, '')
                                                        , inTOVAR      := COALESCE (tmpMI.GoodsName_Child, '')
                                                        , inDATA_DOG   := COALESCE (tmpMI.StartDate, zc_DateStart())
                                                        , inPDV        := 20
                                                        , inSUMMA_P    := tmpMI.AmountPlan_2
                                                         )

               WHEN inIsDay_3 = TRUE AND COALESCE (tmpMI.isAmountPlan_3, TRUE) = TRUE AND tmpMI.AmountPlan_3 > 0
                    THEN zfCalc_Comment_pay_OrderFinance (inComment    := COALESCE (tmpJuridicalOrderFinance.Comment, tmpJuridicalOrderFinance_last.Comment)
                                                        , inNOM_DOG    := COALESCE (tmpMI.ContractName, '')
                                                        , inNOM_IVOICE := COALESCE (tmpMI.InvNumber_Invoice_Child, '')
                                                        , inTOVAR      := COALESCE (tmpMI.GoodsName_Child, '')
                                                        , inDATA_DOG   := COALESCE (tmpMI.StartDate, zc_DateStart())
                                                        , inPDV        := 20
                                                        , inSUMMA_P    := tmpMI.AmountPlan_3
                                                         )

               WHEN inIsDay_4 = TRUE AND COALESCE (tmpMI.isAmountPlan_4, TRUE) = TRUE AND tmpMI.AmountPlan_4 > 0
                    THEN zfCalc_Comment_pay_OrderFinance (inComment    := COALESCE (tmpJuridicalOrderFinance.Comment, tmpJuridicalOrderFinance_last.Comment)
                                                        , inNOM_DOG    := COALESCE (tmpMI.ContractName, '')
                                                        , inNOM_IVOICE := COALESCE (tmpMI.InvNumber_Invoice_Child, '')
                                                        , inTOVAR      := COALESCE (tmpMI.GoodsName_Child, '')
                                                        , inDATA_DOG   := COALESCE (tmpMI.StartDate, zc_DateStart())
                                                        , inPDV        := 20
                                                        , inSUMMA_P    := tmpMI.AmountPlan_4
                                                         )

               WHEN inIsDay_5 = TRUE AND COALESCE (tmpMI.isAmountPlan_5, TRUE) = TRUE AND tmpMI.AmountPlan_5 > 0
                    THEN zfCalc_Comment_pay_OrderFinance (inComment    := COALESCE (tmpJuridicalOrderFinance.Comment, tmpJuridicalOrderFinance_last.Comment)
                                                        , inNOM_DOG    := COALESCE (tmpMI.ContractName, '')
                                                        , inNOM_IVOICE := COALESCE (tmpMI.InvNumber_Invoice_Child, '')
                                                        , inTOVAR      := COALESCE (tmpMI.GoodsName_Child, '')
                                                        , inDATA_DOG   := COALESCE (tmpMI.StartDate, zc_DateStart())
                                                        , inPDV        := 20
                                                        , inSUMMA_P    := tmpMI.AmountPlan_5
                                                         )

               ELSE ''
          END :: TVarChar AS Comment_pay

        , COALESCE (tmpJuridicalOrderFinance.JuridicalOrderFinanceId, tmpJuridicalOrderFinance_last.JuridicalOrderFinanceId)  ::Integer  AS JuridicalOrderFinanceId
        , COALESCE (tmpJuridicalOrderFinance.Comment, tmpJuridicalOrderFinance_last.Comment)                                  ::TVarChar AS Comment_jof          -- JuridicalOrderFinance
        , COALESCE (tmpJuridicalOrderFinance.BankAccountId, tmpJuridicalOrderFinance_last.BankAccountId)                      ::Integer  AS BankAccountId_jof    -- JuridicalOrderFinance
        , COALESCE (tmpJuridicalOrderFinance.BankAccountName, tmpJuridicalOrderFinance_last.BankAccountName)                  ::TVarChar AS BankAccountName_jof  -- JuridicalOrderFinance
        , COALESCE (tmpJuridicalOrderFinance.BankId, tmpJuridicalOrderFinance_last.BankId )                                   ::Integer  AS BankId_jof
        , COALESCE (tmpJuridicalOrderFinance.BankName, tmpJuridicalOrderFinance_last.BankName)                                ::TVarChar AS BankName_jof
        , COALESCE (tmpJuridicalOrderFinance.MFO, tmpJuridicalOrderFinance_last.MFO)                                          ::TVarChar AS MFO_jof

          --  child
        , tmpMI.MovementItemId_Child    ::Integer
        , tmpMI.InvNumber_Child         ::TVarChar
        , tmpMI.InvNumber_Invoice_Child ::TVarChar
        , tmpMI.GoodsName_Child         ::TVarChar

        , tmpMI.isSign_Child            ::Boolean
        , CASE WHEN tmpMI.isSign_Child = TRUE THEN 'Погоджено'
               WHEN tmpMI.isSign_Child = FALSE THEN 'Не погоджено'
               ELSE ''
          END ::TVarChar AS TextSign_Child

          -- Detail
        , tmpMI.MovementItemId_Detail_1 ::Integer
        , tmpMI.MovementItemId_Detail_2 ::Integer
        , tmpMI.MovementItemId_Detail_3 ::Integer
        , tmpMI.MovementItemId_Detail_4 ::Integer
        , tmpMI.MovementItemId_Detail_5 ::Integer

        , CASE WHEN tmpMI.isSign_Child = FALSE
                    -- подсветили если Не погоджено
                    THEN zc_Color_Aqua()
               ELSE zc_Color_White()
          END ::Integer AS ColorFon_record

   FROM tmpMovement_Data AS tmpMovement
        LEFT JOIN tmpMI_Data AS tmpMI ON tmpMI.MovementId = tmpMovement.MovementId
        
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
   -- или план по дням
   WHERE tmpMI.AmountPlan_1 <> 0
      OR tmpMI.AmountPlan_2 <> 0
      OR tmpMI.AmountPlan_3 <> 0
      OR tmpMI.AmountPlan_4 <> 0
      OR tmpMI.AmountPlan_5 <> 0
      -- или Первичный план на неделю
      OR (tmpMI.JuridicalId > 0 AND tmpMI.Amount <> 0)
      -- или Платежный план на неделю
      OR (tmpMI.JuridicalId > 0 AND tmpMI.AmountPlan_next <> 0)
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.12.25         *
 20.11.25         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderFinance_Plan_5 (inStartDate:= '01.11.2025', inEndDate:= '30.12.2025', inStartWeekNumber:=47, inEndWeekNumber := 48, inIsDay_1:=FALSE, inIsDay_2:=FALSE, inIsDay_3:=FALSE, inIsDay_4:=FALSE, inIsDay_5:=FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_Movement_OrderFinance_Plan_5 (inStartDate:= '01.11.2025', inEndDate:= '30.12.2025', inBankMainId:=76970, inStartWeekNumber:=47, inEndWeekNumber := 48, inIsDay_1:=FALSE, inIsDay_2:=FALSE, inIsDay_3:=FALSE, inIsDay_4:=FALSE, inIsDay_5:=FALSE, inSession:= '2')
