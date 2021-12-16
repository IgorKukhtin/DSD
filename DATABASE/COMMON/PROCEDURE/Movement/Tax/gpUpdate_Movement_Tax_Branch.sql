-- gpUpdate_Movement_Tax_Branch()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Tax_Branch (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Tax_Branch (
    IN inMovementId          Integer   , -- Ключ объекта <>
    IN inBranchId            Integer   , -- Филиал
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- изменения только для zc_Enum_DocumentTaxKind_Prepay
     
     IF (SELECT MLO.ObjectId
         FROM MovementLinkObject AS MLO
         WHERE MLO.MovementId = inMovementId
           AND MLO.DescId = zc_MovementLinkObject_DocumentTaxKind()
         ) <> zc_Enum_DocumentTaxKind_Prepay()
     THEN 
         RAISE EXCEPTION 'Ошибка.Нет прав изменять параметр <Филиал>.';
     END IF;
     
     
     IF (SELECT DescId FROM Movement WHERE Id = inMovementId) = zc_Movement_Tax() 
     THEN
	vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Tax_Branch());
     ELSE 
        vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_TaxCorrective_Branch());
     END IF;

     -- сохранили связь с <филиал>
     --PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Branch(), inMovementId, inBranchId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.12.21         *
*/

-- тест
--