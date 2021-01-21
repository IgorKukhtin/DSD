-- Function: gpInsertUpdate_Object_ReportBonus()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReportBonus (Integer, TDateTime, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReportBonus (Integer, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReportBonus(
 INOUT ioId                  Integer   , --
    IN inMonth               TDateTime , --
    IN inJuridicalId         Integer   , --
    IN inPartnerId           Integer   , --
    IN inContractId_master   Integer   , --
    IN inContractId_child    Integer   , --
    IN inIsSend              Boolean   , -- �������
   OUT outIsSend             Boolean   , -- �������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    outIsSend := inIsSend;


     -- ��������
     IF COALESCE (inContractId_master, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ���������� ������� <���������>';
     END IF;
     -- ��������
     IF COALESCE (inContractId_child, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ���������� ������� <����>';
     END IF;


    -- ������� �����, ����� ��� ���� �������
    IF COALESCE (ioId,0) = 0
    THEN
        IF COALESCE (inPartnerId, 0) = 0
        THEN
            -- ���� � ������ ������������
            ioId := (SELECT Object_ReportBonus.Id
                     FROM Object AS Object_ReportBonus
                          INNER JOIN ObjectDate AS ObjectDate_Month
                                                ON ObjectDate_Month.ObjectId = Object_ReportBonus.Id
                                               AND ObjectDate_Month.DescId = zc_Object_ReportBonus_Month()
                                               AND ObjectDate_Month.ValueData =  DATE_TRUNC ('MONTH', inMonth)
                          INNER JOIN ObjectLink AS ObjectLink_Juridical
                                                ON ObjectLink_Juridical.ObjectId = Object_ReportBonus.Id
                                               AND ObjectLink_Juridical.DescId = zc_ObjectLink_ReportBonus_Juridical()
                                               AND ObjectLink_Juridical.ChildObjectId = inJuridicalId
                          INNER JOIN ObjectLink AS ObjectLink_ContractMaster
                                                ON ObjectLink_ContractMaster.ObjectId = Object_ReportBonus.Id
                                               AND ObjectLink_ContractMaster.DescId = zc_ObjectLink_ReportBonus_ContractMaster()
                                               AND ObjectLink_ContractMaster.ChildObjectId = inContractId_master
                          INNER JOIN ObjectLink AS ObjectLink_ContractChild
                                                ON ObjectLink_ContractChild.ObjectId = Object_ReportBonus.Id
                                               AND ObjectLink_ContractChild.DescId = zc_ObjectLink_ReportBonus_ContractChild()
                                               AND ObjectLink_ContractChild.ChildObjectId  = inContractId_child

                          LEFT JOIN ObjectLink AS ObjectLink_Partner
                                               ON ObjectLink_Partner.ObjectId = Object_ReportBonus.Id
                                              AND ObjectLink_Partner.DescId = zc_ObjectLink_ReportBonus_Partner()
                    WHERE Object_ReportBonus.DescId = zc_Object_ReportBonus()
                       AND ObjectLink_Partner.ChildObjectId IS NULL
                    );
        ELSE
            -- ���� � ������������� ������������
            ioId := (SELECT Object_ReportBonus.Id
                     FROM Object AS Object_ReportBonus
                          INNER JOIN ObjectDate AS ObjectDate_Month
                                               ON ObjectDate_Month.ObjectId  = Object_ReportBonus.Id
                                              AND ObjectDate_Month.DescId    = zc_Object_ReportBonus_Month()
                                              AND ObjectDate_Month.ValueData =  DATE_TRUNC ('MONTH', inMonth)
                          INNER JOIN ObjectLink AS ObjectLink_Juridical
                                                ON ObjectLink_Juridical.ObjectId      = Object_ReportBonus.Id
                                               AND ObjectLink_Juridical.DescId        = zc_ObjectLink_ReportBonus_Juridical()
                                               AND ObjectLink_Juridical.ChildObjectId = inJuridicalId
                          INNER JOIN ObjectLink AS ObjectLink_Partner
                                                ON ObjectLink_Partner.ObjectId      = Object_ReportBonus.Id
                                               AND ObjectLink_Partner.DescId        = zc_ObjectLink_ReportBonus_Partner()
                                               AND ObjectLink_Partner.ChildObjectId = inPartnerId

                          INNER JOIN ObjectLink AS ObjectLink_ContractMaster
                                                ON ObjectLink_ContractMaster.ObjectId = Object_ReportBonus.Id
                                               AND ObjectLink_ContractMaster.DescId = zc_ObjectLink_ReportBonus_ContractMaster()
                                               AND ObjectLink_ContractMaster.ChildObjectId = inContractId_master
                          INNER JOIN ObjectLink AS ObjectLink_ContractChild
                                                ON ObjectLink_ContractChild.ObjectId = Object_ReportBonus.Id
                                               AND ObjectLink_ContractChild.DescId = zc_ObjectLink_ReportBonus_ContractChild()
                                               AND ObjectLink_ContractChild.ChildObjectId  = inContractId_child
                     WHERE Object_ReportBonus.DescId = zc_Object_ReportBonus()
                    );
        END IF;
    END IF;

    -- ���� isSend = TRUE, �������� �� ������ ���, ���� ���������� �� ����, �.�. ����� isErased = TRUE
    IF COALESCE (ioId, 0) <> 0 AND inIsSend = TRUE
    THEN
        UPDATE Object SET isErased = TRUE WHERE Object.Id = ioId AND Object.DescId = zc_Object_ReportBonus();
    END IF;

    -- ���� isSend = FALSE � ����� ������� ����, ��������������� � ������ ���, ���� ���������� �� ����, �.�. ����� isErased = FALSE
    IF COALESCE (ioId,0) <> 0 AND inIsSend = FALSE
    THEN
        UPDATE Object SET isErased = FALSE WHERE Object.Id = ioId AND Object.DescId = zc_Object_ReportBonus();
        -- ��������� ����� �������� -- 18,01,2021
          -- ��������� ����� � <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReportBonus_ContractMaster(), ioId, inContractId_master);
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReportBonus_ContractChild(), ioId, inContractId_child);
    END IF;

    -- ���� isSend = FALSE - � ��� ����� �������, ��������� � ������ ���, ���� ���������� �� ����
    IF COALESCE (ioId, 0) = 0 AND inIsSend = FALSE
    THEN
         -- ��������� <������>
         ioId := lpInsertUpdate_Object (ioId, zc_Object_ReportBonus(), 0, '');

         -- ��������� �������� <>
         PERFORM lpInsertUpdate_ObjectDate (zc_Object_ReportBonus_Month(), ioId, DATE_TRUNC ('MONTH', inMonth));

         -- ��������� ����� � <����������� ����>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReportBonus_Juridical(), ioId, inJuridicalId);
         -- ��������� ����� � <����������>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReportBonus_Partner(), ioId, inPartnerId);
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReportBonus_ContractMaster(), ioId, inContractId_master);
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReportBonus_ContractChild(), ioId, inContractId_child);
    END IF;


    IF ioId > 0
    THEN
        -- ��������� ��������
        PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
    END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.09.20         *
*/


-- ����
--