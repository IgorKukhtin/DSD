-- Function: gpUpdate_Movement_Promo_Data_after()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Promo_Data_after (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Promo_Data_after(
    IN inStartDate             TDateTime  , -- ���� 
    IN inEndDate               TDateTime  , -- ���� 
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());


     -- ������ �� ��������, � ������� ������� �����
     CREATE TEMP TABLE _tmpMovement_sale (MovementId Integer, MovementId_promo Integer) ON COMMIT DROP;


     -- ������ �� ��������, � ������� ������� �����
     INSERT INTO _tmpMovement_sale (MovementId, MovementId_promo)
       -- �� ������
       SELECT MovementDate_OperDatePartner.MovementId, MIN (MIFloat_PromoMovement.ValueData)
       FROM MovementDate AS MovementDate_OperDatePartner
            INNER JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId
                               AND Movement.DescId = zc_Movement_Sale()
                               AND Movement.StatusId = zc_Enum_Status_Complete()
            INNER JOIN MovementBoolean AS MB_Promo
                                       ON MB_Promo.MovementId = MovementDate_OperDatePartner.MovementId
                                      AND MB_Promo.DescId = zc_MovementBoolean_Promo()
                                      AND MB_Promo.ValueData = TRUE
            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                   AND MovementItem.isErased = FALSE
            INNER JOIN MovementItemFloat AS MIFloat_PromoMovement
                                         ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                        AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                                        AND MIFloat_PromoMovement.ValueData <> 0
       WHERE MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
         AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
       GROUP BY MovementDate_OperDatePartner.MovementId
       HAVING MIN (MIFloat_PromoMovement.ValueData) = MAX (MIFloat_PromoMovement.ValueData)
      UNION ALL
       -- �� ������
       SELECT MovementDate_OperDatePartner.MovementId, MIN (MIFloat_PromoMovement.ValueData)
       FROM MovementDate AS MovementDate_OperDatePartner
            INNER JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId
                               AND Movement.DescId = zc_Movement_OrderExternal()
                               AND Movement.StatusId = zc_Enum_Status_Complete()
            INNER JOIN MovementBoolean AS MB_Promo
                                       ON MB_Promo.MovementId = MovementDate_OperDatePartner.MovementId
                                      AND MB_Promo.DescId = zc_MovementBoolean_Promo()
                                      AND MB_Promo.ValueData = TRUE
            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                   AND MovementItem.isErased = FALSE
            INNER JOIN MovementItemFloat AS MIFloat_PromoMovement
                                         ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                        AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                                        AND MIFloat_PromoMovement.ValueData <> 0
       WHERE MovementDate_OperDatePartner.ValueData BETWEEN inStartDate - INTERVAL '5 DAY' AND inEndDate + INTERVAL '5 DAY'
         AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
       GROUP BY MovementDate_OperDatePartner.MovementId
       HAVING MIN (MIFloat_PromoMovement.ValueData) = MAX (MIFloat_PromoMovement.ValueData)
      ;     


     -- ��������� - � MovementLinkMovement ������� + ������
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Promo(), _tmpMovement_sale.MovementId, MovementId_promo)
     FROM _tmpMovement_sale
     ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.  ��������� �.�.
 26.11.15                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_Promo_Data_after (inStartDate:= '01.11.2015', inEndDate:= '30.11.2015', inSession:= zfCalc_UserAdmin())
