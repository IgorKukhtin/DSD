-- Function: lpInsertUpdate_Movement_Cost()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Cost (Integer, TVarChar, TDateTime, Integer, Tfloat, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Cost (Integer, Integer, Tfloat, TVarChar, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Cost(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inParentId            Integer   , -- �� ���� (� ���������)
    IN inMovementId          Tfloat    , -- 
    IN inComment             TVarChar  , -- 
    IN inUserId              Integer    -- ������ ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDescId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbInvNumber TVarChar;
BEGIN
    
     vbDescId := (SELECT CASE WHEN Movement.DescId = zc_Movement_Service() THEN zc_Movement_CostService() 
                              WHEN Movement.DescId = zc_Movement_Transport() THEN zc_Movement_CostTransport()
                         END 
                  FROM Movement WHERE Movement.Id = inMovementId);
   
     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>     
     IF COALESCE (ioId, 0) = 0 
     THEN  --��������� ����� ��������
          IF vbDescId = zc_Movement_CostService()
          THEN
              ioId := lpInsertUpdate_Movement (ioId, vbDescId, CAST (NEXTVAL ('Movement_CostService_seq') AS TVarChar), CURRENT_DATE, inParentId);
          ELSE
              ioId := lpInsertUpdate_Movement (ioId, vbDescId, CAST (NEXTVAL ('Movement_CostTransport_seq') AS TVarChar), CURRENT_DATE, inParentId);
          END IF;
     ELSE  -- ��������� ������������
          vbInvNumber := (select Movement.InvNumber from Movement where Movement.Id = ioId);
          ioId := lpInsertUpdate_Movement (ioId, vbDescId, vbInvNumber, CURRENT_DATE, inParentId);
     END IF;

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementId(), ioId, inMovementId);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
   
     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 29.04.16         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_Cost (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inParentId:= 0, inMovementId:= 0, inComment:= 'xfdf', inSession:= '2')
