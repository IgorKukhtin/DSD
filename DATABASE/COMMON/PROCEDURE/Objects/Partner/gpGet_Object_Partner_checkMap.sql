-- Function: gpGet_Object_Partner_checkMap()

DROP FUNCTION IF EXISTS gpGet_Object_Partner_checkMap (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Object_Partner_checkMap (Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Object_Partner_checkMap (Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Partner_checkMap(
    IN inJuridicalId       Integer  , 
    IN inRetailId          Integer  , 
    IN inPersonalTradeId   Integer  , 
    IN inRouteId           Integer  , 
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpGetUserBySession (inSession);

   -- определяется 
   IF COALESCE (inJuridicalId, 0) = 0 AND
      COALESCE (inRetailId, 0) = 0 AND 
      COALESCE (inPersonalTradeId, 0) = 0 AND 
      COALESCE (inRouteId, 0) = 0 THEN
     -- RAISE EXCEPTION 'Ошибка. нельзя на карте Google показать такое количество <%> контрагентов.Необходимо ограничить <Торговая сеть> или <Юридическое лицо> или <ФИО сотрудник (ТП)>.', (SELECT COUNT() FROM Object WHERE DescId = zc_Object_Partner()) :: Integer;
     RAISE EXCEPTION 'Ошибка. нельзя на карте Google показать такое количество <%> контрагентов.Необходимо установить ограничение в ячейке <Юридическое лицо> или <Торговая сеть> или <ФИО сотрудник (ТП)> или <Маршрут>', (SELECT COUNT(*) FROM Object WHERE DescId = zc_Object_Partner()) :: Integer;
   END IF;
   
   -- просто так   
   RETURN inJuridicalId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.05.17         *
 04.05.17                                        *
*/

-- тест
-- SELECT * FROM gpGet_Object_Partner_checkMap (inJuridicalId:=1, inRetailId:= 0, inPersonalTradeId:= 0, inRouteId:= 0, inSession:= zfCalc_UserAdmin())
