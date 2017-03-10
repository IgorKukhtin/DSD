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
   DECLARE vbUserId Integer;
   DECLARE vbMemberId Integer;
   DECLARE calcSession TVarChar;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

     vbMemberId:= (SELECT tmp.MemberId FROM gpGetMobile_Object_Const (inSession) AS tmp);
     IF (COALESCE(inMemberId,0) <> 0 AND COALESCE(vbMemberId,0) <> inMemberId)
        THEN
            RAISE EXCEPTION 'Ошибка.Не достаточно прав доступа.'; 
     END IF;

     calcSession := (SELECT CAST (ObjectLink_User_Member.ObjectId AS TVarChar) 
                     FROM ObjectLink AS ObjectLink_User_Member
                     WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                       AND ObjectLink_User_Member.ChildObjectId = vbMemberId);

     -- Результат
     RETURN QUERY
       -- Результат
       SELECT tmpMobileGoodsListSale.Id
            , Object_Goods.Id             AS GoodsId
            , Object_Goods.ObjectCode     AS GoodsCode
            , Object_Goods.ValueData      AS GoodsName
            , Object_GoodsKind.Id         AS GoodsKindId 
            , Object_GoodsKind.ValueData  AS GoodsKindName
            , Object_Partner.Id           AS PartnerId
            , Object_Partner.ObjectCode   AS PartnerCode
            , Object_Partner.ValueData    AS PartnerName
            , tmpMobileGoodsListSale.AmountCalc
            , tmpMobileGoodsListSale.isErased
            , tmpMobileGoodsListSale.isSync
       FROM gpSelectMobile_Object_GoodsListSale (zc_DateStart(), calcSession) AS tmpMobileGoodsListSale
               LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMobileGoodsListSale.GoodsId 
               LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMobileGoodsListSale.GoodsKindId 
               LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpMobileGoodsListSale.PartnerId
       WHERE tmpMobileGoodsListSale.isSync = TRUE
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