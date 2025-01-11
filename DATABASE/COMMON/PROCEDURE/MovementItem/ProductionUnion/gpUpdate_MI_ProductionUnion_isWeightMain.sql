 -- Function: gpUpdate_MI_ProductionUnion_isWeightMain()

DROP FUNCTION IF EXISTS gpUpdate_MI_ProductionUnion_isWeightMain (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ProductionUnion_isWeightMain(
    IN inMovementItemId       Integer   , -- ���� ������� <>
    IN inisWeightMain         Boolean   , -- 
   OUT outisWeightMain        Boolean   , --
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_MI_ProductionUnion_isWeightMain());
   
   -- ��������
   IF COALESCE (inMovementItemId, 0) = 0 
   THEN
       RAISE EXCEPTION '������.������ �� ���������.';
   END IF;

   outisWeightMain := Not inisWeightMain;
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_WeightMain(), inMovementItemId, outisWeightMain);
 
   IF vbUserId = 9457 
   THEN
        RAISE EXCEPTION 'Test.OK';
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.01.25         * 
*/

-- ����
-- 