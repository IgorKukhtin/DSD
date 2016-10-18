-- Function: gpInsertUpdate_Object_GoodsListSale_byReport  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsListSale_byReport (TDateTime,TDateTime,TDateTime,TDateTime,TDateTime,TDateTime,Integer,Integer,Integer,Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsListSale_byReport(
    IN inStartDate_1    TDateTime ,  
    IN inEndDate_1      TDateTime ,
    IN inStartDate_2    TDateTime ,  
    IN inEndDate_2      TDateTime ,
    IN inStartDate_3    TDateTime ,  
    IN inEndDate_3      TDateTime ,
    IN inInfoMoneyId_1             Integer   ,    -- 
    IN inInfoMoneyDestinationId_1  Integer   ,    -- 
    IN inInfoMoneyId_2             Integer   ,    -- 
    IN inInfoMoneyDestinationId_2  Integer   ,    -- 
    IN inSession     TVarChar       -- сессия пользователя
)
 RETURNS Void AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbisErased Boolean;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsListSale());

   CREATE TEMP TABLE _tmpGoods (GoodsId Integer, StartDate TDateTime, EndDate TDateTime) ON COMMIT DROP;
   CREATE TEMP TABLE _tmpMIContainer (ContainerId Integer, GoodsId Integer, PartnerId Integer, OperDate TDateTime, Amount TFloat) ON COMMIT DROP;
   CREATE TEMP TABLE _tmpResult (GoodsId Integer, Juridical Integer, ContractId Integer, PartnerId Integer) ON COMMIT DROP;

   -- период для выбора продаж
   vbStartDate:= (SELECT MIN (StartDate) FROM (SELECT inStartDate_1 AS StartDate UNION SELECT inStartDate_2 AS StartDate UNION SELECT inStartDate_3 AS StartDate) as tt);
   vbEndDate  := (SELECT MAX (StartDate) FROM (SELECT inEndDate_1 AS StartDate UNION SELECT inEndDate_2 AS StartDate UNION SELECT inEndDate_3 AS StartDate) as tt);


   INSERT INTO _tmpGoods (GoodsId, StartDate, EndDate) 
        SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
             , CASE WHEN (Object_InfoMoney_View.InfoMoneyDestinationId = COALESCE (inInfoMoneyDestinationId_1, 0) 
                      OR Object_InfoMoney_View.InfoMoneyId = COALESCE (inInfoMoneyId_1,0))
                    THEN inStartDate_1
                    WHEN (Object_InfoMoney_View.InfoMoneyDestinationId = COALESCE (inInfoMoneyDestinationId_2, 0) 
                       OR Object_InfoMoney_View.InfoMoneyId = COALESCE (inInfoMoneyId_2,0)) 
                    THEN inStartDate_2
                    ELSE inStartDate_2
               END :: TdateTime AS StartDate                                                                                             -- dataS3
             , CASE WHEN (Object_InfoMoney_View.InfoMoneyDestinationId = COALESCE (inInfoMoneyDestinationId_1, 0) 
                      OR Object_InfoMoney_View.InfoMoneyId = COALESCE (inInfoMoneyId_1,0)) 
                    THEN inEndDate_1
                    WHEN (Object_InfoMoney_View.InfoMoneyDestinationId = COALESCE (inInfoMoneyDestinationId_2, 0) 
                       OR Object_InfoMoney_View.InfoMoneyId = COALESCE (inInfoMoneyId_2,0))
                    THEN inEndDate_2
                    ELSE inEndDate_3
               END :: TdateTime AS EndDate                                                                                                  -- dataE3
        FROM ObjectLink AS ObjectLink_Goods_InfoMoney
            INNER JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
         WHERE ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney();

   INSERT INTO _tmpMIContainer (ContainerId, GoodsId, PartnerId, OperDate, Amount)
        SELECT MIContainer.ContainerId_analyzer  AS ContainerId
             , MIContainer.ObjectId_analyzer     AS GoodsId
             , MIContainer.ObjectExtId_analyzer  AS PartnerId
             , MIContainer.OperDate 
             , SUM(-1 * MIContainer.Amount )     AS  Amount
        FROM MovementItemContainer AS MIContainer 
        WHERE MIContainer.OperDate BETWEEN vbStartDate AND vbEndDate
          AND MIContainer.MovementDescId = zc_Movement_Sale()  
          AND MIContainer.DescId = zc_MIContainer_Count()
        GROUP BY MIContainer.ContainerId_analyzer
               , MIContainer.ObjectId_analyzer 
               , MIContainer.ObjectExtId_analyzer
               , MIContainer.OperDate
        HAVING SUM(-1 * MIContainer.Amount ) <> 0;

     --!!!!!!!!!!!!!!!!!!!!!
     ANALYZE _tmpMIContainer;

   INSERT INTO _tmpResult (GoodsId, Juridical, ContractId, PartnerId)
        SELECT DISTINCT tmpData.GoodsId  
             , tmpData.Juridical
             , tmpData.ContractId
             , tmpData.PartnerId
        FROM (SELECT _tmpMIContainer.GoodsId  
                   , _tmpMIContainer.PartnerId
                   , ContainerLO_Juridical.ObjectId AS Juridical
                   , ContainerLO_Contract.ObjectId AS ContractId                          
                   , SUM (CASE WHEN _tmpMIContainer.OperDate BETWEEN _tmpGoods.StartDate AND _tmpGoods.EndDate THEN _tmpMIContainer.Amount ELSE 0 END) AS Amount
              FROM _tmpGoods
                 JOIN _tmpMIContainer ON _tmpMIContainer.GoodsId = _tmpGoods.GoodsId
                 LEFT JOIN ContainerLinkObject AS ContainerLO_Juridical
                                               ON ContainerLO_Juridical.ContainerId = _tmpMIContainer.ContainerId
                                              AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                 LEFT JOIN ContainerLinkObject AS ContainerLO_Contract 
                                               ON ContainerLO_Contract.ContainerId = _tmpMIContainer.ContainerId
                                              AND ContainerLO_Contract.DescId = zc_ContainerLinkObject_Contract()            
             GROUP BY  _tmpMIContainer.GoodsId  
                     , _tmpMIContainer.PartnerId
                     , ContainerLO_Juridical.ObjectId 
                     , ContainerLO_Contract.ObjectId 
             ) as tmpData
        WHERE tmpData.Amount <> 0;

    PERFORM lpInsertUpdate_Object_GoodsListSale (inGoodsId       := _tmpResult.GoodsId
                                               , inContractId    := _tmpResult.ContractId
                                               , inJuridicalId   := _tmpResult.Juridical
                                               , inPartnerId     := _tmpResult.PartnerId
                                               , inUserId        := vbUserId
                                                )
    FROM _tmpResult
    LIMIT 10;
   
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 11.10.16         *

