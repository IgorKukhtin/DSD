-- Function: gpSelectMobile_Object_GoodsGroup (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_GoodsGroup (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_GoodsGroup (
    IN inSyncDateIn TDateTime, -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id         Integer
             , ObjectCode Integer  -- Код
             , ValueData  TVarChar -- Название
             , isErased   Boolean  -- Удаленный ли элемент
             , isSync     Boolean  -- Синхронизируется (да/нет)
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
           RETURN QUERY
             WITH tmpProtocol AS (SELECT ObjectProtocol.ObjectId AS GoodsGroupId, MAX(ObjectProtocol.OperDate) AS MaxOperDate
                                  FROM ObjectProtocol
                                       JOIN Object AS Object_GoodsGroup
                                                   ON Object_GoodsGroup.Id = ObjectProtocol.ObjectId
                                                  AND Object_GoodsGroup.DescId = zc_Object_GoodsGroup() 
                                  WHERE ObjectProtocol.OperDate > inSyncDateIn
                                  GROUP BY ObjectProtocol.ObjectId
                                 )
                , tmpGoodsGroup AS (SELECT ObjectLink_Goods_GoodsGroup.ChildObjectId AS GoodsGroupId
                                         , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
                                         , COUNT(ObjectLink_Goods_GoodsGroup.ChildObjectId) AS GoodsGroupCount
                                    FROM Object AS Object_GoodsListSale
                                         JOIN ObjectLink AS ObjectLink_GoodsListSale_Goods 
                                                         ON ObjectLink_GoodsListSale_Goods.ObjectId = Object_GoodsListSale.Id
                                                        AND ObjectLink_GoodsListSale_Goods.DescId = zc_ObjectLink_GoodsListSale_Goods()
                                                        AND ObjectLink_GoodsListSale_Goods.ChildObjectId IS NOT NULL
                                         JOIN ObjectLink AS ObjectLink_GoodsListSale_Partner
                                                         ON ObjectLink_GoodsListSale_Partner.ObjectId = Object_GoodsListSale.Id
                                                        AND ObjectLink_GoodsListSale_Partner.DescId = zc_ObjectLink_GoodsListSale_Partner()
                                                        AND ObjectLink_GoodsListSale_Partner.ChildObjectId IS NOT NULL
                                         JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                                         ON ObjectLink_Partner_PersonalTrade.ObjectId = ObjectLink_GoodsListSale_Partner.ChildObjectId
                                                        AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                                        AND ObjectLink_Partner_PersonalTrade.ChildObjectId = vbPersonalId
                                         JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup 
                                                         ON ObjectLink_Goods_GoodsGroup.ObjectId = ObjectLink_GoodsListSale_Goods.ChildObjectId
                                                        AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup() 
                                                        AND ObjectLink_Goods_GoodsGroup.ChildObjectId IS NOT NULL
                                         JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                                           ON ObjectString_Goods_GroupNameFull.ObjectId = ObjectLink_GoodsListSale_Goods.ChildObjectId
                                                          AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull() 
                                    WHERE Object_GoodsListSale.DescId = zc_Object_GoodsListSale()
                                    GROUP BY ObjectLink_Goods_GoodsGroup.ChildObjectId
                                           , ObjectString_Goods_GroupNameFull.ValueData
                                   )                 
             SELECT Object_GoodsGroup.Id
                  , Object_GoodsGroup.ObjectCode
                  , tmpGoodsGroup.GoodsGroupNameFull AS ValueData
                  , Object_GoodsGroup.isErased
                  , (tmpGoodsGroup.GoodsGroupId IS NOT NULL) AS isSync
             FROM Object AS Object_GoodsGroup
                  JOIN tmpProtocol ON tmpProtocol.GoodsGroupId = Object_GoodsGroup.Id
                  LEFT JOIN tmpGoodsGroup ON tmpGoodsGroup.GoodsGroupId = Object_GoodsGroup.Id
             WHERE Object_GoodsGroup.DescId = zc_Object_GoodsGroup();
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
-- SELECT * FROM gpSelectMobile_Object_GoodsGroup(inSyncDateIn := CURRENT_TIMESTAMP - Interval '10 day', inSession := zfCalc_UserAdmin())
