-- Function: gpUpdate_Movement_Sale_Print()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Sale_Print (Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Movement_Sale_Print(
    IN inId                  Integer   , -- ���� ������� <�������� �����������>
    IN inNewPrinted          Boolean   , --
   OUT outPrinted            Boolean   , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);

     IF vbUserId = 5 --OR (TRUE = (SELECT MovementBoolean.ValueData FROM MovementBoolean WHERE MovementBoolean.MovementId =  inId AND MovementBoolean.DescId = zc_MovementBoolean_Print())
                     --AND TRUE = inNewPrinted)
     THEN
         -- ���������� �������
         outPrinted := COALESCE ((SELECT MovementBoolean.ValueData FROM MovementBoolean WHERE MovementBoolean.MovementId =  inId AND MovementBoolean.DescId = zc_MovementBoolean_Print()), FALSE);
     ELSE
         -- ���������� �������
         outPrinted := inNewPrinted;

         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Print(), inId, inNewPrinted);

         -- ��������� ��������
         PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.12.15         *
 */

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Sale_Print (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
