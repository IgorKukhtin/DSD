-- Function: gpInsertUpdate_Movement_ProductionUnion()

-- DROP FUNCTION gpInsertUpdate_Movement_ProductionUnion();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProductionUnion(
INOUT ioId	         Integer,   	/* ключ объекта <Документ производства> */
  IN inInvNumber         TVarChar, 
  IN inOperDate          TDateTime,
  IN inFromId            Integer,
  IN inToId              Integer,
  IN inSession           TVarChar       /* текущий пользователь */
)                              
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_Measure());

   ioId := lpInsertUpdate_Movement(ioId, zc_Movement_ProductionUnion(), inInvNumber, inOperDate, NULL);
   
   PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLink_From(), ioId, inFromId);
   PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLink_To(), ioId, inToId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            