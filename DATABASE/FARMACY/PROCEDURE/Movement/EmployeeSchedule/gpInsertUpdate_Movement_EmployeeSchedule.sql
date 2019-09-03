-- Function: gpInsertUpdate_Movement_EmployeeSchedule()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_EmployeeSchedule (Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_EmployeeSchedule(
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
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EmployeeSchedule());
    vbUserId := inSession;
    ioOperDate := date_trunc('month', ioOperDate);

    -- �������� ���� ������������ �� ����� ���������
    IF vbUserId NOT IN (3, 758920, 4183126, 9383066)
    THEN
      RAISE EXCEPTION '��������� <������ ������ �����������> ��� ���������.';
    END IF;

    IF COALESCE (ioId, 0) = 0 AND
       EXISTS(SELECT 1 FROM Movement
              WHERE Movement.DescId = zc_Movement_EmployeeSchedule()
                AND Movement.OperDate = ioOperDate)
    THEN
       SELECT Movement.ID 
       INTO ioId
       FROM Movement
       WHERE Movement.DescId = zc_Movement_EmployeeSchedule()
         AND Movement.OperDate = ioOperDate;
    END IF;

    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement_EmployeeSchedule (ioId          := ioId
                                        , inInvNumber       := inInvNumber
                                        , inOperDate        := ioOperDate
                                        , inUserId          := vbUserId
                                        );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������ �.�.
 09.12.18         *
*/
