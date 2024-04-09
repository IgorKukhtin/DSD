DROP FUNCTION IF EXISTS gpReport_Promo_Market(
    TDateTime, --дата начала периода
    TDateTime, --дата окончания периода
    Boolean,   --показать только Акции
    Boolean,   --показать только Тендеры
    Integer,   --подразделение
    Integer,   --юр.лицо
    TVarChar   --сессия пользователя
);

DROP FUNCTION IF EXISTS gpReport_Promo_Market(
    TDateTime, --дата начала периода
    TDateTime, --дата окончания периода
    Boolean,   --показать только Акции
    Boolean,   --показать только Тендеры
    Boolean,   -- разворачиваем
    Integer,   --подразделение
    Integer,   --юр.лицо
    TVarChar   --сессия пользователя
);
CREATE OR REPLACE FUNCTION gpReport_Promo_Market(
    IN inStartDate      TDateTime, --дата начала периода
    IN inEndDate        TDateTime, --дата окончания периода
    IN inIsPromo        Boolean,   --показать только Акции
    IN inIsTender       Boolean,   --показать только Тендеры
    IN inIsDetail       Boolean,   -- разворачиваем по товарам + ценам, иначе группируем по док акции + юр лицо из документа прод/возврат
    IN inUnitId         Integer,   --подразделение
    IN inJuridicalId    Integer,   --юр.лицо
    IN inSession        TVarChar   --сессия пользователя
)

RETURNS TABLE(
      MovementId           Integer   --ИД документа акции
    , OperDate             TDateTime -- * Статус внесения в базу
    , InvNumber            TVarChar   --№ документа акции
    , StatusCode Integer, StatusName TVarChar
    , UnitName            TVarChar  --Склад
    , BranchId Integer, BranchName TVarChar
    , DateStartSale       TDateTime       --Дата начала отгрузки по акционной цене
    , DateFinalSale       TDateTime       --Дата окончания отгрузки по акционной цене
    , DateStartPromo      TDateTime       --Дата начала акции
    , DateFinalPromo      TDateTime       --Дата окончания акции
    , MonthPromo          TDateTime       --месяц акции
    , PromoKindName        TVarChar    --Условия участия в акции
    , PromoStateKindName   TVarChar    --Состояние акции
    , RetailName           TBlob     --Сеть, в которой проходит акция
    , JuridicalName_str    TBlob     --юр.лица
    , GoodsName            TVarChar  --Позиция
    , GoodsCode            Integer   --Код позиции
    , MeasureName          TVarChar  --единица измерения
    , TradeMarkName        TVarChar  --Торговая марка
    , GoodsKindName             TVarChar  --Вид упаковки
    , AmountOut_fact            TFloat    --Кол-во реализация (факт)
    , AmountOutWeight_fact      TFloat    --Кол-во реализация (факт) Вес
    , AmountIn_fact             TFloat    --Кол-во возврат (факт)
    , AmountInWeight_fact       TFloat    --Кол-во возврат (факт) Вес

    , SummOut_diff TFloat  -- summa разницы цен (по прайсу и промо) * кг продажи
    , SummIn_diff TFloat   -- summa разницы цен (по прайсу и промо) * кг возврат
    , Summ_diff TFloat     -- summa разницы цен (по прайсу и промо) * кг (продажи-возврат)
    , Price_pl TFloat      -- цена прайс
    , Price    TFloat      -- цена из документа
    , JuridicalId_fact       Integer  -- Юр.лица из док. продаж/возврата
    , JuridicalName_str_fact TVarChar -- Юр.лица из док. продаж/возврата
    , ContractId Integer, ContractCode Integer, ContractNumber TVarChar, ContractTagName TVarChar
    , ContractId_21512 Integer, ContractCode_21512 Integer, ContractNumber_21512 TVarChar, ContractTagName_21512 TVarChar
    , InfoMoneyId_21512 Integer, InfoMoneyCode_21512 Integer, InfoMoneyName_21512 TVarChar
    , PaidKindId_21512 Integer
     )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

