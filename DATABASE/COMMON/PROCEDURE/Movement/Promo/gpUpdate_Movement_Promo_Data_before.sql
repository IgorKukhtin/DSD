-- Function: gpUpdate_Movement_Promo_Data_before()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Promo_Data_before (TDateTime, TDateTime, TVarChar);

-- zc_MovementLinkMovement_Promo

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Promo_Data_before(
    IN inStartDate             TDateTime  , -- Дата 
    IN inEndDate               TDateTime  , -- Дата 
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());


     -- данные по продажам, в которых есть акция
     CREATE TEMP TABLE _tmpMovement_sale (MovementId Integer) ON COMMIT DROP;


     -- данные по продажам, в которых найдена акция
     INSERT INTO _tmpMovement_sale (MovementId)
       -- из продаж
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
       -- из акций
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

     -- Результат - в MovementLinkMovement Продажа
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Promo(), _tmpMovement_sale.MovementId, NULL)
     FROM _tmpMovement_sale
     ;*/

     -- Результат - в Movement Продажа
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Promo(), _tmpMovement_sale.MovementId, FALSE)
     FROM _tmpMovement_sale
     ;

     -- Результат - в MovementItem Продажа
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
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.
 26.11.15                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_Promo_Data_before (inStartDate:= '01.11.2015', inEndDate:= '30.11.2015', inSession:= zfCalc_UserAdmin())
