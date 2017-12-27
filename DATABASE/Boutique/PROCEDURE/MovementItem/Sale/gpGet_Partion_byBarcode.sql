-- Function: gpGet_MI_Sale_Child_Total()

DROP FUNCTION IF EXISTS gpGet_Partion_byBarcode (Integer,Integer,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_Total(
    IN inBarcode           TVarChar   , --
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (AmountRemains TFloat -- �������, ���
             , AmountDiff    TFloat -- �����, ���
              )
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbPartionId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inBarcode, '') <> '' 
     THEN
         vbPartionId := (SELECT zfConvert_StringToNumber (SUBSTR ('2010002606122', 4, 13-4))) :: Integer;
     END IF;
     
     -- ���������
     RETURN QUERY
       SELECT -- �������, ���
              CASE WHEN tmp.AmountDiff > 0 THEN      tmp.AmountDiff ELSE 0 END :: TFloat AS AmountRemains
              -- �����, ���
            , CASE WHEN tmp.AmountDiff < 0 THEN -1 * tmp.AmountDiff ELSE 0 END :: TFloat AS AmountDiff
       FROM tmp;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 22.05.17         *
*/

-- ����
-- SELECT * FROM gpGet_MI_Sale_Child_Total (inId:= 92, inMovementId:= 28, inSession:= zfCalc_UserAdmin());
