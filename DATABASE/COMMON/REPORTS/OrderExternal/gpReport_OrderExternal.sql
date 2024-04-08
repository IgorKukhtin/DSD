-- Function: gpReport_OrderExternal()

DROP FUNCTION IF EXISTS gpReport_OrderExternal (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_OrderExternal (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderExternal(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inJuridicalId        Integer   , -- юр.лицо
    IN inRetailId           Integer   , -- торг. сеть
    IN inFromId             Integer   , -- От кого (в документе)
    IN inToId               Integer   , -- Кому (в документе)
    IN inRouteId            Integer   , -- Маршрут
    IN inRouteSortingId     Integer   , -- Сортировки маршрутов
    IN inGoodsGroupId       Integer   ,
    IN inIsByDoc            Boolean   ,
    IN inIsRemains          Boolean   , -- свернуть и показать остатки  
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId             Integer
             , OperDate               TDateTime
             , InvNumber              TVarChar
             , InvNumberPartner       TVarChar
             , InvNumber_Master       TVarChar
             , OperDate_Master        TDateTime
             , OperDatePartner_Master TDateTime
             
             , OperDatePartner_order  TDateTime
             , OperDatePartner_sale   TDateTime
           
             , ContractCode Integer, ContractNumber TVarChar, ContractTagName TVarChar, ContractTagGroupName TVarChar
             , FromCode Integer, FromName TVarChar
             , ToCode Integer, ToName TVarChar
             , RouteGroupName TVarChar, RouteName TVarChar
             , RouteSortingName TVarChar
             , PersonalName TVarChar
             , PaidKindName TVarChar

             , JuridicalName TVarChar
             , RetailName TVarChar  , RetailName_print TVarChar
             , PartnerTagName TVarChar
             , RegionName TVarChar
             , CityKindName TVarChar
             , CityName TVarChar
             , StreetKindName TVarChar
             , StreetName TVarChar

             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName  TVarChar
             , MeasureName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar, TradeMarkName TVarChar

             , WeightTotal TFloat -- Вес в упаковке - GoodsByGoodsKind

             , AmountSumm1 TFloat, AmountSumm2 TFloat
             , AmountSumm_Dozakaz1 TFloat, AmountSumm_Dozakaz2 TFloat
             , AmountSumm TFloat

             , Amount_Weight1 TFloat, Amount_Sh1 TFloat
             , Amount_Weight2 TFloat, Amount_Sh2 TFloat
             , Amount_Weight_Dozakaz1 TFloat, Amount_Sh_Dozakaz1 TFloat
             , Amount_Weight_Dozakaz2 TFloat, Amount_Sh_Dozakaz2 TFloat

             , Amount TFloat, AmountZakaz TFloat, AmountSecond1 TFloat, AmountSecond2 TFloat
             , Amount_Weight TFloat--, TotalAmount_Weight TFloat
             , AmountZakaz_Weight TFloat, Amount_Sh TFloat, AmountZakaz_Sh TFloat

             , Amount_WeightSK TFloat
             
             , AmountWeight_calc   TFloat, AmountWeight_calc1  TFloat, AmountWeight_calc2  TFloat, AmountWeight_calc3  TFloat 
             
             , Amount_Child_one    TFloat       -- с Остатка
             , Amount_Child_sec    TFloat       -- с Прихода
             , Amount_Child        TFloat       -- Итого
             , Amount_diff         TFloat -- разница с итого заявка 
             , AmountWeight_child_one    TFloat -- с Остатка    вес
             , AmountWeight_child_sec    TFloat -- с Прихода    вес
             , AmountWeight_child        TFloat -- Итого        вес
             , AmountWeight_diff         TFloat -- разница резерв с итого заявка    вес

             , AmountSh_child_one    TFloat -- с Остатка    шт
             , AmountSh_child_sec    TFloat -- с Прихода    шт
             , AmountSh_child        TFloat -- Итого        шт
             , AmountSh_diff         TFloat -- разница резерв с итого заявка    шт

             , AmountRemains            TFloat
             , AmountRemains_Sh         TFloat
             , AmountRemains_Weight     TFloat 
             , Remains_Weight_calc     TFloat
             , Remains_Weight_calc1     TFloat
             , Remains_Weight_calc2     TFloat
             , AmountOrder              TFloat
             , AmountOrder_Sh           TFloat
             , AmountOrder_Weight       TFloat 
             , AmountOrder_calc        TFloat
             , AmountOrder_Sh_calc     TFloat
             , AmountOrder_Weight_calc TFloat
             , AmountOrder_calc1        TFloat
             , AmountOrder_Sh_calc1     TFloat
             , AmountOrder_Weight_calc1 TFloat
             , AmountOrder_calc2        TFloat
             , AmountOrder_Sh_calc2     TFloat
             , AmountOrder_Weight_calc2 TFloat

             , AmountRemainsSH_diff     TFloat
             , AmountRemainsWeight_diff TFloat 
             , Remains_Weight_diff      TFloat
             , Remains1_Weight_diff     TFloat
             , Remains2_Weight_diff     TFloat 
             , RemainsAll_Weight_diff   TFloat

             , AmountSend        TFloat
             , AmountSend_Sh     TFloat
             , AmountSend_Weight TFloat

             , DatePrint TDateTime, DatePrint1 TDateTime, DatePrint2 TDateTime

             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , InfoMoneyCode_goods Integer, InfoMoneyName_goods TVarChar, InfoMoneyName_goods_all TVarChar
             , Comment TVarChar
             , CodeSticker TVarChar

             , CarInfoName  TVarChar
             , OperDate_CarInfo TDateTime, OperDate_CarInfo_date TDateTime 

             , DayOfWeekName              TVarChar
             , DayOfWeekName_Partner      TVarChar
             , DayOfWeekName_CarInfo      TVarChar
             , DayOfWeekName_CarInfo_date TVarChar

             , GoodsSubSendId       Integer
             , GoodsSubSendCode     Integer
             , GoodsSubSendName     TVarChar
             , GoodsKindSubSendId   Integer
             , GoodsKindSubSendName TVarChar  
             , GoodsName_SubSend TVarChar    --для печати по остаткам
              )
AS
$BODY$
   DECLARE vbUserId Integer; 
   DECLARE vbStartDate_1 TDateTime;
   DECLARE vbStartDate_2 TDateTime;
   DECLARE vbStartDate_3 TDateTime;
   DECLARE vbDate_CarInfo TDateTime;
   DECLARE vbDate_CarInfo1 TDateTime;
   DECLARE vbDate_CarInfo2 TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- Ограничения по товарам
    /*CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    IF inGoodsGroupId <> 0
    THEN
        INSERT INTO _tmpGoods (GoodsId)
           SELECT lfObject_Goods_byGoodsGroup.GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE
        INSERT INTO _tmpGoods (GoodsId)
           SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();
    END IF;*/

    --
    -- inIsByDoc:= (inStartDate = inEndDate);

    --для разбивки по дням отгрузки
    vbStartDate_1 := inStartDate + INTERVAL '1 DAY';
    vbStartDate_2 := inStartDate + INTERVAL '2 DAY';
    vbStartDate_3 := inStartDate + INTERVAL '3 DAY';

    vbDate_CarInfo  := ( (inStartDate)::Date ||' 08:00')::TDateTime ;
    vbDate_CarInfo1 := vbDate_CarInfo + INTERVAL '1 DAY';
    vbDate_CarInfo2 := vbDate_CarInfo + INTERVAL '2 DAY';

    IF inIsRemains = TRUE
    THEN
        --если выбрано показать остатки данные за 1 день
        inEndDate := inStartDate;
        inIsByDoc := FALSE;
    END IF;

     RETURN QUERY
     WITH 

     _tmpGoods AS --  (GoodsId Integer) ON COMMIT DROP;
                 (SELECT lfSelect.GoodsId
                  FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
                  WHERE inGoodsGroupId <> 0
                 UNION ALL
                  SELECT Object.Id FROM Object
                  WHERE Object.DescId = zc_Object_Goods()
                    AND COALESCE (inGoodsGroupId, 0) = 0
                 )

--остатки   ( расчет остатка на начало по выбранному складу + сколько осталось отгрузить по заявкам(если дата пок = выбр дате, а дата заявки < выбр даты) - когда нет детализации и за один день + показать информативно разницу "сколько не хватает для заявка + дозаказ" - в весе и в шт., разницу показать только когда делаем расч остатка, т.е. если период >1 дня или есть детализация, то и в разнице будет пусто)
     , tmpRemains AS (WITH
                      tmpContainer AS (SELECT Container.Id       AS ContainerId
                                            , CLO_Unit.ObjectId  AS ToId
                                            , Container.ObjectId AS GoodsId
                                            , Container.Amount
                                       FROM Container
                                            INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = Container.ObjectId
                                            LEFT JOIN ContainerLinkObject AS CLO_Unit
                                                                          ON CLO_Unit.ContainerId = Container.Id
                                                                         AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                            LEFT JOIN ContainerLinkObject AS CLO_Account
                                                                          ON CLO_Account.ContainerId = CLO_Unit.ContainerId
                                                                         AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                       WHERE Container.DescId = zc_Container_Count()
                                         AND CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!! 
                                         AND (CLO_Unit.ObjectId = inToId OR inToId = 0)
                                         AND inIsRemains = TRUE
                                       )
                    , tmpCLO_GoodsKind_rem AS (SELECT CLO_GoodsKind.*
                                               FROM ContainerLinkObject AS CLO_GoodsKind
                                               WHERE CLO_GoodsKind.ContainerId IN (SELECT DISTINCT tmpContainer.ContainerId FROM tmpContainer)
                                                 AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                               )
                     SELECT tmpContainer.ToId
                          , tmpContainer.GoodsId
                          , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                          , tmpContainer.Amount - SUM (COALESCE (MIContainer.Amount, 0)) AS Amount --на начало дня
                          , (tmpContainer.Amount - SUM (COALESCE (MIContainer.Amount, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Amount_Weight
                          , (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpContainer.Amount - SUM (COALESCE (MIContainer.Amount, 0)) ELSE 0 END ) AS Amount_Sh
                     FROM tmpContainer
                          LEFT JOIN tmpCLO_GoodsKind_rem AS CLO_GoodsKind
                                                         ON CLO_GoodsKind.ContainerId = tmpContainer.ContainerId
                                                        AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                          LEFT JOIN MovementItemContainer AS MIContainer
                                                          ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                         AND MIContainer.OperDate >= inStartDate
                          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = tmpContainer.GoodsId
                                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                ON ObjectFloat_Weight.ObjectId = tmpContainer.GoodsId
                                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                     WHERE inIsRemains = TRUE   --если за 1 день
                     GROUP BY tmpContainer.GoodsId
                            , COALESCE (CLO_GoodsKind.ObjectId, 0)
                            , tmpContainer.Amount
                            , tmpContainer.ToId
                            , ObjectFloat_Weight.ValueData
                            , ObjectLink_Goods_Measure.ChildObjectId
                     HAVING SUM (COALESCE (tmpContainer.Amount,0)) > 0
                     )
      --Данные по заявкам(если дата пок = выбр дате, а дата заявки < выбр даты)
     , tmpOrder AS (SELECT MovementLinkObject_To.ObjectId                           AS ToId
                         , MovementItem.ObjectId                                    AS GoodsId
                         , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId NOT IN (zc_Enum_InfoMoney_30102(), zc_Enum_InfoMoney_30103()) THEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) END AS GoodsKindId

                         --все
                         , SUM (COALESCE (MovementItem.Amount,0)+ COALESCE (MIFloat_AmountSecond.ValueData, 0)) AS Amount
                         , SUM ((COALESCE (MovementItem.Amount,0)+ COALESCE (MIFloat_AmountSecond.ValueData, 0)) 
                                 * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Amount_Weight
                         , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() 
                                     THEN COALESCE (MovementItem.Amount,0)+ COALESCE (MIFloat_AmountSecond.ValueData, 0) 
                                     ELSE 0 
                                END) AS Amount_Sh  


                         --сегодня
                         , SUM (CASE WHEN MovementDate_CarInfo.ValueData >= vbDate_CarInfo AND MovementDate_CarInfo.ValueData < vbDate_CarInfo1 THEN COALESCE (MovementItem.Amount,0)+ COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS Amount_calc
                         , SUM (CASE WHEN MovementDate_CarInfo.ValueData >= vbDate_CarInfo AND MovementDate_CarInfo.ValueData < vbDate_CarInfo1 THEN (COALESCE (MovementItem.Amount,0)+ COALESCE (MIFloat_AmountSecond.ValueData, 0)) 
                                                                                                     * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                                     ELSE 0
                                END) AS Amount_Weight_calc
                         , SUM (CASE WHEN MovementDate_CarInfo.ValueData >= vbDate_CarInfo AND MovementDate_CarInfo.ValueData < vbDate_CarInfo1 THEN CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() 
                                                                                                         THEN COALESCE (MovementItem.Amount,0)+ COALESCE (MIFloat_AmountSecond.ValueData, 0) 
                                                                                                         ELSE 0 
                                                                                                    END 
                                     ELSE 0 
                                END) AS Amount_Sh_calc  
                         -- Завтра        
                         , SUM (CASE WHEN MovementDate_CarInfo.ValueData >= vbDate_CarInfo1 AND MovementDate_CarInfo.ValueData < vbDate_CarInfo2  THEN COALESCE (MovementItem.Amount,0)+ COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS Amount_calc1
                         , SUM (CASE WHEN MovementDate_CarInfo.ValueData >= vbDate_CarInfo1 AND MovementDate_CarInfo.ValueData < vbDate_CarInfo2 THEN (COALESCE (MovementItem.Amount,0)+ COALESCE (MIFloat_AmountSecond.ValueData, 0)) 
                                                                                                       * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                                     ELSE 0 
                                END) AS Amount_Weight_calc1
                         , SUM (CASE WHEN MovementDate_CarInfo.ValueData >= vbDate_CarInfo1 AND MovementDate_CarInfo.ValueData < vbDate_CarInfo2 THEN CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() 
                                                                                                           THEN COALESCE (MovementItem.Amount,0)+ COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                                                                                           ELSE 0 
                                                                                                      END 
                                     ELSE 0 
                                END) AS Amount_Sh_calc1
                         --далее
                         , SUM (CASE WHEN MovementDate_CarInfo.ValueData >= vbDate_CarInfo2 THEN COALESCE (MovementItem.Amount,0)+ COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS Amount_calc2
                         , SUM (CASE WHEN MovementDate_CarInfo.ValueData >= vbDate_CarInfo2 THEN (COALESCE (MovementItem.Amount,0)+ COALESCE (MIFloat_AmountSecond.ValueData, 0)) 
                                                                                                       * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                                     ELSE 0 
                                END) AS Amount_Weight_calc2
                         , SUM (CASE WHEN MovementDate_CarInfo.ValueData >= vbDate_CarInfo2 THEN CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() 
                                                                                                            THEN COALESCE (MovementItem.Amount,0)+ COALESCE (MIFloat_AmountSecond.ValueData, 0)  
                                                                                                            ELSE 0 
                                                                                                       END
                                     ELSE 0 
                                END) AS Amount_Sh_calc2 

                    FROM MovementDate AS MovementDate_CarInfo 
                        INNER JOIN Movement ON Movement.Id = MovementDate_CarInfo.MovementId
                                           AND Movement.OperDate < inStartDate
                                           AND Movement.StatusId = zc_Enum_Status_Complete()
                                           AND Movement.DescId = zc_Movement_OrderExternal()

                        LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                     ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                    AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
             
                        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                     ON MovementLinkObject_From.MovementId = Movement.Id
                                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                        LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                     ON MovementLinkObject_To.MovementId = Movement.Id
                                                    AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                        LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                     ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                    AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                        LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                                     ON MovementLinkObject_Route.MovementId = Movement.Id
                                                    AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()

                        LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                             ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                            AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                        LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

                        INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                               AND MovementItem.DescId     = zc_MI_Master()
                                               AND MovementItem.isErased   = FALSE
                        INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
             
                        LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                             ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                            AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                            AND MovementItem.DescId     = zc_MI_Master()
             
                        LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                    ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                   AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                        LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                         ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                             ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                              ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                             AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
    
                    WHERE inIsRemains = TRUE
                      AND MovementDate_CarInfo.DescId = zc_MovementDate_CarInfo() --zc_MovementDate_OperDatePartner()
                      AND MovementDate_CarInfo.ValueData >= vbDate_CarInfo
                      AND (COALESCE (MovementLinkObject_To.ObjectId,0) = CASE WHEN inToId <> 0 THEN inToId ELSE COALESCE (MovementLinkObject_To.ObjectId,0) END)
                      AND (COALESCE (MovementLinkObject_From.ObjectId,0) = CASE WHEN inFromId <> 0 THEN inFromId ELSE COALESCE (MovementLinkObject_From.ObjectId,0) END)
                      AND (COALESCE (MovementLinkObject_Route.ObjectId,0) = CASE WHEN inRouteId <> 0 THEN inRouteId ELSE COALESCE (MovementLinkObject_Route.ObjectId,0) END)
                      AND (COALESCE (ObjectLink_Partner_Juridical.ChildObjectId,0) = CASE WHEN inJuridicalId <> 0 THEN inJuridicalId ELSE COALESCE (ObjectLink_Partner_Juridical.ChildObjectId,0) END)
                      AND (COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) = CASE WHEN inRetailId <> 0 THEN inRetailId ELSE COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) END)
                    GROUP BY
                          MovementLinkObject_To.ObjectId
                        , MovementItem.ObjectId
                        , MILinkObject_GoodsKind.ObjectId
                        , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId NOT IN (zc_Enum_InfoMoney_30102(), zc_Enum_InfoMoney_30103()) THEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) END
                      )

        --  приход перемещение на склад   показывае вместе с остатками
      , tmpSendIn AS (SELECT MLO_To.ObjectId                               AS ToId
                           , MovementItem.ObjectId                         AS GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                           , SUM (MovementItem.Amount) AS Amount
                           , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN MovementItem.Amount ELSE 0 END) AS Amount_Sh
                           , SUM (MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Amount_Weight
                      FROM Movement 
                           INNER JOIN MovementLinkObject AS MLO_To
                                                         ON MLO_To.MovementId = Movement.Id
                                                        AND MLO_To.DescId = zc_MovementLinkObject_To()
                                                        AND MLO_To.ObjectId = inToId   
                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId = zc_MI_Master()
                                                  AND MovementItem.isErased = FALSE
                           INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                               AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                           LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                 ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                                AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

                      WHERE Movement.OperDate = inStartDate
                        AND Movement.DescId = zc_Movement_Send()
                        AND Movement.StatusId = zc_Enum_Status_Complete()
                        AND inIsRemains = TRUE
                      GROUP BY MLO_To.ObjectId
                             , MovementItem.ObjectId
                             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                      )

     , tmpPartnerAddress AS (SELECT * FROM Object_Partner_Address_View)

     , tmpMov AS (SELECT Movement.Id, Movement.OperDate
                       , ObjectLink_Partner_Juridical.ChildObjectId               AS JuridicalId
                       , ObjectLink_Juridical_Retail.ChildObjectId                AS RetailId
                       , MovementLinkObject_From.ObjectId                         AS FromId
                       , MovementLinkObject_To.ObjectId                           AS ToId
                       , MovementLinkObject_Route.ObjectId                        AS RouteId
                  FROM Movement
                      LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                      LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                      LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                                   ON MovementLinkObject_Route.MovementId = Movement.Id
                                                  AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()

                      LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                           ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

                      LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                           ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                     
                  WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                    AND Movement.StatusId = zc_Enum_Status_Complete()
                    AND Movement.DescId = zc_Movement_OrderExternal()
                    AND (COALESCE (MovementLinkObject_To.ObjectId,0) = CASE WHEN inToId <> 0 THEN inToId ELSE COALESCE (MovementLinkObject_To.ObjectId,0) END)
                    AND (COALESCE (MovementLinkObject_From.ObjectId,0) = CASE WHEN inFromId <> 0 THEN inFromId ELSE COALESCE (MovementLinkObject_From.ObjectId,0) END)
                    AND (COALESCE (MovementLinkObject_Route.ObjectId,0) = CASE WHEN inRouteId <> 0 THEN inRouteId ELSE COALESCE (MovementLinkObject_Route.ObjectId,0) END)
                    AND (COALESCE (ObjectLink_Partner_Juridical.ChildObjectId,0) = CASE WHEN inJuridicalId <> 0 THEN inJuridicalId ELSE COALESCE (ObjectLink_Partner_Juridical.ChildObjectId,0) END)
                    AND (COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) = CASE WHEN inRetailId <> 0 THEN inRetailId ELSE COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) END)
                 )

     , tmpMI_Master AS (SELECT MovementItem.*
                        FROM MovementItem
                        WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMov.Id FROM tmpMov)
                          AND MovementItem.DescId = zc_MI_Master()
                          AND MovementItem.isErased = FALSE
                        )

  -- Резервы
     , tmpMIChild AS (SELECT MovementItem.*
                      FROM MovementItem
                      WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMov.Id FROM tmpMov)
                        AND MovementItem.DescId     = zc_MI_Child()
                        AND MovementItem.isErased   = FALSE
                     )
     , tmpMIFloat_Child AS (SELECT MovementItemFloat.*
                            FROM MovementItemFloat
                            WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMIChild.Id FROM tmpMIChild)
                              AND MovementItemFloat.DescId = zc_MIFloat_MovementId()
                           )

     , tmpChild AS (SELECT MovementItem.ParentId

                         , SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) = 0 THEN MovementItem.Amount ELSE 0 END) AS Amount
                         , SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) > 0 THEN MovementItem.Amount ELSE 0 END) AS AmountSecond
                         , SUM (MovementItem.Amount) AS Amount_all
                         
                         , SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) = 0 THEN MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END ELSE 0 END) AS Amount_Weight
                         , SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) > 0 THEN MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END ELSE 0 END) AS AmountSecond_Weight
                         , SUM (MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Amount_all_Weight

                         , SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) = 0 THEN MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN 1 ELSE 0 END ELSE 0 END) AS Amount_sh
                         , SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) > 0 THEN MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN 1 ELSE 0 END ELSE 0 END) AS AmountSecond_sh
                         , SUM (COALESCE (MovementItem.Amount,0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN 1 ELSE 0 END) AS Amount_all_sh

                    FROM tmpMIChild AS MovementItem
                         LEFT JOIN tmpMIFloat_Child AS MIFloat_MovementId
                                                    ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                   AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                         LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                              ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                             AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                         LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                               ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                              AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                    GROUP BY MovementItem.ParentId
                   )

    , tmpMovementLinkObject AS (SELECT MovementLinkObject.*
                                FROM MovementLinkObject
                                WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMov.Id FROM tmpMov)
                                  AND MovementLinkObject.DescId IN (zc_MovementLinkObject_Contract()
                                                                  , zc_MovementLinkObject_PaidKind()
                                                                  , zc_MovementLinkObject_Personal()
                                                                  , zc_MovementLinkObject_CarInfo()
                                                                  , zc_MovementLinkObject_Partner())
                               )

    , tmpMovementDate AS (SELECT MovementDate.*
                          FROM MovementDate
                          WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMov.Id FROM tmpMov)
                            AND MovementDate.DescId IN (zc_MovementDate_OperDatePartner()
                                                      , zc_MovementDate_CarInfo()
                                                      )
                         )

    , tmpMovementFloat AS (SELECT MovementFloat.*
                           FROM MovementFloat
                           WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMov.Id FROM tmpMov)
                             AND MovementFloat.DescId IN (zc_MovementFloat_VATPercent()
                                                        , zc_MovementFloat_ChangePercent()
                                                        )
                          )

    , tmpMovementString AS (SELECT MovementString.*
                            FROM MovementString
                            WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMov.Id FROM tmpMov)
                              AND MovementString.DescId IN (zc_MovementString_Comment()
                                                         )
                           )

    , tmpMovementItemLinkObject AS (SELECT MovementItemLinkObject.*
                                    FROM MovementItemLinkObject
                                    WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                                      AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKind()
                                                                 )
                                   )

    , tmpMovementItemFloat AS (SELECT MovementItemFloat.*
                               FROM MovementItemFloat
                               WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                                 AND MovementItemFloat.DescId IN (zc_MIFloat_AmountSecond()
                                                                , zc_MIFloat_Price()
                                                                , zc_MIFloat_CountForPrice()
                                                                )
                              )
                   
     , tmpMovement2 AS (SELECT CASE WHEN inIsByDoc = TRUE THEN Movement.Id ELSE 0 END   AS MovementId
                             , CASE WHEN inIsRemains = FALSE THEN MovementLinkObject_Contract.ObjectId ELSE 0 END AS ContractId
                             , CASE WHEN inIsRemains = FALSE THEN Movement.JuridicalId ELSE 0 END                 AS JuridicalId
                             , CASE WHEN inIsRemains = FALSE THEN Movement.RetailId ELSE 0 END                    AS RetailId
                             , CASE WHEN inIsRemains = FALSE THEN Movement.FromId ELSE 0 END                      AS FromId
                             , Movement.ToId                                                                      AS ToId
                             , CASE WHEN inIsRemains = FALSE THEN Movement.RouteId ELSE 0 END                     AS RouteId
                             , 0                                                        AS RouteSortingId
                             , CASE WHEN inIsRemains = FALSE THEN MovementLinkObject_Personal.ObjectId ELSE 0 END                     AS PersonalId
                             , CASE WHEN inIsRemains = FALSE THEN MovementLinkObject_PaidKind.ObjectId ELSE 0 END                     AS PaidKindId
                             , CASE WHEN inIsRemains = FALSE THEN COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE) ELSE FALSE END AS isPriceWithVAT
                             , CASE WHEN inIsRemains = FALSE THEN COALESCE (MovementFloat_VATPercent.ValueData, 0)  ELSE 0 END        AS VATPercent
                             , CASE WHEN inIsRemains = FALSE THEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) ELSE 0 END      AS ChangePercent
                             , MovementItem.ObjectId                                    AS GoodsId
                             , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId NOT IN (zc_Enum_InfoMoney_30102(), zc_Enum_InfoMoney_30103()) THEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) END AS GoodsKindId
                             , CASE WHEN inIsRemains = FALSE THEN ObjectLink_Goods_InfoMoney.ChildObjectId ELSE 0 END                 AS InfoMoneyId
                  
                             , SUM (CASE WHEN Movement.OperDate =  COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) THEN MovementItem.Amount ELSE 0 END) AS Amount1
                             , SUM (CASE WHEN Movement.OperDate <> COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) THEN MovementItem.Amount ELSE 0 END) AS Amount2
                             , SUM (CASE WHEN Movement.OperDate =  COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) THEN COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountSecond1
                             , SUM (CASE WHEN Movement.OperDate <> COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) THEN COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountSecond2
                             
                             --
                             , SUM (CASE WHEN COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) = inStartDate    THEN COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS Amount_calc
                             , SUM (CASE WHEN COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) = vbStartDate_1  THEN COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS Amount_calc1
                             , SUM (CASE WHEN COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) = vbStartDate_2  THEN COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS Amount_calc2
                             , SUM (CASE WHEN COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= vbStartDate_3 THEN COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS Amount_calc3 
                             --сhild
                             , SUM (tmpMI_Child.Amount)       AS Amount_child_one -- с Остатка
                             , SUM (tmpMI_Child.AmountSecond) AS Amount_child_sec -- с Прихода
                             , SUM (tmpMI_Child.Amount_all)   AS Amount_child     -- Итого
 
                             , SUM (tmpMI_Child.Amount_Weight)       AS AmountWeight_child_one -- с Остатка
                             , SUM (tmpMI_Child.AmountSecond_Weight) AS AmountWeight_child_sec -- с Прихода
                             , SUM (tmpMI_Child.Amount_all_Weight)   AS AmountWeight_child     -- Итого

                             , SUM (COALESCE (tmpMI_Child.Amount_sh,0))       AS AmountSh_child_one -- с Остатка
                             , SUM (COALESCE (tmpMI_Child.AmountSecond_sh,0)) AS AmountSh_child_sec -- с Прихода
                             , SUM (COALESCE (tmpMI_Child.Amount_all_sh,0))   AS AmountSh_child     -- Итого
    
                             --
                             , CASE WHEN inIsRemains = FALSE 
                                    THEN CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                                   THEN COALESCE (MIFloat_Price.ValueData, 0) / MIFloat_CountForPrice.ValueData
                                              ELSE COALESCE (MIFloat_Price.ValueData, 0)
                                         END
                                       * CASE WHEN MovementFloat_ChangePercent.ValueData <> 0
                                                   THEN (1 + MovementFloat_ChangePercent.ValueData / 100)
                                              ELSE 1
                                         END
                                       * CASE WHEN COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE) = TRUE OR COALESCE (MovementFloat_VATPercent.ValueData, 0) = 0
                                                     -- если цены с НДС или %НДС=0
                                                     THEN 1
                                                ELSE -- если цены без НДС
                                                     1 + MovementFloat_VATPercent.ValueData / 100
                                         END
                                    ELSE 0
                               END AS Price

                             , CASE WHEN inIsByDoc = TRUE THEN MovementDate_OperDatePartner.ValueData ELSE Null END  :: TDateTime  AS OperDatePartner_order
                             , CASE WHEN inIsByDoc = TRUE THEN (MovementDate_OperDatePartner.ValueData + (COALESCE (ObjectFloat_DocumentDayCount.ValueData, 0) :: TVarChar || ' DAY') :: INTERVAL) ELSE Null END :: TDateTime AS OperDatePartner_sale
                             
                             , CASE WHEN inIsByDoc = TRUE THEN COALESCE (MovementString_Comment.ValueData,'') ELSE '' END ::TVarChar AS Comment
                             
                             , CASE WHEN inIsRemains = FALSE THEN zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, COALESCE (Movement.JuridicalId, Movement.FromId), COALESCE (MovementLinkObject_Partner.ObjectId, Movement.FromId))  ELSE 0 END AS GoodsPropertyId
                             , CASE WHEN inIsRemains = FALSE THEN zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0)  ELSE 0 END     AS GoodsPropertyId_basis 

                             , CASE WHEN inIsRemains = FALSE THEN MovementLinkObject_CarInfo.ObjectId  ELSE 0 END           AS CarInfoId
                             , CASE WHEN inIsRemains = FALSE THEN MovementDate_CarInfo.ValueData  ELSE NULL END    ::TDateTime AS OperDate_CarInfo
                             -- Дата смены
                             , CASE WHEN inIsRemains = FALSE THEN CASE WHEN EXTRACT (HOUR FROM MovementDate_CarInfo.ValueData) < 8 THEN DATE_TRUNC ('DAY', MovementDate_CarInfo.ValueData) - INTERVAL '1 DAY'
                                                                       ELSE DATE_TRUNC ('DAY', MovementDate_CarInfo.ValueData)
                                                                  END
                                    ELSE NULL
                               END    ::TDateTime  AS OperDate_CarInfo_date 
                             
                        FROM tmpMov AS Movement
                            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_Contract
                                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                 
                            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_PaidKind
                                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_Personal
                                                         ON MovementLinkObject_Personal.MovementId = Movement.Id
                                                        AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()

                            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_CarInfo
                                                         ON MovementLinkObject_CarInfo.MovementId = Movement.Id
                                                        AND MovementLinkObject_CarInfo.DescId = zc_MovementLinkObject_CarInfo()

                            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_Partner
                                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                                                        --AND Object_From.DescId = zc_Object_Unit()

                            LEFT JOIN tmpMovementDate AS MovementDate_OperDatePartner
                                                   ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

                            LEFT JOIN tmpMovementDate AS MovementDate_CarInfo
                                                   ON MovementDate_CarInfo.MovementId = Movement.Id
                                                  AND MovementDate_CarInfo.DescId = zc_MovementDate_CarInfo()

                            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                            LEFT JOIN tmpMovementFloat AS MovementFloat_VATPercent
                                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
                            LEFT JOIN tmpMovementFloat AS MovementFloat_ChangePercent
                                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

                            LEFT JOIN tmpMovementString AS MovementString_Comment
                                                     ON MovementString_Comment.MovementId = Movement.Id
                                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

                            INNER JOIN tmpMI_Master AS MovementItem ON MovementItem.MovementId = Movement.Id

                            INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
                 
                            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                 ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                 
                            LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountSecond
                                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                            LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                            -- AND ObjectLink_Goods_InfoMoney.ChildObjectId NOT IN (zc_Enum_InfoMoney_30102(), zc_Enum_InfoMoney_30103()) -- Тушенка + Хлеб
                                                            -- AND ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- Ирна + Готовая продукция + Доходы Мясное сырье
                            LEFT JOIN tmpMovementItemFloat AS MIFloat_Price
                                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()

                            LEFT JOIN tmpMovementItemFloat AS MIFloat_CountForPrice
                                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                            LEFT JOIN ObjectFloat AS ObjectFloat_DocumentDayCount 
                                                  ON ObjectFloat_DocumentDayCount.ObjectId = Movement.FromId 
                                                 AND ObjectFloat_DocumentDayCount.DescId = zc_ObjectFloat_Partner_DocumentDayCount()
 
                            -- Резервы
                            LEFT JOIN tmpChild AS tmpMI_Child ON tmpMI_Child.ParentId = MovementItem.Id
                        GROUP BY
                              CASE WHEN inIsByDoc = TRUE THEN Movement.Id ELSE 0 END
                            , CASE WHEN inIsRemains = FALSE THEN MovementLinkObject_Contract.ObjectId ELSE 0 END
                            , CASE WHEN inIsRemains = FALSE THEN Movement.JuridicalId ELSE 0 END
                            , CASE WHEN inIsRemains = FALSE THEN Movement.RetailId ELSE 0 END 
                            , CASE WHEN inIsRemains = FALSE THEN Movement.FromId ELSE 0 END
                            , Movement.ToId
                            , CASE WHEN inIsRemains = FALSE THEN Movement.RouteId ELSE 0 END
                            , CASE WHEN inIsRemains = FALSE THEN MovementLinkObject_Personal.ObjectId ELSE 0 END
                            , CASE WHEN inIsRemains = FALSE THEN MovementLinkObject_PaidKind.ObjectId ELSE 0 END
                            , CASE WHEN inIsRemains = FALSE THEN MovementFloat_VATPercent.ValueData ELSE 0 END
                            , CASE WHEN inIsRemains = FALSE THEN MovementFloat_ChangePercent.ValueData ELSE 0 END
                            , MovementItem.ObjectId
                            , MILinkObject_GoodsKind.ObjectId
                            , CASE WHEN inIsRemains = FALSE THEN  ObjectLink_Goods_InfoMoney.ChildObjectId ELSE 0 END
                            , CASE WHEN inIsRemains = FALSE THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                            , CASE WHEN inIsRemains = FALSE THEN MIFloat_Price.ValueData ELSE 0 END
                            , CASE WHEN inIsRemains = FALSE THEN MovementLinkObject_Partner.ObjectId ELSE 0 END
                            , CASE WHEN inIsByDoc = TRUE THEN MovementDate_OperDatePartner.ValueData ELSE Null END
                            , CASE WHEN inIsByDoc = TRUE THEN (MovementDate_OperDatePartner.ValueData + (COALESCE (ObjectFloat_DocumentDayCount.ValueData, 0) :: TVarChar || ' DAY') :: INTERVAL) ELSE Null END
                            , CASE WHEN inIsByDoc = TRUE THEN COALESCE (MovementString_Comment.ValueData,'') ELSE '' END 
                            , CASE WHEN inIsRemains = FALSE THEN MovementLinkObject_CarInfo.ObjectId ELSE 0 END
                            , CASE WHEN inIsRemains = FALSE THEN MovementDate_CarInfo.ValueData ELSE NULL END
                            , CASE WHEN inIsRemains = FALSE THEN COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE) ELSE FALSE END 
                            , CASE WHEN inIsRemains = FALSE THEN COALESCE (MovementFloat_VATPercent.ValueData, 0)  ELSE 0 END
                            , CASE WHEN inIsRemains = FALSE THEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) ELSE 0 END
                            , CASE WHEN inIsRemains = FALSE 
                                   THEN CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                                  THEN COALESCE (MIFloat_Price.ValueData, 0) / MIFloat_CountForPrice.ValueData
                                             ELSE COALESCE (MIFloat_Price.ValueData, 0)
                                        END
                                      * CASE WHEN MovementFloat_ChangePercent.ValueData <> 0
                                                  THEN (1 + MovementFloat_ChangePercent.ValueData / 100)
                                             ELSE 1
                                        END
                                      * CASE WHEN COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE) = TRUE OR COALESCE (MovementFloat_VATPercent.ValueData, 0) = 0
                                                    -- если цены с НДС или %НДС=0
                                                    THEN 1
                                               ELSE -- если цены без НДС
                                                    1 + MovementFloat_VATPercent.ValueData / 100
                                        END
                                   ELSE 0
                              END
                            , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId NOT IN (zc_Enum_InfoMoney_30102(), zc_Enum_InfoMoney_30103()) THEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) END
                            , CASE WHEN inIsRemains = FALSE THEN zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, COALESCE (Movement.JuridicalId, Movement.FromId), COALESCE (MovementLinkObject_Partner.ObjectId, Movement.FromId))  ELSE 0 END
                            , CASE WHEN inIsRemains = FALSE THEN zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0)  ELSE 0 END 

                            , CASE WHEN inIsRemains = FALSE THEN MovementLinkObject_CarInfo.ObjectId  ELSE 0 END
                            , CASE WHEN inIsRemains = FALSE THEN MovementDate_CarInfo.ValueData  ELSE NULL END
                            , CASE WHEN inIsRemains = FALSE THEN CASE WHEN EXTRACT (HOUR FROM MovementDate_CarInfo.ValueData) < 8 THEN DATE_TRUNC ('DAY', MovementDate_CarInfo.ValueData) - INTERVAL '1 DAY'
                                                                      ELSE DATE_TRUNC ('DAY', MovementDate_CarInfo.ValueData)
                                                                 END
                                   ELSE NULL
                              END
                          )

     , tmpMovement AS (SELECT tmpMovement2.MovementId
                            , tmpMovement2.JuridicalId
                            , tmpMovement2.RetailId
                            , tmpMovement2.FromId
                            , tmpMovement2.ToId
                            , tmpMovement2.ContractId
                            , tmpMovement2.RouteId
                            , tmpMovement2.RouteSortingId
                            , tmpMovement2.PersonalId
                            , tmpMovement2.PaidKindId
                            , tmpMovement2.GoodsKindId
                            , tmpMovement2.GoodsId
                            , tmpMovement2.InfoMoneyId
                            , tmpMovement2.OperDatePartner_order
                            , tmpMovement2.OperDatePartner_sale
                            , tmpMovement2.Comment
                            , tmpMovement2.GoodsPropertyId
                            , tmpMovement2.GoodsPropertyId_basis
                            , tmpMovement2.CarInfoId
                            , tmpMovement2.OperDate_CarInfo
                            , tmpMovement2.OperDate_CarInfo_date
                
                            , SUM (Amount1 + Amount2 + tmpMovement2.AmountSecond1 + tmpMovement2.AmountSecond2) AS Amount
                            , SUM (Amount1 + Amount2 )                                AS AmountZakaz
                            , SUM (tmpMovement2.AmountSecond1)                        AS AmountSecond1
                            , SUM (tmpMovement2.AmountSecond2)                        AS AmountSecond2
                            , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN Amount1 ELSE 0 END)                                 AS Amount_Sh1
                            , SUM (Amount1 * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)  AS Amount_Weight1
                            , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN Amount2 ELSE 0 END)                                 AS Amount_Sh2
                            , SUM (Amount2 * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)  AS Amount_Weight2
                 
                            , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpMovement2.AmountSecond1 ELSE 0 END)                    AS AmountSecond_Sh1
                            , SUM (tmpMovement2.AmountSecond1 * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)  AS AmountSecond_Weight1
                            , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpMovement2.AmountSecond2 ELSE 0 END)                    AS AmountSecond_Sh2
                            , SUM (tmpMovement2.AmountSecond2 * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)  AS AmountSecond_Weight2        
                            -- child
                            , SUM (tmpMovement2.Amount_child_one) AS Amount_child_one
                            , SUM (tmpMovement2.Amount_child_sec) AS Amount_child_sec
                            , SUM (tmpMovement2.Amount_child)     AS Amount_child

                            , SUM (tmpMovement2.AmountWeight_child_one) AS AmountWeight_child_one
                            , SUM (tmpMovement2.AmountWeight_child_sec) AS AmountWeight_child_sec
                            , SUM (tmpMovement2.AmountWeight_child)     AS AmountWeight_child

                            , SUM (CASE WHEN COALESCE (tmpMovement2.AmountSh_child_one,0) <> 0 THEN tmpMovement2.Amount_child_one 
                                         ELSE CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND COALESCE (ObjectFloat_Weight.ValueData,0) <> 0 
                                                   THEN tmpMovement2.AmountWeight_child_one / ObjectFloat_Weight.ValueData 
                                                   ELSE 0 
                                              END 
                                         END  ) AS AmountSh_child_one
                            , SUM (CASE WHEN COALESCE (tmpMovement2.AmountSh_child_sec,0) <> 0 THEN tmpMovement2.Amount_child_sec 
                                        ELSE CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND COALESCE (ObjectFloat_Weight.ValueData,0) <> 0 
                                                   THEN tmpMovement2.AmountWeight_child_sec / ObjectFloat_Weight.ValueData 
                                                   ELSE 0 
                                              END 
                                         END ) AS AmountSh_child_sec
                            , SUM (CASE WHEN COALESCE(tmpMovement2.AmountSh_child,0) <> 0 THEN tmpMovement2.AmountSh_child 
                                        ELSE CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND COALESCE (ObjectFloat_Weight.ValueData,0) <> 0 
                                                   THEN tmpMovement2.AmountWeight_child / ObjectFloat_Weight.ValueData 
                                                   ELSE 0 
                                              END 
                                         END )         AS AmountSh_child 
                            --

                            , SUM (Amount1 * Price) AS Summ1
                            , SUM (Amount2 * Price) AS Summ2
                            , SUM (tmpMovement2.AmountSecond1 * Price) AS SummSecond1
                            , SUM (tmpMovement2.AmountSecond2 * Price) AS SummSecond2  
                            
                            --
                            , SUM (tmpMovement2.Amount_calc  * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS AmountWeight_calc
                            , SUM (tmpMovement2.Amount_calc1 * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS AmountWeight_calc1
                            , SUM (tmpMovement2.Amount_calc2 * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS AmountWeight_calc2
                            , SUM (tmpMovement2.Amount_calc3 * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS AmountWeight_calc3 

                            , SUM ( (tmpMovement2.Amount1 + tmpMovement2.Amount2 + tmpMovement2.AmountSecond1 + tmpMovement2.AmountSecond2)
                                    * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)  AS Amount_Weight
                            , SUM ( CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN (tmpMovement2.Amount1 + tmpMovement2.Amount2 + tmpMovement2.AmountSecond1 + tmpMovement2.AmountSecond2) ELSE 0 END) AS Amount_Sh    
                           
                       FROM tmpMovement2
                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = tmpMovement2.GoodsId
                                                                           AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                           LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                 ON ObjectFloat_Weight.ObjectId = tmpMovement2.GoodsId
                                                AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                       GROUP BY tmpMovement2.MovementId
                              , tmpMovement2.FromId
                              , tmpMovement2.ToId
                              , tmpMovement2.ContractId
                              , tmpMovement2.RouteId
                              , tmpMovement2.RouteSortingId
                              , tmpMovement2.PersonalId
                              , tmpMovement2.PaidKindId
                              , tmpMovement2.GoodsKindId
                              , tmpMovement2.GoodsId
                              , tmpMovement2.InfoMoneyId
                              , tmpMovement2.JuridicalId
                              , tmpMovement2.RetailId
                              , tmpMovement2.OperDatePartner_order
                              , tmpMovement2.OperDatePartner_sale
                              , tmpMovement2.Comment
                              , tmpMovement2.GoodsPropertyId
                              , tmpMovement2.GoodsPropertyId_basis
                              , tmpMovement2.CarInfoId
                              , tmpMovement2.OperDate_CarInfo
                              , tmpMovement2.OperDate_CarInfo_date
                      )

     -- выбираем для заказов документы продажи и перемещения по цене 
     , tmpMLM AS (SELECT MovementLinkMovement.*
                  FROM MovementLinkMovement
                  WHERE MovementLinkMovement.MovementChildId IN (SELECT DISTINCT tmpMovement.MovementId FROM tmpMovement)
                    AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Order()
                 )
     -- Для документы продажи и перемещения по цене получаем дату, номер, дату у покупателя 
     , tmpMLM_All AS (SELECT   tmpMLM.MovementChildId                  AS MovementId_Order
                             , tmpMLM.MovementId                       AS MovementId
                             , Movement.InvNumber                      AS InvNumber
                             , Movement.OperDate                       AS OperDate
                             , MovementDate_OperDatePartner.ValueData  AS OperDatePartner
                             , ROW_NUMBER() OVER (PARTITION BY tmpMLM.MovementChildId ORDER BY tmpMLM.MovementId) AS Ord
                      FROM tmpMLM
                           INNER JOIN Movement ON Movement.Id = tmpMLM.MovementId
                                              AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_SendOnPrice())
                                              AND Movement.StatusId = zc_Enum_Status_Complete()
                           LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                  ON MovementDate_OperDatePartner.MovementId = tmpMLM.MovementId
                                                 AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                     )

     , tmpObject_GoodsPropertyValue AS (SELECT tmpGoodsProperty.GoodsPropertyId
                                             , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                    AS GoodsId
                                             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0)  AS GoodsKindId
                                             , ObjectString_CodeSticker.ValueData                                   AS CodeSticker
                                        FROM (SELECT DISTINCT tmpMovement.GoodsPropertyId
                                              FROM tmpMovement
                                              WHERE tmpMovement.GoodsPropertyId <> 0
                                             ) AS tmpGoodsProperty
                                             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                             INNER JOIN ObjectString AS ObjectString_CodeSticker
                                                                     ON ObjectString_CodeSticker.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                    AND ObjectString_CodeSticker.DescId = zc_ObjectString_GoodsPropertyValue_CodeSticker()
                                                                    AND COALESCE (ObjectString_CodeSticker.ValueData,'') <> ''
                                             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                       )
     , tmpObject_GoodsPropertyValue_basis AS (SELECT tmpGoodsProperty.GoodsPropertyId
                                                   , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                    AS GoodsId
                                                   , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0)  AS GoodsKindId
                                                   , ObjectString_CodeSticker.ValueData                                   AS CodeSticker
                                              FROM (SELECT DISTINCT tmpMovement.GoodsPropertyId_basis AS GoodsPropertyId
                                                    FROM tmpMovement
                                                    WHERE tmpMovement.GoodsPropertyId_basis <> 0
                                                   ) AS tmpGoodsProperty
                                                   INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                                         ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                                        AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                                   INNER JOIN ObjectString AS ObjectString_CodeSticker
                                                                           ON ObjectString_CodeSticker.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                          AND ObjectString_CodeSticker.DescId = zc_ObjectString_GoodsPropertyValue_CodeSticker()
                                                                          AND COALESCE (ObjectString_CodeSticker.ValueData,'') <> ''
                                                   LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                                        ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                       AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                                   LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                                        ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                       AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                             ) 

    , tmpData AS (SELECT tmpMovement.*
                         --остатки
                       , tmpRemains.Amount          ::TFloat  AS AmountRemains
                       , tmpRemains.Amount_Sh       ::TFloat  AS AmountRemains_Sh
                       , tmpRemains.Amount_Weight   ::TFloat  AS AmountRemains_Weight 
                        -- (заказ вчера)
                       ,  tmpOrder.Amount          ::TFloat  AS AmountOrder
                       ,  tmpOrder.Amount_Sh       ::TFloat  AS AmountOrder_Sh
                       ,  tmpOrder.Amount_Weight   ::TFloat  AS AmountOrder_Weight 
                        --отгрузка сегодня  (заказ вчера)
                       ,  tmpOrder.Amount_calc          ::TFloat  AS AmountOrder_calc
                       ,  tmpOrder.Amount_Sh_calc       ::TFloat  AS AmountOrder_Sh_calc
                       ,  tmpOrder.Amount_Weight_calc   ::TFloat  AS AmountOrder_Weight_calc
                       --отгрузка завтра     (заказ вчера)
                       ,  tmpOrder.Amount_calc1          ::TFloat  AS AmountOrder_calc1
                       ,  tmpOrder.Amount_Sh_calc1       ::TFloat  AS AmountOrder_Sh_calc1          
                       ,  tmpOrder.Amount_Weight_calc1   ::TFloat  AS AmountOrder_Weight_calc1
                       --отгрузка далее      (заказ вчера)
                       ,  tmpOrder.Amount_calc2          ::TFloat  AS AmountOrder_calc2
                       ,  tmpOrder.Amount_Sh_calc2       ::TFloat  AS AmountOrder_Sh_calc2
                       ,  tmpOrder.Amount_Weight_calc2   ::TFloat  AS AmountOrder_Weight_calc2
            
                        --заказ дата пок = выбр дате, а дата заявки < выбр даты   , те. заказы прошлого дня 
                       --разница остаток и заказ     (к отгрузке)
                       ,  CASE WHEN COALESCE (tmpMovement.Amount_Sh,0) + COALESCE (tmpOrder.Amount_Sh,0) > COALESCE (tmpRemains.Amount_Sh,0)
                               THEN COALESCE (tmpMovement.Amount_Sh,0) + COALESCE (tmpOrder.Amount_Sh,0) - COALESCE (tmpRemains.Amount_Sh,0)
                               ELSE 0
                          END  ::TFloat  AS AmountRemainsSH_diff
                       ,  CASE WHEN COALESCE (tmpMovement.Amount_Weight,0) + COALESCE (tmpOrder.Amount_Weight,0) > COALESCE (tmpRemains.Amount_Weight,0) 
                               THEN COALESCE (tmpMovement.Amount_Weight,0) + COALESCE (tmpOrder.Amount_Weight,0) - COALESCE (tmpRemains.Amount_Weight,0)
                               ELSE 0
                          END  ::TFloat  AS AmountRemainsWeight_diff 
                       
              
                       -- расчет остаток - отгрузка сегодня  (заказ вчера)
                       , (COALESCE (tmpRemains.Amount_Weight,0) - COALESCE (tmpOrder.Amount_Weight_calc,0))   ::TFloat AS Remains_Weight_calc   
                       -- расчет остаток - отгрузка завтра   (заказ вчера)
                       ,  (COALESCE (tmpRemains.Amount_Weight,0)       --остаток
                           - COALESCE (tmpOrder.Amount_Weight_calc,0)  -- 0тгр.сегодня  (заказы вчера )
                           - COALESCE (tmpOrder.Amount_Weight_calc1,0) -- 0тгр.завтра   (заказы вчера )
                           ) ::TFloat AS Remains_Weight_calc1
                       -- расчет остаток - отгрузка далее   (заказ вчера)
                       ,  (COALESCE (tmpRemains.Amount_Weight,0)       --остаток
                           - COALESCE (tmpOrder.Amount_Weight_calc,0)  -- 0тгр.сегодня  (заказы вчера )
                           - COALESCE (tmpOrder.Amount_Weight_calc1,0) -- 0тгр.завтра   (заказы вчера ) 
                           - COALESCE (tmpOrder.Amount_Weight_calc2,0) -- 0тгр.далее    (заказы вчера ) 
                           ) ::TFloat AS Remains_Weight_calc2                 
                          
                       --не хватает сегодня
                       , CASE WHEN COALESCE (tmpRemains.Amount_Weight,0) - COALESCE (tmpMovement.AmountWeight_calc,0) - COALESCE (tmpOrder.Amount_Weight_calc,0) < 0 
            		          THEN COALESCE (tmpMovement.AmountWeight_calc,0) + COALESCE (tmpOrder.Amount_Weight_calc,0) - COALESCE (tmpRemains.Amount_Weight,0)
            				  ELSE 0 
            			 END  ::TFloat  AS Remains_Weight_diff
                       --не хватает завтра
                       , CASE WHEN COALESCE (tmpMovement.AmountWeight_calc1,0) + COALESCE (tmpOrder.Amount_Weight_calc1,0) > 0 
                               AND COALESCE (tmpRemains.Amount_Weight,0) 
                                 - (COALESCE (tmpMovement.AmountWeight_calc,0) + COALESCE (tmpOrder.Amount_Weight_calc,0)) 
                                 - (COALESCE (tmpMovement.AmountWeight_calc1,0) + COALESCE (tmpOrder.Amount_Weight_calc1,0)) < 0
                                   --остаток после отгр. сегодня
                              THEN CASE WHEN COALESCE (tmpRemains.Amount_Weight,0) - (COALESCE (tmpMovement.AmountWeight_calc,0) + COALESCE (tmpOrder.Amount_Weight_calc,0)) > 0 
                                        THEN (COALESCE (tmpMovement.AmountWeight_calc1,0) + COALESCE (tmpOrder.Amount_Weight_calc1,0)) - (COALESCE (tmpRemains.Amount_Weight,0) - COALESCE (tmpMovement.AmountWeight_calc,0)-COALESCE (tmpOrder.Amount_Weight_calc,0)) 
                                        ELSE COALESCE (tmpMovement.AmountWeight_calc1,0) + COALESCE (tmpOrder.Amount_Weight_calc1,0)
                                   END 
                              ELSE 0
                         END  ::TFloat  AS Remains1_Weight_diff
                       -- не хватает далее
                       ,  CASE WHEN COALESCE (tmpMovement.AmountWeight_calc2,0) + COALESCE (tmpMovement.AmountWeight_calc3,0) + COALESCE (tmpOrder.Amount_Weight_calc2,0) > 0
                               AND COALESCE (tmpRemains.Amount_Weight,0) 
                                 - (COALESCE (tmpMovement.AmountWeight_calc,0) + COALESCE (tmpOrder.Amount_Weight_calc,0))        --отгрузка сегодня 
                                 - (COALESCE (tmpMovement.AmountWeight_calc1,0) + COALESCE (tmpOrder.Amount_Weight_calc1,0))      --отгрузка завтра
                                 - (COALESCE (tmpMovement.AmountWeight_calc2,0) + COALESCE (tmpMovement.AmountWeight_calc3,0) + COALESCE (tmpOrder.Amount_Weight_calc2,0) ) < 0   --отгрузка далее
                              THEN  CASE WHEN COALESCE (tmpRemains.Amount_Weight,0)
                                          - (COALESCE (tmpMovement.AmountWeight_calc,0) + COALESCE (tmpOrder.Amount_Weight_calc,0))
                                          - (COALESCE (tmpMovement.AmountWeight_calc1,0) + COALESCE (tmpOrder.Amount_Weight_calc1,0)) > 0 
                                        THEN  COALESCE (tmpMovement.AmountWeight_calc2,0) + COALESCE (tmpMovement.AmountWeight_calc3,0) + COALESCE (tmpOrder.Amount_Weight_calc2,0)
				                               - (COALESCE (tmpRemains.Amount_Weight,0)
									              - (COALESCE (tmpMovement.AmountWeight_calc,0) + COALESCE (tmpOrder.Amount_Weight_calc,0))
									              - (COALESCE (tmpMovement.AmountWeight_calc1,0) + COALESCE (tmpOrder.Amount_Weight_calc1,0) )
									             ) 
                                        ELSE COALESCE (tmpMovement.AmountWeight_calc2,0) + COALESCE (tmpMovement.AmountWeight_calc3,0) + COALESCE (tmpOrder.Amount_Weight_calc2,0)
                                        END
                              ELSE 0
                         END   ::TFloat  AS Remains2_Weight_diff
            
                         ------ перемещение
                       , tmpSendIn.Amount        ::TFloat AS AmountSend
                       , tmpSendIn.Amount_Sh     ::TFloat AS AmountSend_Sh
                       , tmpSendIn.Amount_Weight ::TFloat AS AmountSend_Weight
            
                   FROM tmpMovement
                 
                      LEFT JOIN tmpOrder ON tmpOrder.GoodsId = tmpMovement.GoodsId
                                        AND tmpOrder.GoodsKindId = tmpMovement.GoodsKindId
                                        AND tmpOrder.ToId = tmpMovement.ToId
                      LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpMovement.GoodsId
                                          AND COALESCE (tmpRemains.GoodsKindId,0) = COALESCE (tmpMovement.GoodsKindId,0)
                                          AND tmpRemains.ToId = tmpMovement.ToId 
                      LEFT JOIN tmpSendIn ON tmpSendIn.GoodsId = tmpMovement.GoodsId
                                         AND tmpSendIn.GoodsKindId = tmpMovement.GoodsKindId
                                         AND tmpSendIn.ToId = tmpMovement.ToId

                 )     

   , tmpGoodsByGoodsKindParam AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                                       , Object_GoodsByGoodsKind_View.GoodsKindId
                                       , Object_GoodsSubSend.Id               AS GoodsSubSendId
                                       , Object_GoodsSubSend.ObjectCode       AS GoodsSubSendCode
                                       , Object_GoodsSubSend.ValueData        AS GoodsSubSendName
                                       , Object_GoodsKindSubSend.Id           AS GoodsKindSubSendId
                                       , Object_GoodsKindSubSend.ValueData    AS GoodsKindSubSendName
                                  FROM Object_GoodsByGoodsKind_View

                                      LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsSubSend
                                                           ON ObjectLink_GoodsByGoodsKind_GoodsSubSend.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                          AND ObjectLink_GoodsByGoodsKind_GoodsSubSend.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsSub()
                                      LEFT JOIN Object AS Object_GoodsSubSend ON Object_GoodsSubSend.Id = ObjectLink_GoodsByGoodsKind_GoodsSubSend.ChildObjectId

                                      LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKindSubSend
                                                           ON ObjectLink_GoodsByGoodsKind_GoodsKindSubSend.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                          AND ObjectLink_GoodsByGoodsKind_GoodsKindSubSend.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKindSub()
                                      LEFT JOIN Object AS Object_GoodsKindSubSend ON Object_GoodsKindSubSend.Id = ObjectLink_GoodsByGoodsKind_GoodsKindSubSend.ChildObjectId

                                  WHERE COALESCE (ObjectLink_GoodsByGoodsKind_GoodsSubSend.ChildObjectId, 0) <> 0
                                     OR COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKindSubSend.ChildObjectId, 0) <> 0
                                  )


       -- Результат
       SELECT
             tmpMovement.MovementId                     AS MovementId
           , Movement.OperDate                          AS OperDate
           , Movement.InvNumber                         AS InvNumber
           , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner

           , tmpMLM_All.InvNumber                       AS InvNumber_Master
           , tmpMLM_All.OperDate                        AS OperDate_Master
           , tmpMLM_All.OperDatePartner                 AS OperDatePartner_Master

           , tmpMovement.OperDatePartner_order  :: TDateTime
           , tmpMovement.OperDatePartner_sale   :: TDateTime

           , View_Contract_InvNumber.ContractCode
           , View_Contract_InvNumber.InvNumber          AS ContractNumber
           , View_Contract_InvNumber.ContractTagName
           , View_Contract_InvNumber.ContractTagGroupName

           , Object_From.ObjectCode                     AS FromCode
           , Object_From.ValueData                      AS FromName
           , Object_To.ObjectCode                       AS ToCode
           , Object_To.ValueData                        AS ToName

           , Object_RouteGroup.ValueData                AS RouteGroupName
           , Object_Route.ValueData                     AS RouteName
           , Object_RouteSorting.ValueData              AS RouteSortingName
           , Object_Personal.ValueData                  AS PersonalName
           , Object_PaidKind.ValueData                  AS PaidKindName

           , Object_Juridical.ValueData    AS JuridicalName
           , Object_Retail.ValueData       AS RetailName  
           --для печати
           , COALESCE (Object_Retail.ValueData, Object_From.ValueData)  ::TVarChar AS  RetailName_print
           
           , View_Partner_Address.PartnerTagName
           , View_Partner_Address.RegionName
           , View_Partner_Address.CityKindName
           , View_Partner_Address.CityName
           , View_Partner_Address.StreetKindName
           , View_Partner_Address.StreetName

           , Object_Goods.Id                            AS GoodsId
           , Object_Goods.ObjectCode                    AS GoodsCode
           , Object_Goods.ValueData                     AS GoodsName
           , Object_GoodsKind.ValueData                 AS GoodsKindName
           , Object_Measure.ValueData                   AS MeasureName
           , Object_GoodsGroup.ValueData                AS GoodsGroupName
           , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
           , Object_TradeMark.ValueData                 AS TradeMarkName

             -- Вес в упаковке - GoodsByGoodsKind
           , ObjectFloat_WeightTotal.ValueData AS WeightTotal
           -- кол-во и суммы  показываем только для первой строки заказа
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.Summ1 ELSE 0 END                            :: TFloat AS AmountSumm1
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.Summ2 ELSE 0 END                            :: TFloat AS AmountSumm2

           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN (tmpMovement.SummSecond1) ELSE 0 END                    :: TFloat AS AmountSumm_Dozakaz1
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN (tmpMovement.SummSecond2) ELSE 0 END                    :: TFloat AS AmountSumm_Dozakaz2
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN (tmpMovement.Summ1 + tmpMovement.Summ2 + tmpMovement.SummSecond1 + tmpMovement.SummSecond2) ELSE 0 END :: TFloat AS AmountSumm

           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.Amount_Weight1 ELSE 0 END                   :: TFloat AS Amount_Weight1
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.Amount_Sh1 ELSE 0 END                       :: TFloat AS Amount_Sh1
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.Amount_Weight2 ELSE 0 END                   :: TFloat AS Amount_Weight2
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.Amount_Sh2 ELSE 0 END                       :: TFloat AS Amount_Sh2
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN (tmpMovement.AmountSecond_Weight1) ELSE 0 END           :: TFloat AS Amount_Weight_Dozakaz1
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN (tmpMovement.AmountSecond_Sh1 ) ELSE 0 END              :: TFloat AS Amount_Sh_Dozakaz1
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN (tmpMovement.AmountSecond_Weight2) ELSE 0 END           :: TFloat AS Amount_Weight_Dozakaz2
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN (tmpMovement.AmountSecond_Sh2) ELSE 0 END               :: TFloat AS Amount_Sh_Dozakaz2

           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN (tmpMovement.Amount) ELSE 0 END                         :: TFloat AS Amount
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN (tmpMovement.AmountZakaz) ELSE 0 END                    :: TFloat AS AmountZakaz                       -- количество без дозаказа
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.AmountSecond1 ELSE 0 END                    :: TFloat AS AmountSecond1
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.AmountSecond2 ELSE 0 END                    :: TFloat AS AmountSecond2

           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN (tmpMovement.Amount_Weight1 + tmpMovement.Amount_Weight2 + tmpMovement.AmountSecond_Weight1 + tmpMovement.AmountSecond_Weight2) ELSE 0 END :: TFloat AS Amount_Weight
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN (tmpMovement.Amount_Weight1 + tmpMovement.Amount_Weight2) ELSE 0 END                                                                       :: TFloat AS AmountZakaz_Weight  -- вес без дозаказа
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN (tmpMovement.Amount_Sh1 + tmpMovement.Amount_Sh2 + tmpMovement.AmountSecond_Sh1 + tmpMovement.AmountSecond_Sh2) ELSE 0 END                 :: TFloat AS Amount_Sh
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN (tmpMovement.Amount_Sh1 + tmpMovement.Amount_Sh2) ELSE 0 END                                                                               :: TFloat AS AmountZakaz_Sh      -- шт без дозаказа
           , 0 :: TFloat AS Amount_WeightSK

           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.AmountWeight_calc  ELSE 0 END  :: TFloat AS AmountWeight_calc          
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.AmountWeight_calc1 ELSE 0 END  :: TFloat AS AmountWeight_calc1         
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.AmountWeight_calc2 ELSE 0 END  :: TFloat AS AmountWeight_calc2             
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.AmountWeight_calc3 ELSE 0 END  :: TFloat AS AmountWeight_calc3  
                 
              -- child
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.Amount_Child_one  ELSE 0 END        ::TFloat AS Amount_Child_one              -- с Остатка
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.Amount_Child_sec  ELSE 0 END        ::TFloat AS Amount_Child_sec        -- с Прихода
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.Amount_Child  ELSE 0 END            ::TFloat AS Amount_Child         -- Итого
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN (COALESCE (tmpMovement.Amount,0) - COALESCE (tmpMovement.Amount_Child,0) ) ELSE 0 END ::TFloat AS Amount_diff-- разница резерв с итого заявка  
           --вес
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.AmountWeight_child_one  ELSE 0 END  ::TFloat AS AmountWeight_child_one       -- с Остатка
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.AmountWeight_child_sec  ELSE 0 END  ::TFloat AS AmountWeight_child_sec       -- с Прихода
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.AmountWeight_child  ELSE 0 END      ::TFloat AS AmountWeight_child           -- Итого
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN (COALESCE (tmpMovement.Amount_Weight,0) - COALESCE (tmpMovement.AmountWeight_child,0) ) ELSE 0 END ::TFloat AS AmountWeight_diff-- разница резерв с итого заявка  
           --шт
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.AmountSh_child_one  ELSE 0 END  ::TFloat AS AmountSh_child_one       -- с Остатка
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.AmountSh_child_sec  ELSE 0 END  ::TFloat AS AmountSh_child_sec       -- с Прихода
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.AmountSh_child  ELSE 0 END      ::TFloat AS AmountSh_child           -- Итого
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN (COALESCE (tmpMovement.Amount_Sh,0) - COALESCE (tmpMovement.AmountSh_child,0) ) ELSE 0 END ::TFloat AS AmountSh_diff-- разница резерв с итого заявка  


             --остатки
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.AmountRemains ELSE 0 END         ::TFloat  AS AmountRemains
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.AmountRemains_Sh ELSE 0 END      ::TFloat  AS AmountRemains_Sh
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.AmountRemains_Weight ELSE 0 END  ::TFloat  AS AmountRemains_Weight 


           -- расчет остаток - отгрузка  (заказ вчера)
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.Remains_Weight_calc ELSE 0 END  ::TFloat AS Remains_Weight_calc 
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.Remains_Weight_calc1 ELSE 0 END ::TFloat AS Remains_Weight_calc1 
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.Remains_Weight_calc2 ELSE 0 END ::TFloat AS Remains_Weight_calc2   
            
            --заказ дата пок = выбр дате, а дата заявки < выбр даты   , те. заказы прошлого дня
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.AmountOrder ELSE 0 END         ::TFloat  AS AmountOrder
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.AmountOrder_Sh ELSE 0 END      ::TFloat  AS AmountOrder_Sh
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.AmountOrder_Weight ELSE 0 END  ::TFloat  AS AmountOrder_Weight
           --отгрузка сегодня
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.AmountOrder_calc ELSE 0 END    ::TFloat  AS AmountOrder_calc
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.AmountOrder_Sh_calc ELSE 0 END ::TFloat  AS AmountOrder_Sh_calc          
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.AmountOrder_Weight_calc ELSE 0 END  ::TFloat  AS AmountOrder_Weight_calc
           --отгрузка завтра
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.AmountOrder_calc1 ELSE 0 END    ::TFloat  AS AmountOrder_calc1
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.AmountOrder_Sh_calc1 ELSE 0 END ::TFloat  AS AmountOrder_Sh_calc1          
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.AmountOrder_Weight_calc1 ELSE 0 END  ::TFloat  AS AmountOrder_Weight_calc1
           --отгрузка далее
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.AmountOrder_calc2 ELSE 0 END    ::TFloat  AS AmountOrder_calc2
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.AmountOrder_Sh_calc2 ELSE 0 END ::TFloat  AS AmountOrder_Sh_calc2          
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.AmountOrder_Weight_calc2 ELSE 0 END  ::TFloat  AS AmountOrder_Weight_calc2

           --к отгрузке  
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.AmountRemainsSH_diff ELSE 0 END     ::TFloat  AS AmountRemainsSH_diff
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.AmountRemainsWeight_diff ELSE 0 END ::TFloat  AS AmountRemainsWeight_diff 
           
           --не хватает 
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.Remains_Weight_diff  ELSE 0 END ::TFloat  AS Remains_Weight_diff
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.Remains1_Weight_diff ELSE 0 END ::TFloat  AS Remains1_Weight_diff
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.Remains2_Weight_diff ELSE 0 END ::TFloat  AS Remains2_Weight_diff
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN COALESCE (tmpMovement.Remains_Weight_diff,0) + COALESCE (tmpMovement.Remains1_Weight_diff,0) + COALESCE (tmpMovement.Remains2_Weight_diff,0) ELSE 0 END ::TFloat  AS RemainsAll_Weight_diff
             ------ перемещение
           , tmpMovement.AmountSend        ::TFloat AS AmountSend
           , tmpMovement.AmountSend_Sh     ::TFloat AS AmountSend_Sh
           , tmpMovement.AmountSend_Weight ::TFloat AS AmountSend_Weight

           , inStartDate   ::TDateTime AS DatePrint
           , vbStartDate_1 ::TDateTime AS DatePrint1
           , vbStartDate_2 ::TDateTime AS DatePrint2

           , View_InfoMoney.InfoMoneyCode                         AS InfoMoneyCode
           , View_InfoMoney.InfoMoneyName                         AS InfoMoneyName
           , View_InfoMoney.InfoMoneyName_all                     AS InfoMoneyName_all

           , View_InfoMoney_goods.InfoMoneyCode                   AS InfoMoneyCode_goods
           , View_InfoMoney_goods.InfoMoneyName                   AS InfoMoneyName_goods
           , View_InfoMoney_goods.InfoMoneyName_all               AS InfoMoneyName_goods_all
           
           , tmpMovement.Comment ::TVarChar
           
           --, COALESCE (tmpObject_GoodsPropertyValue.CodeSticker, tmpObject_GoodsPropertyValue_basis.CodeSticker)  ::TVarChar AS CodeSticker
           --временно классификатор Алан
           , tmpObject_GoodsPropertyValue_basis.CodeSticker  ::TVarChar AS CodeSticker 

           , Object_CarInfo.ValueData           ::TVarChar   AS CarInfoName
           , tmpMovement.OperDate_CarInfo       ::TDateTime  AS OperDate_CarInfo 
           , tmpMovement.OperDate_CarInfo_date  ::TDateTime  AS OperDate_CarInfo_date

           , tmpWeekDay.DayOfWeekName                   ::TVarChar AS DayOfWeekName
           , tmpWeekDay_Partner.DayOfWeekName           ::TVarChar AS DayOfWeekName_Partner
           , tmpWeekDay_CarInfo.DayOfWeekName           ::TVarChar AS DayOfWeekName_CarInfo
           , tmpWeekDay_CarInfo_date.DayOfWeekName      ::TVarChar AS DayOfWeekName_CarInfo_date

           , tmpGoodsByGoodsKindParam.GoodsSubSendId       ::Integer
           , tmpGoodsByGoodsKindParam.GoodsSubSendCode     ::Integer
           , tmpGoodsByGoodsKindParam.GoodsSubSendName     ::TVarChar
           , tmpGoodsByGoodsKindParam.GoodsKindSubSendId   ::Integer
           , tmpGoodsByGoodsKindParam.GoodsKindSubSendName ::TVarChar
           , COALESCE (tmpGoodsByGoodsKindParam.GoodsSubSendName, Object_Goods.ValueData) ::TVarChar AS GoodsName_SubSend
       FROM tmpData AS tmpMovement
          LEFT JOIN Movement ON Movement.Id = tmpMovement.MovementId
          LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                   ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                  AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

          LEFT JOIN Object AS Object_From ON Object_From.Id = tmpMovement.FromId
          LEFT JOIN Object AS Object_To ON Object_To.Id = tmpMovement.ToId
          LEFT JOIN Object AS Object_Route ON Object_Route.Id = tmpMovement.RouteId
          LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = tmpMovement.RouteSortingId
          LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = tmpMovement.PersonalId
          LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpMovement.PaidKindId
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMovement.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMovement.GoodsKindId  
          
          LEFT JOIN Object AS Object_CarInfo ON Object_CarInfo.Id = tmpMovement.CarInfoId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                               ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
          LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectLink AS ObjectLink_Route_RouteGroup ON ObjectLink_Route_RouteGroup.ObjectId = Object_Route.Id
                                                             AND ObjectLink_Route_RouteGroup.DescId = zc_ObjectLink_Route_RouteGroup()
          LEFT JOIN Object AS Object_RouteGroup ON Object_RouteGroup.Id = COALESCE (ObjectLink_Route_RouteGroup.ChildObjectId, Object_Route.Id)

          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpMovement.JuridicalId 
          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = tmpMovement.RetailId

          /*LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = tmpMovement.FromId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                               ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
          */
          LEFT JOIN tmpPartnerAddress AS View_Partner_Address ON View_Partner_Address.PartnerId = tmpMovement.FromId

          LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = tmpMovement.ContractId
          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId

          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_goods ON View_InfoMoney_goods.InfoMoneyId = tmpMovement.InfoMoneyId
          
          LEFT JOIN tmpMLM_All ON tmpMLM_All.MovementId_Order = tmpMovement.MovementId

           -- Товар и Вид товара
          LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId     = tmpMovement.GoodsId
                                                AND Object_GoodsByGoodsKind_View.GoodsKindId = tmpMovement.GoodsKindId
          -- вес в упаковке: "чистый" вес + вес 1-ого пакета
          LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                ON ObjectFloat_WeightTotal.ObjectId = Object_GoodsByGoodsKind_View.Id
                               AND ObjectFloat_WeightTotal.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()
          -- 
          LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsPropertyId = tmpMovement.GoodsPropertyId
                                                AND tmpObject_GoodsPropertyValue.GoodsId = tmpMovement.GoodsId
                                                AND tmpObject_GoodsPropertyValue.GoodsKindId = tmpMovement.GoodsKindId
          LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsPropertyId = tmpMovement.GoodsPropertyId_basis
                                                      AND tmpObject_GoodsPropertyValue_basis.GoodsId = tmpMovement.GoodsId
                                                      AND tmpObject_GoodsPropertyValue_basis.GoodsKindId = tmpMovement.GoodsKindId
          
          LEFT JOIN tmpOrder ON tmpOrder.GoodsId = tmpMovement.GoodsId
                            AND tmpOrder.GoodsKindId = tmpMovement.GoodsKindId
                            AND tmpOrder.ToId = tmpMovement.ToId
          LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpMovement.GoodsId
                              AND COALESCE (tmpRemains.GoodsKindId,0) = COALESCE (tmpMovement.GoodsKindId,0)
                              AND tmpRemains.ToId = tmpMovement.ToId 
          LEFT JOIN tmpSendIn ON tmpSendIn.GoodsId = tmpMovement.GoodsId
                             AND tmpSendIn.GoodsKindId = tmpMovement.GoodsKindId
                             AND tmpSendIn.ToId = tmpMovement.ToId

          LEFT JOIN tmpGoodsByGoodsKindParam ON tmpGoodsByGoodsKindParam.GoodsId = tmpMovement.GoodsId
                                            AND COALESCE (tmpGoodsByGoodsKindParam.GoodsKindId, 0) = COALESCE (tmpMovement.GoodsKindId, 0)

          LEFT JOIN zfCalc_DayOfWeekName (Movement.OperDate) AS tmpWeekDay ON 1=1
          LEFT JOIN zfCalc_DayOfWeekName (tmpMovement.OperDatePartner_order) AS tmpWeekDay_Partner ON 1=1
          LEFT JOIN zfCalc_DayOfWeekName (tmpMovement.OperDate_CarInfo) AS tmpWeekDay_CarInfo ON 1=1
          LEFT JOIN zfCalc_DayOfWeekName (tmpMovement.OperDate_CarInfo_date) AS tmpWeekDay_CarInfo_date ON 1=1

         ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpReport_OrderExternal (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 20.06.22         *
 12.03.21         *
 14.12.20         * add Comment
 26.06.18         *
 18.04.18         *
 25.05.17         *
 29.06.15                                        * ALL
 02.09.14                                                        *
 29.08.14                                                        *
 22.08.14                                                        *
 21.08.14                                                        *
*/

-- тест
-- SELECT * FROM gpReport_OrderExternal (inStartDate:= '21.06.2022', inEndDate:= '21.06.2022', inJuridicalId:=0, inRetailId:= 0, inFromId := 0, inToId := 346093, inRouteId := 0, inRouteSortingId := 0, inGoodsGroupId := 1986, inIsByDoc := False, inIsRemains := TRUE, inSession:= zfCalc_UserAdmin())
 --WHERE GOODSID = 7493  
 --select * from gpReport_OrderExternal(inStartDate := ('11.07.2022')::TDateTime , inEndDate := ('11.07.2022')::TDateTime , inJuridicalId := 0 , inRetailId := 0 , inFromId := 0 , inToId := 8459 , inRouteId := 0 , inRouteSortingId := 0 , inGoodsGroupId := 0 , inIsByDoc := 'True' , inIsRemains := 'False' ,  inSession := '9457');
