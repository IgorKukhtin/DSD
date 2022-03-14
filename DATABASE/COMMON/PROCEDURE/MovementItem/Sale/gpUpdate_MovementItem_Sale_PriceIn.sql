-- Function: gpUpdate_MovementItem_Sale_PriceIn()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Sale_PriceIn (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Sale_PriceIn(
    IN inMovementId              Integer   , -- ���� ������� <��������>
    IN inSession                 TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_Sale_Price());

     -- ���������
     PERFORM lpUpdate_MovementItem_Sale_PriceIn (inMovementId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.01.22         *
*/
