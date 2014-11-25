-- gpInsertUpdate_Movement_TaxCorrective_IsDocument()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TaxCorrective_IsDocument (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TaxCorrective_IsDocument (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TaxCorrective_IsDocument (
    IN inId                  Integer   , -- Ключ объекта <Документ>
 INOUT ioIsDocument          Boolean   , -- Есть ли подписанный документ (да/нет)
    IN inIsCalculate         Boolean   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_TaxCorrective_IsDocument());

     IF inIsCalculate = TRUE
     THEN -- определили признак
          ioIsDocument:= NOT ioIsDocument;
     END IF;

     -- сохранили свойство <Есть ли подписанный документ>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Document(), COALESCE (Movement_find.Id, Movement.Id), ioIsDocument)
     FROM Movement
          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                         ON MovementLinkMovement_Master.MovementId = Movement.Id
                                        AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master_find
                                         ON MovementLinkMovement_Master_find.MovementChildId = MovementLinkMovement_Master.MovementChildId
                                        AND MovementLinkMovement_Master_find.DescId = zc_MovementLinkMovement_Master()
          LEFT JOIN Movement AS Movement_find ON Movement_find.Id = MovementLinkMovement_Master_find.MovementId
                                             AND Movement_find.StatusId <> zc_Enum_Status_Erased()
      WHERE Movement.Id = inId
        AND Movement.DescId = zc_Movement_TaxCorrective();

     -- сохранили протокол для всех
     PERFORM lpInsert_MovementProtocol (COALESCE (Movement_find.Id, Movement.Id), vbUserId, FALSE)
     FROM Movement
          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                         ON MovementLinkMovement_Master.MovementId = Movement.Id
                                        AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master_find
                                         ON MovementLinkMovement_Master_find.MovementChildId = MovementLinkMovement_Master.MovementChildId
                                        AND MovementLinkMovement_Master_find.DescId = zc_MovementLinkMovement_Master()
          LEFT JOIN Movement AS Movement_find ON Movement_find.Id = MovementLinkMovement_Master_find.MovementId
                                             AND Movement_find.StatusId <> zc_Enum_Status_Erased()
      WHERE Movement.Id = inId
        AND Movement.DescId = zc_Movement_TaxCorrective();

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.05.14                                        * add lpInsert_MovementProtocol
 30.04.14                                        * zc_Enum_Process_Update_Movement_TaxCorrective_IsDocument
 23.04.14                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_TaxCorrective_IsDocument (ioId:= 0, ioIsDocument:= FALSE, inIsCalculate:= TRUE, inSession:= '2')
