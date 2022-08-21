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
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.08.22                                                       *
*/

-- тест

SELECT zfGet_ProtokolStr('Производитель украинское название', '<XML><Field FieldName = "Значение" FieldValue = "Акутол Септ дезинф ср-во 50мл (Владасепт)"/><Field FieldName = "Код" FieldValue = "21785"/><Field FieldName = "Доступ" FieldValue = "NULL"/><Field FieldName = "Удален" FieldValue = "false"/><Field FieldName = "Кол-во прайсов" FieldValue = "6.0000"/><Field FieldName = "Кол-во пластин в упаковке" FieldValue = "1.0000"/><Field FieldName = "Кол-во в упаковке" FieldValue = "1.0000"/><Field FieldName = "Дата загрузки прайса" FieldValue = "22.07.2022"/><Field FieldName = "Пред Послед. дата наличия на рынке" FieldValue = "22.07.2022"/><Field FieldName = "Связь товаров с группой товаров" FieldValue = "Антисептики.Ранозаживляющие"/><Field FieldName = "Связь товаров с единицей измерения" FieldValue = "уп"/><Field FieldName = "Связь товаров с Видом НДС" FieldValue = "0% - медикаменты"/><Field FieldName = "Форма отпуска" FieldValue = "шт."/><Field FieldName = "Производитель" FieldValue = "ООО Владасепт,Украина"/><Field FieldName = "Название украинское" FieldValue = ""/><Field FieldName = "Код УКТЗЭД" FieldValue = ""/><Field FieldName = "Перечень аналогов товара ATC" FieldValue = ""/><Field FieldName = "Действующее вещество" FieldValue = ""/><Field FieldName = "Производитель украинское название" FieldValue = "ТОВ Владасепт,Україна"/><Field FieldName = "Общие товары" FieldValue = "true"/><Field FieldName = "Постанова 224" FieldValue = "true"/><Field FieldName = "Невидимка для ограничений по СУН" FieldValue = "false"/><Field FieldName = "Рецептура / Не рецептура" FieldValue = "false"/></XML>');

