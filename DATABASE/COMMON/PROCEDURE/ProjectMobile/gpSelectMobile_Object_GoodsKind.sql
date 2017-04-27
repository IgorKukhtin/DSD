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
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      vbPersonalId:= (SELECT PersonalId FROM gpGetMobile_Object_Const (inSession));

      -- Результат
      IF vbPersonalId IS NOT NULL
      THEN
           CREATE TEMP TABLE tmpGoodsKind ON COMMIT DROP
           AS (SELECT ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId AS GoodsKindId
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
                    JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                    ON ObjectLink_Partner_PersonalTrade.ObjectId = ObjectLink_GoodsListSale_Partner.ChildObjectId
                                   AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                   AND ObjectLink_Partner_PersonalTrade.ChildObjectId = vbPersonalId
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
              );
           
           -- Убрал, есть ошибка у одного торгового - пусть выгружется ВСЕ
           IF 1 = 0 -- inSyncDateIn > zc_DateStart()
           THEN
                RETURN QUERY
                  WITH tmpProtocol AS (SELECT ObjectProtocol.ObjectId AS GoodsKindId, MAX(ObjectProtocol.OperDate) AS MaxOperDate
                                       FROM ObjectProtocol
                                            JOIN Object AS Object_GoodsKind
                                                        ON Object_GoodsKind.Id = ObjectProtocol.ObjectId
                                                       AND Object_GoodsKind.DescId = zc_Object_GoodsKind() 
                                       WHERE ObjectProtocol.OperDate > inSyncDateIn
                                       GROUP BY ObjectProtocol.ObjectId
                                      )
                  SELECT Object_GoodsKind.Id
                       , Object_GoodsKind.ObjectCode
                       , Object_GoodsKind.ValueData 
                       , Object_GoodsKind.isErased
                       , EXISTS(SELECT 1 FROM tmpGoodsKind WHERE tmpGoodsKind.GoodsKindId = Object_GoodsKind.Id) AS isSync
                  FROM Object AS Object_GoodsKind
                       JOIN tmpProtocol ON tmpProtocol.GoodsKindId = Object_GoodsKind.Id
                  WHERE Object_GoodsKind.DescId = zc_Object_GoodsKind();
           ELSE
                RETURN QUERY
                  SELECT Object_GoodsKind.Id
                       , Object_GoodsKind.ObjectCode
                       , Object_GoodsKind.ValueData 
                       , Object_GoodsKind.isErased
                       , TRUE AS isSync
                  FROM Object AS Object_GoodsKind
                  WHERE Object_GoodsKind.DescId   = zc_Object_GoodsKind()
                    AND Object_GoodsKind.isErased = FALSE
                    AND EXISTS(SELECT 1 FROM tmpGoodsKind WHERE tmpGoodsKind.GoodsKindId = Object_GoodsKind.Id)
                 ;
                 
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
-- SELECT * FROM gpSelectMobile_Object_GoodsKind(inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())
