
-- Function: gpInsertUpdate_Object_GoodsListSale_byReport  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsListSale_byReport (TFloat,TFloat,TFloat,Integer,Integer,Integer,Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsListSale_byReport(
    IN inPeriod_1                  TFloat ,  
    IN inPeriod_2                  TFloat ,
    IN inPeriod_3                  TFloat ,  
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
   DECLARE vbStartDate1 TDateTime;
   DECLARE vbStartDate2 TDateTime;
   DECLARE vbStartDate3 TDateTime;
   DECLARE vbEndDate TDateTime;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsListSale());

   CREATE TEMP TABLE _tmpGoods (GoodsId Integer, Value Integer) ON COMMIT DROP;
   CREATE TEMP TABLE _tmpMIContainer (ContainerId Integer, GoodsId Integer, PartnerId Integer, Amount TFloat) ON COMMIT DROP;
   CREATE TEMP TABLE _tmpResult (GoodsId Integer, Juridical Integer, ContractId Integer, PartnerId Integer, Amount TFloat) ON COMMIT DROP;
   CREATE TEMP TABLE _tmpList (Id Integer, GoodsId Integer, Juridical Integer, ContractId Integer, PartnerId Integer, isErased Boolean) ON COMMIT DROP;

   -- период для выбора продаж
   vbStartDate1:= DATE_TRUNC ('MONTH', (SELECT CURRENT_DATE - (TO_CHAR (inPeriod_1, '999')|| ' MONTH') :: INTERVAL));
   vbStartDate2:= DATE_TRUNC ('MONTH', (SELECT CURRENT_DATE - (TO_CHAR (inPeriod_2, '999')|| ' MONTH') :: INTERVAL));
   vbStartDate3:= DATE_TRUNC ('MONTH', (SELECT CURRENT_DATE - (TO_CHAR (inPeriod_3, '999')|| ' MONTH') :: INTERVAL));
   vbEndDate   := CURRENT_DATE;


   -- выборка существующих элементов
   INSERT INTO _tmpList (Id, GoodsId, Juridical, ContractId, PartnerId, isErased) 
      SELECT 
             Object_GoodsListSale.Id                           AS Id
           , ObjectLink_GoodsListSale_Goods.ChildObjectId      AS GoodsId 
           , ObjectLink_GoodsListSale_Juridical.ChildObjectId  AS JuridicalId           
           , GoodsListSale_Contract.ChildObjectId              AS ContractId
           , ObjectLink_GoodsListSale_Partner.ChildObjectId    AS PartnerId
           , Object_GoodsListSale.isErased                     AS isErased
      FROM Object AS Object_GoodsListSale 
        LEFT JOIN ObjectLink AS GoodsListSale_Contract
                             ON GoodsListSale_Contract.ObjectId = Object_GoodsListSale.Id
                            AND GoodsListSale_Contract.DescId = zc_ObjectLink_GoodsListSale_Contract()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Juridical
                             ON ObjectLink_GoodsListSale_Juridical.ObjectId = Object_GoodsListSale.Id
                            AND ObjectLink_GoodsListSale_Juridical.DescId = zc_ObjectLink_GoodsListSale_Juridical()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Goods
                             ON ObjectLink_GoodsListSale_Goods.ObjectId = Object_GoodsListSale.Id
                            AND ObjectLink_GoodsListSale_Goods.DescId = zc_ObjectLink_GoodsListSale_Goods()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Partner
                             ON ObjectLink_GoodsListSale_Partner.ObjectId = Object_GoodsListSale.Id
                            AND ObjectLink_GoodsListSale_Partner.DescId = zc_ObjectLink_GoodsListSale_Partner()
      WHERE  Object_GoodsListSale.DescId = zc_Object_GoodsListSale();

   -- выбираем товары согдасно статьям
   INSERT INTO _tmpGoods (GoodsId, Value) 
        SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
            , CASE WHEN (Object_InfoMoney_View.InfoMoneyId = COALESCE (inInfoMoneyId_1,0) OR Object_InfoMoney_View.InfoMoneyDestinationId = COALESCE (inInfoMoneyDestinationId_1, 0))
                        THEN 1
                   WHEN (Object_InfoMoney_View.InfoMoneyId = COALESCE (inInfoMoneyId_2,0) OR Object_InfoMoney_View.InfoMoneyDestinationId = COALESCE (inInfoMoneyDestinationId_2, 0))
                        THEN 2
                   ELSE 0
              END :: Integer AS Value
        FROM ObjectLink AS ObjectLink_Goods_InfoMoney
             JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
        WHERE ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney();
   -- !!!оптимизация!!!
   ANALYZE _tmpGoods;

   -- 
   INSERT INTO _tmpMIContainer (ContainerId, GoodsId, PartnerId, Amount)
        SELECT MIContainer.ContainerId_analyzer  AS ContainerId
             , MIContainer.ObjectId_analyzer     AS GoodsId
             , MIContainer.ObjectExtId_analyzer  AS PartnerId
             , SUM(-1 * MIContainer.Amount ) ::TFloat    AS  Amount
        FROM MovementItemContainer AS MIContainer 
            INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_analyzer 
                                AND _tmpGoods.Value = 1
        WHERE MIContainer.OperDate BETWEEN vbStartDate1 AND vbEndDate
          AND MIContainer.MovementDescId = zc_Movement_Sale()  
          AND MIContainer.DescId = zc_MIContainer_Count()
        GROUP BY MIContainer.ContainerId_analyzer
               , MIContainer.ObjectId_analyzer 
               , MIContainer.ObjectExtId_analyzer
        HAVING SUM(-1 * MIContainer.Amount ) <> 0
      UNION
        SELECT MIContainer.ContainerId_analyzer  AS ContainerId
             , MIContainer.ObjectId_analyzer     AS GoodsId
             , MIContainer.ObjectExtId_analyzer  AS PartnerId
             , SUM(-1 * MIContainer.Amount )     AS  Amount
        FROM MovementItemContainer AS MIContainer 
            INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_analyzer 
                                AND _tmpGoods.Value = 2
        WHERE MIContainer.OperDate BETWEEN vbStartDate2 AND vbEndDate
          AND MIContainer.MovementDescId = zc_Movement_Sale()  
          AND MIContainer.DescId = zc_MIContainer_Count()
        GROUP BY MIContainer.ContainerId_analyzer
               , MIContainer.ObjectId_analyzer 
               , MIContainer.ObjectExtId_analyzer
        HAVING SUM(-1 * MIContainer.Amount ) <> 0
      UNION
        SELECT MIContainer.ContainerId_analyzer  AS ContainerId
             , MIContainer.ObjectId_analyzer     AS GoodsId
             , MIContainer.ObjectExtId_analyzer  AS PartnerId
             , SUM(-1 * MIContainer.Amount )     AS  Amount
        FROM MovementItemContainer AS MIContainer 
            INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_analyzer 
                                AND _tmpGoods.Value = 0
        WHERE MIContainer.OperDate BETWEEN vbStartDate3 AND vbEndDate
          AND MIContainer.MovementDescId = zc_Movement_Sale()  
          AND MIContainer.DescId = zc_MIContainer_Count()
        GROUP BY MIContainer.ContainerId_analyzer
               , MIContainer.ObjectId_analyzer 
               , MIContainer.ObjectExtId_analyzer
        HAVING SUM(-1 * MIContainer.Amount ) <> 0;

     --!!!!!!!!!!!!!!!!!!!!!
     ANALYZE _tmpMIContainer;


     INSERT INTO _tmpResult (GoodsId, Juridical, ContractId, PartnerId, Amount)
        SELECT DISTINCT tmpData.GoodsId  
             , tmpData.Juridical
             , tmpData.ContractId
             , tmpData.PartnerId
             , CAST (tmpData.Amount AS NUMERIC (16, 2)) ::Tfloat
        FROM (SELECT _tmpMIContainer.GoodsId  
                   , _tmpMIContainer.PartnerId
                   , ContainerLO_Juridical.ObjectId AS Juridical
                   , ContainerLO_Contract.ObjectId AS ContractId                          
                   , SUM (_tmpMIContainer.Amount) AS Amount
              FROM _tmpMIContainer 
                  JOIN ContainerLinkObject AS ContainerLO_Juridical
                                               ON ContainerLO_Juridical.ContainerId = _tmpMIContainer.ContainerId
                                              AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                  JOIN ContainerLinkObject AS ContainerLO_Contract 
                                               ON ContainerLO_Contract.ContainerId = _tmpMIContainer.ContainerId
                                              AND ContainerLO_Contract.DescId = zc_ContainerLinkObject_Contract()            
             GROUP BY  _tmpMIContainer.GoodsId  
                     , _tmpMIContainer.PartnerId
                     , ContainerLO_Juridical.ObjectId 
                     , ContainerLO_Contract.ObjectId 
             HAVING SUM (_tmpMIContainer.Amount) <> 0
             ) as tmpData
        WHERE tmpData.Amount <> 0;


     --!!!!!!!!!!!!!!!!!!!!!
     ANALYZE _tmpResult;

    -- метим на удаление элементы, которые не попали в таблицу _tmpResult
    PERFORM lpUpdate_Object_isErased (inObjectId:= _tmpList.Id, inUserId:= vbUserId)
    FROM _tmpList
       LEFT JOIN _tmpResult ON _tmpList.GoodsId    = _tmpResult.GoodsId
                           AND _tmpList.ContractId = _tmpResult.ContractId
                           AND _tmpList.Juridical  = _tmpResult.Juridical
                           AND _tmpList.PartnerId  = _tmpResult.PartnerId
    WHERE _tmpList.isErased = FALSE AND _tmpResult.GoodsId IS NULL;
    
    
    -- обновляем справочник, добавляем новые элементы, снимаем пометку с удаленных
    PERFORM lpInsertUpdate_Object_GoodsListSale (inId            := COALESCE (_tmpList.Id, 0) :: integer
                                               , inGoodsId       := _tmpResult.GoodsId
                                               , inContractId    := _tmpResult.ContractId
                                               , inJuridicalId   := _tmpResult.Juridical
                                               , inPartnerId     := _tmpResult.PartnerId
                                               , inAmount        := _tmpResult.Amount ::Tfloat
                                               , inUserId        := vbUserId
                                                )
    FROM _tmpResult
       LEFT JOIN _tmpList ON _tmpList.GoodsId    = _tmpResult.GoodsId
                         AND _tmpList.ContractId = _tmpResult.ContractId
                         AND _tmpList.Juridical  = _tmpResult.Juridical
                         AND _tmpList.PartnerId  = _tmpResult.PartnerId
                                 
    WHERE _tmpList.Id IS NULL OR  _tmpList.isErased   = TRUE;
 --   LIMIT 100

   /* -- обновляем справочник, обновляем кол-во в существующих элементах
    PERFORM lpInsertUpdate_Object_GoodsListSale (inId            := COALESCE (_tmpList.Id, 0) :: integer
                                               , inGoodsId       := _tmpResult.GoodsId
                                               , inContractId    := _tmpResult.ContractId
                                               , inJuridicalId   := _tmpResult.Juridical
                                               , inPartnerId     := _tmpResult.PartnerId
                                               , inAmount        := CAST (_tmpResult.Amount AS NUMERIC (16, 2)) ::Tfloat
                                               , inUserId        := vbUserId
                                                )
    FROM _tmpResult
       LEFT JOIN _tmpList ON _tmpList.GoodsId    = _tmpResult.GoodsId
                         AND _tmpList.ContractId = _tmpResult.ContractId
                         AND _tmpList.Juridical  = _tmpResult.Juridical
                         AND _tmpList.PartnerId  = _tmpResult.PartnerId
                                 
    WHERE _tmpList.Id IS NULL OR  _tmpList.isErased   = TRUE
*/

   
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.10.16         *

*/

-- тест
-- select * from gpInsertUpdate_Object_GoodsListSale_byReport(inStartDate_1 := ('01.06.2016')::TDateTime , inEndDate_1 := ('31.08.2016')::TDateTime , inStartDate_2 := ('01.06.2016')::TDateTime , inEndDate_2 := ('31.08.2016')::TDateTime 
--, inStartDate_3 := ('01.08.2016')::TDateTime , inEndDate_3 := ('10.08.2016')::TDateTime , inInfoMoneyId_1 := 8963 , inInfoMoneyDestinationId_1 := 0 , inInfoMoneyId_2 := 0 , inInfoMoneyDestinationId_2 := 8879 ,  inSession := '5');
