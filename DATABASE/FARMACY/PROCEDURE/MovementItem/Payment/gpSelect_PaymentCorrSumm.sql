-- Function: gpSelect_PaymentCorrSumm()

DROP FUNCTION IF EXISTS gpSelect_PaymentCorrSumm (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_PaymentCorrSumm(
    IN inMovementId  Integer      , -- ключ Документа
    IN inJuridicalId Integer      , -- юрлицо
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (ObjectId                   Integer
             , ContainerAmountBonus       TFloat
             , ContainerAmountReturnOut   TFloat
             , ContainerAmountOther       TFloat
             , ContainerAmountPartialSale TFloat
             , CorrBonus                  TFloat
             , LeftCorrBonus              TFloat
             , CorrReturnOut              TFloat
             , LeftCorrReturnOut          TFloat
             , CorrOther                  TFloat
             , LeftCorrOther              TFloat
             , CorrPartialSale            TFloat
             , LeftCorrPartialSale        TFloat
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
    WITH
    tmpContainer AS (SELECT CASE WHEN Container.ObjectId = zc_Enum_ChangeIncomePaymentKind_Bonus()       THEN Container.Amount ELSE 0 END ::TFloat AS ContainerAmountBonus
                          , CASE WHEN Container.ObjectId = zc_Enum_ChangeIncomePaymentKind_ReturnOut()   THEN Container.Amount ELSE 0 END ::TFloat AS ContainerAmountReturnOut
                          , CASE WHEN Container.ObjectId = zc_Enum_ChangeIncomePaymentKind_Other()       THEN Container.Amount ELSE 0 END ::TFloat AS ContainerAmountOther
                          , CASE WHEN Container.ObjectId = zc_Enum_ChangeIncomePaymentKind_PartialSale() THEN Container.Amount ELSE 0 END ::TFloat AS ContainerAmountPartialSale
                          , 0 :: TFloat AS CorrBonus
                          , 0 :: TFloat AS CorrReturnOut
                          , 0 :: TFloat AS CorrOther
                          , 0 :: TFloat AS CorrPartialSale
                          , CLO_Juridical.ObjectId
                     FROM ContainerLinkObject AS CLO_JuridicalBasis
                          INNER JOIN Container ON Container.Id =  CLO_JuridicalBasis.ContainerId
                                              AND Container.DescId = zc_Container_SummIncomeMovementPayment() 
                                              AND Container.Amount <> 0 
                          LEFT JOIN ContainerLinkObject AS CLO_Juridical
                                                        ON CLO_Juridical.ContainerId = Container.Id
                                                       AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                     WHERE CLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                       AND CLO_JuridicalBasis.ObjectId = inJuridicalId
                    )
                      
  , tmpMI AS ( SELECT SUM (CASE WHEN Movement.StatusId = zc_Enum_Status_Complete() THEN COALESCE (MIFloat_CorrBonus.ValueData, 0)       ELSE 0 END) :: TFloat AS ContainerAmountBonus
                    , SUM (CASE WHEN Movement.StatusId = zc_Enum_Status_Complete() THEN COALESCE (MIFloat_CorrReturnOut.ValueData, 0)   ELSE 0 END) :: TFloat AS ContainerAmountReturnOut
                    , SUM (CASE WHEN Movement.StatusId = zc_Enum_Status_Complete() THEN COALESCE (MIFloat_CorrOther.ValueData, 0)       ELSE 0 END) :: TFloat AS ContainerAmountOther
                    , SUM (CASE WHEN Movement.StatusId = zc_Enum_Status_Complete() THEN COALESCE (MIFloat_CorrPartialSale.ValueData, 0) ELSE 0 END) :: TFloat AS ContainerAmountPartialSale
                    , SUM (CASE WHEN Movement.StatusId <> zc_Enum_Status_Erased() THEN COALESCE (MIFloat_CorrBonus.ValueData, 0)        ELSE 0 END) :: TFloat AS CorrBonus
                    , SUM (CASE WHEN Movement.StatusId <> zc_Enum_Status_Erased() THEN COALESCE (MIFloat_CorrReturnOut.ValueData, 0)    ELSE 0 END) :: TFloat AS CorrReturnOut
                    , SUM (CASE WHEN Movement.StatusId <> zc_Enum_Status_Erased() THEN COALESCE (MIFloat_CorrOther.ValueData, 0)        ELSE 0 END) :: TFloat AS CorrOther
                    , SUM (CASE WHEN Movement.StatusId <> zc_Enum_Status_Erased() THEN COALESCE (MIFloat_CorrPartialSale.ValueData, 0)  ELSE 0 END) :: TFloat AS CorrPartialSale
                    , Movement_From.ObjectId
               FROM MovementItem 
                    INNER JOIN MovementItemBoolean AS MIBoolean_NeedPay
                                                   ON MIBoolean_NeedPay.MovementItemId = MovementItem.Id
                                                  AND MIBoolean_NeedPay.DescId = zc_MIBoolean_NeedPay()
                                                  AND MIBoolean_NeedPay.ValueData = TRUE

                    INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                 ON MIFloat_MovementId.MovementItemid = MovementItem.Id
                                                AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                    LEFT JOIN MovementLinkObject AS Movement_From
                                                 ON Movement_From.MovementId = MIFloat_MovementId.ValueData :: Integer
                                                AND Movement_From.DescId = zc_MovementLinkObject_From()
                    LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId

                    LEFT JOIN MovementItemFloat AS MIFloat_CorrBonus
                                                ON MIFloat_CorrBonus.MovementItemId = MovementItem.Id
                                               AND MIFloat_CorrBonus.DescId = zc_MIFloat_CorrBonus()
                    LEFT JOIN MovementItemFloat AS MIFloat_CorrReturnOut
                                                ON MIFloat_CorrReturnOut.MovementItemId = MovementItem.Id
                                               AND MIFloat_CorrReturnOut.DescId = zc_MIFloat_CorrReturnOut()
                    LEFT JOIN MovementItemFloat AS MIFloat_CorrOther
                                                ON MIFloat_CorrOther.MovementItemId = MovementItem.Id
                                               AND MIFloat_CorrOther.DescId = zc_MIFloat_CorrOther()
                    LEFT JOIN MovementItemFloat AS MIFloat_CorrPartialSale
                                                ON MIFloat_CorrPartialSale.MovementItemId = MovementItem.Id
                                               AND MIFloat_CorrPartialSale.DescId = zc_MIFloat_CorrPartialSale()
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId = zc_MI_Master()
                  AND MovementItem.IsErased = FALSE
                  AND (MIFloat_CorrBonus.ValueData     <> 0
                    OR MIFloat_CorrReturnOut.ValueData <> 0
                    OR MIFloat_CorrOther.ValueData     <> 0
                    )
                GROUP BY Movement_From.ObjectId
              )

        SELECT D.ObjectId
             , SUM(D.ContainerAmountBonus)::TFloat       AS ContainerAmountBonus
             , SUM(D.ContainerAmountReturnOut)::TFloat   AS ContainerAmountReturnOut
             , SUM(D.ContainerAmountOther)::TFloat       AS ContainerAmountOther
             , SUM(D.ContainerAmountPartialSale)::TFloat AS ContainerAmountPartialSale
             , SUM(D.CorrBonus)::TFloat                  AS CorrBonus
             , (COALESCE(SUM(D.ContainerAmountBonus),0)-COALESCE(SUM(D.CorrBonus),0))::TFloat               AS LeftCorrBonus
             , SUM(D.CorrReturnOut)::TFloat              AS CorrReturnOut
             , (COALESCE(SUM(D.ContainerAmountReturnOut),0) -COALESCE(SUM(D.CorrReturnOut),0))::TFloat      AS LeftCorrReturnOut
             , SUM(D.CorrOther)::TFloat                  AS CorrOther
             , (COALESCE(SUM(D.ContainerAmountOther),0) - COALESCE(SUM(D.CorrOther),0))::TFloat             AS LeftCorrOther
             , SUM(D.CorrPartialSale)::TFloat            AS CorrPartialSale
             , (COALESCE(SUM(D.ContainerAmountPartialSale),0) - COALESCE(SUM(D.CorrPartialSale),0))::TFloat AS LeftCorrPartialSale
        FROM (
              SELECT tmpContainer.ContainerAmountBonus
                   , tmpContainer.ContainerAmountReturnOut
                   , tmpContainer.ContainerAmountOther
                   , tmpContainer.ContainerAmountPartialSale
                   , tmpContainer.CorrBonus
                   , tmpContainer.CorrReturnOut
                   , tmpContainer.CorrOther
                   , tmpContainer.CorrPartialSale
                   , tmpContainer.ObjectId
              FROM tmpContainer 
            UNION ALL
                SELECT tmpMI.ContainerAmountBonus
                     , tmpMI.ContainerAmountReturnOut
                     , tmpMI.ContainerAmountOther
                     , tmpMI.ContainerAmountPartialSale
                     , tmpMI.CorrBonus
                     , tmpMI.CorrReturnOut
                     , tmpMI.CorrOther
                     , tmpMI.CorrPartialSale
                     , tmpMI.ObjectId
                FROM tmpMI 
              ) AS D
        GROUP BY D.ObjectId;
        
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.   Шаблий О.В.
 03.11.20                                                                         *
 25.09.17         *
 21.12.15                                                          *
*/

-- тест
-- 
select * from gpSelect_PaymentCorrSumm(inMovementId := 6743309 , inJuridicalId := 393052 ,  inSession := '3');
