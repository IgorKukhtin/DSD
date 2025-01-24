
DROP FUNCTION IF EXISTS gpSelect_Report_Promo(
    TDateTime, --дата начала периода
    TDateTime, --дата окончания периода
    Integer,   --подразделение
    TVarChar   --сессия пользователя
);
DROP FUNCTION IF EXISTS gpSelect_Report_Promo(
    TDateTime, --дата начала периода
    TDateTime, --дата окончания периода
    Boolean,   --показать только Акции
    Boolean,   --показать только Тендеры
    Integer,   --подразделение
    TVarChar   --сессия пользователя
);
/*
DROP FUNCTION IF EXISTS gpSelect_Report_Promo(
    TDateTime, --дата начала периода
    TDateTime, --дата окончания периода
    Boolean,   --показать только Акции
    Boolean,   --показать только Тендеры
    Boolean,   -- группировать по видам
    Integer,   --подразделение
    TVarChar   --сессия пользователя
);*/
DROP FUNCTION IF EXISTS gpSelect_Report_Promo(
    TDateTime, --дата начала периода
    TDateTime, --дата окончания периода
    Boolean,   --показать только Акции
    Boolean,   --показать только Тендеры
    Boolean,   -- группировать по видам
    Integer,   --подразделение
    Integer,   --юр.лицо
    TVarChar   --сессия пользователя
);
CREATE OR REPLACE FUNCTION gpSelect_Report_Promo(
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
    ,InvNumber            Integer   --№ документа акции
    ,StatusCode Integer, StatusName TVarChar
    ,UnitName             TVarChar  --Склад
    ,PersonalTradeName    TVarChar  --Ответственный представитель коммерческого отдела
    ,PersonalName         TVarChar  --Ответственный представитель маркетингового отдела
    ,DateStartSale        TDateTime --Дата отгрузки по акционным ценам
    ,DeteFinalSale        TDateTime --Дата отгрузки по акционным ценам
    ,DateStartPromo       TDateTime --Дата проведения акции
    ,DateFinalPromo       TDateTime --Дата проведения акции
    ,MonthPromo           TDateTime --Месяц акции
    ,CheckDate            TDateTime --Дата Согласования
    ,RetailName           TBlob     --Сеть, в которой проходит акция
    ,AreaName             TBlob     --Регион
    ,JuridicalName_str    TBlob     --юр.лица
    ,GoodsName            TVarChar  --Позиция
    ,GoodsCode            Integer   --Код позиции
    ,MeasureName          TVarChar  --единица измерения
    ,TradeMarkName        TVarChar  --Торговая марка
    ,AmountPlanMin        TFloat    --Планируемый объем продаж в акционный период, шт
    ,AmountPlanMinWeight  TFloat    --Планируемый объем продаж в акционный период, кг
    ,AmountPlanMax        TFloat    --Планируемый объем продаж в акционный период, шт
    ,AmountPlanMaxWeight  TFloat    --Планируемый объем продаж в акционный период, кг
    ,AmountReal           TFloat    --Объем продаж в аналогичный период, кг
    ,AmountRealWeight     TFloat    --Объем продаж в аналогичный период, кг Вес
    ,AmountOrder          TFloat    --Кол-во заявка (факт)
    ,AmountOrderWeight    TFloat    --Кол-во заявка (факт) Вес
    ,AmountOut            TFloat    --Кол-во реализация (факт)
    ,AmountOutWeight      TFloat    --Кол-во реализация (факт) Вес
    ,AmountIn             TFloat    --Кол-во возврат (факт)
    ,AmountInWeight       TFloat    --Кол-во возврат (факт) Вес
    ,GoodsKindName        TVarChar  --Вид упаковки
    ,GoodsKindCompleteName  TVarChar  --Вид упаковки ( примечание)
    ,GoodsKindCompleteName_byPrint TVarChar -- План мин - План макс + Вид упаковки ( примечание)
    ,GoodsKindName_List   TVarChar  --Вид товара (справочно)
    ,GoodsWeight          TFloat    --Вес
    ,Discount             TBlob     --Скидка, %
    ,PriceWithOutVAT      TFloat    --Отгрузочная акционная цена без учета НДС, грн
    ,PriceWithVAT         TFloat    --Отгрузочная акционная цена с учетом НДС, грн
    ,Price                TFloat    -- * Цена спецификации с НДС, грн
    ,CostPromo            TFloat    -- * Стоимость участия
    ,AdvertisingName      TBlob     -- * рекламн.поддержка
    ,OperDate             TDateTime -- * Статус внесения в базу
    ,PriceSale            TFloat    -- * Цена на полке/скидка для покупателя
    ,Comment              TVarChar  --Комментарии
    , CommentMain         TVarChar  --Примечание (общее)
    ,ShowAll              Boolean   --Показывать все данные
    ,isPromo              Boolean   --Акция (да/нет)
    ,Checked              Boolean   --Согласовано (да/нет)
    , PromoStateKindName    TVarChar --состояние акции
    , Color_PromoStateKind  Integer  -- подсветка
    , strSign             TVarChar   --эл. подпись     
    
    , PriceIn_fact              TFloat -- с/с факт
    , PriceIn_plan              TFloat -- с/с план
    , ContractCondition_persent TFloat --бонус сети %
    , ContractCondition         TFloat --бонус сети сумма
    , PriceWithVAT_calc              TFloat -- цена с ндс с учетом скидки
    , SummaProfit_fact          TFloat --прибыль факт
    , SummaProfit_plan          TFloat --прибыль план 
    
    , Days_Sale  Integer               --длительность дней отгрузки по акц. ценам
    , Days_Real  Integer               --длительность дней аналогичный период

    )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbShowAll Boolean;
    DECLARE vbScript   TEXT;
    DECLARE vb1        TEXT;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- Вставить нормальную проверку на право отображения всех колонок
    vbShowAll:= EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId IN (112322, 876016, 5473256, 296580, zc_Enum_Role_Admin())); -- Документы Маркетинг + Отдел Маркетинг + Маркетинг - Руководитель + Просмотр ВСЕ (управленцы)

    -- таблицы для получения Вид товара (справочно) из GoodsListSale
