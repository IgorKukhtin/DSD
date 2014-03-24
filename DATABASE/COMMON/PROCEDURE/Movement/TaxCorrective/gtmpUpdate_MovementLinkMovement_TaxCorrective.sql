-- Function: gtmpUpdate_MovementLinkMovement_TaxCorrective()

DROP FUNCTION IF EXISTS gtmpUpdate_MovementLinkMovement_TaxCorrective (Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gtmpUpdate_MovementLinkMovement_TaxCorrective(
    IN inMovementId          Integer   , -- ключ главного документа
    IN inMovementMasterId    Integer   , -- ключ Master документа
    IN inMovementChildId     Integer   , -- ключ подчиненного документа
    IN inDocumentTaxKindId   Integer   , -- Тип формирования налогового документа
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
   DECLARE vbJuridicalId Integer;
   DECLARE vbPartnerId Integer;
   DECLARE vbContractId Integer;
BEGIN

         -- сформировали одну связь
         PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Master(), inMovementId, inMovementMasterId);
         -- сформировали одну связь
         PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Child(), inMovementId, inMovementChildId);


     IF inDocumentTaxKindId = zc_Enum_DocumentTaxKind_Corrective()
     THEN
         -- сохранили связь с <Тип формирования налогового документа> у inMovementMasterId
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentTaxKind(), inMovementMasterId, inDocumentTaxKindId);
     ELSE
         -- определили параметры
         SELECT DATE_TRUNC ('Month', Movement.OperDate) -- '01.12.2013' :: TDateTime
              , DATE_TRUNC ('Month', Movement.OperDate) + interval '1 month' - interval '1 day' -- '31.12.2013' :: TDateTime
              , MovementLinkObject_From.ObjectId
              , MovementLinkObject_Partner.ObjectId
              , MovementLinkObject_Contract.ObjectId
           INTO vbStartDate, vbEndDate, vbJuridicalId, vbPartnerId, vbContractId
         FROM Movement
              LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                           ON MovementLinkObject_From.MovementId = Movement.Id
                                          AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
              LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                           ON MovementLinkObject_Partner.MovementId = Movement.Id
                                          AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
              LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                           ON MovementLinkObject_Contract.MovementId = Movement.Id
                                          AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
         WHERE Movement.Id = inMovementId;
         --
         IF inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR(), zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR())
         THEN 
              -- сохранили связь с <Тип формирования налогового документа> у inMovementMasterId
              PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentTaxKind(), Movement.Id, inDocumentTaxKindId)
              FROM Movement 
                   JOIN MovementLinkObject AS MovementLinkObject_To
                                           ON MovementLinkObject_To.MovementId = Movement.Id
                                          AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                          AND MovementLinkObject_To.ObjectId NOT IN (8445, 8444) -- Склад МИНУСОВКА + Склад ОХЛАЖДЕНКА
                   JOIN MovementLinkObject AS MovementLinkObject_From
                                           ON MovementLinkObject_From.MovementId = Movement.Id
                                          AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                   JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                   ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                  AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                  AND ObjectLink_Partner_Juridical.ChildObjectId = vbJuridicalId
                   JOIN MovementLinkObject AS MovementLinkObject_Contract
                                           ON MovementLinkObject_Contract.MovementId = Movement.Id
                                          AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                          AND MovementLinkObject_Contract.ObjectId = vbContractId
              WHERE Movement.StatusId <> zc_Enum_Status_Erased() -- zc_Enum_Status_Complete()
                AND Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                AND Movement.DescId = zc_Movement_ReturnIn()
             ;

         ELSE
             IF inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR(), zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR())
             THEN 
                 -- сохранили связь с <Тип формирования налогового документа> у inMovementMasterId
                 PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentTaxKind(), Movement.Id, inDocumentTaxKindId)
                 FROM Movement 
                      JOIN MovementLinkObject AS MovementLinkObject_To
                                              ON MovementLinkObject_To.MovementId = Movement.Id
                                             AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                             AND MovementLinkObject_To.ObjectId NOT IN (8445, 8444) -- Склад МИНУСОВКА + Склад ОХЛАЖДЕНКА
                      JOIN MovementLinkObject AS MovementLinkObject_From
                                              ON MovementLinkObject_From.MovementId = Movement.Id
                                             AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                             AND MovementLinkObject_From.ObjectId = vbPartnerId
                      JOIN MovementLinkObject AS MovementLinkObject_Contract
                                              ON MovementLinkObject_Contract.MovementId = Movement.Id
                                             AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                             AND MovementLinkObject_Contract.ObjectId = vbContractId
                 WHERE Movement.StatusId <> zc_Enum_Status_Erased() -- zc_Enum_Status_Complete()
                   AND Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                   AND Movement.DescId = zc_Movement_ReturnIn()
                ;
             END IF;
         END IF;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.03.14                                        * add vbContractId
 16.03.14                                        * эта процка только для Load_PostgreSql
*/

-- тест
-- SELECT * FROM gtmpUpdate_MovementLinkMovement_TaxCorrective (inMovementId:= 114768, inMovementChildId:= 130627, inDocumentTaxKindId:= 80787, inSession:='5');
