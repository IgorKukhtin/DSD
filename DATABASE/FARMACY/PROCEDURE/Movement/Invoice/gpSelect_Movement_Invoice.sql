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
             , TotalDiffSumm       TFloat
             , Summ_Diff           TFloat
             , TotalCount          TFloat
             , ChangePercent       TFloat

             , SummChangePercentAll TFloat
             , AmountSale          TFloat
             , isErrorSum          Boolean

             , SummCPMedical       TFloat
             , NDSKindMedicalId    Integer
             , NDSMedical          TFloat
             
             , SummCPSpecial_0     TFloat
             , NDSKindSpecial_0Id  Integer
             , NDSSpecial_0        TFloat
             
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

             , DateAdoptedByNSZU   TDateTime

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
                                    LEFT JOIN Object AS Object_Department ON Object_Department.Id = tmp.DepartmentId
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
                                                          , zc_MovementFloat_SP()
                                                          , zc_MovementFloat_TotalDiffSumm())
                            )

     , tmpMovementDate AS (SELECT MovementDate.*
                           FROM MovementDate
                           WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                             AND MovementDate.DescId IN ( zc_MovementDate_OperDateStart()
                                                        , zc_MovementDate_OperDateEnd()
                                                        , zc_MovementDate_DateRegistered()
                                                        , zc_MovementDate_AdoptedByNSZU()
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
     , tmpMovementCheck AS (SELECT Movement.Id          AS InvoiceId
                                 , MLM_Child.MovementId AS Id
                                 , MovementCheck.DescId
                       FROM tmpMovement AS Movement
                       
                            INNER JOIN MovementLinkMovement AS MLM_Child
                                                            ON MLM_Child.MovementChildId = Movement.Id
                                                           AND MLM_Child.DescId = zc_MovementLinkMovement_Child()
                                                           
                            INNER JOIN Movement AS MovementCheck
                                                ON MovementCheck.ID =  MLM_Child.MovementId 
                                     
                       )                  
     , tmpMI_Check AS (SELECT MI_Check.*
                       FROM MovementItem AS MI_Check
                       WHERE MI_Check.MovementId IN (SELECT tmpMovementCheck.Id FROM tmpMovementCheck)
                         AND MI_Check.DescId = zc_MI_Master()
                         AND MI_Check.Amount <> 0
                         AND MI_Check.isErased = FALSE
                        )
      -- информация из партий
     , tmpMIC AS (SELECT MovementItemContainer.ContainerId
                       , MovementItemContainer.MovementItemId
                       , (-MovementItemContainer.Amount)::TFloat AS Amount
                  FROM tmpMovementCheck

                       INNER JOIN MovementItemContainer ON MovementItemContainer.MovementId = tmpMovementCheck.Id
                                                       AND MovementItemContainer.DescId = zc_MIContainer_Count()
                                                       
                  )
     , tmpMIC_Info AS (SELECT tmpMIC.*
                            , COALESCE (MIFloat_MovementItem.ValueData :: Integer, Object_PartionMovementItem.ObjectCode)   AS MIIncomeId
                       FROM tmpMIC

                            LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                          ON ContainerLinkObject_MovementItem.Containerid = tmpMIC.ContainerId
                                                         AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                            LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId

                            -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                            LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                        ON MIFloat_MovementItem.MovementItemId = Object_PartionMovementItem.ObjectCode
                                                       AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                            
                         )

     , tmpMIFloat AS (SELECT *
                      FROM MovementItemFloat
                      WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Check.Id FROM tmpMI_Check) 
                      )
     , tmpOF_NDSKind_NDS AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId, ObjectFloat_NDSKind_NDS.valuedata FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                             WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                            )
                            
     , impMIncome_NDS AS (SELECT MI_Income.Id
                               , COALESCE(CASE WHEN MovementLinkObject_NDSKind.ObjectId = zc_Enum_NDSKind_Common() 
                                               THEN zc_Enum_NDSKind_Medical() 
                                               ELSE MovementLinkObject_NDSKind.ObjectId END, zc_Enum_NDSKind_Medical()) AS NDSKindId 
                          FROM MovementItem AS MI_Income 
     
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                            ON MovementLinkObject_NDSKind.MovementId = MI_Income.MovementId
                                                           AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                                                                
                          WHERE MI_Income.Id  IN (SELECT tmpMIC_Info.MIIncomeId FROM tmpMIC_Info))

    , tmpMI_CheckSum AS (SELECT Movement_Check.InvoiceId                                                                        AS InvoiceId 
                              , MI_Income.NDSKindId 
                              , ROUND(SUM (CASE WHEN Movement_Check.DescId = zc_Movement_Check() AND Movement_Check.Id = 25920626
                                                THEN COALESCE (MIFloat_SummChangePercent.ValueData, 0)
                                                ELSE COALESCE(tmpMIC_Info.Amount, MI_Check.Amount) * COALESCE (MIFloat_PriceSale.ValueData, 0) -
                                                     COALESCE(tmpMIC_Info.Amount, MI_Check.Amount) * COALESCE (MIFloat_Price.ValueData, 0) END), 2)::TFloat   AS SummChangePercent
                              , SUM(COALESCE(tmpMIC_Info.Amount, MI_Check.Amount))    AS Amount
                         FROM tmpMovementCheck AS Movement_Check
                         
                              INNER JOIN tmpMI_Check AS MI_Check ON MI_Check.MovementId = Movement_Check.Id
                              
                              LEFT JOIN tmpMIC_Info ON tmpMIC_Info.MovementItemId = MI_Check.Id
                                                        
                              --Сумма Скидки
                              LEFT JOIN tmpMIFloat AS MIFloat_SummChangePercent
                                                   ON MIFloat_SummChangePercent.MovementItemId = MI_Check.Id
                                                  AND MIFloat_SummChangePercent.DescId = zc_MIFloat_SummChangePercent()

                              LEFT JOIN tmpMIFloat AS MIFloat_PriceSale
                                                   ON MIFloat_PriceSale.MovementItemId = MI_Check.Id
                                                  AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
                              LEFT JOIN tmpMIFloat AS MIFloat_Price
                                                   ON MIFloat_Price.MovementItemId = MI_Check.Id
                                                  AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                  
                                                  
                               LEFT JOIN impMIncome_NDS AS MI_Income ON MI_Income.Id      = tmpMIC_Info.MIIncomeId     
                                                                                       
                         GROUP BY Movement_Check.InvoiceId, MI_Income.NDSKindId 
                         HAVING  SUM (CASE WHEN Movement_Check.DescId = zc_Movement_Check()
                                           THEN COALESCE (MIFloat_SummChangePercent.ValueData, 0)
                                           ELSE MI_Check.Amount * COALESCE (MIFloat_PriceSale.ValueData, 0) -
                                                MI_Check.Amount * COALESCE (MIFloat_Price.ValueData, 0) END) <> 0
                         )                        
    , tmpMI_CheckSumAll AS (SELECT Movement_Check.InvoiceId                            AS InvoiceId 
                                 , MAX(Movement_Check.NDSKindId)::Integer              AS NDSKindId
                                 , SUM(Movement_Check.SummChangePercent)::TFloat       AS SummChangePercent
                                 , SUM(Movement_Check.Amount)::TFloat                  AS Amount
                                 , count(*)                                            AS CountNDS
                            FROM tmpMI_CheckSum AS Movement_Check
                            GROUP BY Movement_Check.InvoiceId 
                           )
                                
                        

        -- Результат
    SELECT     
        Movement.Id
      , Movement.InvNumber
      , zfConvert_InvNumberToInt(Movement.InvNumber)            AS InvNumber_int
      , Movement.OperDate
      , Object_Status.ObjectCode                                AS StatusCode
      , Object_Status.ValueData                                 AS StatusName
      , COALESCE (MovementFloat_TotalSumm.ValueData, 0)::TFloat AS TotalSumm
      , COALESCE (CAST (COALESCE (MI_CheckSumAll.SummChangePercent, MovementFloat_TotalSumm.ValueData, 0)/(1.0 + COALESCE(OF_NDSKind_NDS_Medical.ValueData, OF_NDSKind_NDS.ValueData, 7) / 100) AS NUMERIC (16,2)),0) ::TFloat  AS TotalSummWithOutVAT
      , COALESCE (CAST (COALESCE (MovementFloat_TotalSumm.ValueData, 0) - 
        (COALESCE (MI_CheckSumAll.SummChangePercent, MovementFloat_TotalSumm.ValueData, 0)/(1.0 + COALESCE(OF_NDSKind_NDS_Medical.ValueData, OF_NDSKind_NDS.ValueData, 7) / 100))  AS NUMERIC (16,2)),0) ::TFloat  AS TotalSummVAT

      , COALESCE (ObjectFloat_TotalSumm.ValueData, 0)       :: TFloat AS TotalSumm_Contract
      , COALESCE (MovementFloat_TotalDiffSumm.ValueData,0)  :: TFloat AS TotalDiffSumm
      , (COALESCE (MovementFloat_TotalSumm.ValueData, 0) -  COALESCE (MovementFloat_TotalDiffSumm.ValueData,0) ) :: TFloat AS Summ_Diff
      , COALESCE (MovementFloat_TotalCount.ValueData,0)     :: TFloat AS TotalCount
      , COALESCE (MovementFloat_ChangePercent.ValueData, 0) :: TFloat AS ChangePercent

      , MI_CheckSumAll.SummChangePercent                       AS SummChangePercentAll
      , MI_CheckSumAll.Amount                                  AS AmountSale
      , COALESCE(MI_CheckSumMedical.SummChangePercent, 0) = 0 AND
        COALESCE(MI_CheckSumSpecial_0.SummChangePercent, 0) = 0 AND
        COALESCE(MI_CheckSumAll.CountNDS, 1) > 1               AS isErrorSum 

      , CASE WHEN COALESCE(MI_CheckSumAll.CountNDS, 0) = 1 AND MI_CheckSumAll.NDSKindId = zc_Enum_NDSKind_Medical()
               OR COALESCE(MI_CheckSumAll.CountNDS, 0) = 0    
             THEN COALESCE (MovementFloat_TotalSumm.ValueData, 0)
             ELSE MI_CheckSumMedical.SummChangePercent END::TFloat     AS SummCPMedical
      , CASE WHEN COALESCE(MI_CheckSumAll.CountNDS, 0) = 0
             THEN 9
             WHEN COALESCE(MI_CheckSumAll.CountNDS, 0) <= 1 AND MI_CheckSumAll.NDSKindId = zc_Enum_NDSKind_Medical()
             THEN MI_CheckSumAll.NDSKindId
             ELSE MI_CheckSumMedical.NDSKindId END::Integer            AS NDSKindMedicalId
      , CASE WHEN COALESCE(MI_CheckSumAll.CountNDS, 0) = 0
             THEN 7
             WHEN COALESCE(MI_CheckSumAll.CountNDS, 0) <= 1 AND MI_CheckSumAll.NDSKindId = zc_Enum_NDSKind_Medical()
             THEN OF_NDSKind_NDS.ValueData
             ELSE OF_NDSKind_NDS_Medical.ValueData END::TFloat         AS NDSMedical

      , CASE WHEN COALESCE(MI_CheckSumAll.CountNDS, 0) = 1 AND MI_CheckSumAll.NDSKindId = zc_Enum_NDSKind_Special_0()
             THEN COALESCE (MovementFloat_TotalSumm.ValueData, 0)
             ELSE MI_CheckSumSpecial_0.SummChangePercent END::TFloat   AS SummCPSpecial_0
      , CASE WHEN COALESCE(MI_CheckSumAll.CountNDS, 0) = 1 AND MI_CheckSumAll.NDSKindId = zc_Enum_NDSKind_Special_0()
             THEN MI_CheckSumAll.NDSKindId
             ELSE MI_CheckSumSpecial_0.NDSKindId END::Integer          AS NDSKindSpecial_0Id
      , CASE WHEN COALESCE(MI_CheckSumAll.CountNDS, 0) = 1 AND MI_CheckSumAll.NDSKindId = zc_Enum_NDSKind_Special_0()
             THEN OF_NDSKind_NDS.ValueData
             ELSE OF_NDSKind_NDS_Special_0.ValueData END::TFloat       AS NDSSpecial_0

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
      
      , MovementDate_AdoptedByNSZU.ValueData                   AS DateAdoptedByNSZU

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

        LEFT JOIN tmpMovementFloat AS MovementFloat_TotalDiffSumm
                                   ON MovementFloat_TotalDiffSumm.MovementId = Movement.Id
                                  AND MovementFloat_TotalDiffSumm.DescId = zc_MovementFloat_TotalDiffSumm()

        LEFT JOIN tmpMovementDate AS MovementDate_OperDateStart
                                  ON MovementDate_OperDateStart.MovementId = Movement.Id
                                 AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
        LEFT JOIN tmpMovementDate AS MovementDate_OperDateEnd
                               ON MovementDate_OperDateEnd.MovementId = Movement.Id
                              AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
        LEFT JOIN tmpMovementDate AS MovementDate_AdoptedByNSZU
                               ON MovementDate_AdoptedByNSZU.MovementId = Movement.Id
                              AND MovementDate_AdoptedByNSZU.DescId = zc_MovementDate_AdoptedByNSZU()

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
        LEFT JOIN gpSelect_ObjectHistory_JuridicalDetails(injuridicalid := CASE WHEN Object_PartnerMedical.DescId = zc_Object_Juridical() THEN Object_PartnerMedical.Id ELSE ObjectLink_PartnerMedical_Juridical.ChildObjectId END
                                                        , inFullName := '', inOKPO := '', inSession := inSession) AS ObjectHistory_PartnerMedicalDetails ON 1=1
 
        LEFT JOIN tmpBankAccount ON tmpBankAccount.JuridicalId = Object_Juridical.Id
                                AND tmpBankAccount.BankAccount = ObjectHistory_JuridicalDetails.BankAccount

        LEFT JOIN tmpBankAccount AS tmpPartnerMedicalBankAccount 
                                 ON tmpPartnerMedicalBankAccount.JuridicalId = CASE WHEN Object_PartnerMedical.DescId = zc_Object_Juridical() THEN Object_PartnerMedical.Id ELSE ObjectLink_PartnerMedical_Juridical.ChildObjectId END --ObjectLink_PartnerMedical_Juridical.ChildObjectId
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
        
        LEFT JOIN tmpMI_CheckSumAll AS MI_CheckSumAll
                                    ON MI_CheckSumAll.InvoiceId = Movement.Id
        LEFT JOIN tmpOF_NDSKind_NDS AS OF_NDSKind_NDS
                                    ON OF_NDSKind_NDS.ObjectId = COALESCE(MI_CheckSumAll.NDSKindId, zc_Enum_NDSKind_Medical())
        
        LEFT JOIN tmpMI_CheckSum AS MI_CheckSumMedical
                                 ON MI_CheckSumMedical.InvoiceId = Movement.Id 
                                AND MI_CheckSumAll.SummChangePercent = COALESCE (MovementFloat_TotalSumm.ValueData,0)
                                AND MI_CheckSumMedical.NDSKindId = zc_Enum_NDSKind_Medical()

        LEFT JOIN tmpOF_NDSKind_NDS AS OF_NDSKind_NDS_Medical
                                    ON OF_NDSKind_NDS_Medical.ObjectId = MI_CheckSumMedical.NDSKindId
                                            
        LEFT JOIN tmpMI_CheckSum AS MI_CheckSumSpecial_0
                                 ON MI_CheckSumSpecial_0.InvoiceId = Movement.Id 
                                AND MI_CheckSumAll.SummChangePercent = COALESCE (MovementFloat_TotalSumm.ValueData,0)
                                AND MI_CheckSumSpecial_0.NDSKindId = zc_Enum_NDSKind_Special_0()

        LEFT JOIN tmpOF_NDSKind_NDS AS OF_NDSKind_NDS_Special_0
                                    ON OF_NDSKind_NDS_Special_0.ObjectId = MI_CheckSumSpecial_0.NDSKindId

 ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_Invoice (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.04.19         * add TotalDiffSumm
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


--select * from gpSelect_Movement_Invoice(inStartDate := ('07.06.2021')::TDateTime , inEndDate := ('20.04.2022')::TDateTime , inIsErased := 'False' ,  inSession := '3')
-- where TotalSummAll <> TotalSumm

select * from gpSelect_Movement_Invoice(inStartDate := ('07.02.2022')::TDateTime , inEndDate := ('13.04.2022')::TDateTime , inIsErased := 'False' ,  inSession := '3');