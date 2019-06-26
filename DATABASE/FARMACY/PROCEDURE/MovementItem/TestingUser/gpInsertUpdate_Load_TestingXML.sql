-- Function: gpInsertUpdate_Load_TestingXML (TBlob, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Load_TestingXML (TDateTime, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Load_TestingXML (
    IN inOperDate            TDateTime  ,  -- Месяц тестирования
    IN inXmlOffers           TBlob      ,  -- файл xml
    IN inSession             TVarChar      -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbMovement Integer;
BEGIN

  -- приводим дату к первому числу месяца
  inOperDate := date_trunc('month', inOperDate);

  vbMovement := lpInsertUpdate_Movement_TestingUser(ioId          := 0,
                                                    inOperDate    := inOperDate, -- Дата документа
                                                    inVersion     := 0,          -- Версия опроса
                                                    inQuestion    := 0,          -- Количество вопросов
                                                    inMaxAttempts := 0,          -- Количество попыток
                                                    inSession     := inSession); -- сессия пользователя
  IF EXISTS(SELECT * FROM MovementItem
            WHERE MovementItem.MovementId = vbMovement
              AND MovementItem.DescId = zc_MI_Master())
  THEN
    UPDATE MovementItem SET Amount = 0
    WHERE MovementItem.MovementId = vbMovement
      AND MovementItem.DescId = zc_MI_Master();

    UPDATE MovementItemFloat SET ValueData = 0
    WHERE MovementItemFloat.DescId = zc_MIFloat_TestingUser_Attempts()
      AND MovementItemFloat.MovementItemId in (SELECT MovementItem.Id FROM MovementItem
                                               WHERE MovementItem.MovementId = vbMovement
                                                 AND MovementItem.DescId = zc_MI_Master());
  END IF;

  CREATE EXTENSION IF NOT EXISTS xml2;
  CREATE TEMP TABLE _XML(id int PRIMARY KEY, xml text) ON COMMIT DROP;

  INSERT INTO _XML VALUES (1, inXmlOffers::text);

  PERFORM lpInsertUpdate_MovementItem_TestingUser(0, vbMovement, Object_User.id,
                     (tmpResult.Theme1 + tmpResult.Theme2 + tmpResult.Theme3 + tmpResult.Theme4) * 100 / 4, tmpResult.DateTimeTest, inSession)
  FROM (SELECT Code, Theme1::TFloat, Theme2::TFloat, Theme3::TFloat, Theme4::TFloat, DateTimeTest::TDateTime FROM
                      xpath_table('id','xml','_XML',
                                  '/Offers/Offer/@Code|/Offers/Offer/@Theme1|/Offers/Offer/@Theme2|/Offers/Offer/@Theme3|/Offers/Offer/@Theme4|/Offers/Offer/@DateTimeTest',
                                  'True')
                  AS t(id Integer, Code Integer, Theme1 Text, Theme2 Text, Theme3 Text, Theme4 Text, DateTimeTest Text)
                  WHERE Theme1 <> 'Null' and Theme2 <> 'Null' and Theme3 <> 'Null' and Theme4 <> 'Null' and DateTimeTest <> 'Null') AS tmpResult
       INNER JOIN Object AS Object_User
                         ON Object_User.DescId = zc_Object_User()
                        AND Object_User.ObjectCode = tmpResult.Code;
--       WHERE inOperDate = date_trunc('month',  tmpResult.DateTimeTest);
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 25.06.19        *
 15.10.18        *
 20.09.18        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Load_TestingXML (inOperDate := '25/06/2019', inXmlOffers := '', inSession:= '3')