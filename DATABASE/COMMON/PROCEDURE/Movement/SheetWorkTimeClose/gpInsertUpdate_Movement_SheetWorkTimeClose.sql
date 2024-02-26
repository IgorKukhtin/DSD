-- Function: gpInsertUpdate_Movement_SheetWorkTimeClose()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SheetWorkTimeClose (Integer, TVarChar, TDateTime, TDateTime, TDateTime, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SheetWorkTimeClose (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SheetWorkTimeClose (Integer, TVarChar, TDateTime, TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_SheetWorkTimeClose(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ������ �������
    IN inOperDateEnd         TDateTime , -- ���� ��������� �������
    IN inTimeClose           TDateTime , -- ����, ����� ���� �������� 
    IN inUnitId              Integer   , -- �������������(����������)
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SheetWorkTimeClose());


     -- ��������
     IF DATE_TRUNC ('DAY', inTimeClose) <= inOperDateEnd
     THEN
         RAISE EXCEPTION '������. ����+����� ���� �������� �� ����� ���� ������ <%>.', zfConvert_DateToString (inOperDateEnd + INTERVAL '1 DAY');
     END IF;

     -- 1. ����  update
     IF ioId > 0 AND EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = ioId AND Movement.StatusId <> zc_Enum_Status_UnComplete())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId
                                       );
     END IF;

     -- ��������� <��������>
     SELECT tmp.ioId
            INTO ioId
     FROM lpInsertUpdate_Movement_SheetWorkTimeClose (ioId           := ioId
                                                    , inInvNumber    := inInvNumber
                                                    , inOperDate     := inOperDate
                                                    , inOperDateEnd  := inOperDateEnd
                                                    , inTimeClose    := inTimeClose -- (DATE_TRUNC ('DAY', inOperDateEnd) + INTERVAL '1 DAY' + (inTimeClose - DATE_TRUNC ('DAY', inTimeClose))  :: INTERVAL) :: TDateTime
                                                    , inUnitId       := inUnitId
                                                    , inUserId       := vbUserId
                                                     ) AS tmp;

     -- �������� ��������
     PERFORM lpComplete_Movement (inMovementId := ioId
                                , inDescId     := zc_Movement_SheetWorkTimeClose()
                                , inUserId     := vbUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.02.24         *
 10.08.21         *
*/

-- ����
--