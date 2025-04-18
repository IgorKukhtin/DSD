-- DROP FUNCTION lpInsert_ObjectProtocol (IN inObjectId Integer, IN inUserId Integer);

DROP FUNCTION IF EXISTS lpInsert_ObjectProtocol (Integer, Integer);
DROP FUNCTION IF EXISTS lpInsert_ObjectProtocol (Integer, Integer, Boolean);
DROP FUNCTION IF EXISTS lpInsert_ObjectProtocol (Integer, Integer, Boolean, Boolean);

CREATE OR REPLACE FUNCTION lpInsert_ObjectProtocol(
    IN inObjectId Integer, 
    IN inUserId   Integer,
    IN inIsUpdate Boolean DEFAULT NULL, -- �������
    IN inIsErased Boolean DEFAULT NULL  -- �������, ���� �� ������ ����� � �������� ��-�� �� �������
)
RETURNS VOID
AS
$BODY$
   DECLARE ProtocolXML TBlob;
BEGIN

       -- -- !!!��������-����. ��� ���� ����� ���. ���.���
       /*IF (SELECT Object.DescId FROM Object WHERE Object.Id = inObjectId) <> zc_Object_Member()
       THEN
           -- !!!��������-����.
           RETURN;
       END IF;*/


       -- �������������� XML ��� "������������" ���������
       WITH 
       tmpObject AS (SELECT '<Field FieldName = "��������" FieldValue = "' || zfStrToXmlStr(Object.ValueData) || '"/>'
                         || '<Field FieldName = "���" FieldValue = "' || Object.ObjectCode || '"/>'
                         || '<Field FieldName = "������" FieldValue = "' || CASE WHEN Object.AccessKeyId IS NULL THEN 'NULL' ELSE Object.AccessKeyId :: TBlob END || '"/>'
                         || '<Field FieldName = "������" FieldValue = "' || Object.isErased || '"/>' AS FieldXML
                          , 1 AS GroupId
                          , Object.DescId
                     FROM Object
                     WHERE Object.Id = inObjectId
                        )
  
     , tmpObjectFloat AS (SELECT '<Field FieldName = "' || zfStrToXmlStr(ObjectFloatDesc.ItemName) || '" FieldValue = "' || COALESCE (ObjectFloat.ValueData :: TBlob, 'NULL') || '"/>' AS FieldXML 
                               , 2 AS GroupId
                               , ObjectFloat.DescId
                          FROM ObjectFloat
                               JOIN ObjectFloatDesc ON ObjectFloatDesc.Id = ObjectFloat.DescId
                          WHERE ObjectFloat.ObjectId = inObjectId
                            AND inIsErased IS NULL
                            AND ObjectFloat.DescId <> zc_ObjectFloat_Member_ScalePSW()
                           )
  
     , tmpObjectDate AS (SELECT '<Field FieldName = "' || zfStrToXmlStr (ObjectDateDesc.ItemName)
                             || '" FieldValue = "' || COALESCE (CASE WHEN ObjectDate.DescId IN (zc_ObjectDate_ImportSettings_StartTime()
                                                                                              , zc_ObjectDate_ImportSettings_EndTime()
                                                                                              , zc_ObjectDate_User_UpdateMobileFrom()
                                                                                              , zc_ObjectDate_User_UpdateMobileTo()
                                                                                              , zc_ObjectDate_Protocol_Insert()
                                                                                              , zc_ObjectDate_Protocol_Update()
                                                                                               )
                                                                          THEN zfConvert_DateTimeShortToString (ObjectDate.ValueData)
                                                                     ELSE zfConvert_DateToString (ObjectDate.ValueData)
                                                                END, 'NULL') || '"/>' :: TBlob AS FieldXML 
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
                             AND ObjectString.DescId <> zc_ObjectString_Goods_Analog()
                          )
  
     , tmpObjectBoolean AS (SELECT '<Field FieldName = "' || zfStrToXmlStr(ObjectBooleanDesc.ItemName) || '" FieldValue = "' || COALESCE (ObjectBoolean.ValueData :: TBlob, 'NULL') || '"/>' AS FieldXML 
                                 , 6 AS GroupId
                                 , ObjectBoolean.DescId
                            FROM ObjectBoolean
                                 JOIN ObjectBooleanDesc ON ObjectBooleanDesc.Id = ObjectBoolean.DescId
                            WHERE ObjectBoolean.ObjectId = inObjectId
                              AND inIsErased IS NULL
                            )

     --
     SELECT '<XML>' || STRING_AGG (D.FieldXML, '') || '</XML>' INTO ProtocolXML
     FROM
          (SELECT D.FieldXML
           FROM 
               (SELECT tmp.FieldXML
                     , tmp.GroupId
                     , tmp.DescId
                FROM tmpObject AS tmp
               UNION
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
               ) AS D
           ORDER BY D.GroupId, D.DescId
          ) AS D
         ;

     -- ��������� "�����������" ��������
     INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
          SELECT inObjectId, CURRENT_TIMESTAMP, inUserId, ProtocolXML, COALESCE ((SELECT 1 FROM ObjectProtocol WHERE ObjectId = inObjectId LIMIT 1), 0) = 0;


     -- !!!�������� ����� �������� ����������� �������!!!
     IF inIsUpdate = TRUE
     THEN
         -- ��������� �������� <���� �������������>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), inObjectId, CURRENT_TIMESTAMP);
         -- ��������� �������� <������������ (�������������)>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), inObjectId, inUserId);
     ELSE
         IF inIsUpdate = FALSE
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
ALTER FUNCTION lpInsert_ObjectProtocol (Integer, Integer, Boolean, Boolean) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 30.04.18         * ������� ����� WITH
 09.02.15                         * add zfStrToXmlStr
 14.05.14                                        * add ObjectBoolean
 24.02.14                                        *
