-- Function: gpInsertUpdate_Object_Area()

DROP FUNCTION IF EXISTS gpDelete_Object_DataExcel_byUser(TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_Object_DataExcel_byUser(
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession; 

    CREATE TEMP TABLE tmpDataExcel(Id Integer) ON COMMIT DROP;
    INSERT INTO tmpDataExcel   
           SELECT Object_DataExcel.Id
           FROM Object AS Object_DataExcel
                JOIN ObjectLink AS ObjectLink_Insert
                                ON ObjectLink_Insert.ObjectId = Object_DataExcel.Id
                               AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
                               AND ObjectLink_Insert.ChildObjectId = vbUserId
           WHERE Object_DataExcel.DescId = zc_Object_DataExcel()
               AND Object_DataExcel.ObjectCode = 1
               --AND Object_DataExcel.ValueData LIKE '%||inUnitId||%'
           ;
                     
                     
    DELETE FROM ObjectDate     WHERE ObjectId IN (SELECT tmpDataExcel.Id FROM tmpDataExcel);
    DELETE FROM ObjectLink     WHERE ObjectId IN (SELECT tmpDataExcel.Id FROM tmpDataExcel);
    DELETE FROM ObjectProtocol WHERE ObjectId IN (SELECT tmpDataExcel.Id FROM tmpDataExcel);
    --
    DELETE FROM Object AS Object_DataExcel WHERE Object_DataExcel.Id IN (SELECT tmpDataExcel.Id FROM tmpDataExcel);

   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.10.17         *
*/

-- ����
-- SELECT * FROM gpDelete_Object_DataExcel_byUser(inSession:='2'::TVarChar)