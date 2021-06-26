-- Function: gpSelectMobile_Movement_PromoPartner()

DROP FUNCTION IF EXISTS gpSelectMobile_Movement_PromoPartner (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Movement_PromoPartner(
    IN inSyncDateIn TDateTime, -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id         Integer -- Уникальный идентификатор, формируется в Главной БД, и используется при синхронизации
             , MovementId Integer -- Уникальный идентификатор документа
             , ContractId Integer -- Договора
             , PartnerId  Integer -- Контрагент
             , isSync     Boolean 
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      vbPersonalId:= (SELECT PersonalId FROM gpGetMobile_Object_Const (inSession));

      -- Результат
      IF vbPersonalId IS NOT NULL 
      THEN
           RETURN QUERY
             WITH tmpPromoPartner AS (SELECT MI_PromoPartner.Id             AS PromoPartnerId
                                           , Movement_PromoPartner.ParentId AS MovementId
                                           , COALESCE (MILinkObject_Contract.ObjectId, 0)::Integer AS ContractId
                                           , MI_PromoPartner.ObjectId       AS PartnerId
                                           , ROW_NUMBER() OVER (PARTITION BY MI_PromoPartner.ObjectId, MovementItem_PromoGoods.ObjectId ORDER BY Movement_Promo.Operdate DESC, Movement_PromoPartner.ParentId DESC) AS RowNum
                                      FROM Movement AS Movement_PromoPartner
                                           JOIN MovementItem AS MI_PromoPartner
                                                             ON MI_PromoPartner.MovementId = Movement_PromoPartner.Id
                                                            AND MI_PromoPartner.DescId = zc_MI_Master()
                                                            AND MI_PromoPartner.IsErased = FALSE
                                           JOIN lfSelectMobile_Object_Partner (inIsErased:= FALSE, inSession:= inSession) AS OP ON OP.Id = MI_PromoPartner.ObjectId
                                           JOIN Movement AS Movement_Promo 
                                                         ON Movement_Promo.Id = Movement_PromoPartner.ParentId
                                                        AND Movement_Promo.StatusId = zc_Enum_Status_Complete()
                                           JOIN MovementDate AS MovementDate_StartSale
                                                             ON MovementDate_StartSale.MovementId = Movement_Promo.Id
                                                            AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
                                                            AND MovementDate_StartSale.ValueData <= CURRENT_DATE + INTERVAL '10 DAY'
                                           JOIN MovementDate AS MovementDate_EndSale
                                                             ON MovementDate_EndSale.MovementId = Movement_Promo.Id
                                                            AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
                                                            AND MovementDate_EndSale.ValueData >= CURRENT_DATE   - INTERVAL '10 DAY'
                                           JOIN MovementItem AS MovementItem_PromoGoods 
                                                             ON MovementItem_PromoGoods.MovementId = Movement_Promo.Id
                                                            AND MovementItem_PromoGoods.DescId     = zc_MI_Master()
                                                            AND MovementItem_PromoGoods.IsErased   = FALSE
                                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                                            ON MILinkObject_Contract.MovementItemId = MI_PromoPartner.Id
                                                                           AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                                      WHERE Movement_PromoPartner.DescId = zc_Movement_PromoPartner()
                                        AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                                        --
                                        AND CASE WHEN OP.isOperDateOrder = TRUE
                                                      THEN MovementDate_StartSale.ValueData
                                                         - (COALESCE (OP.PrepareDayCount, 0) :: TVarChar || ' DAY') :: INTERVAL
                                                 ELSE MovementDate_StartSale.ValueData
                                                    - (COALESCE (OP.PrepareDayCount, 0) :: TVarChar || ' DAY') :: INTERVAL
                                                    - (COALESCE (OP.DocumentDayCount, 0) :: TVarChar || ' DAY') :: INTERVAL
                                            END <= CURRENT_DATE
                                        AND CASE WHEN OP.isOperDateOrder = TRUE
                                                      THEN MovementDate_EndSale.ValueData
                                                         - (COALESCE (OP.PrepareDayCount, 0) :: TVarChar || ' DAY') :: INTERVAL
                                                 ELSE MovementDate_EndSale.ValueData
                                                    - (COALESCE (OP.PrepareDayCount, 0) :: TVarChar || ' DAY') :: INTERVAL
                                                    - (COALESCE (OP.DocumentDayCount, 0) :: TVarChar || ' DAY') :: INTERVAL
                                            END >= CURRENT_DATE
                                     )
                , tmpPartner AS (SELECT DISTINCT tmpPromoPartner.PromoPartnerId AS Id
                                      , tmpPromoPartner.MovementId
                                      , tmpPromoPartner.ContractId
                                      , tmpPromoPartner.PartnerId
                                 FROM tmpPromoPartner
                                 WHERE tmpPromoPartner.RowNum = 1
                                )
             SELECT tmpPartner.Id
                  , tmpPartner.MovementId
                  , tmpPartner.ContractId
                  , tmpPartner.PartnerId
                  , TRUE :: Boolean       AS isSync
             FROM tmpPartner
             LIMIT CASE WHEN vbUserId = zfCalc_UserMobile_limit0() THEN 0 ELSE 500000 END
            ;
      END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.   Ярошенко Р.Ф.
 29.05.17                                                                          *
 17.03.17                                                                          *
*/

-- SELECT * FROM gpSelectMobile_Movement_PromoPartner (inSyncDateIn:= zc_DateStart(), inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelectMobile_Movement_PromoPartner (inSyncDateIn:= zc_DateStart(), inSession:= '1156045')
