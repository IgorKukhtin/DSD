-- Function: gpSelect_Object_GoodsListSale_Mobile (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsListSale_Mobile (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsListSale_Mobile (
     IN inMemberId       Integer  , -- физ.лицо
     IN inSession        TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id             Integer
             , GoodsId        Integer  -- Товар
             , GoodsCode      Integer  -- Товар
             , GoodsName      TVarChar -- Товар
             , GoodsKindId    Integer  -- Вид товара
             , GoodsKindName  TVarChar -- Вид товара
             , GoodsGroupNameFull TVarChar --
             , InfoMoneyName_all  TVarChar --
             , PartnerId      Integer  -- Контрагент
             , PartnerCode    Integer  -- Контрагент
             , PartnerName    TVarChar --
             , AmountCalc     TFloat   -- Предварительное значение, потом используется для расчета на мобильном  устройстве "рекомендованного заказа", формируется в Главной БД = предыдущий остаток факт на ТТ + Реализация на ТТ - Возвраты с ТТ, причем все это за "определенный" период
             , isErased       Boolean  -- Удаленный ли элемент
             , isSync         Boolean  -- Синхронизируется (да/нет)
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
       SELECT gpSelect.Id
            , Object_Goods.Id             AS GoodsId
            , Object_Goods.ObjectCode     AS GoodsCode
            , Object_Goods.ValueData      AS GoodsName
            , Object_GoodsKind.Id         AS GoodsKindId
            , Object_GoodsKind.ValueData  AS GoodsKindName
            , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , Object_InfoMoney_View.InfoMoneyName_all
            , Object_Partner.Id           AS PartnerId
            , Object_Partner.ObjectCode   AS PartnerCode
            , Object_Partner.ValueData    AS PartnerName
            , gpSelect.AmountCalc
            , gpSelect.isErased
            , gpSelect.isSync
       FROM gpSelectMobile_Object_GoodsListSale (zc_DateStart(), vbUserId_Mobile :: TVarChar) AS gpSelect
            LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = gpSelect.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = gpSelect.GoodsKindId
            LEFT JOIN Object AS Object_Partner   ON Object_Partner.Id   = gpSelect.PartnerId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 10.03.17         *
*/

-- тест
-- select * from gpSelect_Object_GoodsListSale_Mobile(inMemberId := 149833 ,  inSession := '5'::TVarChar);