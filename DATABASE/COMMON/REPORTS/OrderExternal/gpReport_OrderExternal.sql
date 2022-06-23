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
             , RetailName TVarChar
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
             , Amount_Weight TFloat, AmountZakaz_Weight TFloat, Amount_Sh TFloat, AmountZakaz_Sh TFloat

             , Amount_WeightSK TFloat
             
             , AmountWeight_calc   TFloat, AmountWeight_calc1  TFloat, AmountWeight_calc2  TFloat, AmountWeight_calc3  TFloat 
             
             , Amount_Child        TFloat
             , AmountSecond_Child  TFloat
             , TotalAmount_Child   TFloat
             , Amount_diff         TFloat -- разница с итого заявка 

             , AmountRemains            TFloat
             , AmountRemains_Sh         TFloat
             , AmountRemains_Weight     TFloat
             , AmountOrder              TFloat
             , AmountOrder_Sh           TFloat
             , AmountOrder_Weight       TFloat
             --, AmountRemains_diff       TFloat
             , AmountRemainsSH_diff     TFloat
             , AmountRemainsWeight_diff TFloat

             , DatePrint TDateTime, DatePrint1 TDateTime, DatePrint2 TDateTime

             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , InfoMoneyCode_goods Integer, InfoMoneyName_goods TVarChar, InfoMoneyName_goods_all TVarChar
             , Comment TVarChar
             , CodeSticker TVarChar

             , CarInfoName  TVarChar
             , OperDate_CarInfo TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer; 
   DECLARE vbStartDate_1 TDateTime;
   DECLARE vbStartDate_2 TDateTime;
   DECLARE vbStartDate_3 TDateTime;
