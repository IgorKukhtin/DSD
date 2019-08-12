-- Function: gpInsert_Object_wms_SKU(TVarChar)
-- 4.1.1.1 ���������� ������� <sku>

DROP FUNCTION IF EXISTS gpInsert_Object_wms_SKU (VarChar(255));

CREATE OR REPLACE FUNCTION gpInsert_Object_wms_SKU(
    IN inSession       VarChar(255)       -- ������ ������������
)
-- RETURNS TABLE (ProcName TVarChar, RowNum Integer, RowData Text, ObjectId Integer)
RETURNS VOID
AS
$BODY$
   DECLARE vbProcName TVarChar;
   DECLARE vbRowNum   Integer;
BEGIN
     vbProcName:= 'gpInsert_Object_wms_SKU';
/*
CREATE TABLE Object_WMS(
   Id                    BIGSERIAL NOT NULL PRIMARY KEY, 
   ProcName              TVarChar NOT NULL,
   RowNum                Integer  NOT NULL,
   RowData               Text     NOT NULL,
   ObjectId              Integer  NOT NULL
   );
CREATE INDEX idx_Object_WMS_ProcName ON Object_WMS (ProcName);
*/
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Insert_Object_wms_SKU());



     -- ������� ������� ������
     DELETE FROM Object_WMS WHERE Object_WMS.ProcName = vbProcName;

     -- ������ ������� XML
     -- vbRowNum:= 1;
     -- INSERT INTO Object_WMS (ProcName, RowNum, RowData) VALUES (vbProcName, vbRowNum, '<?xml version="1.0" encoding="UTF-16"?>');


     -- ���������
     -- RETURN QUERY
     -- ��������� - ������������ ����� ������ - �������� XML
     INSERT INTO Object_WMS (ProcName, RowNum, RowData, ObjectId)
        SELECT vbProcName AS ProcName
             , (COALESCE (vbRowNum, 0) + ROW_NUMBER() OVER (ORDER BY tmpData.sku_id) :: Integer) AS RowNum
               -- XML
             , ('<sku'
--                ||' syncid=�' || tmpData.sku_id    :: TVarChar ||'"' -- ???
--                ||' action=�' || 'update'                       ||'"' -- ???
--              ||' syncdate=�' || CURRENT_TIMESTAMP  :: TVarChar ||'"' -- ???
                  ||' sku_id=�' || tmpData.sku_id       :: TVarChar ||'"' -- ���������� ��� ������ � �������� ����������� �����������
                ||' sku_code=�' || tmpData.sku_code     :: TVarChar ||'"' -- ����������, ��������-�������� ��� ������ ��� ����������� � �������� ������.
                    ||' name=�' || tmpData.name                     ||'"' -- ������������ ������ � �������� ����������� �����������
             ||' description=�' || ''                                ||'"' -- �������� ������ � �������� ����������� �����������.
            ||' control_date=�' || '3'                               ||'"' -- ��������, ������������ ����� ������� ���� ������ ������� �� ������� �������� ������ �� ������:�0� � �� ����������1� � �� ����� ��������2� � �� ���� ��������� ����� ��������3� � �� ���� ������������ � ���� ��������� ����� ��������.�������� �� ���������: 0
            ||' product_life=�' || tmpData.product_life :: TVarChar ||'"' -- ���� �������� ������ � ������.
                 ||' measure=�' || tmpData.MeasureName              ||'"' -- ������� ��������� ������ (������������� �� ����������� � ��).
         ||' lot_capture_req=�' || 'f'                               ||'"' -- �������� ������, ����������� �� ������������� ����� ������ ������ ��� ����� ��� ������ ������ �� �����: f � �� ������� t � �������
          ||' weight_control=�' || 'A'                               ||'"' -- ����� ����� ����: �A� � ������������� ��� ������� �M� � ������� ��� �������
   ||' host_transform_factor=�' || '1'                               ||'"' -- ����������� ��������� �� ������� ������ (������� ������� ������ �� � ����� ������� � WMS).
                     ||' upc=�' || ''                                ||'"' -- �������� ������
                     ||' </sku>'
               ):: Text AS RowData
               -- Id
             , tmpData.ObjectId
        FROM lpSelect_Object_wms_SKU() AS tmpData
        ORDER BY 2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
              ������� �.�.   ������ �.�.   ���������� �.�.
 10.08.19                                       *
*/
-- ����
-- SELECT * FROM gpInsert_Object_wms_SKU (zfCalc_UserAdmin())
