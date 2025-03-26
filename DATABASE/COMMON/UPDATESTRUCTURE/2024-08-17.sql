     CREATE TABLE _tmp_2024_07 ( UnitId Integer
, JuridicalId_basis Integer
,  AccountId Integer                
,  InfoMoneyDestinationId  Integer
, InfoMoneyId              Integer
, InfoMoneyId_Detail               Integer
, ContainerId_Goods                        Integer
, GoodsId Integer
, GoodsKindId     Integer
, PartionGoodsId          Integer
, AssetId                         Integer)





     CREATE TABLE Container_err_2024_08 (ContainerId Integer); - ошибка ContainerSumm неправильный PartionGoodsId

     
     CREATE TABLE _tmpContainerList_2024_07 (ContainerId Integer, ContainerId_count Integer, AccountId Integer, isZavod Boolean,
                                                          UnitId Integer,
                                                          GoodsId Integer,
                                                          GoodsKindId Integer,
                                                          JuridicalId_basis Integer,
                                                          InfoMoneyId Integer,
                                                          InfoMoneyId_Detail Integer);

     CREATE TABLE _tmpContainerList_partion_2024_07 (ContainerId_count Integer, AccountId Integer,
                                                          UnitId Integer,
                                                          GoodsId Integer,
                                                          GoodsKindId Integer,
                                                          JuridicalId_basis Integer,
                                                          InfoMoneyId Integer,
                                                          InfoMoneyId_Detail Integer);
                                   
     CREATE TABLE _tmpMaster_2024_07_ (ContainerId Integer, UnitId Integer, isInfoMoney_80401 Boolean
                                 , StartCount TFloat, StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat
                                 , calcCount TFloat, calcSumm TFloat, calcCount_external TFloat, calcSumm_external TFloat
                                 , OutCount TFloat, OutSumm TFloat
                                 , AccountId Integer, GoodsId Integer, GoodsKindId Integer, InfoMoneyId Integer, InfoMoneyId_Detail Integer, JuridicalId_basis Integer
                                 , isZavod Boolean
                                  );

