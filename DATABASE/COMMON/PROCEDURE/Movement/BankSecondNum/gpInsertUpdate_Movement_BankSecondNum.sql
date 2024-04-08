-- Function: gpInsertUpdate_Movement_BankSecondNum()

---DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankSecondNum (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankSecondNum (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_BankSecondNum(
 INOUT ioId                     Integer   , -- ���� ������� <�������� >
    IN inInvNumber              TVarChar  , -- ����� ���������
    IN inOperDate               TDateTime , -- ���� 
    IN inMovementId_PersonalService Integer, -- ��������� ����������
    IN inBankSecondId_num       Integer   , -- 
    IN inBankSecondTwoId_num    Integer   , --  
    IN inBankSecondDiffId_num   Integer   , -- 
    IN inBankSecond_num         TFloat    , -- 
    IN inBankSecondTwo_num      TFloat    , --
    IN inBankSecondDiff_num     TFloat    , -- 
    IN inComment                TVarChar  , -- ����������
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbCurrencyDocumentId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankSecondNum());


     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- �������������� ���� ��������� - ����� ���������� = ������ ����� ������
     inOperDate:= DATE_TRUNC ('MONTH', inOperDate);

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_BankSecondNum(), inInvNumber, inOperDate, NULL);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_BankSecond_num(), ioId, inBankSecondId_num);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_BankSecondTwo_num(), ioId, inBankSecondTwoId_num);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_BankSecondDiff_num(), ioId, inBankSecondDiffId_num);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_BankSecond_num(), ioId, inBankSecond_num);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_BankSecondTwo_num(), ioId, inBankSecondTwo_num);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_BankSecondDiff_num(), ioId, inBankSecondDiff_num);

     -- ����������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- ������� - ���
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_BankSecondNum(), MovementLinkMovement.MovementId, NULL)
     FROM MovementLinkMovement
     WHERE MovementLinkMovement.DescId          = zc_MovementLinkMovement_BankSecondNum()
       AND MovementLinkMovement.MovementChildId = ioId
    ;


     -- ��������� ����� � ���������� <��������� ���������� � ��������� ����������>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_BankSecondNum(), inMovementId_PersonalService, ioId);
     
     IF vbIsInsert = TRUE
     THEN
         -- ��������� �������� <���� ��������>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- ��������� �������� <������������ (��������)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, vbUserId);
     ELSE
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, vbUserId);
     END IF;


     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.03.24         *
*/

-- ����
-- 