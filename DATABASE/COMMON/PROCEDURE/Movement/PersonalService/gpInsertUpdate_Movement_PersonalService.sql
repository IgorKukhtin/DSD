-- Function: gpInsertUpdate_Movement_PersonalService()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PersonalService (Integer, TVarChar, TDateTime, TDateTime, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PersonalService(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inServiceDate         TDateTime , -- ���� ����������
    IN inComment             TVarChar  , -- �����������
    IN inPersonalServiceListId  Integer  , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PersonalService());
     vbUserId:= inSession;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_PersonalService (ioId           := ioId
                                         , inInvNumber               := inInvNumber
                                         , inOperDate                := inOperDate
                                         , inServiceDate             := inServiceDate
                                         , inComment                 := inComment
                                         , inPersonalServiceListId   := inPersonalServiceListId 
                                         , inUserId                  := vbUserId
                                          );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 11.09.14         *
 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_PersonalService (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inServiceDate:= '01.01.2013', inComment:= 'xxx', inSession:= '2')