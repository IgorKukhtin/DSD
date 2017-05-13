-- Function: zfSelect_Word_Split

DROP FUNCTION IF EXISTS zfSelect_DiscountSaleKind (TDateTime, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION zfSelect_DiscountSaleKind(
    IN inOperDate           TDateTime , -- ���� ��������
    IN inUnitId             Integer   , -- ������������� 
    IN inGoodsId            Integer   , -- �����
    IN inClientId           Integer   , -- ���� 
    IN inUserId             Integer        -- ������������
)
RETURNS TABLE (ChangePercent Tfloat, DiscountSaleKindId Integer, DiscountSaleKindName TVarChar
              )
AS
$BODY$
BEGIN
   
     -- ���������
     RETURN QUERY
             SELECT tmp1.Tax, tmp1.DiscountSaleKindId, Object.ValueData
      FROM (
            SELECT tmp.Tax, tmp.DiscountSaleKindId
                 , ROW_NUMBER() OVER ( ORDER BY tmp.Tax desc) AS Num
            FROM (
                  SELECT tmp.ValuePrice AS Tax, zc_Enum_DiscountSaleKind_Period() AS DiscountSaleKindId -- ��������
                  FROM gpGet_ObjectHistory_DiscountPeriodItem(inOperDate,inUnitId:= inUnitId, inGoodsId:= inGoodsId, inSession:='2') as tmp
                UNION
                  SELECT ObjectFloat_DiscountTax.ValueData AS Tax, zc_Enum_DiscountSaleKind_Client() AS DiscountSaleKindId -- ������� 
                  FROM ObjectFloat AS ObjectFloat_DiscountTax 
                  WHERE ObjectFloat_DiscountTax.DescId = zc_ObjectFloat_Client_DiscountTax()
                    AND ObjectFloat_DiscountTax.ObjectId =  inClientId --459     -- Object_To.Id ������
                UNION
                  SELECT  ObjectFloat_DiscountTax.ValueData AS Tax, zc_Enum_DiscountSaleKind_Outlet() AS DiscountSaleKindId -- ������� 
                  FROM ObjectFloat AS ObjectFloat_DiscountTax 
                  WHERE ObjectFloat_DiscountTax.DescId = zc_ObjectFloat_Unit_DiscountTax()
                    AND ObjectFloat_DiscountTax.ObjectId =  inUnitId --230     --inUnitId
                 ) AS tmp
            ) AS tmp1
            LEFT JOIN Object ON Object.Id = tmp1.DiscountSaleKindId
            WHERE tmp1.Num = 1 ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.05.17         *
*/

-- ����
-- SELECT * FROM zfSelect_DiscountSaleKind (inOperDate:='03.05.2017' ::TDateTime, inUnitId:= 230,  inGoodsId:=406 , inClientId:=459 ,inUserId:= zfCalc_UserAdmin() :: Integer);