-- Function: gpSelectMobile_Movement_Promo()

DROP FUNCTION IF EXISTS gpSelectMobile_Movement_Promo (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Movement_Promo(
    IN inSyncDateIn TDateTime, -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id              Integer   -- Уникальный идентификатор, формируется в Главной БД, и используется при синхронизации
             , InvNumber       TVarChar  -- Номер документа
             , OperDate        TDateTime -- Дата документа
             , StatusId        Integer   -- Виды статусов
             , StartSale       TDateTime -- Дата начала отгрузки по акционной цене
             , EndSale         TDateTime -- Дата окончания отгрузки по акционной цене
             , isChangePercent Boolean   -- учитывать % скидки по договору, *важно* - если FALSE, тогда в строчной части заявки ChangePercent всегда = 0 
             , CommentMain     TVarChar  -- Примечание (общее)
             , isSync          Boolean   
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
             WITH tmpPromoPartner AS (SELECT Movement_Promo.Id AS PromoId
                                           , Movement_Promo.InvNumber
                                           , Movement_Promo.Operdate
                                           , Movement_Promo.StatusId
                                           , CASE WHEN OP.isOperDateOrder = TRUE
                                                       THEN MovementDate_StartSale.ValueData
                                                          - (COALESCE (OP.PrepareDayCount, 0) :: TVarChar || ' DAY') :: INTERVAL
                                                  ELSE MovementDate_StartSale.ValueData
                                                     - (COALESCE (OP.PrepareDayCount, 0) :: TVarChar || ' DAY') :: INTERVAL
                                                     - (COALESCE (OP.DocumentDayCount, 0) :: TVarChar || ' DAY') :: INTERVAL
                                             END :: TDateTime AS StartSale
                                           , CASE WHEN OP.isOperDateOrder = TRUE
                                                       THEN MovementDate_EndSale.ValueData
                                                          - (COALESCE (OP.PrepareDayCount, 0) :: TVarChar || ' DAY') :: INTERVAL
                                                  ELSE MovementDate_EndSale.ValueData
                                                     - (COALESCE (OP.PrepareDayCount, 0) :: TVarChar || ' DAY') :: INTERVAL
                                                     - (COALESCE (OP.DocumentDayCount, 0) :: TVarChar || ' DAY') :: INTERVAL
                                             END :: TDateTime AS EndSale
                                           , ROW_NUMBER() OVER (PARTITION BY MI_PromoPartner.ObjectId, MovementItem_PromoGoods.ObjectId ORDER BY Movement_Promo.Operdate DESC, Movement_PromoPartner.ParentId DESC) AS RowNum
                                      FROM Movement AS Movement_PromoPartner
                                           JOIN MovementItem AS MI_PromoPartner
                                                             ON MI_PromoPartner.MovementId = Movement_PromoPartner.Id
                                                            AND MI_PromoPartner.DescId = zc_MI_Master()
                                                            AND MI_PromoPartner.IsErased = FALSE
                                           JOIN lfSelectMobile_Object_Partner (inIsErased:= FALSE, inSession:= inSession) AS OP ON OP.Id = MI_PromoPartner.ObjectId
                                           JOIN Movement AS Movement_Promo 
                                                         ON Movement_Promo.Id       = Movement_PromoPartner.ParentId
                                                        AND Movement_Promo.StatusId = zc_Enum_Status_Complete()
                                           JOIN MovementDate AS MovementDate_StartSale
                                                             ON MovementDate_StartSale.MovementId = Movement_Promo.Id
                                                            AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
                                                            AND MovementDate_StartSale.ValueData <= CURRENT_DATE + INTERVAL '10 DAY'
                                           JOIN MovementDate AS MovementDate_EndSale
                                                             ON MovementDate_EndSale.MovementId = Movement_Promo.Id
                                                            AND MovementDate_EndSale.DescId     = zc_MovementDate_EndSale()
                                                            AND MovementDate_EndSale.ValueData  >= CURRENT_DATE  - INTERVAL '10 DAY'
                                           JOIN MovementItem AS MovementItem_PromoGoods 
                                                             ON MovementItem_PromoGoods.MovementId = Movement_Promo.Id
                                                            AND MovementItem_PromoGoods.DescId     = zc_MI_Master()
                                                            AND MovementItem_PromoGoods.IsErased   = FALSE
                                      WHERE Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
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
                , tmpPromo AS (SELECT DISTINCT tmpPromoPartner.PromoId AS Id
                                    , tmpPromoPartner.InvNumber
                                    , tmpPromoPartner.Operdate
                                    , tmpPromoPartner.StatusId
                                    , tmpPromoPartner.StartSale
                                    , tmpPromoPartner.EndSale
                               FROM tmpPromoPartner
                               WHERE tmpPromoPartner.RowNum = 1
                              )
             SELECT tmpPromo.Id
                  , tmpPromo.InvNumber
                  , tmpPromo.Operdate
                  , tmpPromo.StatusId
                  , MIN ((tmpPromo.StartSale - INTERVAL '0 DAY')) :: TDateTime AS StartSale
                  , MAX (tmpPromo.EndSale)                        :: TDateTime AS EndSale
                  , (MI_Child.ObjectId IS NULL)          AS isChangePercent
                  , MovementString_CommentMain.ValueData AS CommentMain
                  , TRUE                      :: Boolean AS isSync  
             FROM tmpPromo
                  LEFT JOIN MovementItem AS MI_Child
                                         ON MI_Child.MovementId = tmpPromo.Id
                                        AND MI_Child.DescId = zc_MI_Child() 
                                        AND MI_Child.ObjectId = zc_Enum_ConditionPromo_ContractChangePercentOff() -- без учета % скидки по договору
                                        AND NOT MI_Child.isErased
                  LEFT JOIN MovementString AS MovementString_CommentMain
                                           ON MovementString_CommentMain.MovementId = tmpPromo.Id
                                          AND MovementString_CommentMain.DescId = zc_MovementString_CommentMain() 
             GROUP BY tmpPromo.Id
                    , tmpPromo.InvNumber
                    , tmpPromo.Operdate
                    , tmpPromo.StatusId
                    , (MI_Child.ObjectId IS NULL)
                    , MovementString_CommentMain.ValueData
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
 16.03.17                                                                          *
*/

-- SELECT * FROM gpSelectMobile_Movement_Promo (inSyncDateIn:= zc_DateStart(), inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelectMobile_Movement_Promo (inSyncDateIn:= zc_DateStart(), inSession:= '1068282')
