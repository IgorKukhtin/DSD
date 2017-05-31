-- Function: gpSelect_Object_GoodsLinkGoodsKind_Mobile (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsLinkGoodsKind_Mobile (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsLinkGoodsKind_Mobile (
     IN inMemberId   Integer  , -- физ.лицо
     IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id                 Integer
             , GoodsId            Integer  -- Товар
             , GoodsCode          Integer  -- Товар
             , GoodsName          TVarChar -- Товар
             , GoodsKindId        Integer  -- Вид товара
             , GoodsKindName      TVarChar -- Вид товара
             , GoodsGroupName     TVarChar -- Группа товара
             , GoodsGroupNameFull TVarChar --
             , Remains            TFloat   -- Остаток на  складе vbUnitId
             , Forecast           TFloat   -- Прогноз прихода на vbUnitId
             , isErased           Boolean  -- Удаленный ли элемент
             , isSync             Boolean  -- Синхронизируется (да/нет)
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


      -- !!!меняем значение!!! - с какими параметрами пользователь может просматривать данные с мобильного устройства
     IF NOT EXISTS (SELECT 1 FROM ObjectBoolean WHERE ObjectBoolean.DescId = zc_ObjectBoolean_User_ProjectMobile() AND ObjectBoolean.ObjectId = vbUserId AND ObjectBoolean.ValueData = TRUE)
        OR inSession = zfCalc_UserAdmin()
     THEN
         -- Если пользователь inSession - НЕ Торговый агент - видит ВСЕ
         vbMemberId:= 0; calcSession:= '';
     ELSE
         --
         vbMemberId:= (SELECT tmp.MemberId FROM gpGetMobile_Object_Const (inSession) AS tmp);
         --
         calcSession := (SELECT CAST (ObjectLink_User_Member.ObjectId AS TVarChar)
                         FROM ObjectLink AS ObjectLink_User_Member
                         WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                           AND ObjectLink_User_Member.ChildObjectId = vbMemberId);
         --
         IF COALESCE (vbMemberId, 0) <> inMemberId
         THEN
              RAISE EXCEPTION 'Ошибка.Не достаточно прав доступа.';
         END IF;
     END IF;


     -- Результат
     RETURN QUERY
       SELECT tmpMobileGoodsByGoodsKind.Id
            , Object_Goods.Id             AS GoodsId
            , Object_Goods.ObjectCode     AS GoodsCode
            , Object_Goods.ValueData      AS GoodsName
            , Object_GoodsKind.Id         AS GoodsKindId
            , Object_GoodsKind.ValueData  AS GoodsKindName
            , Object_GoodsGroup.ValueData AS GoodsGroupName
            , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , tmpMobileGoodsByGoodsKind.Remains
            , tmpMobileGoodsByGoodsKind.Forecast
            , tmpMobileGoodsByGoodsKind.isErased
            , tmpMobileGoodsByGoodsKind.isSync
       FROM gpSelectMobile_Object_GoodsByGoodsKind (zc_DateStart(), calcSession) AS tmpMobileGoodsByGoodsKind
               LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMobileGoodsByGoodsKind.GoodsId
               LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMobileGoodsByGoodsKind.GoodsKindId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                  ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
             LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

             LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                    ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                   AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

       WHERE tmpMobileGoodsByGoodsKind.isSync = TRUE
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
-- SELECT * FROM gpSelect_Object_GoodsLinkGoodsKind_Mobile (inMemberId:= 1, inSession := zfCalc_UserAdmin())
