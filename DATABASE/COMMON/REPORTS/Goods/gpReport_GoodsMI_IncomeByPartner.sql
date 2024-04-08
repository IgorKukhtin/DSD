-- Function: gpReport_GoodsMI_IncomeByPartner ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_Income (TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_Income (TDateTime, TDateTime, Integer, Integer, Integer, Integer,Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_Income (TDateTime, TDateTime, Integer, Integer, Integer, Integer,Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_IncomeByPartner (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_IncomeByPartner (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_GoodsMI_IncomeByPartner (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_IncomeByPartner (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_IncomeByPartner (
    IN inStartDate    TDateTime ,
    IN inEndDate      TDateTime ,
    IN inDescId       Integer   ,
    IN inJuridicalId  Integer   ,
    IN inPaidKindId   Integer   ,
    IN inInfoMoneyId  Integer   , -- Управленческая статья
    IN inUnitGroupId  Integer   ,
    IN inUnitId       Integer   ,
    IN inGoodsGroupId Integer   ,
    IN inisDate       Boolean   , -- по датам (показ дату док + дату поставщика
    IN inisMovement   Boolean   , -- показато № док
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar 
             , Name_Scale TVarChar
             , GoodsKindName TVarChar, PartionGoods TVarChar, MeasureName TVarChar
             , TradeMarkName TVarChar
             , LocationId Integer, LocationCode Integer, LocationName TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , FuelKindName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , Amount TFloat, Amount_Weight TFloat, Amount_Sh TFloat, Price TFloat
             , AmountPartner TFloat, AmountPartner_Weight TFloat , AmountPartner_Sh TFloat, PricePartner TFloat
             , AmountDiff_Weight TFloat, AmountDiff_Sh TFloat
             , Summ TFloat, Summ_ProfitLoss TFloat
             , OperDate        TDateTime
             , OperDatePartner TDateTime
             , Invnumber       TVarChar
             )
AS
$BODY$
 DECLARE vbUserId Integer;
 DECLARE vbIsGroup Boolean;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


      vbIsGroup:= (inSession = '');

     /*IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpgoods')
     THEN
         DELETE FROM _tmpGoods;
         DELETE FROM _tmpUnit;
     ELSE
         -- таблица -
         CREATE TEMP TABLE _tmpGoods (GoodsId Integer, InfoMoneyId Integer, TradeMarkId Integer, MeasureId Integer, Weight TFloat) ON COMMIT DROP;
         CREATE TEMP TABLE _tmpUnit (UnitId Integer, UnitId_by Integer, isActive Boolean) ON COMMIT DROP;
     END IF;*/


    -- Результат
    RETURN QUERY

     WITH -- Ограничения по товару
          _tmpGoods AS -- (GoodsId, MeasureId, Weight)
          (SELECT lfSelect.GoodsId, ObjectLink_Goods_Measure.ChildObjectId AS MeasureId, ObjectFloat_Weight.ValueData AS Weight
           FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = lfSelect.GoodsId
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = lfSelect.GoodsId
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
           WHERE inGoodsGroupId <> 0
          UNION
           SELECT Object.Id, ObjectLink_Goods_Measure.ChildObjectId AS MeasureId, ObjectFloat_Weight.ValueData AS Weight
           FROM Object
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object.Id
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = Object.Id
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
           WHERE Object.DescId = zc_Object_Goods()
             AND COALESCE (inGoodsGroupId, 0) = 0
          UNION
           SELECT Object.Id, 0 AS MeasureId, 0 AS Weight FROM Object
           WHERE Object.DescId = zc_Object_Fuel()
             AND COALESCE (inGoodsGroupId, 0) = 0
          )


    , tmpBranch AS (SELECT TRUE AS Value WHERE 1 = 0 AND NOT EXISTS (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0))
    , tmpUnit AS (SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (inUnitGroupId) AS lfSelect
                  WHERE inUnitGroupId <> 0 AND COALESCE (inUnitId, 0) = 0
                 )
    , _tmpUnit AS
          (-- группа подразделений
           SELECT tmpUnit.UnitId FROM tmpUnit
          UNION
           SELECT ObjectLink_Partner_Unit.ObjectId AS UnitId
           FROM tmpUnit
               INNER JOIN ObjectLink AS ObjectLink_Partner_Unit
                                     ON ObjectLink_Partner_Unit.ChildObjectId = tmpUnit.UnitId
                                    AND ObjectLink_Partner_Unit.DescId        = zc_ObjectLink_Partner_Unit()

          UNION
           -- Подразделение
           SELECT Object.Id AS UnitId
           FROM Object
           WHERE Object.Id = inUnitId
             AND inUnitId  > 0
          UNION
           SELECT ObjectLink_Partner_Unit.ObjectId AS UnitId
           FROM ObjectLink AS ObjectLink_Partner_Unit
           WHERE ObjectLink_Partner_Unit.ChildObjectId = inUnitId
             AND ObjectLink_Partner_Unit.DescId = zc_ObjectLink_Partner_Unit()
             AND inUnitId > 0

           -- или место учета (МО, Авто)
            /*UNION
               SELECT Object.Id FROM Object INNER JOIN tmpBranch ON tmpBranch.Value = TRUE WHERE DescId = zc_Object_Unit()
              UNION
               SELECT Object.Id FROM Object INNER JOIN tmpBranch ON tmpBranch.Value = TRUE WHERE DescId = zc_Object_Member()
              UNION
               SELECT Object.Id FROM Object INNER JOIN tmpBranch ON tmpBranch.Value = TRUE WHERE DescId = zc_Object_Car();
            */
              -- UNION
              --  SELECT Id FROM Object WHERE DescId = zc_Object_Unit()
              UNION
               SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Member() AND COALESCE (inUnitGroupId, 0) = 0 AND COALESCE (inUnitId, 0) = 0
              UNION ALL
               SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Car() AND COALESCE (inUnitGroupId, 0) = 0 AND COALESCE (inUnitId, 0) = 0
              UNION ALL
               SELECT ObjectLink_Partner_Unit.ObjectId AS UnitId
               FROM ObjectLink AS ObjectLink_Partner_Unit
               WHERE ObjectLink_Partner_Unit.DescId = zc_ObjectLink_Partner_Unit()
                 AND COALESCE (inUnitGroupId, 0) = 0
                 AND COALESCE (inUnitId, 0)      = 0
          )
    -- Результат
    SELECT Object_GoodsGroup.Id        AS GoodsGroupId
         , Object_GoodsGroup.ValueData AS GoodsGroupName
         , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
         , Object_Goods.id             AS GoodsId
         , Object_Goods.ObjectCode     AS GoodsCode
         , Object_Goods.ValueData      AS GoodsName
         , COALESCE (zfCalc_Text_replace (ObjectString_Goods_Scale.ValueData, CHR (39), '`' ), '') :: TVarChar AS Name_Scale
         , Object_GoodsKind.ValueData  AS GoodsKindName
         , Object_PartionGoods.ValueData  AS PartionGoods
         , Object_Measure.ValueData    AS MeasureName
         , Object_TradeMark.ValueData  AS TradeMarkName

         , Object_Location.Id         AS LocationId
         , Object_Location.ObjectCode AS LocationCode
         , Object_Location.ValueData  AS LocationName

         , Object_Juridical.ObjectCode AS JuridicalCode
         , Object_Juridical.ValueData  AS JuridicalName

         , Object_Partner.Id           AS PartnerId
         , Object_Partner.ObjectCode   AS PartnerCode
         , Object_Partner.ValueData    AS PartnerName

         , Object_PaidKind.Id          AS PaidKindId
         , Object_PaidKind.ValueData   AS PaidKindName
         , Object_FuelKind.ValueData   AS FuelKindName

          , View_InfoMoney.InfoMoneyGroupName              AS InfoMoneyGroupName
          , View_InfoMoney.InfoMoneyDestinationName        AS InfoMoneyDestinationName
          , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
          , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName
          , View_InfoMoney.InfoMoneyName_all               AS InfoMoneyName_all

         , tmpOperationGroup.Amount        :: TFloat AS Amount
         , tmpOperationGroup.Amount_Weight :: TFloat AS Amount_Weight
         , tmpOperationGroup.Amount_sh     :: TFloat AS Amount_Sh
         , CASE WHEN tmpOperationGroup.Amount <> 0 THEN (tmpOperationGroup.Summ + tmpOperationGroup.Summ_ProfitLoss) / tmpOperationGroup.Amount ELSE 0 END :: TFloat AS Price

         , tmpOperationGroup.AmountPartner        :: TFloat AS AmountPartner
         , tmpOperationGroup.AmountPartner_Weight :: TFloat AS AmountPartner_Weight
         , tmpOperationGroup.AmountPartner_sh     :: TFloat AS AmountPartner_Sh
         , CASE WHEN tmpOperationGroup.AmountPartner <> 0 THEN tmpOperationGroup.Summ / tmpOperationGroup.AmountPartner ELSE 0 END :: TFloat AS PricePartner

         , (tmpOperationGroup.Amount_Weight - tmpOperationGroup.AmountPartner_Weight) :: TFloat AS AmountDiff_Weight
         , (tmpOperationGroup.Amount_sh     - tmpOperationGroup.AmountPartner_sh)     :: TFloat AS AmountDiff_Sh

         , tmpOperationGroup.Summ            :: TFloat AS Summ
         , tmpOperationGroup.Summ_ProfitLoss :: TFloat AS Summ_ProfitLoss

         , tmpOperationGroup.OperDate        ::TDateTime AS OperDate
         , tmpOperationGroup.OperDatePartner ::TDateTime AS OperDatePartner
         , tmpOperationGroup.Invnumber       ::TVarChar  AS Invnumber

     FROM (SELECT CASE WHEN vbIsGroup = TRUE THEN 0 ELSE tmpContainer.GoodsId END AS GoodsId
                , tmpContainer.LocationId
                , COALESCE (ContainerLO_Juridical.ObjectId,  COALESCE (ContainerLO_Member.ObjectId, 0 )) AS JuridicalId
                -- , COALESCE (ContainerLO_Partner.ObjectId, COALESCE (ContainerLO_Member.ObjectId, 0))     AS PartnerId
                , tmpContainer.PartnerId
                , CASE WHEN ContainerLO_Member.ObjectId > 0 THEN zc_Enum_PaidKind_SecondForm() ELSE COALESCE (ContainerLO_PaidKind.ObjectId,0) END AS PaidKindId
                , COALESCE (ContainerLO_InfoMoney.ObjectId, 0) AS InfoMoneyId
                , 0/*( COALESCE (ContainerLO_FuelKind.ObjectId,0) )*/ AS FuelKindId
                , tmpContainer.GoodsKindId                            AS GoodsKindId
                , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE COALESCE (CLO_PartionGoods.ObjectId, 0) END AS PartionGoodsId
                
                , CASE WHEN inisDate = TRUE THEN Movement.OperDate ELSE NULL END      AS OperDate
                , MovementDate_OperDatePartner.ValueData                              AS OperDatePartner
                , CASE WHEN inisMovement = TRUE THEN Movement.Invnumber ELSE NULL END AS Invnumber

                , SUM (tmpContainer.Amount)                           AS Amount
                , SUM (tmpContainer.AmountPartner)                    AS AmountPartner
                , SUM (tmpContainer.Amount        * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END) AS Amount_Weight
                , SUM (tmpContainer.AmountPartner * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END) AS AmountPartner_Weight
                , SUM (CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN tmpContainer.Amount        ELSE 0 END) AS Amount_Sh
                , SUM (CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN tmpContainer.AmountPartner ELSE 0 END) AS AmountPartner_Sh
                , SUM (tmpContainer.Summ + tmpContainer.Summ_ProfitLoss) AS Summ
                , SUM (tmpContainer.Summ_ProfitLoss + tmpContainer.Summ_ProfitLoss_partner) AS Summ_ProfitLoss

           FROM (SELECT MIContainer.ContainerId                        AS ContainerId
                      , MIContainer.ObjectId_analyzer                  AS GoodsId
                      , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE COALESCE (MIContainer.ObjectIntId_Analyzer, 0) END AS GoodsKindId
                      , MIContainer.ContainerId_analyzer               AS ContainerId_analyzer
                      , MIContainer.ObjectExtId_Analyzer               AS PartnerId
                      , MIContainer.WhereObjectId_analyzer             AS LocationId
                      , CASE WHEN inisDate = TRUE OR inisMovement = TRUE THEN MIContainer.MovementId ELSE 0 END AS MovementId
                      , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.MovementDescId = zc_Movement_Income() AND MIContainer.isActive = TRUE
                                       THEN MIContainer.Amount
                                  WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.MovementDescId = zc_Movement_ReturnOut() AND MIContainer.isActive = FALSE
                                       THEN -1 * MIContainer.Amount
                                  ELSE 0
                             END) AS Amount
                      , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.MovementDescId = zc_Movement_Income() AND MIContainer.isActive = TRUE
                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_Count_40200()
                                       THEN MIContainer.Amount
                                  WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.MovementDescId = zc_Movement_ReturnOut() AND MIContainer.isActive = FALSE
                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_Count_40200()
                                       THEN -1 * MIContainer.Amount
                                  ELSE 0
                             END) AS AmountPartner

                      , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.MovementDescId = zc_Movement_Income() AND MIContainer.isActive = TRUE
                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_ProfitLoss()
                                       THEN MIContainer.Amount
                                  WHEN MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.MovementDescId = zc_Movement_ReturnOut() AND MIContainer.isActive = FALSE
                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_ProfitLoss()
                                       THEN -1 * MIContainer.Amount
                                  ELSE 0
                             END) AS Summ
                       , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()
                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ProfitLoss()
                                   AND ((MIContainer.MovementDescId = zc_Movement_ReturnOut() AND MIContainer.isActive = FALSE)
                                     OR (MIContainer.MovementDescId = zc_Movement_Income() AND MIContainer.isActive = TRUE))
                                       THEN 1 * MIContainer.Amount
                                  ELSE 0
                             END) AS Summ_ProfitLoss_partner
                      , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()
                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ProfitLoss()
                                   AND MIContainer.MovementDescId = zc_Movement_ReturnOut()
                                   AND MIContainer.isActive = TRUE and 1=0  -- задваивает цену 
                                       THEN 1 * MIContainer.Amount
                                  ELSE 0
                             END) AS Summ_ProfitLoss

                 FROM MovementItemContainer AS MIContainer
                      INNER JOIN _tmpUnit ON _tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                 WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                   AND MIContainer.MovementDescId = inDescId
                   -- AND MIContainer.isActive = CASE WHEN inDescId = zc_Movement_Income() THEN TRUE ELSE FALSE END
                   AND COALESCE (MIContainer.AccountId, 0) <> zc_Enum_Account_100301() -- прибыль текущего периода
                   AND COALESCE (MIContainer.AccountId, 0) <> zc_Enum_Account_110101()-- товар в пути
                 GROUP BY MIContainer.ContainerId
                        , MIContainer.ObjectId_analyzer
                        , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE COALESCE (MIContainer.ObjectIntId_Analyzer, 0) END
                        , MIContainer.ContainerId_analyzer
                        , MIContainer.WhereObjectId_analyzer
                        , MIContainer.ObjectExtId_Analyzer
                        , CASE WHEN inisDate = TRUE OR inisMovement = TRUE THEN MIContainer.MovementId ELSE 0 END
                ) AS tmpContainer
                      INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpContainer.GoodsId

       /*               LEFT JOIN ContainerLinkObject AS ContainerLO_FuelKind
                                                    ON ContainerLO_FuelKind.ContainerId = tmpContainer.ContainerId
                                                   AND ContainerLO_FuelKind.DescId = zc_ContainerLinkObject_Goods()*/

                      LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                    ON CLO_PartionGoods.ContainerId = tmpContainer.ContainerId
                                                   AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()

                      LEFT JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                    ON ContainerLO_Juridical.ContainerId = tmpContainer.ContainerId_analyzer
                                                   AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                      LEFT JOIN ContainerLinkObject AS ContainerLO_InfoMoney
                                                    ON ContainerLO_InfoMoney.ContainerId = tmpContainer.ContainerId_analyzer
                                                   AND ContainerLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()

                      LEFT JOIN ContainerLinkObject AS ContainerLO_PaidKind
                                                    ON ContainerLO_PaidKind.ContainerId =  tmpContainer.ContainerId_analyzer
                                                   AND ContainerLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                      /*LEFT JOIN ContainerLinkObject AS ContainerLO_Partner
                                                    ON ContainerLO_Partner.ContainerId =  tmpContainer.ContainerId_analyzer
                                                   AND ContainerLO_Partner.DescId = zc_ContainerLinkObject_Partner()*/
                      LEFT JOIN ContainerLinkObject AS ContainerLO_Member
                                                    ON ContainerLO_Member.ContainerId =  tmpContainer.ContainerId_analyzer
                                                   AND ContainerLO_Member.DescId = zc_ContainerLinkObject_Member()

                      LEFT JOIN Movement ON Movement.Id = tmpContainer.MovementId
                      LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                             ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                            AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                            AND inisDate = TRUE

                      WHERE (ContainerLO_Juridical.ObjectId = inJuridicalId OR inJuridicalId=0)
                        AND (ContainerLO_PaidKind.ObjectId = inPaidKindId OR inPaidKindId=0 OR (ContainerLO_Member.ObjectId > 0 AND inPaidKindId = zc_Enum_PaidKind_SecondForm()))
                        AND (ContainerLO_InfoMoney.ObjectId = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)

                      GROUP BY CASE WHEN vbIsGroup = TRUE THEN 0 ELSE tmpContainer.GoodsId END
                             , tmpContainer.GoodsKindId
                             , tmpContainer.LocationId
                             , CASE WHEN ContainerLO_Member.ObjectId > 0 THEN zc_Enum_PaidKind_SecondForm() ELSE COALESCE (ContainerLO_PaidKind.ObjectId,0) END
                             --  , COALESCE (ContainerLO_FuelKind.ObjectId, 0)
                             , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE COALESCE (CLO_PartionGoods.ObjectId, 0) END
                             -- , COALESCE (ContainerLO_Partner.ObjectId, COALESCE (ContainerLO_Member.ObjectId, 0))
                             , tmpContainer.PartnerId
                             , COALESCE (ContainerLO_Juridical.ObjectId,  COALESCE (ContainerLO_Member.ObjectId, 0 ))
                             , COALESCE (ContainerLO_InfoMoney.ObjectId, 0)

                             , CASE WHEN inisDate = TRUE THEN Movement.OperDate ELSE NULL END
                             , MovementDate_OperDatePartner.ValueData
                             , CASE WHEN inisMovement = TRUE THEN Movement.Invnumber ELSE NULL END
          ) AS tmpOperationGroup

          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId
          LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpOperationGroup.PartionGoodsId

          LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpOperationGroup.PaidKindId

          LEFT JOIN Object AS Object_FuelKind ON Object_FuelKind.Id = tmpOperationGroup.FuelKindId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                               ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
          LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN Object AS Object_Location ON Object_Location.Id = tmpOperationGroup.LocationId

          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpOperationGroup.PartnerId

          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpOperationGroup.JuridicalId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectString AS ObjectString_Goods_Scale
                                 ON ObjectString_Goods_Scale.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_Scale.DescId = zc_ObjectString_Goods_Scale()

          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpOperationGroup.InfoMoneyId
     WHERE 0 <> tmpOperationGroup.Amount
        OR 0 <> tmpOperationGroup.AmountPartner
        OR 0 <> tmpOperationGroup.Summ
        OR 0 <> tmpOperationGroup.Summ_ProfitLoss
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.08.15                                        * all
 11.07.15         * add inUnitGroupId, inUnitId, inPaidKindId
 08.02.14         *
*/

-- тест
-- SELECT * FROM gpReport_GoodsMI_IncomeByPartner (inStartDate:= '01.11.2017', inEndDate:= '01.11.2017', inDescId:= zc_Movement_Income(), inJuridicalId:=0, inPaidKindId:=0, inInfoMoneyId:=0, inUnitGroupId:=0, inUnitId:= 0, inGoodsGroupId:= 0, inisDate := FALSE, inisMovement := FALSE, inSession:= zfCalc_UserAdmin());
