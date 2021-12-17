-- Function: gpInsert_MovementItem_Pretension()

DROP FUNCTION IF EXISTS gpInsert_MovementItem_Pretension(Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementItem_Pretension(
 INOUT ioMovementId          Integer   , -- ���� ������� <��������>
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ����
    IN inParentId            Integer   , -- ��������� ���������
    IN inMIParentId          Integer   , -- ������ �� ��������
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inReasonDifferencesId Integer   , -- ������� �����������
    IN inAmountIncome        TFloat    , -- ���������� ������
    IN inAmountManual        TFloat    , -- ����. ���-��
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementIncomeId Integer;
   DECLARE vbAmountIncome TFloat;
   DECLARE vbAmountOther TFloat;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     --vbUserId := inSession;
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Pretension());
     
     IF COALESCE (inAmount, 0) = 0 OR COALESCE (inReasonDifferencesId, 0) = 0
     THEN
       RETURN;
     END IF;
     
     IF COALESCE (ioMovementId, 0) = 0
     THEN
 
       ioMovementId := lpInsertUpdate_Movement_Pretension(0
                                                        , CAST (NEXTVAL ('movement_Pretension_seq') AS TVarChar) 
                                                        , CURRENT_DATE
                                                        , inFromId
                                                        , inToId
                                                        , inParentId
                                                        , ''
                                                        , vbUserId);     
     END IF;
     
     PERFORM lpInsertUpdate_MovementItem_Pretension(0, ioMovementId, inMIParentId, inGoodsId, inAmount, inReasonDifferencesId, inAmountIncome, inAmountManual, True, vbUserId);

     -- ����������� �������� �����
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm_Pretension (ioMovementId);
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.12.21                                                       *
*/

-- ����
-- SELECT * FROM gpInsert_MovementItem_Pretension ()