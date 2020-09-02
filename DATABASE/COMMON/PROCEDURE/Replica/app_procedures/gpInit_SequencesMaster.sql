/* 
  _replica.gpInit_SequencesMaster() - ������� ������� ������������ id ��� �������, ��������� � ���� 10000 �� ������, ���� � ��� �� ����� ���-�� ��� ������� ������ � �������,
                                      ��������� ��� � table_slave � start_id, � ����������������� sequence ��� ��������� ������� 
                                      � ������ ����������� start_id � digit_for_increment, ������� ����������� ��� ����������� �������
                                      � _replica.clients �� �������
*/

CREATE OR REPLACE FUNCTION _replica.gpInit_SequencesMaster(inSchema TVarChar, inTable TVarChar, inColumn TVarChar, inSequence TVarChar)
RETURNS VOID AS
$BODY$
DECLARE vbSql TEXT;
DECLARE vbStartId BIGINT;
DECLARE vbDigitForIncrement INT;
BEGIN

  vbDigitForIncrement := (SELECT digit_for_increment FROM _replica.clients WHERE client_id ::Text = (SELECT value FROM _replica.settings WHERE name ILIKE 'client_id'));
  IF vbDigitForIncrement IS NULL THEN
    RAISE EXCEPTION '������ ��������� digit_for_increment �� ������� _replica.clients';
  END IF;
  
  INSERT INTO _replica.table_slave(master_schema, master_table)
  SELECT inSchema, inTable
  WHERE NOT EXISTS(SELECT * FROM _replica.table_slave t 
                   WHERE t.master_schema = inSchema 
                     AND t.master_table = inTable);  
  
  EXECUTE 'UPDATE _replica.table_slave ' || 
          'SET start_id =  COALESCE((SELECT MAX('|| inColumn ||') FROM ' || inSchema || '.' || inTable || '),0) + 1 ' ||
          'WHERE master_schema = ''' || inSchema || ''' AND master_table = ''' || inTable || ''';';

  vbStartId := COALESCE((SELECT start_id FROM _replica.table_slave WHERE master_schema = inSchema and master_table = inTable), 0);
  vbStartId := COALESCE(CEIL(vbStartId / 10.0) * 10, 0) + vbDigitForIncrement;
  
  vbSQL := 'ALTER SEQUENCE ' || inSequence || ' INCREMENT 10 RESTART WITH ' || vbStartId :: TVarChar || ';';
  
  EXECUTE vbSQL;  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;  
