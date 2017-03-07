-- Function: gpSelectMobile_Object_GoodsListSale (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_GoodsListSale (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_GoodsListSale (
    IN inSyncDateIn TDateTime, -- ����/����� ��������� ������������� - ����� "�������" ����������� �������� ���������� - ���������� �����������, ����, �����, �����, ������� � �.�
    IN inSession    TVarChar   -- ������ ������������
)
RETURNS TABLE (Id            Integer
             , GoodsId       Integer  -- �����
             , GoodsKindId   Integer  -- ��� ������
             , PartnerId     Integer  -- ����������
             , AmountCalc    TFloat   -- ��������������� ��������, ����� ������������ ��� ������� �� ���������  ���������� "���������������� ������", ����������� � ������� �� = ���������� ������� ���� �� �� + ���������� �� �� - �������� � ��, ������ ��� ��� �� "������������" ������
             , isErased      Boolean  -- ��������� �� �������
             , isSync        Boolean  -- ���������������� (��/���)
              )
AS 
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
   DECLARE vbUnitId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      SELECT PersonalId, UnitId INTO vbPersonalId, vbUnitId FROM gpGetMobile_Object_Const (inSession);

      -- ���������
      IF vbPersonalId IS NOT NULL
      THEN
           CREATE TEMP TABLE tmpGoodsListSale ON COMMIT DROP
           AS (SELECT Object_GoodsListSale.Id AS GoodsListSaleId
               FROM Object AS Object_GoodsListSale
                    JOIN ObjectLink AS ObjectLink_GoodsListSale_Partner
                                    ON ObjectLink_GoodsListSale_Partner.ObjectId = Object_GoodsListSale.Id
                                   AND ObjectLink_GoodsListSale_Partner.DescId = zc_ObjectLink_GoodsListSale_Partner()
                                   AND ObjectLink_GoodsListSale_Partner.ChildObjectId IS NOT NULL
                    JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                    ON ObjectLink_Partner_PersonalTrade.ObjectId = ObjectLink_GoodsListSale_Partner.ChildObjectId
                                   AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                   AND ObjectLink_Partner_PersonalTrade.ChildObjectId = vbPersonalId
               WHERE Object_GoodsListSale.DescId = zc_Object_GoodsListSale()
              );

           IF inSyncDateIn > zc_DateStart()
           THEN
                RETURN QUERY
                  WITH tmpProtocol AS (SELECT ObjectProtocol.ObjectId AS GoodsListSaleId, MAX(ObjectProtocol.OperDate) AS MaxOperDate
                                       FROM ObjectProtocol
                                            JOIN Object AS Object_GoodsListSale
                                                        ON Object_GoodsListSale.Id = ObjectProtocol.ObjectId
                                                       AND Object_GoodsListSale.DescId = zc_Object_GoodsListSale() 
                                       WHERE ObjectProtocol.OperDate > inSyncDateIn
                                       GROUP BY ObjectProtocol.ObjectId
                                      )
                  SELECT Object_GoodsListSale.Id
                       , COALESCE (ObjectLink_GoodsListSale_Goods.ChildObjectId, 0)     AS GoodsId
                       , COALESCE (ObjectLink_GoodsListSale_GoodsKind.ChildObjectId, 0) AS GoodsKindId 
                       , COALESCE (ObjectLink_GoodsListSale_Partner.ChildObjectId, 0)   AS PartnerId
                       , CAST(0.0 AS TFloat)                                            AS AmountCalc
                       , Object_GoodsListSale.isErased
                       , EXISTS(SELECT 1 FROM tmpGoodsListSale WHERE tmpGoodsListSale.GoodsListSaleId = Object_GoodsListSale.Id) AS isSync
                  FROM Object AS Object_GoodsListSale
                       JOIN tmpProtocol ON tmpProtocol.GoodsListSaleId = Object_GoodsListSale.Id
                       LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Goods
                                            ON ObjectLink_GoodsListSale_Goods.ObjectId = Object_GoodsListSale.Id
                                           AND ObjectLink_GoodsListSale_Goods.DescId = zc_ObjectLink_GoodsListSale_Goods()
                       LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_GoodsKind
                                            ON ObjectLink_GoodsListSale_GoodsKind.ObjectId = Object_GoodsListSale.Id
                                           AND ObjectLink_GoodsListSale_GoodsKind.DescId = zc_ObjectLink_GoodsListSale_GoodsKind()
                       LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Partner
                                            ON ObjectLink_GoodsListSale_Partner.ObjectId = Object_GoodsListSale.Id
                                           AND ObjectLink_GoodsListSale_Partner.DescId = zc_ObjectLink_GoodsListSale_Partner()
                  WHERE Object_GoodsListSale.DescId = zc_Object_GoodsListSale();
           ELSE
                RETURN QUERY
                  SELECT Object_GoodsListSale.Id
                       , COALESCE (ObjectLink_GoodsListSale_Goods.ChildObjectId, 0)     AS GoodsId
                       , COALESCE (ObjectLink_GoodsListSale_GoodsKind.ChildObjectId, 0) AS GoodsKindId 
                       , COALESCE (ObjectLink_GoodsListSale_Partner.ChildObjectId, 0)   AS PartnerId
                       , CAST(0.0 AS TFloat)                                            AS AmountCalc
                       , Object_GoodsListSale.isErased
                       , CAST(true AS Boolean) AS isSync
                  FROM Object AS Object_GoodsListSale
                       JOIN tmpGoodsListSale ON tmpGoodsListSale.GoodsListSaleId = Object_GoodsListSale.Id
                       LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Goods
                                            ON ObjectLink_GoodsListSale_Goods.ObjectId = Object_GoodsListSale.Id
                                           AND ObjectLink_GoodsListSale_Goods.DescId = zc_ObjectLink_GoodsListSale_Goods()
                       LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_GoodsKind
                                            ON ObjectLink_GoodsListSale_GoodsKind.ObjectId = Object_GoodsListSale.Id
                                           AND ObjectLink_GoodsListSale_GoodsKind.DescId = zc_ObjectLink_GoodsListSale_GoodsKind()
                       LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Partner
                                            ON ObjectLink_GoodsListSale_Partner.ObjectId = Object_GoodsListSale.Id
                                           AND ObjectLink_GoodsListSale_Partner.DescId = zc_ObjectLink_GoodsListSale_Partner()
                  WHERE Object_GoodsListSale.DescId = zc_Object_GoodsListSale();
           END IF;
      END IF;

END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 04.03.17                                                         *
*/

-- ����
-- SELECT * FROM gpSelectMobile_Object_GoodsListSale(inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())
