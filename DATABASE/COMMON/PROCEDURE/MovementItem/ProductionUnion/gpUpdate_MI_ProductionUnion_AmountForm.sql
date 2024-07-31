 -- Function: gpUpdate_MI_ProductionUnion_AmountForm()

DROP FUNCTION IF EXISTS gpUpdate_MI_ProductionUnion_AmountForm (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ProductionUnion_AmountForm(
    IN inMovementItemId       Integer   , -- ���� ������� <>
    IN inAmountForm           TFloat    , -- ���-�� ��������+1����,��
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_MI_ProductionUnion_AmountForm());
   
   -- ��������
   IF COALESCE (inMovementItemId, 0) = 0 
   THEN
       RAISE EXCEPTION '������.������ �� ���������.';
   END IF;

   -- ��������� �������� <���-�� ��������+1����,��>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountForm(), inMovementItemId, inAmountForm);
 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.07.24         * 
*/

-- ����
-- 