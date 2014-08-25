-- Function: gpUpdate_Object_Partner1CLink_Partner (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner1CLink_Partner (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner1CLink_Partner(
    IN inBranchTopId            Integer,    -- 
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbJuridicalGroupId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Partner1CLink_Partner());
   vbUserId := lpGetUserBySession (inSession);

   -- ��������
   IF COALESCE (inBranchTopId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ���������� <������>.';
   END IF;

   -- ������������ ������
   vbJuridicalGroupId:= (SELECT Object_JuridicalGroup.Id
                         FROM Object
                              INNER JOIN Object AS Object_JuridicalGroup
                                                ON Object_JuridicalGroup.DescId = zc_Object_JuridicalGroup()
                                               AND Object_JuridicalGroup.ObjectCode = 20 + Object.ObjectCode
                         WHERE Object.Id = inBranchTopId);

   -- ��������
   IF COALESCE (vbJuridicalGroupId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ���������� <������ ��.���>.';
   END IF;



   --
   CREATE TEMP TABLE _tmp (Id Integer) ON COMMIT DROP;



   -- ��������� ����
   WITH tmpSale1C  AS (SELECT Sale1C.ClientCode, MAX (TRIM (Sale1C.ClientName)) AS ClientName, MAX (TRIM (Sale1C.ClientOKPO)) AS OKPO, CASE WHEN LENGTH (MAX (TRIM (Sale1C.ClientOKPO))) <= 6 THEN TRUE ELSE FALSE END isOKPO_Virtual
                       FROM Sale1C
                       WHERE zfGetBranchLinkFromBranchPaidKind(zfGetBranchFromUnitId (Sale1C.UnitId), zc_Enum_PaidKind_SecondForm()) = inBranchTopId
                         AND zfGetPaidKindFrom1CType (Sale1C.VidDoc) = zc_Enum_PaidKind_SecondForm()
                         AND Sale1C.ClientCode <> 0
                         AND TRIM (Sale1C.ClientOKPO) <> ''
                       GROUP BY Sale1C.ClientCode
                      )
      , tmpPartner1CLink AS (SELECT MAX (Object_Partner1CLink.Id) AS Id
                                  , Object_Partner1CLink.ObjectCode AS ClientCode
                             FROM Object AS Object_Partner1CLink
                                  INNER JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
                                                        ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_Partner1CLink.Id
                                                       AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
                                                       AND ObjectLink_Partner1CLink_Branch.ChildObjectId = inBranchTopId
                                  LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Partner
                                                       ON ObjectLink_Partner1CLink_Partner.ObjectId = Object_Partner1CLink.Id
                                                      AND ObjectLink_Partner1CLink_Partner.DescId = zc_ObjectLink_Partner1CLink_Partner()
                             WHERE Object_Partner1CLink.DescId =  zc_Object_Partner1CLink()
                               AND Object_Partner1CLink.ObjectCode <> 0
                               AND ObjectLink_Partner1CLink_Partner.ChildObjectId IS NULL
                             GROUP BY Object_Partner1CLink.ObjectCode
                            )

   INSERT INTO _tmp (Id)
   SELECT lpInsertUpdate_Object_Partner1CLink (inId         := tmpPartner.Partner1CLinkId
                                             , inCode       := tmpPartner.ClientCode
                                             , inName       := tmpPartner.ClientName
                                             , inPartnerId  := tmpPartner.PartnerId
                                             , inBranchId   := inBranchTopId
                                             , inContractId := tmpPartner.ContractId
                                             , inUserId     := vbUserId)
   FROM 
         -- ����������
        (SELECT gpInsertUpdate_Object_Partner(
 INOUT ioId                  Integer   ,    -- ���� ������� <����������> 
   OUT outPartnerName        TVarChar  ,    -- 
    IN inAddress             TVarChar  ,    -- 
    IN inCode                Integer   ,    -- ��� ������� <����������> 
    IN inShortName           TVarChar  ,    -- ������� ������������
    IN inGLNCode             TVarChar  ,    -- ��� GLN
    IN inHouseNumber         TVarChar  ,    -- ����� ����
    IN inCaseNumber          TVarChar  ,    -- ����� �������
    IN inRoomNumber          TVarChar  ,    -- ����� ��������
    IN inStreetId            Integer   ,    -- �����/��������  
    IN inPrepareDayCount     TFloat    ,    -- �� ������� ���� ����������� �����
    IN inDocumentDayCount    TFloat    ,    -- ����� ������� ���� ����������� �������������
    IN inJuridicalId         Integer   ,    -- ����������� ����
    IN inRouteId             Integer   ,    -- �������
    IN inRouteSortingId      Integer   ,    -- ���������� ���������
    IN inPersonalTakeId      Integer   ,    -- ��������� (����������) 
    
    IN inPriceListId         Integer   ,    -- �����-����
    IN inPriceListPromoId    Integer   ,    -- �����-����(���������)
    IN inStartPromo          TDateTime ,    -- ���� ������ �����
    IN inEndPromo            TDateTime ,    -- ���� ��������� �����     
              , tmpContract.JuridicalId
              , tmpContract.Partner1CLinkId
              , tmpContract.ClientCode
              , tmpContract.ClientName
              , tmpContract.ContractId
         FROM
         -- �������
        (SELECT CASE WHEN COALESCE (Contract_noClose.ContractId, COALESCE (Contract_Close.ContractId, COALESCE (Contract_Erased.ContractId, 0))) = 0
                          THEN gpInsertUpdate_Object_Contract (ioId                 := 0
                                                             , inCode               := 0
                                                             , inInvNumber          := '��� ��������'
                                                             , inInvNumberArchive   := ''
                                                             , inComment            := ''
                                                             , inBankAccountExternal:= ''
    
                                                             , inSigningDate        := '01.01.2000'
                                                             , inStartDate          := '01.01.2000'
                                                             , inEndDate            := '31.12.2020'
    
                                                             , inJuridicalId        := tmpJuridical.JuridicalId
                                                             , inJuridicalBasisId   := zc_Juridical_Basis()
                                                             , inInfoMoneyId        := zc_Enum_InfoMoney_30101() -- ������� ���������
                                                             , inContractKindId     := NULL
                                                             , inPaidKindId         := zc_Enum_PaidKind_SecondForm()
    
                                                             , inPersonalId         := NULL
                                                             , inPersonalTradeId    := NULL
                                                             , inPersonalCollationId:= NULL
                                                             , inBankAccountId      := NULL
                                                             , inContractTagId      := 113113 -- ������
    
                                                             , inAreaId             := NULL
                                                             , inContractArticleId  := NULL
                                                             , inContractStateKindId:= NULL
                                                             , inBankId             := NULL
                                                             , inisDefault          := TRUE
                                                             , inisStandart         := TRUE

                                                             , inisPersonal         := FALSE
                                                             , inisUnique           := TRUE
                                                             , inSession            := inSession
                                                               )
                     ELSE COALESCE (Contract_noClose.ContractId, COALESCE (Contract_Close.ContractId, COALESCE (Contract_Erased.ContractId, 0)))
                END AS ContractId

              , tmpJuridical.JuridicalId
              , tmpJuridical.Partner1CLinkId
              , tmpJuridical.ClientCode
              , tmpJuridical.ClientName
         FROM
         -- ��.����
        (SELECT CASE WHEN ViewHistory_JuridicalDetails.OKPO IS NULL
                          THEN gpInsertUpdate_Object_Juridical (ioId              := 0
                                                              , inCode            := 0
                                                              , inName            := tmpSale1C.ClientName
                                                              , inGLNCode         := NULL
                                                              , inisCorporate     := FALSE
                                                              , inJuridicalGroupId:= vbJuridicalGroupId
                                                              , inGoodsPropertyId := NULL
                                                              , inRetailId        := NULL
                                                              , inInfoMoneyId     := zc_Enum_InfoMoney_30101() -- ������� ���������
                                                              , inPriceListId     := NULL
                                                              , inPriceListPromoId:= NULL
                                                              , inStartPromo      := NULL
                                                              , inEndPromo        := NULL
                                                              , inSession         := inSession
                                                               )
                     ELSE COALESCE (ViewHistory_JuridicalDetails.JuridicalId, 0)
                END AS JuridicalId

              , CASE WHEN ViewHistory_JuridicalDetails.OKPO IS NULL THEN TRUE ELSE FALSE END AS isJuridicalInsert
              , tmpPartner1CLink.Id AS Partner1CLinkId
              , tmpSale1C.ClientCode
              , tmpSale1C.ClientName

         FROM tmpPartner1CLink
              INNER JOIN tmpSale1C ON tmpSale1C.ClientCode = tmpPartner1CLink.ClientCode
              LEFT JOIN (SELECT MAX (ObjectHistory_JuridicalDetails_View.JuridicalId) AS JuridicalId, ObjectHistory_JuridicalDetails_View.OKPO
                         FROM ObjectHistory_JuridicalDetails_View
                         GROUP BY ObjectHistory_JuridicalDetails_View.OKPO
                        ) AS ViewHistory_JuridicalDetails ON ViewHistory_JuridicalDetails.OKPO = tmpSale1C.OKPO
                                                         AND tmpSale1C.isOKPO_Virtual = FALSE
        ) AS tmpJuridical -- ��.����
        LEFT JOIN (SELECT MAX (Object_Contract_InvNumber_View.ContractId) AS ContractId, Object_Contract_InvNumber_View.JuridicalId
                   FROM Object_Contract_InvNumber_View
                   WHERE Object_Contract_InvNumber_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                     AND Object_Contract_InvNumber_View.isErased = FALSE
                     AND Object_Contract_InvNumber_View.InfoMoneyId = zc_Enum_InfoMoney_30101() -- ������� ���������
                   GROUP BY Object_Contract_InvNumber_View.JuridicalId
                  ) AS Contract_noClose ON Contract_noClose.JuridicalId = tmpJuridical.JuridicalId
                                       AND tmpJuridical.isJuridicalInsert = FALSE
        LEFT JOIN (SELECT MAX (Object_Contract_InvNumber_View.ContractId) AS ContractId, Object_Contract_InvNumber_View.JuridicalId
                   FROM Object_Contract_InvNumber_View
                   WHERE Object_Contract_InvNumber_View.ContractStateKindId = zc_Enum_ContractStateKind_Close()
                     AND Object_Contract_InvNumber_View.isErased = FALSE
                     AND Object_Contract_InvNumber_View.InfoMoneyId = zc_Enum_InfoMoney_30101() -- ������� ���������
                   GROUP BY Object_Contract_InvNumber_View.JuridicalId
                  ) AS Contract_Close ON Contract_Close.JuridicalId = tmpJuridical.JuridicalId
                                     AND tmpJuridical.isJuridicalInsert = FALSE
                                     AND Contract_noClose.JuridicalId IS NULL
        LEFT JOIN (SELECT MAX (Object_Contract_InvNumber_View.ContractId) AS ContractId, Object_Contract_InvNumber_View.JuridicalId
                   FROM Object_Contract_InvNumber_View
                   WHERE Object_Contract_InvNumber_View.isErased = TRUE
                     AND Object_Contract_InvNumber_View.InfoMoneyId = zc_Enum_InfoMoney_30101() -- ������� ���������
                   GROUP BY Object_Contract_InvNumber_View.JuridicalId
                  ) AS Contract_Erased ON Contract_Erased.JuridicalId = tmpJuridical.JuridicalId
                                      AND tmpJuridical.isJuridicalInsert = FALSE
                                      AND Contract_noClose.JuridicalId IS NULL
                                      AND Contract_Close.JuridicalId IS NULL
        ) AS tmpContract -- �������
        ) AS tmpPartner -- ����������
  ;
                                          


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_Partner1CLink_Partner (Integer, TVarChar)  OWNER TO postgres;

  
/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.08.14                                        *
*/
