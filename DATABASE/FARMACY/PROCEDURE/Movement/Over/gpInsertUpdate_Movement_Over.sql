-- Function: gpInsertUpdate_Movement_Over()
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Over (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Over(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inUnitId              Integer   , -- �������������
    IN inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
  
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Over());
    vbUserId := inSession;

    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement_Over (ioId             := ioId
                                        , inInvNumber      := inInvNumber
                                        , inOperDate       := inOperDate
                                        , inUnitId         := inUnitId
                                        , inComment        := inComment
                                        , inUserId         := vbUserId
                                        );

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.06.16         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Over (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
