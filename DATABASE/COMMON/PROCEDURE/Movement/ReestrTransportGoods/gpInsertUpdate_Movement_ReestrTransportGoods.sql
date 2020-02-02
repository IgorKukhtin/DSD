-- Function: gpInsertUpdate_Movement_ReestrTransportGoods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReestrTransportGoods (Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ReestrTransportGoods(
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
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReestrTransportGoods());
   --  vbUserId:= lpGetUserBySession (inSession);                                              

     -- ������ � ���� ������ - ������ �� ������, �.�. �� ������ ���������� "������" ���
     IF ioId = 0 AND TRIM (inInvNumber) = ''
     THEN
         RETURN; -- !!!�����!!!
     END IF;

     -- ��������
     IF COALESCE (ioId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�������� �� ��������.';
     END IF;

     -- �������� - ����� ������ ? - �� �������� �������� ���������
     IF NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = ioId AND Movement.InvNumber = inInvNumber AND Movement.OperDate = inOperDate AND  Movement.DescId = zc_Movement_ReestrTransportGoods())
     THEN
         RAISE EXCEPTION '������.��� ���� ������ ���� ��������� <%> <%> <%>.', zfConvert_DateToString (inOperDate), inInvNumber, ioId;
     END IF;

     -- ��������� <��������>,
     ioId:= lpInsertUpdate_Movement_ReestrTransportGoods (ioId               := ioId
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
 31.01.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_ReestrTransportGoods (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inSession:= '2')
