-- Function: gpGet_Movement_checkopen()

DROP FUNCTION IF EXISTS gpGet_Movement_checkopen (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_checkopen(
    IN inMovementId        Integer  , -- ключ Документа
   OUT outFormName         TVarChar , --
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ReturnIn());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
        outFormName := '';
        RAISE EXCEPTION 'Ошибка.Нет документа для открытия.';
     ELSE
        outFormName := (SELECT CASE WHEN Movement.DescId = zc_Movement_Sale() THEN 'TSaleForm'
                                    WHEN Movement.DescId = zc_Movement_Tax() THEN 'TTaxForm'
                               END
                        FROM Movement
                        WHERE Movement.Id = inMovementId);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.10.21         *
*/

-- тест
--