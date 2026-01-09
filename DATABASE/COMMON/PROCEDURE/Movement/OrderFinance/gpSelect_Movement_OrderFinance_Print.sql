
-- Function: gpSelect_Movement_Income_Print()
DROP FUNCTION IF EXISTS gpSelect_Movement_OrderFinance_Print (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderFinance_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbOperDate TDateTime;
    DECLARE vbInvNumber TVarChar;
    DECLARE vbOrderFinanceId Integer;
    DECLARE vbMovementId_old    Integer;
    DECLARE vbWeekNumber        TFloat;
    DECLARE vbWeekNumber_old    TFloat;
    DECLARE vbIsPlan_1_old      Boolean;
    DECLARE vbIsPlan_2_old      Boolean;
    DECLARE vbIsPlan_3_old      Boolean;
    DECLARE vbIsPlan_4_old      Boolean;
    DECLARE vbIsPlan_5_old      Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income_Print());
     vbUserId:= lpGetUserBySession (inSession);


     -- нашли
     vbIsPlan_1_old:= FALSE;
     vbIsPlan_2_old:= FALSE;
     vbIsPlan_3_old:= FALSE;
     vbIsPlan_4_old:= FALSE;
     vbIsPlan_5_old:= TRUE;


     -- параметры из документа
     SELECT Movement.DescId
          , Movement.StatusId
          , Movement.OperDate
          , Movement.InvNumber         ::TVarChar AS InvNumber 
          , MLO_OrderFinance.ObjectId  ::Integer  AS OrderFinanceId

            INTO vbDescId, vbStatusId, vbOperDate, vbInvNumber, vbOrderFinanceId
     FROM Movement
           LEFT JOIN MovementLinkObject AS MLO_OrderFinance
                                        ON MLO_OrderFinance.MovementId = Movement.Id
                                       AND MLO_OrderFinance.DescId = zc_MovementLinkObject_OrderFinance()   
     WHERE Movement.Id = inMovementId
       -- AND Movement.StatusId = zc_Enum_Status_Complete()
    ;

     -- нашли
     vbWeekNumber := (SELECT MovementFloat.ValueData
                      FROM MovementFloat
                      WHERE MovementFloat.MovementId = inMovementId
                        AND MovementFloat.DescId     = zc_MovementFloat_WeekNumber()
                     );

     -- начало недели минус 7 дней
     vbWeekNumber_old := EXTRACT (WEEK FROM zfCalc_Week_StartDate (vbOperDate, vbWeekNumber) - INTERVAL '7 DAY') ;

     -- план прошлой недели
     vbMovementId_old:= (SELECT Movement.Id
                         FROM Movement
                              INNER JOIN MovementFloat AS MovementFloat_WeekNumber
                                                       ON MovementFloat_WeekNumber.MovementId = Movement.Id
                                                      AND MovementFloat_WeekNumber.DescId     = zc_MovementFloat_WeekNumber()
                                                      AND MovementFloat_WeekNumber.ValueData  = vbWeekNumber_old
                              INNER JOIN MovementLinkObject AS MovementLinkObject_OrderFinance
                                                            ON MovementLinkObject_OrderFinance.MovementId = Movement.Id
                                                           AND MovementLinkObject_OrderFinance.DescId     = zc_MovementLinkObject_OrderFinance()
                                                           AND MovementLinkObject_OrderFinance.ObjectId   = vbOrderFinanceId
  
                         WHERE Movement.DescId = zc_Movement_OrderFinance()
                           AND Movement.StatusId IN (zc_Enum_Status_Complete()) -- zc_Enum_Status_UnComplete()
                           AND Movement.OperDate BETWEEN vbOperDate - INTERVAL '14 DAY' AND vbOperDate - INTERVAL '1 DAY'
                         );


     -- очень важная проверка
    IF 1=0 -- COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete() OR vbUserId <> 9457 --OR vbUserId = 5
    THEN
        IF vbStatusId = zc_Enum_Status_Erased() OR vbUserId = 5
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        IF vbStatusId = zc_Enum_Status_UnComplete()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
    END IF;

    --
    OPEN Cursor1 FOR
    WITH 
    
    tmpMovementFloat AS (SELECT MovementFloat.*
                         FROM MovementFloat
                         WHERE MovementFloat.MovementId = inMovementId
                           AND MovementFloat.DescId IN (zc_MovementFloat_WeekNumber()
                                                        )
                         )

  , tmpMovementString AS (SELECT MovementString.*
                           FROM MovementString
                           WHERE MovementString.MovementId = inMovementId
                             AND MovementString.DescId IN (zc_MovementString_Comment()
                                                          )
                         )

  , tmpMovementLinkObject AS (SELECT MovementLinkObject.*
                           FROM MovementLinkObject
                           WHERE MovementLinkObject.MovementId = inMovementId
                         )
         -- Результат
         SELECT
             Movement.Id
           , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement.Id) AS IdBarCode
           , Movement.InvNumber InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode          AS StatusCode
           , Object_Status.ValueData           AS StatusName

           , Object_OrderFinance.Id            AS OrderFinanceId
           , Object_OrderFinance.ValueData     AS OrderFinanceName

           , Object_BankAccount_View.Id        AS BankAccountId
           , Object_BankAccount_View.Name      AS BankAccountName
           , Object_BankAccount_View.BankId
           , Object_BankAccount_View.BankName
           , (Object_BankAccount_View.BankName || '' || Object_BankAccount_View.Name) :: TVarChar AS BankAccountNameAll

           , MovementFloat_WeekNumber.ValueData   ::TFloat    AS WeekNumber
           , zfCalc_Week_StartDate (Movement.OperDate, MovementFloat_WeekNumber.ValueData) AS StartDate_WeekNumber
           , zfCalc_Week_EndDate   (Movement.OperDate, MovementFloat_WeekNumber.ValueData) AS EndDate_WeekNumber
           
           --, MovementDate_Update_report.ValueData ::TDateTime AS DateUpdate_report
           , Object_Update_report.ValueData       ::TVarChar  AS UserUpdate_report
           , Object_Member_1.ValueData            ::TVarChar  AS UserMember_1
           , Object_Member_2.ValueData            ::TVarChar  AS UserMember_2

           , MovementString_Comment.ValueData       AS Comment 

           , Object_Insert.ValueData                AS InsertName
           , MovementDate_Insert.ValueData          AS InsertDate
           , Object_Unit_insert.ValueData      ::TVarChar AS UnitName_insert
           , Object_Position_insert.ValueData  ::TVarChar AS PositionName_insert          
           
           , CASE WHEN COALESCE (MovementBoolean_Sign_1.ValueData, FALSE) = FALSE THEN '' 
                  ELSE zfConvert_DateToString (MovementDate_Sign_1.ValueData)
             END  ::TVarChar AS Date_Sign_1

           , CASE WHEN COALESCE (MovementBoolean_Sign_1.ValueData, FALSE) = FALSE THEN 'Не согласовано' 
                  ELSE 'Согласовано'
             END  ::TVarChar AS Text_Sign_1       
       FROM Movement
          --  JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_WeekNumber
                                    ON MovementFloat_WeekNumber.MovementId = Movement.Id
                                   AND MovementFloat_WeekNumber.DescId = zc_MovementFloat_WeekNumber()

            LEFT JOIN tmpMovementString AS MovementString_Comment
                                        ON MovementString_Comment.MovementId = Movement.Id
                                       AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_OrderFinance
                                            ON MovementLinkObject_OrderFinance.MovementId = Movement.Id
                                           AND MovementLinkObject_OrderFinance.DescId = zc_MovementLinkObject_OrderFinance()
            LEFT JOIN Object AS Object_OrderFinance ON Object_OrderFinance.Id = MovementLinkObject_OrderFinance.ObjectId

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_BankAccount
                                            ON MovementLinkObject_BankAccount.MovementId = Movement.Id
                                           AND MovementLinkObject_BankAccount.DescId = zc_MovementLinkObject_BankAccount()
            LEFT JOIN Object_BankAccount_View ON Object_BankAccount_View.Id = MovementLinkObject_BankAccount.ObjectId

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_Update_report
                                            ON MovementLinkObject_Update_report.MovementId = Movement.Id
                                           AND MovementLinkObject_Update_report.DescId = zc_MovementLinkObject_Update_report()
            LEFT JOIN Object AS Object_Update_report ON Object_Update_report.Id = MovementLinkObject_Update_report.ObjectId

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_Member_1
                                            ON MovementLinkObject_Member_1.MovementId = Movement.Id
                                           AND MovementLinkObject_Member_1.DescId = zc_MovementLinkObject_Member_1()
            LEFT JOIN Object AS Object_Member_1 ON Object_Member_1.Id = MovementLinkObject_Member_1.ObjectId

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_Member_2
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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit_insert ON Object_Unit_insert.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Position
                                         ON MovementLinkObject_Position.MovementId = Movement.Id
                                        AND MovementLinkObject_Position.DescId = zc_MovementLinkObject_Position()
            LEFT JOIN Object AS Object_Position_insert ON Object_Position_insert.Id = MovementLinkObject_Position.ObjectId                           

            LEFT JOIN MovementDate AS MovementDate_Sign_1
                                   ON MovementDate_Sign_1.MovementId = Movement.Id
                                  AND MovementDate_Sign_1.DescId = zc_MovementDate_Sign_1()

            LEFT JOIN MovementBoolean AS MovementBoolean_Sign_1
                                      ON MovementBoolean_Sign_1.MovementId = Movement.Id
                                     AND MovementBoolean_Sign_1.DescId = zc_MovementBoolean_Sign_1()
      WHERE Movement.Id = inMovementId
        AND Movement.DescId = zc_Movement_OrderFinance();
     
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
    WITH
       tmpMI AS (SELECT MovementItem.*
                      , MILinkObject_Contract.ObjectId AS ContractId
                 FROM MovementItem
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                       ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId     = zc_MI_Master()
                   AND MovementItem.isErased   = FALSE                
                 ) 

     , tmpContractCondition AS (SELECT Object_ContractCondition_View.ContractId
                              --, Object_ContractCondition_View.ContractConditionId
                              --, Object_ContractCondition_View.ContractConditionKindId
                              --, Object_ContractCondition_View.Value
                              , (Object_ContractCondition_View.Value::Integer
                                ||' '|| CASE WHEN Object_ContractCondition_View.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayDayCalendar()
                                                 THEN 'К.дн.'
                                             WHEN Object_ContractCondition_View.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayDayBank()
                                                     THEN 'Б.дн.'
                                             ELSE ''
                                        END
                                 ) AS Condition
                         FROM Object_ContractCondition_View
                         WHERE Object_ContractCondition_View.ContractConditionKindId IN (zc_Enum_ContractConditionKind_DelayDayCalendar(), zc_Enum_ContractConditionKind_DelayDayBank())
                           AND Object_ContractCondition_View.Value <> 0
                           AND Object_ContractCondition_View.ContractId IN (SELECT DISTINCT tmpMI.ContractId FROM tmpMI)
                           AND vbOperDate BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                         )
     , tmpContract_View AS (SELECT * FROM Object_Contract_View WHERE Object_Contract_View.ContractId IN (SELECT DISTINCT tmpMI.ContractId FROM tmpMI)) 
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
                                     )
     , tmpMovementItemString AS (SELECT *
                                 FROM MovementItemString
                                 WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                   AND MovementItemString.DescId = zc_MIString_Comment()
                                 )
                                 

     -- статьи для группировки
     , tmpOrderFinanceProperty AS (SELECT DISTINCT OrderFinanceProperty_Object.ChildObjectId AS Id
                                        , ObjectFloat_Group.ValueData                        AS NumGroup
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

                                   WHERE OrderFinanceProperty_OrderFinance.ChildObjectId = vbOrderFinanceId
                                     AND OrderFinanceProperty_OrderFinance.DescId = zc_ObjectLink_OrderFinanceProperty_OrderFinance()
                                   )

      , tmpInfoMoney_OFP AS (SELECT DISTINCT Object_InfoMoney_View.InfoMoneyId, tmpOrderFinanceProperty.NumGroup
                             FROM Object_InfoMoney_View
                                  INNER JOIN tmpOrderFinanceProperty ON (tmpOrderFinanceProperty.Id = Object_InfoMoney_View.InfoMoneyId
                                                                      OR tmpOrderFinanceProperty.Id = Object_InfoMoney_View.InfoMoneyDestinationId
                                                                      OR tmpOrderFinanceProperty.Id = Object_InfoMoney_View.InfoMoneyGroupId)
                             )
       -- план прошлой недели
     , tmpMI_old AS (SELECT MovementItem.Id                AS MovementItemId
                          , MovementItem.ObjectId          AS JuridicalId
                          , MILinkObject_Contract.ObjectId AS ContractId
                     FROM MovementItem
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                            ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                     WHERE MovementItem.MovementId = vbMovementId_old
                       AND MovementItem.DescId     = zc_MI_Master()
                       AND MovementItem.isErased   = FALSE
                    )
     , tmpMovementItemFloat_old AS (SELECT *
                                    FROM MovementItemFloat
                                    WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_old.MovementItemId FROM tmpMI_old)
                                      AND MovementItemFloat.DescId IN (zc_MIFloat_AmountPlan_1()
                                                                     , zc_MIFloat_AmountPlan_2()
                                                                     , zc_MIFloat_AmountPlan_3()
                                                                     , zc_MIFloat_AmountPlan_4()
                                                                     , zc_MIFloat_AmountPlan_5()
                                                                      )
                                   )
       -- Результат
       SELECT
             inMovementId                     AS MovementId
           , MovementItem.Id                  AS Id
           , Object_Juridical.Id              AS JuridicalId
           , Object_Juridical.ObjectCode      AS JuridicalCode
           , Object_Juridical.ValueData       AS JuridicalName
           , tmpJuridicalDetails_View.OKPO

           , Object_Contract.Id               AS ContractId
           , Object_Contract.ObjectCode       AS ContractCode
           , Object_Contract.ValueData        AS ContractName
           , Object_PaidKind.ValueData        AS PaidKindName
           , Object_InfoMoney.ValueData       AS InfoMoneyName
           , tmpContractCondition.Condition ::TVarChar AS Condition
           --, ObjectDate_Start.ValueData       AS StartDate
           , View_Contract.StartDate
           , View_Contract.EndDate_real
           , (''|| CASE WHEN View_Contract.ContractTermKindId = zc_Enum_ContractTermKind_Long() THEN '* ' ELSE '' END
                || (LPAD (EXTRACT (Day FROM View_Contract.EndDate_term) :: TVarChar,2,'0') ||'.'||LPAD (EXTRACT (Month FROM View_Contract.EndDate_term) :: TVarChar,2,'0') ||'.'||EXTRACT (YEAR FROM View_Contract.EndDate_term) :: TVarChar)
             ) ::TVarChar AS EndDate


             -- Предварительный План на неделю
           , MovementItem.Amount               :: TFloat AS Amount
             -- Нач. долг
           , (COALESCE (MIFloat_AmountRemains.ValueData, 0) - CASE WHEN vbIsPlan_1_old = TRUE THEN COALESCE (MIFloat_AmountPlan_1_old.ValueData, 0) ELSE 0 END
                                                            - CASE WHEN vbIsPlan_2_old = TRUE THEN COALESCE (MIFloat_AmountPlan_2_old.ValueData, 0) ELSE 0 END
                                                            - CASE WHEN vbIsPlan_3_old = TRUE THEN COALESCE (MIFloat_AmountPlan_3_old.ValueData, 0) ELSE 0 END
                                                            - CASE WHEN vbIsPlan_4_old = TRUE THEN COALESCE (MIFloat_AmountPlan_4_old.ValueData, 0) ELSE 0 END
                                                            - CASE WHEN vbIsPlan_5_old = TRUE THEN COALESCE (MIFloat_AmountPlan_5_old.ValueData, 0) ELSE 0 END
             ) :: TFloat AS AmountRemains
             -- Долг с отсрочкой
           , (COALESCE (MIFloat_AmountPartner.ValueData, 0) - CASE WHEN vbIsPlan_1_old = TRUE THEN COALESCE (MIFloat_AmountPlan_1_old.ValueData, 0) ELSE 0 END
                                                            - CASE WHEN vbIsPlan_2_old = TRUE THEN COALESCE (MIFloat_AmountPlan_2_old.ValueData, 0) ELSE 0 END
                                                            - CASE WHEN vbIsPlan_3_old = TRUE THEN COALESCE (MIFloat_AmountPlan_3_old.ValueData, 0) ELSE 0 END
                                                            - CASE WHEN vbIsPlan_4_old = TRUE THEN COALESCE (MIFloat_AmountPlan_4_old.ValueData, 0) ELSE 0 END
                                                            - CASE WHEN vbIsPlan_5_old = TRUE THEN COALESCE (MIFloat_AmountPlan_5_old.ValueData, 0) ELSE 0 END
             ) :: TFloat AS AmountPartner
             -- Приход
           , MIFloat_AmountSumm.ValueData      :: TFloat AS AmountSumm
             -- Просрочка
           , MIFloat_AmountPartner_1.ValueData :: TFloat AS AmountPartner_1
           , MIFloat_AmountPartner_2.ValueData :: TFloat AS AmountPartner_2
           , MIFloat_AmountPartner_3.ValueData :: TFloat AS AmountPartner_3
           , MIFloat_AmountPartner_4.ValueData :: TFloat AS AmountPartner_4
           , (COALESCE (MIFloat_AmountPartner.ValueData,0)
              - COALESCE (MIFloat_AmountPartner_1.ValueData,0)
              - COALESCE (MIFloat_AmountPartner_2.ValueData,0)
              - COALESCE (MIFloat_AmountPartner_3.ValueData,0)
              - COALESCE (MIFloat_AmountPartner_4.ValueData,0)
             )   :: TFloat AS AmountPartner_5                -->28дней

             -- План оплат
           , MIFloat_AmountPlan_1.ValueData    :: TFloat AS AmountPlan_1
           , MIFloat_AmountPlan_2.ValueData    :: TFloat AS AmountPlan_2
           , MIFloat_AmountPlan_3.ValueData    :: TFloat AS AmountPlan_3
           , MIFloat_AmountPlan_4.ValueData    :: TFloat AS AmountPlan_4
           , MIFloat_AmountPlan_5.ValueData    :: TFloat AS AmountPlan_5
             --
           , COALESCE (tmpInfoMoney_OFP.NumGroup, 999) ::Integer AS NumGroup
           , COALESCE (tmpInfoMoney_OFP.NumGroup, Object_InfoMoney.ObjectCode) ::Integer AS NumGroupRes  --для сортировки итогов

       FROM tmpMI AS MovementItem
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementItem.ObjectId
                                                AND Object_Juridical.DescId = zc_Object_Juridical()

            -- план прошлой недели
            LEFT JOIN tmpMI_old ON tmpMI_old.JuridicalId = MovementItem.ObjectId
                               AND tmpMI_old.ContractId  = MovementItem.ContractId
            LEFT JOIN tmpMovementItemFloat_old AS MIFloat_AmountPlan_1_old
                                               ON MIFloat_AmountPlan_1_old.MovementItemId = tmpMI_old.MovementItemId
                                              AND MIFloat_AmountPlan_1_old.DescId = zc_MIFloat_AmountPlan_1()
            LEFT JOIN tmpMovementItemFloat_old AS MIFloat_AmountPlan_2_old
                                               ON MIFloat_AmountPlan_2_old.MovementItemId = tmpMI_old.MovementItemId
                                              AND MIFloat_AmountPlan_2_old.DescId = zc_MIFloat_AmountPlan_2()
            LEFT JOIN tmpMovementItemFloat_old AS MIFloat_AmountPlan_3_old
                                               ON MIFloat_AmountPlan_3_old.MovementItemId = tmpMI_old.MovementItemId
                                              AND MIFloat_AmountPlan_3_old.DescId = zc_MIFloat_AmountPlan_3()
            LEFT JOIN tmpMovementItemFloat_old AS MIFloat_AmountPlan_4_old
                                               ON MIFloat_AmountPlan_4_old.MovementItemId = tmpMI_old.MovementItemId
                                              AND MIFloat_AmountPlan_4_old.DescId = zc_MIFloat_AmountPlan_4()
            LEFT JOIN tmpMovementItemFloat_old AS MIFloat_AmountPlan_5_old
                                               ON MIFloat_AmountPlan_5_old.MovementItemId = tmpMI_old.MovementItemId
                                              AND MIFloat_AmountPlan_5_old.DescId = zc_MIFloat_AmountPlan_5()


            LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountRemains
                                           ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountRemains.DescId = zc_MIFloat_AmountRemains()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPartner
                                           ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountSumm
                                           ON MIFloat_AmountSumm.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountSumm.DescId = zc_MIFloat_AmountSumm()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPartner_1
                                           ON MIFloat_AmountPartner_1.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountPartner_1.DescId = zc_MIFloat_AmountPartner_1()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPartner_2
                                           ON MIFloat_AmountPartner_2.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountPartner_2.DescId = zc_MIFloat_AmountPartner_2()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPartner_3
                                           ON MIFloat_AmountPartner_3.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountPartner_3.DescId = zc_MIFloat_AmountPartner_3()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPartner_4
                                           ON MIFloat_AmountPartner_4.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountPartner_4.DescId = zc_MIFloat_AmountPartner_4()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_1
                                           ON MIFloat_AmountPlan_1.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountPlan_1.DescId = zc_MIFloat_AmountPlan_1()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_2
                                           ON MIFloat_AmountPlan_2.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountPlan_2.DescId = zc_MIFloat_AmountPlan_2()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_3
                                           ON MIFloat_AmountPlan_3.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountPlan_3.DescId = zc_MIFloat_AmountPlan_3()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_4
                                           ON MIFloat_AmountPlan_4.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountPlan_4.DescId = zc_MIFloat_AmountPlan_4()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_5
                                           ON MIFloat_AmountPlan_5.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountPlan_5.DescId = zc_MIFloat_AmountPlan_5()

            LEFT JOIN tmpMovementItemString AS MIString_Comment
                                            ON MIString_Comment.MovementItemId = MovementItem.Id
                                           AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementItem.ContractId     --MILinkObject_Contract.ObjectId

            LEFT JOIN tmpJuridicalDetails_View ON tmpJuridicalDetails_View.JuridicalId = Object_Juridical.Id

            LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                 ON ObjectLink_Contract_InfoMoney.ObjectId = Object_Contract.Id
                                AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, MovementItem.ObjectId)
                                                AND Object_InfoMoney.DescId = zc_Object_InfoMoney()

            LEFT JOIN tmpContract_View AS View_Contract ON View_Contract.ContractId = Object_Contract.Id
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = View_Contract.PaidKindId 
            LEFT JOIN tmpContractCondition ON tmpContractCondition.ContractId = Object_Contract.Id 
            
            LEFT JOIN tmpInfoMoney_OFP ON tmpInfoMoney_OFP.InfoMoneyId = Object_InfoMoney.Id
            ;
    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.11.25         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderFinance_Print (inMovementId := 19727298, inSession:= '5'); -- FETCH ALL "<unnamed portal 10>";
