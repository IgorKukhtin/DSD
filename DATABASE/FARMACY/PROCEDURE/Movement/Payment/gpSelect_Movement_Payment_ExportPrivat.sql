-- Function: gpSelect_Movement_Payment_ExportPrivat()

DROP FUNCTION IF EXISTS gpSelect_Movement_Payment_ExportPrivat (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Payment_ExportPrivat(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id                      Integer            
             , Bankid                  Integer
             , BankName                TVarChar
             , Income_JuridicalId      Integer
             , Income_JuridicalName    TVarChar
             , Income_UnitName         TVarChar
             , Income_InvNumber        TVarChar
             , Income_OperDate         TDateTime
             , Income_TotalSumm        TFloat
             , Income_NDS              TFloat
             , SummaPay                TFloat
             , Income_PayOrder         TFloat
             , Income_DatePayment      TDateTime
             , JuridicalNDS            TVarChar
             , NDSValue                TFloat
               
             , ContractNumber          TVarChar
             , ContractStartDate       TDateTime
             , ContractEndDate         TDateTime

             , Number                  Integer
             , PayerAccount            TVarChar

             , CBName                  TVarChar
             , CBMFO                   TVarChar
             , CBAccount               TVarChar
             , CBPurposePayment        TVarChar
             , OKPO                    TVarChar
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbJuridicalId Integer;

BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Payment());
    vbUserId:= inSession;

        SELECT Movement_Payment.JuridicalId
          INTO vbJuridicalId
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

        SELECT
            MI_Payment.ID
          , Object_Bank.id
          , Object_Bank.valuedata
          , MI_Payment.income_JuridicalId
          , MI_Payment.Income_JuridicalName
          , MI_Payment.Income_UnitName
          , MI_Payment.Income_InvNumber
          , MI_Payment.Income_OperDate
          , MI_Payment.Income_TotalSumm
          , MI_Payment.Income_NDS
          , MI_Payment.SummaPay
          , MI_Payment.Income_PayOrder
          , MI_Payment.Income_DatePayment
          , (MI_Payment.Income_JuridicalName||';'||CAST(MI_Payment.Income_NDS AS TVarChar))::TVarChar as JuridicalNDS
          , ROUND(MI_Payment.SummaPay * (MI_Payment.Income_NDS/100),2)::TFloat AS NDSValue
             
          , tmpJuridicalSettings.InvNumber AS ContractNumber
          , tmpJuridicalSettings.StartDate AS ContractStartDate
          , tmpJuridicalSettings.EndDate   AS ContractEndDate
          
          , ROW_NUMBER() OVER (ORDER BY MI_Payment.Income_PayOrder
                                       ,MI_Payment.Income_JuridicalName
                                       ,MI_Payment.Income_NDS
                                       ,MI_Payment.Income_OperDate
                                       ,MI_Payment.Income_InvNumber)::Integer AS Number

          , OS_BankAccount_CBAccount.ValueData        AS PayerAccount

          , ObjectString_CBName.ValueData             AS CBName 
          , ObjectString_CBMFO.ValueData              AS CBMFO
          , ObjectString_CBAccount.ValueData          AS CBAccount
          , ObjectString_CBPurposePayment.ValueData   AS CBPurposePayment
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

        WHERE MI_Payment.MovementId = inMovementId
          AND MI_Payment.isErased = FALSE
          AND MI_Payment.NeedPay = TRUE
          AND COALESCE(Object_Bank.id, 0) = 1020650
        ORDER BY
            MI_Payment.Income_PayOrder
           ,MI_Payment.Income_JuridicalName
           ,MI_Payment.Income_NDS
           ,MI_Payment.Income_OperDate
           ,MI_Payment.Income_InvNumber;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Payment_ExportPrivat (Integer,TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В
 08.09.19                                                                       *
*/

-- SELECT * FROM gpSelect_Movement_Payment_ExportPrivat (inMovementId := 15499959 , inSession:= '5');
