-- Function: gpInsertUpdate_Movement_MemberHoliday ()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_MemberHoliday (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_MemberHoliday (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_MemberHoliday(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inOperDateStart       TDateTime   , -- 
    IN inOperDateEnd         TDateTime  , -- 
    IN inBeginDateStart      TDateTime   , --
    IN inBeginDateEnd        TDateTime   , --
    IN inMemberId            Integer   , -- 
    IN inMemberMainId        Integer   , --   
    IN inWorkTimeKindId      Integer   , -- ��� �������  
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_MemberHoliday());
     vbUserId:= lpGetUserBySession (inSession);

     --�������� �������� ��� ������� ������ ���� ���������
     IF COALESCE (inWorkTimeKindId,0) = 0
     THEN
          RAISE EXCEPTION '������.<��� �������> ������ ���� ��������.';
     END IF;

     -- ��������� <��������>
     ioId:= lpInsertUpdate_Movement_MemberHoliday ( ioId              := ioId
                                                  , inInvNumber       := inInvNumber
                                                  , inOperDate        := inOperDate
                                                  , inOperDateStart   := inOperDateStart
                                                  , inOperDateEnd     := inOperDateEnd
                                                  , inBeginDateStart  := inBeginDateStart
                                                  , inBeginDateEnd    := inBeginDateEnd
                                                  , inMemberId        := inMemberId
                                                  , inMemberMainId    := inMemberMainId
                                                  , inWorkTimeKindId  := inWorkTimeKindId
                                                  , inUserId          := vbUserId
                                                   );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.12.18         *
*/

-- ����
--