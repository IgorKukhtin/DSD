-- Function: gpSelect_Movement_Tax()

DROP FUNCTION IF EXISTS gpSelect_Movement_Tax_Load (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Tax_Load (TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Tax_Load (TDateTime, TDateTime, TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Tax_Load(
    IN inStartDate            TDateTime , --
    IN inEndDate              TDateTime , --
    IN inStartDateReg         TDateTime , --
    IN inEndDateReg           TDateTime , --
    IN inInfoMoneyId          Integer   ,
    IN inPaidKindId           Integer   ,
    IN inIsTaxCorrectiveOnly  Boolean   ,
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS TABLE (NPP TVarChar,  NUM TVarChar,   DATEV TDateTime, NAZP TVarChar, IPN TVarChar, 
               ZAGSUM TFloat, BAZOP20 TFloat, SUMPDV TFloat,   BAZOP0 TFloat, ZVILN TFloat,
               EXPORT TFloat, PZOB TFloat,    NREZ TFloat,     KOR TFloat,    WMDTYPE TFloat, 
               WMDTYPESTR TVarChar
             , DKOR TDateTime, D1_NUM TVarChar
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Tax());
     vbUserId:= inSession;

     --
     RETURN QUERY
     SELECT
             (row_number() OVER ())::TVarChar
           , (MovementString_InvNumberPartner.ValueData || CASE WHEN MovementString_InvNumberBranch.ValueData <> '' THEN '/' || MovementString_InvNumberBranch.ValueData ELSE '' END) :: TVarChar  AS InvNumber
           , Movement.OperDate				AS OperDate
           , ObjectHistoryString_JuridicalDetails_FullName.ValueData   AS ToName
           , ObjectHistoryString_JuridicalDetails_INN.ValueData        AS INN
           , CASE Movement.DescId 
                  WHEN zc_Movement_Tax() THEN MovementFloat_TotalSummPVAT.ValueData      
                  ELSE - MovementFloat_TotalSummPVAT.ValueData
             END :: TFloat                              AS TotalSummPVAT
           , CASE Movement.DescId 
                  WHEN zc_Movement_Tax() THEN MovementFloat_TotalSummMVAT.ValueData      
                  ELSE - MovementFloat_TotalSummMVAT.ValueData
             END :: TFloat                              AS TotalSummMVAT
           , CASE Movement.DescId 
                  WHEN zc_Movement_Tax() THEN (MovementFloat_TotalSummPVAT.ValueData - MovementFloat_TotalSummMVAT.ValueData)
                  ELSE - (MovementFloat_TotalSummPVAT.ValueData - MovementFloat_TotalSummMVAT.ValueData)
             END :: TFloat                              AS SUMPDV
           , 0::TFloat AS BAZOP0
           , 0::TFloat AS ZVILN
           , 0::TFloat AS EXPORT
           , 0::TFloat AS PZOB
           , 0::TFloat AS NREZ
           , 0::TFloat AS KOR
           , NULL::TFloat AS WMDTYPE
           , CASE WHEN Movement.DescId = zc_Movement_Tax() AND MovementBoolean_Electron.ValueData = TRUE
                       THEN '���'
                  WHEN Movement.DescId = zc_Movement_Tax()
                       THEN '���'
                  WHEN Movement.DescId = zc_Movement_TaxCorrective() AND MovementBoolean_Electron.ValueData = TRUE
                       THEN '���'
                  WHEN Movement.DescId = zc_Movement_TaxCorrective()
                       THEN '���'
                  ELSE ''
             END ::TVarChar AS WMDTYPESTR

           , Movement_DocumentChild.OperDate AS DKOR
           , (MS_InvNumberPartner_DocumentChild.ValueData || CASE WHEN MS_InvNumberBranch_DocumentChild.ValueData <> '' THEN '/' || MS_InvNumberBranch_DocumentChild.ValueData ELSE '' END) :: TVarChar AS D1_NUM

       FROM Movement
            INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                          ON MovementLinkObject_Contract.MovementId = Movement.Id
                                         AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            INNER JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
                                                                                AND (View_Contract_InvNumber.InfoMoneyId NOT IN (zc_Enum_InfoMoney_30201()) -- ������ �����
                                                                                  OR inInfoMoneyId <> 0
                                                                                    )
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                           ON MovementLinkMovement_Child.MovementId = Movement.Id
                                          AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()
                                          AND Movement.DescId = zc_Movement_TaxCorrective()
            LEFT JOIN Movement AS Movement_DocumentChild ON Movement_DocumentChild.Id = MovementLinkMovement_Child.MovementChildId
            LEFT JOIN MovementString AS MS_InvNumberPartner_DocumentChild ON MS_InvNumberPartner_DocumentChild.MovementId = Movement_DocumentChild.Id
                                                                         AND MS_InvNumberPartner_DocumentChild.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN MovementString AS MS_InvNumberBranch_DocumentChild
                                     ON MS_InvNumberBranch_DocumentChild.MovementId =  Movement_DocumentChild.Id
                                    AND MS_InvNumberBranch_DocumentChild.DescId = zc_MovementString_InvNumberBranch()


            LEFT JOIN MovementString AS MovementString_InvNumberBranch
                                     ON MovementString_InvNumberBranch.MovementId =  Movement.Id
                                    AND MovementString_InvNumberBranch.DescId = zc_MovementString_InvNumberBranch()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = CASE WHEN Movement.DescId = zc_Movement_Tax() THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END

            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementBoolean AS MovementBoolean_Electron
                                      ON MovementBoolean_Electron.MovementId =  Movement.Id
                                     AND MovementBoolean_Electron.DescId = zc_MovementBoolean_Electron()

            LEFT JOIN MovementDate AS MovementDate_DateRegistered
                                   ON MovementDate_DateRegistered.MovementId =  Movement.Id
                                  AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()
            LEFT JOIN MovementString AS MovementString_InvNumberRegistered
                                     ON MovementString_InvNumberRegistered.MovementId = Movement.Id
                                    AND MovementString_InvNumberRegistered.DescId = zc_MovementString_InvNumberRegistered()

            LEFT JOIN ObjectHistory AS ObjectHistory_JuridicalDetails 
                   ON ObjectHistory_JuridicalDetails.ObjectId = MovementLinkObject_To.ObjectId
                  AND ObjectHistory_JuridicalDetails.DescId = zc_ObjectHistory_JuridicalDetails()
                  AND Movement.OperDate >= ObjectHistory_JuridicalDetails.StartDate AND Movement.OperDate < ObjectHistory_JuridicalDetails.EndDate  
            LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_FullName
                   ON ObjectHistoryString_JuridicalDetails_FullName.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                  AND ObjectHistoryString_JuridicalDetails_FullName.DescId = zc_ObjectHistoryString_JuridicalDetails_FullName()
            LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_INN
                   ON ObjectHistoryString_JuridicalDetails_INN.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                  AND ObjectHistoryString_JuridicalDetails_INN.DescId = zc_ObjectHistoryString_JuridicalDetails_INN()
            /*LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                                                                           THEN zc_MovementLinkObject_PaidKind()
                                                                                      WHEN Movement.DescId IN (zc_Movement_TransferDebtOut())
                                                                                           THEN zc_MovementLinkObject_PaidKindTo()
                                                                                      WHEN Movement.DescId IN (zc_Movement_TransferDebtIn())
                                                                                           THEN zc_MovementLinkObject_PaidKindFrom()
                                                                                  END*/

      WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate 
        AND ((MovementDate_DateRegistered.ValueData BETWEEN inStartDateReg AND inEndDateReg AND MovementString_InvNumberRegistered.ValueData <> '')
          OR Movement.DescId = zc_Movement_Tax()
          OR inStartDateReg > inEndDateReg
            )
        AND ((Movement.DescId = zc_Movement_Tax() AND inIsTaxCorrectiveOnly = FALSE)
           OR Movement.DescId = zc_Movement_TaxCorrective()
            )
        AND Movement.StatusId = zc_Enum_Status_Complete()
        AND (View_Contract_InvNumber.InfoMoneyId = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)
        -- AND (MovementLinkObject_PaidKind.ObjectId = inPaidKindId OR COALESCE (inPaidKindId, 0) = 0)
        AND MovementFloat_TotalSummPVAT.ValueData <> 0
        AND COALESCE (MovementString_InvNumberBranch.ValueData, '') <> '2'
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Tax_Load (TDateTime, TDateTime, TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.08.14                                        * add MovementBoolean_Electron
 27.06.14                         * add inInfoMoneyId, inPaidKindId
 19.05.14                                        * add BAZOP0
 16.05.14                                        * all
 18.04.14                         *
 27.02.14                         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_Tax_Load (inStartDate:= '01.06.2016', inEndDate:= '01.06.2016', inStartDateReg:= '16.03.2015', inEndDateReg:= '16.03.2015', inInfoMoneyId:= zc_Enum_InfoMoney_30101(), inPaidKindId:= zc_Enum_PaidKind_FirstForm(), inIsTaxCorrectiveOnly:= TRUE, inSession:= zfCalc_UserAdmin())
