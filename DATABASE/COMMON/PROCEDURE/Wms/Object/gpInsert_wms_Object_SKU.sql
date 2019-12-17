-- Function: gpInsert_wms_Object_SKU(TVarChar)
-- 4.1.1.1 ���������� ������� <sku>

DROP FUNCTION IF EXISTS gpInsert_wms_Object_SKU (VarChar(255), VarChar(255));

CREATE OR REPLACE FUNCTION gpInsert_wms_Object_SKU(
    IN inGUID          VarChar(255),      -- 
    IN inSession       VarChar(255)       -- ������ ������������
)
-- RETURNS TABLE (GUID TVarChar, ProcName TVarChar, TagName TVarChar, RowNum Integer, ActionName TVarChar, RowData Text, ObjectId Integer, GroupId Integer, InsertDate TDateTime)
RETURNS VOID
AS
$BODY$
   DECLARE vbProcName   TVarChar;
   DECLARE vbTagName    TVarChar;
   DECLARE vbActionName TVarChar;
-- DECLARE vbRowNum     Integer;
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


     -- ���������
     -- RETURN QUERY
     -- ��������� - ������������ ����� ������ - �������� XML
     INSERT INTO wms_Message (GUID, ProcName, TagName, ActionName, RowNum, RowData, ObjectId, GroupId, InsertDate)
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
                             ||' upc="' || ''                               ||'"' -- �������� ������
                        ||' weight_g="' || CASE WHEN tmpData.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Nom() THEN 't' ELSE 'f' END ||'"' -- ������� �������� ������ "f" � �� ��������, "t" � ��������. �������� �� ���������: "f"
                --||' weight_control="' || CASE WHEN tmpData.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Nom() THEN 'M' ELSE 'A' END ||'"' -- � - ������ ��������������, ���������� ��� �������� ������ � �� ������������ M - �������� �������, ���������� ��� ������������ ������
                                        ||'></' || vbTagName || '>'
                     ) :: Text AS RowData
                     -- Id
                   , tmpData.ObjectId
                   , 0 AS GroupId
              FROM lpSelect_wms_Object_SKU() AS tmpData
            --WHERE tmpData.sku_id IN ('795513', '38391802')
             ) AS tmp
     -- WHERE tmp.RowNum = 1
        ORDER BY 4
     -- LIMIT 1
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
              ������� �.�.   ������ �.�.   ���������� �.�.
 10.08.19                                       *
*/
-- 956-16 - select * from wms_Object_GoodsByGoodsKind where '38391802' in (sku_id_sh, sku_id_nom, sku_id_ves)
-- 39-3   - select * from wms_Object_GoodsByGoodsKind where sku_id_nom = '795292'
-- select * FROM wms_Message WHERE RowData ILIKE '%sku_id=945179%
-- select * FROM wms_Message WHERE GUID = '1' ORDER BY Id
-- ����
-- SELECT * FROM gpInsert_wms_Object_SKU ('1', zfCalc_UserAdmin())
