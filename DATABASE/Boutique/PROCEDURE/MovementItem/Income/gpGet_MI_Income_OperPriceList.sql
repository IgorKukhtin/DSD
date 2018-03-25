-- Function: gpGet_MI_Income_OperPriceList()

DROP FUNCTION IF EXISTS gpGet_MI_Income_OperPriceList (TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Income_OperPriceList (Integer, Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Income_OperPriceList(
    IN inMovementId        Integer  , --
    IN inGoodsId           Integer  , --
    IN inOperPrice         TFloat   , --
    IN inCountForPrice     TFloat   , --
 INOUT ioOperPriceList     TFloat   , -- 
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperPrice TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpGetUserBySession (inSession);

     inOperPrice := (SELECT MAX(tmp.OperPrice)
                     FROM (
                           SELECT inOperPrice AS OperPrice
                          UNION ALL
                           SELECT COALESCE (MIFloat_OperPrice.ValueData, 0) AS OperPrice
                           FROM MovementItem 
                                LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                            ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                           AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice()
                           WHERE MovementItem.MovementId = inMovementId AND MovementItem.ObjectId = inGoodsId
                           ) AS tmp
                    );
     
     -- ���������� ��� ������ � �� +/-50 ������, �.�. ��������� ����� ��� 50 ��� �����
     ioOperPriceList:= (CAST ( (inOperPrice * zc_Enum_GlobalConst_IncomeKoeff() / inCountForPrice) / 50 AS NUMERIC (16,0)) * 50) :: TFloat;
                
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 24.03.18         *
 06.06.17         *
*/

-- ����
-- SELECT * FROM gpGet_MI_Income_OperPriceList (inOperPrice:= 156, inCountForPrice:= 1, ioOperPriceList:= 256, inSession:= zfCalc_UserAdmin());
