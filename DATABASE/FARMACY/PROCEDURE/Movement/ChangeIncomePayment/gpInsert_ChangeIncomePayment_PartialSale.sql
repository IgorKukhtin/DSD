-- Function: gpInsert_ChangeIncomePayment_PartialSale()

DROP FUNCTION IF EXISTS gpInsert_ChangeIncomePayment_PartialSale(TDateTime, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_ChangeIncomePayment_PartialSale(
    IN inOperDate                           TDateTime , -- ���� ���������
    IN inJuridicalId                        Integer   , -- ��� ������ ������
    IN inFromId                             Integer   , -- �� ���� (� ���������)
    IN inSumma                              TFloat    , -- ����� ��������� �����
    IN inSession                            TVarChar    -- ������ ������������
)
RETURNS VOID
AS 
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ChangeIncomePayment());
    vbUserId := inSession;
    
    IF COALESCE (inSumma, 0) <= 0
    THEN
      RETURN;
    END IF;
    
    vbId := lpInsertUpdate_Movement_ChangeIncomePayment(ioId                         := 0
                                                      , inInvNumber                  := CAST (NEXTVAL ('movement_ChangeIncomePayment_seq') AS TVarChar)
                                                      , inOperDate                   := inOperDate
                                                      , inTotalSumm                  := inSumma
                                                      , inFromId                     := inFromId
                                                      , inJuridicalId                := inJuridicalId
                                                      , inChangeIncomePaymentKindId  := zc_Enum_ChangeIncomePaymentKind_PartialSale()
                                                      , inComment                    := ''
                                                      , inUserId                     := vbUserId);
                                                      
    PERFORM gpComplete_Movement_ChangeIncomePayment(inMovementId   := vbId
                                                  , inSession      := inSession);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsert_ChangeIncomePayment_PartialSale (TDateTime, Integer, Integer, TFloat, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 05.11.20                                                      *
*/