-- Function: lfGet_Object_Partner_PriceList_onDate (Integer, Integer, TDateTime)

DROP FUNCTION IF EXISTS lfGet_Object_Partner_PriceList_onDate (Integer, Integer, Integer, TDateTime, TDateTime, Boolean);

CREATE OR REPLACE FUNCTION lfGet_Object_Partner_PriceList_onDate(
    IN inContractId      Integer, 
    IN inPartnerId       Integer,
    IN inMovementDescId  Integer,
    IN inOperDate_order  TDateTime,
    IN inOperDatePartner TDateTime,
    IN inIsPrior         Boolean
)
RETURNS TABLE (PriceListId Integer, PriceListName TVarChar, PriceWithVAT Boolean, VATPercent TFloat, DescId Integer, Code TVarChar, ItemName TVarChar)
AS
$BODY$
   DECLARE vbJuridicalId Integer;
   DECLARE vbInfoMoneyId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN

      -- �����
      IF COALESCE (inContractId, 0) = 0
      THEN RETURN;
      END IF;


      -- ���������� ������
      vbInfoMoneyId:= (SELECT ObjectLink_Contract_InfoMoney.ChildObjectId
                       FROM ObjectLink AS ObjectLink_Contract_InfoMoney
                       WHERE ObjectLink_Contract_InfoMoney.ObjectId = inContractId
                         AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                      );
      -- ���������� ��.����
      vbJuridicalId:= (SELECT ObjectLink_Partner_Juridical.ChildObjectId
                       FROM ObjectLink AS ObjectLink_Partner_Juridical
                       WHERE ObjectLink_Partner_Juridical.ObjectId = inPartnerId
                         AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                      );

      IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmppricelist_ondate')
      THEN
          --
          DELETE FROM _tmpPriceList_onDate;
      ELSE
          -- 
          CREATE TEMP TABLE _tmpPriceList_onDate (PriceListId Integer, DescId Integer) ON COMMIT DROP;
      END IF;

      -- 1.1. ��� ��� ��������� + ��
      IF inMovementDescId = zc_Movement_ReturnIn() AND vbInfoMoneyId = zc_Enum_InfoMoney_30101() -- ������ + ��������� + ������� ���������
      THEN
          IF inIsPrior = TRUE
          THEN
              -- 1.1.1. ��� ��� ��������� �� �� "������ �����"
              WITH tmpPartner AS (SELECT inPartnerId AS PartnerId, vbJuridicalId AS JuridicalId)
              INSERT INTO _tmpPriceList_onDate (PriceListId, DescId)
                 SELECT COALESCE (ObjectLink_Partner_PriceListPrior.ChildObjectId
                      , COALESCE (ObjectLink_Juridical_PriceListPrior.ChildObjectId
                                , zc_PriceList_BasisPrior())) AS PriceListId

                      , COALESCE (ObjectLink_Partner_PriceListPrior.DescId
                      , COALESCE (ObjectLink_Juridical_PriceListPrior.DescId
                                , 0)) AS DescId
                 FROM tmpPartner
                      LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceListPrior
                                           ON ObjectLink_Partner_PriceListPrior.ObjectId = tmpPartner.PartnerId
                                          AND ObjectLink_Partner_PriceListPrior.DescId = zc_ObjectLink_Partner_PriceListPrior()
                                          AND ObjectLink_Partner_PriceListPrior.ChildObjectId > 0
                      LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceListPrior
                                           ON ObjectLink_Juridical_PriceListPrior.ObjectId = tmpPartner.JuridicalId
                                          AND ObjectLink_Juridical_PriceListPrior.DescId = zc_ObjectLink_Juridical_PriceListPrior()
                                          AND ObjectLink_Juridical_PriceListPrior.ChildObjectId > 0
                 ;
          ELSE
              -- 1.1.2. ��� ��� ��������� �� �� "������� �����"
              WITH tmpPartner AS (SELECT inPartnerId AS PartnerId, inContractId AS ContractId, vbJuridicalId AS JuridicalId)
              INSERT INTO _tmpPriceList_onDate (PriceListId, DescId)
                 SELECT COALESCE (ObjectLink_Partner_PriceList.ChildObjectId
                      , COALESCE (ObjectLink_Contract_PriceList.ChildObjectId
                      , COALESCE (ObjectLink_Juridical_PriceList.ChildObjectId
                                , zc_PriceList_Basis()))) AS PriceListId

                      , COALESCE (ObjectLink_Partner_PriceList.DescId
                      , COALESCE (ObjectLink_Contract_PriceList.DescId
                      , COALESCE (ObjectLink_Juridical_PriceList.DescId
                                , 0))) AS DescId
                 FROM tmpPartner
                      LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList
                                           ON ObjectLink_Partner_PriceList.ObjectId = tmpPartner.PartnerId
                                          AND ObjectLink_Partner_PriceList.DescId = zc_ObjectLink_Partner_PriceList()
                                          AND ObjectLink_Partner_PriceList.ChildObjectId > 0
                      LEFT JOIN ObjectLink AS ObjectLink_Contract_PriceList
                                           ON ObjectLink_Contract_PriceList.ObjectId = tmpPartner.ContractId
                                          AND ObjectLink_Contract_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
                                          AND ObjectLink_Contract_PriceList.ChildObjectId > 0
                      LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                           ON ObjectLink_Juridical_PriceList.ObjectId = tmpPartner.JuridicalId
                                          AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()
                                          AND ObjectLink_Juridical_PriceList.ChildObjectId > 0
                 ;

          END IF;
      ELSE
          -- 1.2. ��� ��� ��������� + �� ��
          IF inMovementDescId = zc_Movement_ReturnIn()
          THEN
              WITH tmpPartner AS (SELECT inPartnerId AS PartnerId, inContractId AS ContractId, vbJuridicalId AS JuridicalId)
              INSERT INTO _tmpPriceList_onDate (PriceListId, DescId)
                 SELECT COALESCE (ObjectLink_Partner_PriceList30103.ChildObjectId
                      , COALESCE (ObjectLink_Partner_PriceList30201.ChildObjectId
                      , COALESCE (ObjectLink_Contract_PriceList.ChildObjectId
                      , COALESCE (ObjectLink_Juridical_PriceList30103.ChildObjectId
                      , COALESCE (ObjectLink_Juridical_PriceList30201.ChildObjectId
                                , zc_PriceList_Basis()))))) AS PriceListId

                      , COALESCE (ObjectLink_Partner_PriceList30103.DescId
                      , COALESCE (ObjectLink_Partner_PriceList30201.DescId

                      , COALESCE (ObjectLink_Contract_PriceList.DescId

                      , COALESCE (ObjectLink_Juridical_PriceList30103.DescId
                      , COALESCE (ObjectLink_Juridical_PriceList30201.DescId

                                , 0))))) AS DescId
                 FROM tmpPartner
                      LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList30103
                                           ON ObjectLink_Partner_PriceList30103.ObjectId = tmpPartner.PartnerId
                                          AND ObjectLink_Partner_PriceList30103.DescId = zc_ObjectLink_Partner_PriceList30103()
                                          AND ObjectLink_Partner_PriceList30103.ChildObjectId > 0
                                          AND vbInfoMoneyId = zc_Enum_InfoMoney_30103() -- ������ + ��������� + ����
                      LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList30201
                                           ON ObjectLink_Partner_PriceList30201.ObjectId = tmpPartner.PartnerId
                                          AND ObjectLink_Partner_PriceList30201.DescId = zc_ObjectLink_Partner_PriceList30201()
                                          AND ObjectLink_Partner_PriceList30201.ChildObjectId > 0
                                          AND vbInfoMoneyId = zc_Enum_InfoMoney_30201() -- ������ + ������ ����� + ������ �����

                      LEFT JOIN ObjectLink AS ObjectLink_Contract_PriceList
                                           ON ObjectLink_Contract_PriceList.ObjectId = tmpPartner.ContractId
                                          AND ObjectLink_Contract_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
                                          AND ObjectLink_Contract_PriceList.ChildObjectId > 0

                      LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList30103
                                           ON ObjectLink_Juridical_PriceList30103.ObjectId = tmpPartner.JuridicalId
                                          AND ObjectLink_Juridical_PriceList30103.DescId = zc_ObjectLink_Juridical_PriceList30103()
                                          AND ObjectLink_Juridical_PriceList30103.ChildObjectId > 0
                                          AND vbInfoMoneyId = zc_Enum_InfoMoney_30103() -- ������ + ��������� + ����
                      LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList30201
                                           ON ObjectLink_Juridical_PriceList30201.ObjectId = tmpPartner.JuridicalId
                                          AND ObjectLink_Juridical_PriceList30201.DescId = zc_ObjectLink_Juridical_PriceList30201()
                                          AND ObjectLink_Juridical_PriceList30201.ChildObjectId > 0
                                          AND vbInfoMoneyId = zc_Enum_InfoMoney_30201() -- ������ + ������ ����� + ������ �����

                 ;
          ELSE
          -- 2.1. ��� ��� ������� + ��
          IF inMovementDescId = zc_Movement_Sale() AND vbInfoMoneyId = zc_Enum_InfoMoney_30101() -- ������ + ��������� + ������� ���������
          THEN
              IF inOperDatePartner IS NULL
              THEN
                  -- ���� ��� ������ �����
                  inOperDatePartner:= inOperDate_order :: Date + COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = inPartnerId AND ObjectFloat.DescId = zc_ObjectFloat_Partner_PrepareDayCount()), 0) :: Integer
                                                               + COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = inPartnerId AND ObjectFloat.DescId = zc_ObjectFloat_Partner_DocumentDayCount()), 0) :: Integer
                                                               ;
              END IF;
              -- 2.1. � ��������� �������: 1.1) ��������� � ����������� 1.2) ��������� � �������� 1.3) ��������� � ��.���� 2.1) ������� � ����������� 2.2) ������� � �������� 2.3) ������� � ��.���� 3) zc_PriceList_Basis
              WITH tmpPartner AS (SELECT inPartnerId AS PartnerId, inContractId AS ContractId, vbJuridicalId AS JuridicalId)
              INSERT INTO _tmpPriceList_onDate (PriceListId, DescId)
                 SELECT COALESCE (ObjectLink_Partner_PriceListPromo.ChildObjectId
                      , COALESCE (ObjectLink_Contract_PriceListPromo.ChildObjectId
                      , COALESCE (ObjectLink_Juridical_PriceListPromo.ChildObjectId

                      , COALESCE (ObjectLink_Partner_PriceList.ChildObjectId
                      , COALESCE (ObjectLink_Contract_PriceList.ChildObjectId
                      , COALESCE (ObjectLink_Juridical_PriceList.ChildObjectId
                                , zc_PriceList_Basis())))))) AS PriceListId

                      , COALESCE (ObjectLink_Partner_PriceListPromo.DescId
                      , COALESCE (ObjectLink_Contract_PriceListPromo.DescId
                      , COALESCE (ObjectLink_Juridical_PriceListPromo.DescId

                      , COALESCE (ObjectLink_Partner_PriceList.DescId
                      , COALESCE (ObjectLink_Contract_PriceList.DescId
                      , COALESCE (ObjectLink_Juridical_PriceList.DescId
                                , 0)))))) AS DescId

                 FROM tmpPartner
                      LEFT JOIN ObjectDate AS ObjectDate_PartnerStartPromo
                                           ON ObjectDate_PartnerStartPromo.ObjectId = tmpPartner.PartnerId
                                          AND ObjectDate_PartnerStartPromo.DescId = zc_ObjectDate_Partner_StartPromo()
                      LEFT JOIN ObjectDate AS ObjectDate_PartnerEndPromo
                                           ON ObjectDate_PartnerEndPromo.ObjectId = tmpPartner.PartnerId
                                          AND ObjectDate_PartnerEndPromo.DescId = zc_ObjectDate_Partner_EndPromo()
                      LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceListPromo
                                           ON ObjectLink_Partner_PriceListPromo.ObjectId = tmpPartner.PartnerId
                                          AND ObjectLink_Partner_PriceListPromo.DescId = zc_ObjectLink_Partner_PriceListPromo()
                                          AND ObjectLink_Partner_PriceListPromo.ChildObjectId > 0
                                          AND inOperDatePartner BETWEEN ObjectDate_PartnerStartPromo.ValueData AND ObjectDate_PartnerEndPromo.ValueData

                      LEFT JOIN ObjectDate AS ObjectDate_StartPromo
                                           ON ObjectDate_StartPromo.ObjectId = tmpPartner.ContractId
                                          AND ObjectDate_StartPromo.DescId = zc_ObjectDate_Contract_StartPromo()
                      LEFT JOIN ObjectDate AS ObjectDate_EndPromo
                                           ON ObjectDate_EndPromo.ObjectId = tmpPartner.ContractId
                                          AND ObjectDate_EndPromo.DescId = zc_ObjectDate_Contract_EndPromo()
                      LEFT JOIN ObjectLink AS ObjectLink_Contract_PriceListPromo
                                           ON ObjectLink_Contract_PriceListPromo.ObjectId = tmpPartner.ContractId
                                          AND ObjectLink_Contract_PriceListPromo.DescId = zc_ObjectLink_Contract_PriceListPromo()
                                          AND ObjectLink_Contract_PriceListPromo.ChildObjectId > 0
                                          AND inOperDatePartner BETWEEN ObjectDate_StartPromo.ValueData AND ObjectDate_EndPromo.ValueData

                      LEFT JOIN ObjectDate AS ObjectDate_JuridicalStartPromo
                                           ON ObjectDate_JuridicalStartPromo.ObjectId = tmpPartner.JuridicalId
                                          AND ObjectDate_JuridicalStartPromo.DescId = zc_ObjectDate_Juridical_StartPromo()
                      LEFT JOIN ObjectDate AS ObjectDate_JuridicalEndPromo
                                           ON ObjectDate_JuridicalEndPromo.ObjectId = tmpPartner.JuridicalId
                                          AND ObjectDate_JuridicalEndPromo.DescId = zc_ObjectDate_Juridical_EndPromo()
                      LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceListPromo
                                           ON ObjectLink_Juridical_PriceListPromo.ObjectId = tmpPartner.JuridicalId
                                          AND ObjectLink_Juridical_PriceListPromo.DescId = zc_ObjectLink_Juridical_PriceListPromo()
                                          AND ObjectLink_Juridical_PriceListPromo.ChildObjectId > 0
                                          AND inOperDatePartner BETWEEN ObjectDate_JuridicalStartPromo.ValueData AND ObjectDate_JuridicalEndPromo.ValueData

                      LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList
                                           ON ObjectLink_Partner_PriceList.ObjectId = tmpPartner.PartnerId
                                          AND ObjectLink_Partner_PriceList.DescId = zc_ObjectLink_Partner_PriceList()
                                          AND ObjectLink_Partner_PriceList.ChildObjectId > 0
                      LEFT JOIN ObjectLink AS ObjectLink_Contract_PriceList
                                           ON ObjectLink_Contract_PriceList.ObjectId = tmpPartner.ContractId
                                          AND ObjectLink_Contract_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
                                          AND ObjectLink_Contract_PriceList.ChildObjectId > 0
                      LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                           ON ObjectLink_Juridical_PriceList.ObjectId = tmpPartner.JuridicalId
                                          AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()
                                          AND ObjectLink_Juridical_PriceList.ChildObjectId > 0
                 ;
         
          ELSE
          -- 2.2. ��� ��� ������� + �� ��
          IF inMovementDescId = zc_Movement_Sale()
          THEN
              --
              WITH tmpPartner AS (SELECT inPartnerId AS PartnerId, inContractId AS ContractId, vbJuridicalId AS JuridicalId)
              INSERT INTO _tmpPriceList_onDate (PriceListId, DescId)
                 SELECT COALESCE (ObjectLink_Partner_PriceList30103.ChildObjectId
                      , COALESCE (ObjectLink_Partner_PriceList30201.ChildObjectId
                      , COALESCE (ObjectLink_Contract_PriceList.ChildObjectId
                      , COALESCE (ObjectLink_Juridical_PriceList30103.ChildObjectId
                      , COALESCE (ObjectLink_Juridical_PriceList30201.ChildObjectId
                                , zc_PriceList_Basis()))))) AS PriceListId

                      , COALESCE (ObjectLink_Partner_PriceList30103.DescId
                      , COALESCE (ObjectLink_Partner_PriceList30201.DescId
                      , COALESCE (ObjectLink_Contract_PriceList.DescId
                      , COALESCE (ObjectLink_Juridical_PriceList30103.DescId
                      , COALESCE (ObjectLink_Juridical_PriceList30201.DescId
                                , 0))))) AS DescId
                 FROM tmpPartner
                      LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList30103
                                           ON ObjectLink_Partner_PriceList30103.ObjectId = tmpPartner.PartnerId
                                          AND ObjectLink_Partner_PriceList30103.DescId = zc_ObjectLink_Partner_PriceList30103()
                                          AND ObjectLink_Partner_PriceList30103.ChildObjectId > 0
                                          AND vbInfoMoneyId = zc_Enum_InfoMoney_30103() -- ������ + ��������� + ����
                      LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList30201
                                           ON ObjectLink_Partner_PriceList30201.ObjectId = tmpPartner.PartnerId
                                          AND ObjectLink_Partner_PriceList30201.DescId = zc_ObjectLink_Partner_PriceList30201()
                                          AND ObjectLink_Partner_PriceList30201.ChildObjectId > 0
                                          AND vbInfoMoneyId = zc_Enum_InfoMoney_30201() -- ������ + ������ ����� + ������ �����

                      LEFT JOIN ObjectLink AS ObjectLink_Contract_PriceList
                                           ON ObjectLink_Contract_PriceList.ObjectId = tmpPartner.ContractId
                                          AND ObjectLink_Contract_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
                                          AND ObjectLink_Contract_PriceList.ChildObjectId > 0

                      LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList30103
                                           ON ObjectLink_Juridical_PriceList30103.ObjectId = tmpPartner.JuridicalId
                                          AND ObjectLink_Juridical_PriceList30103.DescId = zc_ObjectLink_Juridical_PriceList30103()
                                          AND ObjectLink_Juridical_PriceList30103.ChildObjectId > 0
                                          AND vbInfoMoneyId = zc_Enum_InfoMoney_30103() -- ������ + ��������� + ����
                      LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList30201
                                           ON ObjectLink_Juridical_PriceList30201.ObjectId = tmpPartner.JuridicalId
                                          AND ObjectLink_Juridical_PriceList30201.DescId = zc_ObjectLink_Juridical_PriceList30201()
                                          AND ObjectLink_Juridical_PriceList30201.ChildObjectId > 0
                                          AND vbInfoMoneyId = zc_Enum_InfoMoney_30201() -- ������ + ������ ����� + ������ �����
                 ;
          ELSE
              -- 3. ��� ��� ����� ����������
              WITH tmpPartner AS (SELECT inPartnerId AS PartnerId, inContractId AS ContractId, vbJuridicalId AS JuridicalId)
              INSERT INTO _tmpPriceList_onDate (PriceListId, DescId)
                 SELECT COALESCE (ObjectLink_Contract_PriceList.ChildObjectId
                                , zc_PriceList_Basis()) AS PriceListId
                      , COALESCE (ObjectLink_Contract_PriceList.DescId
                                , 0) AS DescId
                 FROM tmpPartner
                      LEFT JOIN ObjectLink AS ObjectLink_Contract_PriceList
                                           ON ObjectLink_Contract_PriceList.ObjectId = tmpPartner.ContractId
                                          AND ObjectLink_Contract_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
                                          AND ObjectLink_Contract_PriceList.ChildObjectId > 0
                 ;
          END IF;
          END IF;
          END IF;
      END IF;

      -- ���������
      RETURN QUERY
      SELECT tmpPriceList.PriceListId
           , Object_PriceList.ValueData           AS PriceListName
           , ObjectBoolean_PriceWithVAT.ValueData AS PriceWithVAT
           , ObjectFloat_VATPercent.ValueData     AS VATPercent
           , tmpPriceList.DescId
           , ObjectLinkDesc.Code
           , ObjectLinkDesc.ItemName
      FROM _tmpPriceList_onDate AS tmpPriceList
           LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = tmpPriceList.PriceListId
           LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceWithVAT
                                   ON ObjectBoolean_PriceWithVAT.ObjectId = Object_PriceList.Id
                                  AND ObjectBoolean_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()
           LEFT JOIN ObjectFloat AS ObjectFloat_VATPercent
                                 ON ObjectFloat_VATPercent.ObjectId = Object_PriceList.Id
                                AND ObjectFloat_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()
           LEFT JOIN ObjectLinkDesc ON ObjectLinkDesc.Id = tmpPriceList.DescId
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.06.15                                        *
*/

-- ����
-- SELECT * FROM lfGet_Object_Partner_PriceList_onDate (inContractId:= 347332, inPartnerId:= 348917, inMovementDescId:= zc_Movement_Sale(), inOperDate_order:= '05.05.2015', inOperDatePartner:= NULL, inIsPrior:= NULL)