*/

-- тест 2.09
-- select * from gpInsertUpdate_Object_GoodsListSale_byReport(inStartDate_1 := ('05.08.2016')::TDateTime , inEndDate_1 := ('05.08.2016')::TDateTime , inStartDate_2 := ('02.08.2016')::TDateTime , inEndDate_2 := ('07.08.2016')::TDateTime , inStartDate_3 := ('01.08.2016')::TDateTime , inEndDate_3 := ('10.08.2016')::TDateTime , inInfoMoneyGroupId_1 := 8852 , inInfoMoneyDestinationId_1 := 8860 , inInfoMoneyGroupId_2 := 8853 , inInfoMoneyDestinationId_2 := 8861 ,  inSession := '5');
/*select * from gpInsertUpdate_Object_GoodsListSale_byReport(inStartDate_1 := ('01.01.2016')::TDateTime , inEndDate_1 := ('31.08.2016')::TDateTime 
                                                         , inStartDate_2 := ('01.06.2016')::TDateTime , inEndDate_2 := ('31.08.2016')::TDateTime
                                                         , inStartDate_3 := ('01.08.2016')::TDateTime , inEndDate_3 := ('31.08.2016')::TDateTime 
                                                         , inInfoMoneyId_1 := 8963 , inInfoMoneyDestinationId_1 := 0 
                                                         , inInfoMoneyId_2 := 0 , inInfoMoneyDestinationId_2 := 8879 ,  inSession := '5');
*/