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
-- select lpInsertUpdate_MovementFloat_TotalSummInventory (inMovementId:= id) from gpSelect_Movement_WeighingPartner (inStartDate := ('01.06.2014')::TDateTime , inEndDate := ('30.06.2014')::TDateTime ,  inSession := '5') as a
-- ����
-- SELECT lpInsertUpdate_MovementFloat_TotalSummInventory (inMovementId:= Movement.Id) from Movement where DescId = zc_Movement_Inventory() and OperDate between ('01.11.2014')::TDateTime and  ('31.12.2014')::TDateTime
