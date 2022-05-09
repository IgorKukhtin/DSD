-- Function: gpGet_Partion_byBarcode()

DROP FUNCTION IF EXISTS gpGet_Partion_byBarcode (TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Partion_byBarcode (TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Partion_byBarcode(
    IN inBarCode           TVarChar   , --
    IN inPartNumber        TVarChar   , 
    IN inSession           TVarChar     -- ������ ������������
)
RETURNS TABLE (PartionId     Integer
             , GoodsId       Integer
             , PartNumber    TVarChar
              )
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbGoodsId Integer;

BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpGetUserBySession (inSession);

     -- ���� ������
     IF TRIM (inBarCode) = ''
     THEN
         -- ���������
         RETURN QUERY
           SELECT 0            :: Integer   AS PartionId
                , 0            :: Integer   AS GoodsId
                , inPartNumber :: TVarChar  AS PartNumber
                 ;

     ELSE
        -- ���� ��� ��������
        IF COALESCE (inBarCode, '') <> '' 
        THEN
             -- ��������
             IF 1 < (SELECT COUNT(*)
                     FROM Object
                          INNER JOIN ObjectString AS ObjectString_EAN
                                                  ON ObjectString_EAN.ObjectId  = Object.Id
                                                 AND ObjectString_EAN.DescId    = zc_ObjectString_EAN()
                                                 AND ObjectString_EAN.ValueData = TRIM (inBarCode)
                     WHERE Object.DescId = zc_Object_Goods()
                    )
             THEN
                 RAISE EXCEPTION '������.�����-��� <%> ������ � ������ �������������.%<%>%� <%>'
                               , inBarCode
                               , CHR (13)
                               , lfGet_Object_ValueData ((SELECT MIN (Object.Id)
                                                          FROM Object
                                                               INNER JOIN ObjectString AS ObjectString_EAN
                                                                                       ON ObjectString_EAN.ObjectId  = Object.Id
                                                                                      AND ObjectString_EAN.DescId    = zc_ObjectString_EAN()
                                                                                      AND ObjectString_EAN.ValueData = TRIM (inBarCode)
                                                          WHERE Object.DescId = zc_Object_Goods()))
                               , CHR (13)
                               , lfGet_Object_ValueData ((SELECT MAX (Object.Id)
                                                          FROM Object
                                                               INNER JOIN ObjectString AS ObjectString_EAN
                                                                                       ON ObjectString_EAN.ObjectId  = Object.Id
                                                                                      AND ObjectString_EAN.DescId    = zc_ObjectString_EAN()
                                                                                      AND ObjectString_EAN.ValueData = TRIM (inBarCode)
                                                          WHERE Object.DescId = zc_Object_Goods()))
                                ;
             END IF;
                         
             -- �����
             vbGoodsId:= (SELECT Object.Id
                          FROM Object
                              INNER JOIN ObjectString AS ObjectString_EAN
                                                      ON ObjectString_EAN.ObjectId  = Object.Id
                                                     AND ObjectString_EAN.DescId    = zc_ObjectString_EAN()
                                                     AND ObjectString_EAN.ValueData = TRIM (inBarCode)
                          WHERE Object.DescId = zc_Object_Goods()
                         );
             
             -- ���� �� �����
             IF COALESCE (vbGoodsId, 0) = 0
             THEN
                 RAISE EXCEPTION '������.������� � �����-����� = <%> �� ������.', inBarCode;
             END IF;
   
  
        END IF;
   
        
        -- ���������
        RETURN QUERY
          SELECT 0  :: Integer AS PartionId
               , vbGoodsId     AS GoodsId
               , inPartNumber  AS PartNumber
          ;

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.02.22         *
*/

-- ����
-- SELECT tmp.*, Object_Goods.* FROM gpGet_Partion_byBarcode (inBarCode:= '221000038868', inPartNumber:='', inSession:= zfCalc_UserAdmin()) AS tmp LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.GoodsId 