truncate table _tmpMaster_2024_05;
truncate table _tmpChild_2024_05;
truncate table _tmpHistoryCost_PartionCell_2024_05;


     CREATE TABLE _tmpMaster_2024_05 (ContainerId Integer, UnitId Integer, isInfoMoney_80401 Boolean
                                 , StartCount TFloat, StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat
                                 , calcCount TFloat, calcSumm TFloat, calcCount_external TFloat, calcSumm_external TFloat
                                 , OutCount TFloat, OutSumm TFloat
                                 , AccountId Integer, GoodsId Integer, GoodsKindId Integer, InfoMoneyId Integer, InfoMoneyId_Detail Integer, JuridicalId_basis Integer
                                 , isZavod Boolean
                                  );
     CREATE TABLE _tmpChild_2024_05 (MasterContainerId Integer, ContainerId Integer, MasterContainerId_Count Integer, ContainerId_Count Integer, OperCount TFloat, isExternal Boolean, DescId Integer
                                , AccountId Integer, UnitId Integer, GoodsId Integer, GoodsKindId Integer, JuridicalId_basis Integer, InfoMoneyId Integer, InfoMoneyId_Detail Integer
                                , AccountId_master Integer, UnitId_master Integer, GoodsId_master Integer, GoodsKindId_master Integer, JuridicalId_basis_master Integer, InfoMoneyId_master Integer, InfoMoneyId_Detail_master Integer
                                 );
     CREATE TABLE _tmpHistoryCost_PartionCell_2024_05 (UnitId Integer, GoodsId Integer, GoodsKindId Integer, InfoMoneyId Integer, InfoMoneyId_Detail Integer
                                                  , StartCount TFloat, StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat
                                                  , CalcCount TFloat, CalcSumm TFloat, CalcCount_external TFloat, CalcSumm_external TFloat
                                                  , OutCount TFloat, OutSumm TFloat
                                                  , AccountId Integer, isInfoMoney_80401 Boolean
                                                   ) ;


     CREATE TABLE _tmpMaster_2024_06 (ContainerId Integer, UnitId Integer, isInfoMoney_80401 Boolean
                                 , StartCount TFloat, StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat
                                 , calcCount TFloat, calcSumm TFloat, calcCount_external TFloat, calcSumm_external TFloat
                                 , OutCount TFloat, OutSumm TFloat
                                 , AccountId Integer, GoodsId Integer, GoodsKindId Integer, InfoMoneyId Integer, InfoMoneyId_Detail Integer, JuridicalId_basis Integer
                                 , isZavod Boolean
                                  );
     CREATE TABLE _tmpChild_2024_06 (MasterContainerId Integer, ContainerId Integer, MasterContainerId_Count Integer, ContainerId_Count Integer, OperCount TFloat, isExternal Boolean, DescId Integer
                                , AccountId Integer, UnitId Integer, GoodsId Integer, GoodsKindId Integer, JuridicalId_basis Integer, InfoMoneyId Integer, InfoMoneyId_Detail Integer
                                , AccountId_master Integer, UnitId_master Integer, GoodsId_master Integer, GoodsKindId_master Integer, JuridicalId_basis_master Integer, InfoMoneyId_master Integer, InfoMoneyId_Detail_master Integer
                                 );
     CREATE TABLE _tmpHistoryCost_PartionCell_2024_06 (UnitId Integer, GoodsId Integer, GoodsKindId Integer, InfoMoneyId Integer, InfoMoneyId_Detail Integer
                                                  , StartCount TFloat, StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat
                                                  , CalcCount TFloat, CalcSumm TFloat, CalcCount_external TFloat, CalcSumm_external TFloat
                                                  , OutCount TFloat, OutSumm TFloat
                                                  , AccountId Integer, isInfoMoney_80401 Boolean
                                                   ) ;

     CREATE TABLE _tmpMaster_2024_07 (ContainerId Integer, UnitId Integer, isInfoMoney_80401 Boolean
                                 , StartCount TFloat, StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat
                                 , calcCount TFloat, calcSumm TFloat, calcCount_external TFloat, calcSumm_external TFloat
                                 , OutCount TFloat, OutSumm TFloat
                                 , AccountId Integer, GoodsId Integer, GoodsKindId Integer, InfoMoneyId Integer, InfoMoneyId_Detail Integer, JuridicalId_basis Integer
                                 , isZavod Boolean
                                  );
     CREATE TABLE _tmpChild_2024_07 (MasterContainerId Integer, ContainerId Integer, MasterContainerId_Count Integer, ContainerId_Count Integer, OperCount TFloat, isExternal Boolean, DescId Integer
                                , AccountId Integer, UnitId Integer, GoodsId Integer, GoodsKindId Integer, JuridicalId_basis Integer, InfoMoneyId Integer, InfoMoneyId_Detail Integer
                                , AccountId_master Integer, UnitId_master Integer, GoodsId_master Integer, GoodsKindId_master Integer, JuridicalId_basis_master Integer, InfoMoneyId_master Integer, InfoMoneyId_Detail_master Integer
                                 );
     CREATE TABLE _tmpHistoryCost_PartionCell_2024_07 (UnitId Integer, GoodsId Integer, GoodsKindId Integer, InfoMoneyId Integer, InfoMoneyId_Detail Integer
                                                  , StartCount TFloat, StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat
                                                  , CalcCount TFloat, CalcSumm TFloat, CalcCount_external TFloat, CalcSumm_external TFloat
                                                  , OutCount TFloat, OutSumm TFloat
                                                  , AccountId Integer, isInfoMoney_80401 Boolean
                                                   ) ;
                                   

     CREATE TABLE _tmpMaster_2024_07_b (ContainerId Integer, UnitId Integer, isInfoMoney_80401 Boolean
                                 , StartCount TFloat, StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat
                                 , calcCount TFloat, calcSumm TFloat, calcCount_external TFloat, calcSumm_external TFloat
                                 , OutCount TFloat, OutSumm TFloat
                                 , AccountId Integer, GoodsId Integer, GoodsKindId Integer, InfoMoneyId Integer, InfoMoneyId_Detail Integer, JuridicalId_basis Integer
                                 , isZavod Boolean
                                  );
     CREATE TABLE _tmpChild_2024_07_b (MasterContainerId Integer, ContainerId Integer, MasterContainerId_Count Integer, ContainerId_Count Integer, OperCount TFloat, isExternal Boolean, DescId Integer
                                , AccountId Integer, UnitId Integer, GoodsId Integer, GoodsKindId Integer, JuridicalId_basis Integer, InfoMoneyId Integer, InfoMoneyId_Detail Integer
                                , AccountId_master Integer, UnitId_master Integer, GoodsId_master Integer, GoodsKindId_master Integer, JuridicalId_basis_master Integer, InfoMoneyId_master Integer, InfoMoneyId_Detail_master Integer
                                 );









        WITH tmpContainer AS (SELECT Container.Id as ContainerId
                                  , Container.ObjectId as GoodsId
                                  , Container.Amount
, CLO_GoodsKind.ObjectId as GoodsKindId
, CLO_PartionGoods.ObjectId as PartionGoodsId
, COALESCE (ObjectDate_Value.ValueData, zc_DateStart()) AS PartionGoodsDate
                                      FROM Container


                                           inner JOIN ContainerLinkObject AS CLO_Unit
                                                                         ON CLO_Unit.ContainerId = Container.Id
                                                                        AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                                        and CLO_Unit.ObjectId = zc_Unit_RK()
                                           LEFT JOIN ContainerLinkObject AS CLO_GoodsKind ON CLO_GoodsKind.ContainerId = Container.Id
                                                                                         AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                                           LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                            AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                LEFT JOIN ObjectDate AS ObjectDate_Value ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                                        AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()

                                           left join ContainerLinkObject as CLO_0 on CLO_0.ContainerId = Container.Id and CLO_0.DescId = zc_ContainerLinkObject_Account()

                             LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                  ON ObjectLink_Goods_InfoMoney.ObjectId = Container.ObjectId
                                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()


                             inner JOIN Object_InfoMoney_View AS View_InfoMoney
                                                             ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                            and InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                                       , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                                        )
                                      WHERE Container.DescId = zc_Container_Count()
                                       and CLO_0.ObjectId is null
                                     )

     -- остаток с учетом движения, временно кроме РК
   , tmpContainer_rem AS (SELECT *
                          FROM (-- остаток на конец дня
                                SELECT tmpContainer.ContainerId
                                     , tmpContainer.GoodsId
                                     , tmpContainer.GoodsKindId
                                     , tmpContainer.Amount
                                     , tmpContainer.PartionGoodsId
                                     , tmpContainer.PartionGoodsDate
                                     , tmpContainer.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS Amount_rem
                                FROM tmpContainer
                                     LEFT JOIN MovementItemContainer AS MIContainer
                                                                     ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                                    -- !!!на конец дня
                                                                    AND MIContainer.OperDate    >= '01.10.2024'
                                GROUP BY tmpContainer.ContainerId
                                     , tmpContainer.GoodsId
                                     , tmpContainer.GoodsKindId
                                     , tmpContainer.Amount
                                     , tmpContainer.PartionGoodsId
                                     , tmpContainer.PartionGoodsDate
                                HAVING tmpContainer.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) <> 0
                                ) as a
                        )
/*
     CREATE TABLE _tmp_part_2024_09 (
  ContainerId Integer
, GoodsId Integer
, GoodsKindId     Integer
, PartionGoodsId          Integer
, PartionGoodsDate TDateTime
, Amount TFloat
, Amount_rem TFloat
)

insert into _tmp_part_2024_09 (ContainerId 
, GoodsId 
, GoodsKindId     
, PartionGoodsId          
, PartionGoodsDate 
, Amount 
, Amount_rem)*/

-- select sum (Amount_rem) 
select ContainerId 
, GoodsId 
, GoodsKindId     
, PartionGoodsId          
, PartionGoodsDate 
, Amount 
, Amount_rem

-- , Object.*
from tmpContainer_rem
--    join Object on Object.Id = tmpContainer_rem.GoodsId
  -- left  join Object as Object2 on Object2.Id = tmpContainer_rem.GoodsKindId
 --where Object.ObjectCode = 2125
-- where Object2.Id is null