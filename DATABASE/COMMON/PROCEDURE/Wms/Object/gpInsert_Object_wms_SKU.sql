-- Function: gpInsert_Object_wms_SKU(TVarChar)
-- 4.1.1.1 ���������� ������� <sku>

DROP FUNCTION IF EXISTS gpInsert_Object_wms_SKU (VarChar(255));

CREATE OR REPLACE FUNCTION gpInsert_Object_wms_SKU(
    IN inSession       VarChar(255)       -- ������ ������������
)
-- RETURNS TABLE (ProcName TVarChar, TagName TVarChar, ActionName TVarChar, RowNum Integer, RowData Text, ObjectId Integer, GroupId Integer)
RETURNS VOID
AS
$BODY$
   DECLARE vbProcName   TVarChar;
   DECLARE vbTagName    TVarChar;
   DECLARE vbActionName TVarChar;
-- DECLARE vbRowNum     Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Insert_Object_wms_SKU());

     --
     vbProcName:= 'gpInsert_Object_wms_SKU';
     --
     vbTagName := 'sku';
     --
     vbActionName:= 'set';


     -- !!!������ ��� ������ - � Object_GoodsByGoodsKind - �������� ����.!!!
     PERFORM gpInsertUpdate_Object_GoodsByGoodsKind_wms (inSession);


     -- ������� ������� ������
     DELETE FROM Object_WMS WHERE Object_WMS.ProcName = vbProcName;

     -- ������ ������� XML
     -- vbRowNum:= 1;
     -- INSERT INTO Object_WMS (ProcName, TagName, ActionName, RowNum, RowData) VALUES (vbProcName, vbTagName, vbActionName, vbRowNum, '<?xml version="1.0" encoding="UTF-16"?>');


     -- ���������
     -- RETURN QUERY
     -- ��������� - ������������ ����� ������ - �������� XML
     INSERT INTO Object_WMS (ProcName, TagName, ActionName, RowNum, RowData, ObjectId, GroupId)
        SELECT tmp.ProcName, tmp.TagName, tmp.ActionName, tmp.RowNum, tmp.RowData, tmp.ObjectId, tmp.GroupId
        FROM
             (SELECT vbProcName   AS ProcName
                   , vbTagName    AS TagName
                   , vbActionName AS ActionName
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
       --!          ||' control_date="' || '2'                              ||'"' -- ��������, ������������ ����� ������� ���� ������ ������� �� ������� �������� ������ �� ������:"0" � �� ���������"1" � �� ����� ��������"2" � �� ���� ��������� ����� ��������"3" � �� ���� ������������ � ���� ��������� ����� ��������.�������� �� ���������: 0
                    ||' product_life="' || tmpData.product_life :: TVarChar ||'"' -- ���� �������� ������ � ������.
       --!               ||' measure="' || tmpData.MeasureName              ||'"' -- ������� ��������� ������ (������������� �� ����������� � ��).
       --!       ||' lot_capture_req="' || 'f'                              ||'"' -- �������� ������, ����������� �� ������������� ����� ������ ������ ��� ����� ��� ������ ������ �� �����: f � �� ������� t � �������
       --!        ||' weight_control="' || 'A'                              ||'"' -- ����� ����� ����: "A" � ������������� ��� ������� "M" � ������� ��� �������
       --! ||' host_transform_factor="' || '1'                              ||'"' -- ����������� ��������� �� ������� ������ (������� ������� ������ �� � ����� ������� � WMS).
                             ||' upc="' || ''                               ||'"' -- �������� ������
                        ||' weight_g="' || CASE WHEN tmpData.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Ves() THEN 't' ELSE 'f' END ||'"' -- ������� �������� ������ "f" � �� ��������, "t" � ��������. �������� �� ���������: "f"
                                        ||'></' || vbTagName || '>'
                     ) :: Text AS RowData
                     -- Id
                   , tmpData.ObjectId
                   , 0 AS GroupId
              FROM lpSelect_Object_wms_SKU() AS tmpData
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
/*
CREATE TABLE Object_WMS(
   Id                    BIGSERIAL NOT NULL PRIMARY KEY, 
   ProcName              TVarChar NOT NULL,
   TagName               TVarChar NOT NULL,
   ActionName            TVarChar NOT NULL,
   RowNum                Integer  NOT NULL,
   RowData               Text     NOT NULL,
   ObjectId              Integer  NOT NULL
   );
CREATE INDEX idx_Object_WMS_ProcName ON Object_WMS (ProcName);
CREATE INDEX idx_Object_WMS_TagName  ON Object_WMS (TagName);
*/
-- delete FROM Object_WMS
-- select * FROM Object_WMS
-- ����
-- SELECT * FROM gpInsert_Object_wms_SKU (zfCalc_UserAdmin())
