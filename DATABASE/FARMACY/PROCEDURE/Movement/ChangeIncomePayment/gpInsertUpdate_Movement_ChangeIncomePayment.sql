-- Function: gpInsertUpdate_Movement_ChangeIncomePayment()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ChangeIncomePayment(Integer, TVarChar, TDateTime, TFloat, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ChangeIncomePayment(Integer, TVarChar, TDateTime, TFloat, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ChangeIncomePayment(
 INOUT ioId                                 Integer   , -- ���� ������� <�������� ��������� ����� �� ��������>
    IN inInvNumber                          TVarChar  , -- ����� ���������
    IN inOperDate                           TDateTime , -- ���� ���������
    IN inTotalSumm                          TFloat    , -- ����� ��������� �����
    IN inFromId                             Integer   , -- �� ���� (� ���������)
    IN inJuridicalId                        Integer   , -- ��� ������ ������
    IN inChangeIncomePaymentKindId          Integer   , -- ���� ��������� ����� �����
    IN inComment                            TVarChar  , -- �����������
    IN inSession                            TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ChangeIncomePayment());
    vbUserId := inSession;
    
    ioId := lpInsertUpdate_Movement_ChangeIncomePayment(ioId, inInvNumber, inOperDate, inTotalSumm
                                         , inFromId, inJuridicalId, inChangeIncomePaymentKindId 
                                         , inComment, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_Movement_ChangeIncomePayment (Integer, TVarChar, TDateTime, TFloat, Integer, Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 10.12.15                                                                       *
*/