-- Function: gpInsertUpdate_Movement_RepriceChange()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_RepriceChange (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_RepriceChange(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inRetailId              Integer    , -- �� ���� (����.����)
    IN inGUID                  TVarChar   , -- GUID ��� ����������� ������� ����������
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_RepriceChange());
    vbUserId := inSession;
    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement_RepriceChange (ioId          := ioId
                                                 , inInvNumber   := inInvNumber
                                                 , inOperDate    := inOperDate
                                                 , inRetailId    := inRetailId
                                                 , inGUID        := inGUID
                                                 , inUserId      := vbUserId
                                                 );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.08.18         *
*/