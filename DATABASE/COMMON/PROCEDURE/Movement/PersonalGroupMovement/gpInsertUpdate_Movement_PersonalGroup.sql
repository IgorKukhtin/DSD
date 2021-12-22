-- Function: gpInsertUpdate_Movement_PersonalGroup()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PersonalGroup (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PersonalGroup(
 INOUT ioId                  Integer   , -- ���� ������� <>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ����()
    IN inUnitId              Integer   , -- 
    IN inPersonalGroupId     Integer   , -- 
    IN inPairDayId           Integer   , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalGroupId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PersonalGroup());

     --vbUserId:=:= (CASE WHEN vbUserId = 5 THEN 140094 ELSE vbUserId);

     -- ����� ������ ������� ��������� ��������� MovementItem
     vbPersonalGroupId := (SELECT MovementLinkObject_PersonalGroup.ObjectId AS PersonalGroupId
                           FROM MovementLinkObject AS MovementLinkObject_PersonalGroup
                           WHERE MovementLinkObject_PersonalGroup.MovementId = ioId
                             AND MovementLinkObject_PersonalGroup.DescId = zc_MovementLinkObject_PersonalGroup()
                           );

     IF COALESCE (vbPersonalGroupId,0) <> 0 AND vbPersonalGroupId <> inPersonalGroupId
     THEN
         RAISE EXCEPTION '������.�������� ����� ��������� ��� ��������� ��� <%>', lfGet_Object_ValueData (vbPersonalGroupId);
     END IF;

     -- ��������� <��������>
     ioId:= lpInsertUpdate_Movement_PersonalGroup (ioId              := ioId
                                                 , inInvNumber       := inInvNumber
                                                 , inOperDate        := inOperDate
                                                 , inUnitId          := inUnitId
                                                 , inPersonalGroupId := inPersonalGroupId
                                                 , inPairDayId       := inPairDayId
                                                 , inUserId          := vbUserId
                                                  )AS tmp;

     IF COALESCE (vbPersonalGroupId,0) = 0 AND COALESCE (inPersonalGroupId,0) <> 0
     THEN
         PERFORM gpInsert_MI_PersonalGroup (inMovementId := ioId
                                          , inSession := inSession);
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.11.21         *
*/

-- ����
--