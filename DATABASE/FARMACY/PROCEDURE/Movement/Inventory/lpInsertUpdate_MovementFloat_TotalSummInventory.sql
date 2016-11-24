-- Function: lpInsertUpdate_MovementFloat_TotalSumm (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummInventory (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSummInventory(
    IN inMovementId Integer -- ���� ������� <��������>
)
  RETURNS VOID AS
$BODY$
    
    DECLARE 
        vbDeficitSumm   TFloat; --��������� �����
        vbProficitSumm  TFloat; --������� �����
        vbDiff          TFloat; --������� ���-��
        vbDiffSumm      TFloat; --������� �����

BEGIN
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION '������.������� ��������� �� ��������.';
    END IF;

    
    SELECT
        SUM(MovementItem_Inventory.DeficitSumm)::TFloat,
        SUM(MovementItem_Inventory.ProficitSumm)::TFloat,
        SUM(MovementItem_Inventory.Diff)::TFloat,
        SUM(MovementItem_Inventory.DiffSumm)::TFloat
    INTO
        vbDeficitSumm,  --��������� �����
        vbProficitSumm, --������� �����
        vbDiff,         --������� ���-��
        vbDiffSumm      --������� �����
    FROM gpSelect_MovementItem_Inventory(inMovementId := inMovementId, -- ���� ���������
                                         inShowAll    := FALSE, --
                                         inIsErased   := FALSE, --
                                         inSession    := '') AS MovementItem_Inventory;-- ������ ������������
    

    -- ��������� �������� <����� ����� ���������>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalDeficitSumm(), inMovementId, vbDeficitSumm);
      
    -- ��������� �������� <����� ����� �������>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalProficitSumm(), inMovementId, vbProficitSumm);
    
    -- ��������� �������� <����� ������� � ����������>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalDiff(), inMovementId, vbDiff);
    
    -- ��������� �������� <����� ������� � �����>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalDiffSumm(), inMovementId, vbDiffSumm);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSummInventory (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.04.15                         * 
*/

-- ����
-- SELECT lpInsertUpdate_MovementFloat_TotalSummInventory (inMovementId:= Movement.Id) FROM Movement WHERE DescId = zc_Movement_Inventory() and OperDate BETWEEN '01.11.2016' and '31.11.2016'
