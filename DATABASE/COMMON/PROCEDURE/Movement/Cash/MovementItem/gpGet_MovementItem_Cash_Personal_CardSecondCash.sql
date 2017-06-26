-- Function: gpGet_MovementItem_Cash_Personal_CardSecondCash()

DROP FUNCTION IF EXISTS gpGet_MovementItem_Cash_Personal_CardSecondCash (Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MovementItem_Cash_Personal_CardSecondCash (
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
 INOUT ioAmount              TFloat    , -- � ������� 
 INOUT ioSummCardSecondCash  TFloat    , -- ����� �� (�����) 2�
   OUT outIsCalculated       Boolean   , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash());

     -- ���������� ����� ��������
     ioAmount:= COALESCE (ioAmount, 0) + COALESCE (ioSummCardSecondCash, 0);
     ioSummCardSecondCash:= 0;
     
     -- ������
     outIsCalculated:= CASE WHEN ioAmount > 0 THEN TRUE ELSE FALSE END;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.06.17         *
*/

-- ����
-- SELECT * FROM gpGet_MovementItem_Cash_Personal_CardSecondCash (ioId:= 0, ioAmount:= 0, ioCardSecondCash:= 0, inSession:= '2')
