-- Function: gpSelect_Movement_Payment_ExportUkrxim()

DROP FUNCTION IF EXISTS gpSelect_Movement_Payment_ExportUkrxim (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Payment_ExportUkrxim(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Income_JuridicalId      Integer
             , Income_JuridicalName    TVarChar
             , SummaPay                TFloat
             , Income_NDS              TFloat

             , ContractNumber          TVarChar
             , ContractStartDate       TDateTime

             , OperDate                TDateTime
             , Number                  Integer
             , PayerMFO                TVarChar
             , PayerAccount            TVarChar
             , PayerIBAN               TVarChar
             
             , CBMFO                   TVarChar
             , CBAccount               TVarChar
             , CBIBAN                  TVarChar
             , CBID                    TVarChar

             , CountryCode             Integer
             , CBName                  TVarChar

             , Priority                Integer
             , CBPurposePayment        TVarChar
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbJuridicalId Integer;
    DECLARE vbOperDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Payment());
    vbUserId:= inSession;

    SELECT Movement_Payment.OperDate, Movement_Payment.JuridicalId
    INTO vbOperDate, vbJuridicalId
    FROM Movement_Payment_View AS Movement_Payment
    WHERE Movement_Payment.Id = inMovementId;


    RETURN QUERY
      WITH tmpJuridicalSettings AS
            (SELECT distinct tmp.JuridicalId
                  , Max(tmp.Name)      ::TVarChar   AS InvNumber
                  , Max(tmp.StartDate) ::TDateTime  AS StartDate
                  , Max(tmp.EndDate)   ::TDateTime  AS EndDate
             FROM gpSelect_Object_JuridicalSettings (FALSE,  inSession) as tmp
             WHERE tmp.MainJuridicalId = vbJuridicalId
               AND Coalesce (tmp.Name, '') <> ''
             GROUP BY tmp.JuridicalId
             )
         , tmpMovementItem_Payment AS
            (SELECT
                    MI_Payment.income_JuridicalId
                  , MI_Payment.Income_JuridicalName
                  , Sum(MI_Payment.SummaPay)          AS SummaPay
                  , MI_Payment.Income_NDS
                  , MI_Payment.BankAccountId

                  , tmpJuridicalSettings.InvNumber AS ContractNumber
                  , tmpJuridicalSettings.StartDate AS ContractStartDate
                  , ObjectHistoryString_JuridicalDetails_OKPO.ValueData AS OKPO

            FROM MovementItem_Payment_View AS MI_Payment

                 LEFT OUTER JOIN ObjectHistory AS ObjectHistory_Juridical
                                               ON ObjectHistory_Juridical.ObjectId = MI_Payment.Income_JuridicalId
                                              AND ObjectHistory_Juridical.DescId = zc_ObjectHistory_JuridicalDetails()
                                              AND CURRENT_DATE >= ObjectHistory_Juridical.StartDate AND CURRENT_DATE < ObjectHistory_Juridical.EndDate
                 LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_OKPO
                                               ON ObjectHistoryString_JuridicalDetails_OKPO.ObjectHistoryId = ObjectHistory_Juridical.Id
                                              AND ObjectHistoryString_JuridicalDetails_OKPO.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO()
                 LEFT JOIN tmpJuridicalSettings ON tmpJuridicalSettings.JuridicalId = MI_Payment.Income_JuridicalId

                 LEFT OUTER JOIN MovementitemLinkObject AS MILinkObject_BankAccount
                                                        ON MILinkObject_BankAccount.MovementItemId = MI_Payment.ID
                                                       AND MILinkObject_BankAccount.DescId = zc_MILinkObject_BankAccount()
                 LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = MILinkObject_BankAccount.ObjectId
                 LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                                      ON ObjectLink_BankAccount_Bank.ObjectId = Object_BankAccount.Id
                                     AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
                 LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId


            WHERE MI_Payment.MovementId = inMovementId
              AND MI_Payment.isErased = FALSE
              AND MI_Payment.NeedPay = TRUE
              AND COALESCE(Object_Bank.id, 0) = 4813205
           GROUP BY MI_Payment.income_JuridicalId, MI_Payment.Income_JuridicalName, MI_Payment.Income_NDS,
                    tmpJuridicalSettings.InvNumber, tmpJuridicalSettings.StartDate, MI_Payment.BankAccountId,
                    ObjectHistoryString_JuridicalDetails_OKPO.ValueData)

    SELECT
            MI_Payment.income_JuridicalId
          , MI_Payment.Income_JuridicalName
          , MI_Payment.SummaPay::TFloat
          , MI_Payment.Income_NDS

          , MI_Payment.ContractNumber
          , MI_Payment.ContractStartDate
          
          , vbOperDate                                AS OperDate

          , ROW_NUMBER() OVER (ORDER BY MI_Payment.Income_JuridicalName
                                      , MI_Payment.Income_NDS)::Integer AS Number
          , OS_Bank_MFO.ValueData                     AS PayerMFO
          , CASE WHEN TRIM(upper(SUBSTRING(OS_BankAccount_CBAccount.ValueData, 1, 2))) <> 'UA' 
            THEN OS_BankAccount_CBAccount.ValueData END::TVarChar AS PayerAccount
          , CASE WHEN TRIM(upper(SUBSTRING(OS_BankAccount_CBAccount.ValueData, 1, 2))) = 'UA' 
            THEN OS_BankAccount_CBAccount.ValueData END::TVarChar AS PayerIBAN

          , ObjectString_CBMFO.ValueData              AS CBMFO
          , CASE WHEN TRIM(upper(SUBSTRING(ObjectString_CBAccount.ValueData, 1, 2))) <> 'UA' 
            THEN ObjectString_CBAccount.ValueData END::TVarChar AS CBAccount
          , CASE WHEN TRIM(upper(SUBSTRING(ObjectString_CBAccount.ValueData, 1, 2))) = 'UA' 
            THEN ObjectString_CBAccount.ValueData END::TVarChar AS CBIBAN
          , MI_Payment.OKPO                           AS CBID
          , 804                                       AS CountryCode
          , ObjectString_CBName.ValueData             AS CBName
          , 50                                        AS Priority
          
          , (CASE WHEN COALESCE(ObjectString_CBPurposePayment.ValueData, '') <> ''
             THEN ObjectString_CBPurposePayment.ValueData
             ELSE 'Сплата за товар мед.призначення' END||
             'зг.дог.№ '||MI_Payment.ContractNumber::TVarChar||' від '||
             TO_CHAR (MI_Payment.ContractStartDate, 'dd.mm.yyyy')||' р У т.ч. ПДВ '||
             MI_Payment.Income_NDS::Integer::TVarChar||'%')::TVarChar    AS CBPurposePayment

        FROM tmpMovementItem_Payment AS MI_Payment

             LEFT JOIN ObjectString AS ObjectString_CBName
                                    ON ObjectString_CBName.ObjectId = MI_Payment.income_JuridicalId
                                   AND ObjectString_CBName.DescId = zc_ObjectString_Juridical_CBName()

             LEFT JOIN ObjectString AS ObjectString_CBMFO
                                    ON ObjectString_CBMFO.ObjectId = MI_Payment.income_JuridicalId
                                   AND ObjectString_CBMFO.DescId = zc_ObjectString_Juridical_CBMFO()

             LEFT JOIN ObjectString AS ObjectString_CBAccount
                                    ON ObjectString_CBAccount.ObjectId = MI_Payment.income_JuridicalId
                                   AND ObjectString_CBAccount.DescId = zc_ObjectString_Juridical_CBAccount()

             LEFT JOIN ObjectString AS ObjectString_CBPurposePayment
                                    ON ObjectString_CBPurposePayment.ObjectId = MI_Payment.income_JuridicalId
                                   AND ObjectString_CBPurposePayment.DescId = zc_ObjectString_Juridical_CBPurposePayment()

             LEFT JOIN ObjectString AS OS_BankAccount_CBAccount
                                    ON OS_BankAccount_CBAccount.ObjectId = MI_Payment.BankAccountId
                                   AND OS_BankAccount_CBAccount.DescId = zc_ObjectString_BankAccount_CBAccount()

            LEFT JOIN ObjectString AS OS_Bank_MFO
                                   ON OS_Bank_MFO.ObjectId = 4813205
                                  AND OS_Bank_MFO.DescId = zc_ObjectString_Bank_MFO()

        ORDER BY MI_Payment.Income_JuridicalName
               , MI_Payment.Income_NDS
           ;




END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Payment_ExportUkrxim (Integer,TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В
 08.09.19                                                                       *
*/

-- SELECT * FROM gpSelect_Movement_Payment_ExportUkrxim (inMovementId := 15584404 , inSession:= '5');


