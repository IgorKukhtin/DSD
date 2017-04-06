-- Function: gpInsertUpdateMobile_Object_Partner

DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Object_Partner (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, 
                                                             TFloat, TFloat, TVarChar, Integer, TVarChar, TVarChar, TVarChar, 
                                                             Integer, TVarChar, TVarChar, TVarChar, Integer,
                                                             Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Object_Partner (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, 
                                                             TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar,
                                                             Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Object_Partner (Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_Object_Partner (
 INOUT ioId               Integer  ,  -- ���� ������� <����������>
    IN inGUID             TVarChar ,  -- ���������� ���������� �������������
    IN inName             TVarChar ,  -- ������������ �����������
    IN inAddress          TVarChar ,  -- ����� ����� ��������
    IN inPrepareDayCount  TFloat   ,  -- �� ������� ���� ����������� �����
    IN inDocumentDayCount TFloat   ,  -- ����� ������� ���� ����������� �������������
    IN inJuridicalGUID    TVarChar ,  -- ����������� ���� (���������� ���������� �������������)
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbPersonalId Integer;
   DECLARE vbId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
      
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      IF COALESCE (inJuridicalGUID, '') = ''
      THEN
           RAISE EXCEPTION '������. �� ����� ���������� ���������� ������������� ��.����';
      END IF;

      -- ���� ��.���� �� �������� ����������� ����������� ��������������
      SELECT ObjectString_Juridical_GUID.ObjectId
      INTO vbJuridicalId
      FROM ObjectString AS ObjectString_Juridical_GUID
           JOIN Object AS Object_Juridical
                       ON Object_Juridical.Id = ObjectString_Juridical_GUID.ObjectId
                      AND Object_Juridical.DescId = zc_Object_Juridical()
      WHERE ObjectString_Juridical_GUID.DescId = zc_ObjectString_Juridical_GUID()
        AND ObjectString_Juridical_GUID.ValueData = inJuridicalGUID;

      -- �������� - ����� �� ��. ����
      IF COALESCE (vbJuridicalId, 0) = 0  
      THEN
           RAISE EXCEPTION '�� ����������� ����������� ����!';
      END IF;
   
      IF COALESCE (inGUID, '') = ''
      THEN
           RAISE EXCEPTION '������. �� ����� ���������� ���������� �������������';
      END IF;

      -- ����� �� �������� ������������� ��������� ������
      SELECT PersonalId INTO vbPersonalId FROM gpGetMobile_Object_Const (inSession);

      -- ���� ����������� �� �������� ����������� ����������� ��������������
      SELECT ObjectString_Partner_GUID.ObjectId
      INTO vbId
      FROM ObjectString AS ObjectString_Partner_GUID
           JOIN Object AS Object_Partner
                       ON Object_Partner.Id = ObjectString_Partner_GUID.ObjectId
                      AND Object_Partner.DescId = zc_Object_Partner()
      WHERE ObjectString_Partner_GUID.DescId = zc_ObjectString_Partner_GUID()
        AND ObjectString_Partner_GUID.ValueData = inGUID;

      vbId:= COALESCE (vbId, 0);

      -- �������� ������������ <������������>
      PERFORM lpCheckUnique_Object_ValueData(vbId, zc_Object_Partner(), inName);

      -- ������������ ������� ��������/�������������
      vbIsInsert:= (vbId = 0);

      -- ��������� <������>
      ioId := lpInsertUpdate_Object (vbId, zc_Object_Partner(), 0, inName);

      -- ��������� �������� <����� ����� ��������>
      PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Partner_Address(), ioId, inAddress);
      -- ��������� �������� <�� ������� ���� ����������� �����>
      PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Partner_PrepareDayCount(), ioId, CASE WHEN vbIsInsert AND COALESCE (inPrepareDayCount, 0) = 0 THEN 1 ELSE inPrepareDayCount END);
      -- ��������� �������� <����� ������� ���� ����������� �������������>
      PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Partner_DocumentDayCount(), ioId, inDocumentDayCount);
      -- ��������� ����� � <����������� ����>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_Juridical(), ioId, vbJuridicalId);
      -- ��������� ����� � <��������� (�������� �����)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_PersonalTrade(), ioId, vbPersonalId);
      -- ��������� �������� <���������� ���������� �������������>
      PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_GUID(), ioId, inGUID);

      -- ��������� ��������
      PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 05.04.17                                                         *
*/

-- ����
/* SELECT * FROM gpInsertUpdateMobile_Object_Partner (ioId               := 0
                                                    , inGUID             := '{FD0D2968-FE5A-49B8-AC9B-29E0FC741E91}'
                                                    , inName             := '���������� � ���. ����������'
                                                    , inAddress          := '�. �������, ��. �������������, 5'       -- ����� �������� �����
                                                    , inPrepareDayCount  := 1                                        -- �� ������� ���� ����������� �����
                                                    , inDocumentDayCount := 1                                        -- ����� ������� ���� ����������� �������������
                                                    , inJuridicalGUID    := '{CCCCEF83-D391-4CDB-A471-AF9DD07AC7D9}' -- ����������� ���� (���������� ���������� �������������)
                                                    , inSession          := zfCalc_UserAdmin()
                                                     )
*/
