-- Function: gpUpdatePartnerGoods()

DROP FUNCTION IF EXISTS gpUpdatePartnerGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdatePartnerGoods(
    IN inId                  Integer   , -- �����-����
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPriceListId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbOperDate TDateTime;

   DECLARE vbAreaId_find Integer;
   DECLARE vbisMorionCode Boolean;
   DECLARE vbisBarCode Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_LoadSaleFrom1C());
     vbUserId := lpGetUserBySession (inSession);

     -- �������� ��������� ����������
     WITH tmpArea AS
             (SELECT ObjectLink_JuridicalArea_Juridical.ChildObjectId AS JuridicalId
                   , ObjectLink_JuridicalArea_Area.ChildObjectId      AS AreaId
              FROM ObjectLink AS ObjectLink_JuridicalArea_Juridical
                   INNER JOIN Object AS Object_JuridicalArea ON Object_JuridicalArea.Id       = ObjectLink_JuridicalArea_Juridical.ObjectId
                                                            AND Object_JuridicalArea.isErased = FALSE
                   INNER JOIN ObjectLink AS ObjectLink_JuridicalArea_Area
                                         ON ObjectLink_JuridicalArea_Area.ObjectId      = Object_JuridicalArea.Id
                                        AND ObjectLink_JuridicalArea_Area.DescId        = zc_ObjectLink_JuridicalArea_Area()
                   -- ���������� ��� ���������� ������ ��� �������
                   INNER JOIN ObjectBoolean AS ObjectBoolean_JuridicalArea_GoodsCode
                                            ON ObjectBoolean_JuridicalArea_GoodsCode.ObjectId  = Object_JuridicalArea.Id
                                           AND ObjectBoolean_JuridicalArea_GoodsCode.DescId    = zc_ObjectBoolean_JuridicalArea_GoodsCode()
                                           AND ObjectBoolean_JuridicalArea_GoodsCode.ValueData = TRUE
              WHERE ObjectLink_JuridicalArea_Juridical.DescId        = zc_ObjectLink_JuridicalArea_Juridical()
             )
      SELECT LoadPriceList.OperDate	 
           , LoadPriceList.JuridicalId
           , COALESCE (tmpArea.AreaId, 0)
           , COALESCE (ObjectBoolean_MorionCode.ValueData, FALSE)  :: Boolean   AS isMorionCode
           , COALESCE (ObjectBoolean_BarCode.ValueData, FALSE)     :: Boolean   AS isBarCode
             INTO vbOperDate, vbJuridicalId, vbAreaId_find, vbisMorionCode, vbisBarCode
      FROM LoadPriceList
           LEFT JOIN tmpArea ON tmpArea.JuridicalId = LoadPriceList.JuridicalId
                            AND tmpArea.AreaId      = LoadPriceList.AreaId
           -- ������� ������ ����� ������� �� ������ (��������� ��� ��� ����� � ��.�������)
           LEFT JOIN ObjectBoolean AS ObjectBoolean_MorionCode
                                   ON ObjectBoolean_MorionCode.ObjectId = LoadPriceList.ContractId
                                  AND ObjectBoolean_MorionCode.DescId = zc_ObjectBoolean_Contract_MorionCode()
           -- ������� ������ �����-����� �� ������ (��������� ��� ��� ����� � ��.�������)
           LEFT JOIN ObjectBoolean AS ObjectBoolean_BarCode
                                   ON ObjectBoolean_BarCode.ObjectId = LoadPriceList.ContractId
                                  AND ObjectBoolean_BarCode.DescId = zc_ObjectBoolean_Contract_BarCode()
      WHERE LoadPriceList.Id = inId;
            
     -- ������� ����� ����, ������� ��� ���
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Object(), lpInsertUpdate_Object(0, zc_Object_Goods(), CommonCode, LoadPriceListItem.GoodsName), zc_Enum_GlobalConst_Marion())
            FROM LoadPriceListItem 
            WHERE LoadPriceListItem.LoadPriceListId = inId
              AND CommonCode NOT IN (SELECT GoodsCodeInt FROM Object_Goods_View WHERE ObjectId = zc_Enum_GlobalConst_Marion())
              AND CommonCode > 0;

     -- ������� ����� ����, ������� ��� ���
     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Object(), lpInsertUpdate_Object(0, zc_Object_Goods(), 0, TRIM (BarCode)), zc_Enum_GlobalConst_BarCode())
            FROM LoadPriceListItem WHERE LoadPriceListItem.LoadPriceListId = inId
             AND TRIM (BarCode) NOT IN (SELECT TRIM (GoodsName) FROM Object_Goods_View WHERE ObjectId = zc_Enum_GlobalConst_BarCode())
             AND TRIM  (COALESCE (BarCode,'')) <> '';

     -- ��� �� ������ ��� ��������� ������ � ���������� ������� �����-�����
     PERFORM lpInsertUpdate_Object_Goods_andArea(
                     Object_Goods.Id  ,    -- ���� ������� <�����>
         LoadPriceListItem.GoodsCode  ,    -- ��� ������� <�����>
         LoadPriceListItem.GoodsName  ,    -- �������� ������� <�����>
                                   0  ,    -- ������ �������
                                   0  ,    -- ������ �� ������� ���������
                                   0  ,    -- ���
                        vbJuridicalId ,    -- �� ���� ��� �������� ����
                             vbUserId , 
                                   0  ,
                       vbAreaId_find  ,
       LoadPriceListItem.ProducerName , 
         LoadPriceListItem.CodeUKTZED ,
                                FALSE )
        FROM LoadPriceListItem
                LEFT JOIN (SELECT Object_Goods_View.Id, Object_Goods_View.GoodsCode, Object_Goods_View.GoodsName, MakerName 
                           FROM Object_Goods_View
                           WHERE Object_Goods_View.ObjectId = vbJuridicalId
                             AND (-- ���� ������ ������������
                                  COALESCE (Object_Goods_View.AreaId, 0) = vbAreaId_find
                                  -- ��� ��� ������ zc_Area_Basis - ����� ���� � ������� "�����"
                               OR (vbAreaId_find = zc_Area_Basis() AND Object_Goods_View.AreaId IS NULL)
                                  -- ��� ��� ������ "�����" - ����� ���� � ������� zc_Area_Basis
                               OR (vbAreaId_find = 0 AND Object_Goods_View.AreaId = zc_Area_Basis())
                                 )
                        ) AS Object_Goods ON Object_Goods.goodscode = LoadPriceListItem.GoodsCode
        WHERE LoadPriceListItem.GoodsId <> 0 
          AND LoadPriceListItem.LoadPriceListId  = inId 
          AND ((COALESCE(Object_Goods.GoodsName, '') <> LoadPriceListItem.GoodsName)
            OR (COALESCE(Object_Goods.MakerName, '') <> LoadPriceListItem.ProducerName)
              )
        GROUP BY Object_Goods.Id  ,
           LoadPriceListItem.GoodsCode  ,
           LoadPriceListItem.GoodsName  ,
           LoadPriceListItem.ProducerName , 
           LoadPriceListItem.CodeUKTZED;

     -- ��� ������������� ����� ����� �������� ����������� � ������� �������

     PERFORM
            gpInsertUpdate_Object_LinkGoods(0 , -- ���� ������� <������� ��������>
                 tmpLoadPriceListItem.GoodsId , -- ������� �����
                      tmpLoadPriceListItem.Id , -- ����� �� ������
                                    inSession )
       FROM (WITH tmpLoadPriceListItem AS (SELECT LoadPriceListItem.GoodsId , -- ������� �����
                                                  Object_Goods.Id 
                                           FROM LoadPriceListItem
                                                JOIN (SELECT Object_Goods_View.Id, Object_Goods_View.GoodsCode
                                                      FROM Object_Goods_View 
                                                      WHERE ObjectId = vbJuridicalId
                                                     ) AS Object_Goods ON Object_Goods.goodscode = LoadPriceListItem.GoodsCode
                                           WHERE LoadPriceListItem.GoodsId <> 0 AND LoadPriceListItem.LoadPriceListId = inId
                                           GROUP BY LoadPriceListItem.GoodsId , 
                                                    Object_Goods.Id),
                   tmpLinkGoods AS (SELECT GoodsMainId, GoodsId
                                    FROM Object_LinkGoods_View
                                    WHERE ObjectId = vbJuridicalId)
                             
                   SELECT
                                LoadPriceListItem.GoodsId , -- ������� �����
                                LoadPriceListItem.Id 
                   FROM tmpLoadPriceListItem AS LoadPriceListItem
                        LEFT JOIN tmpLinkGoods AS LinkGoods 
                                               ON LinkGoods.GoodsMainId = LoadPriceListItem.GoodsId
                                              AND LinkGoods.GoodsId = LoadPriceListItem.Id
                   WHERE COALESCE (LinkGoods.GoodsMainId, 0) = 0) AS tmpLoadPriceListItem;

   IF vbisMorionCode = TRUE
   THEN
       -- �������� ���� �������, � ������� ��� �������� � ������� �������
       PERFORM gpInsertUpdate_Object_LinkGoods(0 
                                             , MainGoodsId  -- ������� �����
                                             , GoodsId      -- ����� ��� ������
                                             , inSession    -- ������ ������������
                                             )  
       FROM (
             SELECT DISTINCT 
                    LoadPriceListItem.GoodsId AS MainGoodsId   --������� �����
                  , Object_Goods_View.Id      AS GoodsId       -- ����� ��� ������ (�������)
             FROM Object_Goods_View 
               JOIN LoadPriceListItem ON LoadPriceListItem.CommonCode = Object_Goods_View.GoodsCodeInt
                                     AND LoadPriceListItem.LoadPriceListId = inId

             WHERE ObjectId = zc_Enum_GlobalConst_Marion() AND LoadPriceListItem.GoodsId <> 0
               AND Object_Goods_View.id NOT IN (SELECT GoodsId FROM Object_LinkGoods_View WHERE ObjectId = zc_Enum_GlobalConst_Marion())
            ) AS DDD;

     --��������� ������������ ��� ������ ��� �������
     PERFORM 
           --��������� ������������ ��� ������ ��� �������
           lpInsertUpdate_Object (DD.Id, zc_Object_Goods(), DD.CommonCode, DD.GoodsName)
           -- ��������� ������������� ��� ������ ��� �������
         , lpInsertUpdate_ObjectString(zc_ObjectString_Goods_Maker(), DD.Id, DD.ProducerName)
           -- ��������� ��� ������� � ������� �������
         , lpUpdate_Object_Goods_MorionCode(DD.Id, DD.CommonCode, vbUserId)

     FROM (
           WITH tmpObject_Goods_View AS (SELECT Object_Goods_View.Id, Object_Goods_View.GoodsCodeInt 
                                         FROM Object_Goods_View 
                                         WHERE Object_Goods_View.ObjectId = zc_Enum_GlobalConst_Marion())
                 
           SELECT Object_Goods_View.Id, LoadPriceListItem.CommonCode, LoadPriceListItem.GoodsName, LoadPriceListItem.ProducerName
           FROM LoadPriceListItem

                INNER JOIN tmpObject_Goods_View AS Object_Goods_View 
                                                ON LoadPriceListItem.CommonCode = Object_Goods_View.GoodsCodeInt
                      
           WHERE LoadPriceListItem.GoodsId <> 0        
             AND LoadPriceListItem.LoadPriceListId = inId) AS DD;

   END IF;

   IF vbisBarCode = TRUE
   THEN
       -- �������� �����-����, � ������� ��� �������� � ������� 
       PERFORM gpInsertUpdate_Object_LinkGoods(0 
                                             , MainGoodsId  -- ������� �����
                                             , GoodsId      -- ����� ��� ������
                                             , inSession    -- ������ ������������
                                             )  
       FROM (
             SELECT DISTINCT 
                    LoadPriceListItem.GoodsId AS MainGoodsId    -- ������� �����
                  , Object_Goods_View.Id      AS GoodsId        -- ����� ��� ������ (��������)
             FROM Object_Goods_View 
               JOIN LoadPriceListItem ON LoadPriceListItem.BarCode = Object_Goods_View.GoodsName
                                     AND LoadPriceListItem.LoadPriceListId = inId
                                     AND TRIM (COALESCE (LoadPriceListItem.BarCode,'')) <> ''
      
             WHERE ObjectId = zc_Enum_GlobalConst_BarCode() AND LoadPriceListItem.GoodsId <> 0
              AND Object_Goods_View.Id NOT IN (SELECT GoodsId FROM Object_LinkGoods_View WHERE ObjectId = zc_Enum_GlobalConst_BarCode())
            ) AS DDD;
            

      PERFORM 
            -- ��������� ������������� ��� ������ ��������
            lpInsertUpdate_ObjectString(zc_ObjectString_Goods_Maker(), DD.Id, DD.ProducerName)

      FROM (
            WITH tmpObject_Goods_View AS (SELECT Object_Goods_View.Id, Object_Goods_View.GoodsName 
                                          FROM Object_Goods_View 
                                          WHERE Object_Goods_View.ObjectId = zc_Enum_GlobalConst_BarCode())
                  
            SELECT Object_Goods_View.Id, LoadPriceListItem.ProducerName
            FROM LoadPriceListItem

                 INNER JOIN tmpObject_Goods_View AS Object_Goods_View 
                                                 ON TRIM (Object_Goods_View.GoodsName) = TRIM (LoadPriceListItem.BarCode)
                       
            WHERE LoadPriceListItem.GoodsId <> 0
              AND TRIM (COALESCE (LoadPriceListItem.BarCode,'')) <> ''
              AND LoadPriceListItem.LoadPriceListId = inId
              ) AS DD;
   END IF;

     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ������ �.�.
 25.09.19         *
 19.06.18                                                                   * ���������� �� ������
 ��� ��������
 22.10.14                        *  ���� ������ �������� � ������ ������� � ����������� ��������� � �������� �������������
 17.10.14                        *  
 03.10.14                        *  
 18.09.14                        *  
*/

-- ����
-- SELECT * FROM gpLoadSaleFrom1C('01-01-2013'::TDateTime, '01-01-2014'::TDateTime, '')

/*
SELECT lpDelete_Object(Id, '') FROM (

SELECT *, MIN(Id) OVER (PARTITION BY GoodsMainId) as MINID FROM Object_LinkGoods_View
WHERE ObjectId = zc_Enum_GlobalConst_Marion()) AS DDD

WHERE Id <> MinId

*/


/*
SELECT *
FROM Object
left JOIN ObjectDesc ON ObjectDesc.Id = Object.DescId
INNER JOIN ObjectLink ON ObjectLink.ObjectId = Object.Id
                    AND ObjectLink.DescId = zc_ObjectLink_Goods_Object()
                    AND ObjectLink.ChildObjectId =  zc_Enum_GlobalConst_Marion()
left join Object AS ObjectEn ON ObjectEn.Id = ObjectLink.ChildObjectId
WHERE Object.ObjectCode = 454112   --76689 --"��������� 1000 �� � 30"
*/

-- select * from gpUpdatePartnerGoods(inId := 31994 ,  inSession := '3');