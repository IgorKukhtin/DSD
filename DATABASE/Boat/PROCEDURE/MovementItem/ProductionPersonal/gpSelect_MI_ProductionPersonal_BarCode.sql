-- Function: gpSelect_MI_ProductionPersonal_BarCode()

DROP FUNCTION IF EXISTS gpSelect_MI_ProductionPersonal_BarCode (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_ProductionPersonal_BarCode (
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (BarCode_OrderClient TVarChar
             , BarCode_start TVarChar
             , BarCode_end TVarChar
             )
AS
$BODY$
  DECLARE vbUserId       Integer;
  DECLARE vbToId         Integer;
  DECLARE vbFromId       Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_ProductionPersonal());
    vbUserId := lpGetUserBySession (inSession);

       RETURN QUERY
         -- результат
            SELECT NULL ::TVarChar AS BarCode_OrderClient
                 , NULL ::TVarChar AS BarCode_start
                 , NULL ::TVarChar AS BarCode_end
            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.07.21         * 
*/

-- тест
--