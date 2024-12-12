-- Function: gpInsertUpdate_Object_GoodsListSale_byReport

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
   CREATE TEMP TABLE _tmpMIContainer (ContainerId Integer, GoodsId Integer, GoodsKindId Integer, PartnerId Integer, Amount TFloat) ON COMMIT DROP;
   CREATE TEMP TABLE _tmpResult (GoodsId Integer, GoodsKindId_max Integer, GoodsKindId_List TVarChar, Juridical Integer, ContractId Integer, PartnerId Integer, Amount TFloat, AmountChoice TFloat) ON COMMIT DROP;
   CREATE TEMP TABLE _tmpList (Id Integer, GoodsId Integer, GoodsKindId_max Integer, GoodsKindId_List TVarChar, Juridical Integer, ContractId Integer, PartnerId Integer, Amount TFloat, AmountChoice TFloat, isErased Boolean) ON COMMIT DROP;

   -- период для выбора продаж
   vbStartDate1:= DATE_TRUNC ('MONTH', (SELECT CURRENT_DATE - (TO_CHAR (inPeriod_1, '999')|| ' MONTH') :: INTERVAL));
   vbStartDate2:= DATE_TRUNC ('MONTH', (SELECT CURRENT_DATE - (TO_CHAR (inPeriod_2, '999')|| ' MONTH') :: INTERVAL));
   vbStartDate3:= DATE_TRUNC ('MONTH', (SELECT CURRENT_DATE - (TO_CHAR (inPeriod_3, '999')|| ' MONTH') :: INTERVAL));
   vbEndDate   := CURRENT_DATE;


   -- выборка существующих элементов
   INSERT INTO _tmpList (Id, GoodsId, GoodsKindId_max, GoodsKindId_List, Juridical, ContractId, PartnerId, Amount, AmountChoice, isErased)
      SELECT
             Object_GoodsListSale.Id                                         AS Id
           , ObjectLink_GoodsListSale_Goods.ChildObjectId                    AS GoodsId
           , COALESCE (ObjectLink_GoodsListSale_GoodsKind.ChildObjectId, 0)  AS GoodsKindId_max
           , COALESCE (ObjectString_GoodsKind.ValueData, '')                 AS GoodsKindId_List
           , ObjectLink_GoodsListSale_Juridical.ChildObjectId                AS JuridicalId
           , GoodsListSale_Contract.ChildObjectId                            AS ContractId
           , ObjectLink_GoodsListSale_Partner.ChildObjectId                  AS PartnerId
           , COALESCE (ObjectFloat_GoodsListSale_Amount.ValueData, 0)        AS Amount
           , COALESCE (ObjectFloat_GoodsListSale_AmountChoice.ValueData, 0)  AS AmountChoice
           , Object_GoodsListSale.isErased                                   AS isErased
      FROM Object AS Object_GoodsListSale
        LEFT JOIN ObjectFloat AS ObjectFloat_GoodsListSale_Amount
                              ON ObjectFloat_GoodsListSale_Amount.ObjectId = Object_GoodsListSale.Id
                             AND ObjectFloat_GoodsListSale_Amount.DescId = zc_ObjectFloat_GoodsListSale_Amount()
        LEFT JOIN ObjectFloat AS ObjectFloat_GoodsListSale_AmountChoice
                              ON ObjectFloat_GoodsListSale_AmountChoice.ObjectId = Object_GoodsListSale.Id
                             AND ObjectFloat_GoodsListSale_AmountChoice.DescId = zc_ObjectFloat_GoodsListSale_AmountChoice()

        LEFT JOIN ObjectLink AS GoodsListSale_Contract
                             ON GoodsListSale_Contract.ObjectId = Object_GoodsListSale.Id
                            AND GoodsListSale_Contract.DescId = zc_ObjectLink_GoodsListSale_Contract()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Juridical
                             ON ObjectLink_GoodsListSale_Juridical.ObjectId = Object_GoodsListSale.Id
                            AND ObjectLink_GoodsListSale_Juridical.DescId = zc_ObjectLink_GoodsListSale_Juridical()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Goods
                             ON ObjectLink_GoodsListSale_Goods.ObjectId = Object_GoodsListSale.Id
                            AND ObjectLink_GoodsListSale_Goods.DescId = zc_ObjectLink_GoodsListSale_Goods()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_GoodsKind
                             ON ObjectLink_GoodsListSale_GoodsKind.ObjectId = Object_GoodsListSale.Id
                            AND ObjectLink_GoodsListSale_GoodsKind.DescId = zc_ObjectLink_GoodsListSale_GoodsKind()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Partner
                             ON ObjectLink_GoodsListSale_Partner.ObjectId = Object_GoodsListSale.Id
                            AND ObjectLink_GoodsListSale_Partner.DescId = zc_ObjectLink_GoodsListSale_Partner()
        LEFT JOIN ObjectString AS ObjectString_GoodsKind
                               ON ObjectString_GoodsKind.ObjectId = Object_GoodsListSale.Id
                              AND ObjectString_GoodsKind.DescId = zc_ObjectString_GoodsListSale_GoodsKind()
      WHERE Object_GoodsListSale.DescId = zc_Object_GoodsListSale();

   -- выбираем товары согласно статьям
   INSERT INTO _tmpGoods (GoodsId, Value)
        SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
            , CASE -- inInfoMoneyId_1 = 8963 -- Тушенка
                   WHEN (Object_InfoMoney_View.InfoMoneyId = COALESCE (inInfoMoneyId_1,0) OR Object_InfoMoney_View.InfoMoneyDestinationId = COALESCE (inInfoMoneyDestinationId_1, 0))
                        THEN 1
                   -- inInfoMoneyDestinationId_2 = 8879 -- Мясное сырье
                   WHEN (Object_InfoMoney_View.InfoMoneyId = COALESCE (inInfoMoneyId_2,0) OR Object_InfoMoney_View.InfoMoneyDestinationId = COALESCE (inInfoMoneyDestinationId_2, 0))
                        THEN 2
                   ELSE 0
              END :: Integer AS Value
        FROM ObjectLink AS ObjectLink_Goods_InfoMoney
             JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
        WHERE ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney();
   -- !!!оптимизация!!!
   ANALYZE _tmpGoods;

   -- Проводки
   INSERT INTO _tmpMIContainer (ContainerId, GoodsId, GoodsKindId, PartnerId, Amount)
        -- Продажи для 1 - 12 месяцев
        SELECT MIContainer.ContainerId_analyzer  AS ContainerId
             , MIContainer.ObjectId_analyzer     AS GoodsId
             , COALESCE (MIContainer.ObjectIntId_Analyzer, 0)  AS GoodsKindId
             , MIContainer.ObjectExtId_analyzer  AS PartnerId
             , -1 * SUM (MIContainer.Amount )    AS Amount

        FROM MovementItemContainer AS MIContainer
            INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_analyzer
                                -- Тушенка
                                AND _tmpGoods.Value = 1

        WHERE MIContainer.OperDate BETWEEN vbStartDate1 AND vbEndDate
          AND MIContainer.MovementDescId = zc_Movement_Sale()
          AND MIContainer.DescId = zc_MIContainer_Count()
        GROUP BY MIContainer.ContainerId_analyzer
               , MIContainer.ObjectId_analyzer
               , MIContainer.ObjectExtId_analyzer
               , MIContainer.ObjectIntId_Analyzer
        --HAVING SUM (-1 * MIContainer.Amount ) <> 0

      UNION
        -- Продажи для 2 - 3 месяца
        SELECT MIContainer.ContainerId_analyzer  AS ContainerId
             , MIContainer.ObjectId_analyzer     AS GoodsId
             , COALESCE (MIContainer.ObjectIntId_Analyzer, 0)  AS GoodsKindId
             , MIContainer.ObjectExtId_analyzer  AS PartnerId
             , SUM (-1 * MIContainer.Amount )     AS Amount
        FROM MovementItemContainer AS MIContainer
            INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_analyzer
                                -- Мясное сырье
                                AND _tmpGoods.Value = 2

        WHERE MIContainer.OperDate BETWEEN vbStartDate2 AND vbEndDate
          AND MIContainer.MovementDescId = zc_Movement_Sale()
          AND MIContainer.DescId = zc_MIContainer_Count()
        GROUP BY MIContainer.ContainerId_analyzer
               , MIContainer.ObjectId_analyzer
               , MIContainer.ObjectExtId_analyzer
               , MIContainer.ObjectIntId_Analyzer
        --HAVING SUM (-1 * MIContainer.Amount ) <> 0
      UNION

        -- Продажи для 3 - 6 месяцев - ВСЕ Остальные, кто не 1 и не 2
        SELECT MIContainer.ContainerId_analyzer  AS ContainerId
             , MIContainer.ObjectId_analyzer     AS GoodsId
             , COALESCE (MIContainer.ObjectIntId_Analyzer, 0)  AS GoodsKindId
             , MIContainer.ObjectExtId_analyzer  AS PartnerId
             , SUM(-1 * MIContainer.Amount )     AS Amount
        FROM MovementItemContainer AS MIContainer
            INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_analyzer
                                AND _tmpGoods.Value = 0
        WHERE MIContainer.OperDate BETWEEN vbStartDate3 AND vbEndDate
          AND MIContainer.MovementDescId = zc_Movement_Sale()
          AND MIContainer.DescId = zc_MIContainer_Count()
        GROUP BY MIContainer.ContainerId_analyzer
               , MIContainer.ObjectId_analyzer
               , MIContainer.ObjectExtId_analyzer
               , MIContainer.ObjectIntId_Analyzer
        --HAVING SUM (-1 * MIContainer.Amount ) <> 0
       ;

     --!!!!!!!!!!!!!!!!!!!!!
     ANALYZE _tmpMIContainer;


     INSERT INTO _tmpResult (GoodsId, GoodsKindId_max, GoodsKindId_List, Juridical, ContractId, PartnerId, Amount, AmountChoice)
        WITH
        tmpData_all AS (SELECT tmp.GoodsId
                             , tmp.GoodsKindId
                             , tmp.PartnerId
                             , tmp.Juridical
                             , tmp.ContractId
                             , tmp.Amount
                             , ROW_NUMBER() OVER (PARTITION BY tmp.PartnerId, tmp.GoodsId ORDER BY tmp.Amount DESC) AS Ord

                        FROM (SELECT _tmpMIContainer.GoodsId
                                   , _tmpMIContainer.GoodsKindId
                                   , _tmpMIContainer.PartnerId
                                   , ContainerLO_Juridical.ObjectId AS Juridical
                                   , ContainerLO_Contract.ObjectId  AS ContractId
                                   , SUM (_tmpMIContainer.Amount)   AS Amount
                              FROM _tmpMIContainer
                                  JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                           ON ContainerLO_Juridical.ContainerId = _tmpMIContainer.ContainerId
                                                          AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                  JOIN ContainerLinkObject AS ContainerLO_Contract
                                                           ON ContainerLO_Contract.ContainerId = _tmpMIContainer.ContainerId
                                                          AND ContainerLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                              GROUP BY _tmpMIContainer.GoodsId
                                     , _tmpMIContainer.GoodsKindId
                                     , _tmpMIContainer.PartnerId
                                     , ContainerLO_Juridical.ObjectId
                                     , ContainerLO_Contract.ObjectId
                            --HAVING SUM (_tmpMIContainer.Amount) <> 0
                             ) AS tmp
                        ORDER BY tmp.Juridical
                               , tmp.ContractId
                               , tmp.PartnerId
                               , tmp.GoodsId
                               , tmp.GoodsKindId
                       )
        -- Результат
        SELECT DISTINCT
               tmpData.GoodsId
             , tmpData_all.GoodsKindId AS GoodsKindId_max
             , tmpData.GoodsKindId_List
             , tmpData.Juridical
             , tmpData.ContractId
             , tmpData.PartnerId
             , CAST (tmpData.Amount AS NUMERIC (16, 2))     :: TFloat AS Amount
             , CAST (tmpData_all.Amount AS NUMERIC (16, 2)) :: TFloat AS AmountChoice
        FROM (SELECT tmpData_all.GoodsId
                   , STRING_AGG (tmpData_all.GoodsKindId ::TVarChar, ',') AS GoodsKindId_List
                   , tmpData_all.PartnerId
                   , tmpData_all.Juridical
                   , tmpData_all.ContractId
                   , SUM (tmpData_all.Amount) AS Amount
              FROM tmpData_all
              GROUP BY  tmpData_all.GoodsId
                      , tmpData_all.PartnerId
                      , tmpData_all.Juridical
                      , tmpData_all.ContractId
              --HAVING SUM (tmpData_all.Amount) <> 0
             ) AS tmpData
             LEFT JOIN tmpData_all ON tmpData_all.GoodsId   = tmpData.GoodsId
                                  AND tmpData_all.PartnerId = tmpData.PartnerId
                                  AND tmpData_all.Ord       = 1
        --WHERE tmpData.Amount <> 0
       ;


    --!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpResult;

    -- отмечаем удаленными - элементы, которые не попали в таблицу _tmpResult
    PERFORM lpUpdate_Object_isErased (inObjectId:= _tmpList.Id, inUserId:= vbUserId)
          , lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), _tmpList.Id, CURRENT_TIMESTAMP)
    FROM _tmpList
         LEFT JOIN _tmpResult ON _tmpList.GoodsId    = _tmpResult.GoodsId
                             AND _tmpList.ContractId = _tmpResult.ContractId
                             AND _tmpList.Juridical  = _tmpResult.Juridical
                             AND _tmpList.PartnerId  = _tmpResult.PartnerId
    WHERE _tmpList.isErased = FALSE AND _tmpResult.GoodsId IS NULL;


    -- обновляем справочник, добавляем новые элементы, снимаем отметку с удаленных
    PERFORM lpInsertUpdate_Object_GoodsListSale (inId              := COALESCE (_tmpList.Id, 0) :: integer
                                               , inGoodsId         := _tmpResult.GoodsId
                                               , inGoodsKindId_max := _tmpResult.GoodsKindId_max
                                               , inContractId      := _tmpResult.ContractId
                                               , inJuridicalId     := _tmpResult.Juridical
                                               , inPartnerId       := _tmpResult.PartnerId
                                               , inAmount          := _tmpResult.Amount
                                               , inAmountChoice    := _tmpResult.AmountChoice
                                               , inGoodsKindId_List:= _tmpResult.GoodsKindId_List ::TVarChar
                                               , inisErased        := _tmpList.isErased
                                               , inUserId          := vbUserId
                                                )
    FROM _tmpResult
       LEFT JOIN _tmpList ON _tmpList.GoodsId    = _tmpResult.GoodsId
                         AND _tmpList.ContractId = _tmpResult.ContractId
                         AND _tmpList.Juridical  = _tmpResult.Juridical
                         AND _tmpList.PartnerId  = _tmpResult.PartnerId
    WHERE _tmpList.Id IS NULL OR _tmpList.isErased = TRUE OR _tmpList.GoodsKindId_List <> COALESCE (_tmpResult.GoodsKindId_List, '') OR _tmpList.GoodsKindId_max <> COALESCE (_tmpResult.GoodsKindId_max, 0)
       OR _tmpList.AmountChoice <> COALESCE (_tmpResult.AmountChoice, 0) OR _tmpList.Amount <> COALESCE (_tmpResult.Amount, 0)
   ;


   IF EXTRACT (HOURS FROM CURRENT_TIMESTAMP) < 7
   THEN
       -- Паровозом еще посчитам ЭТО
       PERFORM gpInsertUpdate_Object_GoodsReportSale (inSession:= inSession);
   END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 07.12.16         * add GoodsKindId_List
 12.10.16         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsListSale_byReport (inPeriod_1:= 12, inPeriod_2:= 3, inPeriod_3:= 6, inInfoMoneyId_1:= 8963, inInfoMoneyDestinationId_1:= 0, inInfoMoneyId_2:= 0, inInfoMoneyDestinationId_2:= 8879,  inSession := '5');
