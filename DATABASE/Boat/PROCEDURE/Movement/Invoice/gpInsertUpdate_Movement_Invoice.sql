-- Function: gpInsert_Movement_Invoice()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Invoice (Integer, TVarChar, TDateTime, TDateTime, TFloat, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Invoice(
 INOUT ioId               Integer  ,  --
    IN inInvNumber        TVarChar ,  -- ����� ���������
    IN inOperDate         TDateTime,  --
    IN inPlanDate         TDateTime,  -- ���� ������
    IN inAmount           TFloat   ,  -- 
    IN inInvNumberPartner TVarChar ,  -- 
    IN inReceiptNumber    TVarChar ,  -- 
    IN inComment          TVarChar ,  -- 
    IN inObjectId         Integer  ,  -- 
    IN inUnitId           Integer  ,  -- 
    IN inInfoMoneyId      Integer  ,  -- 
    IN inProductId        Integer  ,  -- 
    IN inPaidKindId       Integer  ,  -- 
    IN inSession          TVarChar     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;

    -- ��������� <��������>
    PERFORM lpInsertUpdate_Movement_Invoice (ioId              := ioId
                                           , inInvNumber       := inInvNumber
                                           , inOperDate        := inOperDate
                                           , inPlanDate        := inPlanDate
                                           , inAmount          := inAmount :: Tfloat
                                           , inInvNumberPartner := inInvNumberPartner
                                           , inReceiptNumber   := inReceiptNumber
                                           , inComment         := inComment
                                           , inObjectId        := inObjectId
                                           , inUnitId          := inUnitId
                                           , inInfoMoneyId     := inInfoMoneyId
                                           , inProductId       := inProductId
                                           , inPaidKindId      := inPaidKindId
                                           , inUserId          := vbUserId
                                           );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.02.21         *

*/