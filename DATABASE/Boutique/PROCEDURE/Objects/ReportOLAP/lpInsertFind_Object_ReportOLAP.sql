-- Function: lpInsertFind_Object_ReportOLAP (Integer, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertFind_Object_ReportOLAP (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_ReportOLAP(
    IN inCode         Integer,       -- 
    IN inObjectId     Integer,       -- 
    IN inUserId       Integer        --
)
RETURNS Integer
AS
$BODY$
   DECLARE vbId Integer;
BEGIN
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inCode, 0) <= 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <inCode>.';
     END IF;
     IF COALESCE (inCode, 0) NOT IN (zc_ReportOLAP_Brand(), zc_ReportOLAP_Goods(), zc_ReportOLAP_Partion()) THEN
        RAISE EXCEPTION '������.������ ����� �������� <inCode> = <%>.', inCode;
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inObjectId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <inObjectId>.';
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inUserId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <inUserId>.';
     END IF;


     -- ������� �� ��-���
     vbId:= (SELECT Object.Id
             FROM Object
                  INNER JOIN ObjectLink AS ObjectLink_Object
                                        ON ObjectLink_Object.ObjectId      = Object.Id
                                       AND ObjectLink_Object.DescId        = zc_ObjectLink_ReportOLAP_Object()
                                       AND ObjectLink_Object.ChildObjectId = inObjectId
                  INNER JOIN ObjectLink AS ObjectLink_User
                                        ON ObjectLink_User.ObjectId      = Object.Id
                                       AND ObjectLink_User.DescId        = zc_ObjectLink_ReportOLAP_User()
                                       AND ObjectLink_User.ChildObjectId = inUserId
             WHERE Object.DescId     = zc_Object_ReportOLAP()
               AND Object.ObjectCode = inCode
            );


     -- ���� �� �����
     IF COALESCE (vbId, 0) = 0
     THEN
         -- ��������� <������>
         vbId := lpInsertUpdate_Object (vbId, zc_Object_ReportOLAP(), inCode, '');

         -- ��������� ����� � <Object>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReportOLAP_Object(), vbId, inObjectId);

         -- ��������� ����� � <User>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReportOLAP_User(), vbId, inUserId);

     END IF; -- if COALESCE (vbId, 0) = 0


     -- ���������� ��������
     RETURN (vbId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
24.04.17                                         *
*/

-- ����
--