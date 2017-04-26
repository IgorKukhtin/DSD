-- Function: gpSelectMobile_Object_PriceListItems (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_PriceListItems (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_PriceListItems (
    IN inSyncDateIn TDateTime, -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id             Integer
             , GoodsId        Integer   -- Товар
             , PriceListId    Integer   -- Прайс-лист
             , OrderStartDate TDateTime -- Дата с которой действует цена заявки
             , OrderEndDate   TDateTime -- Дата до которой действует цена заявки
             , OrderPrice     TFloat    -- Цена заявки
             , SaleStartDate  TDateTime -- Дата с которой действует цена отгрузки
             , SaleEndDate    TDateTime -- Дата до которой действует цена отгрузки
             , SalePrice      TFloat    -- Цена отгрузки
             , isSync         Boolean   -- Синхронизируется (да/нет)
              )
AS 
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- определяем идентификатор торгового агента
      vbPersonalId:= (SELECT PersonalId FROM gpGetMobile_Object_Const (inSession));

      -- если торговый агент не определен, то возвращать нечего
      IF vbPersonalId IS NOT NULL 
      THEN
           -- создаем список контрагентов, что доступны торговому агенту
           CREATE TEMP TABLE tmpPartner ON COMMIT DROP
           AS (SELECT ObjectLink_Partner_PersonalTrade.ObjectId AS PartnerId
               FROM ObjectLink AS ObjectLink_Partner_PersonalTrade
               WHERE ObjectLink_Partner_PersonalTrade.ChildObjectId = vbPersonalId 
                 AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
              );

           -- создаем список идентификаторов прайс-листов, что доступны торговому агенту 
           CREATE TEMP TABLE tmpPriceList ON COMMIT DROP
           AS (WITH -- определяем список контрагентов+юр.лиц, что доступны торговому агенту
                    tmpPartnerJuridical AS (SELECT tmpPartner.PartnerId
                                                 , COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, 0) AS JuridicalId
                                            FROM tmpPartner
                                                 LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                                      ON ObjectLink_Partner_Juridical.ObjectId = tmpPartner.PartnerId
                                                                     AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                           )
               SELECT COALESCE(ObjectLink_Partner_PriceList.ChildObjectId
                             , ObjectLink_Contract_PriceList.ChildObjectId
                             , ObjectLink_Juridical_PriceList.ChildObjectId
                             , zc_PriceList_Basis()) AS PriceListId
               FROM tmpPartnerJuridical
                    LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList
                                         ON ObjectLink_Partner_PriceList.ObjectId = tmpPartnerJuridical.PartnerId
                                        AND ObjectLink_Partner_PriceList.DescId = zc_ObjectLink_Partner_PriceList()
                    LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                         ON ObjectLink_Juridical_PriceList.ObjectId = tmpPartnerJuridical.JuridicalId
                                        AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()
                    LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                         ON ObjectLink_Contract_Juridical.ChildObjectId = tmpPartnerJuridical.JuridicalId
                                        AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                    LEFT JOIN ObjectLink AS ObjectLink_Contract_PriceList
                                         ON ObjectLink_Contract_PriceList.ObjectId = ObjectLink_Contract_Juridical.ObjectId
                                        AND ObjectLink_Contract_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
               UNION                                    
               SELECT COALESCE(ObjectLink_Partner_PriceListPrior.ChildObjectId
                             , ObjectLink_Juridical_PriceListPrior.ChildObjectId
                             , zc_PriceList_BasisPrior()) AS PriceListId
               FROM tmpPartnerJuridical
                    LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceListPrior
                                         ON ObjectLink_Partner_PriceListPrior.ObjectId = tmpPartnerJuridical.PartnerId
                                        AND ObjectLink_Partner_PriceListPrior.DescId = zc_ObjectLink_Partner_PriceListPrior()
                    LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceListPrior
                                         ON ObjectLink_Juridical_PriceListPrior.ObjectId = tmpPartnerJuridical.JuridicalId
                                        AND ObjectLink_Juridical_PriceListPrior.DescId = zc_ObjectLink_Juridical_PriceListPrior()
              );
                
           IF inSyncDateIn > zc_DateStart()
           THEN
                -- список прайс-листов по контрагентам, что изменились после inSyncDateIn
                CREATE TEMP TABLE tmpPriceListPartner ON COMMIT DROP
                AS (WITH tmpProtocol AS (SELECT ObjectProtocol.ObjectId AS PartnerId, MAX(ObjectProtocol.OperDate) AS MaxOperDate
                                         FROM ObjectProtocol                                                                               
                                              JOIN Object AS Object_Partner                                                              
                                                          ON Object_Partner.Id = ObjectProtocol.ObjectId
                                                         AND Object_Partner.DescId = zc_Object_Partner()
                                              JOIN tmpPartner ON tmpPartner.PartnerId = ObjectProtocol.ObjectId
                                         WHERE ObjectProtocol.OperDate > inSyncDateIn
                                         GROUP BY ObjectProtocol.ObjectId
                                        )
                    SELECT ObjectLink_Partner_PriceList.ChildObjectId AS PriceListId
                    FROM tmpProtocol
                         JOIN ObjectLink AS ObjectLink_Partner_PriceList
                                         ON ObjectLink_Partner_PriceList.ObjectId = tmpProtocol.PartnerId
                                        AND ObjectLink_Partner_PriceList.DescId = zc_ObjectLink_Partner_PriceList()
                                        AND ObjectLink_Partner_PriceList.ChildObjectId IS NOT NULL
                    UNION
                    SELECT ObjectLink_Partner_PriceListPrior.ChildObjectId AS PriceListId
                    FROM tmpProtocol
                         JOIN ObjectLink AS ObjectLink_Partner_PriceListPrior
                                         ON ObjectLink_Partner_PriceListPrior.ObjectId = tmpProtocol.PartnerId
                                        AND ObjectLink_Partner_PriceListPrior.DescId = zc_ObjectLink_Partner_PriceListPrior()
                                        AND ObjectLink_Partner_PriceListPrior.ChildObjectId IS NOT NULL
                   );

                -- список прайс-листов по юр.лицам, что изменились после inSyncDateIn
                CREATE TEMP TABLE tmpPriceListJuridical ON COMMIT DROP
                AS (WITH tmpProtocol AS (SELECT ObjectProtocol.ObjectId AS JuridicalId, MAX(ObjectProtocol.OperDate) AS MaxOperDate
                                         FROM ObjectProtocol                                                                               
                                              JOIN Object AS Object_Juridical                                                              
                                                          ON Object_Juridical.Id = ObjectProtocol.ObjectId
                                                         AND Object_Juridical.DescId = zc_Object_Juridical()
                                              JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                              ON ObjectLink_Partner_Juridical.ChildObjectId = ObjectProtocol.ObjectId
                                                             AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                              JOIN tmpPartner ON tmpPartner.PartnerId = ObjectLink_Partner_Juridical.ObjectId
                                         WHERE ObjectProtocol.OperDate > inSyncDateIn
                                         GROUP BY ObjectProtocol.ObjectId
                                        )
                    SELECT ObjectLink_Juridical_PriceList.ChildObjectId AS PriceListId
                    FROM tmpProtocol
                         JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                         ON ObjectLink_Juridical_PriceList.ObjectId = tmpProtocol.JuridicalId
                                        AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()
                                        AND ObjectLink_Juridical_PriceList.ChildObjectId IS NOT NULL
                    UNION
                    SELECT ObjectLink_Juridical_PriceListPrior.ChildObjectId AS PriceListId
                    FROM tmpProtocol
                         JOIN ObjectLink AS ObjectLink_Juridical_PriceListPrior
                                         ON ObjectLink_Juridical_PriceListPrior.ObjectId = tmpProtocol.JuridicalId
                                        AND ObjectLink_Juridical_PriceListPrior.DescId = zc_ObjectLink_Juridical_PriceListPrior()
                                        AND ObjectLink_Juridical_PriceListPrior.ChildObjectId IS NOT NULL
                   );

                -- список прайс-листов по договорам, что изменились после inSyncDateIn
                CREATE TEMP TABLE tmpPriceListContract ON COMMIT DROP
                AS (WITH tmpProtocol AS (SELECT ObjectProtocol.ObjectId AS ContractId, MAX(ObjectProtocol.OperDate) AS MaxOperDate
                                         FROM ObjectProtocol                                                                               
                                              JOIN Object AS Object_Contract
                                                          ON Object_Contract.Id = ObjectProtocol.ObjectId
                                                         AND Object_Contract.DescId = zc_Object_Contract()
                                              JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                              ON ObjectLink_Contract_Juridical.ObjectId = ObjectProtocol.ObjectId
                                                             AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                              JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                              ON ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Contract_Juridical.ChildObjectId
                                                             AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                              JOIN tmpPartner ON tmpPartner.PartnerId = ObjectLink_Partner_Juridical.ObjectId
                                         WHERE ObjectProtocol.OperDate > inSyncDateIn
                                         GROUP BY ObjectProtocol.ObjectId
                                        )
                    SELECT ObjectLink_Contract_PriceList.ChildObjectId AS PriceListId
                    FROM tmpProtocol
                         JOIN ObjectLink AS ObjectLink_Contract_PriceList
                                         ON ObjectLink_Contract_PriceList.ObjectId = tmpProtocol.ContractId
                                        AND ObjectLink_Contract_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
                                        AND ObjectLink_Contract_PriceList.ChildObjectId IS NOT NULL
                   );

                -- объединенный список позиций прайс-листов, что изменились после inSyncDateIn
                CREATE TEMP TABLE tmpPriceListItem ON COMMIT DROP
                AS (SELECT ObjectLink_PriceListItem_PriceList.ObjectId AS PriceListItemId
                    FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
                         JOIN (SELECT tmpPriceListPartner.PriceListId FROM tmpPriceListPartner
                               UNION
                               SELECT tmpPriceListJuridical.PriceListId FROM tmpPriceListJuridical
                               UNION
                               SELECT tmpPriceListContract.PriceListId FROM tmpPriceListContract
                              ) AS tmpPriceListSync
                           ON tmpPriceListSync.PriceListId = ObjectLink_PriceListItem_PriceList.ChildObjectId
                    WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                   );

                -- Результат
                RETURN QUERY
                  WITH tmpProtocol AS (SELECT ObjectProtocol.ObjectId AS PriceListItemId
                                       FROM ObjectProtocol                                                                               
                                            JOIN Object AS Object_PriceListItem                                                              
                                                        ON Object_PriceListItem.Id = ObjectProtocol.ObjectId
                                                       AND Object_PriceListItem.DescId = zc_Object_PriceListItem()
                                       WHERE ObjectProtocol.OperDate > inSyncDateIn
                                       UNION
                                       SELECT PriceListItemId FROM tmpPriceListItem
                                      )
                  SELECT Object_PriceListItem.Id
                       , ObjectLink_PriceListItem_Goods.ChildObjectId           AS GoodsId
                       , ObjectLink_PriceListItem_PriceList.ChildObjectId       AS PriceListId
                       , ObjectHistory_PriceListItem_Order.StartDate            AS OrderStartDate
                       , ObjectHistory_PriceListItem_Order.EndDate              AS OrderEndDate
                       , COALESCE (ObjectHistoryFloat_PriceListItem_Value_Order.ValueData, 0.0)::TFloat AS OrderPrice
                       , ObjectHistory_PriceListItem_Sale.StartDate             AS SaleStartDate
                       , ObjectHistory_PriceListItem_Sale.EndDate               AS SaleEndDate
                       , COALESCE (ObjectHistoryFloat_PriceListItem_Value_Sale.ValueData, 0.0)::TFloat  AS SalePrice
                       , tmpPriceList.PriceListId IS NOT NULL
                         AND ((ABS (COALESCE (ObjectHistoryFloat_PriceListItem_Value_Order.ValueData, 0.0)) 
                             + ABS (COALESCE (ObjectHistoryFloat_PriceListItem_Value_Sale.ValueData, 0.0))) <> 0.0) AS isSync
                  FROM Object AS Object_PriceListItem
                       JOIN tmpProtocol ON tmpProtocol.PriceListItemId = Object_PriceListItem.Id
                       JOIN ObjectLink AS ObjectLink_PriceListItem_Goods 
                                       ON ObjectLink_PriceListItem_Goods.ObjectId = Object_PriceListItem.Id
                                      AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                       JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                       ON ObjectLink_PriceListItem_PriceList.ObjectId = Object_PriceListItem.Id
                                      AND ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                       LEFT JOIN tmpPriceList ON tmpPriceList.PriceListId = ObjectLink_PriceListItem_PriceList.ChildObjectId
                       LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem_Order
                                               ON ObjectHistory_PriceListItem_Order.ObjectId = Object_PriceListItem.Id
                                              AND ObjectHistory_PriceListItem_Order.DescId = zc_ObjectHistory_PriceListItem() 
                                              AND CURRENT_DATE BETWEEN ObjectHistory_PriceListItem_Order.StartDate AND ObjectHistory_PriceListItem_Order.EndDate
                       LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value_Order
                                                    ON ObjectHistoryFloat_PriceListItem_Value_Order.ObjectHistoryId = ObjectHistory_PriceListItem_Order.Id
                                                   AND ObjectHistoryFloat_PriceListItem_Value_Order.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                       LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem_Sale
                                               ON ObjectHistory_PriceListItem_Sale.ObjectId = Object_PriceListItem.Id
                                              AND ObjectHistory_PriceListItem_Sale.DescId = zc_ObjectHistory_PriceListItem() 
                                              AND (CURRENT_DATE + 1) BETWEEN ObjectHistory_PriceListItem_Sale.StartDate AND ObjectHistory_PriceListItem_Sale.EndDate
                       LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value_Sale
                                                    ON ObjectHistoryFloat_PriceListItem_Value_Sale.ObjectHistoryId = ObjectHistory_PriceListItem_Sale.Id
                                                   AND ObjectHistoryFloat_PriceListItem_Value_Sale.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                  WHERE Object_PriceListItem.DescId = zc_Object_PriceListItem();
           ELSE
                -- Результат
                RETURN QUERY
                  SELECT Object_PriceListItem.Id
                       , ObjectLink_PriceListItem_Goods.ChildObjectId           AS GoodsId
                       , ObjectLink_PriceListItem_PriceList.ChildObjectId       AS PriceListId
                       , ObjectHistory_PriceListItem_Order.StartDate            AS OrderStartDate
                       , ObjectHistory_PriceListItem_Order.EndDate              AS OrderEndDate
                       , ObjectHistoryFloat_PriceListItem_Value_Order.ValueData AS OrderPrice
                       , ObjectHistory_PriceListItem_Sale.StartDate             AS SaleStartDate
                       , ObjectHistory_PriceListItem_Sale.EndDate               AS SaleEndDate
                       , ObjectHistoryFloat_PriceListItem_Value_Sale.ValueData  AS SalePrice
                       , CAST(true AS Boolean) AS isSync
                  FROM Object AS Object_PriceListItem
                       JOIN ObjectLink AS ObjectLink_PriceListItem_Goods 
                                       ON ObjectLink_PriceListItem_Goods.ObjectId = Object_PriceListItem.Id
                                      AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                       JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                       ON ObjectLink_PriceListItem_PriceList.ObjectId = Object_PriceListItem.Id
                                      AND ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                       JOIN tmpPriceList ON tmpPriceList.PriceListId = ObjectLink_PriceListItem_PriceList.ChildObjectId
                       LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem_Order
                                               ON ObjectHistory_PriceListItem_Order.ObjectId = Object_PriceListItem.Id
                                              AND ObjectHistory_PriceListItem_Order.DescId = zc_ObjectHistory_PriceListItem() 
                                              AND CURRENT_DATE BETWEEN ObjectHistory_PriceListItem_Order.StartDate AND ObjectHistory_PriceListItem_Order.EndDate
                       LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value_Order
                                                    ON ObjectHistoryFloat_PriceListItem_Value_Order.ObjectHistoryId = ObjectHistory_PriceListItem_Order.Id
                                                   AND ObjectHistoryFloat_PriceListItem_Value_Order.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                       LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem_Sale
                                               ON ObjectHistory_PriceListItem_Sale.ObjectId = Object_PriceListItem.Id
                                              AND ObjectHistory_PriceListItem_Sale.DescId = zc_ObjectHistory_PriceListItem() 
                                              AND (CURRENT_DATE + 1) BETWEEN ObjectHistory_PriceListItem_Sale.StartDate AND ObjectHistory_PriceListItem_Sale.EndDate
                       LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value_Sale
                                                    ON ObjectHistoryFloat_PriceListItem_Value_Sale.ObjectHistoryId = ObjectHistory_PriceListItem_Sale.Id
                                                   AND ObjectHistoryFloat_PriceListItem_Value_Sale.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                  WHERE Object_PriceListItem.DescId = zc_Object_PriceListItem()
                    AND ((ABS (COALESCE (ObjectHistoryFloat_PriceListItem_Value_Order.ValueData, 0.0)) 
                        + ABS (COALESCE (ObjectHistoryFloat_PriceListItem_Value_Sale.ValueData, 0.0))) <> 0.0);
           END IF;
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
-- SELECT * FROM gpSelectMobile_Object_PriceListItems(inSyncDateIn := zc_DateStart(), inSession := '1000168') WHERE GoodsId = 477449
-- SELECT * FROM gpSelectMobile_Object_PriceListItems(inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())
