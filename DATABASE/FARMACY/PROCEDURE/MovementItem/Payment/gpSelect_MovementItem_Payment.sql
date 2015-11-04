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
              , Income_UnitId        Integer
              , Income_UnitName      TVarChar
              , Income_NDSKindName   TVarChar
              , Income_ContractName  TVarChar
              , Income_TotalSumm     TFloat
              , Income_PaySumm       TFloat
              , SummaPay             TFloat
              , BankAccountId        Integer
              , AccountId            Integer
              , AccountName          TVarChar
              , BankName             TVarChar
              , isErased             Boolean
              , NeedPay              Boolean
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
    IF inShowAll THEN
        SELECT
            Movement_Payment.JuridicalId
        INTO
            vbJuridicalId
        FROM
            Movement_Payment_View AS Movement_Payment
        WHERE
            Movement_Payment.Id = inMovementId;
        
        -- Результат такой
        RETURN QUERY
            WITH UNITS AS (
                            SELECT
                                Object_Unit.ID
                            FROM
                                Object_Unit_View AS Object_Unit
                            WHERE
                                Object_Unit.JuridicalId = vbJuridicalId
                                
                          ),
                 Income AS (
                                SELECT
                                    Movement_Income.id
                                  , Movement_Income.InvNumber
                                  , Movement_Income.OperDate
                                  , Movement_Income.PaymentDate
                                  , Movement_Income.StatusName
                                  , Movement_Income.FromId
                                  , Movement_Income.FromName
                                  , Movement_Income.ToId
                                  , Movement_Income.ToName
                                  , Movement_Income.NDSKindName
                                  , Movement_Income.ContractName
                                  , Movement_Income.TotalSumm
                                  , Movement_Income.PaySumm
                                FROM
                                    UNITS
                                    LEFT OUTER JOIN Movement_Income_View AS Movement_Income
                                                                         ON Movement_Income.ToId = UNITS.Id
                                WHERE
                                    Movement_Income.PaySumm > 0
                                    AND
                                    COALESCE(Movement_Income.PaymentDate,Movement_Income.OperDate) between inDateStart AND inDateEnd
                           ),
                 MI_SavedPayment AS (
                                        Select 
                                            MI_Payment.IncomeId
                                        FROM
                                            MovementItem_Payment_View AS MI_Payment
                                        WHERE
                                            MI_Payment.MovementId = inMovementId
                                            AND
                                            (
                                                MI_Payment.isErased = FALSE
                                                or
                                                inIsErased = TRUE
                                            )
                                   )
                
            SELECT
                0                    AS Id
              , Income.Id            AS IncomeId
              , Income.InvNumber     AS Income_InvNumber
              , Income.OperDate      AS Income_Operdate
              , Income.PaymentDate   AS Income_PaymentDate
              , Income.StatusName    AS Income_StatusName
              , Income.FromId        AS Income_JuridicalId
              , Income.FromName      AS Income_JuridicalName
              , Income.ToId          AS Income_UnitId
              , Income.ToName        AS Income_UnitName
              , Income.NDSKindName   AS Income_NDSKindName
              , Income.ContractName  AS Income_ContractName
              , Income.TotalSumm     AS Income_TotalSumm
              , Income.PaySumm       AS Income_PaySumm
              , Income.PaySumm       AS SummaPay
              , NULL::Integer        AS BankAccountId
              , NULL::Integer        AS AccountId
              , NULL::TVarChar       AS AccountName
              , NULL::TVarChar       AS BankName
              , FALSE                AS isErased
              , FALSE                AS NeedPay
            FROM Income
                LEFT OUTER JOIN MI_SavedPayment ON Income.Id = MI_SavedPayment.IncomeId
            WHERE
                MI_SavedPayment.IncomeId IS NULL
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
              , MI_Payment.Income_UnitId
              , MI_Payment.Income_UnitName
              , MI_Payment.Income_NDSKindName
              , MI_Payment.Income_ContractName
              , MI_Payment.Income_TotalSumm
              , MI_Payment.Income_PaySumm
              , MI_Payment.SummaPay
              , MI_Payment.BankAccountId
              , MI_Payment.AccountId
              , MI_Payment.AccountName
              , MI_Payment.BankName
              , MI_Payment.isErased
              , MI_Payment.NeedPay
            FROM 
                MovementItem_Payment_View AS MI_Payment
            WHERE
                MI_Payment.MovementId = inMovementId
                AND
                (
                    MI_Payment.isErased = FALSE
                    or
                    inIsErased = TRUE
                )
            ORDER BY
                7,5,3;
                
    ELSE
        -- Результат другой
        RETURN QUERY
            SELECT
                MI_Payment.Id
              , MI_Payment.IncomeId
              , MI_Payment.Income_InvNumber
              , MI_Payment.Income_Operdate
              , MI_Payment.Income_DatePayment
              , MI_Payment.Income_StatusName
              , MI_Payment.Income_JuridicalId
              , MI_Payment.Income_JuridicalName
              , MI_Payment.Income_UnitId
              , MI_Payment.Income_UnitName
              , MI_Payment.Income_NDSKindName
              , MI_Payment.Income_ContractName
              , MI_Payment.Income_TotalSumm
              , MI_Payment.Income_PaySumm
              , MI_Payment.SummaPay
              , MI_Payment.BankAccountId
              , MI_Payment.AccountId
              , MI_Payment.AccountName
              , MI_Payment.BankName
              , MI_Payment.isErased
              , MI_Payment.NeedPay
            FROM MovementItem_Payment_View AS MI_Payment
            WHERE 
                MI_Payment.MovementId = inMovementId
                AND
                (
                    MI_Payment.isErased = FALSE
                    or
                    inIsErased = TRUE
                )
            ORDER BY
                MI_Payment.Income_JuridicalName
               ,MI_Payment.Income_DatePayment
               ,MI_Payment.Income_InvNumber;
     END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Payment (Integer, Boolean, Boolean, TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 29.10.15                                                          *
*/