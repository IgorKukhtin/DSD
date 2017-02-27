-- Function: gpSelectMobile_Object_PriceListItems (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_PriceListItems (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_PriceListItems (
    IN inSyncDateIn TDateTime, -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id          Integer
             , GoodsId     Integer   -- Товар
             , PriceListId Integer   -- Прайс-лист
             , StartDate   TDateTime -- Дата с которой действует цена
             , EndDate     TDateTime -- Дата до которой действует цена
             , Price       TFloat    -- Цена
             , isSync      Boolean   -- Синхронизируется (да/нет)
              )
AS 
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      vbPersonalId:= (SELECT PersonalId FROM gpGetMobile_Object_Const (inSession));

      -- Результат
      IF vbPersonalId IS NOT NULL 
      THEN
           CREATE TEMP TABLE tmpPriceList ON COMMIT DROP
           AS (SELECT DISTINCT COALESCE(ObjectLink_Partner_PriceList.ChildObjectId
                                      , ObjectLink_Contract_PriceList.ChildObjectId
                                      , ObjectLink_Juridical_PriceList.ChildObjectId
                                      , zc_PriceList_Basis()) AS PriceListId
                             , COALESCE(ObjectLink_Partner_PriceListPrior.ChildObjectId
                                      , ObjectLink_Juridical_PriceListPrior.ChildObjectId
                                      , zc_PriceList_BasisPrior()) AS PriceListPriorId
               FROM ObjectLink AS ObjectLink_Partner_PersonalTrade
                    LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList
                                         ON ObjectLink_Partner_PriceList.ObjectId = ObjectLink_Partner_PersonalTrade.ObjectId
                                        AND ObjectLink_Partner_PriceList.DescId = zc_ObjectLink_Partner_PriceList()
                    LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceListPrior
                                         ON ObjectLink_Partner_PriceListPrior.ObjectId = ObjectLink_Partner_PersonalTrade.ObjectId
                                        AND ObjectLink_Partner_PriceListPrior.DescId = zc_ObjectLink_Partner_PriceListPrior()
                    LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                         ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner_PersonalTrade.ObjectId
                                        AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                    LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                         ON ObjectLink_Contract_Juridical.ChildObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                        AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                    LEFT JOIN ObjectLink AS ObjectLink_Contract_PriceList
                                         ON ObjectLink_Contract_PriceList.ObjectId = ObjectLink_Contract_Juridical.ObjectId
                                        AND ObjectLink_Contract_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
                    LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                         ON ObjectLink_Juridical_PriceList.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                        AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()
                    LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceListPrior
                                         ON ObjectLink_Juridical_PriceListPrior.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                        AND ObjectLink_Juridical_PriceListPrior.DescId = zc_ObjectLink_Juridical_PriceListPrior()
               WHERE ObjectLink_Partner_PersonalTrade.ChildObjectId = vbPersonalId
                 AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
              );
                
           IF inSyncDateIn > zc_DateStart()
           THEN
                RETURN QUERY
                  WITH tmpProtocol AS (SELECT ObjectProtocol.ObjectId AS PriceListItemId, MAX(ObjectProtocol.OperDate) AS MaxOperDate
                                       FROM ObjectProtocol                                                                               
                                            JOIN Object AS Object_PriceListItem                                                              
                                                        ON Object_PriceListItem.Id = ObjectProtocol.ObjectId                                 
                                                       AND Object_PriceListItem.DescId = zc_Object_PriceListItem()
                                       WHERE ObjectProtocol.OperDate > inSyncDateIn
                                       GROUP BY ObjectProtocol.ObjectId                                                                  
                                      )
                  SELECT Object_PriceListItem.Id
                       , ObjectLink_PriceListItem_Goods.ChildObjectId AS GoodsId
                       , ObjectLink_PriceListItem_PriceList.ChildObjectId AS PriceListId
                       , ObjectHistory_PriceListItem.StartDate
                       , ObjectHistory_PriceListItem.EndDate
                       , ObjectHistoryFloat_PriceListItem_Value.ValueData AS Price
                       , (COALESCE(ObjectHistoryFloat_PriceListItem_Value.ValueData, 0.0) <> 0.0)
                         AND EXISTS(SELECT 1 FROM tmpPriceList 
                                    WHERE ObjectLink_PriceListItem_PriceList.ChildObjectId IN (tmpPriceList.PriceListId, tmpPriceList.PriceListPriorId)) AS isSync
                  FROM Object AS Object_PriceListItem
                       JOIN tmpProtocol ON tmpProtocol.PriceListItemId = Object_PriceListItem.Id
                       JOIN ObjectLink AS ObjectLink_PriceListItem_Goods 
                                       ON ObjectLink_PriceListItem_Goods.ObjectId = Object_PriceListItem.Id
                                      AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                       JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                       ON ObjectLink_PriceListItem_PriceList.ObjectId = Object_PriceListItem.Id
                                      AND ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                       LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                               ON ObjectHistory_PriceListItem.ObjectId = Object_PriceListItem.Id
                                              AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem() 
                                              AND CURRENT_DATE BETWEEN ObjectHistory_PriceListItem.StartDate AND ObjectHistory_PriceListItem.EndDate
                       LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                    ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                   AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                  WHERE Object_PriceListItem.DescId = zc_Object_PriceListItem();
           ELSE
                RETURN QUERY
                  SELECT Object_PriceListItem.Id
                       , ObjectLink_PriceListItem_Goods.ChildObjectId AS GoodsId
                       , ObjectLink_PriceListItem_PriceList.ChildObjectId AS PriceListId
                       , ObjectHistory_PriceListItem.StartDate
                       , ObjectHistory_PriceListItem.EndDate
                       , ObjectHistoryFloat_PriceListItem_Value.ValueData AS Price
                       , CAST(true AS Boolean) AS isSync
                  FROM Object AS Object_PriceListItem
                       JOIN ObjectLink AS ObjectLink_PriceListItem_Goods 
                                       ON ObjectLink_PriceListItem_Goods.ObjectId = Object_PriceListItem.Id
                                      AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                       JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                       ON ObjectLink_PriceListItem_PriceList.ObjectId = Object_PriceListItem.Id
                                      AND ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                       LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                               ON ObjectHistory_PriceListItem.ObjectId = Object_PriceListItem.Id
                                              AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem() 
                                              AND CURRENT_DATE BETWEEN ObjectHistory_PriceListItem.StartDate AND ObjectHistory_PriceListItem.EndDate
                       LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                    ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                   AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                  WHERE Object_PriceListItem.DescId = zc_Object_PriceListItem()
                    AND (COALESCE(ObjectHistoryFloat_PriceListItem_Value.ValueData, 0.0) <> 0.0)
                    AND EXISTS(SELECT 1 FROM tmpPriceList 
                               WHERE ObjectLink_PriceListItem_PriceList.ChildObjectId IN (tmpPriceList.PriceListId, tmpPriceList.PriceListPriorId));
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
-- SELECT * FROM gpSelectMobile_Object_PriceListItems(inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())
