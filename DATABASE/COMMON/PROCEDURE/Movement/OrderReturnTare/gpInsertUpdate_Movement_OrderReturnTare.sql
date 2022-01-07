-- Function: gpInsertUpdate_Movement_OrderReturnTare()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderReturnTare (Integer, TVarChar, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderReturnTare(
 INOUT ioId                      Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber               TVarChar  , -- ����� ���������
    IN inOperDate                TDateTime , -- ���� ���������
    IN inComment                 TVarChar  , -- ����������
    IN inSession                 TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbisAuto Boolean;
   DECLARE vbOperDate_StartBegin TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderReturnTare());

     -- ����������
     SELECT tmp.ioId
            INTO ioId
     FROM lpInsertUpdate_Movement_OrderReturnTare (ioId        := ioId
                                                 , inInvNumber := inInvNumber
                                                 , inOperDate  := inOperDate
                                                 , inComment   := inisPrintComment
                                                 , inUserId    := vbUserId
                                                ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.01.22         *
*/

-- ����
--