-- DROP FUNCTION lpInsert_ObjectProtocol (IN inObjectId Integer, IN inUserId Integer);

DROP FUNCTION IF EXISTS lpInsert_ObjectHistoryProtocol (Integer, Integer, Boolean, Boolean);

CREATE OR REPLACE FUNCTION lpInsert_ObjectHistoryProtocol(
    IN inObjectId   Integer, 
    IN inUserId     Integer,
    IN inStartDate  TDateTime,
    IN inEndDate    TDateTime,
    IN inPrice      TFloat,
    IN inIsUpdate   Boolean DEFAULT NULL, -- �������
    IN inIsErased   Boolean DEFAULT NULL  -- �������, ���� �� ������ ����� � �������� ��-�� �� �������
)
RETURNS VOID
AS
$BODY$
   DECLARE ProtocolXML TBlob;
BEGIN

-- !!!��������-����.
 RETURN;


     -- �������������� XML ��� "������������" ���������
       WITH
       tmpObject AS (SELECT '<Field FieldName = "��������� ����" FieldValue = "' || COALESCE (DATE (inStartDate) :: TVarChar, 'NULL') || '"/>'
                         || '<Field FieldName = "�������� ����" FieldValue = "' || COALESCE (DATE (inEndDate) :: TVarChar, 'NULL') || '"/>'
                         || '<Field FieldName = "����" FieldValue = "' || inPrice || '"/>' AS FieldXML
                          , 1 AS GroupId
                          , Object.DescId
                     FROM Object
                     WHERE Object.Id = inObjectId 
                    )
/*     , tmpObjectFloat AS (SELECT '<Field FieldName = "' || zfStrToXmlStr(ObjectFloatDesc.ItemName) || '" FieldValue = "' || COALESCE (ObjectFloat.ValueData :: TVarChar, 'NULL') || '"/>' AS FieldXML 
                               , 2 AS GroupId
                               , ObjectFloat.DescId
                          FROM ObjectFloat
                               JOIN ObjectFloatDesc ON ObjectFloatDesc.Id = ObjectFloat.DescId
                          WHERE ObjectFloat.ObjectId = inObjectId
                            AND inIsErased IS NULL
                          )

     , tmpObjectDate AS (SELECT '<Field FieldName = "' || zfStrToXmlStr(ObjectDateDesc.ItemName) || '" FieldValue = "' || COALESCE (DATE (ObjectDate.ValueData) :: TVarChar, 'NULL') || '"/>' AS FieldXML 
                              , 3 AS GroupId
                              , ObjectDate.DescId
                         FROM ObjectDate
                              JOIN ObjectDateDesc ON ObjectDateDesc.Id = ObjectDate.DescId
                         WHERE ObjectDate.ObjectId = inObjectId
                           AND inIsErased IS NULL
                        )
     , tmpObjectLink AS (SELECT '<Field FieldName = "' || zfStrToXmlStr(ObjectLinkDesc.ItemName) || '" FieldValue = "' || zfStrToXmlStr(COALESCE (Object.ValueData, 'NULL')) || '"/>' AS FieldXML 
                              , 4 AS GroupId
                              , ObjectLink.DescId
                         FROM ObjectLink
                              JOIN Object ON Object.Id = ObjectLink.ChildObjectId
                              JOIN ObjectLinkDesc ON ObjectLinkDesc.Id = ObjectLink.DescId
                         WHERE ObjectLink.ObjectId = inObjectId
                           AND inIsErased IS NULL
                     )

     , tmpObjectString AS (SELECT '<Field FieldName = "' || zfStrToXmlStr(ObjectStringDesc.ItemName) || '" FieldValue = "' || zfStrToXmlStr(COALESCE (ObjectString.ValueData, 'NULL')) || '"/>' AS FieldXML 
                                , 5 AS GroupId
                                , ObjectString.DescId
                           FROM ObjectString
                                JOIN ObjectStringDesc ON ObjectStringDesc.Id = ObjectString.DescId
                           WHERE ObjectString.ObjectId = inObjectId
                             AND inIsErased IS NULL
                          )

     , tmpObjectBoolean AS (SELECT '<Field FieldName = "' || zfStrToXmlStr(ObjectBooleanDesc.ItemName) || '" FieldValue = "' || COALESCE (ObjectBoolean.ValueData :: TVarChar, 'NULL') || '"/>' AS FieldXML 
                                 , 6 AS GroupId
                                 , ObjectBoolean.DescId
                            FROM ObjectBoolean
                                 JOIN ObjectBooleanDesc ON ObjectBooleanDesc.Id = ObjectBoolean.DescId
                            WHERE ObjectBoolean.ObjectId = inObjectId
                              AND inIsErased IS NULL
                           )
*/
     --  
     SELECT '<XML>' || STRING_AGG (D.FieldXML, '') || '</XML>' INTO ProtocolXML
     FROM
          (SELECT D.FieldXML
           FROM 
               (SELECT tmp.FieldXML
                     , tmp.GroupId
                     , tmp.DescId
                FROM tmpObject AS tmp
                -- WHERE tmp.Id = inObjectId 
               /*UNION
                SELECT tmp.FieldXML
                     , tmp.GroupId
                     , tmp.DescId
                FROM tmpObjectFloat AS tmp
               UNION
                SELECT tmp.FieldXML
                     , tmp.GroupId
                     , tmp.DescId
                FROM tmpObjectDate AS tmp
               UNION
                SELECT tmp.FieldXML
                     , tmp.GroupId
                     , tmp.DescId
                FROM tmpObjectLink AS tmp
               UNION
                SELECT tmp.FieldXML
                     , tmp.GroupId
                     , tmp.DescId
                FROM tmpObjectString AS tmp
               UNION
                SELECT tmp.FieldXML
                     , tmp.GroupId
                     , tmp.DescId
                FROM tmpObjectBoolean AS tmp
                */
                ) AS D
           ORDER BY D.GroupId, D.DescId
          ) AS D
         ;

     -- ��������� "�����������" ��������
     INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
          SELECT inObjectId, CURRENT_TIMESTAMP, inUserId, ProtocolXML, CASE WHEN inIsErased = TRUE THEN NULL ELSE COALESCE ((SELECT 1 FROM ObjectProtocol WHERE ObjectId = inObjectId LIMIT 1), 0) = 0 END;


     -- !!!�������� ����� �������� ����������� �������!!!
     IF inIsUpdate = TRUE AND COALESCE (inIsErased, FALSE) = FALSE
     THEN
         -- ��������� �������� <���� �������������>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), inObjectId, CURRENT_TIMESTAMP);
         -- ��������� �������� <������������ (�������������)>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), inObjectId, inUserId);
     ELSE
         IF inIsUpdate = FALSE AND COALESCE (inIsErased, FALSE) = FALSE
         THEN
             -- ��������� �������� <���� ��������>
             PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), inObjectId, CURRENT_TIMESTAMP);
             -- ��������� �������� <������������ (��������)>
             PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), inObjectId, inUserId);
         END IF;
     END IF;
  
END;           
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION lpInsert_ObjectHistoryProtocol (Integer, Integer, Boolean, Boolean) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 30.04.18         * ������� ����� WITH
 20.08.15         * 

*/