/*    CREATE TEMP TABLE _tmpWord_Split_from (WordList TVarChar) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpWord_Split_to (Ord Integer, Word TVarChar, WordList TVarChar) ON COMMIT DROP;

    INSERT INTO _tmpWord_Split_from (WordList)
            SELECT DISTINCT ObjectString_GoodsKind.ValueData AS WordList
            FROM ObjectString AS ObjectString_GoodsKind
            WHERE ObjectString_GoodsKind.DescId = zc_ObjectString_GoodsListSale_GoodsKind()
              AND ObjectString_GoodsKind.ValueData <> '';

    PERFORM zfSelect_Word_Split (inSep:= ',', inUserId:= vbUserId);
    --
*/

    /*IF vbUserId = 5
    THEN
        -- Реальная таблица
        vbScript:= 'TRUNCATE TABLE _tmpWord_Split_to_promo';
        vb1:= (SELECT *
               FROM dblink_exec ('host=192.168.0.219 dbname=project port=5432 user=project password=sqoII5szOnrcZxJVF1BL'
                                  -- Результат
                               , vbScript));

        -- Реальная таблица
        vbScript:= 'INSERT INTO _tmpWord_Split_to_promo (Ord, Word, WordList) SELECT Ord, Word, WordList FROM zfSelect_Word_Split (inSep:= '','', inIsPromo:= TRUE, inUserId:= ' || vbUserId :: TVarChar || ') AS zfSelect';
        -- Результат
        vb1:= (SELECT *
               FROM dblink_exec ('host=192.168.0.219 dbname=project port=5432 user=project password=sqoII5szOnrcZxJVF1BL'
                                  -- Результат
                               , vbScript));
        --
        RAISE INFO  '%',vb1;

    END IF;*/


    -- Результат
    RETURN QUERY
     WITH tmpGoodsKind AS (SELECT _tmpWord_Split_to.WordList, Object.ValueData :: TVarChar AS GoodsKindName
                           FROM _tmpWord_Split_to_promo AS _tmpWord_Split_to
                                LEFT JOIN Object ON Object.Id = _tmpWord_Split_to.Word :: Integer
                           GROUP BY _tmpWord_Split_to.WordList, Object.ValueData
                           )
        , tmpMovement AS (SELECT Movement_Promo.*
                               , MovementDate_StartSale.ValueData            AS StartSale          --Дата начала отгрузки по акционной цене
                               , MovementDate_EndSale.ValueData              AS EndSale            --Дата окончания отгрузки по акционной цене
                               , MovementLinkObject_Unit.ObjectId            AS UnitId
                               , COALESCE (MovementBoolean_Promo.ValueData, FALSE)   :: Boolean AS isPromo  -- акция (да/нет)
                               , COALESCE(MovementLinkObject_PriceList.ObjectId, zc_PriceList_Basis()) AS PriceListId
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

                             -- нужно определить прайслист , а по нему значение НДС , для расчете цены с НДС
                             LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                                          ON MovementLinkObject_PriceList.MovementId = Movement_Promo.Id
                                                         AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()

                          WHERE Movement_Promo.DescId = zc_Movement_Promo()
                         AND (MovementDate_StartSale.ValueData BETWEEN inStartDate AND inEndDate
                         OR
                               inStartDate BETWEEN MovementDate_StartSale.ValueData AND MovementDate_EndSale.ValueData
                              )
                         AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)
                       --AND Movement_Promo.StatusId = zc_Enum_Status_Complete()
                         AND Movement_Promo.StatusId <> zc_Enum_Status_Erased()
                         AND (  (COALESCE (MovementBoolean_Promo.ValueData, FALSE) = TRUE AND inIsPromo = TRUE)
                             OR (COALESCE (MovementBoolean_Promo.ValueData, FALSE) = FALSE AND inIsTender = TRUE)
                             OR (inIsPromo = FALSE AND inIsTender = FALSE)
                             )
                          )
          -- Для Прайсластов определяем НДС
        , tmpVAT AS (SELECT tmp.PriceListId
                          , (SELECT tt.VATPercent FROM gpGet_Object_PriceList(tmp.PriceListId, inSession) AS tt) AS VATPercent
                     FROM (SELECT DISTINCT tmpMovement.PriceListId FROM tmpMovement) AS tmp
                     )

        , tmpMovement_Promo AS (SELECT
                                Movement_Promo.Id                                                 --Идентификатор
                              , Movement_Promo.InvNumber :: Integer         AS InvNumber          --Номер документа
                              , Movement_Promo.OperDate                                           --Дата документа
                              , Object_Status.Id                            AS StatusId           --
                              , Object_Status.ObjectCode                    AS StatusCode         --
                              , Object_Status.ValueData                     AS StatusName         --
                              , Object_Unit.ValueData                       AS UnitName           --Подразделение
                              , MovementLinkObject_PersonalTrade.ObjectId   AS PersonalTradeId    --Ответственный представитель коммерческого отдела
                              , Object_PersonalTrade.ValueData              AS PersonalTradeName  --Ответственный представитель коммерческого отдела
                              , MovementLinkObject_Personal.ObjectId        AS PersonalId         --Ответственный представитель маркетингового отдела
                              , Object_Personal.ValueData                   AS PersonalName       --Ответственный представитель маркетингового отдела
                              , MovementDate_StartPromo.ValueData           AS StartPromo         --Дата начала акции
                              , MovementDate_EndPromo.ValueData             AS EndPromo           --Дата окончания акции
                              , Movement_Promo.StartSale                    AS StartSale          --Дата начала отгрузки по акционной цене
                              , Movement_Promo.EndSale                      AS EndSale            --Дата окончания отгрузки по акционной цене
                              , MovementDate_EndReturn.ValueData            AS EndReturn          --Дата окончания возвратов по акционной цене  
                              , MovementDate_OperDateStart.ValueData        AS OperDateStart      --Дата начала расч. продаж до акции
                              , MovementDate_OperDateEnd.ValueData          AS OperDateEnd        --Дата окончания расч. продаж до акции
                              , DATE_TRUNC ('MONTH', MovementDate_Month.ValueData) :: TDateTime AS MonthPromo         -- месяц акции
                              , MovementDate_CheckDate.ValueData            AS CheckDate          --Дата согласования
                              , MovementFloat_CostPromo.ValueData           AS CostPromo          --Стоимость участия в акции
                              , MovementString_Comment.ValueData            AS Comment            --Примечание
                              , MovementString_CommentMain.ValueData        AS CommentMain        --Примечание (общее)
                              , COALESCE (Movement_Promo.isPromo, FALSE)   :: Boolean AS isPromo  -- акция (да/нет)
                              , COALESCE (MovementBoolean_Checked.ValueData, FALSE) :: Boolean AS Checked  -- согласовано (да/нет)

                              , Object_PromoStateKind.Id                    AS PromoStateKindId        --Состояние акции
                              , Object_PromoStateKind.ValueData             AS PromoStateKindName      --Состояние акции

/*
- В работе Директор по маркетингу - заливается строка светло-желтым
- В работе Исполнительный директор - заливается строка светло-желтым
- Вернули для исправление - заливается строка оранжевым (ненасыщенным)
- Согласован, но вверху статус Не проведен - заливается строка светло-голубым
- Отменен заливается строка красным цветом
- В работе Отдел маркетинга - заливается строка светло-зеленым цветом
*/
                              , CASE WHEN Object_PromoStateKind.Id = zc_Enum_PromoStateKind_Head() OR Object_PromoStateKind.Id = zc_Enum_PromoStateKind_Main() THEN zc_Color_Yelow()     -- В работе Директор по маркетингу или В работе Исполнительный Директор
                                     WHEN Object_PromoStateKind.Id = zc_Enum_PromoStateKind_Return() THEN 8435455                                                                        --  оранжевым (ненасыщенным)
                                     WHEN Object_PromoStateKind.Id = zc_Enum_PromoStateKind_Complete() AND Movement_Promo.StatusId = zc_Enum_Status_UnComplete() THEN zc_Color_Aqua()    --голубой
                                     WHEN Object_PromoStateKind.Id = zc_Enum_PromoStateKind_Canceled() THEN zc_Color_Red()   -- красный
                                     WHEN Object_PromoStateKind.Id = zc_Enum_PromoStateKind_Start() THEN 13041606 --zc_Color_Lime()     -- зеленый
                                     -- нет цвета
                                     ELSE zc_Color_White()
                                END AS Color_PromoStateKind
                                
                              , tmpVAT.VATPercent   --НДС из прайслиста
                         FROM tmpMovement AS Movement_Promo
                             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Promo.StatusId
                             LEFT JOIN MovementDate AS MovementDate_StartPromo
                                                     ON MovementDate_StartPromo.MovementId = Movement_Promo.Id
                                                    AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
                             LEFT JOIN MovementDate AS MovementDate_EndPromo
                                                     ON MovementDate_EndPromo.MovementId =  Movement_Promo.Id
                                                    AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

                             LEFT JOIN MovementDate AS MovementDate_EndReturn
                                                    ON MovementDate_EndReturn.MovementId = Movement_Promo.Id
                                                   AND MovementDate_EndReturn.DescId = zc_MovementDate_EndReturn()

                             LEFT JOIN MovementDate AS MovementDate_Month
                                                    ON MovementDate_Month.MovementId = Movement_Promo.Id
                                                   AND MovementDate_Month.DescId = zc_MovementDate_Month()

                             LEFT JOIN MovementDate AS MovementDate_CheckDate
                                                    ON MovementDate_CheckDate.MovementId = Movement_Promo.Id
                                                   AND MovementDate_CheckDate.DescId = zc_MovementDate_Check()

                             LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                                    ON MovementDate_OperDateStart.MovementId = Movement_Promo.Id
                                                   AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
                             LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                                    ON MovementDate_OperDateEnd.MovementId = Movement_Promo.Id
                                                   AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

                             LEFT JOIN MovementFloat AS MovementFloat_CostPromo
                                                     ON MovementFloat_CostPromo.MovementId = Movement_Promo.Id
                                                    AND MovementFloat_CostPromo.DescId = zc_MovementFloat_CostPromo()

                             LEFT JOIN MovementString AS MovementString_Comment
                                                      ON MovementString_Comment.MovementId = Movement_Promo.Id
                                                     AND MovementString_Comment.DescId = zc_MovementString_Comment()
                             LEFT JOIN MovementString AS MovementString_CommentMain
                                                      ON MovementString_CommentMain.MovementId = Movement_Promo.Id
                                                     AND MovementString_CommentMain.DescId = zc_MovementString_CommentMain()

                             LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                                       ON MovementBoolean_Checked.MovementId = Movement_Promo.Id
                                                      AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()

                             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement_Promo.UnitId

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalTrade
                                                          ON MovementLinkObject_PersonalTrade.MovementId = Movement_Promo.Id
                                                         AND MovementLinkObject_PersonalTrade.DescId = zc_MovementLinkObject_PersonalTrade()
                             LEFT JOIN Object AS Object_PersonalTrade
                                              ON Object_PersonalTrade.Id = MovementLinkObject_PersonalTrade.ObjectId

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                                          ON MovementLinkObject_Personal.MovementId = Movement_Promo.Id
                                                         AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
                             LEFT JOIN Object AS Object_Personal
                                              ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_PromoStateKind
                                                          ON MovementLinkObject_PromoStateKind.MovementId = Movement_Promo.Id
                                                         AND MovementLinkObject_PromoStateKind.DescId = zc_MovementLinkObject_PromoStateKind()
                             LEFT JOIN Object AS Object_PromoStateKind ON Object_PromoStateKind.Id = MovementLinkObject_PromoStateKind.ObjectId
                             
                             LEFT JOIN tmpVAT ON tmpVAT.PriceListId = Movement_Promo.PriceListId
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
                                     AND MovementItemFloat.DescId IN (zc_MIFloat_Price()
                                                                    , zc_MIFloat_PriceWithOutVAT()
                                                                    , zc_MIFloat_PriceWithVAT()
                                                                    , zc_MIFloat_PriceSale()
                                                                    , zc_MIFloat_AmountOrder()
                                                                    , zc_MIFloat_AmountOut()
                                                                    , zc_MIFloat_AmountIn()
                                                                    , zc_MIFloat_AmountReal()
                                                                    , zc_MIFloat_AmountPlanMin()
                                                                    , zc_MIFloat_AmountPlanMax()
                                                                      )
                                  )

        , tmpMovementItemLinkObject AS (SELECT *
                                        FROM MovementItemLinkObject
                                        WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                          AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKind()
                                                                              , zc_MILinkObject_GoodsKindComplete()
                                                                                )
                                  )

        --данные с закладки 2,1 - Калькулятор скидка
        , tmpMICalc AS (SELECT tmpMovement_Promo.Id    AS MovementId
                             , tmp.Id                  AS MovementItemId      --, tmp.GoodsKindId 
                             , tmp.GoodsId
                             , ROW_NUMBER() OVER (PARTITION BY tmpMovement_Promo.Id, tmp.GoodsId ORDER BY tmpMovement_Promo.Id, tmp.Id)  AS Ord
                             
                             , SUM (CASE WHEN Num = 2 THEN tmp.PriceIn ELSE 0 END) AS PriceIn_fact                        -- с/с факт
                             , SUM (CASE WHEN Num = 4 THEN tmp.PriceIn ELSE 0 END) AS PriceIn_plan                        -- с/с план

                             , SUM (CASE WHEN Num = 1 THEN tmp.ContractCondition ELSE 0 END) AS ContractCondition_persent --бонус сети %
                             , SUM (CASE WHEN Num = 2 THEN tmp.ContractCondition ELSE 0 END) AS ContractCondition         --бонус сети сумма

                             , SUM (CASE WHEN Num = 2 THEN tmp.PriceWithVAT ELSE 0 END) AS PriceWithVAT -- цена с ндс с учетом скидки

                             , SUM (CASE WHEN Num = 2 THEN tmp.SummaProfit ELSE 0 END) AS SummaProfit_fact                --прибыль факт
                             , SUM (CASE WHEN Num = 4 THEN tmp.SummaProfit ELSE 0 END) AS SummaProfit_plan                --прибыль план
                          FROM tmpMovement_Promo
                              LEFT JOIN gpSelect_MI_PromoGoods_Calc_all(tmpMovement_Promo.Id, FALSE, TRUE, inSession) AS tmp ON 1 = 1
                          WHERE tmp.Groupnum IN (1,2)  --факт / план 
                          GROUP BY tmpMovement_Promo.Id, tmp.Id, tmp.GoodsId
                        )

        , tmpMI_PromoGoods AS (SELECT MovementItem.MovementId                AS MovementId          --ИД документа <Акция>
                                    , MovementItem.ObjectId                  AS GoodsId             --ИД объекта <товар>
                                    , Object_Goods.ObjectCode::Integer       AS GoodsCode           --код объекта  <товар>
                                    , Object_Goods.ValueData                 AS GoodsName           --наименование объекта <товар>
                                    , Object_Measure.Id                      AS MeasureId            --Единица измерения
                                    , Object_Measure.ValueData               AS Measure             --Единица измерения
                                    , Object_TradeMark.ValueData             AS TradeMark           --Торговая марка
                                    , Object_GoodsKind.ValueData             AS GoodsKindName       --Наименование обьекта <Вид товара>
                                    , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END::TFloat as GoodsWeight -- Вес
                                    , STRING_AGG (DISTINCT Object_GoodsKindComplete.ValueData, '; ') :: TVarChar  AS GoodsKindCompleteName         --Наименование обьекта <Вид товара (примечание)>
                                    , STRING_AGG (DISTINCT (CAST (MIFloat_AmountPlanMin.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END AS NUMERIC (16,0))) :: TVarChar ||' кг - '
                                                         ||(CAST (MIFloat_AmountPlanMax.ValueData* CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END AS NUMERIC (16,0))) :: TVarChar ||' кг - '
                                                         || Object_GoodsKindComplete.ValueData, ''||CHR(13)||'') :: TVarChar  AS GoodsKindCompleteName_byPrint --Наименование обьекта <Вид товара (примечание)>

                                    , MIFloat_Price.ValueData                AS Price               --Цена в прайсе
                                    , MIFloat_PriceWithOutVAT.ValueData      AS PriceWithOutVAT     --Цена отгрузки без учета НДС, с учетом скидки, грн
                                    , MIFloat_PriceWithVAT.ValueData         AS PriceWithVAT        --Цена отгрузки с учетом НДС, с учетом скидки, грн
                                    , MIFloat_PriceSale.ValueData            AS PriceSale           --Цена на полке

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

                                    , CASE WHEN COALESCE (tmpMICalc.PriceIn_fact,0) <> 0              THEN tmpMICalc.PriceIn_fact              ELSE COALESCE (tmpMICalc_inf.PriceIn_fact,0)              END AS PriceIn_fact              -- с/с факт
                                    , CASE WHEN COALESCE (tmpMICalc.PriceIn_plan,0) <> 0              THEN tmpMICalc.PriceIn_plan              ELSE COALESCE (tmpMICalc_inf.PriceIn_plan,0)              END AS PriceIn_plan              -- с/с план
                                    , CASE WHEN COALESCE (tmpMICalc.ContractCondition_persent,0) <> 0 THEN tmpMICalc.ContractCondition_persent ELSE COALESCE (tmpMICalc_inf.ContractCondition_persent,0) END AS ContractCondition_persent --бонус сети %
                                    , CASE WHEN COALESCE (tmpMICalc.ContractCondition,0) <> 0         THEN tmpMICalc.ContractCondition         ELSE COALESCE (tmpMICalc_inf.ContractCondition,0)         END AS ContractCondition         --бонус сети сумма
                                    , CASE WHEN COALESCE (tmpMICalc.PriceWithVAT,0) <> 0              THEN tmpMICalc.PriceWithVAT              ELSE COALESCE (tmpMICalc_inf.PriceWithVAT,0)              END AS PriceWithVAT_calc         -- цена с ндс с учетом скидки
                                    , CASE WHEN COALESCE (tmpMICalc.SummaProfit_fact,0) <> 0          THEN tmpMICalc.SummaProfit_fact          ELSE COALESCE (tmpMICalc_inf.SummaProfit_fact,0)          END AS SummaProfit_fact          --прибыль факт
                                    , CASE WHEN COALESCE (tmpMICalc.SummaProfit_plan,0) <> 0          THEN tmpMICalc.SummaProfit_plan          ELSE COALESCE (tmpMICalc_inf.SummaProfit_plan,0)          END AS SummaProfit_plan          --прибыль план

                               FROM tmpMI AS MovementItem
                                      LEFT JOIN tmpMovementItemFloat AS MIFloat_Price
                                                                     ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                      LEFT JOIN tmpMovementItemFloat AS MIFloat_PriceWithOutVAT
                                                                     ON MIFloat_PriceWithOutVAT.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT()
                                      LEFT JOIN tmpMovementItemFloat AS MIFloat_PriceWithVAT
                                                                     ON MIFloat_PriceWithVAT.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
                                      LEFT JOIN tmpMovementItemFloat AS MIFloat_PriceSale
                                                                     ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
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
                                      LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlanMin
                                                                     ON MIFloat_AmountPlanMin.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_AmountPlanMin.DescId = zc_MIFloat_AmountPlanMin()
                                      LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlanMax
                                                                     ON MIFloat_AmountPlanMax.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_AmountPlanMax.DescId = zc_MIFloat_AmountPlanMax()

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

                                      LEFT JOIN tmpMICalc ON tmpMICalc.MovementId = MovementItem.MovementId
                                                         AND tmpMICalc.MovementItemId = MovementItem.Id
                                      LEFT JOIN (SELECT tmpMICalc.*
                                                 FROM tmpMICalc
                                                 WHERE tmpMICalc.Ord = 1) AS tmpMICalc_inf 
                                                                          ON tmpMICalc_inf.MovementId = MovementItem.MovementId
                                                                         AND tmpMICalc_inf.GoodsId = MovementItem.ObjectId
                                      
                               GROUP BY MovementItem.MovementId
                                      , MovementItem.ObjectId
                                      , Object_Goods.ObjectCode
                                      , Object_Goods.ValueData
                                      , Object_Measure.ValueData
                                      , Object_Measure.Id
                                      , Object_TradeMark.ValueData
                                      , Object_GoodsKind.ValueData
                                      , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END
                                      , CASE WHEN inIsGoodsKind = FALSE THEN MovementItem.Id ELSE 0 END
                                      , MIFloat_Price.ValueData
                                      , MIFloat_PriceWithOutVAT.ValueData
                                      , MIFloat_PriceWithVAT.ValueData
                                      , MIFloat_PriceSale.ValueData
                                      , CASE WHEN COALESCE (tmpMICalc.PriceIn_fact,0) <> 0              THEN tmpMICalc.PriceIn_fact              ELSE COALESCE (tmpMICalc_inf.PriceIn_fact,0)              END -- с/с факт
                                      , CASE WHEN COALESCE (tmpMICalc.PriceIn_plan,0) <> 0              THEN tmpMICalc.PriceIn_plan              ELSE COALESCE (tmpMICalc_inf.PriceIn_plan,0)              END -- с/с план
                                      , CASE WHEN COALESCE (tmpMICalc.ContractCondition_persent,0) <> 0 THEN tmpMICalc.ContractCondition_persent ELSE COALESCE (tmpMICalc_inf.ContractCondition_persent,0) END --бонус сети %
                                      , CASE WHEN COALESCE (tmpMICalc.ContractCondition,0) <> 0         THEN tmpMICalc.ContractCondition         ELSE COALESCE (tmpMICalc_inf.ContractCondition,0)         END --бонус сети сумма
                                      , CASE WHEN COALESCE (tmpMICalc.PriceWithVAT,0) <> 0              THEN tmpMICalc.PriceWithVAT              ELSE COALESCE (tmpMICalc_inf.PriceWithVAT,0)              END -- цена с ндс с учетом скидки
                                      , CASE WHEN COALESCE (tmpMICalc.SummaProfit_fact,0) <> 0          THEN tmpMICalc.SummaProfit_fact          ELSE COALESCE (tmpMICalc_inf.SummaProfit_fact,0)          END --прибыль факт
                                      , CASE WHEN COALESCE (tmpMICalc.SummaProfit_plan,0) <> 0          THEN tmpMICalc.SummaProfit_plan          ELSE COALESCE (tmpMICalc_inf.SummaProfit_plan,0)          END --прибыль план
                               )
           -- эл. подпись, выбираем те что уже подписаны полностью 
           , tmpSign AS (SELECT tmpMovement.Id
                              , tmpSign.strSign
                              , tmpSign.strSignNo
                         FROM tmpMovement
                              LEFT JOIN lpSelect_MI_Sign (inMovementId:= tmpMovement.Id ) AS tmpSign ON tmpSign.Id = tmpMovement.Id
                         WHERE COALESCE (tmpSign.strSignNo,'') =''
                         )
                         
        --
        SELECT
            Movement_Promo.Id                --ИД документа акции
          , Movement_Promo.InvNumber          --№ документа акции
          , Movement_Promo.StatusCode         --
          , Movement_Promo.StatusName         --

          , Movement_Promo.UnitName           --Склад
          , Movement_Promo.PersonalTradeName  --Ответственный представитель коммерческого отдела
          , Movement_Promo.PersonalName       --Ответственный представитель маркетингового отдела
          , Movement_Promo.StartSale          --Дата начала отгрузки по акционной цене
          , Movement_Promo.EndSale            --Дата окончания отгрузки по акционной цене
          , Movement_Promo.StartPromo         --Дата начала акции
          , Movement_Promo.EndPromo           --Дата окончания акции
          , Movement_Promo.MonthPromo         --месяц акции
          , Movement_Promo.CheckDate          --Дата Согласования

            --------------------------------------
            
          , (CASE WHEN vbUserId = 5
            THEN LENGTH (
            COALESCE ((SELECT STRING_AGG (DISTINCT COALESCE (MovementString_Retail.ValueData, Object_Retail.ValueData),'; ')
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

                          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                               ON ObjectLink_Partner_Juridical.ObjectId = MLO_Partner.ObjectId
                                              AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                                              and 1=0
                          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                               ON ObjectLink_Juridical_Retail.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MLO_Partner.ObjectId)
                                              AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
                                              and 1=0

                INNER JOIN Object ON Object.Id = COALESCE (ObjectLink_Juridical_Retail.ChildObjectId, ObjectLink_Partner_Juridical.ChildObjectId, MLO_Partner.ObjectId)
             WHERE Movement_PromoPartner.ParentId = Movement_Promo.Id
               AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
               AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
              )))
               :: TVarChar || '-'
            ELSE ''
            END 
       || 
       
       LEFT (
       

COALESCE (-- первый - автоматом сформированные MovementItem - всегда Контрагент
          (SELECT STRING_AGG (DISTINCT COALESCE (MovementString_Retail.ValueData, Object_Retail.ValueData),'; ')
                       FROM
                          Movement AS Movement_PromoPartner
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
          , -- второй - ввели Юр.л или Контрагент
            (SELECT STRING_AGG (DISTINCT Object.ValueData,'; ')
             FROM
                  Movement AS Movement_PromoPartner
                  INNER JOIN MovementLinkObject AS MLO_Partner
                                                ON MLO_Partner.MovementId = Movement_PromoPartner.ID
                                               AND MLO_Partner.DescId     = zc_MovementLinkObject_Partner()
  
                  LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                       ON ObjectLink_Partner_Juridical.ObjectId = MLO_Partner.ObjectId
                                      AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                                    --AND 1=0
                  LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                       ON ObjectLink_Juridical_Retail.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MLO_Partner.ObjectId)
                                      AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
                                    --AND 1=0
  
                  INNER JOIN Object ON Object.Id = COALESCE (ObjectLink_Juridical_Retail.ChildObjectId, ObjectLink_Partner_Juridical.ChildObjectId, MLO_Partner.ObjectId)
             WHERE Movement_PromoPartner.ParentId = Movement_Promo.Id
               AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
               AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
              ))
       
       , 4000))::TBlob AS RetailName
            --------------------------------------
          , (SELECT STRING_AGG (DISTINCT Object_Area.ValueData,'; ')
             FROM
                Movement AS Movement_PromoPartner
                INNER JOIN MovementItem AS MI_PromoPartner
                                        ON MI_PromoPartner.MovementId = Movement_PromoPartner.ID
                                       AND MI_PromoPartner.DescId     = zc_MI_Master()
                                       AND MI_PromoPartner.IsErased   = FALSE
                INNER JOIN ObjectLink AS ObjectLink_Partner_Area
                                      ON ObjectLink_Partner_Area.ObjectId = MI_PromoPartner.ObjectId
                                     AND ObjectLink_Partner_Area.DescId   = zc_ObjectLink_Partner_Area()
                INNER JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Partner_Area.ChildObjectId

             WHERE Movement_PromoPartner.ParentId = Movement_Promo.Id
               AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
               AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
            )::TBlob AS AreaName
            
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
          , MI_PromoGoods.Measure
          , MI_PromoGoods.TradeMark
          , MI_PromoGoods.AmountPlanMin      ::TFloat --Минимум планируемого объема продаж на акционный период (в кг)
          , MI_PromoGoods.AmountPlanMinWeight::TFloat --Минимум планируемого объема продаж на акционный период (в кг) Вес
          , MI_PromoGoods.AmountPlanMax      ::TFloat --Максимум планируемого объема продаж на акционный период (в кг)
          , MI_PromoGoods.AmountPlanMaxWeight::TFloat --Максимум планируемого объема продаж на акционный период (в кг) Вес
          , MI_PromoGoods.AmountReal         ::TFloat --Объем продаж в аналогичный период, кг
          , MI_PromoGoods.AmountRealWeight   ::TFloat --Объем продаж в аналогичный период, кг Вес
          , MI_PromoGoods.AmountOrder        ::TFloat --Кол-во заявка (факт)
          , MI_PromoGoods.AmountOrderWeight  ::TFloat --Кол-во заявка (факт) Вес
          , MI_PromoGoods.AmountOut          ::TFloat --Кол-во реализация (факт)
          , MI_PromoGoods.AmountOutWeight    ::TFloat --Кол-во реализация (факт) Вес
          , MI_PromoGoods.AmountIn           ::TFloat --Кол-во возврат (факт)
          , MI_PromoGoods.AmountInWeight     ::TFloat --Кол-во возврат (факт) Вес
          , MI_PromoGoods.GoodsKindName       --Наименование обьекта <Вид товара>
         -- , MI_PromoGoods.GoodsKindCompleteName -- --Наименование обьекта <Вид товара (примечание)>

          /*, CASE WHEN inIsGoodsKind = FALSE THEN MI_PromoGoods.GoodsKindCompleteName
                 ELSE (SELECT STRING_AGG (DISTINCT Object_GoodsKindComplete.ValueData,'; ') AS GoodsKindCompleteName
                       FROM MovementItem AS MI_Promo
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                             ON MILinkObject_GoodsKindComplete.MovementItemId = MI_Promo.Id
                                                            AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                            LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = MILinkObject_GoodsKindComplete.ObjectId

                       WHERE MI_Promo.MovementId = Movement_Promo.Id
                         AND MI_Promo.DescId     = zc_MI_Master()
                         AND MI_Promo.IsErased   = FALSE
                      )
            END  ::TVarChar AS GoodsKindCompleteName
            */
          , MI_PromoGoods.GoodsKindCompleteName         ::TVarChar AS GoodsKindCompleteName

          , MI_PromoGoods.GoodsKindCompleteName_byPrint ::TVarChar AS GoodsKindCompleteName_byPrint

          , (SELECT STRING_AGG (DISTINCT tmpGoodsKind.GoodsKindName,'; ')
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


          , CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN MI_PromoGoods.GoodsWeight ELSE NULL END :: TFloat AS GoodsWeight

          , (REPLACE (TO_CHAR (MI_PromoGoods.Amount,'FM99990D99')||' ','. ','')||'  '||chr(13)||
              (SELECT STRING_AGG (MovementItem_PromoCondition.ConditionPromoName||': '||REPLACE (TO_CHAR (MovementItem_PromoCondition.Amount,'FM999990D09')||' ','.0 ',''), chr(13))
               FROM MovementItem_PromoCondition_View AS MovementItem_PromoCondition
               WHERE MovementItem_PromoCondition.MovementId = Movement_Promo.Id
                 AND MovementItem_PromoCondition.IsErased   = FALSE))  :: TBlob   AS Discount

          , MI_PromoGoods.PriceWithOutVAT                                         AS PriceWithOutVAT
          , MI_PromoGoods.PriceWithVAT                                            AS PriceWithVAT
          , CASE WHEN vbShowAll THEN ROUND (MI_PromoGoods.Price * ((100 + Movement_Promo.VATPercent)/100), 2) END :: TFloat    AS Price       ---MI_PromoGoods.Price
          , CASE WHEN vbShowAll THEN Movement_Promo.CostPromo END    :: TFloat    AS CostPromo

          , CASE WHEN vbShowAll THEN
                (SELECT STRING_AGG (Movement_PromoAdvertising.AdvertisingName,'; ')
                 FROM (SELECT DISTINCT Movement_PromoAdvertising_View.AdvertisingName
                       FROM Movement_PromoAdvertising_View
                       WHERE Movement_PromoAdvertising_View.ParentId = Movement_Promo.Id
                         AND COALESCE (Movement_PromoAdvertising_View.AdvertisingName,'') <> ''
                         AND Movement_PromoAdvertising_View.isErASed = FALSE
                      ) AS Movement_PromoAdvertising
                ) END                                                :: TBlob     AS AdvertisingName

          , CASE WHEN vbShowAll THEN Movement_Promo.OperDate END     :: TDateTime AS OperDate
          , CASE WHEN vbShowAll THEN MI_PromoGoods.PriceSale END     :: TFloat    AS PriceSale
          , Movement_Promo.Comment                                                AS Comment
          , Movement_Promo.CommentMain      :: TVarChar                           AS CommentMain
          , vbShowAll                                                             AS ShowAll
          , Movement_Promo.isPromo                                                AS isPromo
          , Movement_Promo.Checked                                                AS Checked

          , Movement_Promo.PromoStateKindName   ::TVarChar
          , Movement_Promo.Color_PromoStateKind :: Integer
          , tmpSign.strSign                     ::TVarChar-- -- эл.подписи  -- 
          
          , MI_PromoGoods.PriceIn_fact             ::TFloat                     -- с/с факт
          , MI_PromoGoods.PriceIn_plan             ::TFloat                     -- с/с план
          , MI_PromoGoods.ContractCondition_persent::TFloat                     --бонус сети %
          , MI_PromoGoods.ContractCondition        ::TFloat                     --бонус сети сумма
          , MI_PromoGoods.PriceWithVAT_calc        ::TFloat                     -- цена с ндс с учетом скидки
          , MI_PromoGoods.SummaProfit_fact         ::TFloat                     --прибыль факт
          , MI_PromoGoods.SummaProfit_plan         ::TFloat                     --прибыль план
          
          , (EXTRACT (DAY from Movement_Promo.EndSale - Movement_Promo.StartSale) + 1)         ::Integer AS Days_Sale
          , (EXTRACT (DAY from Movement_Promo.OperDateEnd - Movement_Promo.OperDateStart) + 1) ::Integer AS Days_Real                        
        FROM
            tmpMovement_Promo AS Movement_Promo
            LEFT OUTER JOIN tmpMI_PromoGoods AS MI_PromoGoods ON MI_PromoGoods.MovementId = Movement_Promo.Id
            LEFT JOIN tmpSign ON tmpSign.Id = Movement_Promo.Id   -- эл.подписи  --

               ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_Report_Promo (TDateTime,TDateTime,Integer,TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 24.01.25         *
 07.11.17         *
 25.07.17         *
 01.12.15                                                          *
*/

-- тест
-- SELECT * FROM gpSelect_Report_Promo (inStartDate:= ('01.04.2024')::TDateTime , inEndDate:= ('01.04.2024')::TDateTime , inIsPromo := 'False' , inIsTender := 'False' ,inIsGoodsKind := 'true', inUnitId := 0 ,  inSession := '5'::TVarchar) -- where invnumber = 6862
