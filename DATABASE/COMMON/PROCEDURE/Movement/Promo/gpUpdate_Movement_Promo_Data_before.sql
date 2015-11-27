-- Function: gpUpdate_Movement_Promo_Data_before()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Promo_Data_before (TDateTime, TDateTime, TVarChar);

-- zc_MovementLinkMovement_Promo

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Promo_Data_before(
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


     -- ������ �� ��������, � ������� ���� �����
     CREATE TEMP TABLE _tmpMovement_sale (MovementId Integer) ON COMMIT DROP;


     -- ������ �� ��������, � ������� ������� �����
     INSERT INTO _tmpMovement_sale (MovementId)
       -- �� ������
       SELECT MovementDate_OperDatePartner.MovementId
       FROM MovementDate AS MovementDate_OperDatePartner
            INNER JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId
                               AND Movement.DescId = zc_Movement_Sale()
            INNER JOIN MovementBoolean AS MB_Promo
                                       ON MB_Promo.MovementId = MovementDate_OperDatePartner.MovementId
                                      AND MB_Promo.DescId = zc_MovementBoolean_Promo()
                                      AND MB_Promo.ValueData = TRUE
       WHERE MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
         AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
      UNION
       -- �� �����
       SELECT MovementItem.MovementId
       FROM MovementDate AS MovementDate_StartSale
            INNER JOIN MovementDate AS MovementDate_EndSale
                                    ON MovementDate_EndSale.ValueData >= inStartDate
                                   AND MovementDate_EndSale.MovementId =  MovementDate_StartSale.MovementId
                                   AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
            INNER JOIN Movement ON Movement.DescId = zc_Movement_Promo()
                               AND Movement.Id = MovementDate_StartSale.MovementId
            INNER JOIN MovementItemFloat AS MIFloat_PromoMovement
                                         ON MIFloat_PromoMovement.ValueData = Movement.Id
                                        AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
            INNER JOIN MovementItem ON MovementItem.Id = MIFloat_PromoMovement.MovementItemId
       WHERE MovementDate_StartSale.ValueData <= inEndDate
         AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
      ;     

     -- !!!!!
     /*RAISE EXCEPTION '%   %', (select count(*) from _tmpMovement_sale)
                            , (select count(*) from _tmpMovement_sale
          INNER JOIN MovementItem ON MovementItem.MovementId = _tmpMovement_sale.MovementId
          INNER JOIN MovementItemFloat AS MIFloat_PromoMovement
                                       ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                      AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                                      AND MIFloat_PromoMovement.ValueData <> 0);

     -- ��������� - � MovementLinkMovement �������
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Promo(), _tmpMovement_sale.MovementId, NULL)
     FROM _tmpMovement_sale
     ;*/

     -- ��������� - � Movement �������
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Promo(), _tmpMovement_sale.MovementId, FALSE)
     FROM _tmpMovement_sale
     ;

     -- ��������� - � MovementItem �������
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PromoMovementId(), MovementItem.Id, 0)
     FROM _tmpMovement_sale
          INNER JOIN MovementItem ON MovementItem.MovementId = _tmpMovement_sale.MovementId
          INNER JOIN MovementItemFloat AS MIFloat_PromoMovement
                                       ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                      AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                                      AND MIFloat_PromoMovement.ValueData <> 0;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.  ��������� �.�.
 26.11.15                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_Promo_Data_before (inStartDate:= '01.11.2015', inEndDate:= '30.11.2015', inSession:= zfCalc_UserAdmin())
