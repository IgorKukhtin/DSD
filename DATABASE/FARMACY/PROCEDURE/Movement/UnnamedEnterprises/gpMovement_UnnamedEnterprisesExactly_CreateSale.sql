-- Function: gpMovement_UnnamedEnterprisesExactly_CreateSale()

DROP FUNCTION IF EXISTS gpMovement_UnnamedEnterprisesExactly_CreateSale (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovement_UnnamedEnterprisesExactly_CreateSale(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;

BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
    vbUserId:= inSession;

  RAISE EXCEPTION 'Ошибка. В разработке';

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovement_UnnamedEnterprisesExactly_CreateSale (Integer,TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 07.11.18        *
*/

-- SELECT * FROM gpMovement_UnnamedEnterprisesExactly_CreateSale (inMovementId := 10582535, inSession:= '5');