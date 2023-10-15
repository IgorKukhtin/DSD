-- DROP FUNCTION lpInsert_LoginProtocol;

DROP FUNCTION IF EXISTS lpInsert_LoginProtocol (TVarChar, TVarChar, Integer, Boolean, Boolean, Boolean);

CREATE OR REPLACE FUNCTION lpInsert_LoginProtocol(
    IN inUserLogin    TVarChar,
    IN inIP           TVarChar,
    IN inUserId       Integer,
    IN inIsConnect    Boolean,
    IN inIsProcess    Boolean,
    IN inIsExit       Boolean
)
RETURNS VOID
AS
$BODY$
   DECLARE vbId_connect  Integer;
   DECLARE vbId_process  Integer;
BEGIN

     -- !!!��� ������� ��������� ��� ����!!!
     IF zc_isReplica_Slave() = TRUE
     THEN
         -- !!!���������!!!
         RETURN;
     END IF;
 

     -- ���� ����������� - ����� ������ �� ������
     IF inIsConnect = TRUE
     THEN
         -- ���������
         INSERT INTO LoginProtocol (UserId, OperDate, ProtocolData)
            SELECT inUserId, CURRENT_TIMESTAMP
                , '<XML>'
               || '<Field FieldName = "IP" FieldValue = "' || zfStrToXmlStr (inIP) || '"/>'
               || '<Field FieldName = "�����" FieldValue = "' || zfStrToXmlStr (inUserLogin) || '"/>'
               || '<Field FieldName = "��������" FieldValue = "�����������"/>'
               || '</XML>'
                ;
     ELSE
         RETURN;
         -- ������ ��� ���� � ��������� �����������
         SELECT MAX (CASE WHEN POSITION (LOWER ('�����������') IN LOWER (ProtocolData)) > 0 THEN Id ELSE 0 END) AS Id_connect
              , MAX (CASE WHEN POSITION (LOWER ('��������')    IN LOWER (ProtocolData)) > 0 THEN Id ELSE 0 END) AS Id_process
                INTO vbId_connect, vbId_process
         FROM LoginProtocol
         WHERE OperDate >= CURRENT_DATE AND OperDate < CURRENT_DATE + INTERVAL '1 DAY'
           AND UserId = inUserId;

         -- ���� ������������ �� �������, �� ��������� ���� - ������ ��� "�����������" ����
         IF COALESCE (vbId_connect, 0) = 0
         THEN
             -- ���������
             INSERT INTO LoginProtocol (UserId, OperDate, ProtocolData)
                SELECT inUserId, CURRENT_TIMESTAMP
                     , '<XML>'
                    || '<Field FieldName = "IP" FieldValue = "' || zfStrToXmlStr (inIP) || '"/>'
                    || '<Field FieldName = "�����" FieldValue = "' || zfStrToXmlStr (inUserLogin) || '"/>'
                    || '<Field FieldName = "��������" FieldValue = "����������� (�����������)"/>'
                    || '</XML>'
                   ;

         END IF;


         -- ���� �� ���� ������ "��������"
         IF COALESCE (vbId_process, 0) = 0
         THEN
             -- ������� � ��������� ��� ������������ - "��������" ��� "�����"
             INSERT INTO LoginProtocol (UserId, OperDate, ProtocolData)
                SELECT inUserId, CURRENT_TIMESTAMP
                     , '<XML>'
                    || '<Field FieldName = "IP" FieldValue = "' || zfStrToXmlStr (inIP) || '"/>'
                    || '<Field FieldName = "�����" FieldValue = "' || zfStrToXmlStr (inUserLogin) || '"/>'
                    || '<Field FieldName = "��������" FieldValue = "' || CASE WHEN inIsProcess = TRUE THEN '��������' ELSE '�����' END || '"/>'
                    || '</XML>'
                   ;
         ELSE
             -- �������� � ��������� ��� ������������ - "��������" ��� "�����"
             UPDATE LoginProtocol
                    SET OperDate     = CURRENT_TIMESTAMP
                      , ProtocolData = 
                           '<XML>'
                        || '<Field FieldName = "IP" FieldValue = "' || zfStrToXmlStr (inIP) || '"/>'
                        || '<Field FieldName = "�����" FieldValue = "' || zfStrToXmlStr (inUserLogin) || '"/>'
                        || '<Field FieldName = "��������" FieldValue = "' || CASE WHEN inIsProcess = TRUE THEN '��������' ELSE '�����' END || '"/>'
                        || '</XML>'
             WHERE Id = vbId_process;

         END IF;

         
         -- ��������
         IF COALESCE (inIsProcess, FALSE) <> TRUE AND COALESCE (inIsExit, FALSE) <> TRUE
         THEN
             RAISE EXCEPTION '������.inIsConnect - <%> + inIsProcess - <%> + inIsExit - <%>', inIsConnect, inIsProcess, inIsExit;
         END IF;

    END IF;
   
END;           
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsert_LoginProtocol (TVarChar, TVarChar, Integer, Boolean, Boolean, Boolean) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 07.11.16                                        *
*/
