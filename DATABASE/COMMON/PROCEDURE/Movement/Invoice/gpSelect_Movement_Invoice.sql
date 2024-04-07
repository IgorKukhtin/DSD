-- Function: gpSelect_Movement_Invoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_Invoice (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Invoice (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Invoice(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inJuridicalBasisId Integer   , -- Главное юр.лицо
    IN inIsErased         Boolean ,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , InvNumberPartner TVarChar
             , InsertDate TDateTime, InsertName TVarChar
             , TotalCount TFloat--, TotalCountKg TFloat, TotalCountSh TFloat
             , TotalSummMVAT TFloat , TotalSummPVAT TFloat, TotalSumm TFloat
             , TotalSummCurrency TFloat
             , TotalSumm_f1 TFloat, TotalSumm_f2 TFloat
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat
             , CurrencyValue TFloat, ParValue TFloat
             , CurrencyDocumentId Integer, CurrencyDocumentName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , Comment TVarChar
             , isClosed Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Invoice());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpUserAdmin AS (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)


       SELECT
             Movement.Id                                AS Id
           , Movement.InvNumber                         AS InvNumber
           , Movement.OperDate                          AS OperDate
           , Object_Status.ObjectCode                   AS StatusCode
           , Object_Status.ValueData                    AS StatusName
           , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner

           , MovementDate_Insert.ValueData              AS InsertDate
           , Object_Insert.ValueData                    AS InsertName

           , MovementFloat_TotalCount.ValueData         AS TotalCount

           , MovementFloat_TotalSummMVAT.ValueData      AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData      AS TotalSummPVAT
           , MovementFloat_TotalSumm.ValueData          AS TotalSumm
           , MovementFloat_TotalSummCurrency.ValueData  AS TotalSummCurrency
             -- оплата б/н
           , CASE WHEN Object_CurrencyDocument.Id = zc_Enum_Currency_Basis()
                  THEN CASE WHEN Object_PaidKind.Id = zc_Enum_PaidKind_FirstForm()
                            THEN MovementFloat_TotalSumm.ValueData - COALESCE (MovementFloat_TotalSummPayOth.ValueData,0)
                            ELSE COALESCE (MovementFloat_TotalSummPayOth.ValueData,0)
                       END
                  ELSE CASE WHEN Object_PaidKind.Id = zc_Enum_PaidKind_FirstForm()
                            THEN MovementFloat_TotalSummCurrency.ValueData - COALESCE (MovementFloat_TotalSummPayOth.ValueData,0)
                            ELSE COALESCE (MovementFloat_TotalSummPayOth.ValueData,0)
                       END
             END :: TFloat AS TotalSumm_f1
             -- оплата нал
           , CASE WHEN Object_CurrencyDocument.Id = zc_Enum_Currency_Basis()
                  THEN CASE WHEN Object_PaidKind.Id = zc_Enum_PaidKind_FirstForm()
                            THEN COALESCE (MovementFloat_TotalSummPayOth.ValueData,0)
                            ELSE MovementFloat_TotalSumm.ValueData - COALESCE (MovementFloat_TotalSummPayOth.ValueData,0)
                       END
                  ELSE CASE WHEN Object_PaidKind.Id = zc_Enum_PaidKind_FirstForm()
                            THEN COALESCE (MovementFloat_TotalSummPayOth.ValueData,0)
                            ELSE MovementFloat_TotalSummCurrency.ValueData - COALESCE (MovementFloat_TotalSummPayOth.ValueData,0)
                       END
             END :: TFloat AS TotalSumm_f2

           , MovementBoolean_PriceWithVAT.ValueData AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData     AS VATPercent
           , MovementFloat_ChangePercent.ValueData  AS ChangePercent
           , MovementFloat_CurrencyValue.ValueData  AS CurrencyValue
           , MovementFloat_ParValue.ValueData       AS ParValue

           , Object_CurrencyDocument.Id             AS CurrencyDocumentId
           , Object_CurrencyDocument.ValueData      AS CurrencyDocumentName

           , Object_Juridical.Id                    AS JuridicalId
           , Object_Juridical.ValueData             AS JuridicalName

           , Object_Contract.Id                     AS ContractId
           , Object_Contract.ObjectCode             AS ContractCode
           , Object_Contract.ValueData              AS ContractName

           , Object_PaidKind.Id                     AS PaidKindId
           , Object_PaidKind.ValueData              AS PaidKindName

           , MovementString_Comment.ValueData       AS Comment
           , COALESCE (MovementBoolean_Closed.ValueData, FALSE) :: Boolean AS isClosed

       FROM (SELECT Movement.id
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_Invoice() AND Movement.StatusId = tmpStatus.StatusId
            ) AS tmpMovement

            LEFT JOIN Movement ON Movement.id = tmpMovement.id

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementBoolean AS MovementBoolean_Closed
                                      ON MovementBoolean_Closed.MovementId = Movement.Id
                                     AND MovementBoolean_Closed.DescId = zc_MovementBoolean_Closed()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId =  Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummCurrency
                                    ON MovementFloat_TotalSummCurrency.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummCurrency.DescId = zc_MovementFloat_AmountCurrency()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPayOth
                                    ON MovementFloat_TotalSummPayOth.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPayOth.DescId = zc_MovementFloat_TotalSummPayOth()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
            LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                    ON MovementFloat_CurrencyValue.MovementId =  Movement.Id
                                   AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
            LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                    ON MovementFloat_ParValue.MovementId = Movement.Id
                                   AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                         ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                        AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                         ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
            LEFT JOIN Object AS Object_CurrencyDocument ON Object_CurrencyDocument.Id = MovementLinkObject_CurrencyDocument.ObjectId
           ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.03.19         * add MovementFloat_TotalSummPayOth
 19.05.17         * add Closed
 06.10.16         * add inJuridicalBasisId
 25.07.16         * InvNumberPartner
 15.07.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Invoice (inStartDate:= '30.01.2016', inEndDate:= '01.02.2016', inIsErased := FALSE, inJuridicalBasisId:= 0, inSession:= '2')
