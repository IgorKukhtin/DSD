-- Function: gpReport_GoodsMI_IncomeByPartner ()
--SELECT * FROM Object_Account_View WHERE AccountGroupId = zc_Enum_AccountGroup_20000()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_IncomeByPartner (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_IncomeByPartner (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpReport_GoodsMI_IncomeByPartner (
    IN inStartDate    TDateTime ,
    IN inEndDate      TDateTime ,
    IN inDescId       Integer   ,  --sale(продажа покупателю) = 5, returnin (возврат покупателя) = 6
    IN inJuridicalId  Integer   ,
    IN inGoodsGroupId Integer   ,
    IN inUnitGroupId  Integer   ,
    IN inUnitId       Integer   ,
    IN inPaidKindId   Integer   ,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsGroupName TVarChar
             , GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName TVarChar
             , TradeMarkName TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , PaidKindName TVarChar
             , FuelKindName TVarChar
             , Amount_Weight TFloat, Amount_Sh TFloat
             , AmountPartner_Weight TFloat , AmountPartner_Sh TFloat
             , Summ TFloat
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
          /*      
            INSERT INTO _tmpUnit (UnitId)
               SELECT Id FROM Object INNER JOIN tmpBranch ON tmpBranch.Value = TRUE WHERE DescId = zc_Object_Unit()
              UNION ALL
               SELECT Id FROM Object INNER JOIN tmpBranch ON tmpBranch.Value = TRUE WHERE DescId = zc_Object_Member()
              UNION ALL
               SELECT Id FROM Object INNER JOIN tmpBranch ON tmpBranch.Value = TRUE WHERE DescId = zc_Object_Car();
  */
            INSERT INTO _tmpUnit (UnitId)
                                                   /*   SELECT Object.Id AS UnitId FROM Object  WHERE DescId = zc_Object_Unit();*/
               SELECT Id FROM Object WHERE DescId = zc_Object_Unit()
              UNION ALL
               SELECT Id FROM Object  WHERE DescId = zc_Object_Member()
              UNION ALL
               SELECT Id FROM Object  WHERE DescId = zc_Object_Car();
              
        END IF;
    END IF;


   -- Результат
    RETURN QUERY
    
    SELECT Object_GoodsGroup.ValueData AS GoodsGroupName
         , Object_Goods.ObjectCode     AS GoodsCode
         , Object_Goods.ValueData      AS GoodsName
         , Object_GoodsKind.ValueData  AS GoodsKindName
         , Object_TradeMark.ValueData  AS TradeMarkName

         , Object_Juridical.ObjectCode AS JuridicalCode
         , Object_Juridical.ValueData  AS JuridicalName

         , Object_Partner.Id           AS PartnerId
         , Object_Partner.ObjectCode   AS PartnerCode
         , Object_Partner.ValueData    AS PartnerName

         , Object_PaidKind.ValueData   AS PaidKindName
         , Object_FuelKind.ValueData   AS FuelKindName

         , (tmpOperationGroup.Amount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS Amount_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.Amount ELSE 0 END) :: TFloat AS Amount_Sh

         , CAST ((tmpOperationGroup.AmountPartner * (case when Object_Measure.Id = zc_Measure_Sh() then ObjectFloat_Weight.ValueData else 1 end )) AS TFloat) AS AmountPartner_Weight
         , CAST ((case when Object_Measure.Id = zc_Measure_Sh() then tmpOperationGroup.AmountPartner else 0 end) AS TFloat) AS AmountPartner_Sh

         , tmpOperationGroup.Summ :: TFloat AS Summ
     FROM (SELECT tmpContainer.GoodsId
                , ( COALESCE (ContainerLO_Juridical.ObjectId,0) ) AS JuridicalId
                , ( COALESCE (ContainerLO_Partner.ObjectId,0) ) AS PartnerId 
                , ( COALESCE (ContainerLO_PaidKind.ObjectId,0) ) AS PaidKindId
                , 0/*( COALESCE (ContainerLO_FuelKind.ObjectId,0) )*/ AS FuelKindId
                , ( COALESCE (ContainerLO_GoodsKind.ObjectId,0) ) AS GoodsKindId
                , ABS (SUM (tmpContainer.Amount)):: TFloat          AS Amount 
                , ABS (SUM (tmpContainer.AmountPartner)):: TFloat   AS AmountPartner
                , ABS (SUM (tmpContainer.Summ)) :: TFloat           AS Summ

           FROM (SELECT MIContainer.ContainerId AS ContainerId
                      , MIContainer.ObjectId_analyzer AS GoodsId 
                      , MIContainer.ContainerId_analyzer      
                      , SUM ( CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() THEN COALESCE (MIContainer.Amount,0) ELSE 0 end ) AS Summ
                      , SUM ( CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN COALESCE (MIContainer.Amount,0) ELSE 0 end ) AS Amount
                      , SUM ( CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN COALESCE (MIContainer.Amount,0) ELSE 0 end ) AS AmountPartner
                      , 0 AS AmountPackage
                      , 0 AS SummPackage
                 FROM MovementItemContainer AS MIContainer 
                       JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_analyzer
                       JOIN _tmpUnit ON _tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                 WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate  
                   AND MIContainer.MovementDEscId = inDescId
                   And MIContainer.isActive = CASE WHEN MIContainer.MovementDEscId = zc_Movement_Income() THEN True ELSE False End
                 group by  MIContainer.ContainerId,      MIContainer.ObjectId_analyzer , MIContainer.ContainerId_analyzer 
                 ) as tmpContainer
       /*               LEFT JOIN ContainerLinkObject AS ContainerLO_FuelKind
                                                    ON ContainerLO_FuelKind.ContainerId = tmpContainer.ContainerId
                                                   AND ContainerLO_FuelKind.DescId = zc_ContainerLinkObject_Goods()*/
                      INNER JOIN ContainerLinkObject AS ContainerLO_Juridical
                                               ON ContainerLO_Juridical.ContainerId = tmpContainer.ContainerId_analyzer
                                              AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                         AND (ContainerLO_Juridical.ObjectId = inJuridicalId or inJuridicalId=0)
                                                                                   
                      LEFT JOIN ContainerLinkObject AS ContainerLO_GoodsKind
                                                    ON ContainerLO_GoodsKind.ContainerId =  tmpContainer.ContainerId
                                                   AND ContainerLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                      INNER JOIN ContainerLinkObject AS ContainerLO_PaidKind
                                               ON ContainerLO_PaidKind.ContainerId =  tmpContainer.ContainerId_analyzer
                                              AND ContainerLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                              AND (ContainerLO_PaidKind.ObjectId = inPaidKindId or inPaidKindId=0)
                      LEFT JOIN ContainerLinkObject AS ContainerLO_Partner
                                               ON ContainerLO_Partner.ContainerId =  tmpContainer.ContainerId_analyzer
                                              AND ContainerLO_Partner.DescId = zc_ContainerLinkObject_Partner()      
                  
                      GROUP BY tmpContainer.GoodsId
                             , COALESCE (ContainerLO_PaidKind.ObjectId,0)
                           --  , COALESCE (ContainerLO_FuelKind.ObjectId,0) 
                             , COALESCE (ContainerLO_GoodsKind.ObjectId,0) 
                             , COALESCE (ContainerLO_Partner.ObjectId,0)
                             , COALESCE (ContainerLO_Juridical.ObjectId,0) 
          ) AS tmpOperationGroup
          
          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId

          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId

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

          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpOperationGroup.PartnerId

          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpOperationGroup.JuridicalId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()


  ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.07.15         * add inUnitGroupId, inUnitId, inPaidKindId
 08.02.14         * 
    
*/

-- тест
--SELECT * FROM gpReport_GoodsMI_Income (inStartDate:= '01.01.2013', inEndDate:= '31.12.2013',  inDescId:= 1, inGoodsGroupId:= 0, inSession:= zfCalc_UserAdmin());
