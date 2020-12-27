-- Function: gpInsertUpdate_Movement_ReestrIncome()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReestrIncome (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReestrIncome (Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ReestrIncome(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
    IN inInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReestrIncome());
                                              

     -- ������ � ���� ������ - ������ �� ������, �.�. �� ������ ���������� "������" ���
     IF ioId                           = 0
        AND TRIM (inInvNumber)         = ''
     THEN
         RETURN; -- !!!�����!!!
     END IF;


     -- ��������
     IF COALESCE (ioId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�������� �� �������� ������ �/� <������� ����>.';
     END IF;


     -- �������� - ����� ������ ? - �� �������� �������� ���������
     IF NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = ioId AND Movement.InvNumber = inInvNumber AND Movement.OperDate = inOperDate AND  Movement.DescId = zc_Movement_ReestrIncome())
        AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId IN (zc_Enum_Role_Admin()) AND UserId = vbUserId)
     THEN
         RAISE EXCEPTION '������.��� ���� ������ ���� ��������� <%> <%> <%>.', zfConvert_DateToString (inOperDate), inInvNumber, ioId;
     END IF;

     -- ��������� <��������>,
     ioId:= lpInsertUpdate_Movement_ReestrIncome (ioId               := ioId
                                                , inInvNumber        := inInvNumber
                                                , inOperDate         := inOperDate
                                                , inUserId           := vbUserId
                                                );


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.12.20         *
 20.10.16         *
*/

-- ����
--