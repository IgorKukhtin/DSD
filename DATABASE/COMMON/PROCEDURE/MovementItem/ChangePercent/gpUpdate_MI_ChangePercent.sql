-- Function: gpUpdate_MI_ChangePercent()

DROP FUNCTION IF EXISTS gpUpdate_MI_ChangePercent (integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_MI_ChangePercent(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ChangePercent());
     vbUserId:= lpGetUserBySession (inSession);

     -- ��������� ������
     PERFORM lpInsertUpdate_MI_ChangePercent_byTax (inMovementId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.03.23         *
*/

-- ����
--