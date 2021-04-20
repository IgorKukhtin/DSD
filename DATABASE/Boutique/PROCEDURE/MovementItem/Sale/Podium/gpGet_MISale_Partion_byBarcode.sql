-- Function: gpGet_MISale_Partion_byBarCode()

DROP FUNCTION IF EXISTS gpGet_MISale_Partion_byBarCode (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MISale_Partion_byBarCode(
    IN inBarCode           TVarChar   , --
    IN inSession           TVarChar     -- ������ ������������
)
RETURNS TABLE (PartionId     Integer
             , GoodsId       Integer
             , GoodsSizeId   Integer
             , OperPriceList TFloat
              )
AS
$BODY$
   DECLARE vbUserId    Integer;

   DECLARE vbPartionId Integer;
   DECLARE vbSybaseId  Integer;
   DECLARE vbGoodsCode Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpGetUserBySession (inSession);
     
     
     -- ���� ������
     IF TRIM (inBarCode) = '' OR CHAR_LENGTH (inBarCode) < 10 THEN

       -- ���������
       RETURN QUERY
         SELECT 0 :: Integer AS PartionId
              , 0 :: Integer AS GoodsId
              , 0 :: Integer AS GoodsSizeId
              , 0 :: TFloat  AS OperPriceList
               ;

       -- !!!�����!!!
       RETURN;
       
     END IF;


     -- ���� ��� ��������
     IF COALESCE (inBarCode, '') <> '' AND CHAR_LENGTH (inBarCode) = 13
     THEN
         -- ����� � ������ ������
         IF SUBSTR (inBarCode, 1, 2) = '29' AND zc_Enum_GlobalConst_isTerry() = FALSE
         THEN
             -- ��������� 10 - ��� ���
             vbGoodsCode:= zfConvert_StringToNumber (SUBSTR (inBarCode, 3, 10)) :: Integer;
             -- ������� �����
             vbPartionId:= (SELECT Object_PartionGoods.MovementItemId
                            FROM Object_PartionGoods
                                 INNER JOIN Object AS Object_Goods
                                                   ON Object_Goods.Id         = Object_PartionGoods.GoodsId
                                                  AND Object_Goods.ObjectCode = vbGoodsCode
                                                  AND vbGoodsCode             > 0
                           );
             -- ���� �� �����
             IF COALESCE (vbPartionId, 0) = 0
             THEN
                 RAISE EXCEPTION '������.����� � ����� = <%> �� ������.', vbGoodsCode;
             END IF;
         
         -- ����� � ������ Sybase - 1
         ELSEIF SUBSTR (inBarCode, 1, 2) = '20'
         THEN
             -- ������ 5 - ��� ���
             vbGoodsCode:= zfConvert_StringToNumber (SUBSTR (inBarCode, 3, 5)) :: Integer;
             -- ������ 5 - ��� Id
             vbSybaseId:= zfConvert_StringToNumber (SUBSTR (inBarCode, 8, 5)) :: Integer;
             
             -- ������� �����
             vbPartionId:= (SELECT Object_PartionGoods.MovementItemId
                            FROM Object_PartionGoods
                                 INNER JOIN Object AS Object_Goods
                                                   ON Object_Goods.Id         = Object_PartionGoods.GoodsId
                                                  AND Object_Goods.ObjectCode = vbGoodsCode
                                                  AND vbGoodsCode             > 0
                            WHERE Object_PartionGoods.SybaseId = vbSybaseId AND vbSybaseId > 0
                           );
             
             -- ���� �� �����
             IF COALESCE (vbPartionId, 0) = 0
             THEN
                 -- ������� ����� �٨
                 vbPartionId:= (SELECT Object_PartionGoods.MovementItemId
                                FROM Object_PartionGoods
                                     INNER JOIN Object AS Object_Goods
                                                       ON Object_Goods.Id         = Object_PartionGoods.GoodsId
                                                      AND Object_Goods.ObjectCode = (vbGoodsCode - 1)
                                                      AND vbGoodsCode             > 0
                                WHERE Object_PartionGoods.SybaseId = (vbSybaseId + 100000) AND vbSybaseId > 0
                               );
             END IF;

             -- ���� �� �����
             IF COALESCE (vbPartionId, 0) = 0
             THEN
                 RAISE EXCEPTION '������.����� � �������-1 = <%> � ��� = <%> �� ������.', vbSybaseId, vbGoodsCode;
             END IF;


         -- ����� � ������ Sybase - 2
         ELSEIF SUBSTR (inBarCode, 1, 2) = '21'
         THEN
             -- ����� ��� Id
             vbSybaseId:= zfConvert_StringToNumber (SUBSTR (inBarCode, 3, 10)) :: Integer;
             
             -- ������� �����
             vbPartionId:= (SELECT Object_PartionGoods.MovementItemId
                            FROM Object_PartionGoods
                            WHERE Object_PartionGoods.SybaseId = vbSybaseId AND vbSybaseId > 0
                           );
             
             -- ���� �� �����
             IF COALESCE (vbPartionId, 0) = 0
             THEN
                 RAISE EXCEPTION '������.����� � �������-2 = <%> �� ������.', vbSybaseId;
             END IF;


         ELSE
             -- ����� ��� Id, ����� zc_BarCodePref_Object
             vbPartionId := zfConvert_StringToNumber (SUBSTR (inBarCode, CHAR_LENGTH (zc_BarCodePref_Object()) + 1, 13 - CHAR_LENGTH (zc_BarCodePref_Object()) - 1)) :: Integer;
             
             -- ��������
             IF NOT EXISTS (SELECT 1 FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = vbPartionId)
             THEN
                 RAISE EXCEPTION '������.����� � ������� <%> �� ������.', vbPartionId;
             END IF;

         END IF;
     ELSE 
         RAISE EXCEPTION '������.������ � ��������� <%>.', inBarCode;
     END IF;
     
     
     -- ���������
     RETURN QUERY
       WITH tmpCurrency AS (SELECT COALESCE (tmp.Amount, 0) AS CurrencyValue_pl, COALESCE (tmp.ParValue, 0) AS ParValue_pl
                            FROM lfSelect_Movement_Currency_byDate (inOperDate      := CURRENT_DATE
                                                                  , inCurrencyFromId:= zc_Currency_Basis()
                                                                    -- !!! �������� - zc_Currency_EUR !!!
                                                                  , inCurrencyToId  := zc_Currency_EUR() -- vbCurrencyId_pl
                                                                   ) AS tmp)
       SELECT Object_PartionGoods.MovementItemId       AS PartionId
            , Object_PartionGoods.GoodsId              AS GoodsId
            , Object_PartionGoods.GoodsSizeId          AS GoodsSizeId
            , CASE WHEN zc_Enum_GlobalConst_isTerry() = TRUE
                        THEN Object_PartionGoods.OperPriceList
                   ELSE zfCalc_SummPriceList (1, zfCalc_CurrencySumm ((SELECT lpGet.ValuePrice FROM lpGet_ObjectHistory_PriceListItem (CURRENT_DATE, 18419, Object_PartionGoods.GoodsId) AS lpGet)
                                                                    , (SELECT lpGet.CurrencyId FROM lpGet_ObjectHistory_PriceListItem (CURRENT_DATE, 18419, Object_PartionGoods.GoodsId) AS lpGet)
                                                                    , zc_Currency_Basis()
                                                                    , tmpCurrency.CurrencyValue_pl
                                                                    , tmpCurrency.ParValue_pl
                                                                     ))
              END :: TFLoat AS OperPriceList
       FROM Object_PartionGoods
            LEFT JOIN tmpCurrency ON 1=1
       WHERE Object_PartionGoods.MovementItemId = vbPartionId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 28.12.17         *
*/

-- ����
-- SELECT tmp.*, Object_Goods.*, Object_GoodsSize.ValueData FROM gpGet_MISale_Partion_byBarCode (inBarCode:= '2900000129894', inSession:= zfCalc_UserAdmin()) AS tmp LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.GoodsId LEFT JOIN Object AS Object_GoodsSize ON Object_GoodsSize.Id = tmp.GoodsSizeId
