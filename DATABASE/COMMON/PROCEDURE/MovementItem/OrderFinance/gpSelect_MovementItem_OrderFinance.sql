-- Function: gpSelect_MovementItem_OrderFinance()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderFinance (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderFinance(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , OKPO TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , PaidKindName TVarChar, InfoMoneyName TVarChar, NumGroup Integer
             , Condition TVarChar, ContractStateKindCode Integer
             , StartDate TDateTime, EndDate_real TDateTime, EndDate TVarChar
             , Amount TFloat, AmountRemains TFloat, AmountPartner TFloat
             , AmountSumm         TFloat
             , AmountPartner_1    TFloat
             , AmountPartner_2    TFloat
             , AmountPartner_3    TFloat
             , AmountPartner_4    TFloat
             , AmountPlan_1       TFloat
             , AmountPlan_2       TFloat
             , AmountPlan_3       TFloat
             , AmountPlan_4       TFloat
             , AmountPlan_5       TFloat
             , AmountPlan_total   TFloat
             , isAmountPlan_1     Boolean
             , isAmountPlan_2     Boolean
             , isAmountPlan_3     Boolean
             , isAmountPlan_4     Boolean
             , isAmountPlan_5     Boolean
             , Comment            TVarChar
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbOrderFinanceId Integer;
  DECLARE vbBankAccountMainId Integer;
  DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderFinance());
     vbUserId:= lpGetUserBySession (inSession);

     -- нашли
     vbOperDate := (SELECT Movement.OperDate
                    FROM Movement
                    WHERE Movement.Id = inMovementId
                    );

     -- нашли
     vbOrderFinanceId := (SELECT MovementLinkObject.ObjectId AS Id
                          FROM MovementLinkObject
                          WHERE MovementLinkObject.MovementId = inMovementId
                            AND MovementLinkObject.DescId = zc_MovementLinkObject_OrderFinance()
                         );


     -- нашли
    IF inShowAll = TRUE THEN

     -- нашли
     vbBankAccountMainId := (SELECT MovementLinkObject.ObjectId AS Id
                             FROM MovementLinkObject
                             WHERE MovementLinkObject.MovementId = inMovementId
                               AND MovementLinkObject.DescId = zc_MovementLinkObject_BankAccount()
                            );

--   select DISCTINCT zc_ObjectLink_Contract_Juridical если zc_ObjectLink_Contract_InfoMoney соответсвует соотвю списку полученному из zc_ObjectLink_OrderFinanceProperty_Object

     RETURN QUERY
     WITH

          -- если в справ. назначение платежа пусто, надо для таких договоров на показать все делать поиск последнего из банковской выписки, за последний месяц
          tmp_Comment AS (SELECT *
                          FROM (SELECT DISTINCT
                                       Object_MoneyPlace.Id               AS JuridicalId
                                     , MILinkObject_InfoMoney.ObjectId    AS InfoMoneyId
                                     , MovementItem.ObjectId              AS BankAccountId_main
                                     , MILinkObject_BankAccount.ObjectId  AS BankAccountId
                                     , MIString_Comment.ValueData         AS Comment
                                     , ROW_NUMBER() OVER (Partition by  Object_MoneyPlace.Id, MILinkObject_InfoMoney.ObjectId, MovementItem.ObjectId ORDER BY Movement.Id DESC ) AS Ord_byComment   -- комментарий последнего документа
                                FROM Movement
                                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                            AND MovementItem.DescId = zc_MI_Master()
                                                            AND COALESCE (MovementItem.Amount,0) < 0

                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                                                      ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_MoneyPlace.DescId         = zc_MILinkObject_MoneyPlace()
                                     INNER JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId
                                                                        AND Object_MoneyPlace.DescId = zc_Object_Juridical()

                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                      ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                     INNER JOIN MovementItemLinkObject AS MILinkObject_BankAccount
                                                                      ON MILinkObject_BankAccount.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_BankAccount.DescId = zc_MILinkObject_BankAccount()

                                     LEFT JOIN MovementItemString AS MIString_Comment
                                                                  ON MIString_Comment.MovementItemId = MovementItem.Id
                                                                 AND MIString_Comment.DescId = zc_MIString_Comment()

                                WHERE Movement.DescId = zc_Movement_BankAccount()
                                  AND Movement.OperDate BETWEEN vbOperDate - INTERVAL '1 MONTH' AND vbOperDate
                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                                  AND MovementItem.ObjectId = vbBankAccountMainId   --4529011   --  р/сч. ОТП банк
                                ) AS tmp
                          WHERE tmp.Ord_byComment = 1
                          )

   , tmpJuridicalOrderFinance AS (SELECT DISTINCT
                                         tmp.BankAccountId
                                       , tmp.JuridicalId
                                       , tmp.InfoMoneyId
                                       , tmp.Comment
                                  FROM gpSelect_Object_JuridicalOrderFinance_choice (inMovementId     := inMovementId
                                                                                   , inOrderFinanceId := COALESCE (vbOrderFinanceId,0)
                                                                                   , inisShowAll      := FALSE
                                                                                   , inisErased       := FALSE
                                                                                   , inSession        := inSession) AS tmp
                                 )
   , tmpData AS (SELECT DISTINCT
                        ObjectLink_Contract_Juridical.ChildObjectId AS JuridicalId
                      , ObjectLink_Contract_InfoMoney.ObjectId      AS ContractId
                      , ObjectLink_Contract_InfoMoney.ChildObjectId AS InfoMoneyId
                      --, tmpJuridicalOrderFinance.BankAccountId      AS BankAccountId
                      , COALESCE (tmpJuridicalOrderFinance.Comment, tmp_Comment.Comment) ::TVarChar AS Comment
                 FROM ObjectLink AS ObjectLink_Contract_InfoMoney
                      LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                           ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_Contract_InfoMoney.ObjectId
                                          AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()

                      INNER JOIN tmpJuridicalOrderFinance ON tmpJuridicalOrderFinance.JuridicalId = ObjectLink_Contract_Juridical.ChildObjectId
                                                         AND tmpJuridicalOrderFinance.InfoMoneyId = ObjectLink_Contract_InfoMoney.ChildObjectId

                      INNER JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                            ON ObjectLink_Contract_PaidKind.ObjectId = ObjectLink_Contract_InfoMoney.ObjectId
                                           AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
                                           AND ObjectLink_Contract_PaidKind.ChildObjectId = zc_Enum_PaidKind_FirstForm()

                      LEFT JOIN tmp_Comment ON tmp_Comment.JuridicalId = ObjectLink_Contract_Juridical.ChildObjectId
                                           AND tmp_Comment.InfoMoneyId = ObjectLink_Contract_InfoMoney.ChildObjectId
                 WHERE ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                )

   , tmpMI AS (WITH
               tmpMI AS (SELECT MovementItem.*
                         FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                              JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                               AND MovementItem.DescId     = zc_MI_Master()
                                               AND MovementItem.isErased   = tmpIsErased.isErased
                         )

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


               SELECT MovementItem.Id                   AS Id
                    , MovementItem.ObjectId             AS JuridicalId
                    , MILinkObject_Contract.ObjectId    AS ContractId
                    , MovementItem.Amount               AS Amount
                    , MIFloat_AmountRemains.ValueData   AS AmountRemains
                    , MIFloat_AmountPartner.ValueData   AS AmountPartner
                    , MIFloat_AmountSumm.ValueData      AS AmountSumm

                    , MIFloat_AmountPartner_1.ValueData AS AmountPartner_1
                    , MIFloat_AmountPartner_2.ValueData AS AmountPartner_2
                    , MIFloat_AmountPartner_3.ValueData AS AmountPartner_3
                    , MIFloat_AmountPartner_4.ValueData AS AmountPartner_4

                    , MIFloat_AmountPlan_1.ValueData    AS AmountPlan_1
                    , MIFloat_AmountPlan_2.ValueData    AS AmountPlan_2
                    , MIFloat_AmountPlan_3.ValueData    AS AmountPlan_3
                    , MIFloat_AmountPlan_4.ValueData    AS AmountPlan_4
                    , MIFloat_AmountPlan_5.ValueData    AS AmountPlan_5

                    , (COALESCE (MIFloat_AmountPlan_1.ValueData, 0)
                     + COALESCE (MIFloat_AmountPlan_2.ValueData, 0)
                     + COALESCE (MIFloat_AmountPlan_3.ValueData, 0)
                     + COALESCE (MIFloat_AmountPlan_4.ValueData, 0)
                     + COALESCE (MIFloat_AmountPlan_5.ValueData, 0)
                      ) :: TFloat AS AmountPlan_total

                    , MIBoolean_AmountPlan_1.ValueData    AS isAmountPlan_1
                    , MIBoolean_AmountPlan_2.ValueData    AS isAmountPlan_2
                    , MIBoolean_AmountPlan_3.ValueData    AS isAmountPlan_3
                    , MIBoolean_AmountPlan_4.ValueData    AS isAmountPlan_4
                    , MIBoolean_AmountPlan_5.ValueData    AS isAmountPlan_5

                    --, MILinkObject_BankAccount.ObjectId AS BankAccountId
                    , MIString_Comment.ValueData        AS Comment
                    , Object_Insert.ValueData           AS InsertName
                    , Object_Update.ValueData           AS UpdateName
                    , MIDate_Insert.ValueData           AS InsertDate
                    , MIDate_Update.ValueData           AS UpdateDate



                    , MovementItem.isErased             AS isErased

               FROM tmpMI AS MovementItem

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

                    LEFT JOIN tmpMovementItemBoolean AS MIBoolean_AmountPlan_1
                                                     ON MIBoolean_AmountPlan_1.MovementItemId = MovementItem.Id
                                                    AND MIBoolean_AmountPlan_1.DescId = zc_MIBoolean_AmountPlan_1()
                    LEFT JOIN tmpMovementItemBoolean AS MIBoolean_AmountPlan_2
                                                     ON MIBoolean_AmountPlan_2.MovementItemId = MovementItem.Id
                                                    AND MIBoolean_AmountPlan_2.DescId = zc_MIBoolean_AmountPlan_2()
                    LEFT JOIN tmpMovementItemBoolean AS MIBoolean_AmountPlan_3
                                                     ON MIBoolean_AmountPlan_3.MovementItemId = MovementItem.Id
                                                    AND MIBoolean_AmountPlan_3.DescId = zc_MIBoolean_AmountPlan_3()
                    LEFT JOIN tmpMovementItemBoolean AS MIBoolean_AmountPlan_4
                                                     ON MIBoolean_AmountPlan_4.MovementItemId = MovementItem.Id
                                                    AND MIBoolean_AmountPlan_4.DescId = zc_MIBoolean_AmountPlan_4()
                    LEFT JOIN tmpMovementItemBoolean AS MIBoolean_AmountPlan_5
                                                     ON MIBoolean_AmountPlan_5.MovementItemId = MovementItem.Id
                                                    AND MIBoolean_AmountPlan_5.DescId = zc_MIBoolean_AmountPlan_5()

                    LEFT JOIN tmpMovementItemString AS MIString_Comment
                                                    ON MIString_Comment.MovementItemId = MovementItem.Id
                                                   AND MIString_Comment.DescId = zc_MIString_Comment()

                    LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_Contract
                                                        ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()

                    LEFT JOIN tmpMovementItemDate AS MIDate_Insert
                                                  ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                 AND MIDate_Insert.DescId = zc_MIDate_Insert()
                    LEFT JOIN tmpMovementItemDate AS MIDate_Update
                                                  ON MIDate_Update.MovementItemId = MovementItem.Id
                                                 AND MIDate_Update.DescId = zc_MIDate_Update()

                    LEFT JOIN tmpMovementItemLinkObject AS MILO_Insert
                                                        ON MILO_Insert.MovementItemId = MovementItem.Id
                                                       AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                    LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId

                    LEFT JOIN tmpMovementItemLinkObject AS MILO_Update
                                                        ON MILO_Update.MovementItemId = MovementItem.Id
                                                       AND MILO_Update.DescId = zc_MILinkObject_Update()
                    LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILO_Update.ObjectId
                    )

        , tmpContractCondition AS (SELECT Object_ContractCondition_View.ContractId
                                        --, Object_ContractCondition_View.ContractConditionId
                                        --, Object_ContractCondition_View.ContractConditionKindId
                                        --, Object_ContractCondition_View.Value
                                        , ((Object_ContractCondition_View.Value::Integer)
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
                                     --AND Object_ContractCondition_View.ContractId IN (SELECT DISTINCT tmpMI.ContractId FROM tmpMI)
                                     AND vbOperDate BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                                   )

     , tmpContract_View AS (SELECT * FROM Object_Contract_View)
     , tmpJuridicalDetails_View AS (SELECT * FROM ObjectHistory_JuridicalDetails_View /*WHERE ObjectHistory_JuridicalDetails_View.JuridicalId IN (SELECT DISTINCT tmpMI.JuridicalId FROM tmpMI)*/)

     -- статьи для группировки
     , tmpOrderFinanceProperty AS (SELECT DISTINCT OrderFinanceProperty_Object.ChildObjectId AS Id
                                        , ObjectFloat_Group.ValueData                        AS NumGroup
                                        , COALESCE (ObjectBoolean_Group.ValueData,FALSE) ::Boolean AS isGroup
                                   FROM ObjectLink AS OrderFinanceProperty_OrderFinance
                                        INNER JOIN ObjectLink AS OrderFinanceProperty_Object
                                                              ON OrderFinanceProperty_Object.ObjectId = OrderFinanceProperty_OrderFinance.ObjectId
                                                             AND OrderFinanceProperty_Object.DescId = zc_ObjectLink_OrderFinanceProperty_Object()
                                                             AND COALESCE (OrderFinanceProperty_Object.ChildObjectId,0) <> 0

                                        INNER JOIN Object ON Object.Id = OrderFinanceProperty_Object.ObjectId
                                                         AND Object.isErased = FALSE

                                        LEFT JOIN ObjectFloat AS ObjectFloat_Group
                                                              ON ObjectFloat_Group.ObjectId = OrderFinanceProperty_Object.ObjectId
                                                             AND ObjectFloat_Group.DescId = zc_ObjectFloat_OrderFinanceProperty_Group()

                                        LEFT JOIN ObjectBoolean AS ObjectBoolean_Group
                                                                ON ObjectBoolean_Group.ObjectId = OrderFinanceProperty_Object.ObjectId
                                                               AND ObjectBoolean_Group.DescId = zc_ObjectBoolean_OrderFinanceProperty_Group()

                                   WHERE OrderFinanceProperty_OrderFinance.ChildObjectId = vbOrderFinanceId
                                     AND OrderFinanceProperty_OrderFinance.DescId = zc_ObjectLink_OrderFinanceProperty_OrderFinance()
                                   )

      , tmpInfoMoney_OrderF AS (SELECT DISTINCT Object_InfoMoney_View.InfoMoneyId
                                  , tmpOrderFinanceProperty.NumGroup
                                  , tmpOrderFinanceProperty.isGroup
                             FROM Object_InfoMoney_View
                                  INNER JOIN tmpOrderFinanceProperty ON (tmpOrderFinanceProperty.Id = Object_InfoMoney_View.InfoMoneyId
                                                                      OR tmpOrderFinanceProperty.Id = Object_InfoMoney_View.InfoMoneyDestinationId
                                                                      OR tmpOrderFinanceProperty.Id = Object_InfoMoney_View.InfoMoneyGroupId)
                             )


       -- Результат
       SELECT
             tmpMI.Id                         AS Id
           , Object_Juridical.Id              AS JuridicalId
           , Object_Juridical.ObjectCode      AS JuridicalCode
           , Object_Juridical.ValueData       AS JuridicalName
           , tmpJuridicalDetails_View.OKPO

           , Object_Contract.Id               AS ContractId
           , Object_Contract.ObjectCode       AS ContractCode
           , Object_Contract.ValueData        AS ContractName
           , Object_PaidKind.ValueData        AS PaidKindName
           , Object_InfoMoney.ValueData       AS InfoMoneyName
           , COALESCE (tmpInfoMoney_OrderF.NumGroup, NULL) ::Integer AS NumGroup
           , tmpContractCondition.Condition       ::TVarChar AS Condition
           , View_Contract.ContractStateKindCode  ::Integer  AS ContractStateKindCode
           --, ObjectDate_Start.ValueData       AS StartDate
           , View_Contract.StartDate
           , View_Contract.EndDate_real
           , (''|| CASE WHEN View_Contract.ContractTermKindId = zc_Enum_ContractTermKind_Long() THEN '* ' ELSE '' END
                || (LPAD (EXTRACT (Day FROM View_Contract.EndDate_term) :: TVarChar,2,'0') ||'.'||LPAD (EXTRACT (Month FROM View_Contract.EndDate_term) :: TVarChar,2,'0') ||'.'||EXTRACT (YEAR FROM View_Contract.EndDate_term) :: TVarChar)
             ) ::TVarChar AS EndDate

           , tmpMI.Amount        ::TFloat
           , tmpMI.AmountRemains ::TFloat
           , tmpMI.AmountPartner ::TFloat
           , tmpMI.AmountSumm       ::TFloat

           , tmpMI.AmountPartner_1  ::TFloat
           , tmpMI.AmountPartner_2  ::TFloat
           , tmpMI.AmountPartner_3  ::TFloat
           , tmpMI.AmountPartner_4  ::TFloat

           , tmpMI.AmountPlan_1     ::TFloat
           , tmpMI.AmountPlan_2     ::TFloat
           , tmpMI.AmountPlan_3     ::TFloat
           , tmpMI.AmountPlan_4     ::TFloat
           , tmpMI.AmountPlan_5     ::TFloat
           , tmpMI.AmountPlan_total ::TFloat

           , COALESCE (tmpMI.isAmountPlan_1, FALSE)  ::Boolean  AS isAmountPlan_1
           , COALESCE (tmpMI.isAmountPlan_2, FALSE)  ::Boolean  AS isAmountPlan_2
           , COALESCE (tmpMI.isAmountPlan_3, FALSE)  ::Boolean  AS isAmountPlan_3
           , COALESCE (tmpMI.isAmountPlan_4, FALSE)  ::Boolean  AS isAmountPlan_4
           , COALESCE (tmpMI.isAmountPlan_5, FALSE)  ::Boolean  AS isAmountPlan_5

           --, COALESCE (tmpMI.Comment, tmpData.Comment) ::TVarChar AS Comment
           , CASE WHEN COALESCE (tmpMI.Comment,'') = '' THEN COALESCE (tmpData.Comment,'') ELSE COALESCE (tmpMI.Comment,'') END ::TVarChar AS Comment

           , tmpMI.InsertName
           , tmpMI.UpdateName
           , tmpMI.InsertDate
           , tmpMI.UpdateDate

           , COALESCE (tmpMI.isErased, FALSE) AS isErased

       FROM tmpData
            FULL JOIN tmpMI ON tmpMI.JuridicalId = tmpData.JuridicalId
                           AND tmpMI.ContractId  = tmpData.ContractId

            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = COALESCE (tmpData.JuridicalId, tmpMI.JuridicalId)
            LEFT JOIN Object AS Object_Contract  ON Object_Contract.Id  = COALESCE (tmpData.ContractId, tmpMI.ContractId)

            LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                 ON ObjectLink_Contract_InfoMoney.ObjectId = Object_Contract.Id
                                AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_Contract_InfoMoney.ChildObjectId

            LEFT JOIN tmpJuridicalDetails_View ON tmpJuridicalDetails_View.JuridicalId = Object_Juridical.Id

           /* LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                 ON ObjectLink_Contract_PaidKind.ObjectId = tmpData.ContractId
                                AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ObjectLink_Contract_PaidKind.ChildObjectId

            LEFT JOIN ObjectDate AS ObjectDate_Start
                                 ON ObjectDate_Start.ObjectId = tmpData.ContractId
                                AND ObjectDate_Start.DescId = zc_ObjectDate_Contract_Start()
                                AND Object_Contract.ValueData <> '-'
           */
            LEFT JOIN tmpContract_View AS View_Contract ON View_Contract.ContractId = tmpData.ContractId
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = View_Contract.PaidKindId

            LEFT JOIN tmpContractCondition ON tmpContractCondition.ContractId = Object_Contract.Id

            LEFT JOIN tmpInfoMoney_OrderF ON tmpInfoMoney_OrderF.InfoMoneyId = Object_InfoMoney.Id
     UNION
       SELECT
             tmpMI.Id                         AS Id
           , Object_InfoMoney.Id              AS JuridicalId
           , 0                                AS JuridicalCode
           , '' ::TVarChar                    AS JuridicalName
           , '' ::TVarChar                    AS OKPO

           , 0                                AS ContractId
           , 0                                AS ContractCode
           , '' ::TVarChar                    AS ContractName
           , '' ::TVarChar                    AS PaidKindName
           , Object_InfoMoney.ValueData       AS InfoMoneyName
           , COALESCE (tmpInfoMoney_OrderF.NumGroup, NULL) ::Integer AS NumGroup
           , '' ::TVarChar                    AS Condition
           , 0  ::Integer                     AS ContractStateKindCode
           , NULL ::TDateTime                 AS StartDate
           , NULL ::TDateTime                 AS EndDate_real
           , ''   ::TVarChar                  AS EndDate

           , COALESCE (tmpMI.Amount,0) ::TFloat AS Amount
           , 0 ::TFloat       AS AmountRemains
           , 0 ::TFloat       AS AmountPartner
           , 0 ::TFloat       AS AmountSumm

           , 0 ::TFloat       AS AmountPartner_1
           , 0 ::TFloat       AS AmountPartner_2
           , 0 ::TFloat       AS AmountPartner_3
           , 0 ::TFloat       AS AmountPartner_4

           , 0 ::TFloat       AS AmountPlan_1
           , 0 ::TFloat       AS AmountPlan_2
           , 0 ::TFloat       AS AmountPlan_3
           , 0 ::TFloat       AS AmountPlan_4
           , 0 ::TFloat       AS AmountPlan_5
           , 0 ::TFloat       AS AmountPlan_total

           , FALSE ::Boolean  AS isAmountPlan_1
           , FALSE ::Boolean  AS isAmountPlan_2
           , FALSE ::Boolean  AS isAmountPlan_3
           , FALSE ::Boolean  AS isAmountPlan_4
           , FALSE ::Boolean  AS isAmountPlan_5

           , ''   ::TVarChar  AS Comment

           , tmpMI.InsertName  ::TVarChar
           , tmpMI.UpdateName  ::TVarChar
           , tmpMI.InsertDate  ::TDateTime
           , tmpMI.UpdateDate  ::TDateTime

           , COALESCE (tmpMI.isErased, FALSE) AS isErased

       FROM tmpInfoMoney_OrderF
            LEFT JOIN tmpMI ON tmpMI.JuridicalId = tmpInfoMoney_OrderF.InfoMoneyId --для итогового значения статью записываем в ObjectId
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpInfoMoney_OrderF.InfoMoneyId
       WHERE tmpInfoMoney_OrderF.isGroup = TRUE
      ;


     ELSE

     -- Результат такой
     RETURN QUERY
       WITH tmpMI AS (SELECT MovementItem.*
                           , MILinkObject_Contract.ObjectId AS ContractId
                      FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                           JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = tmpIsErased.isErased
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                            ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                     )
       -- Условия договора
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
                         WHERE Object_ContractCondition_View.ContractConditionKindId IN (zc_Enum_ContractConditionKind_DelayDayCalendar()
                                                                                       , zc_Enum_ContractConditionKind_DelayDayBank()
                                                                                        )
                           AND Object_ContractCondition_View.Value <> 0
                           -- только эти договора
                           AND Object_ContractCondition_View.ContractId IN (SELECT DISTINCT tmpMI.ContractId FROM tmpMI)
                           -- на дату
                           AND vbOperDate BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                         )
       -- Договора - только tmpMI
     , tmpContract_View AS (SELECT * FROM Object_Contract_View WHERE Object_Contract_View.ContractId IN (SELECT DISTINCT tmpMI.ContractId FROM tmpMI))
       -- Реквизиты
     , tmpJuridicalDetails_View AS (SELECT * FROM ObjectHistory_JuridicalDetails_View
                                    -- только эти юр.лица
                                    WHERE ObjectHistory_JuridicalDetails_View.JuridicalId IN (SELECT DISTINCT tmpMI.ObjectId FROM tmpMI)
                                   )

       -- св-ва
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
       -- св-ва
     , tmpMovementItemDate AS (SELECT *
                               FROM MovementItemDate
                               WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                 AND MovementItemDate.DescId IN (zc_MIDate_Insert()
                                                                , zc_MIDate_Update())
                              )
       -- св-ва
     , tmpMovementItemLinkObject AS (SELECT *
                                     FROM MovementItemLinkObject
                                     WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                     )
     , tmpMovementItemString AS (SELECT *
                                 FROM MovementItemString
                                 WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                   AND MovementItemString.DescId = zc_MIString_Comment()
                                )
       -- св-ва
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


       -- УП-Статья или Группа или ...
     , tmpOrderFinanceProperty AS (SELECT DISTINCT
                                          -- УП - Статья или Группа или ...
                                          OL_OrderFinanceProperty_Object.ChildObjectId               AS ObjectId
                                          -- № п/п группы
                                        , ObjectFloat_Group.ValueData                                AS NumGroup
                                          -- План по группе (да/нет)
                                        , COALESCE (ObjectBoolean_Group.ValueData, FALSE) :: Boolean AS isGroup

                                   FROM ObjectLink AS OL_OrderFinanceProperty_OrderFinance
                                        INNER JOIN Object ON Object.Id       = OL_OrderFinanceProperty_OrderFinance.ObjectId
                                                         -- не удален
                                                         AND Object.isErased = FALSE
                                        -- УП - Статья или Группа или ...
                                        INNER JOIN ObjectLink AS OL_OrderFinanceProperty_Object
                                                              ON OL_OrderFinanceProperty_Object.ObjectId      = OL_OrderFinanceProperty_OrderFinance.ObjectId
                                                             AND OL_OrderFinanceProperty_Object.DescId        = zc_ObjectLink_OrderFinanceProperty_Object()
                                                             AND OL_OrderFinanceProperty_Object.ChildObjectId > 0

                                        -- № п/п группы
                                        LEFT JOIN ObjectFloat AS ObjectFloat_Group
                                                              ON ObjectFloat_Group.ObjectId = OL_OrderFinanceProperty_OrderFinance.ObjectId
                                                             AND ObjectFloat_Group.DescId   = zc_ObjectFloat_OrderFinanceProperty_Group()
                                        -- План по группе (да/нет)
                                        LEFT JOIN ObjectBoolean AS ObjectBoolean_Group
                                                                ON ObjectBoolean_Group.ObjectId = OL_OrderFinanceProperty_OrderFinance.ObjectId
                                                               AND ObjectBoolean_Group.DescId   = zc_ObjectBoolean_OrderFinanceProperty_Group()

                                   WHERE OL_OrderFinanceProperty_OrderFinance.ChildObjectId = vbOrderFinanceId
                                     AND OL_OrderFinanceProperty_OrderFinance.DescId        = zc_ObjectLink_OrderFinanceProperty_OrderFinance()
                                  )

        -- разворачивается по УП-статьям + № группы
      , tmpInfoMoney_OrderF AS (SELECT DISTINCT
                                    Object_InfoMoney_View.InfoMoneyId
                                  , tmpOrderFinanceProperty.NumGroup
                                  , tmpOrderFinanceProperty.isGroup
                             FROM Object_InfoMoney_View
                                  INNER JOIN tmpOrderFinanceProperty ON (tmpOrderFinanceProperty.ObjectId = Object_InfoMoney_View.InfoMoneyId
                                                                      OR tmpOrderFinanceProperty.ObjectId = Object_InfoMoney_View.InfoMoneyDestinationId
                                                                      OR tmpOrderFinanceProperty.ObjectId = Object_InfoMoney_View.InfoMoneyGroupId
                                                                        )
                             )

       -- Результат
       SELECT
             MovementItem.Id                  AS Id
           , Object_Juridical.Id              AS JuridicalId
           , Object_Juridical.ObjectCode      AS JuridicalCode
           , Object_Juridical.ValueData       AS JuridicalName
           , tmpJuridicalDetails_View.OKPO

           , View_Contract.ContractId
           , View_Contract.ContractCode
           , View_Contract.InvNumber          AS ContractName
           , Object_PaidKind.ValueData        AS PaidKindName

           , Object_InfoMoney.ValueData       AS InfoMoneyName
           , COALESCE (tmpInfoMoney_OrderF.NumGroup, NULL) ::Integer AS NumGroup

           , tmpContractCondition.Condition       ::TVarChar AS Condition
           , View_Contract.ContractStateKindCode  ::Integer  AS ContractStateKindCode

             -- Договор с
           , View_Contract.StartDate
             -- Договор до
           , View_Contract.EndDate_real
             -- Договор до (инф.)
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

           , MIFloat_AmountPlan_1.ValueData    :: TFloat AS AmountPlan_1
           , MIFloat_AmountPlan_2.ValueData    :: TFloat AS AmountPlan_2
           , MIFloat_AmountPlan_3.ValueData    :: TFloat AS AmountPlan_3
           , MIFloat_AmountPlan_4.ValueData    :: TFloat AS AmountPlan_4
           , MIFloat_AmountPlan_5.ValueData    :: TFloat AS AmountPlan_5
           , (COALESCE (MIFloat_AmountPlan_1.ValueData, 0)
            + COALESCE (MIFloat_AmountPlan_2.ValueData, 0)
            + COALESCE (MIFloat_AmountPlan_3.ValueData, 0)
            + COALESCE (MIFloat_AmountPlan_4.ValueData, 0)
            + COALESCE (MIFloat_AmountPlan_5.ValueData, 0)
             ) :: TFloat AS AmountPlan_total

           , COALESCE (MIBoolean_AmountPlan_1.ValueData, FALSE) ::Boolean AS isAmountPlan_1
           , COALESCE (MIBoolean_AmountPlan_2.ValueData, FALSE) ::Boolean AS isAmountPlan_2
           , COALESCE (MIBoolean_AmountPlan_3.ValueData, FALSE) ::Boolean AS isAmountPlan_3
           , COALESCE (MIBoolean_AmountPlan_4.ValueData, FALSE) ::Boolean AS isAmountPlan_4
           , COALESCE (MIBoolean_AmountPlan_5.ValueData, FALSE) ::Boolean AS isAmountPlan_5

           , MIString_Comment.ValueData       AS Comment

           , Object_Insert.ValueData          AS InsertName
           , Object_Update.ValueData          AS UpdateName
           , MIDate_Insert.ValueData          AS InsertDate
           , MIDate_Update.ValueData          AS UpdateDate

           , MovementItem.isErased            AS isErased

       FROM tmpMI AS MovementItem
            INNER JOIN Object AS Object_Juridical ON Object_Juridical.Id     = MovementItem.ObjectId
                                                 -- Только Юр.л.
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

            LEFT JOIN tmpMovementItemBoolean AS MIBoolean_AmountPlan_1
                                             ON MIBoolean_AmountPlan_1.MovementItemId = MovementItem.Id
                                            AND MIBoolean_AmountPlan_1.DescId = zc_MIBoolean_AmountPlan_1()
            LEFT JOIN tmpMovementItemBoolean AS MIBoolean_AmountPlan_2
                                             ON MIBoolean_AmountPlan_2.MovementItemId = MovementItem.Id
                                            AND MIBoolean_AmountPlan_2.DescId = zc_MIBoolean_AmountPlan_2()
            LEFT JOIN tmpMovementItemBoolean AS MIBoolean_AmountPlan_3
                                             ON MIBoolean_AmountPlan_3.MovementItemId = MovementItem.Id
                                            AND MIBoolean_AmountPlan_3.DescId = zc_MIBoolean_AmountPlan_3()
            LEFT JOIN tmpMovementItemBoolean AS MIBoolean_AmountPlan_4
                                             ON MIBoolean_AmountPlan_4.MovementItemId = MovementItem.Id
                                            AND MIBoolean_AmountPlan_4.DescId = zc_MIBoolean_AmountPlan_4()
            LEFT JOIN tmpMovementItemBoolean AS MIBoolean_AmountPlan_5
                                             ON MIBoolean_AmountPlan_5.MovementItemId = MovementItem.Id
                                            AND MIBoolean_AmountPlan_5.DescId = zc_MIBoolean_AmountPlan_5()

            LEFT JOIN tmpMovementItemString AS MIString_Comment
                                            ON MIString_Comment.MovementItemId = MovementItem.Id
                                           AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN tmpMovementItemDate AS MIDate_Insert
                                          ON MIDate_Insert.MovementItemId = MovementItem.Id
                                         AND MIDate_Insert.DescId = zc_MIDate_Insert()
            LEFT JOIN tmpMovementItemDate AS MIDate_Update
                                          ON MIDate_Update.MovementItemId = MovementItem.Id
                                         AND MIDate_Update.DescId = zc_MIDate_Update()

            LEFT JOIN tmpMovementItemLinkObject AS MILO_Insert
                                                ON MILO_Insert.MovementItemId = MovementItem.Id
                                               AND MILO_Insert.DescId = zc_MILinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId

            LEFT JOIN tmpMovementItemLinkObject AS MILO_Update
                                                ON MILO_Update.MovementItemId = MovementItem.Id
                                               AND MILO_Update.DescId = zc_MILinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILO_Update.ObjectId

            -- Реквизиты
            LEFT JOIN tmpJuridicalDetails_View ON tmpJuridicalDetails_View.JuridicalId = Object_Juridical.Id

            -- Договора - только tmpMI
            LEFT JOIN tmpContract_View AS View_Contract ON View_Contract.ContractId = MovementItem.ContractId
            -- Условия договора
            LEFT JOIN tmpContractCondition ON tmpContractCondition.ContractId = MovementItem.ContractId

            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = View_Contract.InfoMoneyId
            LEFT JOIN Object AS Object_PaidKind  ON Object_PaidKind.Id  = View_Contract.PaidKindId

            -- УП-статья + № группы
            LEFT JOIN tmpInfoMoney_OrderF ON tmpInfoMoney_OrderF.InfoMoneyId = Object_InfoMoney.Id

     UNION ALL
       SELECT
             tmpMI.Id                         AS Id
           , Object_InfoMoney.Id              AS JuridicalId
           , NULL ::Integer                   AS JuridicalCode
           , '' ::TVarChar                    AS JuridicalName
           , '' ::TVarChar                    AS OKPO

           , NULL ::Integer                   AS ContractId
           , NULL ::Integer                   AS ContractCode
           , '' ::TVarChar                    AS ContractName
           , '' ::TVarChar                    AS PaidKindName
           , Object_InfoMoney.ValueData       AS InfoMoneyName
           , COALESCE (tmpInfoMoney_OrderF.NumGroup, NULL) ::Integer AS NumGroup
           , '' ::TVarChar                    AS Condition
           , NULL ::Integer                   AS ContractStateKindCode
           , NULL ::TDateTime                 AS StartDate
           , NULL ::TDateTime                 AS EndDate_real
           , ''   ::TVarChar                  AS EndDate

           , COALESCE (tmpMI.Amount,0) ::TFloat AS Amount
           , 0 ::TFloat       AS AmountRemains
           , 0 ::TFloat       AS AmountPartner
           , 0 ::TFloat       AS AmountSumm

           , 0 ::TFloat       AS AmountPartner_1
           , 0 ::TFloat       AS AmountPartner_2
           , 0 ::TFloat       AS AmountPartner_3
           , 0 ::TFloat       AS AmountPartner_4

           , 0 ::TFloat       AS AmountPlan_1
           , 0 ::TFloat       AS AmountPlan_2
           , 0 ::TFloat       AS AmountPlan_3
           , 0 ::TFloat       AS AmountPlan_4
           , 0 ::TFloat       AS AmountPlan_5
           , 0 ::TFloat       AS AmountPlan_total

           , FALSE ::Boolean  AS isAmountPlan_1
           , FALSE ::Boolean  AS isAmountPlan_2
           , FALSE ::Boolean  AS isAmountPlan_3
           , FALSE ::Boolean  AS isAmountPlan_4
           , FALSE ::Boolean  AS isAmountPlan_5

           , ''   ::TVarChar  AS Comment

           , Object_Insert.ValueData          AS InsertName
           , Object_Update.ValueData          AS UpdateName
           , MIDate_Insert.ValueData          AS InsertDate
           , MIDate_Update.ValueData          AS UpdateDate

           , COALESCE (tmpMI.isErased, FALSE) AS isErased

       FROM tmpInfoMoney_OrderF
            -- для итогов статья в ObjectId
            LEFT JOIN tmpMI ON tmpMI.ObjectId = tmpInfoMoney_OrderF.InfoMoneyId
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpInfoMoney_OrderF.InfoMoneyId

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

       WHERE tmpInfoMoney_OrderF.isGroup = TRUE
       ;
     END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.11.25         *
 18.02.21         * AmountStart
 29.07.19         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_OrderFinance (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '9818')
