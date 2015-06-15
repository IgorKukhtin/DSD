-- Function: gpInsertUpdate_Movement_ProductionSeparate()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProductionSeparate (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProductionSeparate(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inPartionGoods        TVarChar  , -- ������ ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProductionSeparate());

   -- ��������� <��������>
   ioId := lpInsertUpdate_Movement_ProductionSeparate (ioId          := ioId
                                                     , inInvNumber   := inInvNumber
                                                     , inOperDate    := inOperDate
                                                     , inFromId      := inFromId
                                                     , inToId        := inToId
                                                     , inPartionGoods:= inPartionGoods
                                                     , inUserId      := vbUserId
                                                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 11.06.15                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_ProductionSeparate (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFromId:= 1, inToId:= 2, inSession:= '2')
