-- Function: gpSelect_Movement_ReturnIn_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_ReturnIn_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ReturnIn_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , Checked Boolean
             , OperDatePartner TDateTime
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat
             , TotalCount TFloat
             , TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractName TVarChar

             , JuridicalId_From Integer, JuridicalName_From TVarChar
             , JuridicalAddress_From TVarChar
             , OKPO_From TVarChar
             , INN_From TVarChar
             , NumberVAT_From TVarChar
             , AccounterName_From TVarChar
             , BankAccount_From TVarChar

             , JuridicalId_To Integer, JuridicalName_To TVarChar
             , JuridicalAddress_To TVarChar
             , OKPO_To TVarChar
             , INN_To TVarChar
             , NumberVAT_To TVarChar
             , AccounterName_To TVarChar
             , BankAccount_To TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= inSession;

     --
     RETURN QUERY
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode          		AS StatusCode
           , Object_Status.ValueData         	    AS StatusName
           , MovementBoolean_Checked.ValueData      AS Checked
           , MovementDate_OperDatePartner.ValueData AS OperDatePartner
           , MovementBoolean_PriceWithVAT.ValueData AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData     AS VATPercent
           , MovementFloat_ChangePercent.ValueData  AS ChangePercent
           , MovementFloat_TotalCount.ValueData     AS TotalCount
           , MovementFloat_TotalSummMVAT.ValueData  AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData  AS TotalSummPVAT
           , MovementFloat_TotalSumm.ValueData      AS TotalSumm
           , Object_From.Id                    		AS FromId
           , Object_From.ValueData             		AS FromName
           , Object_To.Id                      		AS ToId
           , Object_To.ValueData               		AS ToName
           , Object_PaidKind.Id                		AS PaidKindId
           , Object_PaidKind.ValueData         		AS PaidKindName
           , Object_Contract.Id                		AS ContractId
           , Object_Contract.ValueData         		AS ContractName

           , OH_JuridicalDetails_From.JuridicalId       AS JuridicalId_From
           , COALESCE (OH_JuridicalDetails_From.FullName
                       , Object_From.ValueData)         AS JuridicalName_From
           , OH_JuridicalDetails_From.JuridicalAddress  AS JuridicalAddress_From
           , OH_JuridicalDetails_From.OKPO              AS OKPO_From
           , OH_JuridicalDetails_From.INN               AS INN_From
           , OH_JuridicalDetails_From.NumberVAT         AS NumberVAT_From
           , OH_JuridicalDetails_From.AccounterName     AS AccounterName_From
           , OH_JuridicalDetails_From.BankAccount       AS BankAccount_From

           , OH_JuridicalDetails_To.JuridicalId         AS JuridicalId_To
           , COALESCE (OH_JuridicalDetails_To.FullName
                       , Object_To.ValueData)           AS JuridicalName_To
           , OH_JuridicalDetails_To.JuridicalAddress    AS JuridicalAddress_To
           , OH_JuridicalDetails_To.OKPO                AS OKPO_To
           , OH_JuridicalDetails_To.INN                 AS INN_To
           , OH_JuridicalDetails_To.NumberVAT           AS NumberVAT_To
           , OH_JuridicalDetails_To.AccounterName       AS AccounterName_To
           , OH_JuridicalDetails_To.BankAccount         AS BankAccount_To


       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                      ON MovementBoolean_Checked.MovementId =  Movement.Id
                                     AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

           LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

-- ============================
            --по контрагенту находим юр.лицо
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

            --по складу-получателю находим наше юр.лицо (если оно есть)
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical ON ObjectLink_Unit_Juridical.objectid = MovementLinkObject_To.ObjectId
                                                             AND ObjectLink_Unit_Juridical.descid = zc_ObjectLink_Unit_Juridical()

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                                                                ON OH_JuridicalDetails_From.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                                               AND Movement.OperDate BETWEEN OH_JuridicalDetails_From.StartDate AND OH_JuridicalDetails_From.EndDate

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_To
                                                                ON OH_JuridicalDetails_To.JuridicalId = ObjectLink_Unit_Juridical.ChildObjectId
                                                               AND Movement.OperDate BETWEEN OH_JuridicalDetails_To.StartDate AND OH_JuridicalDetails_To.EndDate


       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_ReturnIn();




END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_ReturnIn_Print (Integer,TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 06.02.14                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_ReturnIn_Print (inMovementId := 35198, inSession:= '2')
-- SELECT * FROM gpSelect_Movement_ReturnIn_Print (inMovementId := 35173, inSession:= '2')