-- Function: gpInsert_Movement_Invoice()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Invoice (Integer, TVarChar, TDateTime, TDateTime, TFloat, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Invoice (Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Invoice (Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Invoice (Integer, Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Invoice(
 INOUT ioId               Integer  ,  --
    IN inParentId         Integer  ,  --
    IN inInvNumber        TVarChar ,  -- ����� ���������
    IN inOperDate         TDateTime,  --
    IN inPlanDate         TDateTime,  -- ���� ������
    IN inVATPercent       TFloat   ,  --
    IN inAmountIn         TFloat   ,  -- 
    IN inAmountOut        TFloat   ,  -- 
    IN inInvNumberPartner TVarChar ,  -- 
    IN inReceiptNumber    TVarChar ,  -- 
    IN inComment          TVarChar ,  -- 
    IN inObjectId         Integer  ,  -- 
    IN inUnitId           Integer  ,  -- 
    IN inInfoMoneyId      Integer  ,  -- 
    --IN inProductId        Integer  ,  --
    IN inPaidKindId       Integer  ,  -- 
    IN inSession          TVarChar     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;

     -- !!!
     IF inAmountIn <> 0 THEN
        vbAmount := inAmountIn;
     ELSE
        vbAmount := -1 * inAmountOut;
     END IF;

     -- ����������� ��������
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = ioId AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;

    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement_Invoice (ioId               := ioId
                                           , inParentId         := inParentId
                                           , inInvNumber        := inInvNumber
                                           , inOperDate         := inOperDate
                                           , inPlanDate         := inPlanDate
                                           , inVATPercent       := inVATPercent
                                           , inAmount           := vbAmount :: Tfloat
                                           , inInvNumberPartner := inInvNumberPartner
                                           , inReceiptNumber    := inReceiptNumber
                                           , inComment          := inComment
                                           , inObjectId         := inObjectId
                                           , inUnitId           := inUnitId
                                           , inInfoMoneyId      := inInfoMoneyId
                                           --, inProductId        := inProductId
                                           , inPaidKindId       := inPaidKindId
                                           , inUserId           := vbUserId
                                           );


     -- 5.3. �������� ��������
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_Invoice())
     THEN
          PERFORM lpComplete_Movement_Invoice (inMovementId := ioId
                                             , inUserId     := vbUserId);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.02.21         *

*/