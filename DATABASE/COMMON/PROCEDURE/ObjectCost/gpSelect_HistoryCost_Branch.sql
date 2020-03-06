-- Function: gpSelect_HistoryCost_Branch()

DROP FUNCTION IF EXISTS gpSelect_HistoryCost_Branch (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_HistoryCost_Branch(
    IN inStartDate       TDateTime , --
    IN inEndDate         TDateTime , --
    IN inSession         TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (StartDate TDateTime, EndDate TDateTime, BranchId Integer, BranchCode Integer, BranchName TVarChar, GoodsName TVarChar, myCount Integer)
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_InsertUpdate_HistoryCost());


     RETURN QUERY
     WITH -- захардкодили филиалы
          tmpBranch AS (SELECT Object.Id AS BranchId
                        FROM Object
                        WHERE Object.DescId = zc_Object_Branch()
                          /*AND Object.Id IN (8374   -- филиал Одесса
                                          , 301310 -- филиал Запорожье
                                          , 8373   -- филиал Николаев (Херсон)
                                          , 8375   -- филиал Черкассы (Кировоград)
                                          , 8377   -- филиал Кр.Рог
                                          , 8381   -- филиал Харьков
                                          , 8379   -- филиал Киев
                                           )*/
                          AND Object.isErased = FALSE
                          AND Object.Id <> zc_Branch_Basis()
                       )
      -- список инвентаризаций по документам
    , tmpList_all AS (SELECT Movement.Id AS MovementId, Movement.OperDate, ObjectLink_ObjectFrom_Branch.ChildObjectId AS BranchId
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                           INNER JOIN ObjectLink AS ObjectLink_ObjectFrom_Branch
                                                 ON ObjectLink_ObjectFrom_Branch.ObjectId = MovementLinkObject_From.ObjectId
                                                AND ObjectLink_ObjectFrom_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                               -- AND ObjectLink_ObjectFrom_Branch.ChildObjectId <> zc_Branch_Basis()
                          INNER JOIN tmpBranch ON tmpBranch.BranchId = ObjectLink_ObjectFrom_Branch.ChildObjectId
                      WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                        AND Movement.DescId = zc_Movement_Inventory()
                        AND Movement.StatusId = zc_Enum_Status_Complete()
                        -- AND (Movement.OperDate = '31.10.2016' OR inEndDate > '31.10.2016') 
                     )
          -- список инвентаризаций по филиалам
        , tmpList AS (SELECT tmp.BranchId, tmp.OperDate
                           , ROW_NUMBER() OVER (PARTITION BY tmp.BranchId ORDER BY tmp.OperDate) AS Ord
                      FROM (SELECT DISTINCT tmpList_all.OperDate, tmpList_all.BranchId FROM tmpList_all) AS tmp
                     )
  -- список товаров из инвентаризаций  - по филиалам + по дням
, tmpListGoods_all AS (SELECT DISTINCT tmpList_all.BranchId, tmpList_all.OperDate, MovementItem.ObjectId AS GoodsId
                       FROM tmpList_all
                            INNER JOIN MovementItem ON MovementItem.MovementId = tmpList_all.MovementId
                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                   AND MovementItem.isErased   = FALSE
                      )
      -- развернули - "все" товары по "всем" дням
    , tmpListGoods AS (SELECT DISTINCT tmpListGoods_all.GoodsId, tmpList.OperDate, tmpList.OperDate + INTERVAL '1 DAY' AS OperDate_next
                       FROM tmpListGoods_all
                            INNER JOIN tmpList ON tmpList.OperDate < inEndDate -- Кроме последнего дня
                      )
          -- нашли переоценку по дням
        , tmpPrice AS (SELECT DISTINCT
                              tmpListGoods.OperDate
                            , tmpListGoods.GoodsId
                       FROM tmpListGoods
                            INNER JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                                  ON ObjectLink_PriceListItem_Goods.ChildObjectId = tmpListGoods.GoodsId
                                                 AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                            INNER JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                  ON ObjectLink_PriceListItem_PriceList.ObjectId      = ObjectLink_PriceListItem_Goods.ObjectId
                                                 AND ObjectLink_PriceListItem_PriceList.ChildObjectId = zc_PriceList_Basis()
                                                 AND ObjectLink_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()

                            -- цена на OperDate
                            LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                    ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_Goods.ObjectId
                                                   AND ObjectHistory_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                                                   AND tmpListGoods.OperDate >= ObjectHistory_PriceListItem.StartDate AND tmpListGoods.OperDate < ObjectHistory_PriceListItem.EndDate
                            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                         ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                        AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                                                        AND ObjectHistoryFloat_PriceListItem_Value.ValueData <> 0 -- т.е. есть цена 

                            -- цена на OperDate + 1
                            LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem_next
                                                    ON ObjectHistory_PriceListItem_next.ObjectId = ObjectLink_PriceListItem_Goods.ObjectId
                                                   AND ObjectHistory_PriceListItem_next.DescId   = zc_ObjectHistory_PriceListItem()
                                                   AND tmpListGoods.OperDate_next >= ObjectHistory_PriceListItem_next.StartDate AND tmpListGoods.OperDate_next < ObjectHistory_PriceListItem_next.EndDate
                            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value_next
                                                         ON ObjectHistoryFloat_PriceListItem_Value_next.ObjectHistoryId = ObjectHistory_PriceListItem_next.Id
                                                        AND ObjectHistoryFloat_PriceListItem_Value_next.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                                                        AND ObjectHistoryFloat_PriceListItem_Value_next.ValueData <> 0 -- т.е. есть цена 

                       WHERE ObjectHistoryFloat_PriceListItem_Value.ValueData <> ObjectHistoryFloat_PriceListItem_Value_next.ValueData -- т.е. изменилась цена
                      )
         -- найденную переоценку привязали к филиалам
       , tmpRePrice AS (SELECT DISTINCT tmpListGoods_all.BranchId
                        FROM tmpListGoods_all
                             INNER JOIN tmpPrice ON tmpPrice.GoodsId  = tmpListGoods_all.GoodsId  -- т.е. проверяем что товар который был на филиале+++
                                                AND tmpPrice.OperDate = tmpListGoods_all.OperDate
                       )

      -- Результат
      SELECT tmp.StartDate  :: TDateTime AS StartDate
           , tmp.EndDate    :: TDateTime AS EndDate
           , tmp.BranchId
         --, Object_Branch.ObjectCode AS BranchCode
           , CASE WHEN Object_Branch.ObjectCode = 1 THEN 1
                    WHEN Object_Branch.ObjectCode IN (2, 12) THEN Object_Branch.ObjectCode  * 10
                    ELSE Object_Branch.ObjectCode  * 100
               END :: Integer AS BranchCode
           , Object_Branch.ValueData  AS BranchName
             -- показали любой товар из переоценки - информативно
           , (SELECT '(' || Object.ObjectCode :: TVarChar || ')' || Object.ValueData FROM tmpPrice LEFT JOIN Object ON Object.Id = tmpPrice.GoodsId WHERE tmpPrice.OperDate = tmp.EndDate /*AND tmpPrice.BranchId = tmp.BranchId*/ LIMIT 1) :: TVarChar AS GoodsName
             -- сколько вообще переоценок в этом числе - информативно
           , (SELECT COUNT (*) FROM tmpPrice WHERE tmpPrice.OperDate = tmp.EndDate /*AND tmpPrice.BranchId = tmp.BranchId*/) :: Integer AS myCount

      FROM (-- все филиалы - по которым не было переоценки
            SELECT tmpBranch.BranchId AS BranchId
                 , inStartDate        AS StartDate
                 , inEndDate          AS EndDate
            FROM tmpBranch
                 LEFT JOIN tmpRePrice ON tmpRePrice.BranchId = tmpBranch.BranchId
            WHERE tmpRePrice.BranchId IS NULL
           UNION
            -- Первый период - если на филиале была переоценка
            SELECT tmpList.BranchId AS BranchId
                 , inStartDate      AS StartDate
                 , tmpList.OperDate AS EndDate
            FROM tmpList
                 INNER JOIN tmpRePrice ON tmpRePrice.BranchId = tmpList.BranchId
            WHERE tmpList.Ord = 1
           UNION
            -- Остальные периоды - если на филиале была переоценка
            SELECT tmpList.BranchId  AS BranchId
                 , tmpList.OperDate + INTERVAL '1 DAY' AS StartDate
                 , COALESCE (tmpList_next.OperDate, inEndDate) AS EndDate
            FROM tmpList
                 INNER JOIN tmpRePrice ON tmpRePrice.BranchId = tmpList.BranchId
                 LEFT JOIN tmpList AS tmpList_next ON tmpList_next.Ord      = tmpList.Ord + 1
                                                  AND tmpList_next.BranchId = tmpList.BranchId
            WHERE tmpList.OperDate <> inEndDate
           ) AS tmp
           LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmp.BranchId
      ORDER BY tmp.StartDate
             , CASE WHEN Object_Branch.ObjectCode = 1 THEN 1
                    WHEN Object_Branch.ObjectCode IN (2, 12) THEN 2
                    ELSE 3
               END
             , Object_Branch.ObjectCode
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.08.15                                        *
*/

-- тест
-- SELECT * FROM gpSelect_HistoryCost_Branch (inStartDate:= '01.10.2019', inEndDate:= '31.10.2019', inSession:= '2') ORDER BY 4, 1
