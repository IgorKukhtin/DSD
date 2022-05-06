-- Function: lpInsert_MovementItemProtocol (Integer, Integer)

DROP FUNCTION IF EXISTS lpInsert_MovementItemProtocol (Integer, Integer, Boolean, Boolean);

CREATE OR REPLACE FUNCTION lpInsert_MovementItemProtocol
(   IN inMovementItemId Integer,
    IN inUserId         Integer,
    IN inIsInsert       Boolean,              -- Признак
    IN inIsErased       Boolean DEFAULT NULL  -- Признак, если НЕ пустой тогда в протокол св-ва не пишутся
)
  RETURNS void AS
$BODY$
 DECLARE 
   vbProtocolXML TBlob;
BEGIN

-- !!!ВРЕМЕННО-выкл.
-- RETURN;

  -- Подготавливаем XML для записи в протокол
  WITH
   tmpMovementItem AS (SELECT '<Field FieldName = "Ключ объекта" FieldValue = "' || COALESCE(MovementItem.ObjectId::TBlob, '') || '"/>'
                           || '<Field FieldName = "Объект" FieldValue = "' || zfStrToXmlText (COALESCE (Object.ValueData, 'NULL')) || '"/>'
                           || '<Field FieldName = "Значение" FieldValue = "' || MovementItem.Amount || '"/>'
                           || CASE WHEN MovementItem.ParentId <> 0 THEN '<Field FieldName = "ParentId" FieldValue = "' || MovementItem.ParentId || '"/>' ELSE '' END
                           || '<Field FieldName = "Удален" FieldValue = "' || MovementItem.isErased || '"/>'
                              AS FieldXML
                            , 1 AS GroupId
                            , MovementItem.DescId
                       FROM MovementItem
                            LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
                       WHERE MovementItem.Id = inMovementItemId
                       )

 , tmpMovementItemFloat AS (SELECT '<Field FieldName = "' || zfStrToXmlStr(MovementItemFloatDesc.ItemName) || '" FieldValue = "' || COALESCE (MovementItemFloat.ValueData :: TVarChar, 'NULL') || '"/>' AS FieldXML 
                                 , 2 AS GroupId
                                 , MovementItemFloat.DescId
                            FROM MovementItemFloat
                                 INNER JOIN MovementItemFloatDesc ON MovementItemFloatDesc.Id = MovementItemFloat.DescId
                            WHERE MovementItemFloat.MovementItemId = inMovementItemId
                              AND inIsErased IS NULL
                            )

 , tmpMovementItemDate AS (SELECT '<Field FieldName = "' || zfStrToXmlStr(MovementItemDateDesc.ItemName) || '" FieldValue = "' || COALESCE (MovementItemDate.ValueData :: TVarChar, 'NULL') || '"/>' AS FieldXML 
                                , 3 AS GroupId
                                , MovementItemDate.DescId
                           FROM MovementItemDate
                                INNER JOIN MovementItemDateDesc ON MovementItemDateDesc.Id = MovementItemDate.DescId
                           WHERE MovementItemDate.MovementItemId = inMovementItemId
                             AND inIsErased IS NULL
                           )

 , tmpMovementItemLinkObject AS (SELECT '<Field FieldName = "' || zfStrToXmlStr(MovementItemLinkObjectDesc.ItemName) || '" FieldValue = "' || zfStrToXmlText(COALESCE (Object.ValueData, 'NULL')) || '"/>' AS FieldXML
                                      , 4 AS GroupId
                                      , MovementItemLinkObject.DescId
                                 FROM MovementItemLinkObject
                                      INNER JOIN MovementItemLinkObjectDesc ON MovementItemLinkObjectDesc.Id = MovementItemLinkObject.DescId
                                      LEFT JOIN Object ON Object.Id = MovementItemLinkObject.ObjectId
                                 WHERE MovementItemLinkObject.MovementItemId = inMovementItemId
                                   AND inIsErased IS NULL
                                 )

 , tmpMovementItemString AS (SELECT '<Field FieldName = "' || zfStrToXmlStr(MovementItemStringDesc.ItemName) || '" FieldValue = "' || zfStrToXmlText(COALESCE (MovementItemString.ValueData, 'NULL')) || '"/>' AS FieldXML
                                  , 5 AS GroupId
                                  , MovementItemString.DescId
                             FROM MovementItemString
                                  INNER JOIN MovementItemStringDesc ON MovementItemStringDesc.Id = MovementItemString.DescId
                             WHERE MovementItemString.MovementItemId = inMovementItemId
                               AND inIsErased IS NULL
                             )

 , tmpMovementItemBoolean AS (SELECT '<Field FieldName = "' || zfStrToXmlStr(MovementItemBooleanDesc.ItemName) || '" FieldValue = "' || COALESCE (MovementItemBoolean.ValueData :: TVarChar, 'NULL') || '"/>' AS FieldXML 
                                   , 6 AS GroupId
                                   , MovementItemBoolean.DescId
                              FROM MovementItemBoolean
                                   INNER JOIN MovementItemBooleanDesc ON MovementItemBooleanDesc.Id = MovementItemBoolean.DescId
                              WHERE MovementItemBoolean.MovementItemId = inMovementItemId
                                AND inIsErased IS NULL
                              )
           
           
           
  SELECT '<XML>' || STRING_AGG (D.FieldXML, '') || '</XML>' INTO vbProtocolXML
  FROM
   (SELECT D.FieldXML
    FROM
        (SELECT tmp.FieldXML :: Text
              , tmp.GroupId
              , tmp.DescId
         FROM tmpMovementItem AS tmp
        UNION
         SELECT tmp.FieldXML :: Text
              , tmp.GroupId
              , tmp.DescId
         FROM tmpMovementItemFloat AS tmp
        UNION
         SELECT tmp.FieldXML :: Text
              , tmp.GroupId
              , tmp.DescId
         FROM tmpMovementItemDate AS tmp
        UNION
         SELECT tmp.FieldXML :: Text
              , tmp.GroupId
              , tmp.DescId
         FROM tmpMovementItemLinkObject AS tmp
        UNION
         SELECT tmp.FieldXML :: Text
              , tmp.GroupId
              , tmp.DescId
         FROM tmpMovementItemString AS tmp
        UNION
         SELECT tmp.FieldXML :: Text
              , tmp.GroupId
              , tmp.DescId
         FROM tmpMovementItemBoolean AS tmp
        ) AS D
    ORDER BY D.GroupId, D.DescId
   ) AS D
  ;

  -- Сохранили
  INSERT INTO MovementItemProtocol (MovementItemId, OperDate, UserId, ProtocolData, isInsert)
                            VALUES (inMovementItemId, current_timestamp, inUserId, vbProtocolXML, inIsInsert);

END;           
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 10.07.18                                                                      *  add zfStrToXmlText
 30.04.18         * запросы через WITH
 09.02.15                         * add zfStrToXmlStr
 09.10.14                                        * add MovementItem.isErased
 10.05.14                                        * add ORDER BY
 07.05.14                                        *
*/