 -- Function: gpUpdate_MI_ProductionUnion_AmountForm_two()

DROP FUNCTION IF EXISTS gpUpdate_MI_ProductionUnion_AmountForm_two (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ProductionUnion_AmountForm_two(
    IN inMovementItemId       Integer   , -- ���� ������� <>
    IN inAmountForm_two       TFloat    , -- ���-�� ��������+2����,��
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_MI_ProductionUnion_AmountForm_two());
   
   -- ��������
   IF COALESCE (inMovementItemId, 0) = 0 
   THEN
       RAISE EXCEPTION '������.������ �� ���������.';
   END IF;

   -- ��������� �������� <���-�� ��������+1����,��>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountForm_two(), inMovementItemId, inAmountForm_two);
 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.03.25         * 
*/

-- ����
-- 