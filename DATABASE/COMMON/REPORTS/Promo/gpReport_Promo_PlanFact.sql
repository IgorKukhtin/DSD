

DROP FUNCTION IF EXISTS gpReport_Promo_PlanFact(
    TDateTime, --дата начала периода
    TDateTime, --дата окончания периода
    Boolean,   --показать только Акции
    Boolean,   --показать только Тендеры
    Boolean,   -- группировать по видам
    Integer,   --подразделение
    Integer,   --юр.лицо
    TVarChar   --сессия пользователя
);
CREATE OR REPLACE FUNCTION gpReport_Promo_PlanFact(
    IN inStartDate      TDateTime, --дата начала периода
    IN inEndDate        TDateTime, --дата окончания периода
    IN inIsPromo        Boolean,   --показать только Акции
    IN inIsTender       Boolean,   --показать только Тендеры
    IN inIsGoodsKind    Boolean,   --группировать по видам
    IN inUnitId         Integer,   --подразделение
    IN inJuridicalId    Integer,   --юр.лицо
    IN inSession        TVarChar   --сессия пользователя
)
RETURNS TABLE(
     MovementId           Integer   --ИД документа акции
    ,OperDate             TDateTime -- * Статус внесения в базу
    ,InvNumber            TVarChar   --№ документа акции
    ,StatusCode Integer, StatusName TVarChar
    ,UnitName             TVarChar  --Склад
    , DateStartSale   TDateTime       --Дата начала отгрузки по акционной цене
    , DateFinalSale     TDateTime       --Дата окончания отгрузки по акционной цене
    , DateStartPromo  TDateTime       --Дата начала акции
    , DateFinalPromo    TDateTime       --Дата окончания акции
    , MonthPromo  TDateTime       --месяц акции

    ,RetailName           TBlob     --Сеть, в которой проходит акция
    ,JuridicalName_str    TBlob     --юр.лица
    ,GoodsName            TVarChar  --Позиция
    ,GoodsCode            Integer   --Код позиции
    ,MeasureName          TVarChar  --единица измерения
    ,TradeMarkName        TVarChar  --Торговая марка
    ,AmountPlanMin        TFloat    --Планируемый объем продаж в акционный период, шт
    ,AmountPlanMinWeight  TFloat    --Планируемый объем продаж в акционный период, кг
    ,AmountPlanMax        TFloat    --Планируемый объем продаж в акционный период, шт
    ,AmountPlanMaxWeight  TFloat    --Планируемый объем продаж в акционный период, кг

    ,AmountPlanAvg             TFloat    --Планируемый объем продаж в акционный период, шт
    ,AmountPlanAvgWeight       TFloat    --Планируемый объем продаж в акционный период, кг
    ,AmountPlanAvg_calc        TFloat    --Планируемый объем продаж в акционный период, шт
    ,AmountPlanAvgWeight_calc  TFloat    --Планируемый объем продаж в акционный период, кг

    ,AmountReal           TFloat    --Объем продаж в аналогичный период, кг
    ,AmountRealWeight     TFloat    --Объем продаж в аналогичный период, кг Вес
    ,AmountOrder          TFloat    --Кол-во заявка (факт)
    ,AmountOrderWeight    TFloat    --Кол-во заявка (факт) Вес
    ,AmountOut            TFloat    --Кол-во реализация (факт)
    ,AmountOutWeight      TFloat    --Кол-во реализация (факт) Вес
    ,AmountIn             TFloat    --Кол-во возврат (факт)
    ,AmountInWeight       TFloat    --Кол-во возврат (факт) Вес

    , CountDaySale TFloat
    , CountDay     TFloat
    ,AmountOut_fact            TFloat    --Кол-во реализация (факт)
    ,AmountOutWeight_fact      TFloat    --Кол-во реализация (факт) Вес
    ,AmountIn_fact             TFloat    --Кол-во возврат (факт)
    ,AmountInWeight_fact       TFloat    --Кол-во возврат (факт) Вес
    , PersentWeight            TFloat    -- % Отклонения факта продажи от плана  - средний план продаж расчет = средний план продаж * коэфф дней И факт продаж за период = запросом п.3 за период отчета
    , PersentWeight_2          TFloat    -- % Отклонения факта продажи от плана (AmountPlanMin + AmountPlanMax) / 2 и zc_MIFloat_AmountOut - это ИТОГО за весь период
    ,GoodsKindName             TVarChar  --Вид упаковки
    ,GoodsKindCompleteName     TVarChar  --Вид упаковки ( примечание)
   -- ,GoodsKindName_List   TVarChar  --Вид товара (справочно)
    ,GoodsWeight          TFloat    --Вес
    )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbShowAll Boolean;
    DECLARE vbCountDay TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- Вставить нормальную проверку на право отображения всех колонок
    --vbShowAll:= EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId IN (112322, 876016, 5473256, 296580, zc_Enum_Role_Admin())); -- Документы Маркетинг + Отдел Маркетинг + Маркетинг - Руководитель + Просмотр ВСЕ (управленцы)

    --дней отчета
    vbCountDay := (DATE_PART ('DAY',(inEndDate - inStartDate) ) + 1) ::TFloat;
    
    
    -- таблицы для получения Вид товара (справочно) из GoodsListSale
    CREATE TEMP TABLE _tmpWord_Split_from (WordList TVarChar) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpWord_Split_to (Ord Integer, Word TVarChar, WordList TVarChar) ON COMMIT DROP;

    INSERT INTO _tmpWord_Split_from (WordList)
            SELECT DISTINCT ObjectString_GoodsKind.ValueData AS WordList
            FROM ObjectString AS ObjectString_GoodsKind
            WHERE ObjectString_GoodsKind.DescId = zc_ObjectString_GoodsListSale_GoodsKind()
              AND ObjectString_GoodsKind.ValueData <> '';

    PERFORM zfSelect_Word_Split (inSep:= ',', inUserId:= vbUserId);
    --

    -- Результат
    RETURN QUERY
     WITH tmpGoodsKind AS (SELECT _tmpWord_Split_to.WordList, Object.ValueData :: TVarChar AS GoodsKindName
                           FROM _tmpWord_Split_to
                                LEFT JOIN Object ON Object.Id = _tmpWord_Split_to.Word :: Integer
                           GROUP BY _tmpWord_Split_to.WordList, Object.ValueData
                           )
        -- 1) берем док акция у которой период отгрузки с .. по ...  который попадает в период отчет
        , tmpMovement AS (SELECT Movement_Promo.*
                               , MovementDate_StartSale.ValueData            AS StartSale          --Дата начала отгрузки по акционной цене
                               , MovementDate_EndSale.ValueData              AS EndSale            --Дата окончания отгрузки по акционной цене
                               , MovementLinkObject_Unit.ObjectId            AS UnitId
                               , COALESCE (MovementBoolean_Promo.ValueData, FALSE)   :: Boolean AS isPromo  -- акция (да/нет)

                               --считаем какой период составляет акция в выбранном периоде отчета  
                               /*(коэфф дней = факт_дней_акции_в периоде / факт дней акций итого, т.е всего дней акции = 50, в сентябре 22дн и в октябре 28дн, тогда для сент коэф= 22/50)*/
                               , CASE WHEN MovementDate_StartSale.ValueData < inStartDate THEN inStartDate ELSE MovementDate_StartSale.ValueData END
                               , CASE WHEN MovementDate_EndSale.ValueData > inEndDate THEN inEndDate ELSE MovementDate_EndSale.ValueData END
                               , (DATE_PART ('DAY',(CASE WHEN MovementDate_EndSale.ValueData > inEndDate THEN inEndDate ELSE MovementDate_EndSale.ValueData END              --inEndDate
                                                  - CASE WHEN MovementDate_StartSale.ValueData < inStartDate THEN inStartDate ELSE MovementDate_StartSale.ValueData END)     --inStartDate
                                                   ) + 1) ::TFloat AS CountDay
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
                             LEFT JOIN MovementBoolean AS MovementBoolean_Promo
                                                       ON MovementBoolean_Promo.MovementId = Movement_Promo.Id
                                                      AND MovementBoolean_Promo.DescId = zc_MovementBoolean_Promo()

                          WHERE Movement_Promo.DescId = zc_Movement_Promo()
                         AND (MovementDate_StartSale.ValueData BETWEEN inStartDate AND inEndDate
                         OR
                               inStartDate BETWEEN MovementDate_StartSale.ValueData AND MovementDate_EndSale.ValueData
                              )
                         AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)
                         AND Movement_Promo.StatusId = zc_Enum_Status_Complete()
                         AND Movement_Promo.StatusId <> zc_Enum_Status_Erased()
                         AND (  (COALESCE (MovementBoolean_Promo.ValueData, FALSE) = TRUE AND inIsPromo = TRUE)
                             OR (COALESCE (MovementBoolean_Promo.ValueData, FALSE) = FALSE AND inIsTender = TRUE)
                             OR (inIsPromo = FALSE AND inIsTender = FALSE)
                             )
                          )

        , tmpMovement_Promo AS (SELECT
                                Movement_Promo.Id                                                --Идентификатор
                              , Movement_Promo.OperDate
                              , Movement_Promo.InvNumber                                                --Идентификатор
                              , Movement_Promo.UnitId
                              , Object_Unit.ValueData                       AS UnitName           --Подразделение
                              , MovementDate_StartPromo.ValueData           AS StartPromo         --Дата начала акции
                              , MovementDate_EndPromo.ValueData             AS EndPromo           --Дата окончания акции
                              , Movement_Promo.StartSale                    AS StartSale          --Дата начала отгрузки по акционной цене
                              , Movement_Promo.EndSale                      AS EndSale            --Дата окончания отгрузки по акционной цене
                              , DATE_TRUNC ('MONTH', MovementDate_Month.ValueData) :: TDateTime AS MonthPromo         -- месяц акции
                              , COALESCE (Movement_Promo.isPromo, FALSE)   :: Boolean AS isPromo  -- акция (да/нет)
                              , DATE_PART ('DAY', AGE (Movement_Promo.EndSale, Movement_Promo.StartSale) ) AS CountDaySale
                              --, DATE_PART ('DAY', AGE (MovementDate_EndPromo.ValueData, MovementDate_StartPromo.ValueData) ) AS CountDaySale
                              , Object_Status.ObjectCode                    AS StatusCode         --
                              , Object_Status.ValueData                     AS StatusName         --
                              , Movement_Promo.CountDay
                         FROM tmpMovement AS Movement_Promo
                             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Promo.StatusId
                             LEFT JOIN MovementDate AS MovementDate_StartPromo
                                                    ON MovementDate_StartPromo.MovementId = Movement_Promo.Id
                                                   AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
                             LEFT JOIN MovementDate AS MovementDate_EndPromo
                                                    ON MovementDate_EndPromo.MovementId =  Movement_Promo.Id
                                                   AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()
                             LEFT JOIN MovementDate AS MovementDate_Month
                                                    ON MovementDate_Month.MovementId = Movement_Promo.Id
                                                   AND MovementDate_Month.DescId = zc_MovementDate_Month()
                             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement_Promo.UnitId
                        )

        , tmpMI AS (SELECT *
                    FROM MovementItem
                    WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement_Promo.Id FROM tmpMovement_Promo)
                      AND MovementItem.DescId = zc_MI_Master()
                      AND MovementItem.isErased = FALSE
                    )

        , tmpMovementItemFloat AS (SELECT *
                                   FROM MovementItemFloat
                                   WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                     AND MovementItemFloat.DescId IN (zc_MIFloat_AmountPlanMin()
                                                                    , zc_MIFloat_AmountPlanMax()
                                                                    , zc_MIFloat_AmountOrder()
                                                                    , zc_MIFloat_AmountOut()
                                                                    , zc_MIFloat_AmountIn()
                                                                    , zc_MIFloat_AmountReal() )
                                  )

        , tmpMovementItemLinkObject AS (SELECT *
                                        FROM MovementItemLinkObject
                                        WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                          AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKind()
                                                                              , zc_MILinkObject_GoodsKindComplete()
                                                                                )
                                  )

        , tmpMI_PromoGoods AS (SELECT MovementItem.MovementId                AS MovementId          --ИД документа <Акция>
                                    , MovementItem.ObjectId                  AS GoodsId             --ИД объекта <товар>
                                    , Object_Goods.ObjectCode::Integer       AS GoodsCode           --код объекта  <товар>
                                    , Object_Goods.ValueData                 AS GoodsName           --наименование объекта <товар>
                                    , Object_Measure.Id                      AS MeasureId             --Единица измерения
                                    , Object_Measure.ValueData               AS MeasureName             --Единица измерения
                                    , Object_TradeMark.ValueData             AS TradeMark           --Торговая марка
                                    , Object_GoodsKind.ValueData             AS GoodsKindName       --Наименование обьекта <Вид товара>
                                    , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END::TFloat as GoodsWeight -- Вес
                                    , STRING_AGG (DISTINCT Object_GoodsKindComplete.ValueData, '; ') :: TVarChar  AS GoodsKindCompleteName         --Наименование обьекта <Вид товара (примечание)>
                                    , STRING_AGG (DISTINCT (CAST (MIFloat_AmountPlanMin.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END AS NUMERIC (16,0))) :: TVarChar ||' кг - '
                                                         ||(CAST (MIFloat_AmountPlanMax.ValueData* CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END AS NUMERIC (16,0))) :: TVarChar ||' кг - '
                                                         || Object_GoodsKindComplete.ValueData, ''||CHR(13)||'') :: TVarChar  AS GoodsKindCompleteName_byPrint --Наименование обьекта <Вид товара (примечание)>


                                    , AVG (MovementItem.Amount)                    AS Amount              --% скидки на товар

                                    , SUM (MIFloat_AmountReal.ValueData)           AS AmountReal          --Объем продаж в аналогичный период, кг
                                    , SUM (MIFloat_AmountReal.ValueData
                                        * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountRealWeight    --Объем продаж в аналогичный период, кг Вес

                                    , SUM (MIFloat_AmountPlanMin.ValueData)        AS AmountPlanMin       --Минимум планируемого объема продаж на акционный период (в кг)
                                    , SUM (MIFloat_AmountPlanMin.ValueData
                                        * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountPlanMinWeight --Минимум планируемого объема продаж на акционный период (в кг) Вес
                                    , SUM (MIFloat_AmountPlanMax.ValueData)        AS AmountPlanMax       --Максимум планируемого объема продаж на акционный период (в кг)
                                    , SUM (MIFloat_AmountPlanMax.ValueData
                                        * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountPlanMaxWeight --Максимум планируемого объема продаж на акционный период (в кг) Вес

                                    , SUM (MIFloat_AmountOrder.ValueData)          AS AmountOrder         --Кол-во заявка (факт)
                                    , SUM (MIFloat_AmountOrder.ValueData
                                        * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountOrderWeight   --Кол-во заявка (факт) Вес
                                    , SUM (MIFloat_AmountOut.ValueData)            AS AmountOut           --Кол-во реализация (факт)
                                    , SUM (MIFloat_AmountOut.ValueData
                                        * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountOutWeight     --Кол-во реализация (факт) Вес
                                    , SUM (MIFloat_AmountIn.ValueData)             AS AmountIn            --Кол-во возврат (факт)
                                    , SUM (MIFloat_AmountIn.ValueData
                                        * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountInWeight      --Кол-во возврат (факт) Вес

                                    --среднее значение план
                                    , SUM ((COALESCE (MIFloat_AmountPlanMin.ValueData,0) + COALESCE (MIFloat_AmountPlanMax.ValueData,0)) / 2 ) :: TFloat AS AmountPlanAvg
                                    , SUM ((COALESCE (MIFloat_AmountPlanMin.ValueData,0) + COALESCE (MIFloat_AmountPlanMax.ValueData,0)) / 2
                                        * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountPlanAvgWeight 

                               FROM tmpMI AS MovementItem

                                      LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlanMin
                                                                     ON MIFloat_AmountPlanMin.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_AmountPlanMin.DescId = zc_MIFloat_AmountPlanMin()
                                      LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlanMax
                                                                     ON MIFloat_AmountPlanMax.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_AmountPlanMax.DescId = zc_MIFloat_AmountPlanMax()
                                      LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountOrder
                                                                     ON MIFloat_AmountOrder.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_AmountOrder.DescId = zc_MIFloat_AmountOrder()
                                      LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountOut
                                                                     ON MIFloat_AmountOut.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_AmountOut.DescId = zc_MIFloat_AmountOut()
                                      LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountIn
                                                                     ON MIFloat_AmountIn.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_AmountIn.DescId = zc_MIFloat_AmountIn()
                                      LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountReal
                                                                     ON MIFloat_AmountReal.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_AmountReal.DescId = zc_MIFloat_AmountReal()

                                      LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

                                      LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_GoodsKind
                                                                          ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                         AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                      LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

                                      LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                                          ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                                         AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                                      LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = MILinkObject_GoodsKindComplete.ObjectId

                                      LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                           ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                      LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                                      LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                                           ON ObjectLink_Goods_TradeMark.ObjectId = MovementItem.ObjectId
                                                          AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                                      LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

                                      LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Goods_Weight
                                                                  ON ObjectFloat_Goods_Weight.ObjectId = MovementItem.ObjectId
                                                                 AND ObjectFloat_Goods_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                               GROUP BY MovementItem.MovementId
                                      , MovementItem.ObjectId
                                      , Object_Goods.ObjectCode
                                      , Object_Goods.ValueData
                                      , Object_Measure.ValueData
                                      , Object_Measure.Id
                                      , Object_TradeMark.ValueData
                                      , Object_GoodsKind.ValueData
                                      , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END
                               )

----Данные факт для акций 
          -- выбираем все док продажи и возврата по док. Акция
        , tmpMovementSale AS (SELECT Movement.Id
                               , Movement.OperDate
                               , Movement.Invnumber
                               , Movement.DescId
                               , MovementItem.Id AS MovementItemId
                               , MovementItem.ObjectId            AS GoodsId
                               , MIFloat_PromoMovement.ValueData ::Integer AS MovementId_promo
                               , MovementItem.Amount
                          FROM MovementItemFloat AS MIFloat_PromoMovement
                               INNER JOIN MovementItem ON MovementItem.Id       = MIFloat_PromoMovement.MovementItemId
                                                      AND MovementItem.isErased = FALSE
                               INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                                                  AND Movement.DescId IN ( zc_Movement_Sale(), zc_Movement_ReturnIn())
                                                  AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                          WHERE MIFloat_PromoMovement.ValueData IN (SELECT DISTINCT tmpMovement_Promo.Id FROM tmpMovement_Promo)
                            AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                        )

        , tmpMI_GoodsKind AS (SELECT *
                              FROM MovementItemLinkObject 
                              WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMovementSale.MovementItemId FROM tmpMovementSale)
                                AND MovementItemLinkObject.DescId         = zc_MILinkObject_GoodsKind()
                              )

        , tmpMovementItemFloat2 AS (SELECT *
                                   FROM MovementItemFloat 
                                   WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMovementSale.MovementItemId FROM tmpMovementSale)
                                     AND MovementItemFloat.DescId = zc_MIFloat_AmountPartner()
                                   )

        , tmpDataFact AS (SELECT tmpMovement.MovementId_promo
                               , tmpMovement.GoodsId
                               --, MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                          
                               , SUM (CASE WHEN tmpMovement.DescId = zc_Movement_Sale()  THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END)          :: TFloat AS AmountOut
                               , SUM ( CASE WHEN tmpMovement.DescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END
                                       * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END ) :: TFloat AS AmountOutWeight
                  
                               , SUM (CASE WHEN tmpMovement.DescId = zc_Movement_ReturnIn() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END)       :: TFloat AS AmountIn
                               , SUM (CASE WHEN tmpMovement.DescId = zc_Movement_ReturnIn() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END
                                      * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END )  :: TFloat AS AmountInWeight
                          FROM tmpMovementSale AS tmpMovement
                  
                               LEFT JOIN tmpMI_GoodsKind AS MILinkObject_GoodsKind ON MILinkObject_GoodsKind.MovementItemId = tmpMovement.MovementItemId
                   
                               LEFT JOIN tmpMovementItemFloat2 AS MIFloat_AmountPartner
                                                               ON MIFloat_AmountPartner.MovementItemId = tmpMovement.MovementItemId
                                                              AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                  
                              LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                   ON ObjectLink_Goods_Measure.ObjectId = tmpMovement.GoodsId
                                                  AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                  
                              LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Goods_Weight
                                                          ON ObjectFloat_Goods_Weight.ObjectId = tmpMovement.GoodsId
                                                         AND ObjectFloat_Goods_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                          GROUP BY tmpMovement.MovementId_promo
                                 , tmpMovement.GoodsId
                                -- , MILinkObject_GoodsKind.ObjectId
                           )
                        
        --
        SELECT
            Movement_Promo.Id                --ИД документа акции
          , Movement_Promo.OperDate :: TDateTime AS OperDate
          , Movement_Promo.InvNumber          --№ документа акции
          , Movement_Promo.StatusCode         --
          , Movement_Promo.StatusName         --

          , Movement_Promo.UnitName           --Склад
          , Movement_Promo.StartSale    AS DateStartSale      --Дата начала отгрузки по акционной цене
          , Movement_Promo.EndSale      AS DateFinalSale      --Дата окончания отгрузки по акционной цене
          , Movement_Promo.StartPromo   AS DateStartPromo      --Дата начала акции
          , Movement_Promo.EndPromo     AS DateFinalPromo      --Дата окончания акции
          , Movement_Promo.MonthPromo         --месяц акции
          ------------------------
          , COALESCE ((SELECT STRING_AGG (DISTINCT COALESCE (MovementString_Retail.ValueData, Object_Retail.ValueData),'; ')
                       FROM
                          Movement AS Movement_PromoPartner
                          /*INNER JOIN MovementLinkObject AS MLO_Partner
                                                        ON MLO_Partner.MovementId = Movement_PromoPartner.ID
                                                       AND MLO_Partner.DescId     = zc_MovementLinkObject_Partner()
                          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = MLO_Partner.ObjectId*/
                          INNER JOIN MovementItem AS MI_PromoPartner
                                                  ON MI_PromoPartner.MovementId = Movement_PromoPartner.ID
                                                 AND MI_PromoPartner.DescId     = zc_MI_Master()
                                                 AND MI_PromoPartner.IsErased   = FALSE
                          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                               ON ObjectLink_Partner_Juridical.ObjectId = MI_PromoPartner.ObjectId
                                              AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                               ON ObjectLink_Juridical_Retail.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MI_PromoPartner.ObjectId)
                                              AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
                          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

                          LEFT OUTER JOIN MovementString AS MovementString_Retail
                                                         ON MovementString_Retail.MovementId = Movement_PromoPartner.Id
                                                        AND MovementString_Retail.DescId = zc_MovementString_Retail()
                                                        AND MovementString_Retail.ValueData <> ''

                       WHERE Movement_PromoPartner.ParentId = Movement_Promo.Id
                         AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
                         AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                      )
          , (SELECT STRING_AGG (DISTINCT Object.ValueData,'; ')
             FROM
                Movement AS Movement_PromoPartner
                INNER JOIN MovementLinkObject AS MLO_Partner
                                              ON MLO_Partner.MovementId = Movement_PromoPartner.ID
                                             AND MLO_Partner.DescId     = zc_MovementLinkObject_Partner()
                INNER JOIN Object ON Object.Id = MLO_Partner.ObjectId
             WHERE Movement_PromoPartner.ParentId = Movement_Promo.Id
               AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
               AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
              ) )::TBlob AS RetailName
            --------------------------------------
          , (SELECT STRING_AGG ( tmp.JuridicalName,'; ')
             FROM (SELECT DISTINCT Object_Juridical.ValueData AS JuridicalName
                        , CASE WHEN Object_Juridical.Id = inJuridicalId THEN 1 else 99 END AS ord
                   FROM
                      Movement AS Movement_PromoPartner

                      INNER JOIN MovementItem AS MI_PromoPartner
                                              ON MI_PromoPartner.MovementId = Movement_PromoPartner.ID
                                             AND MI_PromoPartner.DescId     = zc_MI_Master()
                                             AND MI_PromoPartner.IsErased   = FALSE
                      LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                           ON ObjectLink_Partner_Juridical.ObjectId = MI_PromoPartner.ObjectId
                                          AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                      LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MI_PromoPartner.ObjectId)
                   WHERE Movement_PromoPartner.ParentId = Movement_Promo.Id
                     AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
                     AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                   ORDER BY CASE WHEN Object_Juridical.Id = inJuridicalId THEN 1 else 99 END 
                   ) AS tmp
            ) ::TBlob AS JuridicalName_str

          , MI_PromoGoods.GoodsName
          , MI_PromoGoods.GoodsCode
          , MI_PromoGoods.MeasureName
          , MI_PromoGoods.TradeMark
          , MI_PromoGoods.AmountPlanMin      ::TFloat --Минимум планируемого объема продаж на акционный период (в кг)
          , MI_PromoGoods.AmountPlanMinWeight::TFloat --Минимум планируемого объема продаж на акционный период (в кг) Вес
          , MI_PromoGoods.AmountPlanMax      ::TFloat --Максимум планируемого объема продаж на акционный период (в кг)
          , MI_PromoGoods.AmountPlanMaxWeight::TFloat --Максимум планируемого объема продаж на акционный период (в кг) Вес
          , MI_PromoGoods.AmountPlanAvg      ::TFloat --Cреднее планируемого объема продаж на акционный период (в кг) Вес
          , MI_PromoGoods.AmountPlanAvgWeight::TFloat --Среднее планируемого объема продаж на акционный период (в кг) Вес

          , CAST (CASE WHEN COALESCE (Movement_Promo.CountDaySale,0) <> 0 THEN MI_PromoGoods.AmountPlanAvg/Movement_Promo.CountDaySale * Movement_Promo.CountDay ELSE 0 END        AS NUMERIC (16,2))::TFloat AS AmountPlanAvg_calc--Cреднее планируемого объема продаж на период отчета(в кг) Вес
          , CAST (CASE WHEN COALESCE (Movement_Promo.CountDaySale,0) <> 0 THEN MI_PromoGoods.AmountPlanAvgWeight/Movement_Promo.CountDaySale * Movement_Promo.CountDay ELSE 0 END  AS NUMERIC (16,2))::TFloat AS AmountPlanAvgWeight_calc--Cреднее планируемого объема продаж на период отчета(в кг) Вес

          , MI_PromoGoods.AmountReal         ::TFloat --Объем продаж в аналогичный период, кг
          , MI_PromoGoods.AmountRealWeight   ::TFloat --Объем продаж в аналогичный период, кг Вес
          , MI_PromoGoods.AmountOrder        ::TFloat --Кол-во заявка (факт)
          , MI_PromoGoods.AmountOrderWeight  ::TFloat --Кол-во заявка (факт) Вес
          , MI_PromoGoods.AmountOut          ::TFloat --Кол-во реализация (факт)
          , MI_PromoGoods.AmountOutWeight    ::TFloat --Кол-во реализация (факт) Вес
          , MI_PromoGoods.AmountIn           ::TFloat --Кол-во возврат (факт)
          , MI_PromoGoods.AmountInWeight     ::TFloat --Кол-во возврат (факт) Вес

          , Movement_Promo.CountDaySale      ::TFloat
          , Movement_Promo.CountDay          ::TFloat

          , tmpDataFact.AmountOut          ::TFloat AS AmountOut_fact      --Кол-во реализация (факт)
          , tmpDataFact.AmountOutWeight    ::TFloat AS AmountOutWeight_fact--Кол-во реализация (факт) Вес
          , tmpDataFact.AmountIn           ::TFloat AS AmountIn_fact       --Кол-во возврат (факт)
          , tmpDataFact.AmountInWeight     ::TFloat AS AmountInWeight_fact --Кол-во возврат (факт) Вес

          /*, CAST (CASE WHEN (CASE WHEN COALESCE (Movement_Promo.CountDaySale,0) <> 0 THEN MI_PromoGoods.AmountPlanAvgWeight/Movement_Promo.CountDaySale * Movement_Promo.CountDay ELSE 0 END) <> 0 
                 THEN (COALESCE (tmpDataFact.AmountOutWeight,0) - (CASE WHEN COALESCE (Movement_Promo.CountDaySale,0) <> 0 THEN MI_PromoGoods.AmountPlanAvgWeight/Movement_Promo.CountDaySale * Movement_Promo.CountDay ELSE 0 END) ) * 100
                       / (CASE WHEN COALESCE (Movement_Promo.CountDaySale,0) <> 0 THEN MI_PromoGoods.AmountPlanAvgWeight/Movement_Promo.CountDaySale * Movement_Promo.CountDay ELSE 0 END)
                 ELSE 0
            END  AS NUMERIC (16,2)) ::TFloat AS PersentWeight
            */

          , CASE WHEN CAST (CASE WHEN COALESCE (Movement_Promo.CountDaySale,0) <> 0 THEN MI_PromoGoods.AmountPlanAvgWeight/Movement_Promo.CountDaySale * Movement_Promo.CountDay ELSE 0 END AS NUMERIC (16,2)) <> 0
                 THEN CAST( ( (tmpDataFact.AmountOutWeight * 100/ CAST (CASE WHEN COALESCE (Movement_Promo.CountDaySale,0) <> 0 THEN MI_PromoGoods.AmountPlanAvgWeight/Movement_Promo.CountDaySale * Movement_Promo.CountDay ELSE 0 END AS NUMERIC (16,2))) - 100) AS NUMERIC (16,2))
                 ELSE 0
            END ::TFloat AS PersentWeight

          , CASE WHEN MI_PromoGoods.AmountPlanAvgWeight <> 0
                 THEN CAST( ( (MI_PromoGoods.AmountOutWeight * 100/ MI_PromoGoods.AmountPlanAvgWeight) - 100) AS NUMERIC (16,2))
                 ELSE 0
            END ::TFloat AS PersentWeight_2        

          , MI_PromoGoods.GoodsKindName       --Наименование обьекта <Вид товара>
          , MI_PromoGoods.GoodsKindCompleteName         ::TVarChar AS GoodsKindCompleteName

         /* , (SELECT STRING_AGG (DISTINCT tmpGoodsKind.GoodsKindName,'; ')
             FROM Movement AS Movement_PromoPartner
                INNER JOIN MovementItem AS MI_PromoPartner
                                        ON MI_PromoPartner.MovementId = Movement_PromoPartner.ID
                                       AND MI_PromoPartner.DescId     = zc_MI_Master()
                                       AND MI_PromoPartner.IsErased   = FALSE

                LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Partner
                                     ON ObjectLink_GoodsListSale_Partner.ChildObjectId = MI_PromoPartner.ObjectId
                                    AND ObjectLink_GoodsListSale_Partner.DescId = zc_ObjectLink_GoodsListSale_Partner()

                INNER JOIN ObjectLink AS ObjectLink_GoodsListSale_Goods
                                     ON ObjectLink_GoodsListSale_Goods.ObjectId = ObjectLink_GoodsListSale_Partner.ObjectId
                                    AND ObjectLink_GoodsListSale_Goods.DescId = zc_ObjectLink_GoodsListSale_Goods()
                                    AND ObjectLink_GoodsListSale_Goods.ChildObjectId = MI_PromoGoods.GoodsId
                INNER JOIN ObjectString AS ObjectString_GoodsKind
                                        ON ObjectString_GoodsKind.ObjectId = ObjectLink_GoodsListSale_Partner.ObjectId
                                       AND ObjectString_GoodsKind.DescId = zc_ObjectString_GoodsListSale_GoodsKind()

                LEFT JOIN tmpGoodsKind ON tmpGoodsKind.WordList = ObjectString_GoodsKind.ValueData

             WHERE Movement_PromoPartner.ParentId = Movement_Promo.Id
               AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
               AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
            )::TVarChar AS GoodsKindName_List
         */
          , CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN MI_PromoGoods.GoodsWeight ELSE NULL END :: TFloat AS GoodsWeight

        FROM tmpMovement_Promo AS Movement_Promo
            LEFT JOIN tmpMI_PromoGoods AS MI_PromoGoods ON MI_PromoGoods.MovementId = Movement_Promo.Id
            LEFT JOIN tmpDataFact ON tmpDataFact.MovementId_promo = Movement_Promo.Id
                                 AND tmpDataFact.GoodsId = MI_PromoGoods.GoodsId
        WHERE MI_PromoGoods.AmountPlanMin <> 0
           OR MI_PromoGoods.AmountPlanMax <> 0
           OR tmpDataFact.AmountOut       <> 0
        ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.09.21         *
*/

-- тест
--  SELECT * FROM gpReport_Promo_PlanFact(inStartDate := ('01.08.2021')::TDateTime , inEndDate := ('05.08.2021')::TDateTime , inIsPromo := 'False'::Boolean , inIsTender := 'False' ::Boolean,inIsGoodsKind := 'False'::Boolean, inUnitId := 0 ,  inJuridicalId:=0, inSession := '5'::TVarchar) -- where invnumber = 6862


