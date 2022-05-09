-- Function: gpInsertUpdate_Movement_CompetitorMarkups()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_CompetitorMarkups (Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_CompetitorMarkups(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_CompetitorMarkups());
    inOperDate := date_trunc('day', inOperDate);

    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement_CompetitorMarkups (ioId          := ioId
                                                     , inInvNumber       := inInvNumber
                                                     , inOperDate        := inOperDate
                                                     , inUserId          := vbUserId
                                                     );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.05.22                                                        *
*/
