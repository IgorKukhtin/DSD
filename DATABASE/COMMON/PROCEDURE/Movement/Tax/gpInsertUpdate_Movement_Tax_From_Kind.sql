-- Function: gpInsertUpdate_Movement_Tax_From_Kind()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Tax_From_Kind (Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Tax_From_Kind (Integer, Integer, TVarChar, TVarChar, TVarChar);



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
   DECLARE vbTaxId            Integer;
   DECLARE vbUserId           Integer;
   DECLARE vbOperDate         TDateTime;
   DECLARE vbInvNumber        TVarChar;
   DECLARE vbInvNumberPartner TVarChar;
   DECLARE vbPriceWithVAT     Boolean ;
   DECLARE vbVATPercent       TFloat;
   DECLARE vbFromId           Integer;
   DECLARE vbToId             Integer;
   DECLARE vbPartnerId        Integer;
   DECLARE vbContractId       Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Tax());
   
            IF COALESCE (inDocumentTaxKindId,0) =  zc_Enum_DocumentTaxKind_Tax()
               THEN
               /* выбираем реквизиты для обновления/создания шапки НН */
               SELECT MovementLinkMovement.MovementChildId 
                    , MovementSale.InvNumber
                    , MovementSale.InvNumberPartner_Master                     
                    , MovementSale.OperDate
                    , MovementSale.PriceWithVAT
                    , MovementSale.VATPercent
                    , ObjectLink_Contract_JuridicalBasis.ChildObjectId  -- от кого
                    , ObjectLink_Partner_Juridical.ChildObjectId          -- кому
                    , MovementSale.ToId           	             -- контрагент 
                    , MovementSale.ContractId 
                    
               INTO  vbTaxId, vbInvNumber, vbInvNumberPartner, vbOperDate, vbPriceWithVAT, vbVATPercent, vbFromId, vbToId, vbPartnerId, vbContractId

               FROM gpGet_Movement_Sale(inMovementId, CURRENT_DATE , inSession) AS MovementSale
               LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                    ON ObjectLink_Partner_Juridical.ObjectId = MovementSale.ToId
                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
               
               LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                                    ON ObjectLink_Contract_JuridicalBasis.ObjectId = MovementSale.ContractId
                                   AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
               
               LEFT JOIN MovementLinkMovement ON MovementLinkMovement.MovementId = MovementSale.Id
                                             AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master();



               SELECT tmp.ioInvNumberPartner
                    , Object_DocumentTaxKind.ValueData
                    , tmp.ioId                   
               INTO outInvNumberPartner_Master, outDocumentTaxKindName, vbTaxId
     
               FROM lpInsertUpdate_Movement_Tax(
                       ioId := COALESCE (vbTaxId,0)
                     , inInvNumber := vbInvNumber
                     , ioInvNumberPartner := vbInvNumberPartner                    
                     , inOperDate := vbOperDate
                     , inChecked := false
                     , inDocument := false
                     , inPriceWithVAT := vbPriceWithVAT
                     , inVATPercent := vbVATPercent
                     , inFromId := vbFromId                                  -- от кого
                     , inToId := vbToId                                      -- кому
                     , inPartnerId := vbPartnerId           	             -- контрагент 
                     , inContractId := vbContractId
                     , inDocumentTaxKindId := inDocumentTaxKindId
                     , inUserId := vbUserId ) as tmp

               LEFT JOIN Object AS Object_DocumentTaxKind ON Object_DocumentTaxKind.Id = inDocumentTaxKindID;

               -- сохранили Продажи с Нологовой
               PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Master(), inMovementId, vbTaxId);
            
               /*выбрать товары из продажы для обновления/создания НН*/

               
            ELSE 
                           
                  SELECT '12345/789'
                    , Object_DocumentTaxKind.ValueData
                  INTO outInvNumberPartner_Master, outDocumentTaxKindName

                  FROM Object AS Object_DocumentTaxKind
                  WHERE Object_DocumentTaxKind.Id = inDocumentTaxKindId;

      
            END IF;   
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Movement_Tax_From_Kind (Integer, Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 29.03.14         *
 23.03.14                                        * all
 13.02.14                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Tax_From_Kind(inMovementId := 21838, inDocumentTaxKindId:=80770, inSession := '5'); -- все
-- SELECT gpInsertUpdate_Movement_Tax_From_Kind FROM gpInsertUpdate_Movement_Tax_From_Kind(inMovementId := 21838, inDocumentTaxKindId:=80770, inSession := '5'); -- все


      
--select * from gpInsertUpdate_Movement_Tax_From_Kind(inMovementId := 16759 , inDocumentTaxKindId := zc_Enum_DocumentTaxKind_Tax() ,  inSession := '5');
         
/*select * from Movement
join  where id = 176021
*/
/*select * from Movement
LEFT JOIN MovementLinkMovement ON MovementLinkMovement.MovementId = Movement.Id
                              AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
 where  InvNumber = '140574'
and Movement.descid = zc_Movement_Sale()*/