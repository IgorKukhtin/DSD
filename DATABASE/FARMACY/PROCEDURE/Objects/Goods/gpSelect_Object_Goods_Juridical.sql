-- Function: gpSelect_Object_Goods()
 
DROP FUNCTION IF EXISTS gpSelect_Object_Goods_Juridical(Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Goods_Juridical(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods_Juridical(
    IN inObjectId    INTEGER , 
    IN inIsErased    Boolean ,
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, CommonCode Integer
             , GoodsMainId Integer, GoodsMainCode Integer, GoodsMainName TVarChar
             , GoodsId Integer, GoodsCodeInt Integer, GoodsCode TVarChar, GoodsName TVarChar
             , CodeUKTZED TVarChar
             , MakerName TVarChar
             , ConditionsKeepId Integer, ConditionsKeepName TVarChar
             , AreaId Integer, AreaName TVarChar
             , MinimumLot TFloat
             , IsUpload Boolean, IsPromo Boolean, isSpecCondition Boolean, isUploadBadm Boolean, isUploadTeva Boolean, isUploadYuriFarm Boolean
             , UpdateName TVarChar
             , UpdateDate TDateTime
             , isErased boolean

) AS
$BODY$
BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());


      RETURN QUERY 
      -- �������� ������ �� ������� ��� ����������
      WITH tmpLoadPriceListItem AS (SELECT DISTINCT 
                                           tt.BarCode
                                         , tt.GoodsName
                                         , tt.ProducerName
                                    FROM (SELECT DISTINCT 
                                                 LoadPriceListItem.BarCode
                                               , LoadPriceListItem.GoodsName
                                               , LoadPriceListItem.ProducerName
                                               , ROW_NUMBER()OVER(PARTITION BY LoadPriceListItem.BarCode ORDER BY ObjectBoolean_BarCode.ValueData ASC, LoadPriceListItem.GoodsName, LoadPriceListItem.ProducerName ASC) as ORD
                                          FROM LoadPriceListItem
                                               INNER JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId
                                                -- ������� ������ �����-����� �� ������ (��������� ��� ��� ����� �� ����� ���������)
                                               LEFT JOIN ObjectBoolean AS ObjectBoolean_BarCode
                                                                       ON ObjectBoolean_BarCode.ObjectId = LoadPriceList.ContractId
                                                                      AND ObjectBoolean_BarCode.DescId = zc_ObjectBoolean_Contract_BarCode()
                                          WHERE LoadPriceListItem.BarCode <> ''
                                            AND inObjectId = zc_Enum_GlobalConst_BarCode()
                                          ) AS tt
                                    WHERE tt.Ord = 1
                                    )
         , tmpObject_LinkGoods_View AS (SELECT 
                                           ObjectLink_LinkGoods_GoodsMain.ObjectId       AS Id
                                                                                        
                                         , ObjectLink_LinkGoods_GoodsMain.ChildObjectId  AS GoodsMainId
                                         , Object_MainGoods.ObjectCode                   AS GoodsMainCode
                                         , Object_MainGoods.ValueData                    AS GoodsMainName

                                         , ObjectLink_LinkGoods_Goods.ChildObjectId      AS GoodsId
                                         , Object_Goods.GoodsCodeInt                     AS GoodsCodeInt
                                         , Object_Goods.GoodsCode                        AS GoodsCode
                                         , Object_Goods.GoodsName                        AS GoodsName
                                         , Object_Goods.MakerName                        AS MakerName

                                         , Object_Goods.ObjectId                         AS ObjectId
                                         , Object_Goods.AreaId                           AS AreaId
                                         , FALSE                                         AS isErased
                                         
                                     FROM ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                          LEFT JOIN Object AS Object_MainGoods ON Object_MainGoods.Id = ObjectLink_LinkGoods_GoodsMain.ChildObjectId
                                 
                                          LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                                          ON ObjectLink_LinkGoods_Goods.ObjectId = ObjectLink_LinkGoods_GoodsMain.ObjectId
                                                         AND ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                                          JOIN Object_Goods_View AS Object_Goods ON Object_Goods.Id = ObjectLink_LinkGoods_Goods.ChildObjectId
                                          
                                     WHERE ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                                       AND Object_Goods.ObjectId  = zc_Enum_GlobalConst_Marion())
                                    
      SELECT 
           ObjectLink_LinkGoods_GoodsMain.ObjectId AS Id
         , COALESCE(Object_LinkGoods_View.GoodsCode, Object_LinkGoods_View.GoodsCodeInt::TVarChar) ::Integer AS CommonCode
         , MainGoods.Id                            AS GoodsMainId
         , MainGoods.ObjectCode                    AS GoodsMainCode
         , MainGoods.ValueData                     AS GoodsMainName
         , Object_Goods.Id                         AS GoodsId 
         , Object_Goods.ObjectCode                 AS GoodsCodeInt
         --, ObjectString.ValueData                  AS GoodsCode
         , CASE WHEN ObjectLink_Goods_Object.ChildObjectId = zc_Enum_GlobalConst_BarCode() THEN Object_Goods.ValueData ELSE ObjectString.ValueData END :: TVarChar AS GoodsCode
         --, Object_Goods.ValueData                  AS GoodsName
         , CASE WHEN ObjectLink_Goods_Object.ChildObjectId = zc_Enum_GlobalConst_BarCode() THEN tmpLPLI.GoodsName ELSE Object_Goods.ValueData END AS GoodsName
         , ObjectString_Goods_UKTZED.ValueData     AS CodeUKTZED
         --, ObjectString_Goods_Maker.ValueData      AS MakerName
         , CASE WHEN ObjectLink_Goods_Object.ChildObjectId = zc_Enum_GlobalConst_BarCode() THEN COALESCE (ObjectString_Goods_Maker.ValueData, tmpLPLI.ProducerName) ELSE ObjectString_Goods_Maker.ValueData END MakerName

         , Object_ConditionsKeep.Id                AS ConditionsKeepId
         , Object_ConditionsKeep.ValueData         AS ConditionsKeepName

         , Object_Area.Id                          AS AreaId
         , Object_Area.ValueData                   AS AreaName

         , ObjectFloat_Goods_MinimumLot.ValueData  AS MinimumLot
         , COALESCE(ObjectBoolean_Goods_IsUpload.ValueData,FALSE)         AS IsUpload
         , COALESCE(ObjectBoolean_Goods_IsPromo.ValueData,FALSE)          AS IsPromo
         , COALESCE(ObjectBoolean_Goods_SpecCondition.ValueData,FALSE)    AS IsSpecCondition
         , COALESCE(ObjectBoolean_Goods_UploadBadm.ValueData,FALSE)       AS IsUploadBadm
         , COALESCE(ObjectBoolean_Goods_UploadTeva.ValueData,FALSE)       AS IsUploadTeva
         , COALESCE(ObjectBoolean_Goods_UploadYuriFarm.ValueData,FALSE  ) AS isUploadYuriFarm

         , COALESCE(Object_Update.ValueData, '')                ::TVarChar  AS UpdateName
         , COALESCE(ObjectDate_Protocol_Update.ValueData, Null) ::TDateTime AS UpdateDate

         , Object_Goods.isErased                   AS isErased 
      FROM ObjectLink AS ObjectLink_Goods_Object

          INNER JOIN Object AS Object_Goods 
                            ON Object_Goods.Id = ObjectLink_Goods_Object.ObjectId 
                           AND (Object_Goods.isErased = inIsErased OR inIsErased = True)

          LEFT JOIN ObjectString ON ObjectString.ObjectId = ObjectLink_Goods_Object.ObjectId
                                AND ObjectString.DescId = zc_ObjectString_Goods_Code()
          LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                                 ON ObjectString_Goods_Maker.ObjectId = ObjectLink_Goods_Object.ObjectId
                                AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker()

          LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED
                                 ON ObjectString_Goods_UKTZED.ObjectId = ObjectLink_Goods_Object.ObjectId
                                AND ObjectString_Goods_UKTZED.DescId = zc_ObjectString_Goods_UKTZED()

          LEFT JOIN ObjectFloat AS ObjectFloat_Goods_MinimumLot
                                ON ObjectFloat_Goods_MinimumLot.ObjectId = ObjectLink_Goods_Object.ObjectId
                               AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()   

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_IsUpload
                                  ON ObjectBoolean_Goods_IsUpload.ObjectId = ObjectLink_Goods_Object.ObjectId
                                 AND ObjectBoolean_Goods_IsUpload.DescId = zc_ObjectBoolean_Goods_IsUpload()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_IsPromo
                                  ON ObjectBoolean_Goods_IsPromo.ObjectId = ObjectLink_Goods_Object.ObjectId
                                 AND ObjectBoolean_Goods_IsPromo.DescId = zc_ObjectBoolean_Goods_Promo()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_SpecCondition
                                  ON ObjectBoolean_Goods_SpecCondition.ObjectId = ObjectLink_Goods_Object.ObjectId
                                 AND ObjectBoolean_Goods_SpecCondition.DescId = zc_ObjectBoolean_Goods_SpecCondition()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_UploadBadm
                                  ON ObjectBoolean_Goods_UploadBadm.ObjectId = ObjectLink_Goods_Object.ObjectId
                                 AND ObjectBoolean_Goods_UploadBadm.DescId = zc_ObjectBoolean_Goods_UploadBadm()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_UploadTeva
                                  ON ObjectBoolean_Goods_UploadTeva.ObjectId = ObjectLink_Goods_Object.ObjectId
                                 AND ObjectBoolean_Goods_UploadTeva.DescId = zc_ObjectBoolean_Goods_UploadTeva()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_UploadYuriFarm
                                  ON ObjectBoolean_Goods_UploadYuriFarm.ObjectId = ObjectLink_Goods_Object.ObjectId
                                 AND ObjectBoolean_Goods_UploadYuriFarm.DescId = zc_ObjectBoolean_Goods_UploadYuriFarm()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                               ON ObjectLink_Goods_ConditionsKeep.ObjectId = ObjectLink_Goods_Object.ObjectId
                              AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
          LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Area 
                               ON ObjectLink_Goods_Area.ObjectId = ObjectLink_Goods_Object.ObjectId
                              AND ObjectLink_Goods_Area.DescId = zc_ObjectLink_Goods_Area()
          LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Goods_Area.ChildObjectId
          
          LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                               ON ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                              AND ObjectLink_LinkGoods_Goods.ChildObjectId = Object_Goods.Id

          LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain 
                               ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId 
                              AND ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
     
          LEFT JOIN Object AS MainGoods ON MainGoods.Id = ObjectLink_LinkGoods_GoodsMain.ChildObjectId

          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                               ON ObjectDate_Protocol_Update.ObjectId = Object_Goods.Id
                              AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()
          LEFT JOIN ObjectLink AS ObjectLink_Update
                             ON ObjectLink_Update.ObjectId = Object_Goods.Id
                            AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
          LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId 
                         
          LEFT JOIN tmpObject_LinkGoods_View AS Object_LinkGoods_View 
                                             ON Object_LinkGoods_View.GoodsmainId = ObjectLink_LinkGoods_Goodsmain.ChildObjectId

          LEFT JOIN tmpLoadPriceListItem AS tmpLPLI ON tmpLPLI.BarCode = Object_Goods.ValueData
                                        AND ObjectLink_Goods_Object.ChildObjectId = zc_Enum_GlobalConst_BarCode()
                                        AND (COALESCE (ObjectString_Goods_Maker.ValueData,'')= '' OR tmpLPLI.ProducerName = ObjectString_Goods_Maker.ValueData)

      WHERE ObjectLink_Goods_Object.ChildObjectId = inObjectId
     AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
     AND (CASE WHEN inObjectId = zc_Enum_GlobalConst_BarCode() THEN ObjectLink_LinkGoods_GoodsMain.ChildObjectId IS NOT NULL ELSE 1=1 END) -- ���� ��� ������ ���� �� ���� ������ � ������� ��� ����� � ��.�������, (������� �� ���� 60 ���.) , ����� ����� �� ����������
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_Goods_Juridical(Integer, TVarChar) OWNER TO postgres;


-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  �������� �.�.   ������ �.�.
 23.10.19                                                                      * isUploadYuriFarm
 11.12.17         * Goods_UKTZED
 21.10.17         * add Area
 30.03.17                                                      * isUploadTeva
 07.01.17         * add ConditionsKeep
 15.09.16         * 
 10.02.16         * ���� �� �����
                    + �����
 11.11.14                         *
 22.10.14                         *
 24.06.14         *
 20.06.13                         *

*/

-- ����
 --select * from gpSelect_Object_Goods_Juridical(inObjectId := 59614 , inIsErased := 'False' ,  inSession := '3');
 
 select * from gpSelect_Object_Goods_Juridical(inObjectId := 183345 , inIsErased := 'False' ,  inSession := '3');