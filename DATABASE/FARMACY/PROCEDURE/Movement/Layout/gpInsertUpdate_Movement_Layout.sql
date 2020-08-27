-- Function: gpInsertUpdate_Movement_Layout()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Layout (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Layout(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inLayoutId            Integer   , -- �������� ��������
    IN inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Layout());
     vbUserId:= lpGetUserBySession (inSession);
	 
     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_Layout (ioId           := ioId
                                           , inInvNumber    := inInvNumber
                                           , inOperDate     := inOperDate
                                           , inLayoutId     := inLayoutId
                                           , inComment      := inComment
                                           , inUserId       := vbUserId
                                            );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.08.20         *
 */

-- ����
--