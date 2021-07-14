-- Function: gpInsertUpdate_Movement_ProductionPersonal()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProductionPersonal(Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProductionPersonal(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inUnitId              Integer   , -- �������������
    IN inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProductionPersonal());
    vbUserId := lpGetUserBySession (inSession);

    --
    ioId := lpInsertUpdate_Movement_ProductionPersonal(ioId
                                                     , inInvNumber
                                                     , inOperDate
                                                     , inUnitId
                                                     , inComment
                                                     , vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.07.21         *
*/

-- ����
--