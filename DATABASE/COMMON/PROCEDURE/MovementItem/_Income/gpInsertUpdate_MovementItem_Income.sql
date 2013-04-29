-- Function: gpInsertUpdate_MovementItem_Income()

-- DROP FUNCTION gpInsertUpdate_MovementItem_Income();

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Income(
INOUT ioId	         Integer,   	/* ключ объекта <Приходная накладная> */
  IN inInvNumber         TVarChar, 
  IN inOperDate          TDateTime,
  IN inFromId            Integer,
  IN inToId              Integer,
  IN inPaidKindId        Integer,
  IN inContractId        Integer,
  IN inCarId             Integer,
  IN inPersonalDriverId  Integer,
  IN inPersonalPackerId  Integer,
  IN inOperDatePartner   TDateTime,
  IN inInvNumberPartner  TVarChar,
  IN inPriceWithVAT      Boolean,
  IN inVATPercent        TFloat,
  IN inDiscountPercent   TFloat,
  IN inSession           TVarChar       /* текущий пользователь */
)                              
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_Measure());

   ioId := lpInsertUpdate_MovementItem(ioId, zc_MovementItem_Income(), inInvNumber, inOperDate, NULL);
   
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MovementItemLink_From(), ioId, inFromId);
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MovementItemLink_To(), ioId, inToId);
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MovementItemLink_PaidKind(), ioId, inPaidKindId);
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MovementItemLink_Contract(), ioId, inContractId);
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MovementItemLink_Car(), ioId, inCarId);
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MovementItemLink_PersonalDriver(), ioId, inPersonalDriverId);
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MovementItemLink_PersonalPacker(), ioId, inPersonalPackerId);

   PERFORM lpInsertUpdate_MovementItemDate(zc_MovementItemDate_OperDatePartner(), ioId, inOperDatePartner);

   PERFORM lpInsertUpdate_MovementItemString(zc_MovementItemString_InvNumberPartner(), ioId, inInvNumberPartner);

   PERFORM lpInsertUpdate_MovementItemBoolean(zc_MovementItemBoolean_PriceWithVAT(), ioId, inPriceWithVAT);

   PERFORM lpInsertUpdate_MovementItemFloat(zc_MovementItemFloat_VATPercent(), ioId, inVATPercent);
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MovementItemFloat_DiscountPercent(), ioId, inDiscountPercent);
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            