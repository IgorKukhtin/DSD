-- Function: gpInsertUpdate_Object_GoodsListIncome_byReport

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsListIncome_byReport (TFloat, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsListIncome_byReport(
    IN inPeriod                    TFloat    ,    --
    IN inInfoMoneyId               Integer   ,    --
    IN inInfoMoneyDestinationId    Integer   ,    --
    IN inSession                   TVarChar       -- сессия пользователя
)
 RETURNS Void AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbisErased Boolean;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate   TDateTime;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsListIncome());

   CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
   CREATE TEMP TABLE _tmpMIContainer (ContainerId Integer, GoodsId Integer, GoodsKindId Integer, PartnerId Integer, Amount TFloat, OperDate TDateTime) ON COMMIT DROP;
   CREATE TEMP TABLE _tmpResult (GoodsId Integer, GoodsKindId_max Integer, GoodsKindId_List TVarChar, Juridical Integer, ContractId Integer, PartnerId Integer, Amount TFloat, AmountChoice TFloat, OperDate TDateTime, isLast Boolean) ON COMMIT DROP;
   CREATE TEMP TABLE _tmpList (Id Integer, GoodsId Integer, GoodsKindId_max Integer, GoodsKindId_List TVarChar, Juridical Integer, ContractId Integer, PartnerId Integer, Amount TFloat, AmountChoice TFloat, OperDate TDateTime, isLast Boolean, isErased Boolean) ON COMMIT DROP;

   -- период для выбора продаж
   vbStartDate:= DATE_TRUNC ('MONTH', (SELECT CURRENT_DATE - (TO_CHAR (inPeriod, '999')|| ' MONTH') :: INTERVAL));
   vbEndDate  := CURRENT_DATE;


   -- выборка существующих элементов
   INSERT INTO _tmpList (Id, GoodsId, GoodsKindId_max, GoodsKindId_List, Juridical, ContractId, PartnerId, Amount, AmountChoice, OperDate, isLast, isErased)
      SELECT
             Object_GoodsListIncome.Id                                             AS Id
           , ObjectLink_GoodsListIncome_Goods.ChildObjectId                        AS GoodsId
           , COALESCE (ObjectLink_GoodsListIncome_GoodsKind.ChildObjectId, 0)      AS GoodsKindId_max
           , COALESCE (ObjectString_GoodsKind.ValueData, '')                       AS GoodsKindId_List
           , ObjectLink_GoodsListIncome_Juridical.ChildObjectId                    AS JuridicalId
           , GoodsListIncome_Contract.ChildObjectId                                AS ContractId
           , ObjectLink_GoodsListIncome_Partner.ChildObjectId                      AS PartnerId
           , COALESCE (ObjectFloat_GoodsListIncome_Amount.ValueData, 0)            AS Amount
           , COALESCE (ObjectFloat_GoodsListIncome_AmountChoice.ValueData, 0)      AS AmountChoice
           , COALESCE (ObjectDate_GoodsListIncome_Last.ValueData, zc_DateStart())  AS OperDate
           , COALESCE (ObjectBoolean_GoodsListIncome_Last.ValueData, FALSE)        AS isLast
           , Object_GoodsListIncome.isErased                                       AS isErased
      FROM Object AS Object_GoodsListIncome
        LEFT JOIN ObjectFloat AS ObjectFloat_GoodsListIncome_Amount
                              ON ObjectFloat_GoodsListIncome_Amount.ObjectId = Object_GoodsListIncome.Id
                             AND ObjectFloat_GoodsListIncome_Amount.DescId = zc_ObjectFloat_GoodsListIncome_Amount()
        LEFT JOIN ObjectFloat AS ObjectFloat_GoodsListIncome_AmountChoice
                              ON ObjectFloat_GoodsListIncome_AmountChoice.ObjectId = Object_GoodsListIncome.Id
                             AND ObjectFloat_GoodsListIncome_AmountChoice.DescId = zc_ObjectFloat_GoodsListIncome_AmountChoice()

        LEFT JOIN ObjectLink AS GoodsListIncome_Contract
                             ON GoodsListIncome_Contract.ObjectId = Object_GoodsListIncome.Id
                            AND GoodsListIncome_Contract.DescId = zc_ObjectLink_GoodsListIncome_Contract()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsListIncome_Juridical
                             ON ObjectLink_GoodsListIncome_Juridical.ObjectId = Object_GoodsListIncome.Id
                            AND ObjectLink_GoodsListIncome_Juridical.DescId = zc_ObjectLink_GoodsListIncome_Juridical()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsListIncome_Goods
                             ON ObjectLink_GoodsListIncome_Goods.ObjectId = Object_GoodsListIncome.Id
                            AND ObjectLink_GoodsListIncome_Goods.DescId = zc_ObjectLink_GoodsListIncome_Goods()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsListIncome_GoodsKind
                             ON ObjectLink_GoodsListIncome_GoodsKind.ObjectId = Object_GoodsListIncome.Id
                            AND ObjectLink_GoodsListIncome_GoodsKind.DescId = zc_ObjectLink_GoodsListIncome_GoodsKind()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsListIncome_Partner
                             ON ObjectLink_GoodsListIncome_Partner.ObjectId = Object_GoodsListIncome.Id
                            AND ObjectLink_GoodsListIncome_Partner.DescId = zc_ObjectLink_GoodsListIncome_Partner()
        LEFT JOIN ObjectString AS ObjectString_GoodsKind
                               ON ObjectString_GoodsKind.ObjectId = Object_GoodsListIncome.Id
                              AND ObjectString_GoodsKind.DescId = zc_ObjectString_GoodsListIncome_GoodsKind()

        LEFT JOIN ObjectDate AS ObjectDate_GoodsListIncome_Last
                             ON ObjectDate_GoodsListIncome_Last.ObjectId = Object_GoodsListIncome.Id
                            AND ObjectDate_GoodsListIncome_Last.DescId = zc_ObjectDate_GoodsListIncome_Last()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsListIncome_Last
                                ON ObjectBoolean_GoodsListIncome_Last.ObjectId = Object_GoodsListIncome.Id
                               AND ObjectBoolean_GoodsListIncome_Last.DescId = zc_ObjectBoolean_GoodsListIncome_Last()

      WHERE Object_GoodsListIncome.DescId = zc_Object_GoodsListIncome();

   -- выбираем товары согласно статьям
   INSERT INTO _tmpGoods (GoodsId)
        SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
        FROM ObjectLink AS ObjectLink_Goods_InfoMoney
             JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                       AND (Object_InfoMoney_View.InfoMoneyId = inInfoMoneyId
                                         OR Object_InfoMoney_View.InfoMoneyDestinationId IN (inInfoMoneyDestinationId
                                                                                           , zc_Enum_InfoMoneyDestination_20200() -- Прочие ТМЦ
                                                                                           , zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                                                                                           , zc_Enum_InfoMoneyDestination_20600() -- Прочие материалы
                                                                                            )
                                           )
        WHERE ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney();
   -- !!!оптимизация!!!
   ANALYZE _tmpGoods;

   --
   INSERT INTO _tmpMIContainer (ContainerId, GoodsId, GoodsKindId, PartnerId, Amount, OperDate)
        SELECT MIContainer.ContainerId_analyzer  AS ContainerId
             , MIContainer.ObjectId_analyzer     AS GoodsId
             , COALESCE (MIContainer.ObjectIntId_Analyzer, 0)  AS GoodsKindId
             , MIContainer.ObjectExtId_analyzer  AS PartnerId
             , SUM (MIContainer.Amount )         AS Amount
             , MAX (MIContainer.OperDate )       AS OperDate
        FROM MovementItemContainer AS MIContainer
             INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_analyzer
        WHERE MIContainer.OperDate BETWEEN vbStartDate AND vbEndDate
          AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ProductionUnion())
          AND MIContainer.DescId         = zc_MIContainer_Count()
          AND MIContainer.isActive       = TRUE
        GROUP BY MIContainer.ContainerId_analyzer
               , MIContainer.ObjectId_analyzer
               , MIContainer.ObjectExtId_analyzer
               , MIContainer.ObjectIntId_Analyzer
        HAVING SUM (MIContainer.Amount ) <> 0;

     --!!!!!!!!!!!!!!!!!!!!!
     ANALYZE _tmpMIContainer;


     INSERT INTO _tmpResult (GoodsId, GoodsKindId_max, GoodsKindId_List, Juridical, ContractId, PartnerId, Amount, AmountChoice, OperDate, isLast)
        WITH
        tmpData_all AS (SELECT tmp.GoodsId
                             , tmp.GoodsKindId
                             , tmp.PartnerId
                             , tmp.Juridical
                             , tmp.ContractId
                             , tmp.Amount
                             , tmp.OperDate
                             , ROW_NUMBER() OVER (PARTITION BY tmp.PartnerId, tmp.GoodsId ORDER BY tmp.Amount DESC) AS Ord
                             , ROW_NUMBER() OVER (PARTITION BY tmp.GoodsId ORDER BY tmp.OperDate DESC, tmp.Amount DESC) AS Ord_date
                        FROM
                       (SELECT tmp.GoodsId
                             , tmp.GoodsKindId
                             , tmp.PartnerId
                             , tmp.Juridical
                             , tmp.ContractId
                             , SUM (tmp.Amount) AS Amount
                             , MAX (tmp.OperDate) AS OperDate
                        FROM
                       (SELECT _tmpMIContainer.GoodsId
                             , _tmpMIContainer.GoodsKindId
                             , _tmpMIContainer.PartnerId
                             , ContainerLO_Juridical.ObjectId AS Juridical
                             , ContainerLO_Contract.ObjectId AS ContractId
                             , SUM (_tmpMIContainer.Amount) AS Amount
                             , MAX (_tmpMIContainer.OperDate) AS OperDate
                        FROM _tmpMIContainer
                            JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                     ON ContainerLO_Juridical.ContainerId = _tmpMIContainer.ContainerId
                                                    AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                            JOIN ContainerLinkObject AS ContainerLO_Contract
                                                     ON ContainerLO_Contract.ContainerId = _tmpMIContainer.ContainerId
                                                    AND ContainerLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                        GROUP BY  _tmpMIContainer.GoodsId
                                , _tmpMIContainer.GoodsKindId
                                , _tmpMIContainer.PartnerId
                                , ContainerLO_Juridical.ObjectId
                                , ContainerLO_Contract.ObjectId
                        HAVING SUM (_tmpMIContainer.Amount) <> 0
                       UNION ALL
                        SELECT _tmpMIContainer.GoodsId
                             , _tmpMIContainer.GoodsKindId
                             , _tmpMIContainer.PartnerId
                             , _tmpMIContainer.PartnerId AS Juridical
                             , 0 AS ContractId
                             , SUM (_tmpMIContainer.Amount) AS Amount
                             , MAX (_tmpMIContainer.OperDate) AS OperDate
                        FROM _tmpMIContainer
                            JOIN Object AS Object_Unit
                                        ON Object_Unit.Id     = _tmpMIContainer.PartnerId
                                       AND Object_Unit.DescId = zc_Object_Unit()
                            INNER JOIN ObjectLink AS ObjectLink_Unit_AccountDirection
                                                  ON ObjectLink_Unit_AccountDirection.ObjectId      = Object_Unit.Id
                                                 AND ObjectLink_Unit_AccountDirection.DescId        = zc_ObjectLink_Unit_AccountDirection()
                                                 AND ObjectLink_Unit_AccountDirection.ChildObjectId = zc_Enum_AccountDirection_20300() -- Запасы + на хранении
                        GROUP BY  _tmpMIContainer.GoodsId
                                , _tmpMIContainer.GoodsKindId
                                , _tmpMIContainer.PartnerId
                        HAVING SUM (_tmpMIContainer.Amount) <> 0
                       ) AS tmp
                       GROUP BY tmp.GoodsId
                              , tmp.GoodsKindId
                              , tmp.PartnerId
                              , tmp.Juridical
                              , tmp.ContractId
                       ) AS tmp
                        ORDER BY tmp.Juridical
                               , tmp.ContractId
                               , tmp.PartnerId
                               , tmp.GoodsId
                               , tmp.GoodsKindId
                       )
        -- Результат
        SELECT DISTINCT tmpData.GoodsId
             , tmpData_all.GoodsKindId AS GoodsKindId_max
             , tmpData.GoodsKindId_List
             , tmpData.Juridical
             , tmpData.ContractId
             , tmpData.PartnerId
             , CAST (tmpData.Amount AS NUMERIC (16, 2))     :: TFloat AS Amount
             , CAST (tmpData_all.Amount AS NUMERIC (16, 2)) :: TFloat AS AmountChoice
             , tmpData.OperDate
             , CASE WHEN tmpData_all_last.GoodsId > 0 THEN TRUE ELSE FALSE END AS isLast
        FROM (SELECT tmpData_all.GoodsId
                   , STRING_AGG (tmpData_all.GoodsKindId ::TVarChar, ',') AS GoodsKindId_List
                   , tmpData_all.PartnerId
                   , tmpData_all.Juridical
                   , tmpData_all.ContractId
                   , SUM (tmpData_all.Amount)   AS Amount
                   , MAX (tmpData_all.OperDate) AS OperDate
              FROM tmpData_all
             GROUP BY  tmpData_all.GoodsId
                     , tmpData_all.PartnerId
                     , tmpData_all.Juridical
                     , tmpData_all.ContractId
             HAVING SUM (tmpData_all.Amount) <> 0
             ) AS tmpData
             LEFT JOIN tmpData_all ON tmpData_all.GoodsId   = tmpData.GoodsId
                                  AND tmpData_all.PartnerId = tmpData.PartnerId
                                  AND tmpData_all.Ord       = 1
             LEFT JOIN tmpData_all AS tmpData_all_last
                                   ON tmpData_all_last.GoodsId   = tmpData.GoodsId
                                  AND tmpData_all_last.PartnerId = tmpData.PartnerId
                                  AND tmpData_all_last.Ord_date  = 1
        WHERE tmpData.Amount <> 0;


     --!!!!!!!!!!!!!!!!!!!!!
     ANALYZE _tmpResult;

    -- метим на удаление элементы, которые не попали в таблицу _tmpResult
    PERFORM lpUpdate_Object_isErased (inObjectId:= _tmpList.Id, inUserId:= vbUserId)
          , lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), _tmpList.Id, CURRENT_TIMESTAMP)
    FROM _tmpList
       LEFT JOIN _tmpResult ON _tmpList.GoodsId    = _tmpResult.GoodsId
                           AND _tmpList.ContractId = _tmpResult.ContractId
                           AND _tmpList.Juridical  = _tmpResult.Juridical
                           AND _tmpList.PartnerId  = _tmpResult.PartnerId
    WHERE _tmpList.isErased = FALSE AND _tmpResult.GoodsId IS NULL;


    -- обновляем справочник, добавляем новые элементы, снимаем пометку с удаленных
    PERFORM lpInsertUpdate_Object_GoodsListIncome
                                                (inId              := COALESCE (_tmpList.Id, 0) :: integer
                                               , inGoodsId         := _tmpResult.GoodsId
                                               , inGoodsKindId_max := _tmpResult.GoodsKindId_max
                                               , inContractId      := _tmpResult.ContractId
                                               , inJuridicalId     := _tmpResult.Juridical
                                               , inPartnerId       := _tmpResult.PartnerId
                                               , inAmount          := _tmpResult.Amount
                                               , inAmountChoice    := _tmpResult.AmountChoice
                                               , inGoodsKindId_List:= _tmpResult.GoodsKindId_List ::TVarChar
                                               , inLastDate        := _tmpResult.OperDate
                                               , inisLast          := _tmpResult.isLast
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
       OR _tmpList.OperDate <> _tmpResult.OperDate OR _tmpList.isLast <> _tmpResult.isLast
    ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 14.04.17         *
 30.03.17         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsListIncome_byReport (inPeriod:= 12, inInfoMoneyId:= 0, inInfoMoneyDestinationId:= zc_Enum_InfoMoneyDestination_30500(), inSession := zfCalc_UserAdmin());
