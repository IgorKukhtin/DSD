-- Function: gpGet_OrderInternalPromo_ExportParam()

DROP FUNCTION IF EXISTS gpGet_OrderInternalPromo_ExportParam(integer, integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_OrderInternalPromo_ExportParam(
    IN inMovementId  Integer,       -- ключ объекта <Города>
    IN inJuridicalId Integer      , -- Поставщик
    IN inSession     TVarChar       -- сессия пользователя
)

RETURNS TABLE (DefaultFileName TVarChar, ExportType Integer) AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbStatusId Integer;
  DECLARE vbMainJuridicalName TVarChar;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId := lpGetUserBySession (inSession);
  
   -- определяем
   SELECT StatusId
   INTO vbStatusId
   FROM Movement
   WHERE Movement.Id = inMovementId;


   -- Результат - ДЛЯ ВСЕХ остальных
   RETURN QUERY
   SELECT
      'Маркетинговй заказ'::TVarChar
    , 3 AS ExportType
     ;


END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_OrderInternalPromo_ExportParam(integer, integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 08.08.21                                                       *

*/

-- тест
--
 SELECT * FROM gpGet_OrderInternalPromo_ExportParam (inMovementId := 23631157 , inJuridicalId := 59611 , inSession := '3')