-- Function: gpGet_Partion_byBarcode()

DROP FUNCTION IF EXISTS gpGet_Partion_byBarcode (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Partion_byBarcode(
    IN inBarCode           TVarChar   , --
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (GoodsId    Integer
             , PartionId  Integer
             , PriceSale  TFloat
              )
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbPartionId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inBarcode, '') <> '' 
     THEN
         vbPartionId := (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4))) :: Integer;
     ELSE 
         RAISE EXCEPTION 'Ошибка.Товар не найден.';
     END IF;
     
     IF NOT EXISTS (SELECT Object_PartionGoods.MovementItemId AS PartionId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = vbPartionId)
     THEN
         RAISE EXCEPTION 'Ошибка.Товар не найден.';
     END IF;
     
     -- Результат
     RETURN QUERY
       
       SELECT Object_PartionGoods.GoodsId        AS GoodsId
            , Object_PartionGoods.MovementItemId AS PartionId
            , Object_PartionGoods.PriceSale ::TFloat  AS PriceSale
       FROM Object_PartionGoods
       WHERE Object_PartionGoods.MovementItemId = vbPartionId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 28.12.17         *
*/

-- тест
-- SELECT * FROM gpGet_Partion_byBarcode (inBarCode:= '2010002606122', inSession:= zfCalc_UserAdmin());
