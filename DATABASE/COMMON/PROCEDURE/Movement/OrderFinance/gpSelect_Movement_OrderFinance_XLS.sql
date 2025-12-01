-- Function:  gpSelect_Movement_OrderFinance_XLS()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderFinance_XLS (Integer, TVarChar);

CREATE OR REPLACE FUNCTION  gpSelect_Movement_OrderFinance_XLS(
    IN inMovementId       Integer  ,  -- Подразделение
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (OKPO             TVarChar
             , PaidKindName     TVarChar
             , ContractName     TVarChar
             , StartDate        TVarChar
             , EndDate_real     TVarChar
             , Condition        TVarChar
             , JuridicalName    TVarChar
             , InfoMoneyName    TVarChar
             , AmountRemains    TVarChar
             , AmountSumm       TVarChar
             , AmountPartner_1  TVarChar
             , AmountPartner_2  TVarChar
             , AmountPartner_3  TVarChar
             , AmountPartner_4  TVarChar
             , AmountPartner_5  TVarChar
             , AmountPartner    TVarChar
             , Amount           TVarChar
               )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbOrderFinanceId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

     -- параметры из документа
     SELECT Movement.OperDate
          , MLO_OrderFinance.ObjectId  ::Integer  AS OrderFinanceId

            INTO vbOperDate, vbOrderFinanceId
     FROM Movement
           LEFT JOIN MovementLinkObject AS MLO_OrderFinance
                                        ON MLO_OrderFinance.MovementId = Movement.Id
                                       AND MLO_OrderFinance.DescId = zc_MovementLinkObject_OrderFinance()   
     WHERE Movement.Id = inMovementId
       -- AND Movement.StatusId = zc_Enum_Status_Complete()
    ;

     RETURN QUERY
     WITH      
     tmpMovement AS (WITH 
                     tmpMovementFloat AS (SELECT MovementFloat.*
                                          FROM MovementFloat
                                          WHERE MovementFloat.MovementId = inMovementId
                                            AND MovementFloat.DescId IN (zc_MovementFloat_WeekNumber()
                                                                         )
                                          )
      
                   , tmpMovementLinkObject AS (SELECT MovementLinkObject.*
                                               FROM MovementLinkObject
                                               WHERE MovementLinkObject.MovementId = inMovementId
                                               )


                     SELECT
                         Movement.Id
                       , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement.Id) AS IdBarCode
                       , Movement.InvNumber InvNumber
                       , Movement.OperDate
                       , Object_Status.ObjectCode          AS StatusCode
                       , Object_Status.ValueData           AS StatusName
            
                       , Object_OrderFinance.Id            AS OrderFinanceId
                       , Object_OrderFinance.ValueData     AS OrderFinanceName
            
                       , MovementFloat_WeekNumber.ValueData   ::TFloat    AS WeekNumber
                       , DATE_TRUNC ('WEEK', DATE_TRUNC ('YEAR', Movement.OperDate) + ((((7 * COALESCE (MovementFloat_WeekNumber.ValueData - 1, 0)) :: Integer) :: TVarChar) || ' DAY' ):: INTERVAL) ::TDateTime AS StartDate_WeekNumber
                       , (DATE_TRUNC ('WEEK', DATE_TRUNC ('YEAR', Movement.OperDate) + ((((7 * COALESCE (MovementFloat_WeekNumber.ValueData - 1, 0)) :: Integer) :: TVarChar) || ' DAY' ):: INTERVAL) + INTERVAL '6 DAY') ::TDateTime AS EndDate_WeekNumber
            
                       , Object_Member_1.ValueData            ::TVarChar  AS UserMember_1
            
                       , Object_Insert.ValueData                AS InsertName
                       , MovementDate_Insert.ValueData          AS InsertDate
                       , Object_Position_insert.ValueData  ::TVarChar AS PositionName_insert          
                       
                       , CASE WHEN COALESCE (MovementBoolean_Sign_1.ValueData, FALSE) = FALSE THEN '' 
                              ELSE zfConvert_DateToString (MovementDate_Sign_1.ValueData)
                         END  ::TVarChar AS Date_Sign_1
            
                       , CASE WHEN COALESCE (MovementBoolean_Sign_1.ValueData, FALSE) = FALSE THEN 'Не согласовано' 
                              ELSE 'Согласовано'
                         END  ::TVarChar AS Text_Sign_1       
                   FROM Movement
                        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            
                        LEFT JOIN MovementFloat AS MovementFloat_WeekNumber
                                                ON MovementFloat_WeekNumber.MovementId = Movement.Id
                                               AND MovementFloat_WeekNumber.DescId = zc_MovementFloat_WeekNumber()
            
                       LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_OrderFinance
                                                       ON MovementLinkObject_OrderFinance.MovementId = Movement.Id
                                                      AND MovementLinkObject_OrderFinance.DescId = zc_MovementLinkObject_OrderFinance()
                        LEFT JOIN Object AS Object_OrderFinance ON Object_OrderFinance.Id = MovementLinkObject_OrderFinance.ObjectId
            
                        LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_Member_1
                                                        ON MovementLinkObject_Member_1.MovementId = Movement.Id
                                                       AND MovementLinkObject_Member_1.DescId = zc_MovementLinkObject_Member_1()
                        LEFT JOIN Object AS Object_Member_1 ON Object_Member_1.Id = MovementLinkObject_Member_1.ObjectId
            
                        LEFT JOIN MovementDate AS MovementDate_Insert
                                               ON MovementDate_Insert.MovementId = Movement.Id
                                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            
                        LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_Insert
                                                        ON MovementLinkObject_Insert.MovementId = Movement.Id
                                                       AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
                        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId
            
                        LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_Position
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
                    AND Movement.DescId = zc_Movement_OrderFinance()
                 )

    ,  tmpMI AS (SELECT MovementItem.*
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

      , tmpMI_Data AS (SELECT
                               MovementItem.Id                  AS Id
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
                  
                  
                             , MovementItem.Amount               :: TFloat AS Amount
                             , MIFloat_AmountRemains.ValueData   :: TFloat AS AmountRemains
                             , MIFloat_AmountPartner.ValueData   :: TFloat AS AmountPartner
                             , MIFloat_AmountSumm.ValueData      :: TFloat AS AmountSumm
                             , MIFloat_AmountPartner_1.ValueData :: TFloat AS AmountPartner_1
                             , MIFloat_AmountPartner_2.ValueData :: TFloat AS AmountPartner_2
                             , MIFloat_AmountPartner_3.ValueData :: TFloat AS AmountPartner_3
                             , MIFloat_AmountPartner_4.ValueData :: TFloat AS AmountPartner_4 
                             , (COALESCE (MIFloat_AmountPartner.ValueData,0)
                                 - COALESCE (MIFloat_AmountPartner_1.ValueData,0)
                                 - COALESCE (MIFloat_AmountPartner_2.ValueData,0)
                                 - COALESCE (MIFloat_AmountPartner_3.ValueData,0)
                                 - COALESCE (MIFloat_AmountPartner_4.ValueData,0)
                                )   :: TFloat AS AmountPartner_5 
                             , MIFloat_AmountPlan_1.ValueData    :: TFloat AS AmountPlan_1
                             , MIFloat_AmountPlan_2.ValueData    :: TFloat AS AmountPlan_2
                             , MIFloat_AmountPlan_3.ValueData    :: TFloat AS AmountPlan_3
                             , MIFloat_AmountPlan_4.ValueData    :: TFloat AS AmountPlan_4
                             , MIFloat_AmountPlan_5.ValueData    :: TFloat AS AmountPlan_5
                             --
                             , COALESCE (tmpInfoMoney_OFP.NumGroup, 999) ::Integer AS NumGroup
                             , ROW_NUMBER() OVER (ORDER BY COALESCE (tmpInfoMoney_OFP.NumGroup, 999), Object_InfoMoney.ValueData, Object_Juridical.ValueData) AS Ord
                         FROM tmpMI AS MovementItem
                              LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementItem.ObjectId
                                                                  AND Object_Juridical.DescId = zc_Object_Juridical()
                  
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
                         )

       SELECT  tmp.OKPO             ::TVarChar
             , tmp.PaidKindName     ::TVarChar
             , tmp.ContractName     ::TVarChar
             , tmp.StartDate        ::TVarChar
             , tmp.EndDate_real     ::TVarChar
             , tmp.Condition        ::TVarChar
             , tmp.JuridicalName    ::TVarChar
             , tmp.InfoMoneyName    ::TVarChar
             , tmp.AmountRemains    ::TVarChar
             , tmp.AmountSumm       ::TVarChar
             , tmp.AmountPartner_1  ::TVarChar
             , tmp.AmountPartner_2  ::TVarChar
             , tmp.AmountPartner_3  ::TVarChar
             , tmp.AmountPartner_4  ::TVarChar
             , tmp.AmountPartner_5  ::TVarChar
             , tmp.AmountPartner    ::TVarChar
             , tmp.Amount           ::TVarChar
       FROM (SELECT  ('Документ № '||tmpMovement.InvNumber||' от ' || zfConvert_DateToString (tmpMovement.OperDate) ) ::TVarChar AS OKPO
                    , '' ::TVarChar AS PaidKindName
                    , '' ::TVarChar AS ContractName
                    , '' ::TVarChar AS StartDate
                    , '' ::TVarChar AS EndDate_real
                    , '' ::TVarChar AS Condition 
                    , '' ::TVarChar AS JuridicalName
                    , '' ::TVarChar AS InfoMoneyName
                    , '' ::TVarChar AS AmountRemains
                    , '' ::TVarChar AS AmountSumm
                    , '' ::TVarChar AS AmountPartner_1
                    , '' ::TVarChar AS AmountPartner_2
                    , '' ::TVarChar AS AmountPartner_3
                    , '' ::TVarChar AS AmountPartner_4
                    , '' ::TVarChar AS AmountPartner_5
                    , '' ::TVarChar AS AmountPartner
                    , '' ::TVarChar AS Amount 
                    , 1 AS Ord
                    , '' AS Ord1
              FROM tmpMovement
            UNION
              SELECT  ('№ недели'||tmpMovement.WeekNumber ) ::TVarChar AS OKPO
                    , '' ::TVarChar AS PaidKindName
                    , ('Вид планирования '||tmpMovement.OrderFinanceName) ::TVarChar AS ContractName
                    , '' ::TVarChar AS StartDate
                    , '' ::TVarChar AS EndDate_real
                    , '' ::TVarChar AS Condition 
                    , '' ::TVarChar AS JvuridicalName
                    , '' ::TVarChar AS InfoMoneyName
                    , '' ::TVarChar AS AmountRemains
                    , '' ::TVarChar AS AmountSumm
                    , '' ::TVarChar AS AmountPartner_1
                    , '' ::TVarChar AS AmountPartner_2
                    , '' ::TVarChar AS AmountPartner_3
                    , '' ::TVarChar AS AmountPartner_4
                    , '' ::TVarChar AS AmountPartner_5
                    , '' ::TVarChar AS AmountPartner
                    , '' ::TVarChar AS Amount
                    , 2 AS Ord
                    , '' AS Ord1
              FROM tmpMovement
            UNION
              SELECT  ('Автор заявки '||tmpMovement.InsertName||',' || tmpMovement.PositionName_insert ) ::TVarChar AS OKPO
                    , '' ::TVarChar AS PaidKindName
                    , '' ::TVarChar AS ContractName
                    , '' ::TVarChar AS StartDate
                    , '' ::TVarChar AS EndDate_real
                    , '' ::TVarChar AS Condition 
                    , '' ::TVarChar AS JvuridicalName
                    , '' ::TVarChar AS InfoMoneyName
                    , '' ::TVarChar AS AmountRemains
                    , '' ::TVarChar AS AmountSumm
                    , '' ::TVarChar AS AmountPartner_1
                    , '' ::TVarChar AS AmountPartner_2
                    , '' ::TVarChar AS AmountPartner_3
                    , '' ::TVarChar AS AmountPartner_4
                    , '' ::TVarChar AS AmountPartner_5
                    , '' ::TVarChar AS AmountPartner
                    , '' ::TVarChar AS Amount
                    , 3 AS Ord
                    , '' AS Ord1
              FROM tmpMovement
            UNION
            SELECT  (''||tmpMovement.text_sign_1||', ' || tmpMovement.UserMember_1|| ' '|| tmpMovement.Date_Sign_1) ::TVarChar AS OKPO
                    , '' ::TVarChar AS PaidKindName
                    , '' ::TVarChar AS ContractName
                    , '' ::TVarChar AS StartDate
                    , '' ::TVarChar AS EndDate_real
                    , '' ::TVarChar AS Condition 
                    , '' ::TVarChar AS JvuridicalName
                    , '' ::TVarChar AS InfoMoneyName
                    , '' ::TVarChar AS AmountRemains
                    , '' ::TVarChar AS AmountSumm
                    , '' ::TVarChar AS AmountPartner_1
                    , '' ::TVarChar AS AmountPartner_2
                    , '' ::TVarChar AS AmountPartner_3
                    , '' ::TVarChar AS AmountPartner_4
                    , '' ::TVarChar AS AmountPartner_5
                    , '' ::TVarChar AS AmountPartner
                    , '' ::TVarChar AS Amount
                    , 4 AS Ord
                    , '' AS Ord1
              FROM tmpMovement
            UNION
            SELECT  'OKPO' ::TVarChar AS OKPO
                    , 'Форма оплаты' ::TVarChar AS PaidKindName
                    , '№ дог.' ::TVarChar AS ContractName
                    , 'Договор с'  ::TVarChar AS StartDate
                    , 'Договор до' ::TVarChar AS EndDate_real
                    , 'Условия дог.' ::TVarChar AS Condition 
                    , 'Юридическое лицо' ::TVarChar AS JvuridicalName
                    , 'УП статья назначения' ::TVarChar AS InfoMoneyName
                    , 'Нач. долг (кредит)' ::TVarChar AS AmountRemains
                    , 'Приход'   ::TVarChar AS AmountSumm
                    , '7 дней'   ::TVarChar AS AmountPartner_1
                    , '14 дней'  ::TVarChar AS AmountPartner_2
                    , '21 день'  ::TVarChar AS AmountPartner_3
                    , '28 дней'  ::TVarChar AS AmountPartner_4
                    , '> 28дней' ::TVarChar AS AmountPartner_5
                    , 'Долг с отсрочкой' ::TVarChar AS AmountPartner
                    , 'Предварительно план оплаты на неделю' ::TVarChar AS Amount 
                    , 5 AS Ord
                    , '' AS Ord1
            UNION
              SELECT  tmpMI.OKPO             ::TVarChar
                    , tmpMI.PaidKindName     ::TVarChar
                    , tmpMI.ContractName     ::TVarChar
                    , zfConvert_DateToString (tmpMI.StartDate)        ::TVarChar
                    , zfConvert_DateToString (tmpMI.EndDate_real)     ::TVarChar
                    , tmpMI.Condition        ::TVarChar
                    , tmpMI.JuridicalName    ::TVarChar
                    , tmpMI.InfoMoneyName    ::TVarChar
                    , CAST (tmpMI.AmountRemains AS NUMERIC (16,2))    ::TVarChar
                    , CAST (tmpMI.AmountSumm AS NUMERIC (16,2))       ::TVarChar
                    , CAST (tmpMI.AmountPartner_1 AS NUMERIC (16,2))  ::TVarChar
                    , CAST (tmpMI.AmountPartner_2 AS NUMERIC (16,2))  ::TVarChar
                    , CAST (tmpMI.AmountPartner_3 AS NUMERIC (16,2))  ::TVarChar
                    , CAST (tmpMI.AmountPartner_4 AS NUMERIC (16,2))  ::TVarChar
                    , CAST (tmpMI.AmountPartner_5 AS NUMERIC (16,2))  ::TVarChar
                    , CAST (tmpMI.AmountPartner AS NUMERIC (16,2))    ::TVarChar
                    , CAST (tmpMI.Amount AS NUMERIC (16,2))           ::TVarChar
                    , 10 + tmpMI.Ord AS Ord
                    , tmpMI.InfoMoneyName AS Ord1
              FROM tmpMI_Data AS tmpMI
             UNION
              SELECT  '' ::TVarChar AS OKPO
                    , '' ::TVarChar AS PaidKindName
                    , '' ::TVarChar AS ContractName
                    , ''  ::TVarChar AS StartDate
                    , '' ::TVarChar AS EndDate_real
                    , '' ::TVarChar AS Condition 
                    , '' ::TVarChar AS JvuridicalName
                    , '' ::TVarChar AS InfoMoneyName
                    , '' ::TVarChar AS AmountRemains
                    , ''   ::TVarChar AS AmountSumm
                    , ''   ::TVarChar AS AmountPartner_1
                    , ''  ::TVarChar AS AmountPartner_2
                    , ''  ::TVarChar AS AmountPartner_3
                    , ''  ::TVarChar AS AmountPartner_4
                    , '' ::TVarChar AS AmountPartner_5
                    , '' ::TVarChar AS AmountPartner
                    , '' ::TVarChar AS Amount 
                    , 100 AS Ord
                    , '' AS Ord1
             UNION
              SELECT  '' ::TVarChar AS OKPO
                    , '' ::TVarChar AS PaidKindName
                    , '' ::TVarChar AS ContractName
                    , ''  ::TVarChar AS StartDate
                    , '' ::TVarChar AS EndDate_real
                    , '' ::TVarChar AS Condition 
                    , '' ::TVarChar AS JvuridicalName
                    , '' ::TVarChar AS InfoMoneyName
                    , '' ::TVarChar AS AmountRemains
                    , ''   ::TVarChar AS AmountSumm
                    , ''   ::TVarChar AS AmountPartner_1
                    , ''  ::TVarChar AS AmountPartner_2
                    , ''  ::TVarChar AS AmountPartner_3
                    , ''  ::TVarChar AS AmountPartner_4
                    , '' ::TVarChar AS AmountPartner_5
                    , 'В т.ч. по статьям' ::TVarChar AS AmountPartner
                    , '' ::TVarChar AS Amount 
                    , 101 AS Ord
                    , '' AS Ord1 
             UNION
              SELECT  ''     ::TVarChar
                    , ''     ::TVarChar
                    , ''     ::TVarChar
                    , ''     ::TVarChar
                    , ''     ::TVarChar
                    , ''     ::TVarChar
                    , ''     ::TVarChar
                    , ''     ::TVarChar
                    , ''     ::TVarChar
                    , ''     ::TVarChar
                    , ''     ::TVarChar
                    , ''     ::TVarChar
                    , ''     ::TVarChar
                    , ''     ::TVarChar
                    , ''     ::TVarChar
                    , tmpMI.InfoMoneyName  ::TVarChar
                    , CAST (SUM (COALESCE (tmpMI.Amount,0)) AS NUMERIC (16,2)) ::TVarChar
                    , 102 AS Ord
                    , ''||tmpMI.InfoMoneyName AS Ord1
              FROM tmpMI_Data AS tmpMI
              GROUP BY tmpMI.InfoMoneyName, tmpMI.NumGroup
             UNION
              SELECT  ''     ::TVarChar
                    , ''     ::TVarChar
                    , ''     ::TVarChar
                    , ''     ::TVarChar
                    , ''     ::TVarChar
                    , ''     ::TVarChar
                    , ''     ::TVarChar
                    , ''     ::TVarChar
                    , ''     ::TVarChar
                    , ''     ::TVarChar
                    , ''     ::TVarChar
                    , ''     ::TVarChar
                    , ''     ::TVarChar
                    , ''     ::TVarChar
                    , ''     ::TVarChar
                    , 'Всего: '     ::TVarChar
                    , CAST (SUM (COALESCE (tmpMI.Amount,0)) AS NUMERIC (16,2))           ::TVarChar
                    , 103 AS Ord
                    , ''
              FROM tmpMI_Data AS tmpMI
             ) AS tmp
       ORDER BY  tmp.Ord
            ;

             
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 09.11.25         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderFinance_XLS(inMovementId :=32828998  ::Integer , inSession := '9457'::TVarChar);


