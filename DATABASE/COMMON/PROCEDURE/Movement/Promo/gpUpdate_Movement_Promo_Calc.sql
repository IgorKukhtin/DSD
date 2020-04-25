-- Function: gpUpdate_Movement_Promo_Calc()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Promo_Calc (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Promo_Calc(
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate   TDateTime;
   DECLARE vbUnitId    Integer;
   DECLARE vbStatusId  Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Promo_Data());

    -- ��������� �� ��������� <�����>
    SELECT Movement_Promo_View.StatusId
         , Movement_Promo_View.StartSale
         , Movement_Promo_View.EndSale
         , COALESCE (Movement_Promo_View.UnitId, 0)
      INTO vbStatusId, vbStartDate, vbEndDate, vbUnitId
    FROM Movement_Promo_View
    WHERE Movement_Promo_View.Id = inMovementId
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.  ��������� �.�.
 09.08.17         *
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_Promo_Calc (inMovementId:= 2641111, inSession:= zfCalc_UserAdmin())