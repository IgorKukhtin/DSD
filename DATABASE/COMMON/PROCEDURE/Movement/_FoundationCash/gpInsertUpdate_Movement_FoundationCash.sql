-- Function: gpInsertUpdate_Movement_FoundationCash(Integer, TDateTime, Integer, TFloat, tvarchar)

-- DROP FUNCTION gpInsertUpdate_Movement_FoundationCash(Integer, TDateTime, Integer, TFloat, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_FoundationCash(INOUT ioId Integer, IN inOperDate TDateTime, IN inCashId integer, IN inSumm TFloat, Session tvarchar)
  RETURNS Integer AS
$BODY$
BEGIN
  ioId := lpInsertUpdate_Movement(ioId, zc_Movement_FoundationCash(), '', inOperDate);
  PERFORM lpInsertUpdate_MovementLinkObject(zc_Movement_Link_Cash(), ioId, inCashId);
  PERFORM lpInsertUpdate_MovementFloat(zc_Movement_Float_Summ(), ioId, inSumm);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpInsertUpdate_Movement_FoundationCash(Integer, TDateTime, Integer, TFloat, tvarchar)
  OWNER TO postgres;
