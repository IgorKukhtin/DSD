-- Function: lpInsertUpdate_Movement_IncomeCost()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_IncomeCost (Integer, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_IncomeCost(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inParentId            Integer   , -- �������� ������
    IN inMovementId          Integer   , -- �������� ����
    IN inComment             TVarChar  , --
    IN inUserId              Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ��������
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ������ �������� <����>.';
     END IF;   


     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;


     -- ��������� <��������>
     IF COALESCE (ioId, 0) = 0
     THEN
         -- ��������� �����
         ioId := lpInsertUpdate_Movement (ioId
                                        , zc_Movement_IncomeCost()
                                        , CAST (NEXTVAL ('Movement_IncomeCost_seq') AS TVarChar)
                                        , (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inParentId)
                                        , inParentId
                                        , inUserId
                                         );

     ELSE
         -- ��������� ������������
         ioId := lpInsertUpdate_Movement (ioId
                                        , zc_Movement_IncomeCost()
                                        , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = ioId)
                                        , CURRENT_DATE
                                        , (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inParentId)
                                        , inUserId
                                         );
     END IF;

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountCost(), ioId
                                           -- ��� ��� + ���� �������� + ���� ��� ������
                                         , CASE WHEN MovementFloat_Amount.ValueData < 0 AND Movement.StatusId = zc_Enum_Status_Complete()
                                                     THEN -1 * zfCalc_Summ_NoVAT (MovementFloat_Amount.ValueData, MovementFloat_VATPercent.ValueData)
                                                ELSE 0
                                           END
                                          )
     FROM Movement
          LEFT JOIN MovementFloat AS MovementFloat_Amount
                                  ON MovementFloat_Amount.MovementId = Movement.Id
                                 AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                  ON MovementFloat_VATPercent.MovementId = Movement.Id
                                 AND MovementFloat_VATPercent.DescId     = zc_MovementFloat_VATPercent()

     WHERE Movement.Id = inMovementId
    ;

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementId(), ioId, inMovementId);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
     

    -- !!!�������� ����� �������� ����������� �������!!!
     IF vbIsInsert = FALSE
     THEN
         -- ��������� �������� <���� �������������>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- ��������� �������� <������������ (�������������)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     ELSE
         IF vbIsInsert = TRUE
         THEN
             -- ��������� �������� <���� ��������>
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
             -- ��������� �������� <������������ (��������)>
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
         END IF;
     END IF;
     
     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.04.16         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_IncomeCost (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inParentId:= 0, inMovementId:= 0, inComment:= 'xfdf', inSession:= '2')
