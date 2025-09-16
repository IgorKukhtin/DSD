-- Function: lpInsertUpdate_Movement_StaffListMember ()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_StaffListMember (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_StaffListMember(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inMemberId            Integer   , -- 
    IN inPositionId          Integer   , --
    IN inPositionLevelId     Integer   , --
    IN inUnitId              Integer   , --
    IN inPositionId_old      Integer   , --
    IN inPositionLevelId_old Integer   , --
    IN inUnitId_old          Integer   , --
    IN inReasonOutId         Integer   , --
    IN inStaffListKindId     Integer   , --
    IN inisOfficial          Boolean   , --
    IN inisMain              Boolean   , --
    IN inComment             TVarChar  , --
    IN inUserId              Integer     -- ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- 1. ����������� ��������
     IF ioId > 0
     THEN
         -- ������� �������������
         PERFORM gpUnComplete_Movement_StaffListMember (inMovementId := ioId
                                                      , inSession    := inUserId :: TVarChar
                                                       );
     END IF;
     
     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_StaffListMember(), inInvNumber, inOperDate, NULL);
    
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member(), ioId, inMemberId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Position(), ioId, inPositionId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PositionLevel(), ioId, inPositionLevelId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Position_old(), ioId, inPositionId_old);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PositionLevel_old(), ioId, inPositionLevelId_old);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit_old(), ioId, inUnitId_old);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReasonOut(), ioId, inReasonOutId);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Official(), ioId, inisOfficial);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Main(), ioId, inisMain);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     
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


     -- 5.2. ����� �������� �������� + ��������� ��������
     PERFORM gpComplete_Movement_StaffListMember (inMovementId := ioId
                                                , inSession    := inUserId :: TVarChar
                                                 );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.09.25         *
*/

-- ����
--