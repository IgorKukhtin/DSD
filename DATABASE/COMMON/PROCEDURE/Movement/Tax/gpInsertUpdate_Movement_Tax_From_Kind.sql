-- Function: gpInsertUpdate_Movement_Tax_From_Kind()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Tax_From_Kind (Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Tax_From_Kind (
    IN inMovementId                 Integer  , -- ключ Документа
    IN inDocumentTaxKindId          Integer  , -- Тип формирования налогового документа
   OUT outInvNumberPartner_Master   TVarChar , --
   OUT outDocumentTaxKindName       TVarChar , --
    IN inSession                    TVarChar   -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbTaxId        Integer;
   DECLARE vbUserId       Integer;
   DECLARE vbInvNumberPartner Integer;
   DECLARE vbInvNumber Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Tax());
/*

       CASE inDocumentTaxKindId
         WHEN zc_Enum_DocumentTaxKind_Tax() THEN BEGIN

             SELECT MovementLinkMovement.ChildMovementId INTO vbTaxId 
             FROM MovementLinkMovement 
                  WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
                    AND MovementLinkMovement.MovementId = inMovementId;

             IF COALESCE(vbTaxId, 0) = 0 THEN

                SELECT NEXTVAL ('movement_tax_seq')::TVarChar INTO vbInvNumber;
                vbInvNumberPartner := vbInvNumber;


                SELECT lpInsertUpdate_Movement_Tax(
                       ioId := 0
                     , inInvNumber := vbInvNumber
                     , inInvNumberPartner := vbInvNumberPartner
                     , inOperDate := MovementSale.OperDate
                     , inChecked := false
                     , inDocument := false
                     , inPriceWithVAT := MovementSale.PriceWithVAT
                     , inVATPercent := MovementSale.VATPercent
                     , inFromId := MovementSale.FromId
                     , inToId := ObjectLink_Partner_Juridical.ChildObjectId
                     , inPartnerId := MovementSale.ToId          Integer   , -- Контрагент
                     , inContractId := MovementSale.ContractId
                     , inDocumentTaxKindId := MovementSale.DocumentTaxKindId,
                     , inUserId := vbUserId) INTO vbTaxId
               FROM gpGet_Movement_Sale(inMovementId, Today(*), inSession) AS MovementSale
               LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                    ON ObjectLink_Partner_Juridical.ObjectId = MovementSale.ToId
                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical();
          END IF;
       END;

       ESLE
*/
          SELECT '12345/789'
              , Object_DocumentTaxKind.ValueData
                INTO outInvNumberPartner_Master, outDocumentTaxKindName
         FROM Object AS Object_DocumentTaxKind
         WHERE Object_DocumentTaxKind.Id = inDocumentTaxKindId;
--      END;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Movement_Tax_From_Kind (Integer, Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 23.03.14                                        * all
 13.02.14                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Tax_From_Kind(inMovementId := 21838, inDocumentTaxKindId:=80770, inSession := '5'); -- все
-- SELECT gpInsertUpdate_Movement_Tax_From_Kind FROM gpInsertUpdate_Movement_Tax_From_Kind(inMovementId := 21838, inDocumentTaxKindId:=80770, inSession := '5'); -- все
