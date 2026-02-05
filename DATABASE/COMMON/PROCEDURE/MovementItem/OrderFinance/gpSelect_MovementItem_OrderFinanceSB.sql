-- Function: gpSelect_MovementItem_OrderFinanceSB()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderFinanceSB (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderFinanceSB(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , OKPO TVarChar
             , ObjectDesc_ItemName TVarChar, JuridicalName_inf TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, NumGroup Integer
             , Condition TVarChar, ContractStateKindCode Integer
             , StartDate TDateTime, EndDate_real TDateTime, EndDate TVarChar, PersonalName_contract TVarChar
               -- Касса (место выдачи)
             , CashId Integer, CashName TVarChar
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
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean
             , ColorFon_record Integer

             , GoodsName_Child TVarChar
             , InvNumber_Child TVarChar
             , InvNumber_Invoice_Child TVarChar
             , Sign_Child      Boolean
             , Amount_Child    TFloat
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

     tmpJuridicalOrderFinance AS (SELECT DISTINCT
                                         tmp.BankAccountId
                                       , tmp.JuridicalId
                                       , tmp.InfoMoneyId
                                       , '' :: TVarChar AS Comment
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
                    , MILinkObject_Cash.ObjectId        AS CashId
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

                    LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_Cash
                                                        ON MILinkObject_Cash.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_Cash.DescId = zc_MILinkObject_Cash()

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

      -- Child - Данные с № заявки 1С
    , tmpMI_Child AS (SELECT tmpMI.ParentId
                           , STRING_AGG (tmpMI.GoodsName, '; ') AS GoodsName
                           , STRING_AGG (tmpMI.InvNumber, '; ') AS InvNumber
                           , STRING_AGG (tmpMI.InvNumber_Invoice, '; ') AS InvNumber_Invoice
                           , MAX (tmpMI.isSign)                 AS isSign
                           , SUM (tmpMI.Amount)                 AS Amount
                      FROM (SELECT MovementItem.Id
                                 , MovementItem.ParentId
                                 , MIString_GoodsName.ValueData                  AS GoodsName
                                 , MIString_InvNumber.ValueData                  AS InvNumber
                                 , MIString_InvNumber_Invoice.ValueData          AS InvNumber_Invoice
                                 , CASE WHEN MIBoolean_Sign.ValueData = TRUE THEN 0 ELSE 1 END  AS isSign
                                 , MovementItem.Amount                                          AS Amount
                            FROM MovementItem
                                LEFT JOIN MovementItemString AS MIString_GoodsName
                                                             ON MIString_GoodsName.MovementItemId = MovementItem.Id
                                                            AND MIString_GoodsName.DescId = zc_MIString_GoodsName()
                                LEFT JOIN MovementItemString AS MIString_InvNumber
                                                             ON MIString_InvNumber.MovementItemId = MovementItem.Id
                                                            AND MIString_InvNumber.DescId = zc_MIString_InvNumber()
                                LEFT JOIN MovementItemString AS MIString_InvNumber_Invoice
                                                             ON MIString_InvNumber_Invoice.MovementItemId = MovementItem.Id
                                                            AND MIString_InvNumber_Invoice.DescId = zc_MIString_InvNumber_Invoice()
                                LEFT JOIN MovementItemBoolean AS MIBoolean_Sign
                                                              ON MIBoolean_Sign.MovementItemId = MovementItem.Id
                                                             AND MIBoolean_Sign.DescId = zc_MIBoolean_Sign()
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId     = zc_MI_Child()
                              AND MovementItem.isErased   = FALSE
                            -- Важно - Сортировать
                            ORDER BY MovementItem.ParentId ASC
                                   , MovementItem.Id ASC
                           ) AS tmpMI
                      GROUP BY tmpMI.ParentId
                     )
       -- Результат
       SELECT
             tmpMI.Id                         AS Id
           , Object_Juridical.Id              AS JuridicalId
           , Object_Juridical.ObjectCode      AS JuridicalCode
           , Object_Juridical.ValueData       AS JuridicalName
           , tmpJuridicalDetails_View.OKPO
           , ObjectDesc.ItemName              AS ObjectDesc_ItemName
           , CASE WHEN ObjectDesc.Id = zc_Object_Juridical() THEN Object_Juridical.ValueData ELSE Object_Juridical_inf.ValueData END ::TVarChar AS JuridicalName_inf

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
             -- касса (место выдачи)
           , Object_Cash.Id            ::Integer   AS CashId
           , Object_Cash.ValueData     ::TVarChar  AS CashName
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

           , tmpMI.InsertName
           , tmpMI.UpdateName
           , tmpMI.InsertDate
           , tmpMI.UpdateDate

           , COALESCE (tmpMI.isErased, FALSE) AS isErased

           , CASE WHEN COALESCE (tmpMI_Child.Amount, 0) <> tmpMI.Amount
                    OR COALESCE (tmpMI_Child.Amount, 0) <> tmpMI.AmountPlan_total
                       -- подсветили если план изменен
                       THEN zc_Color_Aqua()
                  ELSE zc_Color_White()
             END ::Integer AS ColorFon_record

           , tmpMI_Child.GoodsName ::TVarChar AS GoodsName_Child
           , tmpMI_Child.InvNumber ::TVarChar AS InvNumber_Child
           , tmpMI_Child.InvNumber_Invoice ::TVarChar AS InvNumber_Invoice_Child
           , CASE WHEN tmpMI_Child.isSign = 0 THEN TRUE ELSE FALSE END ::Boolean AS Sign_Child
           , tmpMI_Child.Amount    ::TFloat   AS Amount_Child

       FROM tmpData
            FULL JOIN tmpMI ON tmpMI.JuridicalId = tmpData.JuridicalId
                           AND tmpMI.ContractId  = tmpData.ContractId

            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = COALESCE (tmpData.JuridicalId, tmpMI.JuridicalId)
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Juridical.DescId
            LEFT JOIN Object AS Object_Contract  ON Object_Contract.Id  = COALESCE (tmpData.ContractId, tmpMI.ContractId)
            LEFT JOIN Object AS Object_Cash      ON Object_Cash.Id  = tmpMI.CashId

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

            -- Child - Данные с № заявки 1С
            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpMI.Id

            -- Юр.лицо информативно
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId      = Object_Juridical.Id       --может быть юр. лицо, статья УП , контарагент
                                AND ObjectLink_Partner_Juridical.DescId        = zc_ObjectLink_Partner_Juridical()
                                AND Object_Juridical.DescId = zc_Object_Partner()
            LEFT JOIN Object AS Object_Juridical_inf ON Object_Juridical_inf.Id = ObjectLink_Partner_Juridical.ObjectId
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
       -- НЕТ - Банк текущей недели
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
                        -- НЕТ - Банк текущей недели
                        AND 1=0
                      GROUP BY MILinkObject_MoneyPlace.ObjectId
                             , MILinkObject_Contract.ObjectId
                     )
       -- Child - Данные с № заявки 1С
     , tmpMI_Child AS (SELECT tmpMI.ParentId
                            , STRING_AGG (tmpMI.GoodsName, '; ') AS GoodsName
                            , STRING_AGG (tmpMI.InvNumber, '; ') AS InvNumber
                            , STRING_AGG (tmpMI.InvNumber_Invoice, '; ') AS InvNumber_Invoice
                            , MAX (tmpMI.isSign)                 AS isSign
                            , SUM (tmpMI.Amount)                 AS Amount
                      FROM (SELECT MovementItem.Id
                                 , MovementItem.ParentId
                                 , COALESCE (MIString_GoodsName.ValueData, '')                  AS GoodsName
                                 , COALESCE (MIString_InvNumber.ValueData, '')                  AS InvNumber
                                 , COALESCE (MIString_InvNumber_Invoice.ValueData, '')          AS InvNumber_Invoice
                                 , CASE WHEN MIBoolean_Sign.ValueData = TRUE THEN 0 ELSE 1 END  AS isSign
                                 , MovementItem.Amount
                            FROM MovementItem
                                LEFT JOIN MovementItemString AS MIString_GoodsName
                                                             ON MIString_GoodsName.MovementItemId = MovementItem.Id
                                                            AND MIString_GoodsName.DescId = zc_MIString_GoodsName()
                                LEFT JOIN MovementItemString AS MIString_InvNumber
                                                             ON MIString_InvNumber.MovementItemId = MovementItem.Id
                                                            AND MIString_InvNumber.DescId = zc_MIString_InvNumber()
                                LEFT JOIN MovementItemString AS MIString_InvNumber_Invoice
                                                             ON MIString_InvNumber_Invoice.MovementItemId = MovementItem.Id
                                                            AND MIString_InvNumber_Invoice.DescId = zc_MIString_InvNumber_Invoice()
                                LEFT JOIN MovementItemBoolean AS MIBoolean_Sign
                                                              ON MIBoolean_Sign.MovementItemId = MovementItem.Id
                                                             AND MIBoolean_Sign.DescId = zc_MIBoolean_Sign()
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId     = zc_MI_Child()
                              AND MovementItem.isErased   = FALSE
                            -- Важно - Сортировать
                            ORDER BY MovementItem.ParentId ASC
                                   , MovementItem.Id ASC
                           ) AS tmpMI
                      GROUP BY tmpMI.ParentId
                     )

       -- Результат
       SELECT
             MovementItem.Id                  AS Id
           , Object_Juridical.Id              AS JuridicalId
           , Object_Juridical.ObjectCode      AS JuridicalCode
           , Object_Juridical.ValueData       AS JuridicalName
           , tmpJuridicalDetails_View.OKPO 
           , ObjectDesc.ItemName              AS ObjectDesc_ItemName
           , CASE WHEN ObjectDesc.Id = zc_Object_Juridical() THEN Object_Juridical.ValueData ELSE Object_Juridical_inf.ValueData END ::TVarChar AS JuridicalName_inf

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

             -- касса (место выдачи)
           , Object_Cash.Id            ::Integer   AS CashId
           , Object_Cash.ValueData     ::TVarChar  AS CashName

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
           , (COALESCE (tmpMI_bank_old.Amount_1, 0)
            + COALESCE (tmpMI_bank_old.Amount_2, 0)
            + COALESCE (tmpMI_bank_old.Amount_3, 0)
            + COALESCE (tmpMI_bank_old.Amount_4, 0)
            + COALESCE (tmpMI_bank_old.Amount_5, 0)
             )  :: TFloat AS AmountReal_total_old

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

           , Object_Insert.ValueData          AS InsertName
           , Object_Update.ValueData          AS UpdateName
           , MIDate_Insert.ValueData          AS InsertDate
           , MIDate_Update.ValueData          AS UpdateDate

           , MovementItem.isErased            AS isErased

           , CASE WHEN COALESCE (tmpMI_Child.Amount, 0) <> MovementItem.Amount
                    OR COALESCE (tmpMI_Child.Amount, 0) <> (COALESCE (MIFloat_AmountPlan_1.ValueData, 0)
                                                          + COALESCE (MIFloat_AmountPlan_2.ValueData, 0)
                                                          + COALESCE (MIFloat_AmountPlan_3.ValueData, 0)
                                                          + COALESCE (MIFloat_AmountPlan_4.ValueData, 0)
                                                          + COALESCE (MIFloat_AmountPlan_5.ValueData, 0)
                                                           )
                       -- подсветили если план изменен
                       THEN zc_Color_Aqua()
                  ELSE zc_Color_White()
             END ::Integer AS ColorFon_record

           , tmpMI_Child.GoodsName         ::TVarChar AS GoodsName_Child
           , tmpMI_Child.InvNumber         ::TVarChar AS InvNumber_Child
           , tmpMI_Child.InvNumber_Invoice ::TVarChar AS InvNumber_Invoice_Child
           , CASE WHEN tmpMI_Child.isSign = 0 THEN TRUE ELSE FALSE END ::Boolean AS Sign_Child
           , tmpMI_Child.Amount            ::TFloat   AS Amount_Child

       FROM tmpMI AS MovementItem
            INNER JOIN Object AS Object_Juridical ON Object_Juridical.Id     = MovementItem.ObjectId
                                                    -- Только Юр.л.
                                                 AND (Object_Juridical.DescId = zc_Object_Juridical()
                                                   OR Object_Juridical.DescId = zc_Object_InfoMoney() --или статья УП
                                                   OR Object_Juridical.DescId = zc_Object_Partner()   --или Контагент
                                                     ) 
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Juridical.DescId

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

            LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_Cash
                                                ON MILinkObject_Cash.MovementItemId = MovementItem.Id
                                               AND MILinkObject_Cash.DescId = zc_MILinkObject_Cash()
            LEFT JOIN Object AS Object_Cash ON Object_Cash.Id = MILinkObject_Cash.ObjectId

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

            -- Child - Данные с № заявки 1С
            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = MovementItem.Id

            -- Юр.лицо информативно
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId      = Object_Juridical.Id       --может быть юр. лицо, статья УП , контарагент
                                AND ObjectLink_Partner_Juridical.DescId        = zc_ObjectLink_Partner_Juridical()
                                AND Object_Juridical.DescId = zc_Object_Partner()
            LEFT JOIN Object AS Object_Juridical_inf ON Object_Juridical_inf.Id = ObjectLink_Partner_Juridical.ObjectId
     UNION ALL
       -- Данные прошлой недели
       SELECT
             0 :: Integer                     AS Id
           , Object_Juridical.Id              AS JuridicalId
           , Object_Juridical.ObjectCode      AS JuridicalCode
           , Object_Juridical.ValueData       AS JuridicalName
           , tmpJuridicalDetails_View.OKPO 
           , ObjectDesc.ItemName              AS ObjectDesc_ItemName
           , CASE WHEN ObjectDesc.Id = zc_Object_Juridical() THEN Object_Juridical.ValueData ELSE Object_Juridical_inf.ValueData END ::TVarChar AS JuridicalName_inf

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

             -- касса (место выдачи)
           , 0            ::Integer   AS CashId
           , ''           ::TVarChar  AS CashName

             -- Предварительный План на неделю
           , 0::TFloat AS Amount
           , 0::TFloat AS Amount_old
             -- Дата предварительный план
           , NULL :: TDateTime AS OperDate_Amount
           , NULL :: TDateTime AS OperDate_Amount_old

             -- Нач. долг
           , 0 ::TFloat       AS AmountRemains
             -- Долг с отсрочкой
           , 0 ::TFloat       AS AmountPartner
             -- Приход
           , 0 ::TFloat       AS AmountSumm

             -- Просрочка
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
           , (COALESCE (tmpMI_bank_old.Amount_1, 0)
            + COALESCE (tmpMI_bank_old.Amount_2, 0)
            + COALESCE (tmpMI_bank_old.Amount_3, 0)
            + COALESCE (tmpMI_bank_old.Amount_4, 0)
            + COALESCE (tmpMI_bank_old.Amount_5, 0)
             )  :: TFloat AS AmountReal_total_old

             -- Платим да/нет
           , FALSE ::Boolean  AS isAmountPlan_1
           , FALSE ::Boolean  AS isAmountPlan_2
           , FALSE ::Boolean  AS isAmountPlan_3
           , FALSE ::Boolean  AS isAmountPlan_4
           , FALSE ::Boolean  AS isAmountPlan_5

             -- Учитывается в долгах План прошлой недели да/нет
           , FALSE ::Boolean AS isPlan_1_old
           , FALSE ::Boolean AS isPlan_2_old
           , FALSE ::Boolean AS isPlan_3_old
           , FALSE ::Boolean AS isPlan_4_old
           , FALSE ::Boolean AS isPlan_5_old

           , ''   ::TVarChar AS Comment

           , ''   :: TVarChar           AS InsertName
           , ''   :: TVarChar           AS UpdateName
           , NULL :: TDateTime          AS InsertDate
           , NULL :: TDateTime          AS UpdateDate

           , FALSE :: Boolean AS isErased

           , zc_Color_White() ::Integer AS ColorFon_record

           , ''    ::TVarChar AS GoodsName_Child
           , ''    ::TVarChar AS InvNumber_Child
           , ''    ::TVarChar AS InvNumber_Invoice_Child
           , FALSE ::Boolean  AS Sign_Child
           , 0     ::TFloat   AS Amount_Child

       FROM (-- Банк предыдущей недели
             SELECT DISTINCT tmpMI_bank_old.JuridicalId, tmpMI_bank_old.ContractId
             FROM tmpMI_bank_old
             WHERE 1=1
             --AND vbUserId = 5

            UNION
             -- план прошлой недели
             SELECT DISTINCT tmpMI_old.JuridicalId, tmpMI_old.ContractId
             FROM tmpMI_old
             WHERE 1=1
             --AND vbUserId = 5
            ) AS tmpMI_list

            INNER JOIN Object AS Object_Juridical ON Object_Juridical.Id     = tmpMI_list.JuridicalId
                                                 -- Только Юр.л.
                                                 AND (Object_Juridical.DescId = zc_Object_Juridical()
                                                   OR Object_Juridical.DescId = zc_Object_InfoMoney() --или статья УП
                                                   OR Object_Juridical.DescId = zc_Object_Partner()   --или Контагент
                                                     ) 
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Juridical.DescId

            LEFT JOIN tmpMI ON tmpMI.ObjectId   = tmpMI_list.JuridicalId
                           AND tmpMI.ContractId = tmpMI_list.ContractId

            -- Банк предыдущей недели
            LEFT JOIN tmpMI_bank_old ON tmpMI_bank_old.JuridicalId = tmpMI_list.JuridicalId
                                    AND tmpMI_bank_old.ContractId  = tmpMI_list.ContractId
                                  --AND 1=0

            -- план прошлой недели
            LEFT JOIN tmpMI_old ON tmpMI_old.JuridicalId = tmpMI_list.JuridicalId
                               AND tmpMI_old.ContractId  = tmpMI_list.ContractId
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

            -- Реквизиты
            LEFT JOIN tmpJuridicalDetails_View ON tmpJuridicalDetails_View.JuridicalId = Object_Juridical.Id

            -- Договора - только tmpMI
            LEFT JOIN tmpContract_View AS View_Contract ON View_Contract.ContractId = tmpMI_list.ContractId
            -- Условия договора
            LEFT JOIN tmpContractCondition ON tmpContractCondition.ContractId = tmpMI_list.ContractId

            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = View_Contract.InfoMoneyId
            LEFT JOIN Object AS Object_PaidKind  ON Object_PaidKind.Id  = View_Contract.PaidKindId

            LEFT JOIN ObjectLink AS ObjectLink_Contract_Personal
                                 ON ObjectLink_Contract_Personal.ObjectId = View_Contract.ContractId
                                AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Contract_Personal.ChildObjectId

            -- УП-статья + № группы
            LEFT JOIN tmpInfoMoney_OrderF ON tmpInfoMoney_OrderF.InfoMoneyId = Object_InfoMoney.Id

            -- Юр.лицо информативно
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId      = Object_Juridical.Id       --может быть юр. лицо, статья УП , контарагент
                                AND ObjectLink_Partner_Juridical.DescId        = zc_ObjectLink_Partner_Juridical()
                                AND Object_Juridical.DescId = zc_Object_Partner()
            LEFT JOIN Object AS Object_Juridical_inf ON Object_Juridical_inf.Id = ObjectLink_Partner_Juridical.ObjectId
           ;

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.01.26         *
 14.01.26         *
 10.12.25         *
 17.11.25         *
 18.02.21         * AmountStart
 29.07.19         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_OrderFinanceSB (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_OrderFinanceSB (inMovementId:= 33154757, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '9818')
