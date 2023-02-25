-- Function: gpSelectMobile_Object_GoodsKind (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_GoodsKind (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_GoodsKind (
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
      -- !!!ВРЕМЕННО!!!
      inSyncDateIn:= zc_DateStart();

      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      vbPersonalId:= (SELECT PersonalId FROM gpGetMobile_Object_Const (inSession));

      -- Результат
      IF vbPersonalId IS NOT NULL
      THEN
           RETURN QUERY
             WITH tmpProtocol AS (SELECT ObjectProtocol.ObjectId AS GoodsKindId, MAX(ObjectProtocol.OperDate) AS MaxOperDate
                                  FROM ObjectProtocol
                                       JOIN Object AS Object_GoodsKind
                                                   ON Object_GoodsKind.Id = ObjectProtocol.ObjectId
                                                  AND Object_GoodsKind.DescId = zc_Object_GoodsKind() 
                                  WHERE inSyncDateIn > zc_DateStart()
                                    AND ObjectProtocol.OperDate > inSyncDateIn
                                  GROUP BY ObjectProtocol.ObjectId
                                 )
                , tmpPartner AS (SELECT OP.Id AS PartnerId FROM lfSelectMobile_Object_Partner (inIsErased:= FALSE, inSession:= inSession) AS OP)
                , tmpGoodsKind AS (SELECT ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId AS GoodsKindId
                                        , COUNT(ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId) AS GoodsKindCount
                                   FROM Object AS Object_GoodsListSale
                                        JOIN ObjectLink AS ObjectLink_GoodsListSale_Goods 
                                                        ON ObjectLink_GoodsListSale_Goods.ObjectId = Object_GoodsListSale.Id
                                                       AND ObjectLink_GoodsListSale_Goods.DescId = zc_ObjectLink_GoodsListSale_Goods()
                                                       AND ObjectLink_GoodsListSale_Goods.ChildObjectId IS NOT NULL
                                        JOIN ObjectLink AS ObjectLink_GoodsListSale_Partner
                                                        ON ObjectLink_GoodsListSale_Partner.ObjectId = Object_GoodsListSale.Id
                                                       AND ObjectLink_GoodsListSale_Partner.DescId = zc_ObjectLink_GoodsListSale_Partner()
                                                       AND ObjectLink_GoodsListSale_Partner.ChildObjectId IS NOT NULL
                                        JOIN tmpPartner ON tmpPartner.PartnerId = ObjectLink_GoodsListSale_Partner.ChildObjectId
                                        JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                                        ON ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = ObjectLink_GoodsListSale_Goods.ChildObjectId
                                                       AND ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                                       AND ObjectLink_GoodsByGoodsKind_Goods.ObjectId IS NOT NULL
                                        JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                        ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                       AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                                       AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId IS NOT NULL
                                   WHERE Object_GoodsListSale.DescId = zc_Object_GoodsListSale()
                                   GROUP BY ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId
                                  )
                , tmpFilter AS (SELECT tmpProtocol.GoodsKindId FROM tmpProtocol
                                UNION
                                SELECT tmpGoodsKind.GoodsKindId FROM tmpGoodsKind WHERE inSyncDateIn <= zc_DateStart()
                               ) 
             SELECT Object_GoodsKind.Id
                  , Object_GoodsKind.ObjectCode
                  , Object_GoodsKind.ValueData 
                  , Object_GoodsKind.isErased
                --, (tmpGoodsKind.GoodsKindId IS NOT NULL) AS isSync
                  , TRUE AS isSync
             FROM Object AS Object_GoodsKind
                  -- JOIN tmpFilter ON tmpFilter.GoodsKindId = Object_GoodsKind.Id
                  -- LEFT JOIN tmpGoodsKind ON tmpGoodsKind.GoodsKindId = Object_GoodsKind.Id
             WHERE Object_GoodsKind.DescId = zc_Object_GoodsKind()
           --LIMIT CASE WHEN vbUserId = 1072129 THEN 0 ELSE 500000 END
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
-- SELECT * FROM gpSelectMobile_Object_GoodsKind(inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())
