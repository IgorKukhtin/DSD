-- Function: gpInsertUpdate_Movement_TaxCorrective_From_Kind()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TaxCorrective_From_Kind (Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TaxCorrective_From_Kind (
    IN inMovementId           Integer  , -- ключ Документа
    IN inDocumentTaxKindId    Integer  , -- Тип формирования налогового документа
   OUT outDocumentTaxKindName TVarChar , --
    IN inSession              TVarChar   -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Tax());

       SELECT Object_TaxKind.ValueData

       INTO outDocumentTaxKindName

       FROM Object AS Object_TaxKind
       WHERE Object_TaxKind.Id = inDocumentTaxKindId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Movement_TaxCorrective_From_Kind (Integer, Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 13.02.14                                                        *
*/

-- тест
--SELECT * FROM gpInsertUpdate_Movement_TaxCorrective_From_Kind(inMovementId := 21838, inDocumentTaxKindId:=80770, inSession := '5'); -- все
--SELECT gpInsertUpdate_Movement_TaxCorrective_From_Kind FROM gpInsertUpdate_Movement_TaxCorrective_From_Kind(inMovementId := 21838, inDocumentTaxKindId:=80770, inSession := '5'); -- все