-- Function: gpInsertUpdate_Load_TestingXML (TBlob, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Load_TestingXML (TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Load_TestingXML (
    IN inXmlfile             TBlob   ,  -- файл xml
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
BEGIN

  CREATE EXTENSION IF NOT EXISTS xml2;
  CREATE TEMP TABLE _XML(id int PRIMARY KEY, xml text) ON COMMIT DROP;

  INSERT INTO _XML VALUES (1, inXmlfile::text);

  PERFORM lpInsertUpdate_MovementItem_TestingUser(0, 0 , Object_User.id, tmpResult.Result, tmpResult.DateTimeTest, inSession)
  FROM (SELECT Code, Result::TFloat, DateTimeTest::TDateTime FROM
                      xpath_table('id','xml','_XML',
                                  '/Offers/Offer/@Code|/Offers/Offer/@Result|/Offers/Offer/@DateTimeTest',
                                  'True')
                  AS t(id int, Code Integer, Result Text, DateTimeTest Text)
                  WHERE Result <> 'Null' and DateTimeTest <> 'Null') AS tmpResult
       INNER JOIN Object AS Object_User
                         ON Object_User.DescId = zc_Object_User()
                        AND Object_User.ObjectCode = tmpResult.Code;
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 20.09.18        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Load_TestingXML (inXmlfile:= '', inSession:= '3')