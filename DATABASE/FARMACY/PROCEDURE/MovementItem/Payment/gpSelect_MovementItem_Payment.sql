-- Function: gpSelect_MovementItem_Payment()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Payment (Integer, Boolean, Boolean, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Payment(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , -- показать все
    IN inIsErased    Boolean      , -- показать удаленные
    IN inDateStart   TDateTime    , -- минимальная дата приходов
    IN inDateEnd     TDateTime    , -- максимальная дата приходов
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id                    Integer
             , IncomeId             Integer
             , Income_InvNumber     TVarChar
             , Income_OperDate      TDateTime
             , Income_PaymentDate   TDateTime
             , Income_StatusName    TVarChar
             , Income_JuridicalId   Integer
             , Income_JuridicalName TVarChar
             , Income_PayOrder      TFloat
             , Income_UnitId        Integer
             , Income_UnitName      TVarChar
             , Income_NDSKindName   TVarChar
             , Income_NDS           TFloat
             , Income_ContractName  TVarChar
             , Income_TotalSumm     TFloat
             , Income_PaySumm       TFloat
             , SummaCorrBonus       TFloat
             , SummaCorrReturnOut   TFloat
             , SummaCorrOther       TFloat
             , SummaPay             TFloat
             , BankAccountId        Integer
             , BankAccountName      TVarChar
             , BankName             TVarChar
             , isErased             Boolean
             , NeedPay              Boolean
             , isPartialPay         Boolean
             , ContractNumber       TVarChar
             , ContractStartDate    TDateTime
             , ContractEndDate      TDateTime
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbJuridicalId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Payment());
    vbUserId:= lpGetUserBySession (inSession);


    -- Результат
    SELECT MovementLinkObject_Juridical.ObjectId AS JuridicalId
           INTO vbJuridicalId
    FROM MovementLinkObject AS MovementLinkObject_Juridical
    WHERE MovementLinkObject_Juridical.MovementId = inMovementId
      AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical();

    

    -- Результат
    IF inShowAll THEN
        
        -- Результат такой
        RETURN QUERY
        WITH tmpContainer AS
                         (SELECT Object_Movement.ObjectCode AS MovementId, Container.Amount, Container.KeyValue
                          FROM Container
                               /*INNER JOIN ContainerLinkObject AS CLO_JuridicalBasis
                                                              ON CLO_JuridicalBasis.ContainerId = Container.Id
                                                             AND CLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                                                             AND CLO_JuridicalBasis.ObjectId =  vbJuridicalId*/
                               LEFT JOIN Object AS Object_Movement ON Object_Movement.Id = Container.ObjectId
                                                                  AND Object_Movement.DescId = zc_Object_PartionMovement()
                          WHERE Container.DescId = zc_Container_SummIncomeMovementPayment()
                            AND Container.Amount  > 0
                            -- AND Container.KeyValue LIKE '%,' || vbJuridicalId || ';%'
                         )
          , Income AS 
             (SELECT Movement.Id                                AS Id
                   , Movement.InvNumber                         AS InvNumber
                   , Movement.OperDate                          AS OperDate
                   , MovementDate_Payment.ValueData             AS PaymentDate
                   , Object_Status.ValueData                    AS StatusName
                   , MovementLinkObject_From.ObjectId           AS FromId
                   , Object_From.ValueData                      AS FromName
                   , MovementLinkObject_To.ObjectId             AS ToId
                   , Object_To.ValueData                        AS ToName
                   , Object_NDSKind.ValueData                   AS NDSKindName
                   , ObjectFloat_NDSKind_NDS.ValueData          AS NDS
                   , Object_Contract.ValueData                  AS ContractName
                   , MovementFloat_TotalSumm.ValueData          AS TotalSumm
                   , tmpContainer.Amount                        AS PaySumm
                   , COALESCE (NULLIF (ObjectFloat_Juridical_PayOrder.ValueData, 0), 999999) :: TFloat AS PayOrder
                   --, tmpContainer.KeyValue LIKE '%,' || ObjectLink_Unit_Juridical.ChildObjectId || ';%' AS tmpFind
                   , tmpContainer.KeyValue LIKE '%,' || TRIM(vbJuridicalId:: TVarChar) || ';%' AS tmpFind                      -- 09.09.19 
              FROM tmpContainer

                    INNER JOIN MovementDate AS MovementDate_Payment
                                            ON MovementDate_Payment.MovementId = tmpContainer.MovementId
                                           AND MovementDate_Payment.DescId = zc_MovementDate_Payment()
                                           AND MovementDate_Payment.ValueData BETWEEN inDateStart AND inDateEnd

                    INNER JOIN Movement ON Movement.Id = tmpContainer.MovementId
                                       AND Movement.DescId = zc_Movement_Income()

                    INNER JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                  ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                                 AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                                                 AND MovementLinkObject_Juridical.ObjectId = vbJuridicalId

                    LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

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
                    LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                         ON ObjectLink_Unit_Juridical.ObjectId = Object_To.Id
                                        AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

                    LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                 ON MovementLinkObject_NDSKind.MovementId = Movement.Id
                                                AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                    LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = MovementLinkObject_NDSKind.ObjectId

                    LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                          ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId 
                                         AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                                         
                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                 ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                    LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId


                    LEFT JOIN ObjectFloat AS ObjectFloat_Juridical_PayOrder
                                          ON ObjectFloat_Juridical_PayOrder.ObjectId = MovementLinkObject_From.ObjectId
                                         AND ObjectFloat_Juridical_PayOrder.DescId = zc_ObjectFloat_Juridical_PayOrder()
                    -- Партия накладной
                    /*LEFT JOIN Object AS Object_Movement
                                     ON Object_Movement.ObjectCode = Movement.Id 
                                    AND Object_Movement.DescId = zc_Object_PartionMovement()
                    LEFT JOIN Container ON Container.ObjectId = Object_Movement.Id
                                       AND Container.DescId = zc_Container_SummIncomeMovementPayment()
                                       -- AND Container.KeyValue LIKE '%,' || ObjectLink_Unit_Juridical.ChildObjectId || ';%'
                   */
            ),
            MI_SavedPayment AS 
            (   SELECT MIFloat_IncomeId.ValueData :: Integer AS IncomeId
                FROM MovementItem AS MI_Payment
                     LEFT OUTER JOIN MovementItemFloat AS MIFloat_IncomeId
                                                       ON MIFloat_IncomeId.MovementItemId = MI_Payment.ID
                                                      AND MIFloat_IncomeId.DescId = zc_MIFloat_MovementId()
                WHERE MI_Payment.MovementId = inMovementId
                  AND MI_Payment.DescId = zc_MI_Master()
                  AND (MI_Payment.isErased = FALSE OR inIsErased = TRUE)
            ),
        tmpJuridicalSettings AS 
            (SELECT tmp.JuridicalId
                  , MAX (tmp.Name)      :: TVarChar   AS InvNumber
                  , MAX (tmp.StartDate) :: TDateTime  AS StartDate
                  , MAX (tmp.EndDate)   :: TDateTime  AS EndDate
             FROM gpSelect_Object_JuridicalSettings (FALSE,  inSession) AS tmp
             WHERE tmp.MainJuridicalId = vbJuridicalId
               AND COALESCE (tmp.Name, '') <> ''
             GROUP BY tmp.JuridicalId
             ),
    tmpMI_Payment AS 
            (SELECT MI_Payment.Id                               AS Id
                  , MIFloat_IncomeId.ValueData::Integer         AS IncomeId
                  , Movement_Income.InvNumber                   AS Income_InvNumber
                  , Movement_Income.Operdate                    AS Income_Operdate
                  , MovementDate_Payment.ValueData              AS Income_DatePayment
                  , Object_Status.ValueData                     AS Income_StatusName
                  , MLO_From.ObjectId                           AS Income_JuridicalId
                  , Object_From.ValueData                       AS Income_JuridicalName
                  , COALESCE (NULLIF (ObjectFloat_Juridical_PayOrder.ValueData, 0), 999999) :: TFloat AS Income_PayOrder
                  , MLO_To.ObjectId                             AS Income_UnitId
                  , Object_To.ValueData                         AS Income_UnitName
                  , Object_NDSKind.ValueData                    AS Income_NDSKindName
                  , ObjectFloat_NDSKind_NDS.ValueData           AS Income_NDS
                  , Object_Contract.ValueData                   AS Income_ContractName
                  , MovementFloat_TotalSumm.ValueData           AS Income_TotalSumm
                  , Container.Amount                            AS Income_PaySumm
                  , MIFloat_CorrBonus.ValueData                 AS SummaCorrBonus
                  , MIFloat_CorrReturnOut.ValueData             AS SummaCorrReturnOut
                  , MIFloat_CorrOther.ValueData                 AS SummaCorrOther
                  , MI_Payment.Amount                           AS SummaPay
                  , MILinkObject_BankAccount.ObjectId           AS BankAccountId
                  , Object_BankAccount.ValueData                AS BankAccountName
                  , Object_Bank.ValueData                       AS BankName
                  , MI_Payment.isErased                         AS isErased
                  , COALESCE(MIBoolean_NeedPay.ValueData,FALSE) AS NeedPay
                  , COALESCE(MIBoolean_PartialPay.ValueData,FALSE) AS isPartialPay
                 
               FROM MovementItem AS MI_Payment
                    LEFT OUTER JOIN MovementItemFloat AS MIFloat_IncomeId
                                                      ON MIFloat_IncomeId.MovementItemId = MI_Payment.ID
                                                     AND MIFloat_IncomeId.DescId = zc_MIFloat_MovementId()
                    LEFT OUTER JOIN Movement AS Movement_Income ON Movement_Income.Id = MIFloat_IncomeId.ValueData :: Integer
                    LEFT OUTER JOIN Object AS Object_Status ON Object_Status.Id = Movement_Income.StatusId
                    LEFT OUTER JOIN MovementLinkObject AS MLO_From
                                                       ON MLO_From.MovementId = Movement_Income.Id
                                                      AND MLO_From.DescId = zc_MovementLinkObject_From()
                    LEFT OUTER JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
                               
                    LEFT OUTER JOIN MovementLinkObject AS MLO_To
                                                       ON MLO_To.MovementId = Movement_Income.Id
                                                      AND MLO_To.DescId = zc_MovementLinkObject_To()
                    LEFT OUTER JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId
                    LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                         ON ObjectLink_Unit_Juridical.ObjectId = Object_To.Id
                                        AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

                    LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                 ON MovementLinkObject_NDSKind.MovementId = Movement_Income.Id
                                                AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                    LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = MovementLinkObject_NDSKind.ObjectId

                    LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                          ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId 
                                         AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS() 
                                                                            
                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                 ON MovementLinkObject_Contract.MovementId = Movement_Income.Id
                                                AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                    LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId
        
                    LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                            ON MovementFloat_TotalSumm.MovementId = Movement_Income.Id
                                           AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                    LEFT JOIN MovementDate AS MovementDate_Payment
                                           ON MovementDate_Payment.MovementId = Movement_Income.Id
                                          AND MovementDate_Payment.DescId = zc_MovementDate_Payment()

                    LEFT JOIN Object AS Object_Movement
                                     ON Object_Movement.ObjectCode = Movement_Income.Id
                                    AND Object_Movement.DescId = zc_Object_PartionMovement()
                    LEFT JOIN Container ON Container.DescId = zc_Container_SummIncomeMovementPayment()
                                       AND Container.ObjectId = Object_Movement.Id
                                       AND Container.KeyValue LIKE '%,' || ObjectLink_Unit_Juridical.ChildObjectId || ';%'

                    LEFT OUTER JOIN MovementItemFloat AS MIFloat_CorrBonus
                                                      ON MIFloat_CorrBonus.MovementItemId = MI_Payment.ID
                                                     AND MIFloat_CorrBonus.DescId = zc_MIFloat_CorrBonus()
                    LEFT OUTER JOIN MovementItemFloat AS MIFloat_CorrReturnOut
                                                      ON MIFloat_CorrReturnOut.MovementItemId = MI_Payment.ID
                                                     AND MIFloat_CorrReturnOut.DescId = zc_MIFloat_CorrReturnOut()
                    LEFT OUTER JOIN MovementItemFloat AS MIFloat_CorrOther
                                                      ON MIFloat_CorrOther.MovementItemId = MI_Payment.ID
                                                     AND MIFloat_CorrOther.DescId = zc_MIFloat_CorrOther()
                    LEFT OUTER JOIN MovementitemLinkObject AS MILinkObject_BankAccount
                                                           ON MILinkObject_BankAccount.MovementItemId = MI_Payment.ID
                                                          AND MILinkObject_BankAccount.DescId = zc_MILinkObject_BankAccount()
                    LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = MILinkObject_BankAccount.ObjectId
                    LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                                         ON ObjectLink_BankAccount_Bank.ObjectId = Object_BankAccount.Id
                                        AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
                    LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId

                    LEFT JOIN MovementItemBoolean AS MIBoolean_NeedPay
                                                  ON MIBoolean_NeedPay.MovementItemId = MI_Payment.Id
                                                 AND MIBoolean_NeedPay.DescId = zc_MIBoolean_NeedPay()
                    LEFT JOIN MovementItemBoolean AS MIBoolean_PartialPay
                                                  ON MIBoolean_PartialPay.MovementItemId = MI_Payment.Id
                                                 AND MIBoolean_PartialPay.DescId = zc_MIBoolean_PartialPay()

                    LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Juridical_PayOrder
                                                ON ObjectFloat_Juridical_PayOrder.ObjectId = MLO_From.ObjectId
                                               AND ObjectFloat_Juridical_PayOrder.DescId = zc_ObjectFloat_Juridical_PayOrder()
                    LEFT OUTER JOIN MovementItem AS MI_MovementBankAccount
                                                 ON MI_MovementBankAccount.ParentId = MI_Payment.Id
                WHERE MI_Payment.MovementId = inMovementId
                  AND MI_Payment.DescId     = zc_MI_Master()
                  AND (MI_Payment.isErased = FALSE OR inIsErased = TRUE)
            )
            -- Результат
            SELECT
                0                    AS Id
              , Income.Id            AS IncomeId
              , Income.InvNumber     AS Income_InvNumber
              , Income.OperDate      AS Income_Operdate
              , Income.PaymentDate   AS Income_PaymentDate
              , Income.StatusName    AS Income_StatusName
              , Income.FromId        AS Income_JuridicalId
              , Income.FromName      AS Income_JuridicalName
              , Income.PayOrder      AS Income_PayOrder
              , Income.ToId          AS Income_UnitId
              , Income.ToName        AS Income_UnitName
              , Income.NDSKindName   AS Income_NDSKindName
              , Income.NDS           AS Income_NDS
              , Income.ContractName  AS Income_ContractName
              , Income.TotalSumm     AS Income_TotalSumm
              , Income.PaySumm       AS Income_PaySumm
              , NULL::TFloat         AS SummaCorrBonus
              , NULL::TFloat         AS SummaCorrReturnOut
              , NULL::TFloat         AS SummaCorrOther
              , Income.PaySumm       AS SummaPay
              , NULL::Integer        AS BankAccountId
              , NULL::TVarChar       AS BankAccountName
              , NULL::TVarChar       AS BankName
              , FALSE                AS isErased
              , FALSE                AS NeedPay
              , FALSE                AS isPartialPay

              , tmpJuridicalSettings.InvNumber AS ContractNumber
              , tmpJuridicalSettings.StartDate AS ContractStartDate
              , tmpJuridicalSettings.EndDate   AS ContractEndDate
            FROM Income
                LEFT OUTER JOIN MI_SavedPayment ON Income.Id = MI_SavedPayment.IncomeId
                LEFT JOIN tmpJuridicalSettings ON tmpJuridicalSettings.JuridicalId = Income.FromId 
            WHERE Income.tmpFind = TRUE
              AND MI_SavedPayment.IncomeId IS NULL

           UNION ALL
            SELECT
                MI_Payment.Id
              , MI_Payment.IncomeId
              , MI_Payment.Income_InvNumber
              , MI_Payment.Income_Operdate
              , MI_Payment.Income_DatePayment
              , MI_Payment.Income_StatusName
              , MI_Payment.Income_JuridicalId
              , MI_Payment.Income_JuridicalName
              , MI_Payment.Income_PayOrder
              , MI_Payment.Income_UnitId
              , MI_Payment.Income_UnitName
              , MI_Payment.Income_NDSKindName
              , MI_Payment.Income_NDS
              , MI_Payment.Income_ContractName
              , MI_Payment.Income_TotalSumm
              , MI_Payment.Income_PaySumm
              , MI_Payment.SummaCorrBonus
              , MI_Payment.SummaCorrReturnOut
              , MI_Payment.SummaCorrOther
              , MI_Payment.SummaPay
              , MI_Payment.BankAccountId
              , MI_Payment.BankAccountName
              , MI_Payment.BankName
              , MI_Payment.isErased
              , MI_Payment.NeedPay
              , MI_Payment.isPartialPay
              , tmpJuridicalSettings.InvNumber AS ContractNumber
              , tmpJuridicalSettings.StartDate AS ContractStartDate
              , tmpJuridicalSettings.EndDate   AS ContractEndDate
            FROM tmpMI_Payment AS MI_Payment
                 LEFT JOIN tmpJuridicalSettings ON tmpJuridicalSettings.JuridicalId = MI_Payment.Income_JuridicalId
            /*ORDER BY
                7,5,3*/
           ;
                
    ELSE
        -- Результат другой
        RETURN QUERY
           WITH tmpJuridicalSettings AS 
            (SELECT tmp.JuridicalId
                  , MAX (tmp.Name)      :: TVarChar    AS InvNumber
                  , MAX (tmp.StartDate) :: TDateTime   AS StartDate
                  , MAX (tmp.EndDate)   :: TDateTime   AS EndDate
             FROM gpSelect_Object_JuridicalSettings (FALSE,  inSession) AS tmp
             WHERE tmp.MainJuridicalId = vbJuridicalId
               AND COALESCE (tmp.Name, '') <> '' 
             GROUP BY tmp.JuridicalId
            )
          , tmpMI_Payment AS 
            (SELECT MI_Payment.Id                               AS Id
                  , MIFloat_IncomeId.ValueData::Integer         AS IncomeId
                  , Movement_Income.InvNumber                   AS Income_InvNumber
                  , Movement_Income.Operdate                    AS Income_Operdate
                  , MovementDate_Payment.ValueData              AS Income_DatePayment
                  , Object_Status.ValueData                     AS Income_StatusName
                  , MLO_From.ObjectId                           AS Income_JuridicalId
                  , Object_From.ValueData                       AS Income_JuridicalName
                  , COALESCE (NULLIF (ObjectFloat_Juridical_PayOrder.ValueData, 0), 999999) :: TFloat AS Income_PayOrder
                  , MLO_To.ObjectId                             AS Income_UnitId
                  , Object_To.ValueData                         AS Income_UnitName
                  , Object_NDSKind.ValueData                    AS Income_NDSKindName
                  , ObjectFloat_NDSKind_NDS.ValueData           AS Income_NDS
                  , Object_Contract.ValueData                   AS Income_ContractName
                  , MovementFloat_TotalSumm.ValueData           AS Income_TotalSumm
                  , Container.Amount                            AS Income_PaySumm
                  , MIFloat_CorrBonus.ValueData                 AS SummaCorrBonus
                  , MIFloat_CorrReturnOut.ValueData             AS SummaCorrReturnOut
                  , MIFloat_CorrOther.ValueData                 AS SummaCorrOther
                  , MI_Payment.Amount                           AS SummaPay
                  , MILinkObject_BankAccount.ObjectId           AS BankAccountId
                  , Object_BankAccount.ValueData                AS BankAccountName
                  , Object_Bank.ValueData                       AS BankName
                  , MI_Payment.isErased                         AS isErased
                  , COALESCE(MIBoolean_NeedPay.ValueData,FALSE) AS NeedPay
                  , COALESCE(MIBoolean_PartialPay.ValueData,FALSE) AS isPartialPay
                 
               FROM MovementItem AS MI_Payment
                    LEFT OUTER JOIN MovementItemFloat AS MIFloat_IncomeId
                                                      ON MIFloat_IncomeId.MovementItemId = MI_Payment.ID
                                                     AND MIFloat_IncomeId.DescId = zc_MIFloat_MovementId()
                    LEFT OUTER JOIN Movement AS Movement_Income ON Movement_Income.Id = MIFloat_IncomeId.ValueData :: Integer
                    LEFT OUTER JOIN Object AS Object_Status ON Object_Status.Id = Movement_Income.StatusId

                    LEFT OUTER JOIN MovementLinkObject AS MLO_From
                                                       ON MLO_From.MovementId = Movement_Income.Id
                                                      AND MLO_From.DescId = zc_MovementLinkObject_From()
                    LEFT OUTER JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
                               
                    LEFT OUTER JOIN MovementLinkObject AS MLO_To
                                                       ON MLO_To.MovementId = Movement_Income.Id
                                                      AND MLO_To.DescId = zc_MovementLinkObject_To()
                    LEFT JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId
                    LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                         ON ObjectLink_Unit_Juridical.ObjectId = Object_To.Id
                                        AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

                    LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                 ON MovementLinkObject_NDSKind.MovementId = Movement_Income.Id
                                                AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                    LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = MovementLinkObject_NDSKind.ObjectId

                    LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                          ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId 
                                         AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS() 

                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                 ON MovementLinkObject_Contract.MovementId = Movement_Income.Id
                                                AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                    LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId
        
                    LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                            ON MovementFloat_TotalSumm.MovementId = Movement_Income.Id
                                           AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                    LEFT JOIN MovementDate    AS MovementDate_Payment
                                              ON MovementDate_Payment.MovementId = Movement_Income.Id
                                             AND MovementDate_Payment.DescId = zc_MovementDate_Payment()

                    LEFT JOIN Object AS Object_Movement
                                     ON Object_Movement.ObjectCode = Movement_Income.Id
                                    AND Object_Movement.DescId = zc_Object_PartionMovement()

                    LEFT JOIN Container ON Container.ObjectId = Object_Movement.Id
                                       AND Container.DescId = zc_Container_SummIncomeMovementPayment()
                                       AND Container.KeyValue LIKE '%,' || ObjectLink_Unit_Juridical.ChildObjectId || ';%'

                    LEFT OUTER JOIN MovementItemFloat AS MIFloat_CorrBonus
                                                      ON MIFloat_CorrBonus.MovementItemId = MI_Payment.ID
                                                     AND MIFloat_CorrBonus.DescId = zc_MIFloat_CorrBonus()
                    LEFT OUTER JOIN MovementItemFloat AS MIFloat_CorrReturnOut
                                                      ON MIFloat_CorrReturnOut.MovementItemId = MI_Payment.ID
                                                     AND MIFloat_CorrReturnOut.DescId = zc_MIFloat_CorrReturnOut()
                    LEFT OUTER JOIN MovementItemFloat AS MIFloat_CorrOther
                                                      ON MIFloat_CorrOther.MovementItemId = MI_Payment.ID
                                                     AND MIFloat_CorrOther.DescId = zc_MIFloat_CorrOther()

                    LEFT OUTER JOIN MovementitemLinkObject AS MILinkObject_BankAccount
                                                           ON MILinkObject_BankAccount.MovementItemId = MI_Payment.ID
                                                          AND MILinkObject_BankAccount.DescId = zc_MILinkObject_BankAccount()
                    LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = MILinkObject_BankAccount.ObjectId
                    LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                                         ON ObjectLink_BankAccount_Bank.ObjectId = Object_BankAccount.Id
                                        AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
                    LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId

                    LEFT JOIN MovementItemBoolean AS MIBoolean_NeedPay
                                                  ON MIBoolean_NeedPay.MovementItemId = MI_Payment.Id
                                                 AND MIBoolean_NeedPay.DescId = zc_MIBoolean_NeedPay()
                    LEFT JOIN MovementItemBoolean AS MIBoolean_PartialPay
                                                  ON MIBoolean_PartialPay.MovementItemId = MI_Payment.Id
                                                 AND MIBoolean_PartialPay.DescId = zc_MIBoolean_PartialPay()

                    LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Juridical_PayOrder
                                                ON ObjectFloat_Juridical_PayOrder.ObjectId = MLO_From.ObjectId
                                               AND ObjectFloat_Juridical_PayOrder.DescId = zc_ObjectFloat_Juridical_PayOrder()

                    LEFT OUTER JOIN MovementItem AS MI_MovementBankAccount
                                                 ON MI_MovementBankAccount.ParentId = MI_Payment.Id

                WHERE MI_Payment.MovementId = inMovementId
                  AND MI_Payment.DescId = zc_MI_Master()
                  AND (MI_Payment.isErased = FALSE OR inIsErased = TRUE)
            )
            -- Результат
            SELECT
                MI_Payment.Id
              , MI_Payment.IncomeId
              , MI_Payment.Income_InvNumber
              , MI_Payment.Income_Operdate
              , MI_Payment.Income_DatePayment
              , MI_Payment.Income_StatusName
              , MI_Payment.Income_JuridicalId
              , MI_Payment.Income_JuridicalName
              , MI_Payment.Income_PayOrder
              , MI_Payment.Income_UnitId
              , MI_Payment.Income_UnitName
              , MI_Payment.Income_NDSKindName
              , MI_Payment.Income_NDS
              , MI_Payment.Income_ContractName
              , MI_Payment.Income_TotalSumm
              , MI_Payment.Income_PaySumm
              , MI_Payment.SummaCorrBonus
              , MI_Payment.SummaCorrReturnOut
              , MI_Payment.SummaCorrOther
              , MI_Payment.SummaPay
              , MI_Payment.BankAccountId
              , MI_Payment.BankAccountName
              , MI_Payment.BankName
              , MI_Payment.isErased
              , MI_Payment.NeedPay
              , MI_Payment.isPartialPay
              , tmpJuridicalSettings.InvNumber AS ContractNumber
              , tmpJuridicalSettings.StartDate AS ContractStartDate
              , tmpJuridicalSettings.EndDate   AS ContractEndDate

            FROM tmpMI_Payment AS MI_Payment
                 LEFT JOIN tmpJuridicalSettings ON tmpJuridicalSettings.JuridicalId = MI_Payment.Income_JuridicalId
            /*ORDER BY
                MI_Payment.Income_JuridicalName
               ,MI_Payment.Income_DatePayment
               ,MI_Payment.Income_InvNumber*/
           ;

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Payment (Integer, Boolean, Boolean, TDateTime, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 09.09.19         * 
 05.01.18         * Income_NDS
 06.04.16         *
 21.12.15                                                          *
 07.12.15                                                          *
 29.10.15                                                          *
*/

-- SELECT * FROM Movement_Payment_View where id = 992827
-- SELECT * FROM gpSelect_MovementItem_Payment (inMovementId := 1831122 , inShowAll:= TRUE , inIsErased:= FALSE, inDateStart := ('05.12.2013')::TDateTime , inDateEnd := ('08.05.2015')::TDateTime ,  inSession := '3');
-- SELECT * FROM gpSelect_MovementItem_Payment (inMovementId := 1831122 , inShowAll:= FALSE, inIsErased:= FALSE, inDateStart := ('05.12.2013')::TDateTime , inDateEnd := ('08.05.2015')::TDateTime ,  inSession := '3');
-- SELECT * FROM gpSelect_MovementItem_Payment(inMovementId := 1848680 , inShowAll := 'True' , inIsErased := 'False' , inDateStart := ('01.01.2016')::TDateTime , inDateEnd := ('13.04.2016')::TDateTime ,  inSession := '3');
-- SELECT * FROM gpSelect_MovementItem_Payment(inMovementId := 1870498 , inShowAll := 'True' , inIsErased := 'False' , inDateStart := ('01.01.2016')::TDateTime , inDateEnd := ('13.04.2016')::TDateTime ,  inSession := '3');

select * from gpSelect_MovementItem_Payment(inMovementId := 20810502 , inShowAll := 'False' , inIsErased := 'False' , inDateStart := ('16.09.2019')::TDateTime , inDateEnd := ('16.09.2019')::TDateTime ,  inSession := '3');