-- Function: gpSelect_Movement_Tax()

DROP FUNCTION IF EXISTS gpSelect_Movement_Tax_Load (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Tax_Load (TDateTime, TDateTime, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpSelect_Movement_Tax_Load (TDateTime, TDateTime, TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Tax_Load (TDateTime, TDateTime, TDateTime, TDateTime, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Tax_Load(
    IN inStartDate            TDateTime , --
    IN inEndDate              TDateTime , --
    IN inStartDateReg         TDateTime , --
    IN inEndDateReg           TDateTime , --
    IN inInfoMoneyId          Integer   ,
    IN inPaidKindId           Integer   ,
    IN inIsTaxCorrectiveOnly  Boolean   ,
    IN inIsRegisterOnly       Boolean   , -- только зарегистрированные
    IN inIsNotRegisterOnly    Boolean   , -- только не зарегистрированные
    IN inSession              TVarChar    -- сессия пользователя
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
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Tax());
     vbUserId:= lpGetUserBySession (inSession);

     --проверка если обе галки inIsRegisterOnly и inIsNotRegisterOnly = TRUE  - ошибка
     IF inIsRegisterOnly = TRUE AND inIsNotRegisterOnly = TRUE
     THEN
         RAISE EXCEPTION 'Ошибка. Признаки Только зарегистрированные и Только не зарегистрированные не могут быть выбранны одновременно.';
     END IF;
     IF inIsRegisterOnly = TRUE OR inIsNotRegisterOnly = TRUE
     THEN
         RAISE EXCEPTION 'Ошибка. Признаки Только зарегистрированные и Только не зарегистрированные не могут быть выбранны.%Выгружаются все Налоговые + Зарегистрированые корректировки или только Зарегистрированые корректировки или Все.', CHR (13);
     END IF;
     
     --
     RETURN QUERY
     WITH 
     tmpContract AS (SELECT Object_Contract.Id                            AS ContractId
                          , ObjectLink_Contract_InfoMoney.ChildObjectId   AS InfoMoneyId
                     FROM Object AS Object_Contract
                          LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                               ON ObjectLink_Contract_InfoMoney.ObjectId = Object_Contract.Id
                                              AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                     WHERE Object_Contract.DescId = zc_Object_Contract()
                     )
                     
   , tmpMovement AS (SELECT Movement.*
                     FROM Movement
                          INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                        ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                       AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                          INNER JOIN tmpContract ON tmpContract.ContractId = MovementLinkObject_Contract.ObjectId
                                                AND (tmpContract.InfoMoneyId NOT IN (zc_Enum_InfoMoney_30201()) -- Мясное сырье
                                                  OR inInfoMoneyId <> 0
                                                    )
                     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate 
                       AND ((Movement.DescId = zc_Movement_Tax() AND inIsTaxCorrectiveOnly = FALSE)
                          OR Movement.DescId = zc_Movement_TaxCorrective()
                          )
                       AND Movement.StatusId = zc_Enum_Status_Complete()
                       AND (tmpContract.InfoMoneyId = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)
                     )
   , tmpMLMovement_Child AS (SELECT MovementLinkMovement_Child.MovementId
                                  , Movement_DocumentChild.OperDate AS DKOR
                                  , (MS_InvNumberPartner_DocumentChild.ValueData || CASE WHEN MS_InvNumberBranch_DocumentChild.ValueData <> '' THEN '/' || MS_InvNumberBranch_DocumentChild.ValueData ELSE '' END) AS D1_NUM
                             FROM MovementLinkMovement AS MovementLinkMovement_Child
                                  LEFT JOIN Movement AS Movement_DocumentChild ON Movement_DocumentChild.Id = MovementLinkMovement_Child.MovementChildId
                                  LEFT JOIN MovementString AS MS_InvNumberPartner_DocumentChild ON MS_InvNumberPartner_DocumentChild.MovementId = Movement_DocumentChild.Id
                                                                                               AND MS_InvNumberPartner_DocumentChild.DescId = zc_MovementString_InvNumberPartner()
                                  LEFT JOIN MovementString AS MS_InvNumberBranch_DocumentChild
                                                           ON MS_InvNumberBranch_DocumentChild.MovementId =  Movement_DocumentChild.Id
                                                          AND MS_InvNumberBranch_DocumentChild.DescId = zc_MovementString_InvNumberBranch()
                             WHERE MovementLinkMovement_Child.MovementId IN (SELECT tmpMovement.Id FROM tmpMovement WHERE tmpMovement.DescId = zc_Movement_TaxCorrective())
                               AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()
                            )
  
                     
     SELECT
             (row_number() OVER ())::TVarChar
           , (MovementString_InvNumberPartner.ValueData || CASE WHEN MovementString_InvNumberBranch.ValueData <> '' THEN '/' || MovementString_InvNumberBranch.ValueData ELSE '' END) :: TVarChar  AS InvNumber
           , Movement.OperDate				AS OperDate
           , ObjectHistoryString_JuridicalDetails_FullName.ValueData   AS ToName
           , CASE WHEN Movement.Id IN (-- Tax
                                       6922620
                                     , 6922564
                                     , 6922609
                                     , 6922233
                                     , 6921599
                                     , 6922367
                                     , 6922254
                                     , 6922275
                                     , 8484674
                                     , 8486085
                                     , 8486839
                                     , 8487001
                                     , 8487359
                                       -- Corr
                                     , 7943509
                                     , 8066170
                                     , 8066171
                                     , 8066169
                                     , 8464974
                                     , 8465476
                                     , 8465802
                                     , 8479936
                                     , 8462887
                                     , 8462999
                                     , 8463007
                                     , 8488900
                                     , 8464619
                                      )
                  THEN '100000000000'
                  ELSE COALESCE (MovementString_INN.ValueData, ObjectHistoryString_JuridicalDetails_INN.ValueData)
                                      
             END :: TVarChar AS INN
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
           , CASE WHEN Movement.DescId = zc_Movement_TaxCorrective()
                       THEN 5
                  ELSE 0
             END ::TFloat AS PZOB
           , 0::TFloat AS NREZ
           , CASE WHEN Movement.DescId = zc_Movement_TaxCorrective()
                       THEN 1
                  ELSE 0
             END :: TFloat AS KOR
           , NULL::TFloat AS WMDTYPE
           , CASE WHEN Movement.DescId = zc_Movement_Tax() AND MovementBoolean_Electron.ValueData = TRUE
                       THEN 'ПНЕ'
                  WHEN Movement.DescId = zc_Movement_Tax()
                       THEN 'ПНЕ' -- 'ПНП'
                  WHEN Movement.DescId = zc_Movement_TaxCorrective() AND MovementBoolean_Electron.ValueData = TRUE
                       THEN 'РКЕ'
                  WHEN Movement.DescId = zc_Movement_TaxCorrective()
                       THEN 'РКЕ' -- 'РКП'
                  ELSE ''
             END ::TVarChar AS WMDTYPESTR

           , tmpMLMovement_Child.DKOR               AS DKOR
           , tmpMLMovement_Child.D1_NUM :: TVarChar AS D1_NUM

       FROM tmpMovement AS Movement
            
            LEFT JOIN tmpMLMovement_Child ON tmpMLMovement_Child.MovementId = Movement.Id

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

            LEFT JOIN MovementString AS MovementString_InvNumberBranch
                                     ON MovementString_InvNumberBranch.MovementId = Movement.Id
                                    AND MovementString_InvNumberBranch.DescId = zc_MovementString_InvNumberBranch()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementString AS MovementString_INN
                                     ON MovementString_INN.MovementId = Movement.Id
                                    AND MovementString_INN.DescId = CASE WHEN Movement.DescId = zc_Movement_Tax() THEN zc_MovementString_ToINN() ELSE zc_MovementString_FromINN() END
                                    AND MovementString_INN.ValueData  <> ''

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
                                   AND COALESCE (tmpMLMovement_Child.DKOR, Movement.OperDate) >= ObjectHistory_JuridicalDetails.StartDate AND COALESCE (tmpMLMovement_Child.DKOR, Movement.OperDate) < ObjectHistory_JuridicalDetails.EndDate  
            LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_FullName
                                          ON ObjectHistoryString_JuridicalDetails_FullName.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                         AND ObjectHistoryString_JuridicalDetails_FullName.DescId = zc_ObjectHistoryString_JuridicalDetails_FullName()
            LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_INN
                                         ON ObjectHistoryString_JuridicalDetails_INN.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                        AND ObjectHistoryString_JuridicalDetails_INN.DescId = zc_ObjectHistoryString_JuridicalDetails_INN()

    /*WHERE ((MovementDate_DateRegistered.ValueData BETWEEN inStartDateReg AND inEndDateReg AND MovementString_InvNumberRegistered.ValueData <> '' AND inIsRegisterOnly = TRUE)
          OR (inIsRegisterOnly = FALSE AND inIsNotRegisterOnly = FALSE)
          OR (COALESCE (MovementString_InvNumberRegistered.ValueData, '') = '' AND inIsNotRegisterOnly = TRUE)
            )*/

      WHERE ((MovementDate_DateRegistered.ValueData BETWEEN inStartDateReg AND inEndDateReg AND MovementString_InvNumberRegistered.ValueData <> '')
          OR Movement.DescId = zc_Movement_Tax()
          OR inStartDateReg > inEndDateReg
            )

        AND MovementFloat_TotalSummPVAT.ValueData <> 0
        AND COALESCE (MovementString_InvNumberBranch.ValueData, '') <> '2'
      /*AND ((inIsRegisterOnly = FALSE AND inIsNotRegisterOnly = FALSE) 
          OR (MovementString_InvNumberRegistered.ValueData <> '' AND inIsRegisterOnly = TRUE)
          OR (COALESCE (MovementString_InvNumberRegistered.ValueData, '') = '' AND inIsNotRegisterOnly = TRUE)
            )*/
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 11.04.22         *
 04.03.18         *
 15.08.14                                        * add MovementBoolean_Electron
 27.06.14                         * add inInfoMoneyId, inPaidKindId
 19.05.14                                        * add BAZOP0
 16.05.14                                        * all
 18.04.14                         *
 27.02.14                         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Tax_Load (inStartDate:= '31.10.2017', inEndDate:= '31.10.2017', inStartDateReg:= '01.10.2017', inEndDateReg:= '31.10.2017', inInfoMoneyId:= zc_Enum_InfoMoney_30101(), inPaidKindId:= zc_Enum_PaidKind_FirstForm(), inIsTaxCorrectiveOnly:= TRUE, inIsRegisterOnly:= False, inIsNotRegisterOnly:= False, inSession:= zfCalc_UserAdmin())
