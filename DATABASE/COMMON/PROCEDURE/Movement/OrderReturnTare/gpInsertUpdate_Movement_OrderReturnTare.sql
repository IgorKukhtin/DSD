-- Function: gpInsertUpdate_Movement_OrderReturnTare()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderReturnTare (Integer, TVarChar, TDateTime, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderReturnTare (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderReturnTare (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderReturnTare(
 INOUT ioId                      Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber               TVarChar  , -- ����� ���������
    IN inOperDate                TDateTime , -- ���� ���������
    IN inMovementId_Transport    Integer   , -- ������� ����  
    IN inManagerId               Integer   , -- ����������� ���.������
    IN inSecurityId              Integer   , -- ����� ������������
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
                                                 , inMovementId_Transport := inMovementId_Transport 
                                                 , inManagerId := inManagerId
                                                 , inSecurityId := inSecurityId
                                                 , inComment   := inComment
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