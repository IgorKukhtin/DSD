-- Function: gpInsertUpdate_Movement_Tax_From_Kind()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Tax_From_Kind (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Tax_From_Kind (
    IN inMovementId                 Integer  , -- ключ Документа
    IN inDocumentTaxKindId          Integer  , -- Тип формирования налогового документа
    IN inDocumentTaxKindId_inf      Integer  , -- Тип формирования налогового документа
   OUT outInvNumberPartner_Master   TVarChar , --
   OUT outDocumentTaxKindId         Integer  , --
   OUT outDocumentTaxKindName       TVarChar , --
    IN inSession                    TVarChar   -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Tax_From_Kind());

     -- сохранили и вернули параметры
     SELECT tmp.outInvNumberPartner_Master, tmp.outDocumentTaxKindId, tmp.outDocumentTaxKindName
            INTO outInvNumberPartner_Master, outDocumentTaxKindId, outDocumentTaxKindName
     FROM lpInsertUpdate_Movement_Tax_From_Kind (inMovementId            := inMovementId
                                               , inDocumentTaxKindId     := inDocumentTaxKindId
                                               , inDocumentTaxKindId_inf := inDocumentTaxKindId_inf
                                               , inUserId                := vbUserId
                                                ) AS tmp;


  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Movement_Tax_From_Kind (Integer, Integer, Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 16.05.14                                        * add lpInsertUpdate_Movement_Tax_From_Kind
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Tax_From_Kind (inMovementId:= 21838, inDocumentTaxKindId:= 80770, inSession:= '5');
