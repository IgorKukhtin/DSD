-- Function: gpInsertUpdate_Movement_ServiceItemAdd()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ServiceItemAdd(Integer, TVarChar, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ServiceItemAdd(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
    IN inInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbInfoMoneyId Integer;
   DECLARE vbCommentInfoMoneyId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ServiceItemAdd());
     vbUserId:= lpGetUserBySession (inSession);

     -- ��������� <��������>
     ioId:= lpInsertUpdate_Movement_ServiceItemAdd (ioId                   := ioId
                                               , inInvNumber            := inInvNumber
                                               , inOperDate             := inOperDate
                                               , inUserId               := vbUserId
                                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.06.22         *
 */

-- ����
--