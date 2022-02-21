-- Function: gpGet_Partion_byBarcode()

DROP FUNCTION IF EXISTS gpGet_Partion_byBarcode (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Partion_byBarcode(
    IN inBarCode           TVarChar   , --
    IN inSession           TVarChar     -- ������ ������������
)
RETURNS TABLE (PartionId     Integer
             , GoodsId       Integer
             , OperPriceList TFloat
              )
AS
$BODY$
   DECLARE vbUserId    Integer;

   DECLARE vbPartionId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbOperPriceList TFLoat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpGetUserBySession (inSession);
     
     -- ���� ������
     IF TRIM (inBarCode) = '' THEN

       -- ���������
       RETURN QUERY
         SELECT 0 :: Integer AS PartionId
              , 0 :: Integer AS GoodsId
              , 0 :: TFloat  AS OperPriceList
               ;

       -- !!!�����!!!
       RETURN;
       
     END IF;


    --RAISE EXCEPTION '������.������ � ��������� <%>.', inBarCode;
     
     -- ���� ��� ��������
     IF COALESCE (inBarCode, '') <> '' --AND CHAR_LENGTH (inBarCode) >= 12
     THEN
          -- ��������� 10 - ��� ��
          vbGoodsId:= (SELECT Object.Id
                       FROM Object
                           INNER JOIN ObjectString AS ObjectString_EAN
                                                   ON ObjectString_EAN.ObjectId = Object.Id
                                                  AND ObjectString_EAN.DescId = zc_ObjectString_EAN()
                                                  AND ObjectString_EAN.ValueData = TRIM (inBarCode)
                       WHERE Object.DescId = zc_Object_Goods()
                        -- AND Object.Id = zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) :: Integer
                       );
          
          -- ������� �����
          SELECT Object_PartionGoods.MovementItemId
               , Object_PartionGoods.OperPriceList
         INTO vbPartionId, vbOperPriceList
          FROM Object_PartionGoods
          WHERE Object_PartionGoods.ObjectId = vbGoodsId
            AND vbGoodsId > 0;

          -- ���� �� �����
          IF COALESCE (vbGoodsId, 0) = 0
          THEN
              RAISE EXCEPTION '������.����� �� ���������� = <%> �� ������.', inBarCode;
          END IF;
     END IF;

/*
     --�� ������, ����� ����� �� �����������
     IF COALESCE (inBarCode, '') <> '' AND CHAR_LENGTH (inBarCode) < 12
     THEN
          -- ��������� 10 - ��� ���
          vbGoodsId:= (SELECT Object.Id
                       FROM Object
                       WHERE Object.DescId = zc_Object_Goods()
                         AND Object.ObjectCode = zfConvert_StringToNumber (inBarCode) :: Integer
                       );
          -- ������� �����
          SELECT Object_PartionGoods.MovementItemId
               , Object_PartionGoods.OperPriceList
         INTO vbPartionId, vbOperPriceList
          FROM Object_PartionGoods
          WHERE Object_PartionGoods.ObjectId = vbGoodsId
            AND vbGoodsId > 0;

          -- ���� �� �����
          IF COALESCE (vbGoodsId, 0) = 0
          THEN
              RAISE EXCEPTION '������.����� � ��������������� = <%> �� ������.', inBarCode;
          END IF;

     END IF;
     */
     
     -- ���������
     RETURN QUERY
       SELECT vbPartionId
            , vbGoodsId
            , vbOperPriceList ::TFLoat
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.02.22         *
*/

-- ����
-- SELECT tmp.*, Object_Goods.* FROM gpGet_Partion_byBarcode (inBarCode:= '221000038868', inSession:= zfCalc_UserAdmin()) AS tmp LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.GoodsId 
