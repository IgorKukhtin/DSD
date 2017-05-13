-- Function: gpSelect_Movement_Invoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_Invoice (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Invoice(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , StatusCode Integer
             , StatusName TVarChar
             , TotalSumm TFloat
             , TotalSummWithOutVAT TFloat
             , TotalSummVAT TFloat

             , JuridicalId Integer
             , JuridicalName TVarChar
             , PartnerMedicalId Integer
             , PartnerMedicalName TVarChar
             , ContractId Integer
             , ContractName TVarChar

             , OperDateStart TDateTime
             , OperDateEnd TDateTime

             , DateRegistered TDateTime
             , InvNumberRegistered TVarChar

             , BankAccount TVarChar
             , BankName    TVarChar
             , PartnerMedical_BankAccount TVarChar
             , PartnerMedical_BankName    TVarChar
             , isDocument  Boolean
             , SPName TVarChar

              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbContractId Integer;   
BEGIN

     vbUserId:= lpGetUserBySession (inSession);
     -- ������������ <�������� ����>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);


     -- ����������� - ���� ���� ������ ������
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = 308121 AND UserId = vbUserId)
     THEN
         vbContractId:= zfConvert_StringToNumber (lpGet_DefaultValue ('zc_Object_Contract', vbUserId));
     ELSE
         vbContractId:= 0;
     END IF;


     -- ���������
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

        -- ���������
    SELECT     
        Movement.Id
      , Movement.InvNumber
      , Movement.OperDate
      , Object_Status.ObjectCode                               AS StatusCode
      , Object_Status.ValueData                                AS StatusName
      , COALESCE (MovementFloat_TotalSumm.ValueData,0)::TFloat  AS TotalSumm
      , COALESCE (CAST (MovementFloat_TotalSumm.ValueData/(1.07) AS NUMERIC (16,2)),0) ::TFloat  AS TotalSummWithOutVAT
      , COALESCE (CAST (MovementFloat_TotalSumm.ValueData - (MovementFloat_TotalSumm.ValueData/(1.07))  AS NUMERIC (16,2)),0) ::TFloat  AS TotalSummVAT

      , MovementLinkObject_Juridical.ObjectId                  AS JuridicalId
      , Object_Juridical.ValueData                             AS JuridicalName
      , Object_PartnerMedical.Id                               AS PartnerMedicalId  
      , Object_PartnerMedical.ValueData                        AS PartnerMedicalName 
      , MovementLinkObject_Contract.ObjectId                   AS ContractId
      , Object_Contract.ValueData                              AS ContractName
      , MovementDate_OperDateStart.ValueData                   AS OperDateStart
      , MovementDate_OperDateEnd.ValueData                     AS OperDateStart

      , MovementDate_DateRegistered.ValueData                  AS DateRegistered
      , MovementString_InvNumberRegistered.ValueData           AS InvNumberRegistered

      , ObjectHistory_JuridicalDetails.BankAccount
      , tmpBankAccount.BankName ::TVarChar

      , ObjectHistory_PartnerMedicalDetails.BankAccount       AS PartnerMedical_BankAccount
      , tmpPartnerMedicalBankAccount.BankName                 AS PartnerMedical_BankName

      , COALESCE(MovementBoolean_Document.ValueData, False) :: Boolean  AS isDocument

      , CASE WHEN COALESCE(MovementFloat_SP.ValueData,0) = 1 THEN 'C��.������' 
             WHEN COALESCE(MovementFloat_SP.ValueData,0) = 2 THEN '������ 1303' 
             ELSE ''
        END  :: TVarChar AS SPName
    FROM tmpStatus
        INNER JOIN Movement ON Movement.StatusId = tmpStatus.StatusId
                           AND Movement.DescId = zc_Movement_Invoice()
                           AND Movement.OperDate >= inStartDate AND Movement.OperDate <inEndDate + interval '1 day'
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
        
        LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                ON MovementFloat_TotalSumm.MovementId = Movement.Id
                               AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

        LEFT JOIN MovementDate AS MovementDate_OperDateStart
                               ON MovementDate_OperDateStart.MovementId = Movement.Id
                              AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
        LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                               ON MovementDate_OperDateEnd.MovementId = Movement.Id
                              AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

        LEFT JOIN MovementDate AS MovementDate_DateRegistered
                               ON MovementDate_DateRegistered.MovementId = Movement.Id
                              AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()

        LEFT JOIN MovementString AS MovementString_InvNumberRegistered
                                 ON MovementString_InvNumberRegistered.MovementId = Movement.Id
                                AND MovementString_InvNumberRegistered.DescId = zc_MovementString_InvNumberRegistered()

        LEFT JOIN MovementBoolean AS MovementBoolean_Document
                                  ON MovementBoolean_Document.MovementId = Movement.Id
                                 AND MovementBoolean_Document.DescId = zc_MovementBoolean_Document()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                     ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                    AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId
        
        LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                     ON MovementLinkObject_PartnerMedical.MovementId = Movement.Id
                                    AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
        LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = MovementLinkObject_PartnerMedical.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                     ON MovementLinkObject_Contract.MovementId = Movement.Id
                                    AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
        LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

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
        
        LEFT JOIN MovementFloat AS MovementFloat_SP
                                ON MovementFloat_SP.MovementId = Movement.Id
                               AND MovementFloat_SP.DescId = zc_MovementFloat_SP()


;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_Invoice (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 13.05.17         * add SPName
 21.04.17         *
 22.03.17         *
*/

-- ����
--SELECT * FROM gpSelect_Movement_Invoice (inStartDate:= '01.08.2016', inEndDate:= '01.08.2016', inIsErased := FALSE, inSession:= zfCalc_UserAdmin());