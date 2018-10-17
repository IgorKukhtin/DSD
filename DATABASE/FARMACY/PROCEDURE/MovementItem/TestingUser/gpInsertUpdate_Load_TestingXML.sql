-- Function: gpInsertUpdate_Load_TestingXML (TBlob, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Load_TestingXML (TBlob, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Load_TestingXML (TBlob, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Load_TestingXML (
    IN inXmlHeaders          TBlob   ,  -- ���� xml
    IN inXmlOffers           TBlob   ,  -- ���� xml
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbMovement Integer;
  DECLARE vbVersion Integer;
  DECLARE vbQuestion Integer;
  DECLARE vbMaxAttempts Integer;
  DECLARE vbDateTest TDateTime;
BEGIN

  CREATE EXTENSION IF NOT EXISTS xml2;
  CREATE TEMP TABLE _XML(id int PRIMARY KEY, xml text) ON COMMIT DROP;

  INSERT INTO _XML VALUES (1, inXmlHeaders::text);

  SELECT Version, Question, MaxAttempts, DateTest
  INTO vbVersion, vbQuestion, vbMaxAttempts, vbDateTest
  FROM xpath_table('id','xml','_XML',
                   '/Headers/Header/@Version|/Headers/Header/@Question|/Headers/Header/@MaxAttempts|/Headers/Header/@DateTest',
                   'True') AS t(id Integer, Version Integer, Question Integer, MaxAttempts Integer, DateTest TDateTime);

  IF COALESCE (vbVersion, 0) <= 0 OR COALESCE (vbQuestion, 0) <= 0 OR COALESCE (vbMaxAttempts, -1) < 0
  THEN
    RAISE EXCEPTION '������. �� ���������� ������ (%), ���������� �������� (%) ��� ���������� ������� (%)', vbVersion, vbQuestion, vbMaxAttempts;
  END IF;

  IF date_trunc('month', vbDateTest) <> date_trunc('month', CURRENT_TIMESTAMP)
  THEN
    RAISE EXCEPTION '������. ���� ������ ��������������� �������� ������';
  END IF;

  vbMovement := 0;
  vbMovement := lpInsertUpdate_Movement_TestingUser(vbMovement, vbDateTest, vbVersion, vbQuestion, vbMaxAttempts, inSession);

  DELETE FROM _XML;
  INSERT INTO _XML VALUES (1, inXmlOffers::text);

  PERFORM lpInsertUpdate_MovementItem_TestingUser(0, vbMovement, Object_User.id, tmpResult.Result, tmpResult.Attempts, tmpResult.DateTimeTest, inSession)
  FROM (SELECT Code, Result::Integer, Attempts::Integer, DateTimeTest::TDateTime FROM
                      xpath_table('id','xml','_XML',
                                  '/Offers/Offer/@Code|/Offers/Offer/@Result|/Offers/Offer/@Attempts|/Offers/Offer/@DateTimeTest',
                                  'True')
                  AS t(id Integer, Code Integer, Result Text, Attempts Text, DateTimeTest Text)
                  WHERE Result <> 'Null' and DateTimeTest <> 'Null') AS tmpResult
       INNER JOIN Object AS Object_User
                         ON Object_User.DescId = zc_Object_User()
                        AND Object_User.ObjectCode = tmpResult.Code;
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������ �.�.
 15.10.18        *
 20.09.18        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Load_TestingXML (inXmlfile:= '', inSession:= '3')