-- Function: gpReport_GoodsMI ()
--SELECT * FROM Object_Account_View WHERE AccountGroupId = zc_Enum_AccountGroup_20000()

DROP FUNCTION IF EXISTS gpReport_GoodsMI (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpReport_GoodsMI (
    IN inStartDate    TDateTime ,
    IN inEndDate      TDateTime ,
    IN inDescId       Integer   ,  --sale(продажа покупателю) = 5, returnin (возврат покупателя) = 6
    IN inGoodsGroupId Integer   ,
    IN inUnitGroupId  Integer   ,
    IN inUnitId       Integer   ,
    IN inPaidKindId   Integer   ,
    IN inJuridicalId  Integer   ,
    IN inInfoMoneyId  Integer   ,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar, MeasureName TVarChar
             , TradeMarkName TVarChar
             , Amount_Weight TFloat, Amount_Sh TFloat
             , AmountChangePercent_Weight TFloat, AmountChangePercent_Sh TFloat
             , AmountPartner_Weight TFloat, AmountPartner_Sh TFloat
             , Amount_10500_Weight TFloat, Amount_10500_Sh TFloat
             , Amount_40200_Weight TFloat, Amount_40200_Sh TFloat
             , SummPartner_calc TFloat
             , SummPartner TFloat, SummPartner_10200 TFloat, SummPartner_10300 TFloat
             , SummDiff TFloat
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             ) 
AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);
   
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpUnit (UnitId Integer) ON COMMIT DROP;
    
  
    -- Ограничения по товару
    IF inGoodsGroupId <> 0
    THEN
        INSERT INTO _tmpGoods (GoodsId)
           SELECT lfObject_Goods_byGoodsGroup.GoodsId
           FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE
        INSERT INTO _tmpGoods (GoodsId)
           SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods()
         UNION
           SELECT Object.Id FROM Object WHERE DescId = zc_Object_Fuel();
    END IF;

    

    -- группа подразделений или подразделение или место учета (МО, Авто)
    IF inUnitGroupId <> 0
    THEN
        INSERT INTO _tmpUnit (UnitId)
           SELECT lfSelect_Object_Unit_byGroup.UnitId AS UnitId
           FROM lfSelect_Object_Unit_byGroup (inUnitGroupId) AS lfSelect_Object_Unit_byGroup;
    ELSE
        IF inUnitId <> 0
        THEN
            INSERT INTO _tmpUnit (UnitId)
               SELECT Object.Id AS UnitId
               FROM Object
               WHERE Object.Id = inUnitId;
        ELSE
           WITH tmpBranch AS (SELECT TRUE AS Value WHERE 1 = 0 AND NOT EXISTS (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0))

            INSERT INTO _tmpUnit (UnitId)
               SELECT Id FROM Object WHERE DescId = zc_Object_Unit()
              UNION ALL
               SELECT Id FROM Object  WHERE DescId = zc_Object_Member()
              UNION ALL
               SELECT Id FROM Object  WHERE DescId = zc_Object_Car();
              
        END IF;
    END IF;


   -- Результат
    RETURN QUERY
    
       SELECT Object_GoodsGroup.ValueData            AS GoodsGroupName 
         , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
         , Object_Goods.ObjectCode                AS GoodsCode
         , Object_Goods.ValueData                 AS GoodsName
         , Object_GoodsKind.ValueData             AS GoodsKindName
         , Object_Measure.ValueData               AS MeasureName
         , Object_TradeMark.ValueData             AS TradeMarkName

         , (tmpOperationGroup.Amount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS Amount_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.Amount ELSE 0 END) :: TFloat                                AS Amount_Sh

         , (tmpOperationGroup.AmountChangePercent * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS AmountChangePercent_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.AmountChangePercent ELSE 0 END) :: TFloat                                AS AmountChangePercent_Sh
         
         , (tmpOperationGroup.AmountPartner * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS AmountPartner_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.AmountPartner ELSE 0 END) :: TFloat                                AS AmountPartner_Sh

         , (tmpOperationGroup.Amount_10500 * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS Amount_10500_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.Amount_10500 ELSE 0 END) :: TFloat                                AS Amount_10500_Sh
         , (tmpOperationGroup.Amount_40200 * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS Amount_40200_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.Amount_40200 ELSE 0 END) :: TFloat                                AS Amount_40200_Sh

         , tmpOperationGroup.SummPartner_calc :: TFloat   AS SummPartner_calc
         , tmpOperationGroup.SummPartner :: TFloat        AS SummPartner
         , tmpOperationGroup.SummPartner_10200 :: TFloat  AS SummPartner_10200
         , tmpOperationGroup.SummPartner_10300 :: TFloat  AS SummPartner_10300
         , (tmpOperationGroup.SummPartner - tmpOperationGroup.SummPartner_calc) :: TFloat  AS SummDiff

         , View_InfoMoney.InfoMoneyGroupName              AS InfoMoneyGroupName
         , View_InfoMoney.InfoMoneyDestinationName        AS InfoMoneyDestinationName
         , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
         , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName

     FROM (SELECT tmpContainer.GoodsId
               -- , COALESCE (ContainerLO_Juridical.ObjectId,  COALESCE (ContainerLO_Member.ObjectId, 0 )) AS JuridicalId
              --  , COALESCE (ContainerLO_Partner.ObjectId, COALESCE (ContainerLO_Member.ObjectId, 0)) AS PartnerId 
               -- , CASE WHEN ContainerLO_Member.ObjectId > 0 THEN zc_Enum_PaidKind_SecondForm() ELSE COALESCE (ContainerLO_PaidKind.ObjectId,0) END AS PaidKindId
                
                , ( COALESCE (ContainerLO_GoodsKind.ObjectId,0) )     AS GoodsKindId
                , ContainerLinkObject_InfoMoney.ObjectId              AS InfoMoneyId
                , SUM (tmpContainer.SummPartner) :: TFloat            AS SummPartner 
                , SUM (tmpContainer.SummPartner_10200) :: TFloat      AS SummPartner_10200
                , SUM (tmpContainer.SummPartner_10300)  :: TFloat     AS SummPartner_10300


                , SUM (tmpContainer.Amount) :: TFloat                 AS Amount 
                , SUM (tmpContainer.AmountChangePercent) :: TFloat    AS AmountChangePercent
                , SUM (tmpContainer.AmountPartner)  :: TFloat         AS AmountPartner

                , SUM (tmpContainer.Amount_10500) :: TFloat           AS Amount_10500 
                , SUM (tmpContainer.Amount_40200) :: TFloat           AS Amount_40200
                , SUM (tmpContainer.SummPartner_calc)  :: TFloat      AS SummPartner_calc

           FROM (SELECT MIContainer.ContainerId AS ContainerId
                      , MIContainer.ObjectId_analyzer AS GoodsId 
                      , MIContainer.ContainerId_analyzer      
                      , SUM ( CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() 
                                   THEN (CASE WHEN (inDescId = zc_Movement_Sale())
                                           --    OR (inDescId = zc_Movement_ReturnIn())
                                             THEN -1 
                                             ELSE 1
                                        END) * COALESCE (MIContainer.Amount,0) 
                                   ELSE 0 END ) AS SummPartner
                      , SUM ( CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() AND COALESCE(MIContainer.AccountId,0) in (zc_Enum_AnalyzerId_SaleSumm_10200())
                                   THEN ( CASE WHEN inDescId = zc_Movement_Sale()
                                       --   OR inDescId = zc_Movement_ReturnIn()
                                        THEN -1 
                                        ELSE 1
                                        END) * COALESCE (MIContainer.Amount,0) 
                                   ELSE 0 END ) AS SummPartner_10200
             
                     , SUM ( CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() AND COALESCE(MIContainer.AccountId,0) in (zc_Enum_AnalyzerId_SaleSumm_10300(),zc_Enum_AnalyzerId_ReturnInSumm_10300())
                                   THEN CASE WHEN (inDescId = zc_Movement_Sale())
                                          --OR (inDescId = zc_Movement_ReturnIn() )
                                        THEN -1 
                                        ELSE 1
                                        END * COALESCE (MIContainer.Amount,0) 
                                   ELSE 0 END ) AS SummPartner_10300

                     , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN MIContainer.Amount * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END ELSE 0 END) AS Amount
                     , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SaleCount_10400(), zc_Enum_AnalyzerId_ReturnInCount_10800(), zc_Enum_AnalyzerId_SaleCount_40200(), zc_Enum_AnalyzerId_ReturnInCount_40200()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END) AS AmountChangePercent
                     , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SaleCount_10400(), zc_Enum_AnalyzerId_ReturnInCount_10800())                                                                                 THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END) AS AmountPartner
                            , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SaleCount_10500())                                                                                                                           THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END) AS Amount_10500
                            , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SaleCount_40200(), zc_Enum_AnalyzerId_ReturnInCount_40200())                                                                                 THEN MIContainer.Amount ELSE 0 END)                                                              AS Amount_40200
                            , 0 AS SummPartner_calc

                 FROM MovementItemContainer AS MIContainer 
                       JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_analyzer
                       JOIN _tmpUnit ON _tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                 WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate  
                   AND inDescId = inDescId --in (zc_Movement_Sale(), zc_Movement_ReturnIn())
                   AND MIContainer.isActive =  CASE WHEN inDescId = zc_Movement_Sale() THEN False ELSE True END
              group by  MIContainer.ContainerId
                      , MIContainer.ObjectId_analyzer
                      , MIContainer.ContainerId_analyzer       
                      
                  ) as tmpContainer
     
                      LEFT JOIN ContainerLinkObject AS ContainerLO_Juridical
                                               ON ContainerLO_Juridical.ContainerId = tmpContainer.ContainerId_analyzer
                                              AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                                                                   
                      LEFT JOIN ContainerLinkObject AS ContainerLO_GoodsKind
                                                    ON ContainerLO_GoodsKind.ContainerId =  tmpContainer.ContainerId
                                                   AND ContainerLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                      LEFT JOIN ContainerLinkObject AS ContainerLO_PaidKind
                                               ON ContainerLO_PaidKind.ContainerId =  tmpContainer.ContainerId_analyzer
                                              AND ContainerLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                      LEFT JOIN ContainerLinkObject AS ContainerLO_Partner
                                               ON ContainerLO_Partner.ContainerId =  tmpContainer.ContainerId_analyzer
                                              AND ContainerLO_Partner.DescId = zc_ContainerLinkObject_Partner()  
                      LEFT JOIN ContainerLinkObject AS ContainerLO_Member
                                               ON ContainerLO_Member.ContainerId =  tmpContainer.ContainerId_analyzer
                                              AND ContainerLO_Member.DescId = zc_ContainerLinkObject_Member()       
                      INNER JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                                 ON ContainerLinkObject_InfoMoney.ContainerId = tmpContainer.ContainerId_analyzer
                                                                AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                                AND (ContainerLinkObject_InfoMoney.ObjectId = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)  
                  
                      WHERE (ContainerLO_Juridical.ObjectId = inJuridicalId OR inJuridicalId=0)
                        AND (ContainerLO_PaidKind.ObjectId = inPaidKindId OR inPaidKindId=0 OR (ContainerLO_Member.ObjectId > 0 AND inPaidKindId = zc_Enum_PaidKind_SecondForm()))

                      GROUP BY tmpContainer.GoodsId
                           --  , CASE WHEN ContainerLO_Member.ObjectId > 0 THEN zc_Enum_PaidKind_SecondForm() ELSE COALESCE (ContainerLO_PaidKind.ObjectId,0) END
                             , COALESCE (ContainerLO_GoodsKind.ObjectId,0) 
                           --  , COALESCE (ContainerLO_Partner.ObjectId, COALESCE (ContainerLO_Member.ObjectId, 0))
                            -- , COALESCE (ContainerLO_Juridical.ObjectId,  COALESCE (ContainerLO_Member.ObjectId, 0 ))
                             , ContainerLinkObject_InfoMoney.ObjectId
                    ) AS tmpOperationGroup
          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId
          LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                               ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
          LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()
          LEFT JOIN ObjectFloat AS ObjectFloat_Weight	
                                ON ObjectFloat_Weight.ObjectId = Object_Goods.Id 
                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpOperationGroup.InfoMoneyId
          
  ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.07.15         *                
 15.12.14                                        * all
 13.05.14                                        * all
 16.04.14         add inUnitId
 13.04.14                                        * add zc_MovementFloat_ChangePercent
 08.04.14                                        * all
 05.04.14         * add SummPartner_calc. AmountChangePercent
 04.02.14         * 
 01.02.14                                        * All
 22.01.14         *
*/

-- тест
-- SELECT * FROM gpReport_GoodsMI (inStartDate:= '01.01.2013', inEndDate:= '31.12.2013',  inDescId:= 1, inGoodsGroupId:= 0, inUnitGroupId:=0, inUnitId:= 0, inPaidKindId:=0, inJuridicalId:=0, inSession:= zfCalc_UserAdmin());
