-- Function:  gpSelect_Movement_OrderFinancePlan_XML()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderFinancePlan_XML (TDateTime, Integer, Integer, Boolean,Boolean,Boolean,Boolean,Boolean, TVarChar);

/*
номер недели + год + день недели
+ айди банка (сейчас захардкодить OTP Bank) - и назвать кнопку что это выгрузка для OTP Bank  - формировать все данные  как в gpSelect_Movement_OrderFinance_Plan + с учетом zc_MIBoolean_AmountPlan_соотв день НЕ равен FALSE
*/

CREATE OR REPLACE FUNCTION  gpSelect_Movement_OrderFinancePlan_XML(
    IN inOperDate         TDateTime , -- Дата начю недели (для определения года)
    IN inWeekNumber       Integer   , -- Номер недели
    IN inBankMainId       Integer   , --    76970  ОТП банк
    IN inisPlan_1         Boolean    , --
    IN inisPlan_2         Boolean    , --
    IN inisPlan_3         Boolean    , --
    IN inisPlan_4         Boolean    , --
    IN inisPlan_5         Boolean    , --
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (RowData TBlob)
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbMemberId Integer;
           vbPlan     TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    IF COALESCE (inBankMainId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Банк не выбран.';
    END IF;


    --проверка только 1 день должен быть выбран
    vbPlan := (CASE WHEN COALESCE (inisPlan_1,FALSE) = TRUE THEN 1 ELSE 0 END
             + CASE WHEN COALESCE (inisPlan_2,FALSE) = TRUE THEN 1 ELSE 0 END
             + CASE WHEN COALESCE (inisPlan_3,FALSE) = TRUE THEN 1 ELSE 0 END
             + CASE WHEN COALESCE (inisPlan_4,FALSE) = TRUE THEN 1 ELSE 0 END
             + CASE WHEN COALESCE (inisPlan_5,FALSE) = TRUE THEN 1 ELSE 0 END
             );

    IF COALESCE (vbPlan, 0) > 1
    THEN
        RAISE EXCEPTION 'Ошибка.Выбрано больше 1 дня.';
    END IF;

    IF COALESCE (vbPlan, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.День недели не выбран.';
    END IF;

  CREATE TEMP TABLE tmpData (DOCUMENTDATE TVarChar, DOCUMENTNO TVarChar
                           , BANKID TVarChar, IBAN TVarChar, CORRBANKID TVarChar, CORRIBAN TVarChar
                           , CORRSNAME TVarChar, CORRIDENTIFYCODE TVarChar, DETAILSOFPAYMENT TVarChar
                           , AMOUNT INTEGER
                           , CORRCOUNTRYID TVarChar, PRIORITY TVarChar, PURPOSEPAYMENTID TVarChar, ADDENTRIES TVarChar, VALUEDATE TVarChar
                           ) ON COMMIT DROP;
     -- 
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
                            , (DATE_TRUNC ('WEEK', DATE_TRUNC ('YEAR', Movement.OperDate) + ((((7 * COALESCE (MovementFloat_WeekNumber.ValueData - 1, 0)
                                                                                               ) :: Integer) :: TVarChar) || ' DAY' ):: INTERVAL)
                             + (CASE WHEN COALESCE (inisPlan_1,FALSE) = TRUE THEN 0
                                     WHEN COALESCE (inisPlan_2,FALSE) = TRUE THEN 1
                                     WHEN COALESCE (inisPlan_3,FALSE) = TRUE THEN 2
                                     WHEN COALESCE (inisPlan_4,FALSE) = TRUE THEN 3
                                     WHEN COALESCE (inisPlan_5,FALSE) = TRUE THEN 4
                                END :: TVarChar || ' DAY' ) :: INTERVAL
                              ) ::TDateTime AS OperDate

                       FROM Movement
                            INNER JOIN MovementFloat AS MovementFloat_WeekNumber
                                                     ON MovementFloat_WeekNumber.MovementId = Movement.Id
                                                    AND MovementFloat_WeekNumber.DescId = zc_MovementFloat_WeekNumber()
                                                    AND MovementFloat_WeekNumber.ValueData = inWeekNumber
                       WHERE Movement.DescId = zc_Movement_OrderFinance()
                         AND Movement.StatusId IN (SELECT tmpStatus.StatusId FROM tmpStatus)
                         AND Movement.OperDate BETWEEN inOperDate - INTERVAL '14 DAY' AND inOperDate + INTERVAL '14 DAY'
                       )

     , tmpMI AS (SELECT MovementItem.MovementId
                      , MovementItem.Id       AS Id
                      , MovementItem.ObjectId AS ObjectId
                 FROM MovementItem
                 WHERE MovementItem.MovementId IN (SELECT tmpMovement.Id FROM tmpMovement)
                   AND MovementItem.DescId = zc_MI_Master()
                   AND MovementItem.isErased = FALSE
                 )

     , tmpMovementItemFloat AS (SELECT *
                                FROM MovementItemFloat
                                WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                  AND MovementItemFloat.DescId IN (CASE WHEN COALESCE (inisPlan_1,FALSE) = TRUE THEN zc_MIFloat_AmountPlan_1()
                                                                        WHEN COALESCE (inisPlan_2,FALSE) = TRUE THEN zc_MIFloat_AmountPlan_2()
                                                                        WHEN COALESCE (inisPlan_3,FALSE) = TRUE THEN zc_MIFloat_AmountPlan_3()
                                                                        WHEN COALESCE (inisPlan_4,FALSE) = TRUE THEN zc_MIFloat_AmountPlan_4()
                                                                        WHEN COALESCE (inisPlan_5,FALSE) = TRUE THEN zc_MIFloat_AmountPlan_5()
                                                                   END
                                                                   )
                                )

     , tmpMovementItemBoolean AS (SELECT *
                                  FROM MovementItemBoolean
                                  WHERE MovementItemBoolean.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                    AND MovementItemBoolean.DescId IN (
                                                                     CASE WHEN COALESCE (inisPlan_1,FALSE) = TRUE THEN zc_MIBoolean_AmountPlan_1()
                                                                          WHEN COALESCE (inisPlan_2,FALSE) = TRUE THEN zc_MIBoolean_AmountPlan_2()
                                                                          WHEN COALESCE (inisPlan_3,FALSE) = TRUE THEN zc_MIBoolean_AmountPlan_3()
                                                                          WHEN COALESCE (inisPlan_4,FALSE) = TRUE THEN zc_MIBoolean_AmountPlan_4()
                                                                          WHEN COALESCE (inisPlan_5,FALSE) = TRUE THEN zc_MIBoolean_AmountPlan_5()
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

      , tmpMI_Data AS (SELECT MovementItem.MovementId
                            , MovementItem.Id                  AS Id
                            , Object_Juridical.Id              AS JuridicalId
                            , Object_Juridical.ValueData       AS JuridicalName
                            , tmpJuridicalDetails_View.OKPO    AS OKPO
                            , Object_InfoMoney.Id              AS InfoMoneyId
                            , Object_InfoMoney.ValueData       AS InfoMoneyName
                            , MILinkObject_Contract.ObjectId   AS ContractId

                            , MIFloat_AmountPlan.ValueData     AS AmountPlan
                        FROM tmpMI AS MovementItem
                             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementItem.ObjectId
                                                                 AND Object_Juridical.DescId = zc_Object_Juridical()
                             LEFT JOIN ObjectHistory_JuridicalDetails_View AS tmpJuridicalDetails_View ON tmpJuridicalDetails_View.JuridicalId = Object_Juridical.Id

                             LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlan
                                                            ON MIFloat_AmountPlan.MovementItemId = MovementItem.Id

                             LEFT JOIN tmpMovementItemBoolean AS MIBoolean_AmountPlan
                                                              ON MIBoolean_AmountPlan.MovementItemId = MovementItem.Id

                             LEFT JOIN tmpMILO_Contract AS MILinkObject_Contract
                                                        ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()

                             LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                                  ON ObjectLink_Contract_InfoMoney.ObjectId = MILinkObject_Contract.ObjectId
                                                 AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                             LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_Contract_InfoMoney.ChildObjectId

                        WHERE COALESCE (MIBoolean_AmountPlan.ValueData, TRUE) = TRUE
                          AND COALESCE (MIFloat_AmountPlan.ValueData,0) <> 0
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


             , REPLACE (REPLACE
                       (REPLACE
                       (REPLACE (COALESCE (tmpJuridicalOrderFinance.Comment, '')
                                                                 , 'NOM_DOG', COALESCE (View_Contract.InvNumber, ''))
                                                                 , 'DATA_DOG', zfConvert_DateToString (COALESCE (View_Contract.StartDate, zc_DateStart())))
                                                                 , 'PDV', '20')
                                                                 , 'SUMMA_P', zfConvert_FloatToString (ROUND(tmpMI.AmountPlan/6, 2))
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
-- SELECT * FROM gpSelect_Movement_OrderFinancePlan_XML(inOperDate :='17.11.2025'::TDateTime , inWeekNumber:= 47, inBankMainId := 76970, inisPlan_1 := TRUE, inisPlan_2 := FAlSE, inisPlan_3 := FAlSE, inisPlan_4 := FAlSE, inisPlan_5 := FAlSE, inSession := '3');
