-- Function: gpInsertUpdate_Movement_Loss()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Loss (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Loss(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inUnitId              Integer   , -- �������������
    IN inArticleLossId       Integer   , -- ������ ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Loss());
	 
     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_Loss (ioId               := ioId
                                         , inInvNumber        := inInvNumber
                                         , inOperDate         := inOperDate
                                         , inUnitId           := inUnitId
                                         , inArticleLossId    := inArticleLossId
                                         , inUserId           := vbUserId
                                          );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Movement_Loss (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 20.07.15                                                                      *
 */

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Loss (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inUnitId:= 1, inArticleLossId = 1, inSession:= '3')
