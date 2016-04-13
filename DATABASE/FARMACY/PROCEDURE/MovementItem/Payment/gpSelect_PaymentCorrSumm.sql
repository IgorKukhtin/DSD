-- Function: gpSelect_PaymentCorrSumm()

DROP FUNCTION IF EXISTS gpSelect_PaymentCorrSumm (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_PaymentCorrSumm(
    IN inMovementId  Integer      , -- ���� ���������
    IN inJuridicalId Integer      , -- ������
    IN inSession     TVarChar       -- ������ ������������
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
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Payment());
    vbUserId:= lpGetUserBySession (inSession);
    
    -- ���������
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
                    CASE WHEN Container.ObjectId = zc_Enum_ChangeIncomePaymentKind_Bonus()     THEN Container.Amount ELSE 0 END ::TFloat AS ContainerAmountBonus
                  , CASE WHEN Container.ObjectId = zc_Enum_ChangeIncomePaymentKind_ReturnOut() THEN Container.Amount ELSE 0 END ::TFloat AS ContainerAmountReturnOut
                  , CASE WHEN Container.ObjectId = zc_Enum_ChangeIncomePaymentKind_Other()     THEN Container.Amount ELSE 0 END ::TFloat AS ContainerAmountOther
                  , 0 :: TFloat AS CorrBonus
                  , 0 :: TFloat AS CorrReturnOut
                  , 0 :: TFloat AS CorrOther
                  , CLO_Juridical.ObjectId
                FROM Container 
                    INNER JOIN ContainerLinkObject AS CLO_JuridicalBasis
                                                   ON CLO_JuridicalBasis.ContainerId = Container.Id
                                                  AND CLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                                                  AND CLO_JuridicalBasis.ObjectId = inJuridicalId
                    LEFT JOIN ContainerLinkObject AS CLO_Juridical
                                                  ON CLO_Juridical.ContainerId = Container.Id
                                                 AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                WHERE Container.DescId = zc_Container_SummIncomeMovementPayment() 
                  AND Container.Amount <> 0
                    
               UNION ALL
                SELECT
                    SUM (CASE WHEN Movement.StatusId = zc_Enum_Status_Complete() THEN COALESCE (MIFloat_CorrBonus.ValueData, 0)     ELSE 0 END) :: TFloat AS ContainerAmountBonus
                  , SUM (CASE WHEN Movement.StatusId = zc_Enum_Status_Complete() THEN COALESCE (MIFloat_CorrReturnOut.ValueData, 0) ELSE 0 END) :: TFloat AS ContainerAmountReturnOut
                  , SUM (CASE WHEN Movement.StatusId = zc_Enum_Status_Complete() THEN COALESCE (MIFloat_CorrOther.ValueData, 0)     ELSE 0 END) :: TFloat AS ContainerAmountOther

                   ,SUM (CASE WHEN Movement.StatusId <> zc_Enum_Status_Erased() THEN COALESCE (MIFloat_CorrBonus.ValueData, 0)      ELSE 0 END) :: TFloat AS CorrBonus
                   ,SUM (CASE WHEN Movement.StatusId <> zc_Enum_Status_Erased() THEN COALESCE (MIFloat_CorrReturnOut.ValueData, 0)  ELSE 0 END) :: TFloat AS CorrReturnOut
                   ,SUM (CASE WHEN Movement.StatusId <> zc_Enum_Status_Erased() THEN COALESCE (MIFloat_CorrOther.ValueData, 0)      ELSE 0 END) :: TFloat AS CorrOther
                   ,Movement_From.ObjectId
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

                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId = zc_MI_Master()
                  AND MovementItem.IsErased = FALSE
                  AND (MIFloat_CorrBonus.ValueData     <> 0
                    OR MIFloat_CorrReturnOut.ValueData <> 0
                    OR MIFloat_CorrOther.ValueData     <> 0
                      )
                GROUP BY Movement_From.ObjectId
               ) AS D
        Group By
            D.ObjectId;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_PaymentCorrSumm (Integer, Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
 21.12.15                                                          *
*/

-- ����
-- SELECT * FROM gpSelect_PaymentCorrSumm (inMovementId:= 1813569, inJuridicalId:= 393052, inSession:= '3');
