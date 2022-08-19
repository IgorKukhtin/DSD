-- Function: zfGet_ProtokolStr

DROP FUNCTION IF EXISTS zfGet_ProtokolStr (TVarChar, Text);

CREATE OR REPLACE FUNCTION zfGet_ProtokolStr(
    IN inNode            TVarChar, 
    IN inProtocolData    Text)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbResult TVarChar;
BEGIN

  IF NOT EXISTS (SELECT 1 FROM pg_extension where extname = 'xml2')
  THEN
     CREATE EXTENSION IF NOT EXISTS xml2;
  END IF;
  
  IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_XML'))
  THEN
    CREATE TEMP TABLE _XML(id int PRIMARY KEY, xml text) ON COMMIT DROP;
  ELSE
    DELETE FROM _XML;
  END IF;

  INSERT INTO _XML VALUES (1, inProtocolData::text);

  WITH tmpProtocolData AS (SELECT FieldName, FieldValue 
                           FROM xpath_table('id','xml','_XML', '/XML/Field/@FieldName|/XML/Field/@FieldValue', 'True') AS t(id Integer, FieldName TVarChar, FieldValue TVarChar))
                  
  SELECT tmpProtocolData.FieldValue
  INTO vbResult
  FROM tmpProtocolData
  WHERE tmpProtocolData.FieldName = inNode
  LIMIT 1;
  
  RETURN vbResult;
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.08.22                                                       *
*/

-- ����

SELECT zfGet_ProtokolStr('������������� ���������� ��������', '<XML><Field FieldName = "��������" FieldValue = "������ ���� ������ ��-�� 50�� (���������)"/><Field FieldName = "���" FieldValue = "21785"/><Field FieldName = "������" FieldValue = "NULL"/><Field FieldName = "������" FieldValue = "false"/><Field FieldName = "���-�� �������" FieldValue = "6.0000"/><Field FieldName = "���-�� ������� � ��������" FieldValue = "1.0000"/><Field FieldName = "���-�� � ��������" FieldValue = "1.0000"/><Field FieldName = "���� �������� ������" FieldValue = "22.07.2022"/><Field FieldName = "���� ������. ���� ������� �� �����" FieldValue = "22.07.2022"/><Field FieldName = "����� ������� � ������� �������" FieldValue = "�����������.���������������"/><Field FieldName = "����� ������� � �������� ���������" FieldValue = "��"/><Field FieldName = "����� ������� � ����� ���" FieldValue = "0% - �����������"/><Field FieldName = "����� �������" FieldValue = "��."/><Field FieldName = "�������������" FieldValue = "��� ���������,�������"/><Field FieldName = "�������� ����������" FieldValue = ""/><Field FieldName = "��� ������" FieldValue = ""/><Field FieldName = "�������� �������� ������ ATC" FieldValue = ""/><Field FieldName = "����������� ��������" FieldValue = ""/><Field FieldName = "������������� ���������� ��������" FieldValue = "��� ���������,������"/><Field FieldName = "����� ������" FieldValue = "true"/><Field FieldName = "��������� 224" FieldValue = "true"/><Field FieldName = "��������� ��� ����������� �� ���" FieldValue = "false"/><Field FieldName = "��������� / �� ���������" FieldValue = "false"/></XML>');

