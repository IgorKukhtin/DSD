DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Income_CreatePretension(TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Income_CreatePretension(
    IN inAmount              TFloat   , -- ��������
    IN inAmountManual        TFloat   , -- ��������
   OUT outAmountDiff         TFloat   , -- ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TFloat AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
     vbUserId := lpGetUserBySession (inSession);

     outAmountDiff := inAmountManual - inAmount;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.   ������ �.�.
 01.12.21                                                                                       *
*/
