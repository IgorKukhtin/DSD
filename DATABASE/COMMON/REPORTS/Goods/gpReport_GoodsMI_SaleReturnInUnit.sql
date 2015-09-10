-- Function: gpReport_Goods_Movement ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_SaleReturnInUnit (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_SaleReturnInUnit (
    IN inStartDate    TDateTime ,
    IN inEndDate      TDateTime ,
    IN inBranchId     Integer   , -- Филиал
    IN inAreaId       Integer   , -- Регион (контрагенты -> юр лица)
    IN inRetailId     Integer   , -- Торговая сеть (юр лица)
    IN inJuridicalId  Integer   ,
    IN inPaidKindId   Integer   , --
    IN inTradeMarkId  Integer   ,
    IN inGoodsGroupId Integer   ,
    IN inInfoMoneyId  Integer   ,-- Управленческая статья
    IN inIsPartner    Boolean   , --
    IN inIsTradeMark  Boolean   , --
    IN inIsGoods      Boolean   , --
    IN inIsGoodsKind  Boolean   , --
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar, MeasureName TVarChar
             , TradeMarkName TVarChar, GoodsGroupAnalystName TVarChar, GoodsTagName TVarChar, GoodsGroupStatName TVarChar
             , GoodsPlatformName TVarChar
             , JuridicalGroupName TVarChar
             , BranchCode Integer, BranchName TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar, OKPO TVarChar
             , RetailName TVarChar, RetailReportName TVarChar
             , AreaName TVarChar, PartnerTagName TVarChar
             , Address TVarChar, RegionName TVarChar, ProvinceName TVarChar, CityKindName TVarChar, CityName TVarChar, ProvinceCityName TVarChar, StreetKindName TVarChar, StreetName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , ContractCode Integer, ContractNumber TVarChar, ContractTagName TVarChar, ContractTagGroupName TVarChar
             , PersonalName TVarChar, UnitName_Personal TVarChar, BranchName_Personal TVarChar
             , PersonalTradeName TVarChar, UnitName_PersonalTrade TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , AccountName TVarChar
             , Sale_Summ TFloat, Sale_Summ_10200 TFloat, Sale_Summ_10300 TFloat, Sale_SummCost TFloat, Sale_SummCost_10500 TFloat, Sale_SummCost_40200 TFloat
             , Sale_Amount_Weight TFloat , Sale_Amount_Sh TFloat, Sale_AmountPartner_Weight TFloat , Sale_AmountPartner_Sh TFloat
             , Return_Summ TFloat, Return_Summ_10300 TFloat, Return_SummCost TFloat, Return_SummCost_40200 TFloat
             , Return_Amount_Weight TFloat, Return_Amount_Sh TFloat, Return_AmountPartner_Weight TFloat, Return_AmountPartner_Sh TFloat
             , Sale_Amount_10500_Weight TFloat
             , Sale_Amount_40200_Weight TFloat
             , Return_Amount_40200_Weight TFloat
             , ReturnPercent TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsGoods Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
     vbUserId:= lpGetUserBySession (inSession);



    IF vbUserId = 5 THEN
       RETURN QUERY
       SELECT * FROM gpReport_GoodsMI_SaleReturnInUnit_NEW (inStartDate
                                                      , inEndDate
                                                      , inBranchId
                                                      , inAreaId
                                                      , inRetailId
                                                      , inJuridicalId
                                                      , inPaidKindId
                                                      , inTradeMarkId
                                                      , inGoodsGroupId
                                                      , inInfoMoneyId
                                                      , inIsPartner
                                                      , inIsTradeMark
                                                      , inIsGoods
                                                      , inIsGoodsKind
                                                      , inSession
                                                       );
       RETURN;
    END IF;

    -- Ограничения по товару
    CREATE TEMP TABLE _tmpGoods_report (GoodsId Integer, TradeMarkId Integer) ON COMMIT DROP;
    IF inGoodsGroupId <> 0
    THEN
        -- устанавливается признак
        vbIsGoods:= TRUE;
        -- заполнение
        INSERT INTO _tmpGoods_report (GoodsId, TradeMarkId)
           SELECT lfObject_Goods_byGoodsGroup.GoodsId AS GoodsId
                , CASE WHEN inIsTradeMark = TRUE OR inIsGoods = TRUE THEN COALESCE (ObjectLink_Goods_TradeMark.ChildObjectId, 0) ELSE 0 END AS TradeMarkId
                -- , COALESCE (ObjectLink_Goods_Measure.ChildObjectId, 0) AS MeasureId
                -- , COALESCE (ObjectFloat_Weight.ValueData, 0)           AS Weight
           FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup
                LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                     ON ObjectLink_Goods_TradeMark.ObjectId = lfObject_Goods_byGoodsGroup.GoodsId
                                    AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
/*                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                     ON ObjectLink_Goods_Measure.ObjectId = lfObject_Goods_byGoodsGroup.GoodsId
                                    AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = lfObject_Goods_byGoodsGroup.GoodsId
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()*/
           WHERE (ObjectLink_Goods_TradeMark.ChildObjectId = inTradeMarkId OR COALESCE (inTradeMarkId, 0) = 0)
       ;
    ELSE IF inTradeMarkId <> 0
         THEN
             -- устанавливается признак
             vbIsGoods:= TRUE;
             -- заполнение
             INSERT INTO _tmpGoods_report (GoodsId, TradeMarkId)
                SELECT ObjectLink_Goods_TradeMark.ObjectId AS GoodsId
                     , CASE WHEN inIsTradeMark = TRUE OR inIsGoods = TRUE THEN COALESCE (ObjectLink_Goods_TradeMark.ChildObjectId, 0) ELSE 0 END AS TradeMarkId
                FROM ObjectLink AS ObjectLink_Goods_TradeMark
                WHERE ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                  AND ObjectLink_Goods_TradeMark.ChildObjectId = inTradeMarkId
            ;
         ELSE
             -- устанавливается признак
             vbIsGoods:= FALSE;
             -- заполнение
             INSERT INTO _tmpGoods_report (GoodsId, TradeMarkId)
                SELECT ObjectLink_Goods_TradeMark.ObjectId AS GoodsId
                     , CASE WHEN inIsTradeMark = TRUE OR inIsGoods = TRUE THEN COALESCE (ObjectLink_Goods_TradeMark.ChildObjectId, 0) ELSE 0 END AS TradeMarkId
                FROM ObjectLink AS ObjectLink_Goods_TradeMark
                WHERE ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                  AND ObjectLink_Goods_TradeMark.ChildObjectId > 0
                  AND (inIsTradeMark = TRUE AND inIsGoods = FALSE)
            ;

         END IF;
    END IF;


    ANALYZE _tmpGoods_report;


    -- результат
       RETURN QUERY
       WITH tmp_Unit AS  (SELECT 8459 AS UnitId -- Склад Реализации
                         UNION 
                          SELECT UnitId FROM lfSelect_Object_Unit_byGroup (8460) AS lfSelect_Object_Unit_byGroup) -- Возвраты общие
          , tmp_Send AS  (SELECT CASE WHEN inIsPartner = TRUE AND tmp_Unit_To.UnitId IS NULL
                                           THEN MovementLinkObject_From.ObjectId
                                      WHEN inIsPartner = TRUE AND tmp_Unit_From.UnitId IS NULL
                                           THEN MovementLinkObject_To.ObjectId
                                      ELSE 0
                                 END AS FromId


                               , CASE WHEN inIsPartner = TRUE AND tmp_Unit_To.UnitId IS NULL
                                           THEN MovementLinkObject_To.ObjectId
                                      WHEN inIsPartner = TRUE AND tmp_Unit_From.UnitId IS NULL
                                           THEN MovementLinkObject_From.ObjectId
                                      ELSE 0
                                 END AS ToId

                               , MovementItem.ObjectId AS GoodsId
                               , CASE WHEN inIsGoodsKind = TRUE THEN MILinkObject_GoodsKind.ObjectId ELSE 0 END AS GoodsKindId

                               , SUM (CASE WHEN tmp_Unit_From.UnitId > 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) /*MovementItem.Amount*/ ELSE 0 END) AS Amount_Count
                               , SUM (CASE WHEN tmp_Unit_From.UnitId > 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) /*MovementItem.Amount*/ ELSE 0 END
                                    * CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                                THEN COALESCE (MIFloat_Price.ValueData, 0) / MIFloat_CountForPrice.ValueData
                                           ELSE COALESCE (MIFloat_Price.ValueData, 0)
                                      END * 1.2
                                     ) AS Amount_Summ

                               , SUM (CASE WHEN tmp_Unit_To.UnitId > 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) /*MovementItem.Amount*/ ELSE 0 END) AS Amount_CountRet
                               , SUM (CASE WHEN tmp_Unit_To.UnitId > 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) /*MovementItem.Amount*/ ELSE 0 END
                                    * CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                                THEN COALESCE (MIFloat_Price.ValueData, 0) / MIFloat_CountForPrice.ValueData
                                           ELSE COALESCE (MIFloat_Price.ValueData, 0)
                                      END * 1.2
                                     ) AS Amount_SummRet

                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                               LEFT JOIN tmp_Unit AS tmp_Unit_From ON tmp_Unit_From.UnitId = MovementLinkObject_From.ObjectId
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                               LEFT JOIN tmp_Unit AS tmp_Unit_To ON tmp_Unit_To.UnitId = MovementLinkObject_To.ObjectId

                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.isErased   = FALSE
                               LEFT JOIN _tmpGoods_report ON _tmpGoods_report.GoodsId = MovementItem.ObjectId

                               LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                           ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                          AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()

                               LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                           ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                          AND MIFloat_Price.DescId = zc_MIFloat_Price()
                               LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                           ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                          AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                          WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                            AND Movement.StatusId = zc_Enum_Status_Complete()
                            AND Movement.DescId = zc_Movement_SendOnPrice()
                            AND (_tmpGoods_report.GoodsId > 0 OR vbIsGoods = FALSE)
                            AND (tmp_Unit_From.UnitId > 0
                              OR tmp_Unit_To.UnitId > 0)
                            AND (inBranchId = zc_Branch_Basis() OR COALESCE (inBranchId, 0) = 0)
                          GROUP BY CASE WHEN inIsPartner = TRUE AND tmp_Unit_To.UnitId IS NULL
                                             THEN MovementLinkObject_From.ObjectId
                                        WHEN inIsPartner = TRUE AND tmp_Unit_From.UnitId IS NULL
                                             THEN MovementLinkObject_To.ObjectId
                                        ELSE 0
                                   END
                                 , CASE WHEN inIsPartner = TRUE AND tmp_Unit_To.UnitId IS NULL
                                             THEN MovementLinkObject_To.ObjectId
                                        WHEN inIsPartner = TRUE AND tmp_Unit_From.UnitId IS NULL
                                             THEN MovementLinkObject_From.ObjectId
                                        ELSE 0
                                   END
                                 , CASE WHEN inIsPartner = TRUE THEN MovementLinkObject_To.ObjectId ELSE 0 END
                                 , MovementItem.ObjectId
                                 , CASE WHEN inIsGoodsKind = TRUE THEN MILinkObject_GoodsKind.ObjectId ELSE 0 END
                         )


       SELECT  tmp.GoodsGroupName, tmp.GoodsGroupNameFull
             , tmp.GoodsCode, tmp.GoodsName, tmp.GoodsKindName, tmp.MeasureName
             , tmp.TradeMarkName, tmp.GoodsGroupAnalystName, tmp.GoodsTagName, tmp.GoodsGroupStatName
             , tmp.GoodsPlatformName
             , tmp.JuridicalGroupName
             , tmp.BranchCode, tmp.BranchName
             , tmp.JuridicalCode, tmp.JuridicalName, tmp.OKPO
             , tmp.RetailName, tmp.RetailReportName
             , tmp.AreaName, tmp.PartnerTagName
             , tmp.Address, tmp.RegionName, tmp.ProvinceName, tmp.CityKindName, tmp.CityName, tmp.ProvinceCityName, tmp.StreetKindName, tmp.StreetName
             , tmp.PartnerId, tmp.PartnerCode, tmp.PartnerName
             , tmp.ContractCode, tmp.ContractNumber, tmp.ContractTagName, tmp.ContractTagGroupName
             , tmp.PersonalName, tmp.UnitName_Personal, tmp.BranchName_Personal
             , tmp.PersonalTradeName, tmp.UnitName_PersonalTrade
             , tmp.InfoMoneyGroupName, tmp.InfoMoneyDestinationName, tmp.InfoMoneyCode, tmp.InfoMoneyName, tmp.InfoMoneyName_all
             , tmp.AccountName
             , tmp.Sale_Summ, tmp.Sale_Summ_10200, tmp.Sale_Summ_10300, tmp.Sale_SummCost, tmp.Sale_SummCost_10500, tmp.Sale_SummCost_40200
             , tmp.Sale_Amount_Weight , tmp.Sale_Amount_Sh, tmp.Sale_AmountPartner_Weight , tmp.Sale_AmountPartner_Sh
             , tmp.Return_Summ, tmp.Return_Summ_10300, tmp.Return_SummCost, tmp.Return_SummCost_40200
             , tmp.Return_Amount_Weight, tmp.Return_Amount_Sh, tmp.Return_AmountPartner_Weight, tmp.Return_AmountPartner_Sh
             , tmp.Sale_Amount_10500_Weight
             , tmp.Sale_Amount_40200_Weight
             , tmp.Return_Amount_40200_Weight
             , tmp.ReturnPercent
       FROM gpReport_GoodsMI_SaleReturnIn (inStartDate
                                         , inEndDate
                                         , inBranchId
                                         , inAreaId
                                         , inRetailId
                                         , inJuridicalId
                                         , inPaidKindId
                                         , inTradeMarkId
                                         , inGoodsGroupId
                                         , inInfoMoneyId
                                         , inIsPartner
                                         , inIsTradeMark
                                         , inIsGoods
                                         , inIsGoodsKind
                                         , inSession
                                          ) AS tmp
    UNION ALL

     SELECT Object_GoodsGroup.ValueData        AS GoodsGroupName
          , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
          , Object_Goods.ObjectCode            AS GoodsCode
          , Object_Goods.ValueData             AS GoodsName
          , Object_GoodsKind.ValueData         AS GoodsKindName
          , Object_Measure.ValueData           AS MeasureName
          , Object_TradeMark.ValueData         AS TradeMarkName
          , Object_GoodsGroupAnalyst.ValueData AS GoodsGroupAnalystName
          , Object_GoodsTag.ValueData          AS GoodsTagName
          , Object_GoodsGroupStat.ValueData    AS GoodsGroupStatName
          , Object_GoodsPlatform.ValueData     AS GoodsPlatformName

          , '' :: TVarChar AS JuridicalGroupName
          , Object_Branch.ObjectCode    AS BranchCode
          , Object_Branch.ValueData     AS BranchName

          , Object_Unit_Parent.ObjectCode    AS JuridicalCode
          , Object_Unit_Parent.ValueData     AS JuridicalName

          , '' :: TVarChar AS OKPO

          , '' :: TVarChar AS RetailName
          , '' :: TVarChar AS RetailReportName

          , Object_Area.ValueData :: TVarChar AS AreaName
          , '' :: TVarChar AS PartnerTagName
          , '' :: TVarChar AS Address
          , '' :: TVarChar AS RegionName
          , '' :: TVarChar AS ProvinceName
          , '' :: TVarChar AS CityKindName
          , '' :: TVarChar AS CityName
          , '' :: TVarChar AS ProvinceCityName
          , '' :: TVarChar AS StreetKindName
          , '' :: TVarChar AS StreetName

          , Object_Partner.Id            AS PartnerId
          , Object_Partner.ObjectCode    AS PartnerCode
          , Object_Partner.ValueData     AS PartnerName

          , 0 :: Integer   ContractCode
          , '' :: TVarChar AS ContractNumber
          , '' :: TVarChar ContractTagName
          , '' :: TVarChar ContractTagGroupName

          , '' :: TVarChar AS PersonalName
          , '' :: TVarChar AS UnitName_Personal
          , '' :: TVarChar AS BranchName_Personal

          , '' :: TVarChar AS PersonalTradeName
          , '' :: TVarChar AS UnitName_PersonalTrade

          , View_InfoMoney.InfoMoneyGroupName              AS InfoMoneyGroupName
          , View_InfoMoney.InfoMoneyDestinationName        AS InfoMoneyDestinationName
          , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
          , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName
          , View_InfoMoney.InfoMoneyName_all               AS InfoMoneyName_all

          , '' :: TVarChar AS AccountName

         , tmpOperationGroup.Amount_Summ          :: TFloat  AS Sale_Summ
         , 0    :: TFloat  AS Sale_Summ_10200
         , 0    :: TFloat  AS Sale_Summ_10300
         , 0      :: TFloat  AS Sale_SummCost
         , 0  :: TFloat  AS Sale_SummCost_10500
         , 0 :: TFloat  AS Sale_SummCost_40200

         , tmpOperationGroup.Amount_CountWeight :: TFloat  AS Sale_Amount_Weight
         , tmpOperationGroup.Amount_CountSh     :: TFloat  AS Sale_Amount_Sh

         , tmpOperationGroup.Amount_CountWeight :: TFloat AS Sale_AmountPartner_Weight
         , tmpOperationGroup.Amount_CountSh     :: TFloat AS Sale_AmountPartner_Sh

         , tmpOperationGroup.Amount_SummRet :: TFloat AS Return_Summ
         , 0 :: TFloat AS Return_Summ_10300
         , 0 :: TFloat AS Return_SummCost
         , 0 :: TFloat AS Return_SummCost_40200

         , tmpOperationGroup.Amount_CountRetWeight :: TFloat AS Return_Amount_Weight
         , tmpOperationGroup.Amount_CountRetSh :: TFloat AS Return_Amount_Sh

         , tmpOperationGroup.Amount_CountRetWeight :: TFloat AS Return_AmountPartner_Weight
         , tmpOperationGroup.Amount_CountRetSh :: TFloat AS Return_AmountPartner_Sh

         , 0 :: TFloat AS Sale_Amount_10500_Weight
         , 0 :: TFloat AS Sale_Amount_40200_Weight
         , 0 :: TFloat AS Return_Amount_40200_Weight

         , 0 :: TFloat AS ReturnPercent

     FROM (SELECT tmp_Send.FromId
                , tmp_Send.ToId
                , CASE WHEN inIsGoods = TRUE OR inIsTradeMark = TRUE THEN tmp_Send.GoodsId ELSE 0 END AS GoodsId
                , tmp_Send.GoodsKindId
                , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmp_Send.Amount_Count ELSE 0 END)                                AS Amount_CountSh
                , SUM (tmp_Send.Amount_Count * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Amount_CountWeight
                , SUM (tmp_Send.Amount_Summ) AS Amount_Summ

                , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmp_Send.Amount_CountRet ELSE 0 END)                                AS Amount_CountRetSh
                , SUM (tmp_Send.Amount_CountRet * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Amount_CountRetWeight
                , SUM (tmp_Send.Amount_SummRet) AS Amount_SummRet
           FROM tmp_Send
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = tmp_Send.GoodsId
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = tmp_Send.GoodsId
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
           GROUP BY tmp_Send.FromId
                  , tmp_Send.ToId
                  , CASE WHEN inIsGoods = TRUE OR inIsTradeMark = TRUE THEN tmp_Send.GoodsId ELSE 0 END
                  , tmp_Send.GoodsKindId
          ) AS tmpOperationGroup
          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupAnalyst
                               ON ObjectLink_Goods_GoodsGroupAnalyst.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
          LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_Goods_GoodsGroupAnalyst.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                               ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
          LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                               ON ObjectLink_Goods_GoodsTag.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
          LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupStat
                               ON ObjectLink_Goods_GoodsGroupStat.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroupStat.DescId = zc_ObjectLink_Goods_GoodsGroupStat()
          LEFT JOIN Object AS Object_GoodsGroupStat ON Object_GoodsGroupStat.Id = ObjectLink_Goods_GoodsGroupStat.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsPlatform
                               ON ObjectLink_Goods_GoodsPlatform.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsPlatform.DescId = zc_ObjectLink_Goods_GoodsPlatform()
          LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = ObjectLink_Goods_GoodsPlatform.ChildObjectId
            
          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                               ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpOperationGroup.ToId
          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = zc_Branch_Basis()

          LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                               ON ObjectLink_Unit_Parent.ObjectId = tmpOperationGroup.ToId
                              AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
          LEFT JOIN Object AS Object_Unit_Parent ON Object_Unit_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                               ON ObjectLink_Unit_Area.ObjectId = tmpOperationGroup.ToId
                              AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
          LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Unit_Area.ChildObjectId

         ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 22.03.15                                        * add inIsGoodsKind
 11.01.15                                        * all
 12.12.14                                        * all
 27.10.14                                        * add inIsPartner AND inIsGoods
 13.09.14                                        * add GoodsTagName and GroupStatName and BranchName and JuridicalGroupName
 11.07.14                                        * add RetailName and OKPO
 06.05.14                                        * add GoodsGroupNameFull
 28.03.14                                        * all
 06.02.14         *
*/

-- тест
-- SELECT * FROM gpReport_GoodsMI_SaleReturnInUnit (inStartDate:= '31.08.2015', inEndDate:= '31.08.2015', inBranchId:= 0, inAreaId:= 1, inRetailId:= 0, inJuridicalId:= 0, inPaidKindId:= zc_Enum_PaidKind_FirstForm(), inTradeMarkId:= 0, inGoodsGroupId:= 0, inInfoMoneyId:= zc_Enum_InfoMoney_30101(), inIsPartner:= TRUE, inIsTradeMark:= FALSE, inIsGoods:= FALSE, inIsGoodsKind:= FALSE, inSession:= zfCalc_UserAdmin());
