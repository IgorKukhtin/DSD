-- Function: gpUpdateMI_OrderInternal_Amount_to()

DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_Amount_to (Integer, Integer, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderInternal_Amount_to(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inAmount              TFloat    , -- 
    IN inIsClear             Boolean   , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId  Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderInternal());


    IF inIsClear = TRUE
    THEN
        -- ��������
        UPDATE MovementItem SET Amount = 0 WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master();

        -- ����������� �������� ����� �� ���������
        PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

    ELSEIF inAmount > 0
    THEN

        -- ��������
        IF COALESCE (inGoodsId, 0) = 0
        THEN
            RAISE EXCEPTION '������.�� ���������� �������� <�����>.';
        END IF;
        -- �������� + �������� �����������
        IF NOT EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.DescId = zc_MILinkObject_GoodsKind() AND MovementItemId = inMovementId AND ObjectId IN (SELECT tmp.UnitId FROM lfSelect_Object_Unit_byGroup (8446) AS tmp)) -- ��� �������+���-��
        THEN
            RAISE EXCEPTION '������.�� ���������� �������� <��� ������>.';
        END IF;

        -- ���������
        UPDATE MovementItem SET Amount = inAmount WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master() AND MovementItem.Id = inId;

        -- ����������� �������� ����� �� ���������
        PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

        -- ��������� ��������
        PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.11.17                                        *
*/

-- ����
-- SELECT * FROM gpUpdateMI_OrderInternal_Amount_to (inMovementId:= 7343799, inOperDate:= '31.10.2017', inSession:= zfCalc_UserAdmin());
