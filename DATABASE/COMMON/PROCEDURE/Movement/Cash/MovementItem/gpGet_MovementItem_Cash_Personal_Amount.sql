-- Function: gpGet_MovementItem_Cash_Personal_Amount()

-- DROP FUNCTION IF EXISTS gpGet_MovementItem_Cash_Personal_Amount (Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MovementItem_Cash_Personal_Amount (Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MovementItem_Cash_Personal_Amount (
 INOUT ioId                   Integer   , -- ���� ������� <������� ���������>
 INOUT ioAmount               TFloat    , -- �����
 INOUT ioSummRemains          TFloat    , -- ������� � �������
    IN inSummRemains_diff_F2  TFloat    , -- ������� ����� �� �����
   OUT outSummRemains_diff_F2 TFloat    , -- ������� � ���� ��� ����������
   OUT outIsCalculated        Boolean   , --
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash());

     -- ���������� ����� ��������
     ioAmount:= COALESCE (ioAmount, 0) + COALESCE (ioSummRemains, 0);
     ioSummRemains:= 0;
     outSummRemains_diff_F2:= inSummRemains_diff_F2;

     -- ������
     outIsCalculated:= FALSE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.04.15                                        * all
 16.09.14         *
*/

-- ����
-- SELECT * FROM gpGet_MovementItem_Cash_Personal_Amount (ioId := 11967866, ioAmount:= 8, ioSummRemains:= 450, inSummRemains_diff_F2:= 10, inSession:= '5');
