-- Function: lpSelect_Movement_Promo_Auto()

DROP FUNCTION IF EXISTS lpSelect_Movement_Promo_Auto (Integer, Integer);

CREATE OR REPLACE FUNCTION lpSelect_Movement_Promo_Auto(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inUserId                Integer     -- сессия пользователя
)
RETURNS TABLE(MovementId           Integer   --ИД документа акции
            , MovementItemId       Integer   --  
            , GoodsId              Integer
            , GoodsKindId          Integer
            , DateMonth            TDateTime
            , AmountReal           TFloat
            , AmountRealPromo      TFloat
            , AmountRetIn          TFloat
            , AmountRealWeight           TFloat
            , AmountRealPromoWeight      TFloat
            , AmountRetInWeight          TFloat
)
AS
$BODY$
   DECLARE vbTmpId     Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate   TDateTime;
   DECLARE vbUnitId    Integer;
   DECLARE vbStartPeriod_1 TDateTime;
   DECLARE vbEndPeriod_1   TDateTime;
   DECLARE vbStartPeriod_2 TDateTime;
   DECLARE vbEndPeriod_2   TDateTime;
   DECLARE vbPeriod_1      TDateTime;
   DECLARE vbPeriod_2      TDateTime;
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
     SELECT Movement_Promo_View.OperDateStart
          , Movement_Promo_View.OperDateEnd
          , COALESCE (Movement_Promo_View.UnitId, 0) AS UnitId

          , DATE_TRUNC ('MONTH', Movement_Promo_View.StartPromo) AS Period_1
                     , DATE_TRUNC ('MONTH', Movement_Promo_View.EndPromo)   AS Period_2
                     
                     , Movement_Promo_View.OperDateStart                                   AS StartPeriod_1
                     , Movement_Promo_View.OperDateStart 
                     + CASE WHEN DATE_TRUNC ('MONTH', Movement_Promo_View.StartPromo) <> DATE_TRUNC ('MONTH', Movement_Promo_View.EndPromo)
                            THEN (DATE_TRUNC ('MONTH', Movement_Promo_View.EndPromo)- INTERVAL '1 day') - Movement_Promo_View.StartPromo + INTERVAL '1 day'
                            ELSE Movement_Promo_View.EndPromo - Movement_Promo_View.StartPromo + INTERVAL '1 day'
                       END 
                     - INTERVAL '1 day' AS EndPeriod_1
                     , Movement_Promo_View.OperDateStart
                     + CASE WHEN DATE_TRUNC ('MONTH', Movement_Promo_View.StartPromo) <> DATE_TRUNC ('MONTH', Movement_Promo_View.EndPromo)
                            THEN (DATE_TRUNC ('MONTH', Movement_Promo_View.EndPromo)- INTERVAL '1 day') - Movement_Promo_View.StartPromo + INTERVAL '1 day'
                            ELSE Movement_Promo_View.EndPromo - Movement_Promo_View.StartPromo + INTERVAL '1 day'
                       END                    AS StartPeriod_2
                     , Movement_Promo_View.OperDateStart
                     + CASE WHEN DATE_TRUNC ('MONTH', Movement_Promo_View.StartPromo) <> DATE_TRUNC ('MONTH', Movement_Promo_View.EndPromo)
                            THEN (DATE_TRUNC ('MONTH', Movement_Promo_View.EndPromo)- INTERVAL '1 day') - Movement_Promo_View.StartPromo + INTERVAL '1 day'
                            ELSE Movement_Promo_View.EndPromo - Movement_Promo_View.StartPromo + INTERVAL '1 day'
                       END
                     + CASE WHEN DATE_TRUNC ('MONTH', Movement_Promo_View.StartPromo) <> DATE_TRUNC ('MONTH', Movement_Promo_View.EndPromo)
                            THEN Movement_Promo_View.EndPromo - DATE_TRUNC ('MONTH', Movement_Promo_View.EndPromo) + INTERVAL '1 day'
                            ELSE INTERVAL '0 day'
                       END     AS EndPeriod_2

            INTO vbStartDate, vbEndDate, vbUnitId,vbPeriod_1, vbPeriod_2,  vbStartPeriod_1, vbEndPeriod_1, vbStartPeriod_2, vbEndPeriod_2
     FROM Movement_Promo_View
     WHERE Movement_Promo_View.Id = inMovementId
    ;

 --RAISE EXCEPTION 'Ошибка.%  %   %   %  % % %', vbPeriod_1 ;
    RETURN QUERY
    WITH
  /* _tmpPartner_new AS (SELECT tmp.MovementId, tmp.PartnerId, tmp.ContractId FROM lpSelect_Movement_PromoPartner_Detail (inMovementId:= inMovementId) AS tmp
                    )
    -- док.продаж
   ,*/ tmpMovement_sale AS (SELECT Movement.Id AS MovementId
                               , CASE WHEN COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) BETWEEN vbStartPeriod_1 AND vbEndPeriod_1
                                      THEN vbPeriod_1
                                      ELSE vbPeriod_2
                                 END AS DateMonth
                         FROM _tmpPartner_new AS tmpPartner
                              INNER JOIN MovementLinkObject AS MLO_To ON MLO_To.ObjectId = tmpPartner.PartnerId
                                                                     AND MLO_To.DescId = zc_MovementLinkObject_To()
                              INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                                      ON MovementDate_OperDatePartner.ValueData BETWEEN vbStartPeriod_1 AND vbEndPeriod_2
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
  , tmpMovement_ReturnIn AS (SELECT Movement.Id AS MovementId
                                  , CASE WHEN COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) BETWEEN vbStartPeriod_1 AND vbEndPeriod_1
                                      THEN vbPeriod_1
                                      ELSE vbPeriod_2
                                 END AS DateMonth
                             FROM _tmpPartner_new AS tmpPartner
                                  INNER JOIN MovementLinkObject AS MLO_From ON MLO_From.ObjectId = tmpPartner.PartnerId
                                                                           AND MLO_From.DescId   = zc_MovementLinkObject_From()
                                  INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                                          ON MovementDate_OperDatePartner.ValueData BETWEEN vbStartPeriod_1 AND vbEndPeriod_2
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
                             , MI_PromoGoods.GoodsWeight
                             , MI_PromoGoods.MeasureId
                        FROM MovementItem_PromoGoods_View AS MI_PromoGoods
                        WHERE MI_PromoGoods.MovementId = inMovementId
                          AND MI_PromoGoods.isErased = FALSE
                       )
      , tmpMI_promo AS (SELECT -- т.е. если установлено "для всех GoodsKindId" - запишем в него, иначе получится дублирование
                               MAX (COALESCE (tmpMI_promo_all_find.MovementItemId, tmpMI_promo_all.MovementItemId)) AS MovementItemId
                             , tmpMI_promo_all.GoodsId
                             , COALESCE (tmpMI_promo_all_find.GoodsKindId, tmpMI_promo_all.GoodsKindId) AS GoodsKindId
                             , tmpMI_promo_all.GoodsWeight
                             , tmpMI_promo_all.MeasureId
                        FROM tmpMI_promo_all
                             LEFT JOIN tmpMI_promo_all AS tmpMI_promo_all_find ON tmpMI_promo_all_find.GoodsId     = tmpMI_promo_all.GoodsId
                                                                              AND tmpMI_promo_all_find.GoodsKindId = 0
                                                                             -- AND tmpMI_promo_all_find.isErased    = FALSE
                        --WHERE tmpMI_promo_all.isErased = FALSE
                          -- AND (tmpMI_promo_all.GoodsKindId = 0 OR tmpMI_promo_all_find.GoodsId IS NULL) -- т.е. если установлено "для всех GoodsKindId" - надо откинуть с GoodsKindId <> 0, иначе получится дублирование
                        GROUP BY tmpMI_promo_all.GoodsId
                               , COALESCE (tmpMI_promo_all_find.GoodsKindId, tmpMI_promo_all.GoodsKindId)
                               , tmpMI_promo_all.GoodsWeight
                               , tmpMI_promo_all.MeasureId
                       )
        , tmpMI_sale AS (SELECT tmpMI_promo.MovementItemId AS MovementItemId_promo
                              , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS AmountPartner
                              , SUM (CASE WHEN COALESCE (MIFloat_PromoMovement.MovementItemId, 0) > 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS AmountPartnerPromo
                              , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)
                                     * CASE WHEN tmpMI_promo.MeasureId = zc_Measure_Sh() THEN tmpMI_promo.GoodsWeight ELSE 1 END) AS AmountPartnerWeight
                              , SUM (CASE WHEN COALESCE (MIFloat_PromoMovement.MovementItemId, 0) > 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END
                                     * CASE WHEN tmpMI_promo.MeasureId = zc_Measure_Sh() THEN tmpMI_promo.GoodsWeight ELSE 1 END) AS AmountPartnerPromoWeight
                              , tmpMovement_sale.DateMonth
                         FROM tmpMovement_sale
                              INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement_sale.MovementId
                                                     AND MovementItem.DescId = zc_MI_Master()
                                                     AND MovementItem.isErased = FALSE
                              LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                                          ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                                         AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                                                         AND MIFloat_PromoMovement.ValueData <> 0
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                               ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                              INNER JOIN tmpMI_promo ON tmpMI_promo.GoodsId = MovementItem.ObjectId
                                                     AND (tmpMI_promo.GoodsKindId = MILinkObject_GoodsKind.ObjectId OR tmpMI_promo.GoodsKindId = 0)
                              LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                          ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                         AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                         GROUP BY tmpMI_promo.MovementItemId, tmpMovement_sale.DateMonth
                        )
   
   , tmpMI_ReturnIn AS (SELECT tmpMI_promo.MovementItemId AS MovementItemId_promo
                             , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS AmountPartner
                             , SUM (CASE WHEN COALESCE (MIFloat_PromoMovement.MovementItemId, 0) > 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS AmountPartnerPromo
                             , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)
                                   * CASE WHEN tmpMI_promo.MeasureId = zc_Measure_Sh() THEN tmpMI_promo.GoodsWeight ELSE 1 END) AS AmountPartnerWeight
                             , SUM (CASE WHEN COALESCE (MIFloat_PromoMovement.MovementItemId, 0) > 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END
                                   * CASE WHEN tmpMI_promo.MeasureId = zc_Measure_Sh() THEN tmpMI_promo.GoodsWeight ELSE 1 END) AS AmountPartnerPromoWeight
                             , tmpMovement_ReturnIn.DateMonth
                        FROM tmpMovement_ReturnIn
                             INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement_ReturnIn.MovementId
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE
                             LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                                         ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                                        AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                                                        AND MIFloat_PromoMovement.ValueData <> 0
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                             INNER JOIN tmpMI_promo ON tmpMI_promo.GoodsId      = MovementItem.ObjectId
                                                   AND (tmpMI_promo.GoodsKindId = MILinkObject_GoodsKind.ObjectId OR tmpMI_promo.GoodsKindId = 0)
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                         ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                        GROUP BY tmpMI_promo.MovementItemId, tmpMovement_ReturnIn.DateMonth
                       )
                     
                     
                SELECT inMovementId AS MovementId
                     , tmpMI_promo_all.MovementItemId
                     , tmpMI_promo_all.GoodsId
                     , tmpMI_promo_all.GoodsKindId 
                     , COALESCE (tmpMI_sale.DateMonth, tmpMI_ReturnIn.DateMonth) ::TDateTime AS DateMonth 
                     , COALESCE (tmpMI_sale.AmountPartner, 0)      ::TFloat AS AmountReal
                     , COALESCE (tmpMI_sale.AmountPartnerPromo, 0) ::TFloat AS AmountRealPromo
                     , COALESCE (tmpMI_ReturnIn.AmountPartner, 0)  ::TFloat AS AmountRetIn
                     , COALESCE (tmpMI_sale.AmountPartnerWeight, 0)      ::TFloat AS AmountRealWeight
                     , COALESCE (tmpMI_sale.AmountPartnerPromoWeight, 0) ::TFloat AS AmountRealPromoWeight
                     , COALESCE (tmpMI_ReturnIn.AmountPartnerWeight, 0)  ::TFloat AS AmountRetInWeight
                FROM tmpMI_promo_all
                     LEFT JOIN tmpMI_promo ON tmpMI_promo.MovementItemId      = tmpMI_promo_all.MovementItemId
                     LEFT JOIN tmpMI_sale  ON tmpMI_sale.MovementItemId_promo = tmpMI_promo.MovementItemId
                     LEFT JOIN tmpMI_ReturnIn ON tmpMI_ReturnIn.MovementItemId_promo = tmpMI_promo.MovementItemId
                                             AND tmpMI_ReturnIn.DateMonth = tmpMI_sale.DateMonth
                WHERE COALESCE (tmpMI_sale.AmountPartner, 0) <> 0
                   OR COALESCE (tmpMI_sale.AmountPartnerPromo, 0)  <> 0
                   OR COALESCE (tmpMI_ReturnIn.AmountPartner, 0) <> 0
                ;
DROP TABLE _tmpPartner_new;  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.12.24         *
*/

-- тест
-- SELECT * FROM lpSelect_Movement_Promo_Auto (inMovementId:= 28690908    , inUserId:= zfCalc_UserAdmin() :: Integer) AS spSelect

/*
SELECT * 
FROM (SELECT 29034623 AS ID
    UNION SELECT 29352454 AS ID
    UNION SELECT 29201559 AS ID
    UNION SELECT 28690908 AS ID
      ) AS tmp
    LEFT JOIN lpSelect_Movement_Promo_Auto (inMovementId:= tmp.Id, inUserId:= zfCalc_UserAdmin() :: Integer) AS spSelect On 1 = 1 --spSelect.MovementId = tmp.Id
order by 1, 3,4, 4
*/
