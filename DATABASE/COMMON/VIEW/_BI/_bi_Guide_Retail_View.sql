-- View: _bi_Guide_Retail_View

 DROP VIEW IF EXISTS _bi_Guide_Retail_View;

-- ���������� �������� ����
CREATE OR REPLACE VIEW _bi_Guide_Retail_View
AS
       SELECT
             Object_Retail.Id         AS Id
           , Object_Retail.ObjectCode AS Code
           , Object_Retail.ValueData  AS Name
             -- ������� "������ ��/���"
           , Object_Retail.isErased   AS isErased

           --���� �� ���� ������
           , COALESCE (ObjectBoolean_OperDateOrder.ValueData, CAST (FALSE AS Boolean)) AS OperDateOrder
           --�������� ����������� �����
           , COALESCE (ObjectBoolean_isOrderMin.ValueData, FALSE::Boolean)             AS isOrderMin
           --�������� ������ ��� ���
           , COALESCE (ObjectBoolean_isWMS.ValueData, FALSE) :: Boolean                AS isWMS
           --���-�� ������ ��� ���������� ����
           , ObjectFloat_RoundWeight.ValueData ::TFloat AS RoundWeight
           --��� GLN - ����������
           , GLNCode.ValueData                   AS GLNCode
           --��� GLN - ���������
           , GLNCodeCorporate.ValueData          AS GLNCodeCorporate
           --���� ��� �����. ����������
           , ObjectString_OKPO.ValueData         AS OKPO
           --�������������� ������� �������
           , Object_GoodsProperty.Id             AS GoodsPropertyId
           , Object_GoodsProperty.ValueData      AS GoodsPropertyName
           --��������� (������������� ������������� �������������� ������)
           , Object_PersonalMarketing.Id         AS PersonalMarketingId
           , Object_PersonalMarketing.ValueData  AS PersonalMarketingName
           --��������� (������������� ������������� ������������� ������)
           , Object_PersonalTrade.Id             AS PersonalTradeId
           , Object_PersonalTrade.ValueData      AS PersonalTradeName
           --��������� �����������
           , Object_ClientKind.Id                AS ClientKindId
           , Object_ClientKind.ValueData         AS ClientKindName
           --��������� ��� ����
           , Object_StickerHeader.Id             AS StickerHeaderId
           , Object_StickerHeader.ValueData      AS StickerHeaderName

       FROM Object AS Object_Retail
            --��� GLN - ����������
            LEFT JOIN ObjectString AS GLNCode
                                   ON GLNCode.ObjectId = Object_Retail.Id
                                  AND GLNCode.DescId = zc_ObjectString_Retail_GLNCode()
            --��� GLN - ���������
            LEFT JOIN ObjectString AS GLNCodeCorporate
                                   ON GLNCodeCorporate.ObjectId = Object_Retail.Id
                                  AND GLNCodeCorporate.DescId = zc_ObjectString_Retail_GLNCodeCorporate()
            --���� ��� �����. ����������
            LEFT JOIN ObjectString AS ObjectString_OKPO
                                   ON ObjectString_OKPO.ObjectId = Object_Retail.Id
                                  AND ObjectString_OKPO.DescId = zc_ObjectString_Retail_OKPO()
            --���� �� ���� ������
            LEFT JOIN ObjectBoolean AS ObjectBoolean_OperDateOrder
                                    ON ObjectBoolean_OperDateOrder.ObjectId = Object_Retail.Id
                                   AND ObjectBoolean_OperDateOrder.DescId = zc_ObjectBoolean_Retail_OperDateOrder()
            --�������� ����������� �����
            LEFT JOIN ObjectBoolean AS ObjectBoolean_isOrderMin
                                    ON ObjectBoolean_isOrderMin.ObjectId = Object_Retail.Id
                                   AND ObjectBoolean_isOrderMin.DescId = zc_ObjectBoolean_Retail_isOrderMin()
            --�������� ������ ��� ���
            LEFT JOIN ObjectBoolean AS ObjectBoolean_isWMS
                                    ON ObjectBoolean_isWMS.ObjectId = Object_Retail.Id
                                   AND ObjectBoolean_isWMS.DescId = zc_ObjectBoolean_Retail_isWMS()
            --���-�� ������ ��� ���������� ����
            LEFT JOIN ObjectFloat AS ObjectFloat_RoundWeight
                                  ON ObjectFloat_RoundWeight.ObjectId = Object_Retail.Id
                                 AND ObjectFloat_RoundWeight.DescId = zc_ObjectFloat_Retail_RoundWeight()
            --�������������� ������� �������
            LEFT JOIN ObjectLink AS ObjectLink_Retail_GoodsProperty
                                 ON ObjectLink_Retail_GoodsProperty.ObjectId = Object_Retail.Id
                                AND ObjectLink_Retail_GoodsProperty.DescId = zc_ObjectLink_Retail_GoodsProperty()
            LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = ObjectLink_Retail_GoodsProperty.ChildObjectId
            --��������� (������������� ������������� �������������� ������)
            LEFT JOIN ObjectLink AS ObjectLink_Retail_PersonalMarketing
                                 ON ObjectLink_Retail_PersonalMarketing.ObjectId = Object_Retail.Id
                                AND ObjectLink_Retail_PersonalMarketing.DescId = zc_ObjectLink_Retail_PersonalMarketing()
            LEFT JOIN Object AS Object_PersonalMarketing ON Object_PersonalMarketing.Id = ObjectLink_Retail_PersonalMarketing.ChildObjectId
            --��������� (������������� ������������� ������������� ������)
            LEFT JOIN ObjectLink AS ObjectLink_Retail_PersonalTrade
                                 ON ObjectLink_Retail_PersonalTrade.ObjectId = Object_Retail.Id
                                AND ObjectLink_Retail_PersonalTrade.DescId = zc_ObjectLink_Retail_PersonalTrade()
            LEFT JOIN Object AS Object_PersonalTrade ON Object_PersonalTrade.Id = ObjectLink_Retail_PersonalTrade.ChildObjectId
            --��������� �����������
            LEFT JOIN ObjectLink AS ObjectLink_Retail_ClientKind
                                 ON ObjectLink_Retail_ClientKind.ObjectId = Object_Retail.Id
                                AND ObjectLink_Retail_ClientKind.DescId = zc_ObjectLink_Retail_ClientKind()
            LEFT JOIN Object AS Object_ClientKind ON Object_ClientKind.Id = ObjectLink_Retail_ClientKind.ChildObjectId  
            --��������� ��� ����
            LEFT JOIN ObjectLink AS ObjectLink_Retail_StickerHeader
                                 ON ObjectLink_Retail_StickerHeader.ObjectId = Object_Retail.Id
                                AND ObjectLink_Retail_StickerHeader.DescId = zc_ObjectLink_Retail_StickerHeader()
            LEFT JOIN Object AS Object_StickerHeader ON Object_StickerHeader.Id = ObjectLink_Retail_StickerHeader.ChildObjectId

       WHERE Object_Retail.DescId = zc_Object_Retail()
      ;

ALTER TABLE _bi_Guide_Retail_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.05.25         *
 09.05.25                                        *
*/

-- ����
-- SELECT * FROM _bi_Guide_Retail_View
