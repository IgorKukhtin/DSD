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
        -- 1.1. ���� ��� �������� - EAN
        IF COALESCE (inBarCode, '') <> ''
        THEN
             -- �������� - 1
             IF 1 < (SELECT COUNT(*)
                     FROM Object
                          INNER JOIN ObjectString AS ObjectString_EAN
                                                  ON ObjectString_EAN.ObjectId  = Object.Id
                                                 AND ObjectString_EAN.DescId    = zc_ObjectString_EAN()
                                                 AND ObjectString_EAN.ValueData ILIKE TRIM (inBarCode)
                     WHERE Object.DescId = zc_Object_Goods()
                    )
             THEN
                 RAISE EXCEPTION '������.�����-��� <%> ������ � ������ �������������.%<%>%� <%>'
                               , inBarCode
                               , CHR (13)
                               , (SELECT CASE WHEN ObjectString_Article.ValueData <> ''
                                              THEN '(' || ObjectString_Article.ValueData || ') '
                                              ELSE '{' || Object.ObjectCode :: TVarChar  || '} '
                                         END || Object.ValueData
                                  FROM Object
                                       INNER JOIN ObjectString AS ObjectString_EAN
                                                               ON ObjectString_EAN.ObjectId  = Object.Id
                                                              AND ObjectString_EAN.DescId    = zc_ObjectString_EAN()
                                                              AND ObjectString_EAN.ValueData ILIKE TRIM (inBarCode)
                                       LEFT JOIN ObjectString AS ObjectString_Article
                                                              ON ObjectString_Article.ObjectId  = Object.Id
                                                             AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                                  WHERE Object.DescId = zc_Object_Goods()
                                  ORDER BY Object.Id ASC LIMIT 1)
                               , CHR (13)
                               , (SELECT CASE WHEN ObjectString_Article.ValueData <> ''
                                              THEN '(' || ObjectString_Article.ValueData || ') '
                                              ELSE '{' || Object.ObjectCode :: TVarChar  || '} '
                                         END || Object.ValueData
                                  FROM Object
                                       INNER JOIN ObjectString AS ObjectString_EAN
                                                               ON ObjectString_EAN.ObjectId  = Object.Id
                                                              AND ObjectString_EAN.DescId    = zc_ObjectString_EAN()
                                                              AND ObjectString_EAN.ValueData ILIKE TRIM (inBarCode)
                                       LEFT JOIN ObjectString AS ObjectString_Article
                                                              ON ObjectString_Article.ObjectId  = Object.Id
                                                             AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                                  WHERE Object.DescId = zc_Object_Goods()
                                  ORDER BY Object.Id DESC LIMIT 1)
                                ;
             END IF;

             -- 1.2. ����� - EAN
             vbGoodsId:= (SELECT Object.Id
                          FROM Object
                              INNER JOIN ObjectString AS ObjectString_EAN
                                                      ON ObjectString_EAN.ObjectId  = Object.Id
                                                     AND ObjectString_EAN.DescId    = zc_ObjectString_EAN()
                                                     AND ObjectString_EAN.ValueData ILIKE TRIM (inBarCode)
                          WHERE Object.DescId = zc_Object_Goods()
                         );


             -- 2.1. ���� ��� Article-1
             IF COALESCE (vbGoodsId, 0) = 0
             THEN
                 -- �������� - 2
                 IF 1 < (SELECT COUNT(*)
                         FROM Object
                              INNER JOIN ObjectString AS ObjectString_Article
                                                      ON ObjectString_Article.ObjectId  = Object.Id
                                                     AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                                                     AND ObjectString_Article.ValueData ILIKE TRIM (inBarCode)
                         WHERE Object.DescId = zc_Object_Goods()
                        )
                 THEN
                     RAISE EXCEPTION '������.Artikel Nr <%> ������ � ������ �������������.%<%>%� <%>'
                                   , inBarCode
                                   , CHR (13)
                                   , (SELECT CASE WHEN ObjectString_Article.ValueData <> ''
                                                  THEN '(' || ObjectString_Article.ValueData || ') '
                                                  ELSE '{' || Object.ObjectCode :: TVarChar  || '} '
                                             END || Object.ValueData
                                      FROM Object
                                           INNER JOIN ObjectString AS ObjectString_Article
                                                                   ON ObjectString_Article.ObjectId  = Object.Id
                                                                  AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                                                                  AND ObjectString_Article.ValueData ILIKE TRIM (inBarCode)
                                      WHERE Object.DescId = zc_Object_Goods()
                                      ORDER BY Object.Id ASC LIMIT 1)
                                   , CHR (13)
                                   , (SELECT CASE WHEN ObjectString_Article.ValueData <> ''
                                                  THEN '(' || ObjectString_Article.ValueData || ') '
                                                  ELSE '{' || Object.ObjectCode :: TVarChar  || '} '
                                             END || Object.ValueData
                                      FROM Object
                                           INNER JOIN ObjectString AS ObjectString_Article
                                                                   ON ObjectString_Article.ObjectId  = Object.Id
                                                                  AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                                                                  AND ObjectString_Article.ValueData ILIKE TRIM (inBarCode)
                                      WHERE Object.DescId = zc_Object_Goods()
                                      ORDER BY Object.Id DESC LIMIT 1)
                                    ;
                 END IF;

                 -- 2.2. ����� - Article-1
                 vbGoodsId:= (SELECT Object.Id
                              FROM Object
                                  INNER JOIN ObjectString AS ObjectString_Article
                                                          ON ObjectString_Article.ObjectId  = Object.Id
                                                         AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                                                         AND ObjectString_Article.ValueData ILIKE TRIM (inBarCode)
                              WHERE Object.DescId = zc_Object_Goods()
                             );
             END IF;

             -- 3.1. ���� ��� Article-2
             IF COALESCE (vbGoodsId, 0) = 0
             THEN
                 -- �������� - 3
                 IF 1 < (SELECT COUNT(*)
                         FROM Object
                              INNER JOIN ObjectString AS ObjectString_Article
                                                      ON ObjectString_Article.ObjectId  = Object.Id
                                                     AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                                                     AND REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (ObjectString_Article.ValueData, '.', ''), '-', ''), ' ', ''), '=', ''), ',', '') ILIKE TRIM (inBarCode)
                         WHERE Object.DescId = zc_Object_Goods()
                        )
                 THEN
                     RAISE EXCEPTION '������.Artikel Nr all <%> ������ � ������ �������������.%<%>%� <%>'
                                   , inBarCode
                                   , CHR (13)
                                   , (SELECT CASE WHEN ObjectString_Article.ValueData <> ''
                                                  THEN '(' || ObjectString_Article.ValueData || ') '
                                                  ELSE '{' || Object.ObjectCode :: TVarChar  || '} '
                                             END || Object.ValueData
                                      FROM Object
                                           INNER JOIN ObjectString AS ObjectString_Article
                                                                   ON ObjectString_Article.ObjectId  = Object.Id
                                                                  AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                                                                  AND REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (ObjectString_Article.ValueData, '.', ''), '-', ''), ' ', ''), '=', ''), ',', '') ILIKE TRIM (inBarCode)
                                      WHERE Object.DescId = zc_Object_Goods()
                                      ORDER BY Object.Id ASC LIMIT 1)
                                   , CHR (13)
                                   , (SELECT CASE WHEN ObjectString_Article.ValueData <> ''
                                                  THEN '(' || ObjectString_Article.ValueData || ') '
                                                  ELSE '{' || Object.ObjectCode :: TVarChar  || '} '
                                             END || Object.ValueData
                                      FROM Object
                                           INNER JOIN ObjectString AS ObjectString_Article
                                                                   ON ObjectString_Article.ObjectId  = Object.Id
                                                                  AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                                                                  AND REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (ObjectString_Article.ValueData, '.', ''), '-', ''), ' ', ''), '=', ''), ',', '') ILIKE TRIM (inBarCode)
                                      WHERE Object.DescId = zc_Object_Goods()
                                      ORDER BY Object.Id DESC LIMIT 1)
                                    ;
                 END IF;

                 -- 3.2. ����� - Article-2
                 vbGoodsId:= (SELECT Object.Id
                              FROM Object
                                  INNER JOIN ObjectString AS ObjectString_Article
                                                          ON ObjectString_Article.ObjectId  = Object.Id
                                                         AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                                                         AND REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (ObjectString_Article.ValueData, '.', ''), '-', ''), ' ', ''), '=', ''), ',', '') ILIKE TRIM (inBarCode)
                              WHERE Object.DescId = zc_Object_Goods()
                             );
             END IF;


             -- 4.1. ���� ��� ObjectCode
             IF COALESCE (vbGoodsId, 0) = 0 AND zfConvert_StringToNumber (inBarCode) > 0 AND STRPOS (inBarCode, '00000') = 1
             THEN
                 -- �������� - 4
                 IF 1 < (SELECT COUNT(*)
                         FROM Object
                         WHERE Object.DescId     = zc_Object_Goods()
                           AND Object.ObjectCode = CASE WHEN LENGTH (inBarCode) = 13 THEN zfConvert_StringToNumber (SUBSTRING (inBarCode FROM 1 FOR 12)) ELSE zfConvert_StringToNumber (inBarCode) END :: Integer
                        )
                 THEN
                     RAISE EXCEPTION '������.Interne Nr <%> ������ � ������ �������������.%<%>%� <%>'
                                   , inBarCode
                                   , CHR (13)
                                   , (SELECT CASE WHEN ObjectString_Article.ValueData <> ''
                                                  THEN '(' || ObjectString_Article.ValueData || ') '
                                                  ELSE '{' || Object.ObjectCode :: TVarChar  || '} '
                                             END || Object.ValueData
                                      FROM Object
                                           INNER JOIN ObjectString AS ObjectString_Article
                                                                   ON ObjectString_Article.ObjectId  = Object.Id
                                                                  AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                                      WHERE Object.DescId     = zc_Object_Goods()
                                        AND Object.ObjectCode = CASE WHEN LENGTH (inBarCode) = 13 THEN zfConvert_StringToNumber (SUBSTRING (inBarCode FROM 1 FOR 12)) ELSE zfConvert_StringToNumber (inBarCode) END :: Integer
                                      ORDER BY Object.Id ASC LIMIT 1)
                                   , CHR (13)
                                   , (SELECT CASE WHEN ObjectString_Article.ValueData <> ''
                                                  THEN '(' || ObjectString_Article.ValueData || ') '
                                                  ELSE '{' || Object.ObjectCode :: TVarChar  || '} '
                                             END || Object.ValueData
                                      FROM Object
                                           INNER JOIN ObjectString AS ObjectString_Article
                                                                   ON ObjectString_Article.ObjectId  = Object.Id
                                                                  AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                                      WHERE Object.DescId     = zc_Object_Goods()
                                        AND Object.ObjectCode = CASE WHEN LENGTH (inBarCode) = 13 THEN zfConvert_StringToNumber (SUBSTRING (inBarCode FROM 1 FOR 12)) ELSE zfConvert_StringToNumber (inBarCode) END :: Integer
                                      ORDER BY Object.Id DESC LIMIT 1)
                                    ;
                 END IF;

                 -- 4.2. ����� - ObjectCode
                 vbGoodsId:= (SELECT Object.Id
                              FROM Object
                              WHERE Object.DescId     = zc_Object_Goods()
                                AND Object.ObjectCode = CASE WHEN LENGTH (inBarCode) = 13 THEN zfConvert_StringToNumber (SUBSTRING (inBarCode FROM 1 FOR 12)) ELSE zfConvert_StringToNumber (inBarCode) END :: Integer
                             );
             END IF;


             -- ���� �� �����
             IF COALESCE (vbGoodsId, 0) = 0 AND zfConvert_StringToNumber (inBarCode) > 0 AND STRPOS (inBarCode, '00000') = 1
             THEN
                 RAISE EXCEPTION '������.Interne Nr = <%> �� ������.', zfConvert_StringToNumber (inBarCode) :: Integer;

             ELSEIF COALESCE (vbGoodsId, 0) = 0 AND LENGTH (inBarCode) = 13
             THEN
                 RAISE EXCEPTION '������.������� � �����-����� = <%> �� ������.', inBarCode;

             ELSEIF COALESCE (vbGoodsId, 0) = 0
             THEN
                 RAISE EXCEPTION '������.Artikel Nr = <%> �� ������.', inBarCode;
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
