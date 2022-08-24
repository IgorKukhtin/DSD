-- Function: gpInsertUpdate_Movement_PersonalTransport()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PersonalTransport (Integer, TVarChar, TDateTime, TDateTime, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PersonalTransport(
 INOUT ioId                     Integer   , -- ���� ������� <��������>
    IN inInvNumber              TVarChar  , -- ����� ���������
    IN inOperDate               TDateTime , -- ���� ���������
    IN inServiceDate            TDateTime , -- ����� ����������
    IN inPersonalServiceListId  Integer   , -- ��������� ����������
    IN inComment                TVarChar  , -- ����������
    IN inSession                TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PersonalTransport());

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_PersonalTransport (ioId                      := ioId
                                                      , inInvNumber               := inInvNumber
                                                      , inOperDate                := inOperDate
                                                      , inServiceDate             := inServiceDate
                                                      , inPersonalServiceListId   := inPersonalServiceListId 
                                                      , inComment                 := inComment
                                                      , inUserId                  := vbUserId
                                                       );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.08.22         *
*/

-- ����
--