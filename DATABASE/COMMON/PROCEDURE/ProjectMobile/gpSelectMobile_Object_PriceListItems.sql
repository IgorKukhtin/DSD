 -- Function: gpSelectMobile_Object_PriceListItems (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_PriceListItems (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_PriceListItems (
    IN inSyncDateIn TDateTime, -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id              Integer
             , GoodsId         Integer   -- Товар
             , GoodsId_key     Integer   -- Товар
             , GoodsKindId     Integer   -- Товар
             , PriceListId     Integer   -- Прайс-лист
             , OrderStartDate  TDateTime -- Дата с которой действует цена заявки
             , OrderEndDate    TDateTime -- Дата до которой действует цена заявки
             , OrderPrice      TFloat    -- Цена заявки
             , SaleStartDate   TDateTime -- Дата с которой действует цена отгрузки
             , SaleEndDate     TDateTime -- Дата до которой действует цена отгрузки
             , SalePrice       TFloat    -- Цена отгрузки
             , ReturnStartDate TDateTime -- Дата с которой действует цена возврата
             , ReturnEndDate   TDateTime -- Дата до которой действует цена возврата
             , ReturnPrice     TFloat    -- Цена возврата
             , isSync          Boolean   -- Синхронизируется (да/нет)
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUserId_save Integer;
   DECLARE vbPersonalId Integer;
   DECLARE vbReturnDayCount Integer;
   DECLARE vbReturnDate TDateTime;
   DECLARE vbSession_save    TVarChar;
BEGIN

      -- !!!ВРЕМЕННО!!!
      vbSession_save:=inSession;

      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      vbUserId_save:= vbUserId;

      -- if vbUserId = 5 then vbUserId:= 1045496; inSession:= '1045496'; end if; -- Стрижко Д.О.

      -- if inSession = '1000137' then return; end if;

      -- !!! ВРЕМЕННО будем выгружать все
      inSyncDateIn:= zc_DateStart();


      -- определяем идентификатор торгового агента
      SELECT PersonalId, ReturnDayCount INTO vbPersonalId, vbReturnDayCount FROM gpGetMobile_Object_Const (inSession);

      vbReturnDate:= CURRENT_DATE - COALESCE (vbReturnDayCount, 14)::Integer;

      -- если торговый агент не определен, то возвращать нечего
      IF vbPersonalId IS NOT NULL
      THEN
           -- Результат
           RETURN QUERY
             WITH
                  -- определяем список контрагентов+юр.лиц, что доступны торговому агенту
                  tmpPartner AS (SELECT OP.Id AS PartnerId
                                      , OP.JuridicalId
                                 FROM lfSelectMobile_Object_Partner (inIsErased:= FALSE, inSession:= inSession) AS OP
                                )
                  -- создаем список идентификаторов прайс-листов, что доступны торговому агенту
                , tmpPriceList AS (SELECT COALESCE(ObjectLink_Partner_PriceList.ChildObjectId
                                               --, ObjectLink_Contract_PriceList.ChildObjectId
                                                 , ObjectLink_Juridical_PriceList.ChildObjectId
                                                 , zc_PriceList_Basis()) AS PriceListId
                                   FROM tmpPartner
                                        LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList
                                                             ON ObjectLink_Partner_PriceList.ObjectId = tmpPartner.PartnerId
                                                            AND ObjectLink_Partner_PriceList.DescId = zc_ObjectLink_Partner_PriceList()
                                        LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                                             ON ObjectLink_Juridical_PriceList.ObjectId = tmpPartner.JuridicalId
                                                            AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()
                                  UNION
                                   SELECT COALESCE(ObjectLink_Partner_PriceListPrior.ChildObjectId
                                                 , ObjectLink_Juridical_PriceListPrior.ChildObjectId
                                                 , zc_PriceList_Basis() /*zc_PriceList_BasisPrior()*/) AS PriceListId
                                   FROM tmpPartner
                                        LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceListPrior
                                                             ON ObjectLink_Partner_PriceListPrior.ObjectId = tmpPartner.PartnerId
                                                            AND ObjectLink_Partner_PriceListPrior.DescId = zc_ObjectLink_Partner_PriceListPrior()
                                        LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceListPrior
                                                             ON ObjectLink_Juridical_PriceListPrior.ObjectId = tmpPartner.JuridicalId
                                                            AND ObjectLink_Juridical_PriceListPrior.DescId = zc_ObjectLink_Juridical_PriceListPrior()
                                  UNION
                                   SELECT OL_ContractPriceList_PriceList.ChildObjectId AS PriceListId
                                   FROM tmpPartner
                                        JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                        ON ObjectLink_Contract_Juridical.ChildObjectId = tmpPartner.JuridicalId
                                                       AND ObjectLink_Contract_Juridical.DescId        = zc_ObjectLink_Contract_Juridical()
                                        -- убрали Удаленные
                                        JOIN Object AS Object_Contract
                                                    ON Object_Contract.Id       = ObjectLink_Contract_Juridical.ObjectId
                                                   AND Object_Contract.isErased = FALSE
                                        INNER JOIN ObjectLink AS OL_ContractPriceList_Contract
                                                              ON OL_ContractPriceList_Contract.ChildObjectId = Object_Contract.Id
                                                             AND OL_ContractPriceList_Contract.DescId        = zc_ObjectLink_ContractPriceList_Contract()
                                        INNER JOIN Object AS Object_ContractPriceList ON Object_ContractPriceList.Id       = OL_ContractPriceList_Contract.ObjectId
                                                                                     AND Object_ContractPriceList.isErased = FALSE
                                        INNER JOIN ObjectDate AS ObjectDate_StartDate
                                                              ON ObjectDate_StartDate.ObjectId = Object_ContractPriceList.Id
                                                             AND ObjectDate_StartDate.DescId   = zc_ObjectDate_ContractPriceList_StartDate()
                                        INNER JOIN ObjectDate AS ObjectDate_EndDate
                                                              ON ObjectDate_EndDate.ObjectId = Object_ContractPriceList.Id
                                                             AND ObjectDate_EndDate.DescId   = zc_ObjectDate_ContractPriceList_EndDate()
                                        INNER JOIN ObjectLink AS OL_ContractPriceList_PriceList
                                                              ON OL_ContractPriceList_PriceList.ObjectId = Object_ContractPriceList.Id
                                                             AND OL_ContractPriceList_PriceList.DescId   = zc_ObjectLink_ContractPriceList_PriceList()
                                                             AND OL_ContractPriceList_PriceList.ChildObjectId > 0
                                   WHERE CURRENT_DATE + INTERVAL '1 DAY' BETWEEN ObjectDate_StartDate.ValueData AND ObjectDate_EndDate.ValueData
                                  )
                , tmpGoods AS (SELECT DISTINCT tmp.GoodsId FROM gpSelectMobile_Object_GoodsByGoodsKind (inSyncDateIn, inSession) AS tmp)

            , tmpRes_all AS (SELECT     (Object_PriceListItem.Id)                                 :: Integer   AS Id
                                  , ObjectLink_PriceListItem_Goods.ChildObjectId                  :: Integer   AS GoodsId
                                  , ObjectLink_PriceListItem_PriceList.ChildObjectId              :: Integer   AS PriceListId
                                  , MAX (ObjectHistory_PriceListItem_Order.StartDate)             :: TDateTime AS OrderStartDate
                                  , MAX (ObjectHistory_PriceListItem_Order.EndDate)               :: TDateTime AS OrderEndDate
                                  , MAX (ObjectHistoryFloat_PriceListItem_Value_Order.ValueData)  :: TFloat    AS OrderPrice
                                  , MAX (ObjectHistory_PriceListItem_Sale.StartDate)              :: TDateTime AS SaleStartDate
                                  , MAX (ObjectHistory_PriceListItem_Sale.EndDate)                :: TDateTime AS SaleEndDate
                                  , MAX (ObjectHistoryFloat_PriceListItem_Value_Sale.ValueData)   :: TFloat    AS SalePrice
                                  , MAX (COALESCE (ObjectHistory_PriceListItem_Return_curr.StartDate, ObjectHistory_PriceListItem_Return.StartDate))          :: TDateTime AS ReturnStartDate
                                  , MAX (COALESCE (ObjectHistory_PriceListItem_Return_curr.EndDate, ObjectHistory_PriceListItem_Return.EndDate))              :: TDateTime AS ReturnEndDate
                                  , MAX (COALESCE (ObjectHistoryFloat_PriceListItem_Value_Return_curr.ValueData, ObjectHistoryFloat_PriceListItem_Value_Return.ValueData)) :: TFloat    AS ReturnPrice
                                  , TRUE                                                          :: Boolean   AS isSync
                             FROM Object AS Object_PriceListItem
                                  JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                                  ON ObjectLink_PriceListItem_Goods.ObjectId = Object_PriceListItem.Id
                                                 AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                                  JOIN tmpGoods ON tmpGoods.GoodsId = ObjectLink_PriceListItem_Goods.ChildObjectId
                                  JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                  ON ObjectLink_PriceListItem_PriceList.ObjectId = Object_PriceListItem.Id
                                                 AND ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                                  JOIN tmpPriceList ON tmpPriceList.PriceListId = ObjectLink_PriceListItem_PriceList.ChildObjectId

                                  LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                                       ON ObjectLink_PriceListItem_GoodsKind.ObjectId = Object_PriceListItem.Id
                                                      AND ObjectLink_PriceListItem_GoodsKind.DescId = zc_ObjectLink_PriceListItem_GoodsKind()

                                  -- Цены заявки
                                  LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem_Order
                                                          ON ObjectHistory_PriceListItem_Order.ObjectId = Object_PriceListItem.Id
                                                         AND ObjectHistory_PriceListItem_Order.DescId = zc_ObjectHistory_PriceListItem()
                                                         AND CURRENT_DATE >= ObjectHistory_PriceListItem_Order.StartDate AND CURRENT_DATE < ObjectHistory_PriceListItem_Order.EndDate
                                  LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value_Order
                                                               ON ObjectHistoryFloat_PriceListItem_Value_Order.ObjectHistoryId = ObjectHistory_PriceListItem_Order.Id
                                                              AND ObjectHistoryFloat_PriceListItem_Value_Order.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                                  -- Цены отгрузки
                                  LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem_Sale
                                                          ON ObjectHistory_PriceListItem_Sale.ObjectId = Object_PriceListItem.Id
                                                         AND ObjectHistory_PriceListItem_Sale.DescId = zc_ObjectHistory_PriceListItem()
                                                         AND (CURRENT_DATE + INTERVAL '1 DAY') >= ObjectHistory_PriceListItem_Sale.StartDate AND (CURRENT_DATE + INTERVAL '1 DAY') < ObjectHistory_PriceListItem_Sale.EndDate
                                  LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value_Sale
                                                               ON ObjectHistoryFloat_PriceListItem_Value_Sale.ObjectHistoryId = ObjectHistory_PriceListItem_Sale.Id
                                                              AND ObjectHistoryFloat_PriceListItem_Value_Sale.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                                  -- Цены возврата
                                  LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem_Return
                                                          ON ObjectHistory_PriceListItem_Return.ObjectId = Object_PriceListItem.Id
                                                         AND ObjectHistory_PriceListItem_Return.DescId = zc_ObjectHistory_PriceListItem()
                                                         AND vbReturnDate >= ObjectHistory_PriceListItem_Return.StartDate AND vbReturnDate < ObjectHistory_PriceListItem_Return.EndDate
                                  LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value_Return
                                                               ON ObjectHistoryFloat_PriceListItem_Value_Return.ObjectHistoryId = ObjectHistory_PriceListItem_Return.Id
                                                              AND ObjectHistoryFloat_PriceListItem_Value_Return.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

                                  LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem_Return_curr
                                                          ON ObjectHistory_PriceListItem_Return_curr.ObjectId = Object_PriceListItem.Id
                                                         AND ObjectHistory_PriceListItem_Return_curr.DescId = zc_ObjectHistory_PriceListItem()
                                                         AND CURRENT_DATE >= ObjectHistory_PriceListItem_Return_curr.StartDate AND CURRENT_DATE < ObjectHistory_PriceListItem_Return_curr.EndDate
                                                         AND ObjectHistory_PriceListItem_Return.ObjectId IS NULL
                                  LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value_Return_curr
                                                               ON ObjectHistoryFloat_PriceListItem_Value_Return_curr.ObjectHistoryId = ObjectHistory_PriceListItem_Return_curr.Id
                                                              AND ObjectHistoryFloat_PriceListItem_Value_Return_curr.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

                             WHERE Object_PriceListItem.DescId = zc_Object_PriceListItem()
                               AND ((ABS (COALESCE (ObjectHistoryFloat_PriceListItem_Value_Order.ValueData, 0.0))
                                   + ABS (COALESCE (ObjectHistoryFloat_PriceListItem_Value_Sale.ValueData, 0.0))) <> 0.0)
                             --AND ObjectLink_PriceListItem_GoodsKind.ChildObjectId IS NULL

                             GROUP BY Object_PriceListItem.Id
                                    , ObjectLink_PriceListItem_Goods.ChildObjectId
                                    , ObjectLink_PriceListItem_PriceList.ChildObjectId
                            )
                , tmpRes AS (SELECT tmpRes_all.Id
                                  , tmpRes_all.GoodsId
                                  , tmpRes_all.PriceListId
                                  , tmpRes_all.OrderStartDate
                                  , tmpRes_all.OrderEndDate
                                  , tmpRes_all.OrderPrice
                                  , tmpRes_all.SaleStartDate
                                  , tmpRes_all.SaleEndDate
                                  , tmpRes_all.SalePrice
                                  , tmpRes_all.ReturnStartDate
                                  , tmpRes_all.ReturnEndDate
                                  , tmpRes_all.ReturnPrice
                                  , tmpRes_all.isSync
                                    -- № п/п
                                  , ROW_NUMBER() OVER (PARTITION BY tmpRes_all.GoodsId, tmpRes_all.PriceListId ORDER BY tmpRes_all.Id ASC) AS Ord
                                    -- № п/п
                                  , ROW_NUMBER() OVER (PARTITION BY tmpRes_all.GoodsId, tmpRes_all.PriceListId ORDER BY tmpRes_all.OrderPrice DESC) AS Ord_price
                             FROM tmpRes_all
                            )
             -- Результат
             SELECT tmpRes.Id
                  , CASE WHEN tmpRes.Ord = 1 THEN tmpRes.GoodsId     ELSE 0  END :: Integer AS GoodsId
                  , CASE WHEN tmpRes.Ord = 1 THEN tmpRes.GoodsId     ELSE 0  END :: Integer AS GoodsId_key
                  , 0 :: Integer AS GoodsKindId
                  , CASE WHEN tmpRes.Ord = 1 THEN tmpRes.PriceListId ELSE -1 END :: Integer AS PriceListId
                  , COALESCE (tmpRes_ch.OrderStartDate, tmpRes.OrderStartDate)   :: TDateTime AS OrderStartDate
                  , COALESCE (tmpRes_ch.OrderEndDate, tmpRes.OrderEndDate)       :: TDateTime AS OrderEndDate
                  , CASE WHEN tmpRes.Ord = 1 THEN COALESCE (tmpRes_ch.OrderPrice,  tmpRes.OrderPrice)  ELSE 0 END :: TFloat AS OrderPrice
                  , COALESCE (tmpRes_ch.SaleStartDate, tmpRes.SaleStartDate)     :: TDateTime AS SaleStartDate
                  , COALESCE (tmpRes_ch.SaleEndDate, tmpRes.SaleEndDate)         :: TDateTime AS SaleEndDate
                  , CASE WHEN tmpRes.Ord = 1 THEN COALESCE (tmpRes_ch.SalePrice,   tmpRes.SalePrice)   ELSE 0 END :: TFloat AS SalePrice
                  , COALESCE (tmpRes_ch.ReturnStartDate, tmpRes.ReturnStartDate) :: TDateTime AS ReturnStartDate
                  , COALESCE (tmpRes_ch.ReturnEndDate, tmpRes.ReturnEndDate)     :: TDateTime AS ReturnEndDate
                  , CASE WHEN tmpRes.Ord = 1 THEN COALESCE (tmpRes_ch.ReturnPrice, tmpRes.ReturnPrice) ELSE 0 END :: TFloat AS ReturnPrice
                  , tmpRes.isSync
             FROM tmpRes
                  LEFT JOIN tmpRes AS tmpRes_ch ON tmpRes_ch.GoodsId     = tmpRes.GoodsId
                                               AND tmpRes_ch.PriceListId = tmpRes.PriceListId
                                               AND tmpRes_ch.Ord_price   = 1
             ORDER BY tmpRes.GoodsId
                    , tmpRes.PriceListId
                  --, ObjectHistory_PriceListItem_Return.StartDate DESC
             LIMIT CASE WHEN vbUserId = zfCalc_UserMobile_limit0() THEN 0 ELSE 500000 END
            ;

      END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 17.02.17                                                         *
*/

-- тест
-- SELECT * FROM gpSelectMobile_Object_PriceListItems (inSyncDateIn := zc_DateStart(), inSession := '1059546') WHERE GoodsId = 1045379 and PriceListId = zc_PriceList_Basis()
-- SELECT * FROM gpSelectMobile_Object_PriceListItems (inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())
-- SELECT * FROM gpSelectMobile_Object_PriceListItems (inSyncDateIn := zc_DateStart(), inSession := '1000137')
SELECT * FROM gpSelectMobile_Object_PriceListItems (inSyncDateIn := zc_DateStart(), inSession := '5')
  where                              GoodsId_key = 2755
 and PriceListId = 18840