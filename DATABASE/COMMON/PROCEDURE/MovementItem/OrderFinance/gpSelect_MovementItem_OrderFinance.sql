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
             , PaidKindId Integer, PaidKindName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, NumGroup Integer
             , Condition TVarChar, ContractStateKindCode Integer
             , StartDate TDateTime, EndDate_real TDateTime, EndDate TVarChar, PersonalName_contract TVarChar
               -- *** Предварительный План на неделю
             , Amount               TFloat
             , Amount_old           TFloat
               -- *** Дата предварительный план
             , OperDate_Amount      TDateTime
             , OperDate_Amount_old  TDateTime
               --
             , AmountRemains TFloat, AmountPartner TFloat
             , AmountSumm           TFloat
             , AmountPartner_1      TFloat
             , AmountPartner_2      TFloat
             , AmountPartner_3      TFloat
             , AmountPartner_4      TFloat
             , AmountPartner_5      TFloat
               -- План оплат
             , AmountPlan_1         TFloat
             , AmountPlan_2         TFloat
             , AmountPlan_3         TFloat
             , AmountPlan_4         TFloat
             , AmountPlan_5         TFloat
               -- План оплат - Итог
             , AmountPlan_total     TFloat

               -- План прошлой недели
             , AmountPlan_1_old     TFloat
             , AmountPlan_2_old     TFloat
             , AmountPlan_3_old     TFloat
             , AmountPlan_4_old     TFloat
             , AmountPlan_5_old     TFloat
               -- План прошлой недели - Итог
             , AmountPlan_total_old TFloat

               -- Факт прошлой недели
             , AmountReal_1_old     TFloat
             , AmountReal_2_old     TFloat
             , AmountReal_3_old     TFloat
             , AmountReal_4_old     TFloat
             , AmountReal_5_old     TFloat
               -- Факт прошлой недели - Итог
             , AmountReal_total_old TFloat

               -- Платим да/нет
             , isAmountPlan_1       Boolean
             , isAmountPlan_2       Boolean
             , isAmountPlan_3       Boolean
             , isAmountPlan_4       Boolean
             , isAmountPlan_5       Boolean
               -- Учитывается в долгах План прошлой недели да/нет
             , isPlan_1_old         Boolean
             , isPlan_2_old         Boolean
             , isPlan_3_old         Boolean
             , isPlan_4_old         Boolean
             , isPlan_5_old         Boolean

             , Comment              TVarChar
             , Comment_pay          TVarChar
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean
             , Color_Group Integer
              )