*/
/*
insert into ObjectDate (DescId, ObjectId, ValueData) 
select zc_ObjectDate_Protocol_Insert(), Object.Id, ObjectProtocol.OperDate
from Object join (select ObjectId, min(Id) as minId, max(Id) as maxId, min (OperDate) as minOperDate,  max (OperDate) as maxOperDate from ObjectProtocol group by ObjectId
                 ) as ObjecProtocol_find on ObjecProtocol_find.ObjectId = Object.Id
            join ObjectProtocol on ObjectProtocol.Id = ObjecProtocol_find.minId
            left join ObjectDate on ObjectDate.DescId = zc_ObjectDate_Protocol_Insert() and ObjectDate.ObjectId = Object.Id
where Object.DescId in (zc_Object_Contract(), zc_Object_ContractCondition())
     and ObjectDate.ObjectId is null;

insert into ObjectDate (DescId, ObjectId, ValueData) 
select zc_ObjectDate_Protocol_Update(), Object.Id, ObjectProtocol.OperDate
from Object join (select ObjectId, min(Id) as minId, max(Id) as maxId, min (OperDate) as minOperDate,  max (OperDate) as maxOperDate from ObjectProtocol group by ObjectId
                 ) as ObjecProtocol_find on ObjecProtocol_find.ObjectId = Object.Id and ObjecProtocol_find.minId <> ObjecProtocol_find.maxId
            join ObjectProtocol on ObjectProtocol.Id = ObjecProtocol_find.maxId
            left join ObjectDate on ObjectDate.DescId = zc_ObjectDate_Protocol_Update() and ObjectDate.ObjectId = Object.Id
where Object.DescId in (zc_Object_Contract(), zc_Object_ContractCondition())
     and ObjectDate.ObjectId is null;




insert into ObjectLink (DescId, ObjectId, ChildObjectId) 
select zc_ObjectLink_Protocol_Insert(), Object.Id, ObjectProtocol.UserId
from Object join (select ObjectId, min(Id) as minId, max(Id) as maxId, min (OperDate) as minOperDate,  max (OperDate) as maxOperDate from ObjectProtocol group by ObjectId
                 ) as ObjecProtocol_find on ObjecProtocol_find.ObjectId = Object.Id
            join ObjectProtocol on ObjectProtocol.Id = ObjecProtocol_find.minId
            left join ObjectLink on ObjectLink.DescId = zc_ObjectLink_Protocol_Insert() and ObjectLink.ObjectId = Object.Id
where Object.DescId in (zc_Object_Contract(), zc_Object_ContractCondition())
     and ObjectLink.ObjectId is null;

insert into ObjectLink (DescId, ObjectId, ChildObjectId) 
select zc_ObjectLink_Protocol_Update(), Object.Id, ObjectProtocol.UserId
from Object join (select ObjectId, min(Id) as minId, max(Id) as maxId, min (OperDate) as minOperDate,  max (OperDate) as maxOperDate from ObjectProtocol group by ObjectId
                 ) as ObjecProtocol_find on ObjecProtocol_find.ObjectId = Object.Id and ObjecProtocol_find.minId <> ObjecProtocol_find.maxId
            join ObjectProtocol on ObjectProtocol.Id = ObjecProtocol_find.maxId
            left join ObjectLink on ObjectLink.DescId = zc_ObjectLink_Protocol_Update() and ObjectLink.ObjectId = Object.Id
where Object.DescId in (zc_Object_Contract(), zc_Object_ContractCondition())
     and ObjectLink.ObjectId is null;
*/