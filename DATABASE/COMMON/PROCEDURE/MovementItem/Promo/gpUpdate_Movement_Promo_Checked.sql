-- Function: gpUpdate_Movement_Promo_Checked()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Promo_Checked (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Promo_Checked(
    IN inId                    Integer   , -- ���� ������� <������� ���������>
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId          Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
    
      
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.06.20         
*/