AS
$BODY$
  DECLARE vbUserId            Integer;
  DECLARE vbOrderFinanceId    Integer;
  DECLARE vbBankAccountMainId Integer;
  DECLARE vbMovementId_old    Integer;
  DECLARE vbWeekNumber        TFloat;
  DECLARE vbWeekNumber_old    TFloat;

  DECLARE vbOperDate          TDateTime;
  DECLARE vbStartDate         TDateTime;
  DECLARE vbEndDate           TDateTime;
  DECLARE vbStartDate_old     TDateTime;
  DECLARE vbEndDate_old       TDateTime;

  DECLARE vbIsPlan_1_old      Boolean;
  DECLARE vbIsPlan_2_old      Boolean;
  DECLARE vbIsPlan_3_old      Boolean;
  DECLARE vbIsPlan_4_old      Boolean;
  DECLARE vbIsPlan_5_old      Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderFinance());
     vbUserId:= lpGetUserBySession (inSession);

     -- нашли
     vbIsPlan_1_old:= FALSE;
     vbIsPlan_2_old:= FALSE;
     vbIsPlan_3_old:= FALSE;
     vbIsPlan_4_old:= FALSE;
     vbIsPlan_5_old:= FALSE;

     -- нашли
     vbOperDate := (SELECT Movement.OperDate
                    FROM Movement
                    WHERE Movement.Id = inMovementId
                   );
     -- нашли
     vbOrderFinanceId := (SELECT MovementLinkObject.ObjectId AS Id
                          FROM MovementLinkObject
                          WHERE MovementLinkObject.MovementId = inMovementId
                            AND MovementLinkObject.DescId     = zc_MovementLinkObject_OrderFinance()
                         );
     -- нашли
     vbWeekNumber := (SELECT MovementFloat.ValueData
                      FROM MovementFloat
                      WHERE MovementFloat.MovementId = inMovementId
                        AND MovementFloat.DescId     = zc_MovementFloat_WeekNumber()
                     );

     -- начало недели
     vbStartDate:= zfCalc_Week_StartDate (vbOperDate, vbWeekNumber);
     -- окончание недели
     vbEndDate  := zfCalc_Week_EndDate (vbOperDate, vbWeekNumber);

     -- начало предыдущей недели
     vbStartDate_old:= vbStartDate - INTERVAL '7 DAY';
     -- окончание предыдущей недели
     vbEndDate_old  := vbEndDate   - INTERVAL '7 DAY';

     -- предыдущая неделя
     vbWeekNumber_old := EXTRACT (WEEK FROM vbStartDate_old) ;


     -- проверка
     IF 1 < (SELECT COUNT(*)
             FROM (SELECT DISTINCT Movement.Id
                   FROM Movement
                        INNER JOIN MovementFloat AS MovementFloat_WeekNumber
                                                 ON MovementFloat_WeekNumber.MovementId = Movement.Id
                                                AND MovementFloat_WeekNumber.DescId     = zc_MovementFloat_WeekNumber()
                                                AND MovementFloat_WeekNumber.ValueData  = vbWeekNumber_old
                        INNER JOIN MovementLinkObject AS MovementLinkObject_OrderFinance
                                                      ON MovementLinkObject_OrderFinance.MovementId = Movement.Id
                                                     AND MovementLinkObject_OrderFinance.DescId     = zc_MovementLinkObject_OrderFinance()
                                                     AND MovementLinkObject_OrderFinance.ObjectId   = vbOrderFinanceId

                        INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                               AND MovementItem.DescId     = zc_MI_Master()
                                               AND MovementItem.isErased   = FALSE
                                               AND MovementItem.ObjectId   <> 0
                        INNER JOIN MovementItemFloat ON MovementItemFloat.MovementItemId = MovementItem.Id
                                                    AND MovementItemFloat.DescId IN (zc_MIFloat_AmountPlan_1()
                                                                                   , zc_MIFloat_AmountPlan_2()
                                                                                   , zc_MIFloat_AmountPlan_3()
                                                                                   , zc_MIFloat_AmountPlan_4()
                                                                                   , zc_MIFloat_AmountPlan_5()
                                                                                    )
                                                    AND MovementItemFloat.ValueData <> 0
                   WHERE Movement.DescId = zc_Movement_OrderFinance()
                     AND Movement.StatusId IN (zc_Enum_Status_Complete()) -- zc_Enum_Status_UnComplete()
                     AND Movement.OperDate BETWEEN vbOperDate - INTERVAL '14 DAY' AND vbOperDate - INTERVAL '1 DAY'
                  ) AS tmp
            )
     THEN
         RAISE EXCEPTION 'Ошибка.Найдено несколько документов планирования.%для <%> недели + <%>%Необходимо удалить лишний.%№ <%> от <%>%или%№ <%> от <%>'
                        , CHR (13)
                        , zfConvert_FloatToString (vbWeekNumber_old)
                        , lfGet_Object_ValueData_sh (vbOrderFinanceId)
                        , CHR (13)
                        , CHR (13)
                        , (SELECT Movement.InvNumber
                           FROM (SELECT DISTINCT Movement.*
                                 FROM Movement
                                      INNER JOIN MovementFloat AS MovementFloat_WeekNumber
                                                               ON MovementFloat_WeekNumber.MovementId = Movement.Id
                                                              AND MovementFloat_WeekNumber.DescId     = zc_MovementFloat_WeekNumber()
                                                              AND MovementFloat_WeekNumber.ValueData  = vbWeekNumber_old
                                      INNER JOIN MovementLinkObject AS MovementLinkObject_OrderFinance
                                                                    ON MovementLinkObject_OrderFinance.MovementId = Movement.Id
                                                                   AND MovementLinkObject_OrderFinance.DescId     = zc_MovementLinkObject_OrderFinance()
                                                                   AND MovementLinkObject_OrderFinance.ObjectId   = vbOrderFinanceId

                                      INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                             AND MovementItem.DescId     = zc_MI_Master()
                                                             AND MovementItem.isErased   = FALSE
                                                             AND MovementItem.ObjectId   <> 0
                                      INNER JOIN MovementItemFloat ON MovementItemFloat.MovementItemId = MovementItem.Id
                                                                  AND MovementItemFloat.DescId IN (zc_MIFloat_AmountPlan_1()
                                                                                                 , zc_MIFloat_AmountPlan_2()
                                                                                                 , zc_MIFloat_AmountPlan_3()
                                                                                                 , zc_MIFloat_AmountPlan_4()
                                                                                                 , zc_MIFloat_AmountPlan_5()
                                                                                                  )
                                                                  AND MovementItemFloat.ValueData <> 0
                                 WHERE Movement.DescId = zc_Movement_OrderFinance()
                                   AND Movement.StatusId IN (zc_Enum_Status_Complete()) -- zc_Enum_Status_UnComplete()
                                   AND Movement.OperDate BETWEEN vbOperDate - INTERVAL '14 DAY' AND vbOperDate - INTERVAL '1 DAY'
                                ) AS Movement
                           ORDER BY Movement.Id ASC
                           LIMIT 1
                          )
                        , (SELECT zfConvert_DateToString (Movement.OperDate)
                           FROM (SELECT DISTINCT Movement.*
                                 FROM Movement
                                      INNER JOIN MovementFloat AS MovementFloat_WeekNumber
                                                               ON MovementFloat_WeekNumber.MovementId = Movement.Id
                                                              AND MovementFloat_WeekNumber.DescId     = zc_MovementFloat_WeekNumber()
                                                              AND MovementFloat_WeekNumber.ValueData  = vbWeekNumber_old
                                      INNER JOIN MovementLinkObject AS MovementLinkObject_OrderFinance
                                                                    ON MovementLinkObject_OrderFinance.MovementId = Movement.Id
                                                                   AND MovementLinkObject_OrderFinance.DescId     = zc_MovementLinkObject_OrderFinance()
                                                                   AND MovementLinkObject_OrderFinance.ObjectId   = vbOrderFinanceId

                                      INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                             AND MovementItem.DescId     = zc_MI_Master()
                                                             AND MovementItem.isErased   = FALSE
                                                             AND MovementItem.ObjectId   <> 0
                                      INNER JOIN MovementItemFloat ON MovementItemFloat.MovementItemId = MovementItem.Id
                                                                  AND MovementItemFloat.DescId IN (zc_MIFloat_AmountPlan_1()
                                                                                                 , zc_MIFloat_AmountPlan_2()
                                                                                                 , zc_MIFloat_AmountPlan_3()
                                                                                                 , zc_MIFloat_AmountPlan_4()
                                                                                                 , zc_MIFloat_AmountPlan_5()
                                                                                                  )
                                                                  AND MovementItemFloat.ValueData <> 0
                                 WHERE Movement.DescId = zc_Movement_OrderFinance()
                                   AND Movement.StatusId IN (zc_Enum_Status_Complete()) -- zc_Enum_Status_UnComplete()
                                   AND Movement.OperDate BETWEEN vbOperDate - INTERVAL '14 DAY' AND vbOperDate - INTERVAL '1 DAY'
                                ) AS Movement
                           ORDER BY Movement.Id ASC
                           LIMIT 1
                          )
                        , CHR (13)
                        , CHR (13)
                        , (SELECT Movement.InvNumber
                           FROM (SELECT DISTINCT Movement.*
                                 FROM Movement
                                      INNER JOIN MovementFloat AS MovementFloat_WeekNumber
                                                               ON MovementFloat_WeekNumber.MovementId = Movement.Id
                                                              AND MovementFloat_WeekNumber.DescId     = zc_MovementFloat_WeekNumber()
                                                              AND MovementFloat_WeekNumber.ValueData  = vbWeekNumber_old
                                      INNER JOIN MovementLinkObject AS MovementLinkObject_OrderFinance
                                                                    ON MovementLinkObject_OrderFinance.MovementId = Movement.Id
                                                                   AND MovementLinkObject_OrderFinance.DescId     = zc_MovementLinkObject_OrderFinance()
                                                                   AND MovementLinkObject_OrderFinance.ObjectId   = vbOrderFinanceId

                                      INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                             AND MovementItem.DescId     = zc_MI_Master()
                                                             AND MovementItem.isErased   = FALSE
                                                             AND MovementItem.ObjectId   <> 0
                                      INNER JOIN MovementItemFloat ON MovementItemFloat.MovementItemId = MovementItem.Id
                                                                  AND MovementItemFloat.DescId IN (zc_MIFloat_AmountPlan_1()
                                                                                                 , zc_MIFloat_AmountPlan_2()
                                                                                                 , zc_MIFloat_AmountPlan_3()
                                                                                                 , zc_MIFloat_AmountPlan_4()
                                                                                                 , zc_MIFloat_AmountPlan_5()
                                                                                                  )
                                                                  AND MovementItemFloat.ValueData <> 0
                                 WHERE Movement.DescId = zc_Movement_OrderFinance()
                                   AND Movement.StatusId IN (zc_Enum_Status_Complete()) -- zc_Enum_Status_UnComplete()
                                   AND Movement.OperDate BETWEEN vbOperDate - INTERVAL '14 DAY' AND vbOperDate - INTERVAL '1 DAY'
                                ) AS Movement
                           ORDER BY Movement.Id DESC
                           LIMIT 1
                          )
                        , (SELECT zfConvert_DateToString (Movement.OperDate)
                           FROM (SELECT DISTINCT Movement.*
                                 FROM Movement
                                      INNER JOIN MovementFloat AS MovementFloat_WeekNumber
                                                               ON MovementFloat_WeekNumber.MovementId = Movement.Id
                                                              AND MovementFloat_WeekNumber.DescId     = zc_MovementFloat_WeekNumber()
                                                              AND MovementFloat_WeekNumber.ValueData  = vbWeekNumber_old
                                      INNER JOIN MovementLinkObject AS MovementLinkObject_OrderFinance
                                                                    ON MovementLinkObject_OrderFinance.MovementId = Movement.Id
                                                                   AND MovementLinkObject_OrderFinance.DescId     = zc_MovementLinkObject_OrderFinance()
                                                                   AND MovementLinkObject_OrderFinance.ObjectId   = vbOrderFinanceId

                                      INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                             AND MovementItem.DescId     = zc_MI_Master()
                                                             AND MovementItem.isErased   = FALSE
                                                             AND MovementItem.ObjectId   <> 0
                                      INNER JOIN MovementItemFloat ON MovementItemFloat.MovementItemId = MovementItem.Id
                                                                  AND MovementItemFloat.DescId IN (zc_MIFloat_AmountPlan_1()
                                                                                                 , zc_MIFloat_AmountPlan_2()
                                                                                                 , zc_MIFloat_AmountPlan_3()
                                                                                                 , zc_MIFloat_AmountPlan_4()
                                                                                                 , zc_MIFloat_AmountPlan_5()
                                                                                                  )
                                                                  AND MovementItemFloat.ValueData <> 0
                                 WHERE Movement.DescId = zc_Movement_OrderFinance()
                                   AND Movement.StatusId IN (zc_Enum_Status_Complete()) -- zc_Enum_Status_UnComplete()
                                   AND Movement.OperDate BETWEEN vbOperDate - INTERVAL '14 DAY' AND vbOperDate - INTERVAL '1 DAY'
                                ) AS Movement
                           ORDER BY Movement.Id DESC
                           LIMIT 1
                          )
                       ;
     END IF;

     -- план прошлой недели
     vbMovementId_old:= (SELECT DISTINCT Movement.Id
                         FROM Movement
                              INNER JOIN MovementFloat AS MovementFloat_WeekNumber
                                                       ON MovementFloat_WeekNumber.MovementId = Movement.Id
                                                      AND MovementFloat_WeekNumber.DescId     = zc_MovementFloat_WeekNumber()
                                                      AND MovementFloat_WeekNumber.ValueData  = vbWeekNumber_old
                              INNER JOIN MovementLinkObject AS MovementLinkObject_OrderFinance
                                                            ON MovementLinkObject_OrderFinance.MovementId = Movement.Id
                                                           AND MovementLinkObject_OrderFinance.DescId     = zc_MovementLinkObject_OrderFinance()
                                                           AND MovementLinkObject_OrderFinance.ObjectId   = vbOrderFinanceId

                              INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE
                                                     AND MovementItem.ObjectId   <> 0
                              INNER JOIN MovementItemFloat ON MovementItemFloat.MovementItemId = MovementItem.Id
                                                          AND MovementItemFloat.DescId IN (zc_MIFloat_AmountPlan_1()
                                                                                         , zc_MIFloat_AmountPlan_2()
                                                                                         , zc_MIFloat_AmountPlan_3()
                                                                                         , zc_MIFloat_AmountPlan_4()
                                                                                         , zc_MIFloat_AmountPlan_5()
                                                                                          )
                                                          AND MovementItemFloat.ValueData <> 0
                         WHERE Movement.DescId = zc_Movement_OrderFinance()
                           AND Movement.StatusId IN (zc_Enum_Status_Complete()) -- zc_Enum_Status_UnComplete()
                           AND Movement.OperDate BETWEEN vbOperDate - INTERVAL '14 DAY' AND vbOperDate - INTERVAL '1 DAY'
                        );

    IF vbUserId = 5 AND 1=0
    THEN
         RAISE EXCEPTION 'Ошибка-test.%.%.', vbMovementId_old, (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_old);
    END IF;


     -- Если неделя еще не началась
     IF CURRENT_DATE < vbStartDate
        -- или пн. до 11:00 + нет данных за пятн.
        OR (CURRENT_DATE = vbStartDate AND EXTRACT (HOUR FROM CURRENT_DATE) <= 10
            AND NOT EXISTS (SELECT 1
                            FROM Object AS Object_GlobalConst
                                 INNER JOIN ObjectDate AS ActualBankStatement
                                                       ON ActualBankStatement.DescId    = zc_ObjectDate_GlobalConst_ActualBankStatement()
                                                      AND ActualBankStatement.ObjectId  = Object_GlobalConst.Id
                                                      -- здесь пятн.
                                                      AND ActualBankStatement.ValueData >= vbStartDate  - INTERVAL '3 DAY'
                            WHERE Object_GlobalConst.DescId = zc_Object_GlobalConst()
                              AND Object_GlobalConst.Id = zc_Enum_GlobalConst_BankAccountDate()
                           )

           )
     THEN
         -- берем план птн.
         vbIsPlan_5_old:= TRUE;
     ELSE
         -- НЕ берем план птн.
         vbIsPlan_5_old:= FALSE;
     END IF;


     --
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
                                  -- убрали
                                  AND 1=0
                                ) AS tmp
                          WHERE tmp.Ord_byComment = 1
                          )

   , tmpJuridicalOrderFinance AS (SELECT DISTINCT
                                         tmp.BankAccountId
                                       , tmp.JuridicalId
                                       , tmp.InfoMoneyId
                                       , '' :: TVarChar AS Comment
                                       , tmp.Comment_pay AS Comment_pay
                                  FROM gpSelect_Object_JuridicalOrderFinance_choice (inMovementId     := inMovementId
                                                                                   , inOrderFinanceId := COALESCE (vbOrderFinanceId,0)
                                                                                   , inisShowAll      := FALSE
                                                                                   , inisErased       := FALSE
                                                                                   , inSession        := inSession
                                                                                    ) AS tmp
                                 )

   , tmpData AS (SELECT DISTINCT
                        ObjectLink_Contract_Juridical.ChildObjectId AS JuridicalId
                      , ObjectLink_Contract_InfoMoney.ObjectId      AS ContractId
                      , ObjectLink_Contract_InfoMoney.ChildObjectId AS InfoMoneyId
                      --, tmpJuridicalOrderFinance.BankAccountId      AS BankAccountId
                      , CASE WHEN COALESCE (tmpJuridicalOrderFinance.Comment_pay, '') = '' THEN COALESCE (tmp_Comment.Comment,'') ELSE COALESCE (tmpJuridicalOrderFinance.Comment_pay, '') END ::TVarChar AS Comment_pay
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
                                                                       , zc_MIDate_Update()
                                                                       , zc_MIDate_Amount()
                                                                        )
                                        )
             , tmpMovementItemLinkObject AS (SELECT *
                                             FROM MovementItemLinkObject
                                             WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                             )
             , tmpMovementItemString AS (SELECT *
                                         FROM MovementItemString
                                         WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                           AND MovementItemString.DescId IN (zc_MIString_Comment()
                                                                           , zc_MIString_Comment_pay()
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

               -- Результат - tmpMI
               SELECT MovementItem.Id                   AS Id
                    , MovementItem.ObjectId             AS JuridicalId
                    , MILinkObject_Contract.ObjectId    AS ContractId
                      -- Предварительный План на неделю
                    , MovementItem.Amount               AS Amount
                      -- Дата предварительный план
                    , MIDate_Amount.ValueData           AS OperDate_Amount
                    , MIDate_Amount.ValueData           AS OperDate_Amount_old
                      --
                    , MIFloat_AmountRemains.ValueData   AS AmountRemains
                    , MIFloat_AmountPartner.ValueData   AS AmountPartner
                    , MIFloat_AmountSumm.ValueData      AS AmountSumm

                    , MIFloat_AmountPartner_1.ValueData AS AmountPartner_1
                    , MIFloat_AmountPartner_2.ValueData AS AmountPartner_2
                    , MIFloat_AmountPartner_3.ValueData AS AmountPartner_3
                    , MIFloat_AmountPartner_4.ValueData AS AmountPartner_4
                    , (COALESCE (MIFloat_AmountPartner.ValueData,0)
                       - COALESCE (MIFloat_AmountPartner_1.ValueData,0)
                       - COALESCE (MIFloat_AmountPartner_2.ValueData,0)
                       - COALESCE (MIFloat_AmountPartner_3.ValueData,0)
                       - COALESCE (MIFloat_AmountPartner_4.ValueData,0)
                      )   :: TFloat AS AmountPartner_5                -->28дней

                      -- План оплат
                    , MIFloat_AmountPlan_1.ValueData    AS AmountPlan_1
                    , MIFloat_AmountPlan_2.ValueData    AS AmountPlan_2
                    , MIFloat_AmountPlan_3.ValueData    AS AmountPlan_3
                    , MIFloat_AmountPlan_4.ValueData    AS AmountPlan_4
                    , MIFloat_AmountPlan_5.ValueData    AS AmountPlan_5

                      -- План оплат - Итог
                    , (COALESCE (MIFloat_AmountPlan_1.ValueData, 0)
                     + COALESCE (MIFloat_AmountPlan_2.ValueData, 0)
                     + COALESCE (MIFloat_AmountPlan_3.ValueData, 0)
                     + COALESCE (MIFloat_AmountPlan_4.ValueData, 0)
                     + COALESCE (MIFloat_AmountPlan_5.ValueData, 0)
                      ) :: TFloat AS AmountPlan_total

                    , COALESCE (MIBoolean_AmountPlan_1.ValueData, TRUE) :: Boolean    AS isAmountPlan_1
                    , COALESCE (MIBoolean_AmountPlan_2.ValueData, TRUE) :: Boolean    AS isAmountPlan_2
                    , COALESCE (MIBoolean_AmountPlan_3.ValueData, TRUE) :: Boolean    AS isAmountPlan_3
                    , COALESCE (MIBoolean_AmountPlan_4.ValueData, TRUE) :: Boolean    AS isAmountPlan_4
                    , COALESCE (MIBoolean_AmountPlan_5.ValueData, TRUE) :: Boolean    AS isAmountPlan_5

                    --, MILinkObject_BankAccount.ObjectId AS BankAccountId
                    , MIString_Comment.ValueData        AS Comment
                    , MIString_Comment_pay.ValueData    AS Comment_pay
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
                    LEFT JOIN tmpMovementItemString AS MIString_Comment_pay
                                                    ON MIString_Comment_pay.MovementItemId = MovementItem.Id
                                                   AND MIString_Comment_pay.DescId = zc_MIString_Comment_pay()

                    LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_Contract
                                                        ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()

                    LEFT JOIN tmpMovementItemDate AS MIDate_Insert
                                                  ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                 AND MIDate_Insert.DescId = zc_MIDate_Insert()
                    LEFT JOIN tmpMovementItemDate AS MIDate_Update
                                                  ON MIDate_Update.MovementItemId = MovementItem.Id
                                                 AND MIDate_Update.DescId = zc_MIDate_Update()
                    -- Дата предварительный план
                    LEFT JOIN tmpMovementItemDate AS MIDate_Amount
                                                  ON MIDate_Amount.MovementItemId = MovementItem.Id
                                                 AND MIDate_Amount.DescId = zc_MIDate_Amount()

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
             tmpMI.Id                         AS Id
           , Object_Juridical.Id              AS JuridicalId
           , Object_Juridical.ObjectCode      AS JuridicalCode
           , Object_Juridical.ValueData       AS JuridicalName
           , tmpJuridicalDetails_View.OKPO

           , Object_Contract.Id               AS ContractId
           , Object_Contract.ObjectCode       AS ContractCode
           , Object_Contract.ValueData        AS ContractName
           , Object_PaidKind.Id               AS PaidKindId
           , Object_PaidKind.ValueData        AS PaidKindName
           , Object_InfoMoney.ObjectCode      AS InfoMoneyCode
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
           , Object_Personal.ValueData ::TVarChar AS PersonalName_contract
             -- Предварительный План на неделю
           , tmpMI.Amount              ::TFloat AS Amount
           , tmpMI.Amount              ::TFloat AS Amount_old
             -- Дата предварительный план
           , tmpMI.OperDate_Amount     :: TDateTime
           , tmpMI.OperDate_Amount_old :: TDateTime
             --
           , tmpMI.AmountRemains       ::TFloat
           , tmpMI.AmountPartner       ::TFloat
           , tmpMI.AmountSumm          ::TFloat

           , tmpMI.AmountPartner_1     ::TFloat
           , tmpMI.AmountPartner_2     ::TFloat
           , tmpMI.AmountPartner_3     ::TFloat
           , tmpMI.AmountPartner_4     ::TFloat
           , tmpMI.AmountPartner_5     ::TFloat

             -- План оплат
           , tmpMI.AmountPlan_1        ::TFloat
           , tmpMI.AmountPlan_2        ::TFloat
           , tmpMI.AmountPlan_3        ::TFloat
           , tmpMI.AmountPlan_4        ::TFloat
           , tmpMI.AmountPlan_5        ::TFloat
             -- План оплат - Итог
           , tmpMI.AmountPlan_total    ::TFloat

             -- План прошлой недели
           , MIFloat_AmountPlan_1_old.ValueData    AS AmountPlan_1_old
           , MIFloat_AmountPlan_2_old.ValueData    AS AmountPlan_2_old
           , MIFloat_AmountPlan_3_old.ValueData    AS AmountPlan_3_old
           , MIFloat_AmountPlan_4_old.ValueData    AS AmountPlan_4_old
           , MIFloat_AmountPlan_5_old.ValueData    AS AmountPlan_5_old

             -- План прошлой недели - Итог
           , (COALESCE (MIFloat_AmountPlan_1_old.ValueData, 0)
            + COALESCE (MIFloat_AmountPlan_2_old.ValueData, 0)
            + COALESCE (MIFloat_AmountPlan_3_old.ValueData, 0)
            + COALESCE (MIFloat_AmountPlan_4_old.ValueData, 0)
            + COALESCE (MIFloat_AmountPlan_5_old.ValueData, 0)
             ) :: TFloat AS AmountPlan_total_old

             -- Факт прошлой недели
           , 0 :: TFloat AS AmountReal_1_old
           , 0 :: TFloat AS AmountReal_2_old
           , 0 :: TFloat AS AmountReal_3_old
           , 0 :: TFloat AS AmountReal_4_old
           , 0 :: TFloat AS AmountReal_5_old
             -- Факт прошлой недели - Итог
           , 0 :: TFloat AS AmountReal_total_old

             -- Платим да/нет
           , COALESCE (tmpMI.isAmountPlan_1, TRUE)  ::Boolean  AS isAmountPlan_1
           , COALESCE (tmpMI.isAmountPlan_2, TRUE)  ::Boolean  AS isAmountPlan_2
           , COALESCE (tmpMI.isAmountPlan_3, TRUE)  ::Boolean  AS isAmountPlan_3
           , COALESCE (tmpMI.isAmountPlan_4, TRUE)  ::Boolean  AS isAmountPlan_4
           , COALESCE (tmpMI.isAmountPlan_5, TRUE)  ::Boolean  AS isAmountPlan_5

             -- Учитывается в долгах План прошлой недели да/нет
           , vbIsPlan_1_old AS isPlan_1_old
           , vbIsPlan_2_old AS isPlan_2_old
           , vbIsPlan_3_old AS isPlan_3_old
           , vbIsPlan_4_old AS isPlan_4_old
           , vbIsPlan_5_old AS isPlan_5_old

           , COALESCE (tmpMI.Comment, '') ::TVarChar AS Comment
           , CASE WHEN COALESCE (tmpMI.Comment_pay,'') = '' THEN COALESCE (tmpData.Comment_pay,'') ELSE COALESCE (tmpMI.Comment_pay,'') END ::TVarChar AS Comment_pay
           --, COALESCE (tmpMI.Comment_pay,'') ::TVarChar AS Comment_pay

           , tmpMI.InsertName
           , tmpMI.UpdateName
           , tmpMI.InsertDate
           , tmpMI.UpdateDate

           , COALESCE (tmpMI.isErased, FALSE) AS isErased

           , zc_Color_White() ::Integer AS Color_Group

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

            -- план прошлой недели
            LEFT JOIN tmpMI_old ON tmpMI_old.JuridicalId = COALESCE (tmpData.JuridicalId, tmpMI.JuridicalId)
                               AND tmpMI_old.ContractId  = COALESCE (tmpData.ContractId, tmpMI.ContractId)
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

            LEFT JOIN ObjectLink AS ObjectLink_Contract_Personal
                                 ON ObjectLink_Contract_Personal.ObjectId = View_Contract.ContractId
                                AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Contract_Personal.ChildObjectId
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
           , 0                                AS PaidKindId
           , '' ::TVarChar                    AS PaidKindName
           , 0                                AS InfoMoneyCode
           , Object_InfoMoney.ValueData       AS InfoMoneyName
           , COALESCE (tmpInfoMoney_OrderF.NumGroup, NULL) ::Integer AS NumGroup
           , '' ::TVarChar                    AS Condition
           , 0  ::Integer                     AS ContractStateKindCode
           , NULL ::TDateTime                 AS StartDate
           , NULL ::TDateTime                 AS EndDate_real
           , ''   ::TVarChar                  AS EndDate
           , ''   ::TVarChar                  AS PersonalName_contract

             -- Предварительный План на неделю
           , COALESCE (tmpMI.Amount, 0)::TFloat AS Amount
           , COALESCE (tmpMI.Amount, 0)::TFloat AS Amount_old
             -- Дата предварительный план
           , tmpMI.OperDate_Amount     :: TDateTime
           , tmpMI.OperDate_Amount_old :: TDateTime
             --
           , 0 ::TFloat       AS AmountRemains
           , 0 ::TFloat       AS AmountPartner
           , 0 ::TFloat       AS AmountSumm

           , 0 ::TFloat       AS AmountPartner_1
           , 0 ::TFloat       AS AmountPartner_2
           , 0 ::TFloat       AS AmountPartner_3
           , 0 ::TFloat       AS AmountPartner_4
           , 0 ::TFloat       AS AmountPartner_5

             -- План оплат
           , 0 ::TFloat       AS AmountPlan_1
           , 0 ::TFloat       AS AmountPlan_2
           , 0 ::TFloat       AS AmountPlan_3
           , 0 ::TFloat       AS AmountPlan_4
           , 0 ::TFloat       AS AmountPlan_5
             -- План оплат - Итог
           , 0 ::TFloat       AS AmountPlan_total

             -- План прошлой недели
           , 0 :: TFloat AS AmountReal_1_old
           , 0 :: TFloat AS AmountReal_2_old
           , 0 :: TFloat AS AmountReal_3_old
           , 0 :: TFloat AS AmountReal_4_old
           , 0 :: TFloat AS AmountReal_5_old
             -- План прошлой недели - Итог
           , 0 :: TFloat AS AmountReal_total_old

             -- Факт прошлой недели
           , 0 :: TFloat AS AmountReal_1_old
           , 0 :: TFloat AS AmountReal_2_old
           , 0 :: TFloat AS AmountReal_3_old
           , 0 :: TFloat AS AmountReal_4_old
           , 0 :: TFloat AS AmountReal_5_old
             -- Факт прошлой недели - Итог
           , 0 :: TFloat AS AmountReal_total_old

           , FALSE ::Boolean  AS isAmountPlan_1
           , FALSE ::Boolean  AS isAmountPlan_2
           , FALSE ::Boolean  AS isAmountPlan_3
           , FALSE ::Boolean  AS isAmountPlan_4
           , FALSE ::Boolean  AS isAmountPlan_5

             -- Учитывается в долгах План прошлой недели да/нет
           , vbIsPlan_1_old AS isPlan_1_old
           , vbIsPlan_2_old AS isPlan_2_old
           , vbIsPlan_3_old AS isPlan_3_old
           , vbIsPlan_4_old AS isPlan_4_old
           , vbIsPlan_5_old AS isPlan_5_old

           , ''   ::TVarChar  AS Comment
           , ''   ::TVarChar  AS Comment_pay

           , tmpMI.InsertName  ::TVarChar
           , tmpMI.UpdateName  ::TVarChar
           , tmpMI.InsertDate  ::TDateTime
           , tmpMI.UpdateDate  ::TDateTime

           , COALESCE (tmpMI.isErased, FALSE) AS isErased

           , zc_Color_Yelow() ::Integer AS Color_Group

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
                                                               , zc_MIDate_Update()
                                                               , zc_MIDate_Amount()
                                                                 )
                              )
       -- св-ва
     , tmpMovementItemLinkObject AS (SELECT *
                                     FROM MovementItemLinkObject
                                     WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                     )
     , tmpMovementItemString AS (SELECT *
                                 FROM MovementItemString
                                 WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                   AND MovementItemString.DescId IN (zc_MIString_Comment()
                                                                   , zc_MIString_Comment_pay()
                                                                   )
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
   -- Банк предыдущей недели
 , tmpMI_bank_old AS (SELECT MILinkObject_MoneyPlace.ObjectId AS JuridicalId
                           , MILinkObject_Contract.ObjectId   AS ContractId
                           , SUM (CASE WHEN Movement.OperDate =  vbStartDate_old                     THEN -1 * MovementItem.Amount ELSE 0 END) AS Amount_1
                           , SUM (CASE WHEN Movement.OperDate =  vbStartDate_old + INTERVAL '1 DAY ' THEN -1 * MovementItem.Amount ELSE 0 END) AS Amount_2
                           , SUM (CASE WHEN Movement.OperDate =  vbStartDate_old + INTERVAL '2 DAY ' THEN -1 * MovementItem.Amount ELSE 0 END) AS Amount_3
                           , SUM (CASE WHEN Movement.OperDate =  vbStartDate_old + INTERVAL '3 DAY ' THEN -1 * MovementItem.Amount ELSE 0 END) AS Amount_4
                           , SUM (CASE WHEN Movement.OperDate >= vbStartDate_old + INTERVAL '4 DAY ' THEN -1 * MovementItem.Amount ELSE 0 END) AS Amount_5
                      FROM Movement
                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId     = zc_MI_Master()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                            ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Contract.DescId         = zc_MILinkObject_Contract()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                                            ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_MoneyPlace.DescId         = zc_MILinkObject_MoneyPlace()
                           INNER JOIN (SELECT DISTINCT tmpMI.ObjectId AS JuridicalId, tmpMI.ContractId FROM tmpMI
                                      ) AS tmpList
                                        ON tmpList.JuridicalId = MILinkObject_MoneyPlace.ObjectId
                                       AND tmpList.ContractId  = MILinkObject_Contract.ObjectId

                      WHERE Movement.OperDate BETWEEN vbStartDate_old AND vbEndDate_old
                        AND Movement.DescId   = zc_Movement_BankAccount()
                        AND Movement.StatusId = zc_Enum_Status_Complete()
                      GROUP BY MILinkObject_MoneyPlace.ObjectId
                             , MILinkObject_Contract.ObjectId
                     )
       -- Банк текущей недели
     , tmpMI_bank AS (SELECT MILinkObject_MoneyPlace.ObjectId AS JuridicalId
                           , MILinkObject_Contract.ObjectId   AS ContractId
                           , SUM (CASE WHEN Movement.OperDate =  vbStartDate                     THEN -1 * MovementItem.Amount ELSE 0 END) AS Amount_1
                           , SUM (CASE WHEN Movement.OperDate =  vbStartDate + INTERVAL '1 DAY ' THEN -1 * MovementItem.Amount ELSE 0 END) AS Amount_2
                           , SUM (CASE WHEN Movement.OperDate =  vbStartDate + INTERVAL '2 DAY ' THEN -1 * MovementItem.Amount ELSE 0 END) AS Amount_3
                           , SUM (CASE WHEN Movement.OperDate =  vbStartDate + INTERVAL '3 DAY ' THEN -1 * MovementItem.Amount ELSE 0 END) AS Amount_4
                           , SUM (CASE WHEN Movement.OperDate >= vbStartDate + INTERVAL '4 DAY ' THEN -1 * MovementItem.Amount ELSE 0 END) AS Amount_5
                      FROM Movement
                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId     = zc_MI_Master()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                            ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Contract.DescId         = zc_MILinkObject_Contract()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                                            ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_MoneyPlace.DescId         = zc_MILinkObject_MoneyPlace()
                           INNER JOIN (SELECT DISTINCT tmpMI.ObjectId AS JuridicalId, tmpMI.ContractId FROM tmpMI
                                      ) AS tmpList
                                        ON tmpList.JuridicalId = MILinkObject_MoneyPlace.ObjectId
                                       AND tmpList.ContractId  = MILinkObject_Contract.ObjectId

                      WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                        AND Movement.DescId   = zc_Movement_BankAccount()
                        AND Movement.StatusId = zc_Enum_Status_Complete()
                      GROUP BY MILinkObject_MoneyPlace.ObjectId
                             , MILinkObject_Contract.ObjectId
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
           , Object_PaidKind.Id               AS PaidKindId
           , Object_PaidKind.ValueData        AS PaidKindName

           , Object_InfoMoney.ObjectCode      AS InfoMoneyCode
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
           , Object_Personal.ValueData ::TVarChar AS PersonalName_contract


             -- Предварительный План на неделю
           , MovementItem.Amount               :: TFloat AS Amount
           , MovementItem.Amount               :: TFloat AS Amount_old
             -- Дата предварительный план
           , MIDate_Amount.ValueData           AS OperDate_Amount
           , MIDate_Amount.ValueData           AS OperDate_Amount_old

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
             -- План оплат - Итог
           , (COALESCE (MIFloat_AmountPlan_1.ValueData, 0)
            + COALESCE (MIFloat_AmountPlan_2.ValueData, 0)
            + COALESCE (MIFloat_AmountPlan_3.ValueData, 0)
            + COALESCE (MIFloat_AmountPlan_4.ValueData, 0)
            + COALESCE (MIFloat_AmountPlan_5.ValueData, 0)
             ) :: TFloat AS AmountPlan_total

             -- План прошлой недели
           , MIFloat_AmountPlan_1_old.ValueData    AS AmountPlan_1_old
           , MIFloat_AmountPlan_2_old.ValueData    AS AmountPlan_2_old
           , MIFloat_AmountPlan_3_old.ValueData    AS AmountPlan_3_old
           , MIFloat_AmountPlan_4_old.ValueData    AS AmountPlan_4_old
           , MIFloat_AmountPlan_5_old.ValueData    AS AmountPlan_5_old

             -- План прошлой недели - Итог
           , (COALESCE (MIFloat_AmountPlan_1_old.ValueData, 0)
            + COALESCE (MIFloat_AmountPlan_2_old.ValueData, 0)
            + COALESCE (MIFloat_AmountPlan_3_old.ValueData, 0)
            + COALESCE (MIFloat_AmountPlan_4_old.ValueData, 0)
            + COALESCE (MIFloat_AmountPlan_5_old.ValueData, 0)
             ) :: TFloat AS AmountPlan_total_old

             -- Факт прошлой недели
           , tmpMI_bank_old.Amount_1 :: TFloat AS AmountReal_1_old
           , tmpMI_bank_old.Amount_2 :: TFloat AS AmountReal_2_old
           , tmpMI_bank_old.Amount_3 :: TFloat AS AmountReal_3_old
           , tmpMI_bank_old.Amount_4 :: TFloat AS AmountReal_4_old
           , tmpMI_bank_old.Amount_5 :: TFloat AS AmountReal_5_old
             -- Факт прошлой недели - Итог
           , 0 :: TFloat AS AmountReal_total_old

             -- Платим да/нет
           , COALESCE (MIBoolean_AmountPlan_1.ValueData, TRUE) ::Boolean AS isAmountPlan_1
           , COALESCE (MIBoolean_AmountPlan_2.ValueData, TRUE) ::Boolean AS isAmountPlan_2
           , COALESCE (MIBoolean_AmountPlan_3.ValueData, TRUE) ::Boolean AS isAmountPlan_3
           , COALESCE (MIBoolean_AmountPlan_4.ValueData, TRUE) ::Boolean AS isAmountPlan_4
           , COALESCE (MIBoolean_AmountPlan_5.ValueData, TRUE) ::Boolean AS isAmountPlan_5

             -- Учитывается в долгах План прошлой недели да/нет
           , vbIsPlan_1_old AS isPlan_1_old
           , vbIsPlan_2_old AS isPlan_2_old
           , vbIsPlan_3_old AS isPlan_3_old
           , vbIsPlan_4_old AS isPlan_4_old
           , vbIsPlan_5_old AS isPlan_5_old

           , MIString_Comment.ValueData     ::TVarChar AS Comment
           , MIString_Comment_pay.ValueData ::TVarChar AS Comment_pay

           , Object_Insert.ValueData          AS InsertName
           , Object_Update.ValueData          AS UpdateName
           , MIDate_Insert.ValueData          AS InsertDate
           , MIDate_Update.ValueData          AS UpdateDate

           , MovementItem.isErased            AS isErased

           , zc_Color_White() ::Integer AS Color_Group

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

            -- Банк предыдущей недели
            LEFT JOIN tmpMI_bank_old ON tmpMI_bank_old.JuridicalId = MovementItem.ObjectId
                                    AND tmpMI_bank_old.ContractId  = MovementItem.ContractId
                                  --AND 1=0

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
            LEFT JOIN tmpMovementItemString AS MIString_Comment_pay
                                            ON MIString_Comment_pay.MovementItemId = MovementItem.Id
                                           AND MIString_Comment_pay.DescId = zc_MIString_Comment_pay()

            LEFT JOIN tmpMovementItemDate AS MIDate_Insert
                                          ON MIDate_Insert.MovementItemId = MovementItem.Id
                                         AND MIDate_Insert.DescId = zc_MIDate_Insert()
            LEFT JOIN tmpMovementItemDate AS MIDate_Update
                                          ON MIDate_Update.MovementItemId = MovementItem.Id
                                         AND MIDate_Update.DescId = zc_MIDate_Update()
            -- Дата предварительный план
            LEFT JOIN tmpMovementItemDate AS MIDate_Amount
                                          ON MIDate_Amount.MovementItemId = MovementItem.Id
                                         AND MIDate_Amount.DescId = zc_MIDate_Amount()

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

            LEFT JOIN ObjectLink AS ObjectLink_Contract_Personal
                                 ON ObjectLink_Contract_Personal.ObjectId = View_Contract.ContractId
                                AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Contract_Personal.ChildObjectId

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
           , 0                                AS PaidKindId
           , '' ::TVarChar                    AS PaidKindName
           , 0                                AS InfoMoneyCode
           , Object_InfoMoney.ValueData       AS InfoMoneyName
           , COALESCE (tmpInfoMoney_OrderF.NumGroup, NULL) ::Integer AS NumGroup
           , '' ::TVarChar                    AS Condition
           , NULL ::Integer                   AS ContractStateKindCode
           , NULL ::TDateTime                 AS StartDate
           , NULL ::TDateTime                 AS EndDate_real
           , ''   ::TVarChar                  AS EndDate
           , ''   ::TVarChar                  AS PersonalName_contract

             -- Предварительный План на неделю
           , COALESCE (tmpMI.Amount, 0)::TFloat AS Amount
           , COALESCE (tmpMI.Amount, 0)::TFloat AS Amount_old
             -- Дата предварительный план
           , MIDate_Amount.ValueData            AS OperDate_Amount
           , MIDate_Amount.ValueData            AS OperDate_Amount_old
             --
           , 0 ::TFloat       AS AmountRemains
           , 0 ::TFloat       AS AmountPartner
           , 0 ::TFloat       AS AmountSumm

           , 0 ::TFloat       AS AmountPartner_1
           , 0 ::TFloat       AS AmountPartner_2
           , 0 ::TFloat       AS AmountPartner_3
           , 0 ::TFloat       AS AmountPartner_4
           , 0 ::TFloat       AS AmountPartner_5
             -- План оплат
           , 0 ::TFloat       AS AmountPlan_1
           , 0 ::TFloat       AS AmountPlan_2
           , 0 ::TFloat       AS AmountPlan_3
           , 0 ::TFloat       AS AmountPlan_4
           , 0 ::TFloat       AS AmountPlan_5
             -- План оплат - Итог
           , 0 ::TFloat       AS AmountPlan_total

             -- План прошлой недели
           , 0 :: TFloat AS AmountReal_1_old
           , 0 :: TFloat AS AmountReal_2_old
           , 0 :: TFloat AS AmountReal_3_old
           , 0 :: TFloat AS AmountReal_4_old
           , 0 :: TFloat AS AmountReal_5_old
             -- План прошлой недели - Итог
           , 0 :: TFloat AS AmountReal_total_old

             -- Факт прошлой недели
           , 0 :: TFloat AS AmountReal_1_old
           , 0 :: TFloat AS AmountReal_2_old
           , 0 :: TFloat AS AmountReal_3_old
           , 0 :: TFloat AS AmountReal_4_old
           , 0 :: TFloat AS AmountReal_5_old
             -- Факт прошлой недели - Итог
           , 0 :: TFloat AS AmountReal_total_old

             -- Платим да/нет
           , FALSE ::Boolean  AS isAmountPlan_1
           , FALSE ::Boolean  AS isAmountPlan_2
           , FALSE ::Boolean  AS isAmountPlan_3
           , FALSE ::Boolean  AS isAmountPlan_4
           , FALSE ::Boolean  AS isAmountPlan_5

             -- Учитывается в долгах План прошлой недели да/нет
           , vbIsPlan_1_old AS isPlan_1_old
           , vbIsPlan_2_old AS isPlan_2_old
           , vbIsPlan_3_old AS isPlan_3_old
           , vbIsPlan_4_old AS isPlan_4_old
           , vbIsPlan_5_old AS isPlan_5_old

           , ''   ::TVarChar  AS Comment
           , ''   ::TVarChar  AS Comment_pay

           , Object_Insert.ValueData          AS InsertName
           , Object_Update.ValueData          AS UpdateName
           , MIDate_Insert.ValueData          AS InsertDate
           , MIDate_Update.ValueData          AS UpdateDate

           , COALESCE (tmpMI.isErased, FALSE) AS isErased

           , zc_Color_Yelow() ::Integer AS Color_Group
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
            -- Дата предварительный план
            LEFT JOIN tmpMovementItemDate AS MIDate_Amount
                                          ON MIDate_Amount.MovementItemId = tmpMI.Id
                                         AND MIDate_Amount.DescId = zc_MIDate_Amount()

            LEFT JOIN tmpMovementItemLinkObject AS MILO_Insert
                                                ON MILO_Insert.MovementItemId = tmpMI.Id
                                               AND MILO_Insert.DescId = zc_MILinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId

            LEFT JOIN tmpMovementItemLinkObject AS MILO_Update
                                                ON MILO_Update.MovementItemId = tmpMI.Id
                                               AND MILO_Update.DescId = zc_MILinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILO_Update.ObjectId

       WHERE tmpInfoMoney_OrderF.isGroup = TRUE
          OR (Object_InfoMoney.DescId = zc_Object_InfoMoney() AND tmpMI.Id IS NOT NULL)   --сохраненные строки итого , даже если с н х сняли признак группы
       ;
     END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.12.25         *
 17.11.25         *
 18.02.21         * AmountStart
 29.07.19         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_OrderFinance (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_OrderFinance (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '9818')
