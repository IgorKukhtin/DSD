-- Function: gpUpdate_PriceWithoutPersent()

DROP FUNCTION IF EXISTS gpUpdate_PriceWithoutPersent (TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_PriceWithoutPersent(
    IN inPersent             TFloat    , -- ����
    IN inOperPrice           TFloat    , -- ����
   OUT outOperPrice          TFloat    , -- ���� �� ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_Income_Price());

     outOperPrice := inOperPrice - (inOperPrice/100*inPersent);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.02.19         *
*/

-- ����
-- 