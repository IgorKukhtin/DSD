-- Function: gptUpdateMI_Cash_Personal_AmountParam()

DROP FUNCTION IF EXISTS gptUpdateMI_Cash_Personal_AmountParam (Integer, Integer, Integer, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS gptUpdateMI_Cash_Personal_AmountParam (Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gptUpdateMI_Cash_Personal_AmountParam (
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inPersonalId          Integer   , -- ����������
 INOUT ioAmount              TFloat    , -- ����� � �������
 INOUT ioSummRemains         TFloat    , -- ������� � ������� 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS record AS --Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash());

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;
     
     -- ������� � �������
     ioAmount := COALESCE(ioAmount,0) + COALESCE (ioSummRemains,0);
     
     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inPersonalId, inMovementId, ioAmount, NULL);
 
     -- ������� �������� � �������
     ioSummRemains := 0 :: TFLOAT;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

      -- ��������� ��������
      PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 16.09.14         *
*/

-- ����
-- SELECT * FROM gptUpdateMI_Cash_Personal_AmountParam(ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')

--select * from gptUpdateMI_Cash_Personal_AmountParam(ioId := 11967866 , inMovementId := 1015917 , inPersonalId := 280263 , ioAmount := 8 , ioSummRemains := 450 ,  inSession := '5');