-- Function: gpInsertUpdate_MI_PromoStat_Master()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PromoStat_Master (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PromoStat_Master(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
   DECLARE vbUnitId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Promo());

     -- нашли - на какую дату берем условие
     (SELECT MovementDate_StartSale.ValueData - INTERVAL '1 DAY'
           , MovementDate_StartSale.ValueData - INTERVAL '6 MONTH' - INTERVAL '1 DAY'
           , MovementLinkObject_Unit.ObjectId AS UnitId
    INTO vbEndDate, vbStartDate, vbUnitId
      FROM Movement
           LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
      WHERE Movement.Id = inMovementId
     );

    --таблица статистики продаж
    CREATE TEMP TABLE _tmpData (GoodsId Integer, GoodsKindId Integer, StartDate TDateTime, EndDate TDateTime
                              , Amount1 TFloat, Amount2 TFloat, Amount3 TFloat, Amount4 TFloat, Amount5 TFloat, Amount6 TFloat, Amount7 TFloat) ON COMMIT DROP;

    INSERT INTO _tmpData (GoodsId, GoodsKindId, StartDate, EndDate, Amount1, Amount2, Amount3, Amount4, Amount5, Amount6, Amount7)
     WITH -- Список товара
          tmpGoods AS (SELECT DISTINCT MovementItem.ObjectId  AS GoodsId                --ИД объекта <товар>
                            , MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                       FROM MovementItem
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind 
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId = zc_MI_Master()
                         AND MovementItem.isErased = FALSE
                        )
        -- контрагенты
        , tmpPromoPartner AS (SELECT MI_PromoPartner.ObjectId        AS PartnerId   --ИД объекта <партнер>
                              FROM Movement AS Movement_PromoPartner
                                   INNER JOIN MovementItem AS MI_PromoPartner
                                                           ON MI_PromoPartner.MovementId = Movement_PromoPartner.ID
                                                          AND MI_PromoPartner.DescId = zc_MI_Master()
                                                          AND MI_PromoPartner.IsErased = FALSE
                              WHERE Movement_PromoPartner.ParentId = inMovementId
                                AND Movement_PromoPartner.DescId = zc_Movement_PromoPartner()
                             )
        -- список дат больше периода для того чтоб правильно определить даты для выбора продаж - пол года пока
        , tmpListDate AS (SELECT generate_series('01.01.2021'::TDateTime, '31.08.2021'::TDateTime, '1 DAY'::interval) AS OperDate)
        --выбираем документы акций чтоб определить даты продаж по акциям, их нужно исключить из статистики
        , tmpMovPromo AS (SELECT Movement_Promo.*
                               , MovementDate_StartSale.ValueData  AS StartSale          --Дата начала отгрузки по акционной цене
                               , MovementDate_EndSale.ValueData    AS EndSale            --Дата окончания отгрузки по акционной цене
                               , MovementLinkObject_Unit.ObjectId  AS UnitId
                          FROM Movement AS Movement_Promo
                             LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement_Promo.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
   
                             LEFT JOIN MovementDate AS MovementDate_StartSale
                                                    ON MovementDate_StartSale.MovementId = Movement_Promo.Id
                                                   AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
                             LEFT JOIN MovementDate AS MovementDate_EndSale
                                                    ON MovementDate_EndSale.MovementId = Movement_Promo.Id
                                                   AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
   
                          WHERE Movement_Promo.DescId = zc_Movement_Promo()
                           AND (MovementDate_StartSale.ValueData BETWEEN vbStartDate AND vbEndDate
                                OR vbStartDate BETWEEN MovementDate_StartSale.ValueData AND MovementDate_EndSale.ValueData
                                )
                           AND (MovementLinkObject_Unit.ObjectId = inUnitId OR COALESCE (inUnitId,0) = 0)
                           AND Movement_Promo.StatusId <> zc_Enum_Status_Erased()
                          )
        --ограничиваем Контрагентами из гл.док. Акции
        , tmpMovPromoPartner AS (SELECT DISTINCT Movement_PromoPartner.ParentId AS MovementId  --ИД объекта <акция>
                                 FROM Movement AS Movement_PromoPartner
                                      INNER JOIN MovementItem AS MI_PromoPartner
                                                              ON MI_PromoPartner.MovementId = Movement_PromoPartner.ID
                                                             AND MI_PromoPartner.DescId = zc_MI_Master()
                                                             AND MI_PromoPartner.IsErased = FALSE
                                      INNER JOIN tmpPromoPartner ON tmpPromoPartner.PartnerId = MI_PromoPartner.ObjectId
                                 WHERE Movement_PromoPartner.ParentId IN (SELECT DISTINCT tmpMovPromo.Id FROM tmpMovPromo)
                                   AND Movement_PromoPartner.DescId = zc_Movement_PromoPartner()
                             )
        --по товару из гл.док. Акции
        , tmpPromoMI AS (SELECT *
                         FROM MovementItem
                              INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                         WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovPromoPartner.MovementId FROM tmpMovPromoPartner)
                           AND MovementItem.DescId = zc_MI_Master()
                           AND MovementItem.isErased = FALSE
                         )
        --даты продаж по акции
        , tmpPromo AS(SELECT DISTINCT
                             tmpMovPromo.StartSale
                           , tmpMovPromo.EndSale
                      FROM tmpMovPromo
                          INNER JOIN tmpPromoMI ON tmpPromoMI.MovementId = tmpMovPromo.Id
                      )

        --список дат для выбора продаж
        , tmpDateSale AS (SELECT tmp.OperDate
                               , ROW_NUMBER() OVER (ORDER BY tmp.OperDate) AS Ord
                          FROM (SELECT tmpListDate.* 
                                     , ROW_NUMBER() OVER (ORDER BY tmpListDate.OperDate Desc) AS Ord
                                FROM tmpListDate
                                     LEFT JOIN tmpPromo ON tmpListDate.OperDate BETWEEN tmpPromo.StartSale AND tmpPromo.EndSale
                                WHERE tmpPromo.StartSale IS NULL
                                ) AS tmp
                          WHERE tmp.Ord <=35
                          )

          -- нам нужны не акционные продажы за 35 дней 
        , tmpMovSale AS (SELECT Movement.*
                              , MD_OperDatePartner.ValueData AS OperDatePartner
                         FROM tmpDateSale
                              INNER JOIN MovementDate AS MD_OperDatePartner 
                                                      ON MD_OperDatePartner.ValueData = tmpDateSale.OperDate
                                                     AND MD_OperDatePartner.DescId = zc_MovementDate_OperDatePartner() 

                              INNER JOIN Movement ON Movement.Id       = MD_OperDatePartner.MovementId
                                                 AND Movement.DescId   = zc_Movement_Sale()
                                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                        )
        -- ограничиваем Контрагентами из док Акции
        , tmpMLO_To AS (SELECT MovementLinkObject.*
                        FROM MovementLinkObject
                             INNER JOIN tmpPromoPartner ON tmpPromoPartner.PartnerId = MovementLinkObject.ObjectId
                        WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovSale.Id FROM tmpMovSale)
                          AND MovementLinkObject.DescId = zc_MovementLinkObject_To()
                        )
        -- по товарам
        , tmpMISale_all AS (SELECT MovementItem.*
                            FROM tmpMovSale
                                 INNER JOIN tmpMLO_To ON tmpMLO_To.MovementId = tmpMovSale.Id
                                 INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovSale.Id
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                                        AND MovementItem.isErased   = FALSE
                                 INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                           )

        , tmpMIFloat_PromoMovementId AS (SELECT MovementItemFloat.*
                                         FROM MovementItemFloat
                                         WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMISale_all.Id FROM tmpMISale_all)
                                           AND MovementItemFloat.DescId IN (zc_MIFloat_PromoMovementId()
                                                                          , zc_MIFloat_AmountPartner())
                                        )

        , tmpMILO_GoodsKind AS (SELECT MILO_GoodsKind.*
                                FROM MovementItemLinkObject AS MILO_GoodsKind
                                WHERE MILO_GoodsKind.MovementItemId IN (SELECT DISTINCT tmpMISale_all.Id FROM tmpMISale_all)
                                  AND MILO_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                )
        --продажи по датам
        , tmpSale AS (SELECT tmpMovSale.OperDatePartner
                           , MovementItem.ObjectId    AS GoodsId
                           , MILO_GoodsKind.ObjectId  AS GoodsKindId
                           , SUM (CASE WHEN MIFloat_PromoMovementId.ValueData IS NULL THEN COALESCE (MIFloat_AmountPartner.ValueData,0) ELSE 0 END) AS AmountPartner
                           --, SUM (COALESCE (MIFloat_AmountPartner.ValueData,0)) AS AmountPartner
                      FROM tmpMovSale
                           INNER JOIN tmpMISale_all AS MovementItem
                                                    ON MovementItem.MovementId = tmpMovSale.Id

                           LEFT JOIN tmpMIFloat_PromoMovementId AS MIFloat_PromoMovementId
                                                                ON MIFloat_PromoMovementId.MovementItemId = MovementItem.Id
                                                               AND MIFloat_PromoMovementId.DescId         = zc_MIFloat_PromoMovementId()
                           LEFT JOIN tmpMIFloat_PromoMovementId AS MIFloat_AmountPartner
                                                                ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                               AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                           LEFT JOIN tmpMILO_GoodsKind AS MILO_GoodsKind
                                                       ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                      AND MILO_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                           LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILO_GoodsKind.ObjectId
                      WHERE MIFloat_PromoMovementId.ValueData IS NULL                                              --не берем акционные продажи
                      GROUP BY tmpMovSale.OperDatePartner
                             , MovementItem.ObjectId
                             , MILO_GoodsKind.ObjectId
                      )
        --таблица групп дат (групп периодов)
                 -- группу получаем как разница даты с конкретной , например vbStartDate  минус номер по порядку (удаленность от даты) получаем один.значение для дат по периодам
                 --Это и будут группы,  далее по ним сгруппируем и получим мин и макс
        , tmpGroupPeriod AS (SELECT MIN(t.OperDate) AS StartDate, MAX(t.OperDate) AS EndDate
                             FROM (SELECT t1.OperDate
                                       --, (DATE_PART ('DAY',(t2.OperDate - t1.OperDate ) )) ::TFloat as Days
                                       , (DATE_PART ('DAY',(t1.OperDate - vbStartDate::TDateTime)) - t2.ord) AS grp  
                                   FROM tmpDateSale AS t1
                                        LEFT JOIN tmpDateSale AS t2 ON t2.ord = t1.ord +1
                                   ORDER BY t1.ord
                                   ) AS t
                             GROUP BY grp
                             )
        --Результат
        SELECT tmpSale.GoodsId
             , tmpSale.GoodsKindId
             , tmpGroupPeriod.StartDate
             , tmpGroupPeriod.EndDate
             , SUM (CASE WHEN tmpWeekDay.Number = 1 THEN tmpSale.AmountPartner ELSE 0 END) Amount1
             , SUM (CASE WHEN tmpWeekDay.Number = 2 THEN tmpSale.AmountPartner ELSE 0 END) Amount2
             , SUM (CASE WHEN tmpWeekDay.Number = 3 THEN tmpSale.AmountPartner ELSE 0 END) Amount3
             , SUM (CASE WHEN tmpWeekDay.Number = 4 THEN tmpSale.AmountPartner ELSE 0 END) Amount4
             , SUM (CASE WHEN tmpWeekDay.Number = 5 THEN tmpSale.AmountPartner ELSE 0 END) Amount5
             , SUM (CASE WHEN tmpWeekDay.Number = 6 THEN tmpSale.AmountPartner ELSE 0 END) Amount6
             , SUM (CASE WHEN tmpWeekDay.Number = 7 THEN tmpSale.AmountPartner ELSE 0 END) Amount7
        FROM  tmpSale
             LEFT JOIN tmpDateSale ON tmpDateSale.OperDate = tmpSale.OperDatePartner
             LEFT JOIN zfCalc_DayOfWeekName (tmpSale.OperDatePartner) AS tmpWeekDay ON 1=1
             LEFT JOIN tmpGroupPeriod ON tmpDateSale.OperDate >= tmpGroupPeriod.StartDate AND tmpDateSale.OperDate <= tmpGroupPeriod.EndDate
        GROUP BY tmpSale.GoodsId
               , tmpSale.GoodsKindId
               , tmpGroupPeriod.StartDate
               , tmpGroupPeriod.EndDate
        HAVING SUM (CASE WHEN tmpWeekDay.Number = 1 THEN tmpSale.AmountPartner ELSE 0 END) <> 0
            OR SUM (CASE WHEN tmpWeekDay.Number = 2 THEN tmpSale.AmountPartner ELSE 0 END) <> 0
            OR SUM (CASE WHEN tmpWeekDay.Number = 3 THEN tmpSale.AmountPartner ELSE 0 END) <> 0
            OR SUM (CASE WHEN tmpWeekDay.Number = 4 THEN tmpSale.AmountPartner ELSE 0 END) <> 0
            OR SUM (CASE WHEN tmpWeekDay.Number = 5 THEN tmpSale.AmountPartner ELSE 0 END) <> 0
            OR SUM (CASE WHEN tmpWeekDay.Number = 6 THEN tmpSale.AmountPartner ELSE 0 END) <> 0
            OR SUM (CASE WHEN tmpWeekDay.Number = 7 THEN tmpSale.AmountPartner ELSE 0 END) <> 0
        ;
------------------------------------------------------------------
       
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.09.20         *
*/

-- тест
--