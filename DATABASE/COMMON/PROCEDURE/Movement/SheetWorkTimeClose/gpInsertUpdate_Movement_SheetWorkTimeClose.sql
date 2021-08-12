-- Function: gpInsertUpdate_Movement_SheetWorkTimeClose()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SheetWorkTimeClose (Integer, TVarChar, TDateTime, TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SheetWorkTimeClose (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_SheetWorkTimeClose(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ������ �������
    IN inOperDateEnd         TDateTime , -- ���� ��������� �������
    IN inTimeClose           TDateTime , -- ����� ���� ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SheetWorkTimeClose());


     -- ��������� <��������>
      SELECT tmp.ioId
    INTO ioId
      FROM lpInsertUpdate_Movement_SheetWorkTimeClose (ioId           := ioId
                                                     , inInvNumber    := inInvNumber
                                                     , inOperDate     := inOperDate
                                                     , inOperDateEnd  := inOperDateEnd
                                                     , inTimeClose    := inTimeClose
                                                     , inUserId       := vbUserId
                                                      ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.08.21         *
*/

-- ����
--