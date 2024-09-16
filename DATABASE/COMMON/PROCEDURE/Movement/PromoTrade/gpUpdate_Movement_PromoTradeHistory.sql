-- Function: gpUpdate_Movement_PromoTradeHistory()

DROP FUNCTION IF EXISTS gpUpdate_Movement_PromoTradeHistory (Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Movement_PromoTradeHistory(
    IN inId                  Integer   , -- ���� ������� <�������� �����������>
 INOUT ioisTotalSumm_GoodsReal Boolean   , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer; 
   DECLARE vbOperDateStart TDateTime;
   DECLARE vbOperDateEnd TDateTime;
   
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PromoTrade());

     --
     vbOperDateStart := (SELECT MD.ValueDate FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDateStart())::TDateTime;
     vbOperDateEnd   := (SELECT MD.ValueDate FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDateEnd())::TDateTime;

     


     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE); 

     IF vbUserId = 9457 THEN  RAISE EXCEPTION 'TEST.OK.'; END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�. 
 16.09.24         *
 */

-- ����
--