-- Function: gpSetErased_Movement_TaxCorrective (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_TaxCorrective (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_TaxCorrective(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_TaxCorrective());

     -- Удаляем Документ
     PERFORM lpSetErased_Movement_TaxCorrective (inMovementId := inMovementId
                                               , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Манько Д.А.
 06.05.14                                        * add lpSetErased_Movement_TaxCorrective
 14.02.14                                                       *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_TaxCorrective (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
