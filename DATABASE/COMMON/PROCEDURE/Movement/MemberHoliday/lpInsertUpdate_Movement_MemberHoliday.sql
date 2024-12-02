-- Function: lpInsertUpdate_Movement_MemberHoliday ()

--DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_MemberHoliday (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_MemberHoliday (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_MemberHoliday(
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
    IN inUserId              Integer     -- ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- ���������� ���� �������
     --vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_MemberHoliday());

     -- 1. ����������� ��������
     IF ioId > 0
     THEN
         -- ������� �������������
         PERFORM gpUnComplete_Movement_MemberHoliday (inMovementId := ioId
                                                    , inSession    := inUserId :: TVarChar
                                                     );
         -- ����� �������� - � ������ ��������� WorkTimeKind
         --IF inUserId <> 5 THEN PERFORM gpInsertUpdate_MovementItem_SheetWorkTime_byMemberHoliday(ioId, TRUE, (inUserId)::TVarChar);
         --END IF;
     END IF;
     
     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_MemberHoliday(), inInvNumber, inOperDate, NULL);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateStart(), ioId, inOperDateStart);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateEnd(), ioId, inOperDateEnd);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_BeginDateStart(), ioId, inBeginDateStart);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_BeginDateEnd(), ioId, inBeginDateEnd);
     
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member(), ioId, inMemberId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_MemberMain(), ioId, inMemberMainId);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_WorkTimeKind(), ioId, inWorkTimeKindId);
     
     IF vbIsInsert = TRUE
     THEN
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
     ELSE
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     END IF;

  
     -- 5.1. ������� ����������� � zc_Movement_SheetWorkTime ���������� �� ������ �������������� WorkTimeKind - ��� ������������� ��� �������� - � ������ ��������� WorkTimeKind
     -- IF inUserId <> 5 THEN PERFORM gpInsertUpdate_MovementItem_SheetWorkTime_byMemberHoliday(ioId, FALSE, (-1 * inUserId)::TVarChar);
     -- END IF;

     -- 5.2. ����� �������� �������� + ��������� ��������
     PERFORM gpComplete_Movement_MemberHoliday (inMovementId := ioId
                                              , inSession    := inUserId :: TVarChar
                                               );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.08.21         * inWorkTimeKindId
 20.12.18         *
*/

-- ����
--