-- Function: gpSelectMobile_Object_PriceListItems (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_PriceListItems (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_PriceListItems (
    IN inSyncDateIn TDateTime, -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id              Integer
             , GoodsId         Integer   -- Товар
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

      if vbUserId = 5 then vbUserId:= 1000137; end if;

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
                                                 , ObjectLink_Contract_PriceList.ChildObjectId
                                                 , ObjectLink_Juridical_PriceList.ChildObjectId
                                                 , zc_PriceList_Basis()) AS PriceListId
                                   FROM tmpPartner
                                        LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList
                                                             ON ObjectLink_Partner_PriceList.ObjectId = tmpPartner.PartnerId
                                                            AND ObjectLink_Partner_PriceList.DescId = zc_ObjectLink_Partner_PriceList()
                                        LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                                             ON ObjectLink_Juridical_PriceList.ObjectId = tmpPartner.JuridicalId
                                                            AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()
                                        LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                             ON ObjectLink_Contract_Juridical.ChildObjectId = tmpPartner.JuridicalId
                                                            AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                        LEFT JOIN ObjectLink AS ObjectLink_Contract_PriceList
                                                             ON ObjectLink_Contract_PriceList.ObjectId = ObjectLink_Contract_Juridical.ObjectId
                                                            AND ObjectLink_Contract_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
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
                                  )
                , tmpGoods AS (SELECT DISTINCT tmp.GoodsId FROM gpSelectMobile_Object_GoodsByGoodsKind (inSyncDateIn, inSession) AS tmp)
             SELECT Object_PriceListItem.Id
                  , ObjectLink_PriceListItem_Goods.ChildObjectId            AS GoodsId
                  , ObjectLink_PriceListItem_PriceList.ChildObjectId        AS PriceListId
                  , ObjectHistory_PriceListItem_Order.StartDate             AS OrderStartDate
                  , ObjectHistory_PriceListItem_Order.EndDate               AS OrderEndDate
                  , ObjectHistoryFloat_PriceListItem_Value_Order.ValueData  AS OrderPrice
                  , ObjectHistory_PriceListItem_Sale.StartDate              AS SaleStartDate
                  , ObjectHistory_PriceListItem_Sale.EndDate                AS SaleEndDate
                  , ObjectHistoryFloat_PriceListItem_Value_Sale.ValueData   AS SalePrice
                  , ObjectHistory_PriceListItem_Return.StartDate            AS ReturnStartDate
                  , ObjectHistory_PriceListItem_Return.EndDate              AS ReturnEndDate
                  , ObjectHistoryFloat_PriceListItem_Value_Return.ValueData AS ReturnPrice
                  , TRUE :: Boolean                                         AS isSync
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

             WHERE Object_PriceListItem.DescId = zc_Object_PriceListItem()
               AND ((ABS (COALESCE (ObjectHistoryFloat_PriceListItem_Value_Order.ValueData, 0.0)) 
                   + ABS (COALESCE (ObjectHistoryFloat_PriceListItem_Value_Sale.ValueData, 0.0))) <> 0.0)
               AND ObjectLink_PriceListItem_GoodsKind.ChildObjectId IS NULL

             ORDER BY ObjectLink_PriceListItem_PriceList.ChildObjectId
                    , ObjectLink_PriceListItem_Goods.ChildObjectId
                    , ObjectHistory_PriceListItem_Return.StartDate DESC
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
