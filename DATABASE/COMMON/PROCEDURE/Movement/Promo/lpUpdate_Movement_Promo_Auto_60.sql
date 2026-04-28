-- Function: lpUpdate_Movement_Promo_Auto_60()

DROP FUNCTION IF EXISTS lpUpdate_Movement_Promo_Auto_60 (Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Movement_Promo_Auto_60(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inUserId                Integer     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbTmpId        Integer;
   DECLARE vbStartDate    TDateTime;
   DECLARE vbEndDate      TDateTime;
   DECLARE vbUnitId       Integer;
   DECLARE vbStartDate_60 TDateTime;
   DECLARE vbEndDate_60   TDateTime;
   DECLARE vbStartDate_calc TDateTime;
   DECLARE vbEndDate_calc   TDateTime;
BEGIN
/*
if inUserId = 5 then
         RAISE EXCEPTION 'Ошибка.';
end if;
*/



     -- данные по "новым" контрагентам
     CREATE TEMP TABLE _tmpPartner_new (MovementId Integer, PartnerId Integer, ContractId Integer) ON COMMIT DROP;
     INSERT INTO _tmpPartner_new (MovementId, PartnerId, ContractId)
        SELECT tmp.MovementId, tmp.PartnerId, tmp.ContractId FROM lpSelect_Movement_PromoPartner_Detail (inMovementId:= inMovementId) AS tmp;



     -- параметры из документа <Акции>
     SELECT -- Дата начала расч. продаж до акции
            Movement_Promo_View.OperDateStart
            -- 	Дата окончания расч. продаж до акции
          , Movement_Promo_View.OperDateEnd

            -- Дата документа
          , Movement_Promo_View.OperDate - INTERVAL '60 DAY'
          , Movement_Promo_View.OperDate - INTERVAL '1 DAY'

            -- Дата начала отгрузки по акционной цене
        --, Movement_Promo_View.StartSale - INTERVAL '60 DAY'
        --, Movement_Promo_View.StartSale - INTERVAL '1 DAY'
           -- Дата начала акции
        --, Movement_Promo_View.StartPromo - INTERVAL '60 DAY'
        --, Movement_Promo_View.StartPromo - INTERVAL '1 DAY'

            --
          , COALESCE (Movement_Promo_View.UnitId, 0)

            --
            INTO vbStartDate, vbEndDate
               , vbStartDate_60, vbEndDate_60
               , vbUnitId

     FROM Movement_Promo_View
     WHERE Movement_Promo_View.Id = inMovementId
    ;


     --
     vbStartDate_calc:= vbStartDate_60;
     vbEndDate_calc  := vbEndDate_60;


     --RAISE EXCEPTION 'Ошибка.<%> <%>  <%> <%>   <%> <%>', vbStartDate, vbEndDate, vbStartDate_60, vbEndDate_60, vbStartDate_calc, vbEndDate_calc;

     -- сохранение данных по продажам за аналогичный период
     vbTmpId:= (WITH tmpMovement_sale AS
                        (SELECT Movement.Id AS MovementId, MovementDate_OperDatePartner.ValueData AS OperDatePartner
                         FROM _tmpPartner_new AS tmpPartner
                              INNER JOIN MovementLinkObject AS MLO_To ON MLO_To.ObjectId = tmpPartner.PartnerId
                                                                     AND MLO_To.DescId = zc_MovementLinkObject_To()
                              INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                                      ON MovementDate_OperDatePartner.ValueData BETWEEN vbStartDate_calc - INTERVAL '0 DAY' AND vbEndDate_calc + INTERVAL '0 DAY'
                                                     AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                                     AND MovementDate_OperDatePartner.MovementId = MLO_To.MovementId
                              INNER JOIN Movement ON Movement.Id = MLO_To.MovementId
                                                 AND Movement.DescId = zc_Movement_Sale()
                                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                              LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = MLO_To.MovementId
                                                                      AND MLO_From.DescId = zc_MovementLinkObject_From()
                              LEFT JOIN MovementLinkObject AS MLO_Contract ON MLO_Contract.MovementId = MLO_To.MovementId
                                                                          AND MLO_Contract.DescId = zc_MovementLinkObject_Contract()
                         WHERE (MLO_From.ObjectId = vbUnitId OR vbUnitId = 0)
                           AND (MLO_Contract.ObjectId = tmpPartner.ContractId OR tmpPartner.ContractId = 0)
                        )
    -- док.возвраты
  , tmpMovement_ReturnIn AS (SELECT Movement.Id AS MovementId, MovementDate_OperDatePartner.ValueData AS OperDatePartner
                             FROM _tmpPartner_new AS tmpPartner
                                  INNER JOIN MovementLinkObject AS MLO_From ON MLO_From.ObjectId = tmpPartner.PartnerId
                                                                           AND MLO_From.DescId   = zc_MovementLinkObject_From()
                                  INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                                          ON MovementDate_OperDatePartner.ValueData BETWEEN vbStartDate_calc - INTERVAL '0 DAY' AND vbEndDate_calc + INTERVAL '0 DAY'
                                                         AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                                         AND MovementDate_OperDatePartner.MovementId = MLO_From.MovementId
                                  INNER JOIN Movement ON Movement.Id       = MLO_From.MovementId
                                                     AND Movement.DescId   = zc_Movement_ReturnIn()
                                                     AND Movement.StatusId = zc_Enum_Status_Complete()
                                  LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = MLO_From.MovementId
                                                                        AND MLO_To.DescId = zc_MovementLinkObject_To()
                                  LEFT JOIN MovementLinkObject AS MLO_Contract ON MLO_Contract.MovementId = MLO_From.MovementId
                                                                              AND MLO_Contract.DescId = zc_MovementLinkObject_Contract()
                             WHERE (MLO_To.ObjectId = vbUnitId OR vbUnitId = 0)
                               AND (MLO_Contract.ObjectId = tmpPartner.ContractId OR tmpPartner.ContractId = 0)
                            )

  , tmpMI_promo_all AS (SELECT MI_PromoGoods.Id AS MovementItemId
                             , MI_PromoGoods.GoodsId
                             , CASE WHEN MI_PromoGoods.GoodsKindId > 0 THEN MI_PromoGoods.GoodsKindId ELSE COALESCE (MI_PromoGoods.GoodsKindCompleteId, 0) END AS GoodsKindId
                           --, COALESCE (MI_PromoGoods.GoodsKindCompleteId, 0) AS GoodsKindId -- GoodsKindCompleteId
                           --, 0 AS GoodsKindId
                             , MI_PromoGoods.isErased
                        FROM MovementItem_PromoGoods_View AS MI_PromoGoods
                        WHERE MI_PromoGoods.MovementId = inMovementId
                       )
      , tmpMI_promo AS (SELECT -- т.е. если установлено "для всех GoodsKindId" - запишем в него, иначе получится дублирование
                               MAX (COALESCE (tmpMI_promo_all_find.MovementItemId, tmpMI_promo_all.MovementItemId)) AS MovementItemId
                             , tmpMI_promo_all.GoodsId
                             , COALESCE (tmpMI_promo_all_find.GoodsKindId, tmpMI_promo_all.GoodsKindId) AS GoodsKindId
                        FROM tmpMI_promo_all
                             LEFT JOIN tmpMI_promo_all AS tmpMI_promo_all_find ON tmpMI_promo_all_find.GoodsId     = tmpMI_promo_all.GoodsId
                                                                              AND tmpMI_promo_all_find.GoodsKindId = 0
                                                                              AND tmpMI_promo_all_find.isErased    = FALSE
                        WHERE tmpMI_promo_all.isErased = FALSE
                          -- AND (tmpMI_promo_all.GoodsKindId = 0 OR tmpMI_promo_all_find.GoodsId IS NULL) -- т.е. если установлено "для всех GoodsKindId" - надо откинуть с GoodsKindId <> 0, иначе получится дублирование
                        GROUP BY tmpMI_promo_all.GoodsId
                               , COALESCE (tmpMI_promo_all_find.GoodsKindId, tmpMI_promo_all.GoodsKindId)
                       )
        , tmpMI_sale AS (SELECT tmpMI_promo.MovementItemId AS MovementItemId_promo
                                --
                              , SUM (CASE WHEN tmpMovement_sale.OperDatePartner BETWEEN vbStartDate_60 AND vbEndDate_60 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS AmountPartner_60
                              , SUM (CASE WHEN tmpMovement_sale.OperDatePartner BETWEEN vbStartDate_60 AND vbEndDate_60 AND MIFloat_PromoMovement.MovementItemId > 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS AmountPartnerPromo_60
                         FROM tmpMovement_sale
                              INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement_sale.MovementId
                                                     AND MovementItem.DescId = zc_MI_Master()
                                                     AND MovementItem.isErased = FALSE
                              LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                                          ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                                         AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                                                         AND MIFloat_PromoMovement.ValueData > 0
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                               ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                              INNER JOIN tmpMI_promo ON tmpMI_promo.GoodsId = MovementItem.ObjectId
                                                     AND (tmpMI_promo.GoodsKindId = MILinkObject_GoodsKind.ObjectId OR tmpMI_promo.GoodsKindId = 0)
                              LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                          ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                         AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                         GROUP BY tmpMI_promo.MovementItemId
                        )

   , tmpMI_ReturnIn AS (SELECT tmpMI_promo.MovementItemId AS MovementItemId_promo
                               --
                             , SUM (CASE WHEN tmpMovement_ReturnIn.OperDatePartner BETWEEN vbStartDate_60 AND vbEndDate_60 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS AmountPartner_60
                             , SUM (CASE WHEN tmpMovement_ReturnIn.OperDatePartner BETWEEN vbStartDate_60 AND vbEndDate_60 AND MIFloat_PromoMovement.MovementItemId > 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS AmountPartnerPromo_60

                        FROM tmpMovement_ReturnIn
                             INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement_ReturnIn.MovementId
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE
                             LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                                         ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                                        AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                                                        AND MIFloat_PromoMovement.ValueData > 0
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                             INNER JOIN tmpMI_promo ON tmpMI_promo.GoodsId      = MovementItem.ObjectId
                                                   AND (tmpMI_promo.GoodsKindId = MILinkObject_GoodsKind.ObjectId OR tmpMI_promo.GoodsKindId = 0)
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                         ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                        GROUP BY tmpMI_promo.MovementItemId
                       )


                SELECT MIN (tmp.tmpId)
                FROM (SELECT -- 1.2. Объем продаж 60 дней (итого)
                             CASE lpInsertUpdate_MovementItemFloat (inDescId        := zc_MIFloat_AmountReal_60()
                                                                  , inMovementItemId:= tmpMI_promo_all.MovementItemId
                                                                  , inValueData     := COALESCE (tmpMI_sale.AmountPartner_60, 0)
                                                                   )
                                   WHEN TRUE THEN 0
                                   ELSE -1 -- т.е. показать ошибку
                             END AS tmpId
                      FROM tmpMI_promo_all
                           LEFT JOIN tmpMI_promo ON tmpMI_promo.MovementItemId      = tmpMI_promo_all.MovementItemId
                           LEFT JOIN tmpMI_sale  ON tmpMI_sale.MovementItemId_promo = tmpMI_promo.MovementItemId


                     UNION
                      SELECT -- 2.2. Объем Акционных продаж 60 дней
                             CASE lpInsertUpdate_MovementItemFloat (inDescId        := zc_MIFloat_AmountRealPromo_60()
                                                                  , inMovementItemId:= tmpMI_promo_all.MovementItemId
                                                                  , inValueData     := COALESCE (tmpMI_sale.AmountPartnerPromo_60, 0)
                                                                   )
                                   WHEN TRUE THEN 0
                                   ELSE -1 -- т.е. показать ошибку
                             END AS tmpId

                      FROM tmpMI_promo_all
                           LEFT JOIN tmpMI_promo ON tmpMI_promo.MovementItemId      = tmpMI_promo_all.MovementItemId
                           LEFT JOIN tmpMI_sale  ON tmpMI_sale.MovementItemId_promo = tmpMI_promo.MovementItemId


                     UNION
                      SELECT -- 3.2. Кол-во возврат 60 дней
                             CASE lpInsertUpdate_MovementItemFloat (inDescId        := zc_MIFloat_AmountRetIn_60()
                                                                  , inMovementItemId:= tmpMI_promo_all.MovementItemId
                                                                  , inValueData     := COALESCE (tmpMI_ReturnIn.AmountPartner_60, 0)
                                                                   )
                                   WHEN TRUE THEN 0
                                   ELSE -1 -- т.е. показать ошибку
                             END AS tmpId

                      FROM tmpMI_promo_all
                           LEFT JOIN tmpMI_promo    ON tmpMI_promo.MovementItemId          = tmpMI_promo_all.MovementItemId
                           LEFT JOIN tmpMI_ReturnIn ON tmpMI_ReturnIn.MovementItemId_promo = tmpMI_promo.MovementItemId

                     UNION
                      SELECT -- 4.2. Кол-во возврат Акция 60 дней
                             CASE lpInsertUpdate_MovementItemFloat (inDescId        := zc_MIFloat_AmountRetInPromo_60()
                                                                  , inMovementItemId:= tmpMI_promo_all.MovementItemId
                                                                  , inValueData     := COALESCE (tmpMI_ReturnIn.AmountPartnerPromo_60, 0)
                                                                   )
                                   WHEN TRUE THEN 0
                                   ELSE -1 -- т.е. показать ошибку
                             END AS tmpId

                      FROM tmpMI_promo_all
                           LEFT JOIN tmpMI_promo    ON tmpMI_promo.MovementItemId          = tmpMI_promo_all.MovementItemId
                           LEFT JOIN tmpMI_ReturnIn ON tmpMI_ReturnIn.MovementItemId_promo = tmpMI_promo.MovementItemId

                     ) AS tmp
               );


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.
 26.11.15                                        *
*/

-- тест
-- SELECT * FROM lpUpdate_Movement_Promo_Auto_60 (inMovementId:= 2641111, inUserId:= zfCalc_UserAdmin() :: Integer)
