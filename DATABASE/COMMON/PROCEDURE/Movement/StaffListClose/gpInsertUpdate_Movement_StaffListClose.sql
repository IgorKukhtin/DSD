-- Function: gpInsertUpdate_Movement_StaffListClose()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_StaffListClose (Integer, TVarChar, TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_StaffListClose(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ������ �������
    IN inTimeClose           TDateTime , -- ����, ����� ���� �������� 
    IN inUnitId              Integer   , -- �������������(����������)
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_StaffListClose());


     /*
     -- ��������
     IF DATE_TRUNC ('DAY', inTimeClose) <= inOperDateEnd
     THEN
         RAISE EXCEPTION '������. ����+����� ���� �������� �� ����� ���� ������ <%>.', zfConvert_DateToString (inOperDateEnd + INTERVAL '1 DAY');
     END IF;
     */

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
     FROM lpInsertUpdate_Movement_StaffListClose (ioId           := ioId
                                                , inInvNumber    := inInvNumber
                                                , inOperDate     := inOperDate
                                                , inTimeClose    := inTimeClose
                                                , inUnitId       := inUnitId
                                                , inUserId       := vbUserId
                                                 ) AS tmp;

     -- �������� ��������
     PERFORM lpComplete_Movement (inMovementId := ioId
                                , inDescId     := zc_Movement_StaffListClose()
                                , inUserId     := vbUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.09.25         *
*/

-- ����
--