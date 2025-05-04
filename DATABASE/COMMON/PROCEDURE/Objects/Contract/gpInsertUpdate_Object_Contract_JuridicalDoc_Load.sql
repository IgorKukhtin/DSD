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
         -- �������� �� ��������� �������� 
         IF 1 < (SELECT COUNT (*) FROM Object
                 WHERE Object.DescId = zc_Object_Juridical() AND Object.isErased = FALSE
                   AND zfCalc_Text_replace (TRIM (Object.ValueData), CHR (39), '`' ) = zfCalc_Text_replace (TRIM (inJuridicalName), CHR (39), '`' )
                )
         
         THEN
             -- �������� - �����
             -- RETURN;
             --
             RAISE EXCEPTION '������.�������� ����������� ����(1) <%> ������� ����� ������ ����.', inJuridicalName;
         END IF;
          
         -- �����-1 ��.����
         vbJuridicalId := (SELECT Object.Id FROM Object
                           WHERE Object.DescId = zc_Object_Juridical() AND Object.isErased = FALSE
                             AND zfCalc_Text_replace (TRIM (Object.ValueData), CHR (39), '`' ) = zfCalc_Text_replace (TRIM (inJuridicalName), CHR (39), '`' )
                          );

         -- ���� �� ����� - ����� 1
         IF COALESCE (vbJuridicalId, 0) = 0
         THEN
             -- �������� �� ��������� �������� 
             IF 1 < (SELECT COUNT (*) FROM Object
                     WHERE Object.DescId = zc_Object_Juridical() AND Object.isErased = FALSE
                       AND zfCalc_Text_replace (TRIM (Object.ValueData), CHR (39), '`' ) ILIKE zfCalc_Text_replace (TRIM (inJuridicalName), CHR (39), '`' )
                    )
             
             THEN 
                 -- �������� - �����
                 -- RETURN;
                 --
                 RAISE EXCEPTION '������.�������� ����������� ����(1) <%> ������� ����� ������ ����.', inJuridicalName;
             END IF;
         
            -- �����-2 ��.����
            vbJuridicalId := (SELECT Object.Id FROM Object
                              WHERE Object.DescId = zc_Object_Juridical() AND Object.isErased = FALSE
                                AND zfCalc_Text_replace (TRIM (Object.ValueData), CHR (39), '`' ) ILIKE zfCalc_Text_replace (TRIM (inJuridicalName), CHR (39), '`' )
                             );
         END IF;

         -- ���� �� ����� - ����� 2
         IF COALESCE (vbJuridicalId, 0) = 0
         THEN
             -- �������� �� ��������� �������� 
             IF 1 < (SELECT COUNT (*) FROM Object
                     WHERE Object.DescId = zc_Object_Juridical() -- AND Object.isErased = FALSE
                       AND zfCalc_Text_replace (TRIM (Object.ValueData), CHR (39), '`' ) = zfCalc_Text_replace (TRIM (inJuridicalName), CHR (39), '`' )
                    )
             
             THEN 
                 -- �������� - �����
                 -- RETURN;
                 --
                 RAISE EXCEPTION '������.�������� ����������� ����(1) <%> ������� ����� ������ ����.', inJuridicalName;
             END IF;

             -- �����-3 ��.����
             vbJuridicalId := (SELECT Object.Id FROM Object
                               WHERE Object.DescId = zc_Object_Juridical() -- AND Object.isErased = FALSE
                                 AND zfCalc_Text_replace (TRIM (Object.ValueData), CHR (39), '`' ) = zfCalc_Text_replace (TRIM (inJuridicalName), CHR (39), '`' )
                              );
         END IF;

         -- ���� �� ����� - ����� 3
         IF COALESCE (vbJuridicalId, 0) = 0
         THEN
             -- �������� �� ��������� �������� 
             IF 1 < (SELECT COUNT (*) FROM Object
                     WHERE Object.DescId = zc_Object_Juridical() -- AND Object.isErased = FALSE
                       AND zfCalc_Text_replace (TRIM (Object.ValueData), CHR (39), '`' ) ILIKE zfCalc_Text_replace (TRIM (inJuridicalName), CHR (39), '`' )
                    )
             
             THEN 
                 -- �������� - �����
                 -- RETURN;
                 --
                 RAISE EXCEPTION '������.�������� ����������� ����(1) <%> ������� ����� ������ ����.', inJuridicalName;
             END IF;

             -- �����-4 ��.����
             vbJuridicalId := (SELECT Object.Id FROM Object
                               WHERE Object.DescId = zc_Object_Juridical() -- AND Object.isErased = FALSE
                                 AND zfCalc_Text_replace (TRIM (Object.ValueData), CHR (39), '`' ) ILIKE zfCalc_Text_replace (TRIM (inJuridicalName), CHR (39), '`' )
                              );
         END IF;

         -- �������� - ���� �� ����� - ����� 4
         IF COALESCE (vbJuridicalId, 0) = 0
         THEN
             RAISE EXCEPTION '������.�������� ����������� ����(1) <%> �� �������.', inJuridicalName;
         END IF;

    END IF;
    
    
    IF COALESCE (TRIM (inJuridicalDocName), '') <> ''
    THEN 
         IF 1 < (SELECT COUNT (*) FROM Object
                 WHERE Object.DescId = zc_Object_Juridical() AND Object.isErased = FALSE
                   AND zfCalc_Text_replace (TRIM (Object.ValueData), CHR (39), '`' ) ILIKE zfCalc_Text_replace (TRIM (inJuridicalDocName), CHR (39), '`' )
                )
         THEN 
             RAISE EXCEPTION '������.�������� ����������� ����(2) <%> ������� ����� ������ ����.', inJuridicalDocName;
         END IF;

         -- ����� ��.����
         vbJuridicalDocId := (SELECT Object.Id FROM Object
                              WHERE Object.DescId = zc_Object_Juridical() AND Object.isErased = FALSE
                                AND zfCalc_Text_replace (TRIM (Object.ValueData), CHR (39), '`' ) ILIKE zfCalc_Text_replace (TRIM (inJuridicalDocName), CHR (39), '`' )
                             );

         -- ��������
         IF COALESCE (vbJuridicalDocId, 0) = 0
         THEN
             RAISE EXCEPTION '������.�������� ����������� ����(2) <%> �� �������.', inJuridicalDocName;
         END IF;
    END IF;


    IF COALESCE (TRIM (inJuridicalDoc_NextName), '') <> ''
    THEN 
         IF 1 < (SELECT COUNT (*) FROM Object
                 WHERE Object.DescId = zc_Object_Juridical() AND Object.isErased = FALSE
                   AND zfCalc_Text_replace (TRIM (Object.ValueData), CHR (39), '`' ) ILIKE zfCalc_Text_replace (TRIM (inJuridicalDoc_NextName), CHR (39), '`' )
                 )
         THEN 
             RAISE EXCEPTION '������.�������� ����������� ����(3) <%> ������� ����� ������ ����.', inJuridicalDoc_NextName;
         END IF;

         -- ����� ��.����
         vbJuridicalDoc_NextId := (SELECT Object.Id FROM Object
                                   WHERE Object.DescId = zc_Object_Juridical() AND Object.isErased = FALSE
                                     AND zfCalc_Text_replace (TRIM (Object.ValueData), CHR (39), '`' ) ILIKE zfCalc_Text_replace (TRIM (inJuridicalDoc_NextName), CHR (39), '`' )
                                  );

         -- ��������
         IF COALESCE (vbJuridicalDoc_NextId, 0) = 0
         THEN
             RAISE EXCEPTION '������.�������� ����������� ����(3) <%> �� �������.', inJuridicalDoc_NextName;
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

         -- ��������
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
   -- ��������� �������� <���� ��� ��. ���� �������(������ ���.)>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Contract_JuridicalDoc_Next(), vbContractId, inJuridicalDoc_NextDate ::TDateTime);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inObjectId:= vbContractId, inUserId:= vbUserId, inIsUpdate:= TRUE, inIsErased:= NULL);

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
