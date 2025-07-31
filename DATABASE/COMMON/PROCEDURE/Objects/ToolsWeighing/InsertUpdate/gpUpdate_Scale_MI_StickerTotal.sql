-- Function: gpUpdate_Scale_MI_StickerTotal()

DROP FUNCTION IF EXISTS gpUpdate_Scale_MI_StickerTotal (Integer, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Scale_MI_StickerTotal(
    IN inMovementItemId  Integer      ,
    IN inValue           Boolean      , --
    IN inBranchCode      Integer      , --
    IN inSession         TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId               Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);
   
     -- ��������� ��������
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_BarCode(), inMovementItemId, inValue);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.07.25                                        *
*/

-- ����
-- SELECT *, AmountTotal - WeightTare_add  FROM gpUpdate_Scale_MI_StickerTotal (331192570, zfCalc_UserAdmin())
