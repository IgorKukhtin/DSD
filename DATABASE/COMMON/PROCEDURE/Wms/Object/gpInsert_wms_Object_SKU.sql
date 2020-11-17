-- Function: gpInsert_wms_Object_SKU(TVarChar)
-- 4.1.1.1 ���������� ������� <sku>

DROP FUNCTION IF EXISTS gpInsert_wms_Object_SKU (VarChar(255), VarChar(255));

CREATE OR REPLACE FUNCTION gpInsert_wms_Object_SKU(
    IN inGUID          VarChar(255),      --
   OUT outRecCount     Integer     ,      --
    IN inSession       VarChar(255)       -- ������ ������������
)
-- RETURNS TABLE (GUID TVarChar, ProcName TVarChar, TagName TVarChar, RowNum Integer, ActionName TVarChar, RowData Text, ObjectId Integer, GroupId Integer, InsertDate TDateTime)
RETURNS Integer
AS
$BODY$
   DECLARE vbProcName   TVarChar;
   DECLARE vbTagName    TVarChar;
   DECLARE vbActionName TVarChar;
-- DECLARE vbRowNum     Integer;
   DECLARE vbGoodsPropertyId_basis Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_wms_Object_SKU());

     --
     vbProcName:= 'gpInsert_wms_Object_SKU';
     --
     vbTagName := 'sku';
     --
     vbActionName:= 'set';


     -- !!!������ ��� ������ - � Object_GoodsByGoodsKind - �������� ����.!!!
     PERFORM gpInsertUpdate_wms_Object_GoodsByGoodsKind (inSession);


     -- ��������
     IF TRIM (COALESCE (inGUID, '')) = ''
     THEN
         RAISE EXCEPTION 'Error inGUID = <%>', inGUID;
     ELSEIF inGUID = '1'
     THEN
         -- ������� ������� ������
         DELETE FROM wms_Message WHERE wms_Message.GUID = inGUID; -- AND wms_Message.ProcName = vbProcName;
     END IF;


     -- ������ ������� XML
     -- vbRowNum:= 1;
     -- INSERT INTO wms_Message (GUID, ProcName, TagName, RowNum, RowData) VALUES (inGUID, vbProcName, vbTagName, vbRowNum, '<?xml version="1.0" encoding="UTF-16"?>');

     --
     vbGoodsPropertyId_basis:= zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0);

     -- ���������
     -- RETURN QUERY
     -- ��������� - ������������ ����� ������ - �������� XML
     INSERT INTO wms_Message (GUID, ProcName, TagName, ActionName, RowNum, RowData, ObjectId, GroupId, InsertDate)
        --
        WITH tmpData AS (SELECT * FROM lpSelect_wms_Object_SKU())
           , tmpGoodsProperty_basis_all AS (SELECT OL_Goods.ChildObjectId         AS GoodsId
                                                 , OL_GoodsKind.ChildObjectId     AS GoodsKindId
                                                 , ObjectString_BarCode.ValueData AS BarCode
                                            FROM (SELECT vbGoodsPropertyId_basis AS GoodsPropertyId
                                                 ) AS tmpGoodsProperty
                                                 INNER JOIN ObjectLink AS OL_GoodsPropertyValue
                                                                       ON OL_GoodsPropertyValue.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                                      AND OL_GoodsPropertyValue.DescId        = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                                 LEFT JOIN ObjectLink AS OL_Goods
                                                                      ON OL_Goods.ObjectId = OL_GoodsPropertyValue.ObjectId
                                                                     AND OL_Goods.DescId   = zc_ObjectLink_GoodsPropertyValue_Goods()
                                                 LEFT JOIN ObjectLink AS OL_GoodsKind
                                                                      ON OL_GoodsKind.ObjectId = OL_GoodsPropertyValue.ObjectId
                                                                     AND OL_GoodsKind.DescId   = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                                 LEFT JOIN ObjectString AS ObjectString_BarCode
                                                                        ON ObjectString_BarCode.ObjectId = OL_GoodsPropertyValue.ObjectId
                                                                       AND ObjectString_BarCode.DescId   = zc_ObjectString_GoodsPropertyValue_BarCode()
                                           )
           , tmpGoodsProperty_basis AS (SELECT tmpData.sku_id
                                             , tmpGoodsProperty_basis_all.BarCode
                                               -- � �/�
                                             , ROW_NUMBER() OVER (PARTITION BY tmpGoodsProperty_basis_all.GoodsId, tmpGoodsProperty_basis_all.GoodsKindId
                                                                  ORDER BY CASE WHEN tmpData.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Sh()  THEN 1
                                                                                WHEN tmpData.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Nom() THEN 2
                                                                                WHEN tmpData.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Ves() THEN 3
                                                                                ELSE 100
                                                                           END ASC
                                                                 ) AS Ord
                                        FROM tmpData
                                             JOIN tmpGoodsProperty_basis_all ON tmpGoodsProperty_basis_all.GoodsId     = tmpData.GoodsId
                                                                            AND tmpGoodsProperty_basis_all.GoodsKindId = tmpData.GoodsKindId
                                       )
        --
        SELECT inGUID, tmp.ProcName, tmp.TagName, vbActionName, tmp.RowNum, tmp.RowData, tmp.ObjectId, tmp.GroupId, CURRENT_TIMESTAMP AS InsertDate
        FROM
             (SELECT vbProcName   AS ProcName
                   , vbTagName    AS TagName
                   , (ROW_NUMBER() OVER (ORDER BY tmpData.sku_id) :: Integer) AS RowNum
                     -- XML
                   , ('<' || vbTagName
       --                 ||' syncid="' || tmpData.sku_id       :: TVarChar ||'"' -- ???
                          ||' action="' || vbActionName                     ||'"' -- ???
       --               ||' syncdate="' || CURRENT_TIMESTAMP    :: TVarChar ||'"' -- ???
       --           ||' _internal_id="' || tmpData.sku_id       :: TVarChar ||'"' -- ���������� ��� ������ � �������� ����������� �����������
                          ||' sku_id="' || tmpData.sku_id       :: TVarChar ||'"' -- ���������� ��� ������ � �������� ����������� �����������
       --               ||' sku_code="' || tmpData.sku_code     :: TVarChar ||'"' -- ����������, ��������-�������� ��� ������ ��� ����������� � �������� ������.
                            ||' sdid="' || tmpData.sku_code     :: TVarChar ||'"' -- ����������, ��������-�������� ��� ������ ��� ����������� � �������� ������.
                            ||' name="' || tmpData.name                     ||'"' -- ������������ ������ � �������� ����������� �����������
                     ||' description="' || ''                               ||'"' -- �������� ������ � �������� ����������� �����������.
                    ||' control_date="' || '1'                              ||'"' -- ��������, ������������ ����� ������� ���� ������ ������� �� ������� �������� ������ �� ������:"0" � �� ���������"1" � �� ����� ��������"2" � �� ���� ��������� ����� ��������"3" � �� ���� ������������ � ���� ��������� ����� ��������.�������� �� ���������: 0
                    ||' product_life="' || tmpData.product_life :: TVarChar ||'"' -- ���� �������� ������ � ������.
       --!               ||' measure="' || tmpData.MeasureName              ||'"' -- ������� ��������� ������ (������������� �� ����������� � ��).
       --!       ||' lot_capture_req="' || 'f'                              ||'"' -- �������� ������, ����������� �� ������������� ����� ������ ������ ��� ����� ��� ������ ������ �� �����: f � �� ������� t � �������
       --!        ||' weight_control="' || 'A'                              ||'"' -- ����� ����� ����: "A" � ������������� ��� ������� "M" � ������� ��� �������
       --! ||' host_transform_factor="' || '1'                              ||'"' -- ����������� ��������� �� ������� ������ (������� ������� ������ �� � ����� ������� � WMS).
                             ||' upc="' || CASE WHEN CHAR_LENGTH (COALESCE (tmpGoodsProperty_basis.BarCode, '')) = 13 THEN tmpGoodsProperty_basis.BarCode ELSE '' END ||'"' -- �������� ������
                        ||' weight_g="' || CASE WHEN tmpData.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Nom() THEN 't' ELSE 'f' END ||'"' -- ������� �������� ������ "f" � �� ��������, "t" � ��������. �������� �� ���������: "f"
                --||' weight_control="' || CASE WHEN tmpData.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Nom() THEN 'M' ELSE 'A' END ||'"' -- � - ������ ��������������, ���������� ��� �������� ������ � �� ������������ M - �������� �������, ���������� ��� ������������ ������
                                        ||'></' || vbTagName || '>'
                     ) :: Text AS RowData
                     -- Id
                   , tmpData.ObjectId
                   , 0 AS GroupId
              FROM tmpData
                   LEFT JOIN tmpGoodsProperty_basis ON tmpGoodsProperty_basis.sku_id = tmpData.sku_id
                                                   AND tmpGoodsProperty_basis.Ord    = 1
          --WHERE tmpData.sku_id IN ('2659002')
          --WHERE tmpData.sku_id IN ('3445471', '5304811', '27981831')
          --WHERE tmpData.InfoMoneyId = 8963 -- �������
           ) AS tmp
     -- WHERE tmp.RowNum = 1
        ORDER BY 4
     -- LIMIT 1
       ;


     -- ���������
     outRecCount:= (SELECT COUNT(*) FROM wms_Message WHERE wms_Message.GUID = inGUID);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
              ������� �.�.   ������ �.�.   ���������� �.�.
 10.08.19                                       *
*/
-- 956-   - select * from lpSelect_wms_Object_SKU() where sku_id IN ('38391802') -- "������� ����Ͳ ����-��� � ����̻ �� ����. �����������"
-- 777-16 - select * from lpSelect_wms_Object_SKU() where sku_id IN ('800562', '800563') -- "�������� ��������� �/� �/� �/� ����������� + �������������"
-- 39-3   - select * from lpSelect_wms_Object_SKU() where sku_id IN ('795292', '795293') -- "������������ ������� ���.  �/� �/� ����������� + �������������"
-- select * from lpSelect_wms_Object_SKU() where goodsCode in ('2201 ', '2431 ', '2304') --
-- select * from lpSelect_wms_Object_SKU() where InfoMoneyId = 8963
-- select * FROM wms_Message WHERE RowData ILIKE '%sku_id=945179%
-- select * FROM wms_Message WHERE GUID = '1' ORDER BY Id
-- ����
-- SELECT * FROM gpInsert_wms_Object_SKU ('1', zfCalc_UserAdmin())
