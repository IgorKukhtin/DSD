-- Function: gpGet_MI_Income_OperPriceList()

DROP FUNCTION IF EXISTS gpGet_MI_Income_OperPriceList (TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Income_OperPriceList(
    IN inOperPrice         TFloat   , --
    IN inCountForPrice     TFloat   , --
 INOUT ioOperPriceList     TFloat   , -- 
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpGetUserBySession (inSession);

     -- ���������� ��� ������ � �� +/-50 ������, �.�. ��������� ����� ��� 50 ��� �����
     ioOperPriceList:= (CAST ( (inOperPrice * zc_Enum_GlobalConst_IncomeKoeff() / inCountForPrice) / 50 AS NUMERIC (16,0)) * 50) :: TFloat;
                
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 06.06.17         *
*/

-- ����
-- SELECT * FROM gpGet_MI_Income_OperPriceList (inOperPrice:= 156, inCountForPrice:= 1, ioOperPriceList:= 256, inSession:= zfCalc_UserAdmin());
