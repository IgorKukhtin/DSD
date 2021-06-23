-- Function: gpInsertUpdate_Movement_Send()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Send(Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Send(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ����
    IN inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Send());
    vbUserId := lpGetUserBySession (inSession);

    --
    ioId := lpInsertUpdate_Movement_Send(ioId
                                       , inInvNumber
                                       , inOperDate
                                       , inFromId
                                       , inToId
                                       , inComment
                                       , vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.06.21         *
*/

-- ����
--