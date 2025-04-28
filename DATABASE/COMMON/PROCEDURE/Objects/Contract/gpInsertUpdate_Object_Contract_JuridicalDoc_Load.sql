-- Function: gpInsertUpdate_Object_Contract_JuridicalDoc_Load (Integer, Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract_JuridicalDoc_Load (TVarChar, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Contract_JuridicalDoc_Load(
    IN inJuridicalName              TVarChar   , 
    IN inContractCode               Integer   , -- 
    IN inContractName               TVarChar   , -- 
    IN inPaidKindName               TVarChar   , -- 
    IN inJuridicalDocName           TVarChar   , -- 
    IN inJuridicalDoc_NextName      TVarChar   , --
    IN inJuridicalDoc_NextDate      TDateTime   ,  
    IN inSession                    TVarChar     -- ������ ������������
)
RETURNS VOID AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbPaidKindId Integer;
    DECLARE vbContractId Integer;
    DECLARE vbJuridicalId Integer;
    DECLARE vbJuridicalDocId Integer;
    DECLARE vbJuridicalDoc_NextId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem());

    -- ��������
    IF COALESCE(inContractCode, 0) = 0
    THEN
        RETURN;
    END IF;
    -- ��������
    IF COALESCE(TRIM (inJuridicalName), '') = ''
    THEN
        RETURN;
    END IF;

    -- ��������
    IF COALESCE(inPaidKindName, '') = ''
    THEN
        RAISE EXCEPTION '������.�������� ����� ������ <%> �� ���������� ��� <%> ������� <%>.', inJuridicalName, inContractName;
    END IF;

    IF COALESCE (TRIM (inPaidKindName), '') <> ''
    THEN 
         -- ����� ��
         vbPaidKindId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_PaidKind() AND Object.ValueData ILIKE inPaidKindName);
         IF COALESCE (vbPaidKindId, 0) = 0
         THEN
             RAISE EXCEPTION '������.�������� ����� ������ <%> �� �������.', inPaidKindName;
         END IF;
    END IF;

    
    IF COALESCE (TRIM (inJuridicalName), '') <> ''
    THEN 
         -- ����� ��.����
         vbJuridicalId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Juridical() AND Object.isErased = FALSE AND TRIM (Object.ValueData) ILIKE TRIM (inJuridicalName) LIMIT 1);
         IF COALESCE (vbJuridicalId, 0) = 0
         THEN
             RAISE EXCEPTION '������.�������� ����������� ���� <%> �� �������.', inJuridicalName;
         END IF;
    END IF;

    IF COALESCE (inContractCode, 0) <> 0
    THEN 
         -- ����� �������
         vbContractId:= (SELECT tmp_View.ContractId
                         FROM Object_Contract_View AS tmp_View
                         WHERE tmp_View.JuridicalId = vbJuridicalId
                           AND tmp_View.PaidKindId  = vbPaidKindId
                           AND tmp_View.ContractCode = inContractCode
                         );
         IF COALESCE (vbContractId, 0) = 0
         THEN
             RAISE EXCEPTION '������.������� <(%) %> �� ������ %��� <%> + <%>.'
                           , inContractCode, inContractName
                           , CHR (13)
                           , lfGet_Object_ValueData_sh (vbJuridicalId), lfGet_Object_ValueData_sh (vbPaidKindId)
                            ;
         END IF;
    END IF;

   -- ��������� ����� � <����������� ����(������ ���.)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_JuridicalDocument(), vbContractId, vbJuridicalDocId);
   -- ��������� ����� � <��. ���� �������(������ ���.)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_JuridicalDoc_Next(), vbContractId, vbJuridicalDoc_NextId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Contract_JuridicalDoc_Next(), vbContractId, inJuridicalDoc_NextDate ::TDateTime);

   -- �������� - ��� � ����� ������ �� �����
   IF vbUserId = 5 OR vbUserId = 9457
   THEN
       RAISE EXCEPTION '������.��� ���� - ��� � ����� ������ �� �����.';
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.04.25         *
*/

-- ����