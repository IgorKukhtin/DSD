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
     vbUserId_Mobile:= (SELECT lfGet.UserId FROM lfGet_User_MobileCheck (inMemberId:= inMemberId, inUserId:= vbUserId) AS lfGet);


     -- Результат
     RETURN QUERY
       SELECT gpSelect.Id
            , Object_Goods.Id             AS GoodsId
            , Object_Goods.ObjectCode     AS GoodsCode
            , Object_Goods.ValueData      AS GoodsName
            , Object_GoodsKind.Id         AS GoodsKindId
            , Object_GoodsKind.ValueData  AS GoodsKindName
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