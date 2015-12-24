-- Function: gpSelect_PaymentCorrSumm()

DROP FUNCTION IF EXISTS gpSelect_PaymentCorrSumm (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_PaymentCorrSumm(
    IN inMovementId  Integer      , -- ключ Документа
    IN inJuridicalId Integer      , -- юрлицо
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (ObjectId                  Integer
              , ContainerAmountBonus     TFloat
              , ContainerAmountReturnOut TFloat
              , ContainerAmountOther     TFloat
              , CorrBonus                TFloat
              , LeftCorrBonus            TFloat
              , CorrReturnOut            TFloat
              , LeftCorrReturnOut        TFloat
              , CorrOther                TFloat
              , LeftCorrOther            TFloat
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
    RETURN QUERY
        SELECT
            D.ObjectId
           ,SUM(D.ContainerAmountBonus)::TFloat     AS ContainerAmountBonus
           ,SUM(D.ContainerAmountReturnOut)::TFloat AS ContainerAmountReturnOut
           ,SUM(D.ContainerAmountOther)::TFloat     AS ContainerAmountOther
           ,SUM(D.CorrBonus)::TFloat                AS CorrBonus
           ,SUM(D.LeftCorrBonus)::TFloat            AS LeftCorrBonus
           ,SUM(D.CorrReturnOut)::TFloat            AS CorrReturnOut
           ,SUM(D.LeftCorrReturnOut)::TFloat        AS LeftCorrReturnOut
           ,SUM(D.CorrOther)::TFloat                AS CorrOther
           ,SUM(D.LeftCorrOther)::TFloat            AS LeftCorrOther
        FROM (
                SELECT
                    Container.Amount AS ContainerAmountBonus
                   ,0::TFloat AS ContainerAmountReturnOut
                   ,0::TFloat AS ContainerAmountOther
                   ,MI.CorrBonus
                   ,COALESCE(Container.Amount,0) - COALESCE(MI.CorrBonus,0) AS LeftCorrBonus
                   ,0::TFloat AS CorrReturnOut
                   ,0::TFloat AS LeftCorrReturnOut
                   ,0::TFloat AS CorrOther
                   ,0::TFloat AS LeftCorrOther
                   ,CLO_Juridical.ObjectId
                FROM
                    Container 
                    LEFT OUTER JOIN ContainerLinkObject AS CLO_Juridical
                                                        ON CLO_Juridical.ContainerId = Container.Id
                                                       AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                    LEFT OUTER JOIN ContainerLinkObject AS CLO_JuridicalBasis
                                                        ON CLO_JuridicalBasis.ContainerId = Container.Id
                                                       AND CLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                    LEFT OUTER JOIN (SELECT
                                         Movement_From.ObjectId,
                                         SUM(MIFloat_CorrBonus.ValueData) as CorrBonus
                                     FROM MovementItem 
                                         INNER JOIN MovementItemFloat AS MIFloat_CorrBonus
                                                                      ON MIFloat_CorrBonus.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_CorrBonus.DescId = zc_MIFloat_CorrBonus()
                                         INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                                      ON MIFloat_MovementId.MovementItemid = MovementItem.Id
                                                                     AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                                         LEFT OUTER JOIN MovementLinkObject AS Movement_From
                                                                            ON Movement_From.MovementId = MIFloat_MovementId.ValueData
                                                                           AND Movement_From.DescId = zc_MovementLinkObject_From()
                                         LEFT OUTER JOIN MovementItemBoolean AS MIBoolean_NeedPay
                                                                             ON MIBoolean_NeedPay.MovementItemId = MovementItem.Id
                                                                            AND MIBoolean_NeedPay.DescId = zc_MIBoolean_NeedPay()
                                     Where MovementItem.MovementId = inMovementId
                                       AND MovementItem.Descid = zc_MI_Master()
                                       AND MIFloat_CorrBonus.ValueData <> 0
                                       AND MovementItem.IsErased = FALSE
                                       AND COALESCE(MIBoolean_NeedPay.ValueData,FALSE) = TRUE
                                     GROUP BY
                                         Movement_From.ObjectId) AS MI
                                                                 ON MI.ObjectId = CLO_Juridical.ObjectId
                WHERE
                    Container.DescId = zc_Container_SummIncomeMovementPayment() 
                    AND 
                    Container.ObjectId = zc_Enum_ChangeIncomePaymentKind_Bonus()
                    AND
                    Container.Amount <> 0
                    AND
                    CLO_JuridicalBasis.ObjectId = inJuridicalId
                UNION ALL
                SELECT
                    0::TFloat AS ContainerAmountBonus
                    ,Container.Amount AS ContainerAmountReturnOut
                    ,0::TFloat AS ContainerAmountOther
                    ,0::TFloat AS CorrBonus
                    ,0::TFloat AS LeftCorrBonus
                    ,MI.CorrReturnOut
                    ,COALESCE(Container.Amount,0) - COALESCE(MI.CorrReturnOut,0) AS LeftCorrReturnOut
                    ,0::TFloat AS CorrOther
                    ,0::TFloat AS LeftCorrOther
                    ,CLO_Juridical.ObjectId
                FROM
                    Container 
                    LEFT OUTER JOIN ContainerLinkObject AS CLO_Juridical
                                                        ON CLO_Juridical.ContainerId = Container.Id
                                                       AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                    LEFT OUTER JOIN ContainerLinkObject AS CLO_JuridicalBasis
                                                        ON CLO_JuridicalBasis.ContainerId = Container.Id
                                                       AND CLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                    LEFT OUTER JOIN (SELECT
                                         Movement_From.ObjectId,
                                         SUM(MIFloat_CorrReturnOut.ValueData) as CorrReturnOut
                                     FROM MovementItem 
                                         INNER JOIN MovementItemFloat AS MIFloat_CorrReturnOut
                                                                      ON MIFloat_CorrReturnOut.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_CorrReturnOut.DescId = zc_MIFloat_CorrReturnOut()
                                         INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                                      ON MIFloat_MovementId.MovementItemid = MovementItem.Id
                                                                     AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                                         LEFT OUTER JOIN MovementLinkObject AS Movement_From
                                                                            ON Movement_From.MovementId = MIFloat_MovementId.ValueData
                                                                           AND Movement_From.DescId = zc_MovementLinkObject_From()
                                         LEFT OUTER JOIN MovementItemBoolean AS MIBoolean_NeedPay
                                                                             ON MIBoolean_NeedPay.MovementItemId = MovementItem.Id
                                                                            AND MIBoolean_NeedPay.DescId = zc_MIBoolean_NeedPay()
                                     Where MovementItem.MovementId = inMovementId
                                       AND MovementItem.Descid = zc_MI_Master()
                                       AND MIFloat_CorrReturnOut.ValueData <> 0
                                       AND MovementItem.IsErased = FALSE
                                       AND COALESCE(MIBoolean_NeedPay.ValueData,FALSE) = TRUE
                                     GROUP BY
                                         Movement_From.ObjectId) AS MI
                                                                 ON MI.ObjectId = CLO_Juridical.ObjectId
                WHERE
                    Container.DescId = zc_Container_SummIncomeMovementPayment() 
                    AND 
                    Container.ObjectId = zc_Enum_ChangeIncomePaymentKind_ReturnOut()
                    AND
                    Container.Amount <> 0
                    AND
                    CLO_JuridicalBasis.ObjectId = inJuridicalId    
                UNION ALL
                SELECT
                    0::TFloat AS ContainerAmountBonus
                    ,0::TFloat AS ContainerAmountReturnOut
                    ,Container.Amount AS ContainerAmountOther
                    ,0::TFloat AS CorrBonus
                    ,0::TFloat AS LeftCorrBonus
                    ,0::TFloat AS CorrReturnOut
                    ,0::TFloat AS LeftCorrReturnOut
                    ,MI.CorrOther
                    ,COALESCE(Container.Amount,0) - COALESCE(MI.CorrOther,0) AS LeftCorrOther
                    ,CLO_Juridical.ObjectId
                FROM
                    Container 
                    LEFT OUTER JOIN ContainerLinkObject AS CLO_Juridical
                                                        ON CLO_Juridical.ContainerId = Container.Id
                                                       AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                    LEFT OUTER JOIN ContainerLinkObject AS CLO_JuridicalBasis
                                                        ON CLO_JuridicalBasis.ContainerId = Container.Id
                                                       AND CLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                    LEFT OUTER JOIN (SELECT
                                         Movement_From.ObjectId,
                                         SUM(MIFloat_CorrOther.ValueData) as CorrOther
                                     FROM MovementItem 
                                         INNER JOIN MovementItemFloat AS MIFloat_CorrOther
                                                                      ON MIFloat_CorrOther.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_CorrOther.DescId = zc_MIFloat_CorrOther()
                                         INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                                      ON MIFloat_MovementId.MovementItemid = MovementItem.Id
                                                                     AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                                         LEFT OUTER JOIN MovementLinkObject AS Movement_From
                                                                            ON Movement_From.MovementId = MIFloat_MovementId.ValueData
                                                                           AND Movement_From.DescId = zc_MovementLinkObject_From()
                                         LEFT OUTER JOIN MovementItemBoolean AS MIBoolean_NeedPay
                                                                             ON MIBoolean_NeedPay.MovementItemId = MovementItem.Id
                                                                            AND MIBoolean_NeedPay.DescId = zc_MIBoolean_NeedPay()
                                     Where MovementItem.MovementId = inMovementId
                                       AND MovementItem.Descid = zc_MI_Master()
                                       AND MIFloat_CorrOther.ValueData <> 0
                                       AND MovementItem.IsErased = FALSE
                                       AND COALESCE(MIBoolean_NeedPay.ValueData,FALSE) = TRUE
                                     GROUP BY
                                         Movement_From.ObjectId) AS MI
                                                                 ON MI.ObjectId = CLO_Juridical.ObjectId
                WHERE
                    Container.DescId = zc_Container_SummIncomeMovementPayment() 
                    AND 
                    Container.ObjectId = zc_Enum_ChangeIncomePaymentKind_Other()
                    AND
                    Container.Amount <> 0
                    AND
                    CLO_JuridicalBasis.ObjectId = inJuridicalId) AS D
        Group By
            D.ObjectId;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_PaymentCorrSumm (Integer, Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 21.12.15                                                          *
*/