/*
берем акциии которые попадают по StartSale + EndSale
     + условие не все акции а только у которых zc_MovementLinkObject_PromoKind = В счет маркетингового бюджета,
дальше только для продаж и возвратов с такой акцией по OperDatePartner считаем кол-во кг *(цена по прайсу на дату накл - цена в накл)
*/

    -- Результат
    RETURN QUERY
     WITH
        -- 1) берем док акция у которой период отгрузки с .. по ...  который попадает в период отчет
      tmpMovement_all AS (SELECT Movement_Promo.*
                               , MovementDate_StartSale.ValueData            AS StartSale          --Дата начала отгрузки по акционной цене
                               , MovementDate_EndSale.ValueData              AS EndSale            --Дата окончания отгрузки по акционной цене
                               , MovementLinkObject_Unit.ObjectId            AS UnitId
                               , COALESCE (MovementBoolean_Promo.ValueData, FALSE)   :: Boolean AS isPromo  -- акция (да/нет)
                               , MovementLinkObject_PromoKind.ObjectId       AS PromoKindId        --Вид акции
                          FROM Movement AS Movement_Promo
                             INNER JOIN MovementLinkObject AS MovementLinkObject_PromoKind
                                                           ON MovementLinkObject_PromoKind.MovementId = Movement_Promo.Id
                                                          AND MovementLinkObject_PromoKind.DescId = zc_MovementLinkObject_PromoKind()
                                                          AND MovementLinkObject_PromoKind.ObjectId = zc_Enum_PromoKind_Budget()

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
                             OR inStartDate BETWEEN MovementDate_StartSale.ValueData AND MovementDate_EndSale.ValueData
                               )
                           AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)
                           AND Movement_Promo.StatusId = zc_Enum_Status_Complete()
                           AND (  (COALESCE (MovementBoolean_Promo.ValueData, FALSE) = TRUE AND inIsPromo = TRUE)
                               OR (COALESCE (MovementBoolean_Promo.ValueData, FALSE) = FALSE AND inIsTender = TRUE)
                               OR (inIsPromo = FALSE AND inIsTender = FALSE)
                               )
                            )
          -- компенсация в счет маркетингового бюджета
        , tmpPromoCondition AS (SELECT MovementItem.MovementId
                                FROM MovementItem
                                WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement_all.Id FROM tmpMovement_all) 
                                  AND MovementItem.DescId     = zc_MI_Child()
                                  AND MovementItem.isErased   = FALSE
                                  AND MovementItem.ObjectId   = zc_Enum_ConditionPromo_Budget()
                                  AND MovementItem.Amount     > 0
                               )
          -- 
        , tmpMovement AS (SELECT tmpMovement_all.*
                          FROM tmpMovement_all
                          WHERE tmpMovement_all.Id IN (SELECT DISTINCT tmpPromoCondition.MovementId FROM tmpPromoCondition) 
                         )

        , tmpMovement_Promo AS (SELECT
                                Movement_Promo.Id                                                 --Идентификатор
                              , Movement_Promo.OperDate
                              , Movement_Promo.InvNumber                                          --Идентификатор
                              , Movement_Promo.UnitId
                              , Object_Unit.ValueData                       AS UnitName           --Подразделение
                              , Object_PromoKind.ValueData                  AS PromoKindName      --Условия участия в акции
                              , Object_PromoStateKind.Id                    AS PromoStateKindId        --Состояние акции
                              , Object_PromoStateKind.ValueData             AS PromoStateKindName      --Состояние акции
                              , MovementDate_StartPromo.ValueData           AS StartPromo         --Дата начала акции
                              , MovementDate_EndPromo.ValueData             AS EndPromo           --Дата окончания акции
                              , Movement_Promo.StartSale                    AS StartSale          --Дата начала отгрузки по акционной цене
                              , Movement_Promo.EndSale                      AS EndSale            --Дата окончания отгрузки по акционной цене
                              , DATE_TRUNC ('MONTH', MovementDate_Month.ValueData) :: TDateTime AS MonthPromo         -- месяц акции
                              , COALESCE (Movement_Promo.isPromo, FALSE)   :: Boolean AS isPromo  -- акция (да/нет)
                              , Object_Status.ObjectCode                    AS StatusCode         --
                              , Object_Status.ValueData                     AS StatusName         --
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
                             LEFT JOIN Object AS Object_PromoKind ON Object_PromoKind.Id = Movement_Promo.PromoKindId

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_PromoStateKind
                                                          ON MovementLinkObject_PromoStateKind.MovementId = Movement_Promo.Id
                                                         AND MovementLinkObject_PromoStateKind.DescId = zc_MovementLinkObject_PromoStateKind()
                             LEFT JOIN Object AS Object_PromoStateKind ON Object_PromoStateKind.Id = MovementLinkObject_PromoStateKind.ObjectId
                        )

          -- выбираем все док продажи и возврата по док. Акция
        , tmpMovementSale_1 AS (SELECT Movement.Id
                                     , Movement.OperDate
                                     , MovementDate_OperDatePartner.ValueData AS OperDatePartner
                                     , Movement.Invnumber
                                     , Movement.DescId
                                     , MovementItem.Id AS MovementItemId
                                     , MovementItem.ObjectId            AS GoodsId
                                     , MIFloat_PromoMovement.ValueData ::Integer AS MovementId_promo
                                     , MovementItem.Amount
                                FROM MovementItemFloat AS MIFloat_PromoMovement
                                     INNER JOIN MovementItem ON MovementItem.Id = MIFloat_PromoMovement.MovementItemId
                                                            AND MovementItem.isErased = FALSE
                                     INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                        AND Movement.StatusId = zc_Enum_Status_Complete()
                                                        AND Movement.DescId IN ( zc_Movement_Sale(), zc_Movement_ReturnIn())
                                     INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                                             ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                            AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                                            AND MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                                WHERE MIFloat_PromoMovement.ValueData IN (SELECT DISTINCT tmpMovement_Promo.Id FROM tmpMovement_Promo)
                                  AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                              )

        , tmpMovementSale_2 AS (SELECT Movement.*
                                     , MovementLinkObject_Contract.ObjectId AS ContractId
                                     , MovementLinkObject_Partner.ObjectId  AS PartnerId
                                FROM tmpMovementSale_1 AS Movement
                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                                  ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                                 AND MovementLinkObject_Partner.DescId = CASE WHEN Movement.DescId = zc_Movement_Sale() THEN zc_MovementLinkObject_From() ELSE zc_MovementLinkObject_To() END
                                )

        , tmpPriceListAll AS (SELECT Movement.ContractId
                                   , Movement.PartnerId
                                   , Movement.OperDate
                                   , tmp.PriceListId
                              FROM (SELECT DISTINCT tmp.OperDate, tmp.OperDatePartner, tmp.ContractId, tmp.PartnerId  FROM tmpMovementSale_2 AS tmp) AS Movement
                                  LEFT JOIN lfGet_Object_Partner_PriceList_onDate (inContractId     := Movement.ContractId
                                                                                 , inPartnerId      := Movement.PartnerId
                                                                                 , inMovementDescId := zc_Movement_Sale() -- !!!не ошибка!!!
                                                                                 , inOperDate_order := Movement.OperDate
                                                                                 , inOperDatePartner:= NULL
                                                                                 , inDayPrior_PriceReturn:= 0 -- !!!параметр здесь не важен!!!
                                                                                 , inIsPrior        := FALSE -- !!!параметр здесь не важен!!!
                                                                                 , inOperDatePartner_order:= Movement.OperDatePartner
                                                                                  ) AS tmp ON 1=1

                              )

        , tmpMovementSale AS (SELECT Movement.*
                                   , tmpPriceListAll.PriceListId
                              FROM tmpMovementSale_2 AS Movement
                                   LEFT JOIN tmpPriceListAll ON tmpPriceListAll.OperDate = Movement.OperDate
                                                            AND tmpPriceListAll.ContractId = Movement.ContractId
                                                            AND tmpPriceListAll.PartnerId = Movement.PartnerId
                              )

          -- Цены из прайса
        , tmpPriceList AS (SELECT tmp.PriceListId
                                , tmp.OperDate
                                , ObjectLink_PriceListItem_Goods.ChildObjectId     AS GoodsId
                                , ObjectLink_PriceListItem_GoodsKind.ChildObjectId AS GoodsKindId
                                , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice
                           FROM (SELECT DISTINCT tmpMovementSale.PriceListId, tmpMovementSale.OperDate FROM tmpMovementSale) AS tmp
                                LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                     ON ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                                                    AND ObjectLink_PriceListItem_PriceList.ChildObjectId = tmp.PriceListId

                                LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                                     ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                    AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                                LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                                     ON ObjectLink_PriceListItem_GoodsKind.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                    AND ObjectLink_PriceListItem_GoodsKind.DescId   = zc_ObjectLink_PriceListItem_GoodsKind()

                                LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                        ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                       AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                                       AND tmp.OperDate >= ObjectHistory_PriceListItem.StartDate AND tmp.OperDate < ObjectHistory_PriceListItem.EndDate
                                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                             ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                            AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                           WHERE ObjectHistoryFloat_PriceListItem_Value.ValueData <> 0
                           )

        , tmpMI_GoodsKind AS (SELECT *
                              FROM MovementItemLinkObject
                              WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMovementSale.MovementItemId FROM tmpMovementSale)
                                AND MovementItemLinkObject.DescId         = zc_MILinkObject_GoodsKind()
                              )

        , tmpMovementItemFloat AS (SELECT *
                                   FROM MovementItemFloat
                                   WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMovementSale.MovementItemId FROM tmpMovementSale)
                                     AND MovementItemFloat.DescId IN (zc_MIFloat_AmountPartner()
                                                                    , zc_MIFloat_Price())
                                   )

        , tmpMLO_Juridical AS (SELECT tmp.Id AS MovementId
                                    , Object_Juridical.Id             AS JuridicalId
                                    , Object_Juridical.ValueData      AS JuridicalName
                               FROM (SELECT DISTINCT tmpMovementSale.Id, tmpMovementSale.DescId FROM tmpMovementSale) AS tmp
                                    LEFT JOIN MovementLinkObject ON MovementLinkObject.MovementId = tmp.Id
                                                                AND MovementLinkObject.DescId = CASE WHEN tmp.DescId = zc_Movement_Sale() THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END
                                    LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                         ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject.ObjectId
                                                        AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                    LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId
                               )

        , tmpDataFact AS (SELECT Movement.MovementId_promo
                               , Movement.ContractId
                               , tmpMLO_Juridical.JuridicalId
                               , tmpMLO_Juridical.JuridicalName
                               , CASE WHEN inIsDetail = TRUE THEN Movement.GoodsId ELSE 0 END AS GoodsId
                               , CASE WHEN inIsDetail = TRUE THEN MILinkObject_GoodsKind.ObjectId ELSE 0 END AS GoodsKindId
                               , CASE WHEN inIsDetail = TRUE THEN ObjectLink_Goods_Measure.ChildObjectId ELSE 0 END AS MeasureId

                               , SUM (CASE WHEN Movement.DescId = zc_Movement_Sale()  THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END)          :: TFloat AS AmountOut
                               , SUM ( CASE WHEN Movement.DescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END
                                       * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END ) :: TFloat AS AmountOutWeight

                               , SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END)       :: TFloat AS AmountIn
                               , SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END
                                      * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END )  :: TFloat AS AmountInWeight

                               , SUM (CASE WHEN Movement.DescId = zc_Movement_Sale()  THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END
                                      * (COALESCE (tmpPriceList.ValuePrice,tmpPriceListAll.ValuePrice,0) - COALESCE (MIFloat_Price.ValueData,0) ) )          :: TFloat AS SummOut
                               , SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END
                                      * (COALESCE (tmpPriceList.ValuePrice,tmpPriceListAll.ValuePrice,0) - COALESCE (MIFloat_Price.ValueData,0) ) )          :: TFloat AS SummIn

                               , CASE WHEN inIsDetail = TRUE THEN COALESCE (tmpPriceList.ValuePrice,tmpPriceListAll.ValuePrice,0) ELSE 0 END AS Price_pl
                               , CASE WHEN inIsDetail = TRUE THEN COALESCE (MIFloat_Price.ValueData,0) ELSE 0 END                            AS Price
                          FROM tmpMovementSale AS Movement

                               LEFT JOIN tmpMI_GoodsKind AS MILinkObject_GoodsKind ON MILinkObject_GoodsKind.MovementItemId = Movement.MovementItemId

                               LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPartner
                                                              ON MIFloat_AmountPartner.MovementItemId = Movement.MovementItemId
                                                             AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                               LEFT JOIN tmpMovementItemFloat AS MIFloat_Price
                                                              ON MIFloat_Price.MovementItemId = Movement.MovementItemId
                                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()

                               LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                    ON ObjectLink_Goods_Measure.ObjectId = Movement.GoodsId
                                                   AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()

                               LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Goods_Weight
                                                           ON ObjectFloat_Goods_Weight.ObjectId = Movement.GoodsId
                                                          AND ObjectFloat_Goods_Weight.DescId = zc_ObjectFloat_Goods_Weight()

                               LEFT JOIN tmpPriceList ON tmpPriceList.PriceListId = Movement.PriceListId
                                                     AND tmpPriceList.OperDate = Movement.OperDate
                                                     AND tmpPriceList.GoodsId = Movement.GoodsId
                                                     AND COALESCE (tmpPriceList.GoodsKindId,0) = COALESCE (MILinkObject_GoodsKind.ObjectId,0)
                               LEFT JOIN tmpPriceList AS tmpPriceListAll
                                                      ON tmpPriceListAll.PriceListId = Movement.PriceListId
                                                     AND tmpPriceListAll.OperDate = Movement.OperDate
                                                     AND tmpPriceListAll.GoodsId = Movement.GoodsId
                                                     AND COALESCE (tmpPriceListAll.GoodsKindId,0) = 0

                               LEFT JOIN tmpMLO_Juridical ON tmpMLO_Juridical.MovementId = Movement.Id
                          GROUP BY Movement.MovementId_promo
                                 , Movement.ContractId
                                 , tmpMLO_Juridical.JuridicalId
                                 , tmpMLO_Juridical.JuridicalName
                                 , CASE WHEN inIsDetail = TRUE THEN Movement.GoodsId ELSE 0 END
                                 , CASE WHEN inIsDetail = TRUE THEN MILinkObject_GoodsKind.ObjectId ELSE 0 END
                                 , CASE WHEN inIsDetail = TRUE THEN ObjectLink_Goods_Measure.ChildObjectId ELSE 0 END
                                 , CASE WHEN inIsDetail = TRUE THEN COALESCE (tmpPriceList.ValuePrice,tmpPriceListAll.ValuePrice,0) ELSE 0 END
                                 , CASE WHEN inIsDetail = TRUE THEN COALESCE (MIFloat_Price.ValueData,0) ELSE 0 END
                                 , CASE WHEN inIsDetail = TRUE THEN tmpMLO_Juridical.JuridicalName ELSE '' END
                          )

         , tmpContract AS (SELECT * FROM Object_Contract_InvNumber_View WHERE Object_Contract_InvNumber_View.ContractId IN (SELECT DISTINCT tmpDataFact.ContractId FROM tmpDataFact))
           --
         , tmpContractCondition AS (SELECT Object_ContractCondition_View.*
                                         , ObjectLink_ContractCondition_ContractSend.ChildObjectId AS ContractId_send
                                         , COALESCE (ObjectLink_ContractCondition_InfoMoney.ChildObjectId, Object_ContractCondition_View.InfoMoneyId) AS InfoMoneyId_send
                                           -- № п/п
                                         , ROW_NUMBER() OVER (PARTITION BY Object_ContractCondition_View.ContractId ORDER BY COALESCE (ObjectLink_ContractCondition_InfoMoney.ChildObjectId, 0) DESC) AS Ord

                                    FROM Object_ContractCondition_View
                                         LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_ContractSend
                                                              ON ObjectLink_ContractCondition_ContractSend.ObjectId = Object_ContractCondition_View.ContractConditionId
                                                             AND ObjectLink_ContractCondition_ContractSend.DescId = zc_ObjectLink_ContractCondition_ContractSend()
                                         -- УП статья в условии договора
                                         LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_InfoMoney
                                                              ON ObjectLink_ContractCondition_InfoMoney.ObjectId = Object_ContractCondition_View.ContractConditionId
                                                             AND ObjectLink_ContractCondition_InfoMoney.DescId   = zc_ObjectLink_ContractCondition_InfoMoney()
                                    WHERE Object_ContractCondition_View.ContractId IN (SELECT DISTINCT tmpDataFact.ContractId FROM tmpDataFact)
                                      AND (Object_ContractCondition_View.InfoMoneyId            = zc_Enum_InfoMoney_21512() -- Маркетинговый бюджет
                                        OR ObjectLink_ContractCondition_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_21512() -- Маркетинговый бюджет
                                          )
                                      AND ObjectLink_ContractCondition_ContractSend.ChildObjectId > 0
                                   )
       /*, tmpContract_21512_all AS (SELECT ObjectLink_Contract_Juridical.ChildObjectId AS JuridicalId, tmpContract.ContractId
                                     FROM tmpContract
                                          JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                          ON ObjectLink_Contract_Juridical.ObjectId = tmpContract.ContractId
                                                         AND ObjectLink_Contract_Juridical.DescId   = zc_ObjectLink_Contract_Juridical()
                                          JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                                          ON ObjectLink_Contract_PaidKind.ObjectId      = tmpContract.ContractId
                                                         AND ObjectLink_Contract_PaidKind.DescId        = zc_ObjectLink_Contract_PaidKind()
                                                         AND ObjectLink_Contract_PaidKind.ChildObjectId = zc_Enum_PaidKind_FirstForm()
                                     WHERE tmpContract.InfoMoneyId = zc_Enum_InfoMoney_21512() -- Маркетинговый бюджет
                                    UNION
                                     SELECT ObjectLink_Contract_Juridical.ChildObjectId AS JuridicalId, tmpContractCondition.ContractId
                                     FROM tmpContractCondition
                                          JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                          ON ObjectLink_Contract_Juridical.ObjectId = tmpContractCondition.ContractId
                                                         AND ObjectLink_Contract_Juridical.DescId   = zc_ObjectLink_Contract_Juridical()
                                     WHERE tmpContractCondition.PaidKindId_Condition = zc_Enum_PaidKind_FirstForm()
                                        OR (tmpContractCondition.PaidKindId = zc_Enum_PaidKind_FirstForm()
                                        AND COALESCE (tmpContractCondition.PaidKindId_Condition, 0) = 0
                                           )
                                    )*/
         , tmpContract_21512 AS (-- SELECT tmpContract_21512_all.JuridicalId, MAX (tmpContract_21512_all.ContractId) AS ContractId FROM tmpContract_21512_all GROUP BY tmpContract_21512_all.JuridicalId
                                 SELECT tmpContractCondition.ContractId AS ContractId_base, tmpContractCondition.ContractId_send, tmpContractCondition.InfoMoneyId_send FROM tmpContractCondition WHERE tmpContractCondition.Ord =  1
                                )
        --
        SELECT
            Movement_Promo.Id                --ИД документа акции
          , Movement_Promo.OperDate :: TDateTime AS OperDate
          , Movement_Promo.InvNumber          --№ документа акции
          , Movement_Promo.StatusCode         --
          , Movement_Promo.StatusName         --

          , Movement_Promo.UnitName           --Склад
          , Object_Branch.Id            AS BranchId
          , Object_Branch.ValueData     AS BranchName
          , Movement_Promo.StartSale    AS DateStartSale      --Дата начала отгрузки по акционной цене
          , Movement_Promo.EndSale      AS DateFinalSale      --Дата окончания отгрузки по акционной цене
          , Movement_Promo.StartPromo   AS DateStartPromo      --Дата начала акции
          , Movement_Promo.EndPromo     AS DateFinalPromo      --Дата окончания акции
          , Movement_Promo.MonthPromo         --месяц акции
          , Movement_Promo.PromoKindName      --Условия участия в акции
          , Movement_Promo.PromoStateKindName      --Состояние акции
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

          , Object_Goods.ValueData       AS GoodsName
          , Object_Goods.ObjectCode      AS GoodsCode
          , Object_Measure.ValueData     AS MeasureName
          , Object_TradeMark.ValueData   AS TradeMarkName
          , Object_GoodsKind.ValueData   AS GoodsKindName

          , tmpDataFact.AmountOut          ::TFloat AS AmountOut_fact      --Кол-во реализация (факт)
          , tmpDataFact.AmountOutWeight    ::TFloat AS AmountOutWeight_fact--Кол-во реализация (факт) Вес
          , tmpDataFact.AmountIn           ::TFloat AS AmountIn_fact       --Кол-во возврат (факт)
          , tmpDataFact.AmountInWeight     ::TFloat AS AmountInWeight_fact --Кол-во возврат (факт) Вес

          , tmpDataFact.SummOut ::TFloat AS SummOut_diff
          , tmpDataFact.SummIn  ::TFloat AS SummIn_diff
          , (COALESCE (tmpDataFact.SummOut,0) - COALESCE (tmpDataFact.SummIn,0)) ::TFloat AS Summ_diff

          , tmpDataFact.Price_pl ::TFloat
          , tmpDataFact.Price    ::TFloat
          , tmpDataFact.JuridicalId    :: Integer AS JuridicalId_fact
          , tmpDataFact.JuridicalName  ::TVarChar AS JuridicalName_str_fact
          , tmpDataFact.ContractId                AS ContractId
          , View_Contract_InvNumber.ContractCode
          , View_Contract_InvNumber.InvNumber     AS ContractNumber
          , View_Contract_InvNumber.ContractTagName

          , tmpContract_21512.ContractId_send  :: Integer AS ContractId_21512
          , View_Contract_InvNumber_21512.ContractCode    AS ContractCode_21512
          , View_Contract_InvNumber_21512.InvNumber       AS ContractNumber_21512
          , View_Contract_InvNumber_21512.ContractTagName AS ContractTagName_21512

          , Object_InfoMoney_21512.Id AS InfoMoneyId_21512, Object_InfoMoney_21512.ObjectCode AS InfoMoneyCode_21512, Object_InfoMoney_21512.ValueData AS InfoMoneyName_21512
          
          , zc_Enum_PaidKind_FirstForm() :: Integer AS PaidKindId_21512

        FROM tmpDataFact
            LEFT JOIN tmpMovement_Promo AS Movement_Promo
                                        ON Movement_Promo.Id = tmpDataFact.MovementId_promo

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpDataFact.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpDataFact.GoodsKindId
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = tmpDataFact.MeasureId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                 ON ObjectLink_Goods_TradeMark.ObjectId = tmpDataFact.GoodsId
                                AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
            LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

            LEFT JOIN tmpContract_21512 ON tmpContract_21512.ContractId_base = tmpDataFact.ContractId
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber_21512 ON View_Contract_InvNumber_21512.ContractId = tmpContract_21512.ContractId_send
            LEFT JOIN Object AS Object_InfoMoney_21512 ON Object_InfoMoney_21512.Id = tmpContract_21512.InfoMoneyId_send
      
            LEFT JOIN tmpContract AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = tmpDataFact.ContractId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = Movement_Promo.UnitId
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId

        ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.10.21         *
*/

-- тест
-- SELECT * FROM gpReport_Promo_Market(inStartDate := ('01.08.2021')::TDateTime , inEndDate := ('05.08.2021')::TDateTime , inIsPromo := 'False'::Boolean , inIsTender := 'False' ::Boolean, inIsDetail:=true, inUnitId := 0 ,  inJuridicalId:=0, inSession := '5'::TVarchar) -- where invnumber = 6862
