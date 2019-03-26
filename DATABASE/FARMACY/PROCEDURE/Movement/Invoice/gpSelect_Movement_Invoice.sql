-- Function: gpSelect_Movement_Invoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_Invoice (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Invoice(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id                  Integer
             , InvNumber           TVarChar
             , InvNumber_int       Integer
             , OperDate            TDateTime
             , StatusCode          Integer
             , StatusName          TVarChar
             , TotalSumm           TFloat
             , TotalSummWithOutVAT TFloat
             , TotalSummVAT        TFloat
             , TotalSumm_Contract  TFloat
             , TotalCount          TFloat
             , ChangePercent       TFloat

             , JuridicalId         Integer
             , JuridicalName       TVarChar
             , PartnerMedicalId    Integer
             , PartnerMedicalName  TVarChar
             , ContractId          Integer
             , ContractName        TVarChar
             , SigningDate         TDateTime

             , OperDateStart TDateTime
             , OperDateEnd   TDateTime

             , DateRegistered      TDateTime
             , InvNumberRegistered TVarChar

             , BankAccount TVarChar
             , BankName    TVarChar
             , PartnerMedical_BankAccount TVarChar
             , PartnerMedical_BankName    TVarChar
             , isDocument  Boolean
             , SPName      TVarChar

             , DepartmentId    Integer
             , DepartmentName  TVarChar
             , ContractName_Department         TVarChar
             , Contract_SigningDate_Department TDateTime
             , Contract_StartDate_Department   TDateTime
             , Contract_EndDate_Department     TDateTime

             , OKPO_Juridical      TVarChar
             , OKPO_PartnerMedical TVarChar
             , OKPO_Department     TVarChar
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbContractId Integer;   
BEGIN

     vbUserId:= lpGetUserBySession (inSession);
     -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);


     -- Ограничение - если роль Кассир аптеки
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = 308121 AND UserId = vbUserId)
     THEN
         vbContractId:= zfConvert_StringToNumber (lpGet_DefaultValue ('zc_Object_Contract', vbUserId));
     ELSE
         vbContractId:= 0;
     END IF;


     -- Результат
     RETURN QUERY
        WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                     UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                     UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

      , tmpBankAccount AS (SELECT ObjectLink_Juridical.ChildObjectId AS JuridicalId
                                , Object_BankAccount.ValueData       AS BankAccount
                                , Object_Bank.ValueData              AS BankName
                           FROM Object AS Object_BankAccount
                              LEFT JOIN ObjectLink AS ObjectLink_Juridical
                                                   ON ObjectLink_Juridical.ObjectId = Object_BankAccount.Id
                                                  AND ObjectLink_Juridical.DescId = zc_ObjectLink_BankAccount_Juridical()
                              LEFT JOIN ObjectLink AS ObjectLink_Bank
                                                   ON ObjectLink_Bank.ObjectId = Object_BankAccount.Id
                                                  AND ObjectLink_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
                              LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_Bank.ChildObjectId
                           WHERE Object_BankAccount.DescId = zc_object_BankAccount()
                           )
      -- договора для департаментов
     , tmpContractDepartment AS (SELECT  ObjectLink_Contract_JuridicalBasis.ChildObjectId AS JuridicalId
                                       , tmp.DepartmentId                                 AS DepartmentId
                                       , Object_Department.ValueData                      AS DepartmentName
                                       , COALESCE(Object_Department_Contract.Id,0)        AS ContractId
                                       , Object_Department_Contract.ValueData             AS ContractName
                                       , ObjectDate_Signing.ValueData                     AS Contract_SigningDate
                                       , ObjectDate_Start.ValueData                       AS Contract_StartDate 
                                       , ObjectDate_End.ValueData                         AS Contract_EndDate 

                                 FROM (SELECT DISTINCT ObjectLink.ChildObjectId AS DepartmentId
                                       FROM ObjectLink
                                       WHERE ObjectLink.DescId = zc_ObjectLink_PartnerMedical_Department()
                                      ) AS tmp
                                    LEFT JOIN Object AS Object_Department ON Object_Department.Id =  tmp.DepartmentId
                                    LEFT JOIN ObjectLink AS ObjectLink_Contract_Department
                                                         ON ObjectLink_Contract_Department.ChildObjectId = tmp.DepartmentId
                                                        AND ObjectLink_Contract_Department.DescId = zc_ObjectLink_Contract_Juridical()
                                    LEFT JOIN Object AS Object_Department_Contract ON Object_Department_Contract.Id = ObjectLink_Contract_Department.ObjectId

                                    INNER JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                                                          ON ObjectLink_Contract_JuridicalBasis.ObjectId = Object_Department_Contract.Id 
                                                         AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()

                                    LEFT JOIN ObjectDate AS ObjectDate_Start
                                                         ON ObjectDate_Start.ObjectId = Object_Department_Contract.Id
                                                        AND ObjectDate_Start.DescId = zc_ObjectDate_Contract_Start()
                                    LEFT JOIN ObjectDate AS ObjectDate_End
                                                         ON ObjectDate_End.ObjectId = Object_Department_Contract.Id
                                                        AND ObjectDate_End.DescId = zc_ObjectDate_Contract_End()
                                    LEFT JOIN ObjectDate AS ObjectDate_Signing
                                                         ON ObjectDate_Signing.ObjectId = Object_Department_Contract.Id
                                                        AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
                                 )
     , tmpMovement AS (SELECT Movement.*
                       FROM tmpStatus
                            INNER JOIN Movement ON Movement.StatusId = tmpStatus.StatusId
                                               AND Movement.DescId = zc_Movement_Invoice()
                                               AND Movement.OperDate >= inStartDate AND Movement.OperDate <inEndDate + interval '1 day'
                       )
     , tmpMovementFloat AS (SELECT MovementFloat.*
                            FROM MovementFloat
                            WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                              AND MovementFloat.DescId IN ( zc_MovementFloat_TotalSumm()
                                                          , zc_MovementFloat_TotalCount()
                                                          , zc_MovementFloat_ChangePercent()
                                                          , zc_MovementFloat_SP() )
                            )

     , tmpMovementDate AS (SELECT MovementDate.*
                           FROM MovementDate
                           WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                             AND MovementDate.DescId IN ( zc_MovementDate_OperDateStart()
                                                        , zc_MovementDate_OperDateEnd()
                                                        , zc_MovementDate_DateRegistered()
                                                         )
                           )

     , tmpMovementString AS (SELECT MovementString.*
                             FROM MovementString
                             WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                               AND MovementString.DescId = zc_MovementString_InvNumberRegistered()
                           )

   
     , tmpMovementBoolean AS (SELECT MovementBoolean.*
                              FROM MovementBoolean
                              WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                AND MovementBoolean.DescId = zc_MovementBoolean_Document()
                             )    

     , tmpMLO AS (SELECT MovementLinkObject.*
                  FROM MovementLinkObject
                  WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                    AND MovementLinkObject.DescId IN ( zc_MovementLinkObject_Juridical()
                                                     , zc_MovementLinkObject_PartnerMedical()
                                                     , zc_MovementLinkObject_Contract()
                                                      )
                  )

        -- Результат
    SELECT     
        Movement.Id
      , Movement.InvNumber
      , CASE WHEN COALESCE (Movement.InvNumber, '') <> ''
             THEN COALESCE (CAST (LEFT (Movement.InvNumber, CASE WHEN POSITION ('/' in Movement.InvNumber) = 0 THEN length (Movement.InvNumber) ELSE POSITION ('/' in Movement.InvNumber) -1 END ) AS NUMERIC (16,0)),0) 
             ELSE 0
        END :: integer  AS InvNumber_int
      , Movement.OperDate
      , Object_Status.ObjectCode                               AS StatusCode
      , Object_Status.ValueData                                AS StatusName
      , COALESCE (MovementFloat_TotalSumm.ValueData,0)::TFloat AS TotalSumm
      , COALESCE (CAST (MovementFloat_TotalSumm.ValueData/(1.07) AS NUMERIC (16,2)),0) ::TFloat  AS TotalSummWithOutVAT
      , COALESCE (CAST (MovementFloat_TotalSumm.ValueData - (MovementFloat_TotalSumm.ValueData/(1.07))  AS NUMERIC (16,2)),0) ::TFloat  AS TotalSummVAT
      , COALESCE (ObjectFloat_TotalSumm.ValueData, 0)       :: TFloat AS TotalSumm_Contract
      , COALESCE (MovementFloat_TotalCount.ValueData,0)     :: TFloat AS TotalCount
      , COALESCE (MovementFloat_ChangePercent.ValueData, 0) :: TFloat AS ChangePercent

      , MovementLinkObject_Juridical.ObjectId                  AS JuridicalId
      , Object_Juridical.ValueData                             AS JuridicalName
      , Object_PartnerMedical.Id                               AS PartnerMedicalId  
      , Object_PartnerMedical.ValueData                        AS PartnerMedicalName 
      , MovementLinkObject_Contract.ObjectId                   AS ContractId
      , Object_Contract.ValueData                              AS ContractName
      , COALESCE (ObjectDate_Signing.ValueData, Null) :: TDateTime AS SigningDate
      , MovementDate_OperDateStart.ValueData                   AS OperDateStart
      , MovementDate_OperDateEnd.ValueData                     AS OperDateEnd
      

      , MovementDate_DateRegistered.ValueData                  AS DateRegistered
      , MovementString_InvNumberRegistered.ValueData           AS InvNumberRegistered

      , ObjectHistory_JuridicalDetails.BankAccount
      , tmpBankAccount.BankName ::TVarChar

      , ObjectHistory_PartnerMedicalDetails.BankAccount       AS PartnerMedical_BankAccount
      , tmpPartnerMedicalBankAccount.BankName                 AS PartnerMedical_BankName

      , COALESCE(MovementBoolean_Document.ValueData, False) :: Boolean  AS isDocument

      , CASE WHEN COALESCE(MovementFloat_SP.ValueData,0) = 1 THEN 'Cоц.проект' 
             WHEN COALESCE(MovementFloat_SP.ValueData,0) = 2 THEN 'Приказ 1303' 
             ELSE ''
        END  :: TVarChar AS SPName

      , Object_Department.Id                       AS DepartmentId
      , Object_Department.ValueData                AS DepartmentName
      , tmpContractDepartment.ContractName         AS ContractName_Department
      , tmpContractDepartment.Contract_SigningDate AS Contract_SigningDate_Department
      , tmpContractDepartment.Contract_StartDate   AS Contract_StartDate_Department
      , tmpContractDepartment.Contract_EndDate     AS Contract_EndDate_Department
      
      , ObjectHistory_JuridicalDetails.OKPO      AS OKPO_Juridical
      , ObjectHistory_PartnerMedicalDetails.OKPO AS OKPO_PartnerMedical
      , ObjectHistory_DepartmentDetails.OKPO     AS OKPO_Department

    FROM tmpMovement AS Movement
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
        
        LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSumm
                                   ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                  AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

        LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCount
                                   ON MovementFloat_TotalCount.MovementId = Movement.Id
                                  AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

        LEFT JOIN tmpMovementFloat AS MovementFloat_ChangePercent
                                   ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                  AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

        LEFT JOIN tmpMovementFloat AS MovementFloat_SP
                                   ON MovementFloat_SP.MovementId = Movement.Id
                                  AND MovementFloat_SP.DescId = zc_MovementFloat_SP()

        LEFT JOIN tmpMovementDate AS MovementDate_OperDateStart
                                  ON MovementDate_OperDateStart.MovementId = Movement.Id
                                 AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
        LEFT JOIN tmpMovementDate AS MovementDate_OperDateEnd
                               ON MovementDate_OperDateEnd.MovementId = Movement.Id
                              AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

        LEFT JOIN tmpMovementDate AS MovementDate_DateRegistered
                                  ON MovementDate_DateRegistered.MovementId = Movement.Id
                                 AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()

        LEFT JOIN tmpMovementString AS MovementString_InvNumberRegistered
                                    ON MovementString_InvNumberRegistered.MovementId = Movement.Id
                                   AND MovementString_InvNumberRegistered.DescId = zc_MovementString_InvNumberRegistered()

        LEFT JOIN tmpMovementBoolean AS MovementBoolean_Document
                                     ON MovementBoolean_Document.MovementId = Movement.Id
                                    AND MovementBoolean_Document.DescId = zc_MovementBoolean_Document()

        LEFT JOIN tmpMLO AS MovementLinkObject_Juridical
                         ON MovementLinkObject_Juridical.MovementId = Movement.Id
                        AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId
        
        LEFT JOIN tmpMLO AS MovementLinkObject_PartnerMedical
                         ON MovementLinkObject_PartnerMedical.MovementId = Movement.Id
                        AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
        LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = MovementLinkObject_PartnerMedical.ObjectId

        LEFT JOIN tmpMLO AS MovementLinkObject_Contract
                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
        LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId
        -- дата подписания договора
        LEFT JOIN ObjectDate AS ObjectDate_Signing
                             ON ObjectDate_Signing.ObjectId = Object_Contract.Id
                            AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
        -- сумма осн. договора
        LEFT JOIN ObjectFloat AS ObjectFloat_TotalSumm
                              ON ObjectFloat_TotalSumm.ObjectId = Object_Contract.Id
                             AND ObjectFloat_TotalSumm.DescId = zc_ObjectFloat_Contract_TotalSumm()

        LEFT JOIN ObjectLink AS ObjectLink_PartnerMedical_Juridical 
                             ON ObjectLink_PartnerMedical_Juridical.ObjectId = Object_PartnerMedical.Id
                            AND ObjectLink_PartnerMedical_Juridical.DescId = zc_ObjectLink_PartnerMedical_Juridical()

        LEFT JOIN gpSelect_ObjectHistory_JuridicalDetails(injuridicalid := Object_Juridical.Id, inFullName := '', inOKPO := '', inSession := inSession) AS ObjectHistory_JuridicalDetails ON 1=1
        LEFT JOIN gpSelect_ObjectHistory_JuridicalDetails(injuridicalid := ObjectLink_PartnerMedical_Juridical.ChildObjectId , inFullName := '', inOKPO := '', inSession := inSession) AS ObjectHistory_PartnerMedicalDetails ON 1=1
 
        LEFT JOIN tmpBankAccount ON tmpBankAccount.JuridicalId = Object_Juridical.Id
                                AND tmpBankAccount.BankAccount = ObjectHistory_JuridicalDetails.BankAccount

        LEFT JOIN tmpBankAccount AS tmpPartnerMedicalBankAccount 
                                 ON tmpPartnerMedicalBankAccount.JuridicalId = ObjectLink_PartnerMedical_Juridical.ChildObjectId  --ObjectLink_PartnerMedical_Juridical.ChildObjectId
                                AND tmpPartnerMedicalBankAccount.BankAccount = ObjectHistory_PartnerMedicalDetails.BankAccount
        
        LEFT JOIN ObjectLink AS ObjectLink_PartnerMedical_Department 
                             ON ObjectLink_PartnerMedical_Department.ObjectId = MovementLinkObject_PartnerMedical.ObjectId
                            AND ObjectLink_PartnerMedical_Department.DescId = zc_ObjectLink_PartnerMedical_Department()
        LEFT JOIN Object AS Object_Department ON Object_Department.Id = ObjectLink_PartnerMedical_Department.ChildObjectId
        LEFT JOIN tmpContractDepartment ON tmpContractDepartment.DepartmentId = ObjectLink_PartnerMedical_Department.ChildObjectId
                                       AND tmpContractDepartment.JuridicalId  = MovementLinkObject_Juridical.ObjectId
                                       AND tmpContractDepartment.Contract_StartDate <= MovementDate_OperDateStart.ValueData
                                       AND tmpContractDepartment.Contract_EndDate >= MovementDate_OperDateStart.ValueData

        LEFT JOIN gpSelect_ObjectHistory_JuridicalDetails(injuridicalid := ObjectLink_PartnerMedical_Department.ChildObjectId, inFullName := '', inOKPO := '', inSession := inSession) AS ObjectHistory_DepartmentDetails ON 1=1
 ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_Invoice (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.02.19         * add ChangePercent
 14.02.19         * add TotalCount
 20.08.18         *
 14.05.18         *
 15.08.17         * add InvNumber_int
 13.05.17         * add SPName
 21.04.17         *
 22.03.17         *
*/

-- тест
--SELECT * FROM gpSelect_Movement_Invoice (inStartDate:= '01.08.2016', inEndDate:= '01.08.2016', inIsErased := FALSE, inSession:= zfCalc_UserAdmin());