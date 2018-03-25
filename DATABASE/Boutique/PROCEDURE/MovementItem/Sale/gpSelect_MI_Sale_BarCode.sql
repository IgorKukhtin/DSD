-- Function: gpSelect_MI_Sale_BarCode()

DROP FUNCTION IF EXISTS gpSelect_MI_Sale_BarCode (TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_Sale_BarCode(
     IN inBarCode              TVarChar,
     IN inBarCode_partner      TVarChar,
     IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (BarCode TVarChar, BarCode_partner TVarChar, BarCode_old TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Inventory());
     vbUserId:= lpGetUserBySession (inSession);


     -- Получили для Пользователя - к какому Подразделению он привязан
     vbUnitId:= lpGetUnit_byUser (vbUserId);


     -- Если Штрих-код Поставщика - ОБЯЗАТЕЛЕН
     IF EXISTS (SELECT 1 FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = vbUnitId AND ObjectBoolean.DescId = zc_ObjectBoolean_Unit_PartnerBarCode() AND ObjectBoolean.ValueData = TRUE)
     THEN
         IF COALESCE (inBarCode, '') <> '' AND COALESCE (inBarCode_partner, '') <> ''
         THEN
             -- Обнулили
             RETURN QUERY
               SELECT NULL :: TVarChar AS BarCode
                    , NULL :: TVarChar AS BarCode_partner
                    , NULL :: TVarChar AS BarCode_old
              ;

         ELSE
             -- нельзя Обнулять
             RETURN QUERY
               SELECT COALESCE (inBarCode, '')         :: TVarChar  AS BarCode
                    , COALESCE (inBarCode_partner, '') :: TVarChar  AS BarCode_str
                    , COALESCE (inBarCode, '')         :: TVarChar  AS BarCode_old
              ;

         END IF;

     ELSE
         -- Обнулили - ВСЕГДА
         RETURN QUERY
           SELECT NULL :: TVarChar AS BarCode
                , NULL :: TVarChar AS BarCode_partner
                , NULL :: TVarChar AS BarCode_old
          ;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 29.12.17         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_Sale_BarCode (inBarCode:= '', inBarCode_partner:= '', inSession:= zfCalc_UserAdmin());
