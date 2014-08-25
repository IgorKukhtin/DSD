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


   -- ��� ���� - "�� ������������"
   CREATE TEMP TABLE _tmp (Id Integer) ON COMMIT DROP;

   -- ��������� ����
   WITH tmpSale1C  AS (SELECT Sale1C.ClientCode, MAX (TRIM (Sale1C.ClientName)) AS ClientName, MAX (TRIM (Sale1C.ClientOKPO)) AS OKPO, CASE WHEN LENGTH (MAX (TRIM (Sale1C.ClientOKPO))) <= 6 THEN TRUE ELSE FALSE END isOKPO_Virtual
                       FROM Sale1C
                       WHERE zfGetBranchLinkFromBranchPaidKind(zfGetBranchFromUnitId (Sale1C.UnitId), zc_Enum_PaidKind_SecondForm()) = inBranchTopId
                         AND zfGetPaidKindFrom1CType (Sale1C.VidDoc) = zc_Enum_PaidKind_SecondForm()
                         AND Sale1C.ClientCode <> 0
                         AND TRIM (Sale1C.ClientOKPO) <> ''
                         AND LENGTH (TRIM (Sale1C.ClientOKPO)) > 6
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
      , tmpAll AS (SELECT tmpPartner1CLink.Id AS Partner1CLinkId, tmpPartner1CLink.ClientCode
                        , tmpSale1C.ClientName, tmpSale1C.OKPO, tmpSale1C.isOKPO_Virtual
                   FROM tmpPartner1CLink
                              INNER JOIN tmpSale1C ON tmpSale1C.ClientCode = tmpPartner1CLink.ClientCode
                  )
      , tmpJuridical AS (SELECT tmpAll.OKPO, tmpAll.isOKPO_Virtual, MAX (tmpAll.ClientName) AS JuridicalName FROM tmpAll GROUP BY tmpAll.OKPO, tmpAll.isOKPO_Virtual)

   INSERT INTO _tmp (Id)
   SELECT lpInsertUpdate_Object_Partner1CLink (ioId         := tmpPartner.Partner1CLinkId
                                             , inCode       := tmpPartner.ClientCode
                                             , inName       := tmpPartner.ClientName
                                             , inPartnerId  := tmpPartner.PartnerId
                                             , inBranchId   := inBranchTopId
                                             , inContractId := tmpPartner.ContractId
                                             , inUserId     := vbUserId)
   FROM 
         -- ����������
        (SELECT lpInsertUpdate_Object_Partner (ioId              := 0
                                             , inPartnerName     := tmpAll.ClientName
                                             , inAddress         := ''
                                             , inCode            := 0
                                             , inShortName       := NULL
                                             , inGLNCode         := NULL
                                             , inHouseNumber     := NULL
                                             , inCaseNumber      := NULL
                                             , inRoomNumber      := NULL
                                             , inStreetId        := NULL
                                             , inPrepareDayCount := NULL
                                             , inDocumentDayCount:= NULL
                                             , inJuridicalId     := tmpContract.JuridicalId
                                             , inRouteId         := NULL
                                             , inRouteSortingId  := NULL
                                             , inPersonalTakeId  := NULL
                                             , inPriceListId     := NULL
                                             , inPriceListPromoId:= NULL
                                             , inStartPromo      := NULL
                                             , inEndPromo        := NULL
                                             , inUserId          := vbUserId
                                         ) AS PartnerId
              , tmpContract.JuridicalId
              , tmpContract.ContractId
              , tmpAll.Partner1CLinkId
              , tmpAll.ClientCode
              , tmpAll.ClientName
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

              , tmpJuridical.OKPO
              , tmpJuridical.JuridicalId
         FROM
         -- ��.����
        (SELECT CASE WHEN ViewHistory_JuridicalDetails.OKPO IS NULL
                          THEN gpInsertUpdate_Object_Juridical (ioId              := 0
                                                              , inCode            := 0
                                                              , inName            := tmpJuridical.JuridicalName
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
              , tmpJuridical.OKPO
         FROM tmpJuridical
              LEFT JOIN (SELECT MAX (ObjectHistory_JuridicalDetails_View.JuridicalId) AS JuridicalId, ObjectHistory_JuridicalDetails_View.OKPO
                         FROM ObjectHistory_JuridicalDetails_View
                         GROUP BY ObjectHistory_JuridicalDetails_View.OKPO
                        ) AS ViewHistory_JuridicalDetails ON ViewHistory_JuridicalDetails.OKPO = tmpJuridical.OKPO
                                                         AND tmpJuridical.isOKPO_Virtual = FALSE
        ) AS tmpJuridical -- ��.����
        LEFT JOIN (SELECT MAX (Object_Contract_View.ContractId) AS ContractId, Object_Contract_View.JuridicalId
                   FROM Object_Contract_View
                   WHERE Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                     AND Object_Contract_View.isErased = FALSE
                     AND Object_Contract_View.InfoMoneyId = zc_Enum_InfoMoney_30101() -- ������� ���������
                   GROUP BY Object_Contract_View.JuridicalId
                  ) AS Contract_noClose ON Contract_noClose.JuridicalId = tmpJuridical.JuridicalId
                                       AND tmpJuridical.isJuridicalInsert = FALSE
        LEFT JOIN (SELECT MAX (Object_Contract_View.ContractId) AS ContractId, Object_Contract_View.JuridicalId
                   FROM Object_Contract_View
                   WHERE Object_Contract_View.ContractStateKindId = zc_Enum_ContractStateKind_Close()
                     AND Object_Contract_View.isErased = FALSE
                     AND Object_Contract_View.InfoMoneyId = zc_Enum_InfoMoney_30101() -- ������� ���������
                   GROUP BY Object_Contract_View.JuridicalId
                  ) AS Contract_Close ON Contract_Close.JuridicalId = tmpJuridical.JuridicalId
                                     AND tmpJuridical.isJuridicalInsert = FALSE
                                     AND Contract_noClose.JuridicalId IS NULL
        LEFT JOIN (SELECT MAX (Object_Contract_View.ContractId) AS ContractId, Object_Contract_View.JuridicalId
                   FROM Object_Contract_View
                   WHERE Object_Contract_View.isErased = TRUE
                     AND Object_Contract_View.InfoMoneyId = zc_Enum_InfoMoney_30101() -- ������� ���������
                   GROUP BY Object_Contract_View.JuridicalId
                  ) AS Contract_Erased ON Contract_Erased.JuridicalId = tmpJuridical.JuridicalId
                                      AND tmpJuridical.isJuridicalInsert = FALSE
                                      AND Contract_noClose.JuridicalId IS NULL
                                      AND Contract_Close.JuridicalId IS NULL
        ) AS tmpContract -- �������
        LEFT JOIN tmpAll ON tmpAll.OKPO = tmpContract.OKPO

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

/*
"������������ �.�.";"������������ �.�.";"3163220108"
"���"������ �.�.";"���"������ �.�.";"1905323222"
"������� �.�.";"������� �.�.";"3183512074"
"�������� 5% ������� +";"�������� 5% ������� +";"3112611673"
"�������� _.�. ����_�����";"�������� _.�. ����_�����";"2990109880"
"�������� _.�. ���������";"�������� _.�. ����_�����";"2990109880"
"������ �.�.";"������ �.�.";"2064814385"
"�������� �.�.";"�������� �.�.";"2340514464"
*/