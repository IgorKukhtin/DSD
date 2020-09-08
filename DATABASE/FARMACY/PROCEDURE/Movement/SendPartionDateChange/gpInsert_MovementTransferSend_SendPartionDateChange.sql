-- Function: gpInsert_MovementTransferSend_SendPartionDateChange()

DROP FUNCTION IF EXISTS gpInsert_MovementTransferSend_SendPartionDateChange (Integer, TDateTime, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementTransferSend_SendPartionDateChange(
    IN inContainerID    Integer   , -- ID ���������� ��� ��������� �����
    IN inExpirationDate TDateTime , -- ����� ����
    IN inAmount         TFloat    , -- ����������
    IN inMISendId       TVarChar  , -- �������� �����������
    IN inSession        TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMISendId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbIndex Integer;
BEGIN

  vbUserId:= lpGetUserBySession (inSession);

  vbMovementItemId := gpInsert_MovementTransfer_SendPartionDateChange(inContainerID    := inContainerID
                                                                    , inExpirationDate := inExpirationDate
                                                                    , inAmount         := inAmount
                                                                    , inSession        := inSession);


 -- ������ �����������
  vbIndex := 1;
  WHILE SPLIT_PART (inMISendId, ';', vbIndex) <> '' LOOP
      -- ��������� �� ��� �����
      vbMISendId := SPLIT_PART (inMISendId, ';', vbIndex) :: Integer;
      -- ��������� �������� <���������� ����>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MISendPDChangeId(), vbMISendId, vbMovementItemId);
      -- ������ ����������
      vbIndex := vbIndex + 1;
  END LOOP;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 29.08.20                                                       *
*/

-- ����
-- select * from gpInsert_MovementTransferSend_SendPartionDateChange(inContainerID := 22598207 , inExpirationDate := ('01.01.2021')::TDateTime , inAmount := 2 , inMISendId := '369433676' ,  inSession := '3');