-- Function: gpInsertUpdate_Movement_RetutnIn()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_RetutnIn (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_RetutnIn(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inUnitId                Integer    , -- �� ���� (�������������)
    IN inCashRegisterId        Integer    , -- 
    IN inFiscalCheckNumber     TVarChar   , -- 
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_RetutnIn());
    vbUserId := inSession;

    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement_RetutnIn (ioId                 := ioId
                                            , inInvNumber          := inInvNumber
                                            , inOperDate           := inOperDate
                                            , inUnitId             := inUnitId
                                            , inCashRegisterId     := inCashRegisterId
                                            , inFiscalCheckNumber  := inFiscalCheckNumber
                                            , inUserId             := vbUserId
                                            );
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.01.19         *
*/