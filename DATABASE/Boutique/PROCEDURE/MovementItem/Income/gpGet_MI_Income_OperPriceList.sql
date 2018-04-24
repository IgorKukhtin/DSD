-- Function: gpGet_MI_Income_OperPriceList()

DROP FUNCTION IF EXISTS gpGet_MI_Income_OperPriceList (TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Income_OperPriceList (Integer, TVarChar, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Income_OperPriceList(
    IN inMovementId        Integer  , --
    IN inGoodsName         TVarChar  , --
    IN inOperPrice         TFloat   , --
    IN inCountForPrice     TFloat   , --
 INOUT ioOperPriceList     TFloat   , -- 
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbIncomeKoeff TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpGetUserBySession (inSession);

     inOperPrice := (SELECT MAX (tmp.OperPrice)
                     FROM (
                           SELECT inOperPrice AS OperPrice
                          UNION ALL
                           SELECT COALESCE (MIFloat_OperPrice.ValueData, 0) AS OperPrice
                           FROM MovementItem
                                INNER JOIN Object AS Object_Goods ON Object_Goods.ValueData = TRIM (inGoodsName) 
                                                                 AND Object_Goods.DescId    = zc_Object_Goods()
                                LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                            ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                           AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice()
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE
                           ) AS tmp
                    );
     
     -- ���������� "����������� ��� �������" ��� ������ ���������
     vbIncomeKoeff := (SELECT COALESCE (ObjectFloat_IncomeKoeff.ValueData, 0)  AS IncomeKoeff
                       FROM MovementLinkObject AS MLO_CurrencyDocument
                            LEFT JOIN ObjectFloat AS ObjectFloat_IncomeKoeff 
                                                  ON ObjectFloat_IncomeKoeff.ObjectId = MLO_CurrencyDocument.ObjectId
                                                 AND ObjectFloat_IncomeKoeff.DescId = zc_ObjectFloat_Currency_IncomeKoeff()
                       WHERE MLO_CurrencyDocument.MovementId = inMovementId
                         AND MLO_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
                       );


     -- ���������� ��� ������ � �� +/-50 ������, �.�. ��������� ����� ��� 50 ��� �����
     ioOperPriceList:= (CAST ( (inOperPrice * vbIncomeKoeff / inCountForPrice) / 50 AS NUMERIC (16,0)) * 50) :: TFloat;
                
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 24.04.18         *
 24.03.18         *
 06.06.17         *
*/

-- ����
-- SELECT * FROM gpGet_MI_Income_OperPriceList (inMovementId := 248647 , inGoodsName := '961 * �5 *  *' ,inOperPrice:= 156, inCountForPrice:= 1, ioOperPriceList:= 256, inSession:= zfCalc_UserAdmin());
