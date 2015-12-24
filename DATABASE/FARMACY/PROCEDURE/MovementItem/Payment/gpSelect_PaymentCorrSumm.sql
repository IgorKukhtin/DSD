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
           ,(COALESCE(SUM(D.ContainerAmountBonus),0)-COALESCE(SUM(D.CorrBonus),0))::TFloat            AS LeftCorrBonus
           ,SUM(D.CorrReturnOut)::TFloat            AS CorrReturnOut
           ,(COALESCE(SUM(D.ContainerAmountReturnOut),0) -COALESCE(SUM(D.CorrReturnOut),0))::TFloat   AS LeftCorrReturnOut
           ,SUM(D.CorrOther)::TFloat                AS CorrOther
           ,(COALESCE(SUM(D.ContainerAmountOther),0) - COALESCE(SUM(D.CorrOther),0))::TFloat          AS LeftCorrOther
        FROM (
                SELECT
                    Container.Amount AS ContainerAmountBonus
                   ,0::TFloat AS ContainerAmountReturnOut
                   ,0::TFloat AS ContainerAmountOther
                   ,0::TFloat AS CorrBonus
                   ,0::TFloat AS CorrReturnOut
                   ,0::TFloat AS CorrOther
                   ,CLO_Juridical.ObjectId
                FROM
                    Container 
                    LEFT OUTER JOIN ContainerLinkObject AS CLO_Juridical
                                                        ON CLO_Juridical.ContainerId = Container.Id
                                                       AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                    LEFT OUTER JOIN ContainerLinkObject AS CLO_JuridicalBasis
                                                        ON CLO_JuridicalBasis.ContainerId = Container.Id
                                                       AND CLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
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
                    SUM(CASE WHEN Movement.StatusId = zc_Enum_Status_Complete() THEN MIFloat_CorrBonus.ValueData ELSE 0 END)::TFloat AS ContainerAmountBonus
                   ,0::TFloat AS ContainerAmountReturnOut
                   ,0::TFloat AS ContainerAmountOther
                   ,SUM(MIFloat_CorrBonus.ValueData)::TFloat AS CorrBonus
                   ,0::TFloat AS CorrReturnOut
                   ,0::TFloat AS CorrOther
                   ,Movement_From.ObjectId
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
                    INNER JOIN Movement ON MovementItem.MovementId = Movement.Id
                Where MovementItem.MovementId = inMovementId
                  AND MovementItem.Descid = zc_MI_Master()
                  AND MIFloat_CorrBonus.ValueData <> 0
                  AND MovementItem.IsErased = FALSE
                  AND COALESCE(MIBoolean_NeedPay.ValueData,FALSE) = TRUE
                GROUP BY
                    Movement_From.ObjectId
                    
                UNION ALL
                SELECT
                    0::TFloat AS ContainerAmountBonus
                    ,Container.Amount AS ContainerAmountReturnOut
                    ,0::TFloat AS ContainerAmountOther
                    ,0::TFloat AS CorrBonus
                    ,0::TFloat AS CorrReturnOut
                    ,0::TFloat AS CorrOther
                    ,CLO_Juridical.ObjectId
                FROM
                    Container 
                    LEFT OUTER JOIN ContainerLinkObject AS CLO_Juridical
                                                        ON CLO_Juridical.ContainerId = Container.Id
                                                       AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                    LEFT OUTER JOIN ContainerLinkObject AS CLO_JuridicalBasis
                                                        ON CLO_JuridicalBasis.ContainerId = Container.Id
                                                       AND CLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
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
                   ,SUM(CASE WHEN Movement.StatusId = zc_Enum_Status_Complete() THEN MIFloat_CorrReturnOut.ValueData ELSE 0 END)::TFloat AS ContainerAmountReturnOut
                   ,0::TFloat AS ContainerAmountOther
                   ,0::TFloat AS CorrBonus
                   ,SUM(MIFloat_CorrReturnOut.ValueData) as CorrReturnOut
                   ,0::TFloat AS CorrOther
                   ,Movement_From.ObjectId
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
                    INNER JOIN Movement ON MovementItem.MovementId = Movement.Id
                Where MovementItem.MovementId = inMovementId
                  AND MovementItem.Descid = zc_MI_Master()
                  AND MIFloat_CorrReturnOut.ValueData <> 0
                  AND MovementItem.IsErased = FALSE
                  AND COALESCE(MIBoolean_NeedPay.ValueData,FALSE) = TRUE
                GROUP BY
                    Movement_From.ObjectId
                UNION ALL
                SELECT
                    0::TFloat AS ContainerAmountBonus
                   ,0::TFloat AS ContainerAmountReturnOut
                   ,Container.Amount AS ContainerAmountOther
                   ,0::TFloat AS CorrBonus
                   ,0::TFloat AS CorrReturnOut
                   ,0::TFloat AS CorrOther
                   ,CLO_Juridical.ObjectId
                FROM
                    Container 
                    LEFT OUTER JOIN ContainerLinkObject AS CLO_Juridical
                                                        ON CLO_Juridical.ContainerId = Container.Id
                                                       AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                    LEFT OUTER JOIN ContainerLinkObject AS CLO_JuridicalBasis
                                                        ON CLO_JuridicalBasis.ContainerId = Container.Id
                                                       AND CLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                WHERE
                    Container.DescId = zc_Container_SummIncomeMovementPayment() 
                    AND 
                    Container.ObjectId = zc_Enum_ChangeIncomePaymentKind_Other()
                    AND
                    Container.Amount <> 0
                    AND
                    CLO_JuridicalBasis.ObjectId = inJuridicalId
                UNION ALL
                SELECT
                    0::TFloat AS ContainerAmountBonus
                   ,0::TFloat AS ContainerAmountReturnOut
                   ,SUM(CASE WHEN Movement.StatusId = zc_Enum_Status_Complete() THEN MIFloat_CorrOther.ValueData ELSE 0 END)::TFloat AS ContainerAmountOther
                   ,0::TFloat AS CorrBonus
                   ,0::TFloat as CorrReturnOut
                   ,SUM(MIFloat_CorrOther.ValueData) as CorrOther
                   ,Movement_From.ObjectId
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
                    INNER JOIN Movement ON MovementItem.MovementId = Movement.Id
                Where MovementItem.MovementId = inMovementId
                  AND MovementItem.Descid = zc_MI_Master()
                  AND MIFloat_CorrOther.ValueData <> 0
                  AND MovementItem.IsErased = FALSE
                  AND COALESCE(MIBoolean_NeedPay.ValueData,FALSE) = TRUE
                GROUP BY
                    Movement_From.ObjectId) AS D
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