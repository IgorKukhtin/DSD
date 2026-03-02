-- Function:  gpSelect_Movement_OrderFinancePlan_XML()

--DROP FUNCTION IF EXISTS gpSelect_Movement_OrderFinancePlan_XML (TDateTime, Integer, Integer, Boolean,Boolean,Boolean,Boolean,Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_OrderFinancePlan_XML (TDateTime, Integer, Integer, Boolean,Boolean,Boolean,Boolean,Boolean, Boolean,TFloat, TVarChar);

/*
номер недели + год + день недели
+ айди банка (сейчас захардкодить OTP Bank) - и назвать кнопку что это выгрузка для OTP Bank  - формировать все данные  как в gpSelect_Movement_OrderFinance_Plan + с учетом zc_MIBoolean_AmountPlan_соотв день НЕ равен FALSE
*/

CREATE OR REPLACE FUNCTION  gpSelect_Movement_OrderFinancePlan_XML(
    IN inOperDate         TDateTime , -- Дата начю недели (для определения года)
    IN inWeekNumber       Integer   , -- Номер недели
    IN inBankMainId       Integer   , --    76970  ОТП банк
    IN inIsDay_1          Boolean    , --
    IN inIsDay_2          Boolean    , --
    IN inIsDay_3          Boolean    , --
    IN inIsDay_4          Boolean    , --
    IN inIsDay_5          Boolean    , --
    IN inIsNPP            Boolean    , -- для № очереди
    IN inNPP              TFloat     , -- № очереди
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (RowData TBlob)
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbMemberId Integer;
           vbPlan     TFloat;
           vbOperDate_day   TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    IF COALESCE (inBankMainId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Банк не выбран.';
    END IF;


    --проверка только 1 день должен быть выбран
    vbPlan := (CASE WHEN COALESCE (inIsDay_1,FALSE) = TRUE THEN 1 ELSE 0 END
             + CASE WHEN COALESCE (inIsDay_2,FALSE) = TRUE THEN 1 ELSE 0 END
             + CASE WHEN COALESCE (inIsDay_3,FALSE) = TRUE THEN 1 ELSE 0 END
             + CASE WHEN COALESCE (inIsDay_4,FALSE) = TRUE THEN 1 ELSE 0 END
             + CASE WHEN COALESCE (inIsDay_5,FALSE) = TRUE THEN 1 ELSE 0 END
             );

    IF COALESCE (vbPlan, 0) > 1
    THEN
        RAISE EXCEPTION 'Ошибка.Выбрано больше 1 дня.';
    END IF;

    IF COALESCE (vbPlan, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.День недели не выбран.';
    END IF;

    IF COALESCE (inIsNPP, FALSE) = TRUE AND COALESCE (inNPP,0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.№ очереди не задан.';
    END IF;

    --
    vbOperDate_day:= inOperDate + ('' || CASE WHEN COALESCE (inisDay_1,FALSE) = TRUE THEN 0
                                              WHEN COALESCE (inisDay_2,FALSE) = TRUE THEN 1
                                              WHEN COALESCE (inisDay_3,FALSE) = TRUE THEN 2
                                              WHEN COALESCE (inisDay_4,FALSE) = TRUE THEN 3
                                              WHEN COALESCE (inisDay_5,FALSE) = TRUE THEN 4
                                         END ||' DAY') ::Interval;

  CREATE TEMP TABLE tmpData (DOCUMENTDATE TVarChar, DOCUMENTNO TVarChar
                           , BANKID TVarChar, IBAN TVarChar, CORRBANKID TVarChar, CORRIBAN TVarChar
                           , CORRSNAME TVarChar, CORRIDENTIFYCODE TVarChar, DETAILSOFPAYMENT TVarChar
                           , AMOUNT INTEGER
                           , CORRCOUNTRYID TVarChar, PRIORITY TVarChar, PURPOSEPAYMENTID TVarChar, ADDENTRIES TVarChar, VALUEDATE TVarChar
                           ) ON COMMIT DROP;
     INSERT INTO tmpData (DOCUMENTDATE, DOCUMENTNO, BANKID, IBAN, CORRBANKID, CORRIBAN, CORRSNAME,  CORRIDENTIFYCODE, DETAILSOFPAYMENT, AMOUNT
                        , CORRCOUNTRYID, PRIORITY, PURPOSEPAYMENTID, ADDENTRIES, VALUEDATE
                         )
      WITH
       tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
               UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                    )
     , tmpMovement AS (
                       SELECT Movement.Id
                            , Movement.Invnumber
                          --, Movement.OperDate
                            , (DATE_TRUNC ('WEEK', zfCalc_Week_StartDate (Movement.OperDate, MovementFloat_WeekNumber.ValueData))
                             + (CASE WHEN COALESCE (inIsDay_1,FALSE) = TRUE THEN 0
                                     WHEN COALESCE (inIsDay_2,FALSE) = TRUE THEN 1
                                     WHEN COALESCE (inIsDay_3,FALSE) = TRUE THEN 2
                                     WHEN COALESCE (inIsDay_4,FALSE) = TRUE THEN 3
                                     WHEN COALESCE (inIsDay_5,FALSE) = TRUE THEN 4
                                END :: TVarChar || ' DAY' ) :: INTERVAL
                              ) ::TDateTime AS OperDate

                       FROM Movement
                            INNER JOIN MovementFloat AS MovementFloat_WeekNumber
                                                     ON MovementFloat_WeekNumber.MovementId = Movement.Id
                                                    AND MovementFloat_WeekNumber.DescId = zc_MovementFloat_WeekNumber()
                                                    AND MovementFloat_WeekNumber.ValueData = inWeekNumber
                           -- временно - Відділ забезбечення - 1
                           INNER JOIN MovementLinkObject AS MovementLinkObject_OrderFinance
                                                         ON MovementLinkObject_OrderFinance.MovementId = Movement.Id
                                                        AND MovementLinkObject_OrderFinance.DescId     = zc_MovementLinkObject_OrderFinance()
                                                        /*AND MovementLinkObject_OrderFinance.ObjectId   IN (3988049  -- Мясо
                                                                                                         , 3988054  -- Сырье, упаковочные и расходные материалы
                                                                                                         , 13069438 -- Техническое Обслуживание и Основные Средства
                                                                                                          )*/
                       WHERE Movement.DescId = zc_Movement_OrderFinance()
                         AND Movement.StatusId IN (SELECT tmpStatus.StatusId FROM tmpStatus)
                         AND Movement.OperDate BETWEEN inOperDate - INTERVAL '14 DAY' AND inOperDate + INTERVAL '14 DAY'
                       )

     , tmpMI AS (SELECT MovementItem.MovementId
                      , MovementItem.Id       AS Id
                      , MovementItem.ObjectId AS ObjectId
                 FROM MovementItem
                 WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                   AND MovementItem.DescId     = zc_MI_Master()
                   AND MovementItem.isErased   = FALSE
                 )
     , tmpMI_Child AS (SELECT MovementItem.Id          AS MovementItemId
                            , MovementItem.ParentId    AS MovementItemId_parent
                            , MovementItem.MovementId
                              -- Согласовано к оплате
                            , COALESCE (MIFloat_AmountPlan_next.ValueData, 0) AS AmountPlan_next
                              -- Платим да/нет
                            , COALESCE (MIBoolean_AmountPlan.ValueData, TRUE) ::Boolean AS isAmountPlan

                       FROM MovementItem
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPlan_next
                                                        ON MIFloat_AmountPlan_next.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPlan_next.DescId = zc_MIFloat_AmountPlan_next()
                            -- один день
                            INNER JOIN MovementItemDate AS MIDate_Amount_next
                                                        ON MIDate_Amount_next.MovementItemId = MovementItem.Id
                                                       AND MIDate_Amount_next.DescId         = zc_MIDate_Amount_next()
                                                       -- один день
                                                       AND MIDate_Amount_next.ValueData      = vbOperDate_day
                            -- Платим (да/нет)
                            LEFT JOIN MovementItemBoolean AS MIBoolean_AmountPlan
                                                          ON MIBoolean_AmountPlan.MovementItemId = MovementItem.Id
                                                         AND MIBoolean_AmountPlan.DescId IN (CASE WHEN COALESCE (inisDay_1,FALSE) = TRUE THEN zc_MIBoolean_AmountPlan_1()
                                                                                                  WHEN COALESCE (inisDay_2,FALSE) = TRUE THEN zc_MIBoolean_AmountPlan_2()
                                                                                                  WHEN COALESCE (inisDay_3,FALSE) = TRUE THEN zc_MIBoolean_AmountPlan_3()
                                                                                                  WHEN COALESCE (inisDay_4,FALSE) = TRUE THEN zc_MIBoolean_AmountPlan_4()
                                                                                                  WHEN COALESCE (inisDay_5,FALSE) = TRUE THEN zc_MIBoolean_AmountPlan_5()
                                                                                             END
                                                                                            )

                       WHERE MovementItem.MovementId IN (SELECT tmpMovement.Id FROM tmpMovement)
                         AND MovementItem.DescId = zc_MI_Child()
                         AND MovementItem.isErased = FALSE
                      )
     , tmpMIString_Child AS (SELECT *
                             FROM MovementItemString
                             WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI_Child.MovementItemId FROM tmpMI_Child)
                               AND MovementItemString.DescId IN (zc_MIString_GoodsName()
                                                               , zc_MIString_InvNumber_Invoice()
                                                                )
                             )

     , tmpMIFloat_AmountPlan AS (SELECT *
                                FROM MovementItemFloat
                                WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                  AND MovementItemFloat.DescId IN (CASE WHEN COALESCE (inIsDay_1,FALSE) = TRUE THEN zc_MIFloat_AmountPlan_1()
                                                                        WHEN COALESCE (inIsDay_2,FALSE) = TRUE THEN zc_MIFloat_AmountPlan_2()
                                                                        WHEN COALESCE (inIsDay_3,FALSE) = TRUE THEN zc_MIFloat_AmountPlan_3()
                                                                        WHEN COALESCE (inIsDay_4,FALSE) = TRUE THEN zc_MIFloat_AmountPlan_4()
                                                                        WHEN COALESCE (inIsDay_5,FALSE) = TRUE THEN zc_MIFloat_AmountPlan_5()
                                                                   END
                                                                   )
                                )

     , tmpMIFloat_Number AS (SELECT *
                             FROM MovementItemFloat
                             WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                               AND MovementItemFloat.DescId IN (CASE WHEN COALESCE (inNPP, 0) = 1 THEN zc_MIFloat_Number_1()
                                                                     WHEN COALESCE (inNPP, 0) = 2 THEN zc_MIFloat_Number_2()
                                                                     WHEN COALESCE (inNPP, 0) = 3 THEN zc_MIFloat_Number_3()
                                                                     WHEN COALESCE (inNPP, 0) = 4 THEN zc_MIFloat_Number_4()
                                                                     WHEN COALESCE (inNPP, 0) = 5 THEN zc_MIFloat_Number_5()
                                                                END
                                                                )
                            )
     , tmpMovementItemBoolean AS (SELECT *
                                  FROM MovementItemBoolean
                                  WHERE MovementItemBoolean.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                    AND MovementItemBoolean.DescId IN (
                                                                     CASE WHEN COALESCE (inIsDay_1,FALSE) = TRUE THEN zc_MIBoolean_AmountPlan_1()
                                                                          WHEN COALESCE (inIsDay_2,FALSE) = TRUE THEN zc_MIBoolean_AmountPlan_2()
                                                                          WHEN COALESCE (inIsDay_3,FALSE) = TRUE THEN zc_MIBoolean_AmountPlan_3()
                                                                          WHEN COALESCE (inIsDay_4,FALSE) = TRUE THEN zc_MIBoolean_AmountPlan_4()
                                                                          WHEN COALESCE (inIsDay_5,FALSE) = TRUE THEN zc_MIBoolean_AmountPlan_5()
                                                                     END
                                                                     )
                                 )
     , tmpMILO_Contract AS (SELECT *
                            FROM MovementItemLinkObject
                            WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                              AND MovementItemLinkObject.DescId IN (zc_MILinkObject_Contract()
                                                          )
                           )

   , tmpJuridicalOrderFinance AS (SELECT Object_JuridicalOrderFinance.Id                   AS JuridicalOrderFinanceId
                                       , OL_JuridicalOrderFinance_Juridical.ChildObjectId  AS JuridicalId

                                       , Main_BankAccount_View.BankId     AS BankId_main
                                       , Main_BankAccount_View.BankName   AS BankName_main
                                       , Main_BankAccount_View.MFO        AS MFO_main
                                       , Main_BankAccount_View.Id         AS BankAccountId_main
                                       , Main_BankAccount_View.Name       AS BankAccountName_main

                                       , Partner_BankAccount_View.BankId
                                       , Partner_BankAccount_View.BankName
                                       , Partner_BankAccount_View.MFO
                                       , Partner_BankAccount_View.Id                       AS BankAccountId
                                       , Partner_BankAccount_View.Name                     AS BankAccountName
                                       , OL_JuridicalOrderFinance_InfoMoney.ChildObjectId  AS InfoMoneyId
                                       , ObjectString_Comment.ValueData                    AS Comment
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
                                       INNER JOIN Object_BankAccount_View AS Main_BankAccount_View
                                                                          ON Main_BankAccount_View.Id = OL_JuridicalOrderFinance_BankAccountMain.ChildObjectId
                                                                         -- !!! по Этому банку
                                                                         AND Main_BankAccount_View.BankId = inBankMainId

                                       LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_BankAccount
                                                            ON OL_JuridicalOrderFinance_BankAccount.ObjectId = Object_JuridicalOrderFinance.Id
                                                           AND OL_JuridicalOrderFinance_BankAccount.DescId = zc_ObjectLink_JuridicalOrderFinance_BankAccount()
                                       LEFT JOIN Object_BankAccount_View AS Partner_BankAccount_View ON Partner_BankAccount_View.Id = OL_JuridicalOrderFinance_BankAccount.ChildObjectId

                                       LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_InfoMoney
                                                            ON OL_JuridicalOrderFinance_InfoMoney.ObjectId = Object_JuridicalOrderFinance.Id
                                                           AND OL_JuridicalOrderFinance_InfoMoney.DescId = zc_ObjectLink_JuridicalOrderFinance_InfoMoney()

                                       LEFT JOIN ObjectDate AS ObjectDate_OperDate
                                                            ON ObjectDate_OperDate.ObjectId = Object_JuridicalOrderFinance.Id
                                                           AND ObjectDate_OperDate.DescId = zc_ObjectDate_JuridicalOrderFinance_OperDate()

                                       LEFT JOIN ObjectString AS ObjectString_Comment
                                                              ON ObjectString_Comment.ObjectId = Object_JuridicalOrderFinance.Id
                                                             AND ObjectString_Comment.DescId = zc_ObjectString_JuridicalOrderFinance_Comment()

                                  WHERE Object_JuridicalOrderFinance.DescId = zc_Object_JuridicalOrderFinance()
                                   AND Object_JuridicalOrderFinance.isErased = FALSE
                                 )

     , tmpMI_Data_Child AS (SELECT MovementItem.MovementId
                                 , MovementItem.MovementItemId
                                 , MovementItem.MovementItemId_parent
                                 , MovementItem.AmountPlan_next
                                 , MovementItem.isAmountPlan
                                 , MIString_InvNumber_Invoice.ValueData AS InvNumber_Invoice
                                 , MIString_GoodsName.ValueData         AS GoodsName
                            FROM tmpMI_Child AS MovementItem
                                 LEFT JOIN tmpMIString_Child AS MIString_GoodsName
                                                             ON MIString_GoodsName.MovementItemId = MovementItem.MovementItemId
                                                            AND MIString_GoodsName.DescId = zc_MIString_GoodsName()
                                 LEFT JOIN tmpMIString_Child AS MIString_InvNumber_Invoice
                                                             ON MIString_InvNumber_Invoice.MovementItemId = MovementItem.MovementItemId
                                                            AND MIString_InvNumber_Invoice.DescId = zc_MIString_InvNumber_Invoice()
                           )

      , tmpMI_Data AS (SELECT MovementItem.MovementId
                            , MovementItem.Id                  AS Id
                            , Object_Juridical.Id              AS JuridicalId
                            , Object_Juridical.ValueData       AS JuridicalName
                            , tmpJuridicalDetails_View.OKPO    AS OKPO
                            , Object_InfoMoney.Id              AS InfoMoneyId
                            , Object_InfoMoney.ValueData       AS InfoMoneyName
                            , MILinkObject_Contract.ObjectId   AS ContractId

                              -- замена
                            , COALESCE (tmpMI_Child.AmountPlan_next, MIFloat_AmountPlan.ValueData) AS AmountPlan
                             -- Child
                           , tmpMI_Child.InvNumber_Invoice  AS InvNumber_Invoice_Child 
                           , tmpMI_Child.GoodsName          AS GoodsName_Child

                        FROM tmpMI AS MovementItem
                             -- Child
                             LEFT JOIN tmpMI_Data_Child AS tmpMI_Child ON tmpMI_Child.MovementItemId_parent = MovementItem.Id

                             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementItem.ObjectId
                                                                 AND Object_Juridical.DescId = zc_Object_Juridical()
                             LEFT JOIN ObjectHistory_JuridicalDetails_View AS tmpJuridicalDetails_View ON tmpJuridicalDetails_View.JuridicalId = Object_Juridical.Id

                             LEFT JOIN tmpMIFloat_AmountPlan AS MIFloat_AmountPlan
                                                             ON MIFloat_AmountPlan.MovementItemId = MovementItem.Id

                             LEFT JOIN tmpMIFloat_Number AS MIFloat_Number
                                                         ON MIFloat_Number.MovementItemId = MovementItem.Id 

                             LEFT JOIN tmpMovementItemBoolean AS MIBoolean_AmountPlan
                                                              ON MIBoolean_AmountPlan.MovementItemId = MovementItem.Id

                             LEFT JOIN tmpMILO_Contract AS MILinkObject_Contract
                                                        ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                             -- Только БН
                             INNER JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                                   ON ObjectLink_Contract_PaidKind.ObjectId      = MILinkObject_Contract.ObjectId
                                                  AND ObjectLink_Contract_PaidKind.DescId        = zc_ObjectLink_Contract_PaidKind()
                                                  -- Только БН
                                                  AND ObjectLink_Contract_PaidKind.ChildObjectId = zc_Enum_PaidKind_FirstForm()

                             LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                                  ON ObjectLink_Contract_InfoMoney.ObjectId = MILinkObject_Contract.ObjectId
                                                 AND ObjectLink_Contract_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()
                             LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_Contract_InfoMoney.ChildObjectId

                        WHERE COALESCE (tmpMI_Child.isAmountPlan, MIBoolean_AmountPlan.ValueData, TRUE) = TRUE
                          AND COALESCE (tmpMI_Child.AmountPlan_next, MIFloat_AmountPlan.ValueData, 0) <> 0 
                          AND (COALESCE (MIFloat_Number.ValueData,0) = inNPP OR COALESCE (inIsNPP, FALSE) = FALSE)
                     )
     , tmpContract_View AS (SELECT * FROM Object_Contract_View WHERE Object_Contract_View.ContractId IN (SELECT DISTINCT tmpMILO_Contract.ObjectId FROM tmpMILO_Contract))

        -- Результат
        SELECT (lpad (EXTRACT (YEAR FROM tmpMovement.OperDate)::tvarchar ,4, '0')||lpad (EXTRACT (MONTH FROM tmpMovement.OperDate)::tvarchar ,2, '0') ||lpad (EXTRACT (DAY FROM tmpMovement.OperDate)::tvarchar ,2, '0')) ::TVarchar AS DOCUMENTDATE     --Дата документа
             , tmpMovement.Invnumber                              AS DOCUMENTNO
             , tmpJuridicalOrderFinance.MFO_main                  AS BANKID
             , tmpJuridicalOrderFinance.BankAccountName_main      AS IBAN
             , tmpJuridicalOrderFinance.MFO                       AS CORRBANKID
             , tmpJuridicalOrderFinance.BankAccountName           AS CORRIBAN
             , tmpMI.JuridicalName                                AS CORRSNAME
             , COALESCE (tmpMI.OKPO,'') :: TVarChar AS CORRIDENTIFYCODE
             --, Object_InfoMoney.ValueData       AS DETAILSOFPAYMENT

               -- Назначение платежа
             , zfCalc_Comment_pay_OrderFinance (inComment    := COALESCE (tmpJuridicalOrderFinance.Comment, '')
                                              , inNOM_DOG    := COALESCE (View_Contract.InvNumber, '')
                                              , inNOM_IVOICE := COALESCE (tmpMI.InvNumber_Invoice_Child, '')
                                              , inTOVAR      := COALESCE (tmpMI.GoodsName_Child, '')
                                              , inDATA_DOG   := COALESCE (View_Contract.StartDate, zc_DateStart())
                                              , inPDV        := 20
                                              , inSUMMA_P    := tmpMI.AmountPlan
                                               ) ::TVarChar AS DETAILSOFPAYMENT

             , (COALESCE (tmpMI.AmountPlan,0) *100) :: INTEGER AS AMOUNT
             , 804                  ::TVarChar  AS CORRCOUNTRYID    --Код страны корреспондента
             , 50                   ::TVarChar  AS PRIORITY         --Приоритет
             , '000'                ::TVarChar  AS PURPOSEPAYMENTID --Код назначения платежа
             , ''                   ::TVarChar  AS ADDENTRIES       --Дополнительные реквизиты платежа
             , (lpad (EXTRACT (YEAR FROM tmpMovement.OperDate)::tvarchar ,4, '0')||lpad (EXTRACT (MONTH FROM tmpMovement.OperDate)::tvarchar ,2, '0') ||lpad (EXTRACT (DAY FROM tmpMovement.OperDate)::tvarchar ,2, '0')) ::TVarchar AS VALUEDATE        --Дата валютирования

        FROM tmpMovement
             LEFT JOIN tmpMI_Data AS tmpMI ON tmpMI.MovementId = tmpMovement.Id

             LEFT JOIN tmpContract_View AS View_Contract ON View_Contract.ContractId = tmpMI.ContractId

             INNER JOIN tmpJuridicalOrderFinance ON tmpJuridicalOrderFinance.JuridicalId = tmpMI.JuridicalId
                                                AND tmpJuridicalOrderFinance.InfoMoneyId = tmpMI.InfoMoneyId
                                                AND tmpJuridicalOrderFinance.Ord = 1
        ;


     -- Таблица для результата
     CREATE TEMP TABLE _Result (Num Integer, RowData TBlob) ON COMMIT DROP;

     -- первые строчки XML
     INSERT INTO _Result(Num, RowData) VALUES (1, '<?xml version= "1.0" encoding= "windows-1251"?>');

     -- данные
     INSERT INTO _Result(Num, RowData) VALUES (2, '<ROWDATA>');
     INSERT INTO _Result(Num, RowData)
    SELECT ROW_NUMBER() OVER (ORDER BY tmp.CORRSNAME ASC) + 100
          , '<ROW '
         || 'AMOUNT ="'||tmp.AMOUNT||'" '                                               --Сумма платежа в копейках
         --|| 'CORRSNAME="'||COALESCE (tmp.CORRSNAME,'')::TVarChar||'" '                  -- Наименование получателя платежа
         || 'CORRSNAME="'|| replace (replace (substring (COALESCE (tmp.CORRSNAME,''), 1, 36), '"', '&quot;'), CHR (39), '&apos;') :: TVarChar||'" ' -- Наименование получателя платежа обрезаем , если больше 36 символов
         || 'DETAILSOFPAYMENT="'|| replace (replace (COALESCE (tmp.DETAILSOFPAYMENT,''), '"', '&quot;'), CHR (39), '&apos;')::TVarChar||'" '    --Назначение платежа
         || 'CORRACCOUNTNO="'||COALESCE (tmp.CORRIBAN,'')::TVarChar||'" '               --№ счета получателя платежа
         || 'CORRIBAN="'||COALESCE (tmp.CORRIBAN,'')::TVarChar||'" '                    --IBAN получателя платежа
         || 'ACCOUNTNO="'||COALESCE (tmp.IBAN,'')::TVarChar||'" '                       --№ счета плательщика
         || 'IBAN="'||COALESCE (tmp.IBAN,'')::TVarChar||'" '                            --IBAN плательщика
         || 'CORRBANKID="'||COALESCE (tmp.CORRBANKID,'')::TVarChar||'" '                --Код банка получателя платежа (МФО)
         || 'CORRIDENTIFYCODE="'||COALESCE (tmp.CORRIDENTIFYCODE,'')::TVarChar||'" '    --Идентификационный код получателя платежа (ЕГРПОУ)
         || 'CORRCOUNTRYID="'||COALESCE (tmp.CORRCOUNTRYID,'')::TVarChar||'" '          --Код страны корреспондента
         --|| 'DOCUMENTNO="'||COALESCE (tmp.DOCUMENTNO,'')::TVarChar||'" '                --№ документа
         || 'DOCUMENTNO="'||CAST (NEXTVAL ('movement_bankaccount_plat_seq') AS TVarChar)||'" '
       --|| 'VALUEDATE="'||COALESCE (tmp.VALUEDATE::TVarChar,'')::TVarChar||'" '        --Дата валютирования
         || 'PRIORITY="'||tmp.PRIORITY||'" '                                            --Приоритет
         || 'DOCUMENTDATE="'||tmp.DOCUMENTDATE||'" '                                    --Дата документа
         || 'ADDENTRIES="'||COALESCE (tmp.ADDENTRIES,'')::TVarChar||'" '                --Дополнительные реквизиты платежа
         || 'PURPOSEPAYMENTID="'||COALESCE (tmp.PURPOSEPAYMENTID,'')||'" '              --Код назначения платежа   --??????????????????????
         || 'BANKID="'||COALESCE (tmp.BANKID,'')::TVarChar||'" '                        --Код банка плательщика (МФО)
         || '/>'
     FROM tmpData AS tmp ;

     --последнии строчки XML
     INSERT INTO _Result(Num, RowData) VALUES ((SELECT MAX (_Result.Num) + 1 FROM _Result), '</ROWDATA>');

     -- Результат
     RETURN QUERY
        SELECT _Result.RowData FROM _Result ORDER BY Num;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.09.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderFinancePlan_XML(inOperDate :='17.11.2025'::TDateTime , inWeekNumber:= 47, inBankMainId := 76970, inIsDay_1 := TRUE, inIsDay_2 := FAlSE, inIsDay_3 := FAlSE, inIsDay_4 := FAlSE, inIsDay_5 := FAlSE, inisNPP := true, inNPP := 2, inSession := '3');
