-- Function: gpInsertUpdate_Movement_EmployeeSchedule()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Wages (Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Wages(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
 INOUT ioOperDate              TDateTime  , -- ���� ���������
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS Record AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());
    ioOperDate := date_trunc('month', ioOperDate);

    IF COALESCE (ioId, 0) = 0
    THEN
      IF EXISTS(SELECT 1 FROM Movement WHERE Movement.OperDate = ioOperDate AND Movement.DescId = zc_Movement_Wages())
      THEN
        SELECT Movement.ID
        INTO ioId  
        FROM Movement 
        WHERE Movement.OperDate = ioOperDate 
          AND Movement.DescId = zc_Movement_Wages();
      END IF;
    END IF;

    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement_Wages (ioId          := ioId
                                         , inInvNumber       := inInvNumber
                                         , inOperDate        := ioOperDate
                                         , inUserId          := vbUserId
                                         );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.08.19                                                        *
*/