BEGIN

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
                                         AND (inStartDate = inEndDate)
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
                     WHERE inStartDate = inEndDate   --если за 1 день
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
              
                         , SUM ( COALESCE (MovementItem.Amount,0)+ COALESCE (MIFloat_AmountSecond.ValueData, 0)) AS Amount
                         , SUM ((COALESCE (MovementItem.Amount,0)+ COALESCE (MIFloat_AmountSecond.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Amount_Weight 
                         , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (MovementItem.Amount,0)+ COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS Amount_Sh
                    FROM MovementDate AS MovementDate_OperDatePartner 
                        INNER JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId
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

                        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                                                        AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                              ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                             AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
    
                    WHERE inStartDate = inEndDate
                      AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                      AND MovementDate_OperDatePartner.ValueData = inStartDate
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

     , tmpPartnerAddress AS (SELECT * FROM Object_Partner_Address_View)

     , tmpMovement2 AS (SELECT CASE WHEN inIsByDoc = TRUE THEN Movement.Id ELSE 0 END   AS MovementId
                             , CASE WHEN inIsRemains = FALSE THEN MovementLinkObject_Contract.ObjectId ELSE 0 END AS ContractId
                             , CASE WHEN inIsRemains = FALSE THEN ObjectLink_Partner_Juridical.ChildObjectId ELSE 0 END               AS JuridicalId
                             , CASE WHEN inIsRemains = FALSE THEN ObjectLink_Juridical_Retail.ChildObjectId ELSE 0 END                AS RetailId
                             , CASE WHEN inIsRemains = FALSE THEN MovementLinkObject_From.ObjectId ELSE 0 END                         AS FromId
                             , MovementLinkObject_To.ObjectId                           AS ToId
                             , CASE WHEN inIsRemains = FALSE THEN MovementLinkObject_Route.ObjectId ELSE 0 END                        AS RouteId
                             , 0                                                        AS RouteSortingId
                             , CASE WHEN inIsRemains = FALSE THEN MovementLinkObject_Personal.ObjectId ELSE 0 END                     AS PersonalId
                             , CASE WHEN inIsRemains = FALSE THEN MovementLinkObject_PaidKind.ObjectId ELSE 0 END                     AS PaidKindId
                             , CASE WHEN inIsRemains = FALSE THEN COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE) ELSE FALSE END AS isPriceWithVAT
                             , CASE WHEN inIsRemains = FALSE THEN COALESCE (MovementFloat_VATPercent.ValueData, 0)  ELSE 0 END        AS VATPercent
                             , CASE WHEN inIsRemains = FALSE THEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) ELSE 0 END      AS ChangePercent
                             , MovementItem.ObjectId                                    AS GoodsId
                             , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId NOT IN (zc_Enum_InfoMoney_30102(), zc_Enum_InfoMoney_30103()) THEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) END AS GoodsKindId
                             , CASE WHEN inIsRemains = FALSE THEN ObjectLink_Goods_InfoMoney.ChildObjectId ELSE 0 END                 AS InfoMoneyId
                  
                             , SUM (CASE WHEN Movement.OperDate =  COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) AND MovementItem.DescId = zc_MI_Master() THEN MovementItem.Amount ELSE 0 END) AS Amount1
                             , SUM (CASE WHEN Movement.OperDate <> COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) AND MovementItem.DescId = zc_MI_Master()THEN MovementItem.Amount ELSE 0 END) AS Amount2
                             , SUM (CASE WHEN Movement.OperDate =  COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) AND MovementItem.DescId = zc_MI_Master()THEN COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountSecond1
                             , SUM (CASE WHEN Movement.OperDate <> COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) AND MovementItem.DescId = zc_MI_Master()THEN COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountSecond2
                             
                             --
                             , SUM (CASE WHEN COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) = inStartDate    AND MovementItem.DescId = zc_MI_Master() THEN COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS Amount_calc
                             , SUM (CASE WHEN COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) = vbStartDate_1  AND MovementItem.DescId = zc_MI_Master() THEN COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS Amount_calc1
                             , SUM (CASE WHEN COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) = vbStartDate_2  AND MovementItem.DescId = zc_MI_Master() THEN COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS Amount_calc2
                             , SUM (CASE WHEN COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= vbStartDate_3 AND MovementItem.DescId = zc_MI_Master() THEN COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS Amount_calc3 
                             --сhild
                             , SUM (CASE WHEN MovementItem.DescId = zc_MI_Child() THEN MovementItem.Amount ELSE 0 END) AS Amount_Child
                             , SUM (CASE WHEN MovementItem.DescId = zc_MI_Child()THEN COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountSecond_Child
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
                             
                             , CASE WHEN inIsRemains = FALSE THEN zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_From.ObjectId), COALESCE (MovementLinkObject_Partner.ObjectId, MovementLinkObject_From.ObjectId))  ELSE 0 END AS GoodsPropertyId
                             , CASE WHEN inIsRemains = FALSE THEN zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0)  ELSE 0 END     AS GoodsPropertyId_basis 

                             , CASE WHEN inIsRemains = FALSE THEN MovementLinkObject_CarInfo.ObjectId  ELSE 0 END           AS CarInfoId
                             , CASE WHEN inIsRemains = FALSE THEN MovementDate_CarInfo.ValueData  ELSE NULL END    ::TDateTime AS OperDate_CarInfo 
                             
                        FROM Movement
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
                            -- LEFT JOIN MovementLinkObject AS MovementLinkObject_RouteSorting
                            --                             ON MovementLinkObject_RouteSorting.MovementId = Movement.Id
                            --                            AND MovementLinkObject_RouteSorting.DescId = zc_MovementLinkObject_RouteSorting()
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                                         ON MovementLinkObject_Personal.MovementId = Movement.Id
                                                        AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_CarInfo
                                                         ON MovementLinkObject_CarInfo.MovementId = Movement.Id
                                                        AND MovementLinkObject_CarInfo.DescId = zc_MovementLinkObject_CarInfo()

                            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                 --          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId
                            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                 --          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
  
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                                                        --AND Object_From.DescId = zc_Object_Unit()

                            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                   ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

                            LEFT JOIN MovementDate AS MovementDate_CarInfo
                                                   ON MovementDate_CarInfo.MovementId = Movement.Id
                                                  AND MovementDate_CarInfo.DescId = zc_MovementDate_CarInfo()

                            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
                            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

                            LEFT JOIN MovementString AS MovementString_Comment
                                                     ON MovementString_Comment.MovementId = Movement.Id
                                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                   --AND MovementItem.DescId     = zc_MI_Master()
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
                                                            -- AND ObjectLink_Goods_InfoMoney.ChildObjectId NOT IN (zc_Enum_InfoMoney_30102(), zc_Enum_InfoMoney_30103()) -- Тушенка + Хлеб
                                                            -- AND ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- Ирна + Готовая продукция + Доходы Мясное сырье
                            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                       AND MovementItem.DescId     = zc_MI_Master()
                            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                                                       AND MovementItem.DescId     = zc_MI_Master()

                            LEFT JOIN ObjectFloat AS ObjectFloat_DocumentDayCount 
                                                  ON ObjectFloat_DocumentDayCount.ObjectId = MovementLinkObject_From.ObjectId 
                                                 AND ObjectFloat_DocumentDayCount.DescId = zc_ObjectFloat_Partner_DocumentDayCount()
                            
                        WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                          AND Movement.DescId = zc_Movement_OrderExternal()
                          AND (COALESCE (MovementLinkObject_To.ObjectId,0) = CASE WHEN inToId <> 0 THEN inToId ELSE COALESCE (MovementLinkObject_To.ObjectId,0) END)
                          AND (COALESCE (MovementLinkObject_From.ObjectId,0) = CASE WHEN inFromId <> 0 THEN inFromId ELSE COALESCE (MovementLinkObject_From.ObjectId,0) END)
                          AND (COALESCE (MovementLinkObject_Route.ObjectId,0) = CASE WHEN inRouteId <> 0 THEN inRouteId ELSE COALESCE (MovementLinkObject_Route.ObjectId,0) END)
                          -- AND (COALESCE (MovementLinkObject_RouteSorting.ObjectId,0) = CASE WHEN inRouteSortingId <> 0 THEN inRouteSortingId ELSE COALESCE (MovementLinkObject_RouteSorting.ObjectId,0) END)
                          AND (COALESCE (ObjectLink_Partner_Juridical.ChildObjectId,0) = CASE WHEN inJuridicalId <> 0 THEN inJuridicalId ELSE COALESCE (ObjectLink_Partner_Juridical.ChildObjectId,0) END)
                          AND (COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) = CASE WHEN inRetailId <> 0 THEN inRetailId ELSE COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) END)
                        GROUP BY
                              CASE WHEN inIsByDoc = TRUE THEN Movement.Id ELSE 0 END
                            , CASE WHEN inIsRemains = FALSE THEN MovementLinkObject_Contract.ObjectId ELSE 0 END
                            , CASE WHEN inIsRemains = FALSE THEN MovementLinkObject_From.ObjectId ELSE 0 END
                            , MovementLinkObject_To.ObjectId
                            , CASE WHEN inIsRemains = FALSE THEN MovementLinkObject_Route.ObjectId ELSE 0 END
                            , CASE WHEN inIsRemains = FALSE THEN MovementLinkObject_Personal.ObjectId ELSE 0 END
                            , CASE WHEN inIsRemains = FALSE THEN MovementLinkObject_PaidKind.ObjectId ELSE 0 END
                            , CASE WHEN inIsRemains = FALSE THEN MovementFloat_VATPercent.ValueData ELSE 0 END
                            , CASE WHEN inIsRemains = FALSE THEN MovementFloat_ChangePercent.ValueData ELSE 0 END
                            , MovementItem.ObjectId
                            , MILinkObject_GoodsKind.ObjectId
                            , CASE WHEN inIsRemains = FALSE THEN  ObjectLink_Goods_InfoMoney.ChildObjectId ELSE 0 END
                            , CASE WHEN inIsRemains = FALSE THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                            , CASE WHEN inIsRemains = FALSE THEN MIFloat_Price.ValueData ELSE 0 END
                            , CASE WHEN inIsRemains = FALSE THEN ObjectLink_Partner_Juridical.ChildObjectId ELSE 0 END
                            , CASE WHEN inIsRemains = FALSE THEN ObjectLink_Juridical_Retail.ChildObjectId ELSE 0 END
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
                            , CASE WHEN inIsRemains = FALSE THEN zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_From.ObjectId), COALESCE (MovementLinkObject_Partner.ObjectId, MovementLinkObject_From.ObjectId))  ELSE 0 END
                             , CASE WHEN inIsRemains = FALSE THEN zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0)  ELSE 0 END 

                             , CASE WHEN inIsRemains = FALSE THEN MovementLinkObject_CarInfo.ObjectId  ELSE 0 END
                             , CASE WHEN inIsRemains = FALSE THEN MovementDate_CarInfo.ValueData  ELSE NULL END
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
                            , SUM (tmpMovement2.Amount_Child) AS Amount_child
                            , SUM (tmpMovement2.AmountSecond_child) AS AmountSecond_Child
                            , SUM (tmpMovement2.Amount_Child + tmpMovement2.AmountSecond_child) AS TotalAmount_child

                            , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpMovement2.Amount_Child ELSE 0 END)       AS AmountSh_child
                            , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpMovement2.AmountSecond_child ELSE 0 END) AS AmountSecondSh_Child
                            , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpMovement2.Amount_Child + tmpMovement2.AmountSecond_child ELSE 0 END) AS TotalAmountSh_child

                            , SUM (tmpMovement2.Amount_Child
                                 * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS AmountWeight_child
                            , SUM (tmpMovement2.AmountSecond_child
                                 * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS AmountSecondWeight_Child
                            , SUM (tmpMovement2.Amount_Child + tmpMovement2.AmountSecond_child
                                 * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS TotalAmountWeight_child
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
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.Amount_Child  ELSE 0 END        ::TFloat AS Amount_Child
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.AmountSecond_child  ELSE 0 END  ::TFloat AS AmountSecond_Child
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpMovement.TotalAmount_child  ELSE 0 END   ::TFloat AS TotalAmount_Child
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN (COALESCE (tmpMovement.Amount,0) - COALESCE (tmpMovement.TotalAmount_child,0) ) ELSE 0 END ::TFloat AS Amount_diff-- разница резерв с итого заявка  
             --остатки
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpRemains.Amount ELSE 0 END         ::TFloat  AS AmountRemains
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpRemains.Amount_Sh ELSE 0 END      ::TFloat  AS AmountRemains_Sh
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpRemains.Amount_Weight ELSE 0 END  ::TFloat  AS AmountRemains_Weight
            
            --заказ дата пок = выбр дате, а дата заявки < выбр даты   , те. заказы прошлого дня
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpOrder.Amount ELSE 0 END         ::TFloat  AS AmountOrder
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpOrder.Amount_Sh ELSE 0 END      ::TFloat  AS AmountOrder_Sh
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN tmpOrder.Amount_Weight ELSE 0 END  ::TFloat  AS AmountOrder_Weight
           
           --разница остаток и заказ 
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN CASE WHEN COALESCE (tmpMovement.Amount_Sh,0)+COALESCE (tmpOrder.Amount_Sh,0) > COALESCE (tmpRemains.Amount_Sh,0) THEN COALESCE (tmpMovement.Amount_Sh,0)+COALESCE (tmpOrder.Amount_Sh,0) - COALESCE (tmpRemains.Amount_Sh,0) ELSE 0 END ELSE 0 END ::TFloat  AS AmountRemainsSH_diff
           , CASE WHEN COALESCE (tmpMLM_All.Ord, 1) = 1 THEN CASE WHEN COALESCE (tmpMovement.Amount_Weight,0)+COALESCE (tmpOrder.Amount_Weight,0) > COALESCE (tmpRemains.Amount_Weight,0) THEN COALESCE (tmpMovement.Amount_Weight,0)+COALESCE (tmpOrder.Amount_Weight,0) - COALESCE (tmpRemains.Amount_Weight,0) ELSE 0 END ELSE 0 END ::TFloat  AS AmountRemainsWeight_diff
             ------           

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

           , Object_CarInfo.ValueData      ::TVarChar   AS CarInfoName
           , tmpMovement.OperDate_CarInfo  ::TDateTime  AS OperDate_CarInfo
       FROM tmpMovement
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
                            --AND tmpMLM_All.Ord = 1
          LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpMovement.GoodsId
                              AND COALESCE (tmpRemains.GoodsKindId,0) = COALESCE (tmpMovement.GoodsKindId,0)
                              AND tmpRemains.ToId = tmpMovement.ToId 
                        



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
