-- Function: gpSelect_Object_PriceListItems_Mobile (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_PriceListItems_Mobile (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PriceListItems_Mobile (
     IN inMemberId   Integer  , -- физ.лицо
     IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id             Integer
             , GoodsId        Integer   -- Товар
             , GoodsCode      Integer
             , GoodsName      TVarChar
             , GoodsGroupName     TVarChar -- Группа товара
             , GoodsGroupNameFull TVarChar --
             , PriceListId    Integer   -- Прайс-лист
             , PriceListName  TVarChar
             , OrderStartDate TDateTime -- Дата с которой действует цена заявки
             , OrderEndDate   TDateTime -- Дата до которой действует цена заявки
             , OrderPrice     TFloat    -- Цена заявки
             , SaleStartDate  TDateTime -- Дата с которой действует цена отгрузки
             , SaleEndDate    TDateTime -- Дата до которой действует цена отгрузки
             , SalePrice      TFloat    -- Цена отгрузки
             , ReturnStartDate TDateTime -- Дата с которой действует цена возврата
             , ReturnEndDate   TDateTime -- Дата до которой действует цена возврата
             , ReturnPrice     TFloat    -- Цена возврата
             , isSync         Boolean   -- Синхронизируется (да/нет)
              )
AS
$BODY$
   DECLARE vbUserId        Integer;
   DECLARE vbUserId_Mobile Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!меняем значение!!! - с какими параметрами пользователь может просматривать данные с мобильного устройства
     vbUserId_Mobile:= (SELECT CASE WHEN lfGet.UserId > 0 THEN lfGet.UserId ELSE vbUserId END FROM lfGet_User_MobileCheck (inMemberId:= inMemberId, inUserId:= vbUserId) AS lfGet);


     -- Результат
     RETURN QUERY
       SELECT tmpMobilePriceListItems.Id
            , Object_Goods.Id             AS GoodsId
            , Object_Goods.ObjectCode     AS GoodsCode
            , Object_Goods.ValueData      AS GoodsName
            , Object_GoodsGroup.ValueData AS GoodsGroupName
            , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , Object_PriceList.Id         AS PriceListId
            , Object_PriceList.ValueData  AS PriceListName

            , tmpMobilePriceListItems.OrderStartDate
            , tmpMobilePriceListItems.OrderEndDate
            , tmpMobilePriceListItems.OrderPrice
            , tmpMobilePriceListItems.SaleStartDate
            , tmpMobilePriceListItems.SaleEndDate
            , tmpMobilePriceListItems.SalePrice

            , tmpMobilePriceListItems.ReturnStartDate
            , tmpMobilePriceListItems.ReturnEndDate
            , tmpMobilePriceListItems.ReturnPrice
                  
            , tmpMobilePriceListItems.isSync

        FROM gpSelectMobile_Object_PriceListItems (zc_DateStart(), vbUserId_Mobile :: TVarChar) AS tmpMobilePriceListItems
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMobilePriceListItems.GoodsId
             LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = tmpMobilePriceListItems.PriceListId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                  ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
             LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

             LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                    ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                   AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
        ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 17.03.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_PriceListItems_Mobile (inMemberId:= 0, inSession := zfCalc_UserAdmin())
