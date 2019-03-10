-- Function: gpInsertUpdate_Movement_PUSH()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PUSH (Integer, TVarChar, TDateTime, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PUSH(
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
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_UnnamedEnterprises());
    vbUserId := inSession;

    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement_PUSH (ioId              := ioId
                                        , inInvNumber       := inInvNumber
                                        , inOperDate        := inOperDate
                                        , inUserId          := vbUserId
                                        );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������ �.�.
 16.11.18         *
 30.09.18         *
*