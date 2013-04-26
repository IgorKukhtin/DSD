-- Function: gpGet_Movement_Income()

--DROP FUNCTION gpGet_Movement_Income();

CREATE OR REPLACE FUNCTION gpGet_Movement_Income(
IN inId          Integer,       /* Единица измерения */
IN inSession     TVarChar       /* текущий пользователь */)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, FromId Integer, FromName TVarChar, 
               PaidKindId Integer, PaidKindName TVarChar, ContractId Integer, ContractName TVarChar,
               CarId Integer, CarName TVarChar, PersonalDriverId Integer, PersonalDriverName TVarChar,
               PersonalPackerId Integer, PersonalPackerName TVarChar, OperDatePartner TDateTime,
               InvNumberPartner TVarChar, PriceWithVAT Boolean, VATPercent TFloat, DiscountPercent TFloat,
               ExtraChargesPercent TFloat) 
AS
$BODY$BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
   SELE
   ioId := lpInsertUpdate_Movement(ioId, zc_Movement_Income(), inInvNumber, inOperDate, NULL);
   
   PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLink_From, ioId, inFromId);
   PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLink_To, ioId, inToId);
   PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLink_PaidKind, ioId, inPaidKindId);
   PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLink_Contract, ioId, inContractId);
   PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLink_Car, ioId, inCarId);
   PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLink_PersonalDriver, ioId, inPersonalDriverId);
   PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLink_PersonalPacker, ioId, inPersonalPackerId);

   PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_OperDatePartner, ioId, inOperDatePartner);

   PERFORM lpInsertUpdate_MovementString(zc_MovementString_InvNumberPartner, ioId, inInvNumberPartner);

   PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_PriceWithVAT, ioId, inPriceWithVAT);

   PERFORM lpInsertUpdate_MovementFloat(zc_MovementFloat_VATPercent, ioId, inVATPercent);
   PERFORM lpInsertUpdate_MovementFloat(zc_MovementFloat_DiscountPercent, ioId, inDiscountPercent);
   PERFORM lpInsertUpdate_MovementFloat(zc_MovementFloat_ExtraChargesPercent, ioId, inExtraChargesPercent);


   RETURN QUERY 
   SELECT 
     Object.Id
   , Object.ObjectCode
   , Object.ValueData
   , Object.isErased
   FROM Object
   WHERE Object.Id = inId;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
