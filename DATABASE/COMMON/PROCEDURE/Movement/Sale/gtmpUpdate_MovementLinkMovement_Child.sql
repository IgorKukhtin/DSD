-- Function: gtmpUpdate_MovementLinkMovement_Child()

DROP FUNCTION IF EXISTS gtmpUpdate_MovementLinkMovement_Child (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gtmpUpdate_MovementLinkMovement_Child(
    IN inMovementId          Integer   , -- ключ главного документа
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
BEGIN

     IF inDocumentTaxKindId = zc_Enum_DocumentTaxKind_Tax()
     THEN
         -- сформировали одну связь
         PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Child(), inMovementId, inMovementChildId);
     ELSE
         -- определили параметры
         SELECT DATE_TRUNC ('Month', Movement.OperDate) -- '01.12.2013' :: TDateTime
              , DATE_TRUNC ('Month', Movement.OperDate) + interval '1 month' - interval '1 day' -- '31.12.2013' :: TDateTime
              , MovementLinkObject_To.ObjectId
              , MovementLinkObject_Partner.ObjectId
           INTO vbStartDate, vbEndDate, vbJuridicalId, vbPartnerId
         FROM Movement
              LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                           ON MovementLinkObject_To.MovementId = Movement.Id
                                          AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
              LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                           ON MovementLinkObject_Partner.MovementId = Movement.Id
                                          AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
         WHERE Movement.Id = inMovementChildId;
         --
         IF inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS(), zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR())
         THEN 
              -- сформировали связь для всех по юр лицу
              PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Child(), Movement.Id, inMovementChildId)
              FROM Movement 
                   JOIN MovementLinkObject AS MovementLinkObject_To
                                           ON MovementLinkObject_To.MovementId = Movement.Id
                                          AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                   JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                   ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                  AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                  AND ObjectLink_Partner_Juridical.ChildObjectId = vbJuridicalId
              WHERE Movement.StatusId <> zc_Enum_Status_Erased() -- zc_Enum_Status_Complete()
                AND Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                AND Movement.DescId = zc_Movement_Sale();
         ELSE
             IF inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())
             THEN 
                 -- сформировали связь для всех по юр лицу
                 PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Child(), Movement.Id, inMovementChildId)
                 FROM Movement 
                      JOIN MovementLinkObject AS MovementLinkObject_To
                                              ON MovementLinkObject_To.MovementId = Movement.Id
                                             AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                             AND MovementLinkObject_To.ObjectId = vbPartnerId
                 WHERE Movement.StatusId <> zc_Enum_Status_Erased() -- zc_Enum_Status_Complete()
                   AND Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                   AND Movement.DescId = zc_Movement_Sale();
             END IF;
         END IF;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.03.14                                        * эта процка только для Load_PostgreSql

*/

-- тест
-- SELECT * FROM gtmpUpdate_MovementLinkMovement_Child (inId:= 0, inInvNumber:= '-1', inSession:= '2');
