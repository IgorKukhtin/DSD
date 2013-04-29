-- Function: gpInsertUpdate_Movement_Income()

-- DROP FUNCTION gpInsertUpdate_Movement_Income();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Income(
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

   ioId := lpInsertUpdate_Movement(ioId, zc_Movement_Income(), inInvNumber, inOperDate, NULL);
   
   PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLink_From(), ioId, inFromId);
   PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLink_To(), ioId, inToId);
   PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLink_PaidKind(), ioId, inPaidKindId);
   PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLink_Contract(), ioId, inContractId);
   PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLink_Car(), ioId, inCarId);
   PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLink_PersonalDriver(), ioId, inPersonalDriverId);
   PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLink_PersonalPacker(), ioId, inPersonalPackerId);

   PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_OperDatePartner(), ioId, inOperDatePartner);

   PERFORM lpInsertUpdate_MovementString(zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);

   PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);

   PERFORM lpInsertUpdate_MovementFloat(zc_MovementFloat_VATPercent(), ioId, inVATPercent);
   PERFORM lpInsertUpdate_MovementFloat(zc_MovementFloat_DiscountPercent(), ioId, inDiscountPercent);
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            